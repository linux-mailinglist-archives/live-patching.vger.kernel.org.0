Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D4374C185
	for <lists+live-patching@lfdr.de>; Sun,  9 Jul 2023 10:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjGIIHM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 9 Jul 2023 04:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjGIIHL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 9 Jul 2023 04:07:11 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE81E4D;
        Sun,  9 Jul 2023 01:07:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b7e6512973so21368585ad.3;
        Sun, 09 Jul 2023 01:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688890028; x=1691482028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0tAKuNqVivThCXZVXcVk6n8lCoRv9zeEyxGMSMCnHV4=;
        b=B4jqqBUGLObHbv/psd5Fw0SHSyCzwCzTbmkKWok1kDKDGjOOA6TROUVTOnPpGnok84
         MoG82Ds4xYowTuCIPt9yKS5+HSmjOXX8RbIYXwFnCHTL4286kwIlPx+xuFRCxSat4ICj
         weH2OHAg5vBe1FR1LkWXWsG+6supE87nAJQ1afRFfDTEYVepkjquK0oiMdUtnY7pSekN
         J8sQX/COop/nvJYPZ8EOflzsRWZpqMnfCRPLBpLDuhgN4lFWL0V4WnISsp6QC0Shf6FT
         jLqk9Ls4S3UiVCXCUPZ53X19QX2kI03S5TMHcC0r7EyvC0j1qpPZ9cwAPAltHSb3A4Pd
         FfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688890028; x=1691482028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tAKuNqVivThCXZVXcVk6n8lCoRv9zeEyxGMSMCnHV4=;
        b=C0UWTVvQCi4L3q3fzFB1IGh2nh9ix3Q0ywQdEiH/BNrDTcEoVkwSQceBuFkzv/6k+d
         KX3z97tT7B/nv40rMJh9fDtvJroyJyVd2o4Q+kWFXrGAJw7uQ8Xf02XEwKHyMpJdusgS
         UsSgt4zoLRkTwgEfI261ED9yC2GaptCnPUqaQNHavq5yIQDKs37DPa1cWxQP/R5Fg2QB
         qw1bT/UWoInLWHYD6DJdeRub3RyLMHq3y3G3zmg8cXsD5tJHI2TmqgWRpp0nzHCssF58
         wYnj288IEpajViStBLwpJKnn9CG+xfuQ/LLB93DduPbOeiZgwcJYfWw7Sq3xK3WpWOUy
         o4oA==
X-Gm-Message-State: ABy/qLbNndlZdc7Y55zkU29p0A1cAWiOPeqT+/jzYp9ifgElwN/v4qhb
        JYeFsAcQX9xopDMVsyOTusA=
X-Google-Smtp-Source: APBJJlFxdiI9hJaj7rTeOqOhPVon6jPKdDimUaa6NcxSHRIyqqkSWX7/8jrvcCvJcHLiQtLb3/iFdQ==
X-Received: by 2002:a17:902:9a4a:b0:1b5:4679:568f with SMTP id x10-20020a1709029a4a00b001b54679568fmr6872885plv.45.1688890027669;
        Sun, 09 Jul 2023 01:07:07 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902e54c00b001b9cea4e8a2sm2295992plf.293.2023.07.09.01.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 01:07:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 9004B8197D13; Sun,  9 Jul 2023 15:07:01 +0700 (WIB)
Date:   Sun, 9 Jul 2023 15:07:01 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     wardenjohn <ydzhang@linux.alibaba.com>
Cc:     jpoimboe <jpoimboe@kernel.org>, jikos <jikos@kernel.org>,
        mbenes <mbenes@suse.cz>, pmladek <pmladek@suse.com>,
        "joe.lawrence" <joe.lawrence@redhat.com>,
        Kernel Live Patching <live-patching@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix MAX_STACK_ENTRIES from 100 to 32
Message-ID: <ZKpqpamE89nvgslC@debian.me>
References: <931aaecf-66b1-469a-8bc3-7126871a8464.ydzhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YrNPC+OEMpEeAcTM"
Content-Disposition: inline
In-Reply-To: <931aaecf-66b1-469a-8bc3-7126871a8464.ydzhang@linux.alibaba.com>
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--YrNPC+OEMpEeAcTM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 08, 2023 at 09:56:34AM +0800, wardenjohn wrote:
> Thanks for reading my suggestion. I found that the array for task stack e=
ntries when
> doing livepatch function check is too large which seems to be unnecessary=
=2E Therefore,
> I suggest to fix the MAX_STACK_ENTRIES from 100 to 32.

Can you provide Link: to the discussion? Yet, I guess this is somehow
v2 patch.

>=20
> The patch is as follows:
>=20
> From ee27da5e64daced159257f54170a31141e943710 Mon Sep 17 00:00:00 2001
> From: Yongde Zhang <ydzhang@linux.alibaba.com>
> Date: Sat, 8 Jul 2023 09:40:50 +0800
> Subject: [PATCH] Fix MAX_STACK_ENTRIES to 32
>=20
> When checking the task stack, using an stack array of size 100=20
> seems to be to large for a task stack. Therefore, I suggest to
> change the stack size from 100 to 32.=20

Why is MAX_STACK_ENTRIES=3D100 overkill? And why do you reduce it?

>=20
> Signed-off-by: Yongde Zhang <ydzhang@linux.alibaba.com>
> ---
>  kernel/livepatch/transition.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index e54c3d60a904..8d61c62b0c27 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -14,7 +14,7 @@
>  #include "patch.h"
>  #include "transition.h"
> =20
> -#define MAX_STACK_ENTRIES  100
> +#define MAX_STACK_ENTRIES  32
>  static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entrie=
s);
> =20
>  #define STACK_ERR_BUF_SIZE 128=20

Your patch is MIME'd, please submit it with git-send-email(1) instead.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--YrNPC+OEMpEeAcTM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZKpqoQAKCRD2uYlJVVFO
o2lGAP9sqV+kuxkKPjIXC+EDhICkPGQGyJ4ZZjXLqtr+lEhRXAEAmBy1p3nykzVq
Q17J1o0wFZVmeG+P+wN3flSRKoqecgw=
=w/f9
-----END PGP SIGNATURE-----

--YrNPC+OEMpEeAcTM--
