Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7A147E20F
	for <lists+live-patching@lfdr.de>; Thu, 23 Dec 2021 12:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhLWLJl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Dec 2021 06:09:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59986 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347946AbhLWLJk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Dec 2021 06:09:40 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3C16421128;
        Thu, 23 Dec 2021 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640257779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YQwOF51/ddrC+PGLJQ6ibBPelfdbg+diFpEqHzAU84k=;
        b=SnrCdIqNWBizX/YHg9M3ey+na2DyWTsOBHK4eSkey3UjsQb3na37ZURmCjcc9oCCy0/JkI
        gmfGMuNbpOpv3NIQ4p7tFjz6R1bySDAb1mV1W+2GDzcmXns1FmX8JCo3/3HVtWRqzdKzC2
        RHDzRB5kQ0NSS8KD2NAg+loAyR3LfrM=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1FB20A3B89;
        Thu, 23 Dec 2021 11:09:39 +0000 (UTC)
Date:   Thu, 23 Dec 2021 12:09:35 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v3] livepatch: Fix kobject refcount bug on
 klp_init_patch_early failure path
Message-ID: <YcRY723YKJmnMtGl@alley>
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

JFYI, the patch has been committed into livepatch.git, branch
for-5.17/fixes.

Best Regards,
Petr
