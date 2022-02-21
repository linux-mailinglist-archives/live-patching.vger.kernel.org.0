Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0144BE8DC
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 19:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353671AbiBUKRj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 05:17:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiBUKQv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 05:16:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A65B2B1A3
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 01:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645436118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XZrTlvfXotnswsvjd0YUM1RHyK8H1Vt0nzlWoZF1MZ8=;
        b=Ybr7+/SBDlVI9mrKVt+zk28sOc3CsgY2rxmuaBIQLUaxU+BaG2AVt3IoHshKVGlVlwm+A3
        n3TVlO6NeGo85mLclB6I+vRY/FUvWff+ArOQNfyvgSRV2pdTjbs6ADXEg0u8AJFrVgKCgx
        p4Lj/hRMEmyjsjfe1WWM5eTuhacgZ5w=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-LjJ4Nb94Nt2ko3Q_ijrSGw-1; Mon, 21 Feb 2022 04:35:16 -0500
X-MC-Unique: LjJ4Nb94Nt2ko3Q_ijrSGw-1
Received: by mail-lj1-f199.google.com with SMTP id bf20-20020a2eaa14000000b0024634b36cdaso1868654ljb.0
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 01:35:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZrTlvfXotnswsvjd0YUM1RHyK8H1Vt0nzlWoZF1MZ8=;
        b=oxiODCsQBaZeOaQamxYNy1hE3qz7cTf3CI8OalKN0tziBavIi5N36zJuVBC4LfXur5
         UW22L9+Q/e1sJu0HfpahJ3VQBqxMLtmsAov0CCjC+1bo9/7Eb7FEMynrZco5IwieJdSZ
         ZOG6+uIG5JaF4VFePHmzoo9amqjA6G0kQW8m08wPP8PGNvthrqxlUxKLsME44hsdjIiL
         Oor1JucdXh2ObCc4bLcAN2/uKxdHyDaphNYPBt/2fflha7oCXGTzbfc3lb0dagnF0ebc
         p+GO6sB1xJO0NWp2vBJ6WQchiIk9GOz/Uia5GYpy9myNzY99Y502M0+gr6aqAbGtXTO4
         3slQ==
X-Gm-Message-State: AOAM5321Ny7QK+C4JnOW0icd0qZLX9pgsjsbMzywJAgY4BRUSGYNYoay
        IY7SolViLhMzHOxm2qWLiKPGy24WMN0uQkm3DrVlGc2xAg63zFzwqaFvi2XV2a8ecfoyyXCKiXV
        Qce/EH+NpJAu/omIb4g7Zw4XGSC5DbSBqTqJUDmbF
X-Received: by 2002:a05:6512:308b:b0:443:5f54:dcae with SMTP id z11-20020a056512308b00b004435f54dcaemr14171281lfd.79.1645436114921;
        Mon, 21 Feb 2022 01:35:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwdWTU1J1Wp/gQK1TNV+7EzlpZp9cTyOBUeVKlHJPSRNNZyZzwbpneTb+o1FHTpSs4OLUS8lczju7vAM4M784=
X-Received: by 2002:a05:6512:308b:b0:443:5f54:dcae with SMTP id
 z11-20020a056512308b00b004435f54dcaemr14171262lfd.79.1645436114662; Mon, 21
 Feb 2022 01:35:14 -0800 (PST)
MIME-Version: 1.0
References: <20220218212511.887059-1-atomlin@redhat.com> <20220218212511.887059-7-atomlin@redhat.com>
 <0555ad08-365c-ae49-0f6b-973fd16866c9@csgroup.eu>
In-Reply-To: <0555ad08-365c-ae49-0f6b-973fd16866c9@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Mon, 21 Feb 2022 09:35:03 +0000
Message-ID: <CANfR36ja_NYoBFYOAO02a4LOp_wDzD=8NVqhCY0PEOXC3-dsvg@mail.gmail.com>
Subject: Re: [PATCH v6 06/13] module: Move strict rwx support to a separate file
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,WEIRD_PORT
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-02-21 06:31 +0000, Christophe Leroy wrote:
>    CC      kernel/module/strict_rwx.o
> In file included from ./include/linux/build_bug.h:5,
>                   from ./include/linux/container_of.h:5,
>                   from ./include/linux/list.h:5,
>                   from ./include/linux/module.h:12,
>                   from kernel/module/strict_rwx.c:8:
> kernel/module/strict_rwx.c: In function 'frob_rodata':
> kernel/module/strict_rwx.c:16:17: error: implicit declaration of
> function 'PAGE_ALIGNED'; did you mean 'IS_ALIGNED'?
> [-Werror=implicit-function-declaration]
>     16 |         BUG_ON(!PAGE_ALIGNED(layout->base));
>        |                 ^~~~~~~~~~~~
> ./include/linux/compiler.h:78:45: note: in definition of macro 'unlikely'
>     78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>        |                                             ^
> kernel/module/strict_rwx.c:16:9: note: in expansion of macro 'BUG_ON'
>     16 |         BUG_ON(!PAGE_ALIGNED(layout->base));
>        |         ^~~~~~
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:288 : kernel/module/strict_rwx.o]
> Erreur 1
>
>
>
> You have to include <linux/mm.h>

Christophe,

Strange, I have not seen this before. Locally, looking at
kernel/module/strict_rwx.i it is eventually included. Anyhow, you are
right. Also, it will not hurt due to the multiple-include optimisation
found in include/linux/mm.h.


Kind regards,

-- 
Aaron Tomlin

