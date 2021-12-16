Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44F4774BD
	for <lists+live-patching@lfdr.de>; Thu, 16 Dec 2021 15:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhLPOgo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Dec 2021 09:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237937AbhLPOfu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Dec 2021 09:35:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F58C061574;
        Thu, 16 Dec 2021 06:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CFF4ECE21A0;
        Thu, 16 Dec 2021 14:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249CFC36AE0;
        Thu, 16 Dec 2021 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639665345;
        bh=wO21BSlgQFmZUxxELoB68qEmtpd++swY+umlW7ahpPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2XZXsQ66LnDs/NPcO36jGzszTaO0dXULmG7iWEpqoC11YxmfiSCsfLc0rwGcZdCZC
         yZKFg9OBBN4ZjhIu8O9dTWx+ZDloICXyPp3E12M9Irl6bZ5Fqm33+n9yf3S3FHsjLG
         tvb84Miz8DVMPRFw5B9f17PhiN7/wLEv0HVG9LkE=
Date:   Thu, 16 Dec 2021 15:35:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     David Vernet <void@manifault.com>, Miroslav Benes <mbenes@suse.cz>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com, corbet@lwn.net,
        yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbtOvpMswhIJ8a3s@kroah.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
 <YbmlL0ZyfSuek9OB@alley>
 <YboLPAmOc8/6khu2@kroah.com>
 <YbtJzonSJjcUaUwh@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbtJzonSJjcUaUwh@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Dec 16, 2021 at 03:14:38PM +0100, Petr Mladek wrote:
> On Wed 2021-12-15 16:35:24, Greg Kroah-Hartman wrote:
> > On Wed, Dec 15, 2021 at 09:19:59AM +0100, Petr Mladek wrote:
> > > On Tue 2021-12-14 16:50:15, Greg Kroah-Hartman wrote:
> > > > 
> > > > kobject_init() does allocate things internally, where does it say it
> > > > does not?  What is trying to be "fixed" here?
> > > 
> > > Could you please show where things are allocated in kobject_init()?
> > > I do not see it in the code!
> > > 
> > > It looks to me like a cargo cult claim to me.
> > 
> > Hm, I thought I saw it yesterday when I reviewed the code.  Let me look
> > again...
> > 
> > > Documentation/core-api/kobject.rst says:
> > > 
> > >    Once you registered your kobject via kobject_add(), you must never use
> > >    kfree() to free it directly. The only safe way is to use kobject_put().
> > > 
> > > kobject_add() makes perfect sense because it copies the name, takes
> > > reference to the parent, etc.
> > > 
> > > kobject_init() just initializes the structure members and nothing else.
> > 
> > Now it does.  In the past, I think we did create some memory.  I know
> > when we hook debugobjects up to kobjects (there's an external patch for
> > that floating around somewhere), that is one reason to keep the
> > kobject_put() rule, and there might have been other reasons in the past
> > 20+ years as well.
> > 
> > So yes, while you are correct today, the "normal" reference counted
> > object model patern is "after the object is initialized, it MUST only be
> > freed by handling its reference count."  So let's stick to that rule for
> > now.
> 
> Good point.
> 
> 
> > If you want, I can put some code in the kobject_init() logic to force
> > this to be the case if it bothers you :)
> 
> I actually know about one case where this might be very useful.
> 
> There is the problem with kobject lifetime and module removal.
> module is removed after mod->exit() callback finishes. But some
> kobject release() callbacks might be delayed, especillay when
> CONFIG_DEBUG_KOBJECT_RELEASE is enabled.

Ick, modules and kobjects, just say no :)

> I have proposed there a solution where kobject_add_internal() takes reference
> on the module. It would make sure that the module will stay in the
> memory until the release callbacks is called, see
> https://lore.kernel.org/all/Ya84O2%2FnYCyNb%2Ffp@alley/

I don't want to add module pointers to kobjects.

kobjects are data.  modules are code.  Module references control code
lifespans.  Kobject references control data lifespans.  They are
different, so let us never mix the two please.

Yes, release callbacks are code, but if you really need to worry about
your release callback being unloaded, then just refuse to unload your
module until your data is all released!

The huge majority of kobject users never touch them directly, they use
the driver model, which should not have this issue.  Only code that
wants to touch kobjects in the "raw" have problems like this, and if you
want to mess with them at that level, you can handle the release data
issue.

Then there's the issue of static kobjects that are defined in code
(modules), but are treated as a reference count of data.  ick...

thanks,

greg k-h
