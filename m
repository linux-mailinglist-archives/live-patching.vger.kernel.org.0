Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95BF19FD79
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2020 20:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDFSst (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Apr 2020 14:48:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38004 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgDFSsq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Apr 2020 14:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586198925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GBxc/UOt7N77hE2XxSjkwyDVeXjdx20svvUF7qLf7RU=;
        b=aCtMqABCMazhB3aYaWQ7SKi6++6yvXILouw2kRjKcQbEsLyZtCVifueu2K0/7rsmD6bFcO
        lfpJ/JflX5Sv1e+9Pb6CLROaSdF9FsAlfd8AThbBzhOaOF3UhesdCr/Ov+KBONJBBQAI7U
        KjgHeBg6LSepIKyMtscn5QS8QSBnAq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-u5wcsLN4OVyg__JkDyq_uQ-1; Mon, 06 Apr 2020 14:48:41 -0400
X-MC-Unique: u5wcsLN4OVyg__JkDyq_uQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6185800D4E;
        Mon,  6 Apr 2020 18:48:36 +0000 (UTC)
Received: from redhat.com (ovpn-112-68.phx2.redhat.com [10.3.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B04690CE0;
        Mon,  6 Apr 2020 18:48:35 +0000 (UTC)
Date:   Mon, 6 Apr 2020 14:48:33 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 19/23] module/livepatch: Allow to use exported symbols from
 livepatch module for "vmlinux"
Message-ID: <20200406184833.GA6023@redhat.com>
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-20-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117150323.21801-20-pmladek@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 17, 2020 at 04:03:19PM +0100, Petr Mladek wrote:
> HINT: Get some coffee before reading this commit message.
> 
>       Stop reading when it gets too complicated. It is possible that we
>       will need to resolve symbols from livepatch modules another way.
>       Livepatches need to access also non-exported symbols anyway.
> 
>       Or just ask me to explain the problem a better way. I have
>       ended in many cycles when thinking about it. And it might
>       be much easier from another point of view.
> 
> The split per-object livepatches brings even more types of module
> dependencies. Let's split them into few categories:
> 
> A. Livepatch module using an exported symbol from "vmlinux".
> 
>    It is quite common and works by definition. Livepatch module is just
>    a module from this point of view.
> 

Hi Petr,

If only all the cases were so easy :)

> B. Livepatch module using an exported symbol from the patched module.
> 
>    It should be avoided even with the non-split livepatch module. The module
>    loader automatically takes reference to make sure the modules are
>    unloaded in the right order. This would basically prevent the livepatched
>    module from unloading.
> 
>    Note that it would be perfectly safe to remove this automatic
>    dependency. The livepatch framework makes sure that the livepatch
>    module is loaded only when the patched one is loaded. But it cannot
>    be implemented easily, see below.

Do you envision klp-convert providing this functionality?

For reference, kpatch-build will take this example input patch:

  diff -U 15 -Nupr linux-3.10.0-1133.el7.x86_64.old/drivers/cdrom/cdrom.c linux-3.10.0-1133.el7.x86_64/drivers/cdrom/cdrom.c
  --- linux-3.10.0-1133.el7.x86_64.old/drivers/cdrom/cdrom.c      2020-04-06 11:58:34.470969120 -0400
  +++ linux-3.10.0-1133.el7.x86_64/drivers/cdrom/cdrom.c  2020-04-06 12:01:07.882719611 -0400
  @@ -1429,30 +1429,32 @@ unsigned int cdrom_check_events(struct c
   EXPORT_SYMBOL(cdrom_check_events);
  
   /* We want to make media_changed accessible to the user through an
    * ioctl. The main problem now is that we must double-buffer the
    * low-level implementation, to assure that the VFS and the user both
    * see a medium change once.
    */
  
   static
   int media_changed(struct cdrom_device_info *cdi, int queue)
   {
          unsigned int mask = (1 << (queue & 1));
          int ret = !!(cdi->mc_flags & mask);
          bool changed;
  
  +pr_info("%lx\n", (unsigned long) cdrom_check_events);
  +
          if (!CDROM_CAN(CDC_MEDIA_CHANGED))
                  return ret;
  
          /* changed since last call? */
          if (cdi->ops->check_events) {
                  BUG_ON(!queue); /* shouldn't be called from VFS path */
                  cdrom_update_events(cdi, DISK_EVENT_MEDIA_CHANGE);
                  changed = cdi->ioctl_events & DISK_EVENT_MEDIA_CHANGE;
                  cdi->ioctl_events = 0;
          } else
                  changed = cdi->ops->media_changed(cdi, CDSL_CURRENT);
  
          if (changed) {
                  cdi->mc_flags = 0x3;    /* set bit on both queues */
                  ret |= 1;

and you'll have the original cdrom.ko, owner of exported
cdrom_check_events, and a new livepatch-cdrom.ko that references it.
kpatch-build converts the symbol/rela combination like so:

  % readelf --wide --symbols livepatch-test.ko | grep cdrom_check_events
      79: 0000000000000000     0 FUNC    GLOBAL DEFAULT OS [0xff20] .klp.sym.cdrom.cdrom_check_events,0

  % readelf --wide --relocs livepatch-test.ko | awk '/cdrom_check_events/' RS="\n\n" ORS="\n\n"
  Relocation section '.klp.rela.cdrom..text.media_changed' at offset 0x97fc0 contains 1 entries:
      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
  0000000000000016  0000004f0000000b R_X86_64_32S           0000000000000000 .klp.sym.cdrom.cdrom_check_events,0 + 0

That dodges the implicit module reference on cdrom.ko, but would it
still be safe in this klp-split POC?

FWIW, I have been working an updated klp-convert for v5.6 that includes
a bunch of fixes and such... modifying it to convert module-export
references like this was quite easy.

> C. Livepatch module using an exported symbol from the main livepatch module
>    for "vmlinux".
> 
>    It is the 2nd most realistic variant. It even exists in current
>    selftests. Namely, test_klp_callback_demo* modules share
>    the implementation of callbacks. It avoids code duplication.
>    And it is actually needed to make module parameters working.

I had to double check this and the exports were introduced by this POC
just to avoid code duplication, right?  If so, would it be worth the
extra code to avoid providing bad example usage?  Or at least do so for
sample/livepatch/ and not selftests.

>    Note that the current implementation allows to pass module parameters
>    only to the main livepatch module for "vmlinux". It should not be a real
>    life problem. The parameters are used in selftests. But they are
>    not used in practice.

Yeah, we don't use module parameters for kpatch either, AFAIK they are
only useful as a quick and easy method to poke those selftests.

On a related note, one possible work around for case C is to use shadow
variables created by the main livepatch module to store symbol
locations or the values themselves.  This might get tedious for real
kernel API, but has been reasonable for livepatch bookkeeping states,
counts, etc.

> D. Livepatch modules might depend on each other. Note that dependency on
>    the main livepatch module for "vmlinux" has got a separate category 'C'.
> 
>    The dependencies between modules are quite rare. But they exist.
>    One can assume that this might be useful also on the livepatching
>    level.
> 
>    To keep it sane, the livepatch modules should just follow
>    the dependencies of the related patched modules. By other words,
>    the livepatch modules might or should have the same dependencies
>    as the patched counter parts but nothing more.
> 

I agree, I think this is the only sane way to approach case D.

> Do these dependencies need some special handling?
> 
> [ ... snip ... ]
> 

This is the multiple-coffee cup section that I'm still trying to wrap my
brain around.

In the meantime, could we simplify or avoid any of these by enforcing
things on the build side?  I don't know if these are even detectable,
but perhaps we could prevent them from even occuring.  /shrugs

-- Joe

