Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86730D7A5
	for <lists+live-patching@lfdr.de>; Wed,  3 Feb 2021 11:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhBCKfq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Feb 2021 05:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbhBCKff (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Feb 2021 05:35:35 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EF1C061573
        for <live-patching@vger.kernel.org>; Wed,  3 Feb 2021 02:34:55 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j11so4130545wmi.3
        for <live-patching@vger.kernel.org>; Wed, 03 Feb 2021 02:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=ucutE9tVrKg8bG1XX/lcHYR1DORerY7wTTSfiDErO4Y=;
        b=M75pCStwd1CD5X+AE8fVhstTS+X4mKfTg66UmMyLV/4dbGEYA6QHxZzUVBaPMOz7xx
         F9+edfLoc2Vlmx1emXKW6xZgu7oWNOjz1WTgd2M5J2gnXE54FmGLbHHBb8oKBNcpCTS4
         6/gH/3v5zILbDOnuxcfqarN4OjvcB8d9ja9AA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ucutE9tVrKg8bG1XX/lcHYR1DORerY7wTTSfiDErO4Y=;
        b=q6XEBoS5yLdz0dtCeD4cltq+3yaUU3fX79JuobG/+7cqzP4RM4zxP+Pr4rR03gNjtJ
         0tXe9ICAc7ozCrkhuO90bYY/qHf+Txf9s3TnoHI6CIO1LMJlnxnuLoUMvcOPPgQQOvNz
         JuvvsG782FHSfmSptH/h765jdfXJdsLkxAVUlF9s6aIKTIjD2gEa6KrkfrImkDTY1H9l
         u5UJlqEQt4LH1QAu2JoO7s8HF3Nr4J/P3KBCkgr88o1JivU3Klywd4fngyST2jxEZhYh
         pV8dAtzbFybjlc+utK7ZOYdY9+TuqTSQwA7ibeT/IUJNo3gasVFQwHq2nuwuoFfnWuXp
         AR6A==
X-Gm-Message-State: AOAM533/gZaUwHz5TvgeOMw4blsqydduk86wcFoMlneMEqd3vgBR81As
        h8TW5AxaUulMoftHSoc0bWm+kg==
X-Google-Smtp-Source: ABdhPJz4SARPNc66CChB2hShzHi2iGX8D1M1gjyOuRd3fn77dLJW2FXa5gHf0Q6IrbHt0pXvjzsdvQ==
X-Received: by 2002:a1c:a90f:: with SMTP id s15mr2203893wme.154.1612348493733;
        Wed, 03 Feb 2021 02:34:53 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id b11sm2957419wrp.60.2021.02.03.02.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 02:34:53 -0800 (PST)
Date:   Wed, 3 Feb 2021 11:34:50 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 02/13] drm: remove drm_fb_helper_modinit
Message-ID: <YBp8ShiKbQSPCcRx@phenom.ffwll.local>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <20210128181421.2279-1-hch@lst.de>
 <20210128181421.2279-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128181421.2279-3-hch@lst.de>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 28, 2021 at 07:14:10PM +0100, Christoph Hellwig wrote:
> drm_fb_helper_modinit has a lot of boilerplate for what is not very
> simple functionality.  Just open code it in the only caller using
> IS_ENABLED and IS_MODULE, and skip the find_module check as a
> request_module is harmless if the module is already loaded (and not
> other caller has this find_module check either).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hm I thought I've acked this one already somewhere for merging through
your tree.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/drm_crtc_helper_internal.h | 10 ---------
>  drivers/gpu/drm/drm_fb_helper.c            | 21 ------------------
>  drivers/gpu/drm/drm_kms_helper_common.c    | 25 +++++++++++-----------
>  3 files changed, 12 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc_helper_internal.h b/drivers/gpu/drm/drm_crtc_helper_internal.h
> index 25ce42e799952c..61e09f8a8d0ff0 100644
> --- a/drivers/gpu/drm/drm_crtc_helper_internal.h
> +++ b/drivers/gpu/drm/drm_crtc_helper_internal.h
> @@ -32,16 +32,6 @@
>  #include <drm/drm_encoder.h>
>  #include <drm/drm_modes.h>
>  
> -/* drm_fb_helper.c */
> -#ifdef CONFIG_DRM_FBDEV_EMULATION
> -int drm_fb_helper_modinit(void);
> -#else
> -static inline int drm_fb_helper_modinit(void)
> -{
> -	return 0;
> -}
> -#endif
> -
>  /* drm_dp_aux_dev.c */
>  #ifdef CONFIG_DRM_DP_AUX_CHARDEV
>  int drm_dp_aux_dev_init(void);
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 4b81195106875d..0b9f1ae1b7864c 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -2499,24 +2499,3 @@ void drm_fbdev_generic_setup(struct drm_device *dev,
>  	drm_client_register(&fb_helper->client);
>  }
>  EXPORT_SYMBOL(drm_fbdev_generic_setup);
> -
> -/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
> - * but the module doesn't depend on any fb console symbols.  At least
> - * attempt to load fbcon to avoid leaving the system without a usable console.
> - */
> -int __init drm_fb_helper_modinit(void)
> -{
> -#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
> -	const char name[] = "fbcon";
> -	struct module *fbcon;
> -
> -	mutex_lock(&module_mutex);
> -	fbcon = find_module(name);
> -	mutex_unlock(&module_mutex);
> -
> -	if (!fbcon)
> -		request_module_nowait(name);
> -#endif
> -	return 0;
> -}
> -EXPORT_SYMBOL(drm_fb_helper_modinit);
> diff --git a/drivers/gpu/drm/drm_kms_helper_common.c b/drivers/gpu/drm/drm_kms_helper_common.c
> index 221a8528c9937a..f933da1656eb52 100644
> --- a/drivers/gpu/drm/drm_kms_helper_common.c
> +++ b/drivers/gpu/drm/drm_kms_helper_common.c
> @@ -64,19 +64,18 @@ MODULE_PARM_DESC(edid_firmware,
>  
>  static int __init drm_kms_helper_init(void)
>  {
> -	int ret;
> -
> -	/* Call init functions from specific kms helpers here */
> -	ret = drm_fb_helper_modinit();
> -	if (ret < 0)
> -		goto out;
> -
> -	ret = drm_dp_aux_dev_init();
> -	if (ret < 0)
> -		goto out;
> -
> -out:
> -	return ret;
> +	/*
> +	 * The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
> +	 * but the module doesn't depend on any fb console symbols.  At least
> +	 * attempt to load fbcon to avoid leaving the system without a usable
> +	 * console.
> +	 */
> +	if (IS_ENABLED(CONFIG_DRM_FBDEV_EMULATION) &&
> +	    IS_MODULE(CONFIG_FRAMEBUFFER_CONSOLE) &&
> +	    !IS_ENABLED(CONFIG_EXPERT))
> +		request_module_nowait("fbcon");
> +
> +	return drm_dp_aux_dev_init();
>  }
>  
>  static void __exit drm_kms_helper_exit(void)
> -- 
> 2.29.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
