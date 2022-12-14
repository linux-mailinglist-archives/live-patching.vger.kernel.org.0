Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A0464C9C1
	for <lists+live-patching@lfdr.de>; Wed, 14 Dec 2022 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbiLNNJF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Dec 2022 08:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiLNNJA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Dec 2022 08:09:00 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13DB165B0
        for <live-patching@vger.kernel.org>; Wed, 14 Dec 2022 05:08:57 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id b13so10337880lfo.3
        for <live-patching@vger.kernel.org>; Wed, 14 Dec 2022 05:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PedTboiFtvABud73ZD3U4hUNQIS0oeFWRBzeT0lU6t8=;
        b=KxNdjgQBBMefpFtO1FEOgrggLT8o+qZDfroZw26F0Wv0Nxpn0xu9xNsdKWRy3Tw8bn
         3uBMa/7AEqqjC/PMfuoqKWvVC5DOyip+tZtU9MJs5nl4fxwWT0YGm7OMC2MTSporlAgR
         uNGX8CUL49SHU8ddhDx3ElaxyXbolwzGfnMMmldXQp7emry9hbmp/KuPRA9F0MjIiQ2Z
         dSkIzopkbTiIVz4K7tlH0kGmyqbalMk02wZGbh3IlqwfrbR9rDnnd2pXSwUjeh/EtUjQ
         +M9S8N5KIWGbu1MopCKi+Y+KYZHT6cDTVnC+/G9IM5GpspwyQ30hFg/66iuFDlheHyUP
         TBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PedTboiFtvABud73ZD3U4hUNQIS0oeFWRBzeT0lU6t8=;
        b=dTr5aNfITz72Cg9m2KbHEex7OVv8ExTtE9i9yLEcfeaebWT93ilVy2r+y7X249OPjn
         fisLcF2PxyyH0FKYzK4/WP1Y3n8cTTMdj0aoJMjECAMAkX8ar2XAOeHBc1G8kzxAfNdk
         566ylGvEYr14Zyn2zfEWUAiQJbnjPG0DK5TU23B1vqAD18Kfrmfy9uICZ15WrOxUIjn6
         AidQqKg0yuDeFKHN+1hhvQlbOmhDlU+T2foCFG94lQXc8el7c88WEpESVgBYl5vI75Xf
         4IyNGXGHQBwB2fpFTcgiT97+fBwC7vteVqVTD0OfUBLHJ/2IPSMyGL7M2hlkzl0hJtRP
         Nd4g==
X-Gm-Message-State: ANoB5plWQMF46vjm9108igCBmvsoIipzHd/VPh063Uu+b93G/wuMoI+j
        637GguGupiUra9R+wBP6PdSbCASj4a3ODZNTW8k=
X-Google-Smtp-Source: AA0mqf7aqfGeGqDDOw+H/ntC+nwy73TSEmbwetV0rbXvZf5FsiA5pNXvyDL3eCkdfjVsC5t7TR7v31XEbh/l8BEoqhU=
X-Received: by 2002:ac2:4563:0:b0:4b5:afc6:1f74 with SMTP id
 k3-20020ac24563000000b004b5afc61f74mr1466029lfm.577.1671023336032; Wed, 14
 Dec 2022 05:08:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:651c:1597:0:0:0:0 with HTTP; Wed, 14 Dec 2022 05:08:55
 -0800 (PST)
Reply-To: a2udu@yahoo.com
From:   "." <urri8344@gmail.com>
Date:   Wed, 14 Dec 2022 14:08:55 +0100
Message-ID: <CAKzm1Z4NTZFpkD10SG0cQ6+WLXF0_7ELoUXkkr9FewwDX5Z7SA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

-- 
Hello

The money is ready to be transferred, kindly acknowledge your interest.
