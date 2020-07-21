Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A1227ECE
	for <lists+live-patching@lfdr.de>; Tue, 21 Jul 2020 13:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgGUL1l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jul 2020 07:27:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:34304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgGUL1l (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jul 2020 07:27:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ABB26AB7D;
        Tue, 21 Jul 2020 11:27:46 +0000 (UTC)
Date:   Tue, 21 Jul 2020 13:27:39 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>, nstange@suse.de
Subject: Re: [PATCH] Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH
 is enabled"
In-Reply-To: <fc7d4932-a043-1adc-fd9b-96211c508f64@redhat.com>
Message-ID: <alpine.LSU.2.21.2007211322210.31851@pobox.suse.cz>
References: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com> <fc7d4932-a043-1adc-fd9b-96211c508f64@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, 19 Jul 2020, Joe Lawrence wrote:

> On 7/17/20 2:29 PM, Josh Poimboeuf wrote:
> > Use of the new -flive-patching flag was introduced with the following
> > commit:
> > 
> >    43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is
> >    enabled")
> > 
> > This flag has several drawbacks:
> > 
> > [ ... snip ... ]
> > 
> > - While there *is* a distro which relies on this flag for their distro
> >    livepatch module builds, there's not a publicly documented way to
> >    create safe livepatch modules with it.  Its use seems to be based on
> >    tribal knowledge.  It serves no benefit to those who don't know how to
> >    use it.
> > 
> >    (In fact, I believe the current livepatch documentation and samples
> >    are misleading and dangerous, and should be corrected.  Or at least
> >    amended with a disclaimer.  But I don't feel qualified to make such
> >    changes.)
> 
> FWIW, I'm not exactly qualified to document source-based creation either,
> however I have written a few of the samples and obviously the kselftest
> modules.
> 
> The samples should certainly include a disclaimer (ie, they are only for API
> demonstration purposes!) and eventually it would be great if the kselftest
> modules could guarantee their safety as well.  I don't know quite yet how we
> can automate that, but perhaps some kind of post-build sanity check could
> verify that they are in fact patching what they intend to patch.

That's a good idea. We should have something like that. I don't know how 
to make it nice. Just horrible post-build hacks that would check that 
modules were compiled as expected
 
> As for a more general, long-form warning about optimizations, I grabbed
> Miroslav's LPC slides from a few years back and poked around at some
> IPA-optimized disassembly... Here are my notes that attempt to capture some
> common cases:
> 
> http://file.bos.redhat.com/~jolawren/klp-compiler-notes/livepatch/compiler-considerations.html
> 
> It's not complete and I lost steam about 80% of the way through today. 
> :)  But if it looks useful enough to add to Documentation/livepatch, we 
> can work on it on-list and try to steer folks into using the automated
> kpatch-build, objtool (eventually) or a source-based safety checklist.

It looks really useful. Could you prepare a patch and submit it, please? 
We could discuss it there.

> The
> source-based steps have been posted on-list a few times, but I think it only
> needs to be formalized in a doc.

Yes, I think they were. We discussed it with Nicolai to (better) document 
our workflow. It is currently based on klp-ccp 
(https://github.com/SUSE/klp-ccp), but we need a proper documentation how 
to prepare a live patch starting with an ordinary patch.

Thanks
Miroslav
