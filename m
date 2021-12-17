Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08765478C03
	for <lists+live-patching@lfdr.de>; Fri, 17 Dec 2021 14:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbhLQNKV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Dec 2021 08:10:21 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56144 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbhLQNKU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Dec 2021 08:10:20 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6B7261F38B;
        Fri, 17 Dec 2021 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639746619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gvrw1JzGIY+F9u/2nVJ84UxXgKYo/5jNLHymVmDINqY=;
        b=pepWBIaaFYuxswkaNq/H/QgOeh9t4baOnVp+L+qbk7MTs4mMI1iMA0IFTEv+6M0SFpo+MI
        8EP7mmAHu8jqHRaQgSbea+MX7PiWYcJr01aq2kslSJPrjTPKbomqW7lQTUzmg5gfpWapOb
        d2/JrQ2opXOwoquhiImBKrc2wkuQDX8=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1AED6A3B8B;
        Fri, 17 Dec 2021 13:10:19 +0000 (UTC)
Date:   Fri, 17 Dec 2021 14:10:18 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Vernet <void@manifault.com>, Miroslav Benes <mbenes@suse.cz>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com, corbet@lwn.net,
        yhs@fb.com, songliubraving@fb.com, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbyMOvBEj9Oj3hkf@alley>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
 <YbmlL0ZyfSuek9OB@alley>
 <YboLPAmOc8/6khu2@kroah.com>
 <YbtJzonSJjcUaUwh@alley>
 <YbtOvpMswhIJ8a3s@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbtOvpMswhIJ8a3s@kroah.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-12-16 15:35:42, Greg Kroah-Hartman wrote:
> On Thu, Dec 16, 2021 at 03:14:38PM +0100, Petr Mladek wrote:
> > There is the problem with kobject lifetime and module removal.
> > module is removed after mod->exit() callback finishes. But some
> > kobject release() callbacks might be delayed, especillay when
> > CONFIG_DEBUG_KOBJECT_RELEASE is enabled.
> 
> Ick, modules and kobjects, just say no :)

I will try to persuade you that it is not that uncommon scenario,
see below.


> > I have proposed there a solution where kobject_add_internal() takes reference
> > on the module. It would make sure that the module will stay in the
> > memory until the release callbacks is called, see
> > https://lore.kernel.org/all/Ya84O2%2FnYCyNb%2Ffp@alley/
> 
> I don't want to add module pointers to kobjects.
> 
> kobjects are data.  modules are code.  Module references control code
> lifespans.  Kobject references control data lifespans.  They are
> different, so let us never mix the two please.

I do not undestand this argument. The data are useless without the
code. The code is needed to remove the data. Therefore the code should
stay until the data are released.

I am talking about data using statically defined kobj_type in modules.


> Yes, release callbacks are code, but if you really need to worry about
> your release callback being unloaded, then just refuse to unload your
> module until your data is all released!

This is exactly what I am proposing. If the kobject release callbacks
are defined in the module then the module should stay as long as
they are needed.


> The huge majority of kobject users never touch them directly, they use
> the driver model, which should not have this issue.  Only code that
> wants to touch kobjects in the "raw" have problems like this, and if you
> want to mess with them at that level, you can handle the release data
> issue.

There seems to be 14 simple modules that define static strcut
kobj_type:

$> for file in `git grep "static struct kobj_type" | cut -d : -f1 | sort -u` ; \
       do grep -q "module_init" $file && echo $file ; \
   done
arch/sh/kernel/cpu/sh4/sq.c
drivers/block/pktcdvd.c
drivers/firmware/dmi-sysfs.c
drivers/firmware/efi/efivars.c
drivers/firmware/qemu_fw_cfg.c
drivers/net/bonding/bond_main.c
drivers/net/ethernet/ibm/ibmveth.c
drivers/parisc/pdc_stable.c
drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
drivers/platform/x86/intel/uncore-frequency.c
drivers/platform/x86/uv_sysfs.c
drivers/uio/uio.c
kernel/livepatch/core.c
samples/kobject/kset-example.c


The other struct kobj_type are fined in 81 source files:

$> for file in `git grep "static struct kobj_type" | cut -d : -f1 | sort -u` ;  \
      do grep -q "module_init" $file || echo $file ; \
   done | wc -l
81


I believe that most of them might be compiled as modules as well.
There are many non-trivial drivers and file systes. From just a quick
look:

drivers/infiniband/hw/mlx4/sysfs.c
fs/btrfs/sysfs.c
fs/ext4/sysfs.c


Well, we should probably discuss this in the original thread
https://lore.kernel.org/r/20211129034509.2646872-3-ming.lei@redhat.com

Best Regards,
Petr
