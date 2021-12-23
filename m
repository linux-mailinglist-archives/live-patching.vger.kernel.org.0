Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66F47DC4A
	for <lists+live-patching@lfdr.de>; Thu, 23 Dec 2021 01:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhLWAmr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 19:42:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235461AbhLWAmr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 19:42:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640220166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7Oy6iCSZJJW8lTBkEZWPZ+i3wkBqq3QgTivZq9ltkY=;
        b=MM9NeHxuInksUmQQOBtqSTEBhQtqjdFPsXmE/df0VdgO8bIpHXRM0z+0tCz5KtELiEiVEQ
        95ojNJs64RnsVylSfgFroyFLBhqTbUE2lLnafjpzv1Q1FSONhoGVTOFcCq7UZ/64n0wWkE
        44A8UXccYnO78LB4haf0OkTNpaDx4ug=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-CFXQLiTKOfaGExxWQ_xFGw-1; Wed, 22 Dec 2021 19:42:45 -0500
X-MC-Unique: CFXQLiTKOfaGExxWQ_xFGw-1
Received: by mail-ot1-f72.google.com with SMTP id 66-20020a9d0c48000000b0058f58571e0fso40251otr.23
        for <live-patching@vger.kernel.org>; Wed, 22 Dec 2021 16:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E7Oy6iCSZJJW8lTBkEZWPZ+i3wkBqq3QgTivZq9ltkY=;
        b=Hr7Rq+qpEN0/uS4PYCz+TZTU2oXU2L1b+bjbjkuUAF+534N8Hii0K5ln6da0aqcILP
         7y39LmlvixQeE2OLlRB96GwhqorqcYLQfOk426U8y139yWaVIVV2blKazd5XuVFZ9OLX
         yd7Mx/Mocqzom07JGst1Vffy1xq9pBPqL7M0QFPz1DC9+YNpUA5F1Mu3kVH2Gk9vtrOP
         nBIlJt41qi8Pa6lCYB0pVHZ+3llIoLheOQ785IFnEoRoEFQJrRuJMoSBEPjD7OSOMheP
         qn+XJSkuiKrTlu1iXrgP0OiQErY731C/8PxYIypNWCCd84inFqJiJFTL6pHjeHury+n7
         5Y6Q==
X-Gm-Message-State: AOAM532jB55wXxK7P6bgmeCmlhKH1UIW5JYLbT8o59LhlinI8b33L/KK
        C482Rh/6cgmgk/btpaxcqUGnxprf8D/NjqvY994UVFpzAtKg/5a0fFyZx3jlq7U1uFIIku/ZN40
        nTvL+5xTveZkeRSHpS80W4ZnnoQ==
X-Received: by 2002:a54:470f:: with SMTP id k15mr60144oik.92.1640220164743;
        Wed, 22 Dec 2021 16:42:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmeT/M9BiyPn2ri4zzJLa19R0qkgWAVHjSJ4zSvj08GjU0PsiTvge1ijDAeDnTdnxbAKY40Q==
X-Received: by 2002:a54:470f:: with SMTP id k15mr60137oik.92.1640220164471;
        Wed, 22 Dec 2021 16:42:44 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::c])
        by smtp.gmail.com with ESMTPSA id s6sm744371ois.3.2021.12.22.16.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 16:42:44 -0800 (PST)
Date:   Wed, 22 Dec 2021 16:42:41 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v3] livepatch: Fix kobject refcount bug on
 klp_init_patch_early failure path
Message-ID: <20211223004241.zvv4ymjmcmimumra@treble>
References: <20211221153930.137579-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211221153930.137579-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Dec 21, 2021 at 07:39:31AM -0800, David Vernet wrote:
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
> ---
> v3:
>   - Update patch description to not specifically claim to be fixing a
>     "leak", but rather a kobject reference counting bug.
>   - Make klp_init_patch_early() void to match klp_init_object_early() and
>     klp_init_func_early(), and move the arg validation that previously
>     resided there into klp_enable_patch() (where other argument validation
>     logic already resides).

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh

