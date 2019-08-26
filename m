Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296229D0D3
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2019 15:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbfHZNoY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 26 Aug 2019 09:44:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:43280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728749AbfHZNoY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 26 Aug 2019 09:44:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBD1BAD08;
        Mon, 26 Aug 2019 13:44:21 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module removal
References: <20190719122840.15353-1-mbenes@suse.cz>
        <20190719122840.15353-3-mbenes@suse.cz>
        <20190728200427.dbrojgu7hafphia7@treble>
        <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
        <20190814151244.5xoaxib5iya2qjco@treble>
Date:   Mon, 26 Aug 2019 15:44:21 +0200
In-Reply-To: <20190814151244.5xoaxib5iya2qjco@treble> (Josh Poimboeuf's
        message of "Wed, 14 Aug 2019 10:12:44 -0500")
Message-ID: <878srgkpmy.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh Poimboeuf <jpoimboe@redhat.com> writes:

> On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
>> > Really, we should be going in the opposite direction, by creating module
>> > dependencies, like all other kernel modules do, ensuring that a module
>> > is loaded *before* we patch it.  That would also eliminate this bug.
>> 
>> Yes, but it is not ideal either with cumulative one-fixes-all patch 
>> modules. It would load also modules which are not necessary for a 
>> customer and I know that at least some customers care about this. They 
>> want to deploy only things which are crucial for their systems.

Security concerns set aside, some of the patched modules might get
distributed separately from the main kernel through some sort of
kernel-*-extra packages and thus, not be found on some target system
at all. Or they might have been blacklisted.


> If you frame the question as "do you want to destabilize the live
> patching infrastucture" then the answer might be different.
>
> We should look at whether it makes sense to destabilize live patching
> for everybody, for a small minority of people who care about a small
> minority of edge cases.
>
> Or maybe there's some other solution we haven't thought about, which
> fits more in the framework of how kernel modules already work.
>
>> We could split patch modules as you proposed in the past, but that have 
>> issues as well.
>
> Right, I'm not really crazy about that solution either.
>
> Here's another idea: per-object patch modules.  Patches to vmlinux are
> in a vmlinux patch module.  Patches to kvm.ko are in a kvm patch module.
> That would require:
>
> - Careful management of dependencies between object-specific patches.
>   Maybe that just means that exported function ABIs shouldn't change.
>
> - Some kind of hooking into modprobe to ensure the patch module gets
>   loaded with the real one.
>
> - Changing 'atomic replace' to allow patch modules to be per-object.
>

Perhaps I'm misunderstanding, but supporting only per-object livepatch
modules would make livepatch creation for something like commit
15fab63e1e57 ("fs: prevent page refcount overflow in pipe_buf_get"),
CVE-2019-11487 really cumbersome (see the fuse part)?

I think I've seen similar interdependencies between e.g. kvm.ko <->
kvm_intel.ko, but can't find an example right now.


Thanks,

Nicolai

--
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 247165, AG München), GF: Felix Imendörffer
