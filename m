Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638B1175880
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2020 11:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCBKgw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Mon, 2 Mar 2020 05:36:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:42344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgCBKgv (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Mar 2020 05:36:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72D6CAC37;
        Mon,  2 Mar 2020 10:36:49 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     jpoimboe@redhat.com, live-patching@vger.kernel.org
Subject: Re: [help] Confusion on livepatch's per-task consistency model
References: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
Date:   Mon, 02 Mar 2020 11:36:48 +0100
In-Reply-To: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
        (jefflexu@linux.alibaba.com's message of "Mon, 2 Mar 2020 16:45:24
        +0800")
Message-ID: <87mu8z6o1r.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

JeffleXu <jefflexu@linux.alibaba.com> writes:

> According to the model, there will be scenario where old function and new
>
> function can co-exist, though for a single thread, it sees either all new
>
> functions or all old functions.

That's correct.


> I can't understand why Vojtech said that 'old func processing new
> data' was impossible.

Just to make it explicit: Vojtech was talking about data layout
changes.

That is, consider you have something like e.g. this in the unmodified
kernel sources:

struct my_driver_work
{
	struct work_struct work;
        struct list_head works_list;
        void *some_payload;
};

In general, you can't change that struct definition from a live
patch. So simply extending it like this

struct my_driver_work
{
	struct work_struct work;
        struct list_head works_list;
        unsigned long flags /* New */
        void *some_payload;
};

won't work.


> Assuming a scenario where a process calls func-A to submit a
>
> work request (inserted into a global list), and then a kthread is
> responsible
>
> for calling func-B to process all work requests in the list. What if
> this process
>
> has finished the transition (sees new func-A) while kthread still sees
> the old func-B?

Going with the example from above, the patched func-A would submit
instances of the new struct my_driver_work whereas the unpatched func-B
would expect the ->some_payload pointer at where ->flags is stored now,
which is bad, obviously.

In this specific example, it could perhaps be possible to make the
patched func-A associate a shadow variable corresponding to the new
->flags member with newly created struct my_driver_work instances (of
original, unmodified layout). Any unpatched func-B would obviously
ignore it and consider the shadow only when it becomes patched. It very
much depends on the specific situation whether or not this is
acceptable. If not, the ->post_patch() can sometimes be used to achieve
some notion of a "global consistency" state (in this context,
c.f. Documentation/livepatch/system-state.rst).

Note however, that the patched func-B must always be able to handle
the situation where a struct my_driver_work instance does not have such
a ->flags shadow attached to it, either because the instance had been
created  when the live patch has not been applied at all or because it
has been submitted from a not yet transitioned func-A.

There's another subtlety: the deallocation code for struct
my_driver_work needs to get livepatched as well to make it free the
->flags shadow. Consider the case where func-A has been transitioned,
but the deallocation code hasn't yet. Without any extra measures in
func-A, it could happen that a stale ->flags shadow from a deallocated
struct my_driver_work gets (wrongly) reassociated with a fresh struct
my_driver_work instance allocated at the same address as the old one
(because shadow variables are keyed on addresses of the data they're
associated with). Sometimes that's acceptable, sometimes it's not. In
the latter case you probably had to check for this situation and work
around it in the allocation code, i.e. the live-patched func-A.

Finally, let me remark that from my experience, most CVEs (>95%) can be
fixed via live patching without having to resort to either of shadow
variables, callbacks or the state API. For the rest, things usually tend
to become really non-trivial, hackish and subtle.


> In this case, old func-B has to process new data. If there's some lock
> semantic
>
> changes in func-A and func-B, then old func-B has no way identifying
> the shadow
>
> variable labeled by new func-A.

I don't understand what you mean by "variable labeled by new func-A"?
Anyway, it's correct that an unpatched func-B would not consider any
shadow variables instantiated by patched func-A. And it's also correct
that changing locking semantics is difficult, if not impossible.

Thanks,

Nicolai

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
