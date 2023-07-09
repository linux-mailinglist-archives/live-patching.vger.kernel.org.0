Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D674C140
	for <lists+live-patching@lfdr.de>; Sun,  9 Jul 2023 08:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjGIGRE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 9 Jul 2023 02:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbjGIGRC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 9 Jul 2023 02:17:02 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C562E4E
        for <live-patching@vger.kernel.org>; Sat,  8 Jul 2023 23:17:01 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 3f1490d57ef6-c11e2b31b95so4084407276.3
        for <live-patching@vger.kernel.org>; Sat, 08 Jul 2023 23:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688883420; x=1691475420;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmlwvXEoimVTfsyyyYai0GQlqo3zzXGhdH5Gfvmx5TY=;
        b=XY8qTS1FW3eQH6ZSkN7p0UWmFf5VmWUG7zahPaRPOdgtLo6aTgRBxMz82iRJhVxNyn
         1oYV1BIfzEmHqeLODRgAQz+mc5tDiryEhP8SpvU+GCpmAfLMSn8UP9wh5ZFFgKoJUjCQ
         68ia4zL1N2Okj27ZcZlsL3SWlaGhi+N946w5gDLvKTr60zG1/JOwjzCiMdGTtTFSMVU5
         K5E5AVqbJFeks6CveCcRH63ze+QEeLTtqNQ3Qu4qp61pgsmHmsLwOY34uYXd4Hl8wYLb
         xhZf9IFXf16TjapaObnfNIyOfN3gigHa+NBtd2dGxYxRmihEdnG0Eyv8vkDFKTjlRgIy
         FLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688883420; x=1691475420;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmlwvXEoimVTfsyyyYai0GQlqo3zzXGhdH5Gfvmx5TY=;
        b=MHJnhy7m9IwC19ZXDoQouV7lO+c+rgZtcHFv58MVEUqzllJk+dC/l6VL+ASvOuVgic
         oaLmiEfNsdzgGJ2CjZEoGvDxyvW4g5IhEsMSI37qQ7yMDioCKgLd1uK7ysyxEcaf9UO8
         3GU+uurGWN3Ow7EcNTUKmeGlWG30MSj4UlQke4s8/Vr8LTDq/Q/eu9sNvJqNP8frAccV
         xcPGXf0TGH3x5L5k7gudOaJ/yq3H5esnsHnt6D1JDUhFg5QNU2hu1+MGwHvq2DcJlczY
         CF/lBH34Phwo9M/f5s+10i8Hdpz6w862e5p7UHy1eqOaW+K/ltB/IPWW3FAgZJ6tsvWv
         aKiA==
X-Gm-Message-State: ABy/qLZLz+2KIKtKzHueuPBHENSkHcoJOZBJS3D43A/v/3he8CzW0DKO
        OJQGQWWVK/RYFxGwD2BfMkT6hCBMwi7VlxVrCn0=
X-Google-Smtp-Source: APBJJlFX76/PfOHtB3fhJJpcM2PH93h7bri9Roi3JhKGQ/m7ByUkvd+9LPbq7Z3vhnPAb66jJajmVfuEbcwm+qPVJqo=
X-Received: by 2002:a25:1e8a:0:b0:c00:e25d:818f with SMTP id
 e132-20020a251e8a000000b00c00e25d818fmr8162499ybe.27.1688883420247; Sat, 08
 Jul 2023 23:17:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:6211:b0:35e:b32a:1b89 with HTTP; Sat, 8 Jul 2023
 23:16:57 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <coulibalynina15@gmail.com>
Date:   Sun, 9 Jul 2023 06:16:57 +0000
Message-ID: <CA+8Vp3U85GDtE3yEBc+QXParVLVO52DdX3ETHr7_R3WYSvMaKQ@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Dear,

Please grant me the permission to share important discussion with you.
I am looking forward to hearing from you at your earliest convenience.

Best Regards.

Mrs. Nina Coulibaly
