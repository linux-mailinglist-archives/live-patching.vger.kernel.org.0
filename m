Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F342412E62
	for <lists+live-patching@lfdr.de>; Tue, 21 Sep 2021 07:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhIUFzf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Sep 2021 01:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhIUFzf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Sep 2021 01:55:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C29C061574;
        Mon, 20 Sep 2021 22:54:07 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id i4so77534455lfv.4;
        Mon, 20 Sep 2021 22:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpUkPJQXkk9fBNIxLOKTcbXhkHoX6oXTQwo24b2XE1M=;
        b=CS3Et8KOOV57xk5PhR6sFVWcizWSm/W05z/gI/FvHjtBdxmlz9UbAP+NQwpwdxtIZq
         HB19wnN+gJu5dr9XpRcZ1ObJX/CxPCUPUx5WWSE2yvw+R73et2lmN1AKGREs4HO2v1fQ
         oJ/GZzOAFPho/zQ9se0r+MCBqnfKRAJR+DZjuaGsUbKF5+tqOIh8Sjz9Jnt15rc6JZon
         TABDYC4htGCJgoETF22MvazJWdc1Q3DI6/7XV+B8/97vToXjOfwK/le1yHhQnaG4Eos2
         VHosyOiA4cujW05SXN9+Ac/gtpEdE3PANwIE90Azp42J7b7IXq4YMpykLAdB5FqPR461
         +Rmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpUkPJQXkk9fBNIxLOKTcbXhkHoX6oXTQwo24b2XE1M=;
        b=4/KxijOpQE+MkmN3WM9h5BRtz+Rf0laoB+T0Mx0uzsMZvpsXJipVuXCuG9TFLJp7B9
         CTnIARE6LlYTNIvQdmhufs6aWx8KASKJoK0zkMrJxzSdvy/PVddAHm2aJEt1ucP1NC3t
         KpoMgWXFntvW1qQL8kSc2jsA1VMM3EYGFKynrUTDKzl3AgBe7Sna8lD1msouzM1tM351
         VU8AW/VLVsALB6iQWBY+k7d+xa3ONr4tZbX1T1p3yd07jf33XK9tmm0JWhSFuDZiGXkA
         i7FnD8Qp0dwauK67JxO7TrXsXA3MFIVY6xvs9SBl/gIO/CFqw/KfQzxzBY3Fs7R7Klt1
         rI8w==
X-Gm-Message-State: AOAM532nMGvWB2pDjjW0hdns0fuArtB17OPNgcXWLY8n7eclUz4RWUbf
        LbULOyMm3/HMHDHEy7H0OdfljqkotS/yLibDfMU=
X-Google-Smtp-Source: ABdhPJwrKvNOA6hoU9pJ2xyCVuHPZ7QAlv6lM0knDKsuFO6gALL2+emOzohvo+cGzSMXmXHkqEd+W9DG3SlbSHH2W6E=
X-Received: by 2002:a2e:1645:: with SMTP id 5mr7543404ljw.123.1632203645190;
 Mon, 20 Sep 2021 22:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210810051602.3067384-1-mcgrof@kernel.org> <20210810051602.3067384-2-mcgrof@kernel.org>
In-Reply-To: <20210810051602.3067384-2-mcgrof@kernel.org>
From:   Lucas De Marchi <lucas.de.marchi@gmail.com>
Date:   Mon, 20 Sep 2021 22:53:53 -0700
Message-ID: <CAKi4VAKa7LKXdRmA7epgbkUZw2wpUz19JYYdZ35mPCxSL_W_kw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] libkmod: add a library notice log level print
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-modules <linux-modules@vger.kernel.org>,
        live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        Jessica Yu <jeyu@kernel.org>, osandov@fb.com,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 9, 2021 at 11:56 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> When you use pass the -v argument to modprobe we bump
> the log level from the default modprobe log level of
> LOG_WARNING (4) to LOG_NOTICE (5), however the library
> only has avaiable to print:
>
>  #define DBG(ctx, arg...) kmod_log_cond(ctx, LOG_DEBUG, ## arg)
>  #define INFO(ctx, arg...) kmod_log_cond(ctx, LOG_INFO, ## arg)
>  #define ERR(ctx, arg...) kmod_log_cond(ctx, LOG_ERR, ## arg)
>
> LOG_INFO (6) however is too high of a level for it to be
> effective at printing anything when modprobe -v is passed.
> And so the only way in which modprobe -v can trigger the
> library to print a verbose message is to use ERR() but that
> always prints something and we don't want that in some
> situations.
>
> We need to add a new log level macro which uses LOG_NOTICE (5)
> for a "normal but significant condition" which users and developers
> can use to look underneath the hood to confirm if a situation is
> happening.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  libkmod/libkmod-internal.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/libkmod/libkmod-internal.h b/libkmod/libkmod-internal.h
> index 398af9c..2e5e1bc 100644
> --- a/libkmod/libkmod-internal.h
> +++ b/libkmod/libkmod-internal.h
> @@ -25,10 +25,12 @@ static _always_inline_ _printf_format_(2, 3) void
>  #  else
>  #    define DBG(ctx, arg...) kmod_log_null(ctx, ## arg)
>  #  endif
> +#  define NOTICE(ctx, arg...) kmod_log_cond(ctx, LOG_NOTICE, ## arg)
>  #  define INFO(ctx, arg...) kmod_log_cond(ctx, LOG_INFO, ## arg)
>  #  define ERR(ctx, arg...) kmod_log_cond(ctx, LOG_ERR, ## arg)
>  #else
>  #  define DBG(ctx, arg...) kmod_log_null(ctx, ## arg)
> +#  define NOTICE(ctx, arg...) kmod_log_cond(ctx, LOG_NOTICE, ## arg)

did you mean kmod_log_null()?

Lucas De Marchi

>  #  define INFO(ctx, arg...) kmod_log_null(ctx, ## arg)
>  #  define ERR(ctx, arg...) kmod_log_null(ctx, ## arg)
>  #endif
> --
> 2.30.2
>
