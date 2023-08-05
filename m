Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2167770E2A
	for <lists+live-patching@lfdr.de>; Sat,  5 Aug 2023 08:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjHEGpE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 5 Aug 2023 02:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjHEGpD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 5 Aug 2023 02:45:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2811BE
        for <live-patching@vger.kernel.org>; Fri,  4 Aug 2023 23:45:02 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5231f439968so1546819a12.0
        for <live-patching@vger.kernel.org>; Fri, 04 Aug 2023 23:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691217901; x=1691822701;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fyaf0OHfvWgaqfRiwRufcy49gz6rXRNyNLf1qH0Ffk0=;
        b=IqWKP1ZWA+OY7VogaRrrgUpYs4bR8d0dEFkZrv+L5hezbRnxEhInzSdAvc5XUEgdSd
         dHPNVPfezn/NpK0Db9esxyhwjMUYM38BqO3aYP1AxSFs1IaCkiFXS5OcyhPoQFcZy8BQ
         QJnjg5+/9cwdtxJ7GmcmhxHPxfVJVBpgi+zcq+wCKXP+SxlmWVSM5QFeysNBESSgTBfO
         mgVIsH0Au/UDccLf3MTUzyYmz9lypGArCp04OUfqGRC33q37TmJfQm431HqSPk3wkiGq
         24GgcAwdzBfo3CLN4c8utD7kaxRYm7BgQFSAmKmkhjJrYnXeEwZGJsLE65em8wI81KNX
         kStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691217901; x=1691822701;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fyaf0OHfvWgaqfRiwRufcy49gz6rXRNyNLf1qH0Ffk0=;
        b=ZVRBPS07EDSPoeB8iCYHDsf6u0PTwYLwlVT7Rxe4VaJUALQSfGpTtOGQlz0nRaCNbS
         7X/HEZV+cwQBKk/FeDH9RvcxubGOh6gvkeGGGd155zkuC0xelEtSacJ12KVpGfiYlVAJ
         ltf/sXEDQMdQwUuzmbsXxMEznb1RdYfLpGyBK+4u5sWzv6QjuLoxi/ssNR0Uh6tpT2DY
         f6Q/84G++ywDSf9IVXM6upvHwWxVp2l+LUK6KYebzPvuUhf9Y6gfoJKiWgJDnqQ5QInd
         RMCLeiMvnLRkxWVs++fmGJxIrG29UFndaPjVU0j5B3Hwki4PTNEIjhdSjI48/hVvEHCo
         vwnw==
X-Gm-Message-State: AOJu0Yw4LjaguLL4HUJr7egliFRrzFFz+RfiwxeEw0/js3JHaC3nthR/
        v1og5bC4DsT5DkCEISTO1rJBYw6vrRQzD+ZtTM8=
X-Google-Smtp-Source: AGHT+IEydy+kHQ3W/9fVTesZQcujKO4wzFjGKxHZNIWzxjq3B5NM2eBZxAWADOUria0IqfRrqQRCh1WxmN7vf7ELpSY=
X-Received: by 2002:aa7:dd59:0:b0:523:1f33:cf9 with SMTP id
 o25-20020aa7dd59000000b005231f330cf9mr2610452edw.25.1691217900526; Fri, 04
 Aug 2023 23:45:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7412:6629:b0:df:940:19b1 with HTTP; Fri, 4 Aug 2023
 23:45:00 -0700 (PDT)
Reply-To: bintu37999@gmail.com
From:   Bintu Felicia <bimmtu@gmail.com>
Date:   Sat, 5 Aug 2023 07:45:00 +0100
Message-ID: <CAAF5RuzWGc6ZeeawqiPVd2Hc0na7begM3wkSgFQbUpC7uQeAdg@mail.gmail.com>
Subject: HELLO...,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

How are you today? I hope you are fine. My name is Miss
Bintu Felicia . l am single looking for honest and nice
person whom i can partner with . I don't care about
your color, ethnicity, Status or Sex. Upon your reply to
this mail I will tell you more about myself and send you
more of my picture .I am sending you this beautiful mail
with a wish for much happiness
