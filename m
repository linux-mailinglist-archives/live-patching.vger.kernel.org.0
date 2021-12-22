Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE547D319
	for <lists+live-patching@lfdr.de>; Wed, 22 Dec 2021 14:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245437AbhLVNkU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 08:40:20 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:48696 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245436AbhLVNkU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 08:40:20 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 63CBA21138;
        Wed, 22 Dec 2021 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640180419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eTaxaFkbJsGD0UKpX1p5LowYqe85cdydNwhkvZF77V8=;
        b=sEywVZzT+0QPJXhMV1oPnePsrdrO/hUCNkwnULQvbgoGGxE8mYVz26k92Gu7Axm/dIpxoQ
        hWDX/Q1z//2ej5Wq6ZqkhJd4W13nUyPdsJBe8q2voRVxYnag91wP2sggdkrG5oX8ppBXHc
        qEvsyiekfZEP0UO9liNLDLOoCz0mSY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640180419;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eTaxaFkbJsGD0UKpX1p5LowYqe85cdydNwhkvZF77V8=;
        b=DAVGc4PDBd0W8s2QT8UxxYbxR9r7BzPpfcufAu3K4EtDVb2c6aZMWAuNCCPjbmAlU3EJ/X
        IePlL/w3m1Zqq1Ag==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 33678A3B81;
        Wed, 22 Dec 2021 13:40:19 +0000 (UTC)
Date:   Wed, 22 Dec 2021 14:40:19 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     David Vernet <void@manifault.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v3] livepatch: Fix kobject refcount bug on klp_init_patch_early
 failure path
In-Reply-To: <20211221153930.137579-1-void@manifault.com>
Message-ID: <alpine.LSU.2.21.2112221439520.18494@pobox.suse.cz>
References: <20211221153930.137579-1-void@manifault.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 21 Dec 2021, David Vernet wrote:

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

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
