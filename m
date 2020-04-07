Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C7E1A0859
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2020 09:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDGHdN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Apr 2020 03:33:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:52638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgDGHdN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Apr 2020 03:33:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52892AC84;
        Tue,  7 Apr 2020 07:33:09 +0000 (UTC)
Date:   Tue, 7 Apr 2020 09:33:08 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 19/23] module/livepatch: Allow to use exported symbols from
 livepatch module for "vmlinux"
In-Reply-To: <20200406184833.GA6023@redhat.com>
Message-ID: <alpine.LSU.2.21.2004070915040.1817@pobox.suse.cz>
References: <20200117150323.21801-1-pmladek@suse.com> <20200117150323.21801-20-pmladek@suse.com> <20200406184833.GA6023@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 6 Apr 2020, Joe Lawrence wrote:

> On Fri, Jan 17, 2020 at 04:03:19PM +0100, Petr Mladek wrote:
> > HINT: Get some coffee before reading this commit message.
> > 
> >       Stop reading when it gets too complicated. It is possible that we
> >       will need to resolve symbols from livepatch modules another way.
> >       Livepatches need to access also non-exported symbols anyway.
> > 
> >       Or just ask me to explain the problem a better way. I have
> >       ended in many cycles when thinking about it. And it might
> >       be much easier from another point of view.
> > 
> > The split per-object livepatches brings even more types of module
> > dependencies. Let's split them into few categories:
> > 
> > A. Livepatch module using an exported symbol from "vmlinux".
> > 
> >    It is quite common and works by definition. Livepatch module is just
> >    a module from this point of view.
> > 
> 
> Hi Petr,
> 
> If only all the cases were so easy :)
> 
> > B. Livepatch module using an exported symbol from the patched module.
> > 
> >    It should be avoided even with the non-split livepatch module. The module
> >    loader automatically takes reference to make sure the modules are
> >    unloaded in the right order. This would basically prevent the livepatched
> >    module from unloading.
> > 
> >    Note that it would be perfectly safe to remove this automatic
> >    dependency. The livepatch framework makes sure that the livepatch
> >    module is loaded only when the patched one is loaded. But it cannot
> >    be implemented easily, see below.
> 
> Do you envision klp-convert providing this functionality?
> 
> For reference, kpatch-build will take this example input patch:
> 
>   diff -U 15 -Nupr linux-3.10.0-1133.el7.x86_64.old/drivers/cdrom/cdrom.c linux-3.10.0-1133.el7.x86_64/drivers/cdrom/cdrom.c
>   --- linux-3.10.0-1133.el7.x86_64.old/drivers/cdrom/cdrom.c      2020-04-06 11:58:34.470969120 -0400
>   +++ linux-3.10.0-1133.el7.x86_64/drivers/cdrom/cdrom.c  2020-04-06 12:01:07.882719611 -0400
>   @@ -1429,30 +1429,32 @@ unsigned int cdrom_check_events(struct c
>    EXPORT_SYMBOL(cdrom_check_events);
>   
>    /* We want to make media_changed accessible to the user through an
>     * ioctl. The main problem now is that we must double-buffer the
>     * low-level implementation, to assure that the VFS and the user both
>     * see a medium change once.
>     */
>   
>    static
>    int media_changed(struct cdrom_device_info *cdi, int queue)
>    {
>           unsigned int mask = (1 << (queue & 1));
>           int ret = !!(cdi->mc_flags & mask);
>           bool changed;
>   
>   +pr_info("%lx\n", (unsigned long) cdrom_check_events);
>   +
>           if (!CDROM_CAN(CDC_MEDIA_CHANGED))
>                   return ret;
>   
>           /* changed since last call? */
>           if (cdi->ops->check_events) {
>                   BUG_ON(!queue); /* shouldn't be called from VFS path */
>                   cdrom_update_events(cdi, DISK_EVENT_MEDIA_CHANGE);
>                   changed = cdi->ioctl_events & DISK_EVENT_MEDIA_CHANGE;
>                   cdi->ioctl_events = 0;
>           } else
>                   changed = cdi->ops->media_changed(cdi, CDSL_CURRENT);
>   
>           if (changed) {
>                   cdi->mc_flags = 0x3;    /* set bit on both queues */
>                   ret |= 1;
> 
> and you'll have the original cdrom.ko, owner of exported
> cdrom_check_events, and a new livepatch-cdrom.ko that references it.
> kpatch-build converts the symbol/rela combination like so:
> 
>   % readelf --wide --symbols livepatch-test.ko | grep cdrom_check_events
>       79: 0000000000000000     0 FUNC    GLOBAL DEFAULT OS [0xff20] .klp.sym.cdrom.cdrom_check_events,0
> 
>   % readelf --wide --relocs livepatch-test.ko | awk '/cdrom_check_events/' RS="\n\n" ORS="\n\n"
>   Relocation section '.klp.rela.cdrom..text.media_changed' at offset 0x97fc0 contains 1 entries:
>       Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
>   0000000000000016  0000004f0000000b R_X86_64_32S           0000000000000000 .klp.sym.cdrom.cdrom_check_events,0 + 0
> 
> That dodges the implicit module reference on cdrom.ko, but would it
> still be safe in this klp-split POC?

That is one way to get around the dependency problem. And I think it 
should work even with the PoC. It should (and I don't remember all details 
now unfortunately) guarantee that the patched module is always available 
for the livepatch and since there is no explicit dependency, the recursion 
issue is gone.

However, I think the goal was to follow the most natural road and leverage 
the existing dependency system. Meaning, since the presence of a patched 
module in the system before its patching is guaranteed now, there is no 
reason not to use its exported symbols directly like anywhere else. But it 
introduces the recursion problem, so we may drop it.

> FWIW, I have been working an updated klp-convert for v5.6 that includes
> a bunch of fixes and such... modifying it to convert module-export
> references like this was quite easy.

*THUMBS UP* :)

> > C. Livepatch module using an exported symbol from the main livepatch module
> >    for "vmlinux".
> > 
> >    It is the 2nd most realistic variant. It even exists in current
> >    selftests. Namely, test_klp_callback_demo* modules share
> >    the implementation of callbacks. It avoids code duplication.
> >    And it is actually needed to make module parameters working.
> 
> I had to double check this and the exports were introduced by this POC
> just to avoid code duplication, right?  If so, would it be worth the
> extra code to avoid providing bad example usage?  Or at least do so for
> sample/livepatch/ and not selftests.

I agree.

This case sounds a bit quirky to me.

> >    Note that the current implementation allows to pass module parameters
> >    only to the main livepatch module for "vmlinux". It should not be a real
> >    life problem. The parameters are used in selftests. But they are
> >    not used in practice.
> 
> Yeah, we don't use module parameters for kpatch either, AFAIK they are
> only useful as a quick and easy method to poke those selftests.
> 
> On a related note, one possible work around for case C is to use shadow
> variables created by the main livepatch module to store symbol
> locations or the values themselves.  This might get tedious for real
> kernel API, but has been reasonable for livepatch bookkeeping states,
> counts, etc.
> 
> > D. Livepatch modules might depend on each other. Note that dependency on
> >    the main livepatch module for "vmlinux" has got a separate category 'C'.
> > 
> >    The dependencies between modules are quite rare. But they exist.
> >    One can assume that this might be useful also on the livepatching
> >    level.
> > 
> >    To keep it sane, the livepatch modules should just follow
> >    the dependencies of the related patched modules. By other words,
> >    the livepatch modules might or should have the same dependencies
> >    as the patched counter parts but nothing more.
> > 
> 
> I agree, I think this is the only sane way to approach case D.
> 
> > Do these dependencies need some special handling?
> > 
> > [ ... snip ... ]
> > 
> 
> This is the multiple-coffee cup section that I'm still trying to wrap my
> brain around.

Yes, I really need to go through the patch set once again and try to 
digest it.

Miroslav
