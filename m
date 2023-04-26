Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21A96EFBC7
	for <lists+live-patching@lfdr.de>; Wed, 26 Apr 2023 22:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbjDZUij (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Apr 2023 16:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbjDZUii (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Apr 2023 16:38:38 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25AD1BC
        for <live-patching@vger.kernel.org>; Wed, 26 Apr 2023 13:38:37 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-74da25049e0so659329785a.0
        for <live-patching@vger.kernel.org>; Wed, 26 Apr 2023 13:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682541517; x=1685133517;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JL3yT3Q33W5/BCQtgOVvz2cK4S2v0dqNTi6RS5aes9g=;
        b=OvQqWKtnHE9ZYSOGWQiek75elK/AS5J2BUX9CwuSoKShoVo0Ise6FWhfma/gcRaI2r
         4JFpmFRAaSg6hu/+VeLLx+9MW7RzVW35HL8C0/xkDeMi7k5l3LJbhZnF9vpSrFfRcZgx
         E9RLvPuGgL/NZf1ni2UWzZPMEEfn6K6xfMAEaq/PuMr4f84ErGXbrf2b6qR6UNzx1FWf
         GfyD1P15JXyIkDo2WuxInfMmiTNXfJLykGMlOOg5NvLAdljiDWZtRUddSi6ta9gx/d+w
         PIH7qejQ8/7PhlZT/zMF6mAJE0u/qFTyo62sNwWd0mHXJ3VeKm+0gMQCIxYW4WoPFstR
         2qkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682541517; x=1685133517;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JL3yT3Q33W5/BCQtgOVvz2cK4S2v0dqNTi6RS5aes9g=;
        b=NXKmQoiOucu8kDYWROVm7Lf3Pf4bgZYROpp8J8//tvC6jALIlw8yINoN8XD0VeNuQr
         wI56s93uZ0gBtm2eaSITL3aAVoXUo/+l46Zofufs+KvKvun6QJIUzmFInOX7AmZb0VdO
         WzS1rZQ07bsqSMcfPgSOouxMldVDmKvtyrz06tIaslfhdyZQIdETIN4hwLyNLCGiPAMa
         mMgu6/TPus2B22AIpRung+RighqbJK38OxW0Cpe7txOQque0+MT9D08o+vKADQd8qJXu
         6AEd2EhcGFz6aM8dUjPbnSvGjKIMxWLmNC5VOzQB/c7xuzUNVR793UsXRnjhAE5pKDqa
         FtXg==
X-Gm-Message-State: AAQBX9e0PZNCSxqH7zeRIRHvnZAqAqHfKnufwUbew8xWJOEdktB/Oe25
        u39Xadwp+63f7RDUeOhQHtG29kpErDzCV5AtjEk=
X-Google-Smtp-Source: AKy350aahtT5urGRpRt0dmA3+1cGpPY1YEGq3M9gCFbNPtkMSZ2OjV05EO7SLcW4lSbkAUDp7UiNgM2A3R68/j5eVPQ=
X-Received: by 2002:ac8:5812:0:b0:3ef:58f5:a001 with SMTP id
 g18-20020ac85812000000b003ef58f5a001mr35727525qtg.44.1682541516703; Wed, 26
 Apr 2023 13:38:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:622a:1391:b0:3b8:6d45:da15 with HTTP; Wed, 26 Apr 2023
 13:38:36 -0700 (PDT)
Reply-To: klassoumark@gmail.com
From:   Mark Klassou <georgerown101@gmail.com>
Date:   Wed, 26 Apr 2023 20:38:36 +0000
Message-ID: <CAHmBb7tucZuQ0ROUiFYY3mxfmnDP64+Xz2so2JPVkRCM6-hvsw@mail.gmail.com>
Subject: Re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Good Morning,

I was only wondering if you got my previous email? I have been trying
to reach you by email. Kindly get back to me swiftly, it is very
important.

Yours faithfully
Mark Klassou.
