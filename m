Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62A247CFE0
	for <lists+live-patching@lfdr.de>; Wed, 22 Dec 2021 11:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbhLVKWe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 05:22:34 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:33738 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbhLVKWb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 05:22:31 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4DAEA210F7;
        Wed, 22 Dec 2021 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640168550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TbGmZ584pJp0t74feg81gpCTEFAzks8jUbA4KgFmdoY=;
        b=PJu4FzmjQ64w3ZFD9FnVTJ7X4czGY1qbdNPCNWA7NW25ZnwC27E1crYBvxzKQ6HMYg6iHp
        EBGnJoWxLSQtvHIPorObLi4wH2esYwF3Njxf4PGJR2vy2N2ps/OG8XtT+eQvrraAPZVzQY
        efMt9WzH0W1xHt3DNRBYErlzVCkj7rk=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 18333A3B81;
        Wed, 22 Dec 2021 10:22:30 +0000 (UTC)
Date:   Wed, 22 Dec 2021 11:22:29 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v3] livepatch: Fix kobject refcount bug on
 klp_init_patch_early failure path
Message-ID: <YcL8ZTXyAI8NW+un@alley>
References: <20211221153930.137579-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221153930.137579-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-12-21 07:39:31, David Vernet wrote:
> When enabling a klp patch with klp_enable_patch(), klp_init_patch_early()
> is invoked to initialize the kobjects for the patch itself, as well as the
> 'struct klp_object' and 'struct klp_func' objects that comprise it.
> However, there are some error paths in klp_enable_patch() where some
> kobjects may have been initialized with kobject_init(), but an error code
> is still returned due to e.g. a 'struct klp_object' having a NULL funcs
> pointer.
> 
> In these paths, the initial reference of the kobject of the 'struct
> klp_patch' may never be released, along with one or more of its objects and
> their functions, as kobject_put() is not invoked on the cleanup path if
> klp_init_patch_early() returns an error code.
> 
> For example, if an object entry such as the following were added to the
> sample livepatch module's klp patch, it would cause the vmlinux klp_object,
> and its klp_func which updates 'cmdline_proc_show', to never be released:
> 
> static struct klp_object objs[] = {
> 	{
> 		/* name being NULL means vmlinux */
> 		.funcs = funcs,
> 	},
> 	{
> 		/* NULL funcs -- would cause reference leak */
> 		.name = "kvm",
> 	}, { }
> };
> 
> Without this change, if CONFIG_DEBUG_KOBJECT is enabled, and the sample klp
> patch is loaded, the kobjects (the patch, the vmlinux 'struct klp_object',
> and its func) are observed as initialized, but never released, in the dmesg
> log output.  With the change, these kobject references no longer fail to be
> released as the error case is properly handled before they are initialized.
> 
> Signed-off-by: David Vernet <void@manifault.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
