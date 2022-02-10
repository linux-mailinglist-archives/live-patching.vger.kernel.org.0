Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390D54B183A
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 23:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344988AbiBJWeJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 17:34:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiBJWeI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 17:34:08 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BC4F47
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 14:34:09 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cn6so13431962edb.5
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 14:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=gae0iqrJma0ubJGx+korPq/UL8n+mTcx7+m98ESw/To=;
        b=OXceol4/G2O7BY+gmtm53YuRQSeUlseuEb06MJioe2JcxWBLtmBB2e0looT5yqOKGR
         Vuv1J4nMOunVcyaNPIDZ6sKikFeg/v0tAp+JJ9nIoEqZE4d5wMIfB/W3xf1TccwntlhB
         NH7uU3kNu7+BqA9RIX/zJC+DwtSNy+vfZTsya+mXtLmWtTcnX4a+c3p522vf8f61zqNn
         E6N5h1LVDXoRQiYe9NTe0vdNJk0MjwfIbhJxEXoGOMY3M+37lEHknLhLCcLAVTmFNHDj
         10jVIVBX26d+26V4UQpWpsiuMGv9Sh9OfCKCSDRUhNGVDB3/TEY4ffhkiwG7h3F6FEcY
         cuaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=gae0iqrJma0ubJGx+korPq/UL8n+mTcx7+m98ESw/To=;
        b=oIdVN1nMLXiaMDSvDROcYgxxrpSG6LH8hMhiIj8FdfEpWOp0E5r8ocEk31S6PorIgc
         Fq8kk1FVkJCQtPRJ1IcuLsugkqD0c9JH2W1sUMYDq0CQ/ZZdHeDd6GBwDw17apGM3AIj
         nifIU2Q/xYt9LzYINESylRu3AqDmxl5PSQau8cT2IaiCr2U4ARtW1UH9qiOlbS2Dx9Z6
         IU3vQ+FMJrRfMucpNQUyrb7DmENrXez9pTCNmZ3g8CER2CxshB2srMkcev4mwuWvoymT
         3XLG27+33GvHQh5odkPNeXIWF1gfOMd86/UYonFIcbAeNNPCGIRmaDniUEk1HG99jiSf
         OzBA==
X-Gm-Message-State: AOAM5333e1xfe5VUzyIYjPwvDH+TQ/6VYQH5wt4g3j5KVrp2TU1Ge1Cr
        TpZqLi5jwsa0Q6Mk6GhHD92POw6WMO6tg9EC6Dw=
X-Google-Smtp-Source: ABdhPJxEsgq4kBw9Dm9Lc+L28wx2kPQGiNzdP9sawD/7vmRa/JTkw3rP8TffX+hyicjBiJ/EnVjkERS25IEjyahGQKA=
X-Received: by 2002:a05:6402:5cf:: with SMTP id n15mr10440693edx.245.1644532447682;
 Thu, 10 Feb 2022 14:34:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:7b98:0:0:0:0 with HTTP; Thu, 10 Feb 2022 14:34:07
 -0800 (PST)
Reply-To: tiffanywiffany@gmx.com
From:   Tiffany Wiffany <klouboko@gmail.com>
Date:   Thu, 10 Feb 2022 14:34:07 -0800
Message-ID: <CA+Adgp5Dk3FJzrVpWo-ZR4A1bQtw8Lau0HHW+ma8MafR5xT==g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

-- 

Hi, please with honest did you receive our message ? we are waiting
for your urgent respond.
