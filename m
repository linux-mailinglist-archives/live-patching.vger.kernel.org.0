Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58F027FF65
	for <lists+live-patching@lfdr.de>; Thu,  1 Oct 2020 14:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbgJAMoA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Thu, 1 Oct 2020 08:44:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:54366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbgJAMoA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Oct 2020 08:44:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95C68AD85;
        Thu,  1 Oct 2020 12:43:59 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        pmladek@suse.com, nstange@suse.de
Subject: Re: Patching kthread functions
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
        <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
Date:   Thu, 01 Oct 2020 14:43:58 +0200
In-Reply-To: <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz> (Miroslav
        Benes's message of "Thu, 1 Oct 2020 13:13:07 +0200 (CEST)")
Message-ID: <87lfgqt8tt.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Miroslav Benes <mbenes@suse.cz> writes:

> On Wed, 30 Sep 2020, Evgenii Shatokhin wrote:

>> Is that so? Are there any workarounds?
>
> Petr, do you remember the crazy workarounds we talked about? My head is 
> empty now. And I am sure, Nicolai could come up with something.

There might be some clever tricks ycou could play, but that depends on
the diff you want to turn into a livepatch. For example, sometimes it's
possible to livepatch a callee and make it trick the unpatchable caller
into the desired behaviour.

However, in your case it might be easier to simply kill the running
kthread and start it again, e.g. from a ->post_patch() callback. Note
that KLP's callbacks are a bit subtle though, at a minimum you'd
probably also want to implement ->pre_unpatch() to roll everything back
and perhaps also disable (->replace) downgrades by means of the klp_state API.

You can find some good docs on callbacks and klp_state at
Documentation/livepatch/.

Thanks,

Nicolai

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
