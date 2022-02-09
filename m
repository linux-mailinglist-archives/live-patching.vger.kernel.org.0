Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7974AFEB6
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 21:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiBIUsN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 15:48:13 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiBIUsN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 15:48:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7564C05CB96;
        Wed,  9 Feb 2022 12:48:15 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 270F7210FA;
        Wed,  9 Feb 2022 20:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644439694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UwgkA68ySmUW5/i3EYiZiiSs6H2oCiJiHMFUbdE9/kA=;
        b=CPF3aVkrSzk+DBrQI/8fTVHvPc/tYv/I2kzg7FwUpfmyHrZOeX9O21As8lz0HrmzyKsL2y
        hxIOBDJPcrtAzqP9BQXbIgVxYAz5OqulJGI3tMWsNuHDAddzw4XYnZIVxj5Hp7uwEwZtM3
        Ugc52ItjjFh1AVsL3SLir3b71BSC/lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644439694;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UwgkA68ySmUW5/i3EYiZiiSs6H2oCiJiHMFUbdE9/kA=;
        b=9mPNk4VVo0bx3x9okO/NLh0S98fPaNi7/M5VzvTXgQhxCf/psAEuD5j5Bi/7SHm5a/79Qc
        rJ/GpXhB8PXyQLAA==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B5E91A3B85;
        Wed,  9 Feb 2022 20:48:13 +0000 (UTC)
Date:   Wed, 9 Feb 2022 21:48:12 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     20220209170358.3266629-1-atomlin@redhat.com
Cc:     mcgrof@kernel.org, cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu,
        oleksandr@natalenko.name
Subject: Re: [PATCH v5 07/13] module: Move extra signature support out of
 core code
Message-ID: <20220209204812.GD3113@kunlun.suse.cz>
References: <20220209170814.3268487-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170814.3268487-1-atomlin@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

On Wed, Feb 09, 2022 at 05:08:08PM +0000, Aaron Tomlin wrote:
> No functional change.

There is functional change.


> @@ -2565,70 +2542,6 @@ static inline void kmemleak_load_module(const struct module *mod,
>  }
>  #endif
>  
> -#ifdef CONFIG_MODULE_SIG
> -static int module_sig_check(struct load_info *info, int flags)
> -{
> -	int err = -ENODATA;
> -	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
> -	const char *reason;
> -	const void *mod = info->hdr;
> -	bool mangled_module = flags & (MODULE_INIT_IGNORE_MODVERSIONS |
> -				       MODULE_INIT_IGNORE_VERMAGIC);
> -	/*
> -	 * Do not allow mangled modules as a module with version information
> -	 * removed is no longer the module that was signed.
> -	 */
> -	if (!mangled_module &&
             ^^^^^^^^^^^^^
> -	    info->len > markerlen &&
> -	    memcmp(mod + info->len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
> -		/* We truncate the module to discard the signature */
> -		info->len -= markerlen;
> -		err = mod_verify_sig(mod, info);
> -		if (!err) {
> -			info->sig_ok = true;
> -			return 0;
> -		}
> -	}

> diff --git a/kernel/module/signing.c b/kernel/module/signing.c
> index 8aeb6d2ee94b..ff41541e982a 100644
> --- a/kernel/module/signing.c
> +++ b/kernel/module/signing.c

> @@ -43,3 +62,59 @@ int mod_verify_sig(const void *mod, struct load_info *info)
>  				      VERIFYING_MODULE_SIGNATURE,
>  				      NULL, NULL);
>  }
> +
> +int module_sig_check(struct load_info *info, int flags)
> +{
> +	int err = -ENODATA;
> +	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
> +	const char *reason;
> +	const void *mod = info->hdr;
> +
> +	/*
> +	 * Require flags == 0, as a module with version information
> +	 * removed is no longer the module that was signed
> +	 */
> +	if (flags == 0 &&
            ^^^^^^

This reverts a97ac8cb24a3c3ad74794adb83717ef1605d1b47

Please re-apply.

Thanks

Michal
> +	    info->len > markerlen &&
> +	    memcmp(mod + info->len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
> +		/* We truncate the module to discard the signature */
> +		info->len -= markerlen;
> +		err = mod_verify_sig(mod, info);
> +		if (!err) {
> +			info->sig_ok = true;
> +			return 0;
> +		}
> +	}
