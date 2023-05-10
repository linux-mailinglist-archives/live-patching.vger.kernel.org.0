Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849026FE0B1
	for <lists+live-patching@lfdr.de>; Wed, 10 May 2023 16:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbjEJOpL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 May 2023 10:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237511AbjEJOpL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 May 2023 10:45:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0581A7
        for <live-patching@vger.kernel.org>; Wed, 10 May 2023 07:45:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50bc3a2d333so11139186a12.0
        for <live-patching@vger.kernel.org>; Wed, 10 May 2023 07:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683729909; x=1686321909;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=MCObQyCKOnZL8olyAH+L6yAEeHDNSxv44HyixpORMX6w6nsRhAa6yuDPveW21Rig5G
         Xxfe0i70j9e8PVl6Q7hOUSRP0gGak/KsLwIXguAn58i0Dc8dwcorDBYj1TnQan1Unzz7
         S2sGXEcLZrGnHonHbTiHgIGIetUXxDNLHyVC8lG1VFj0sOlf64fuRTNfPXaXvYJ/aCmu
         I+YfOr/K/rQMVoct3RYfFkrlwXCluwa86MnfVec1DwzbU31XO7xHsWAJDzmIP9EEUhmT
         ZyBwstrDTs3F4+JqIU2sjS8HlyCV43NE5Kg8iN51B2vGYVEO29PrhvcQEoz3oyezJiZJ
         cULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729909; x=1686321909;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=Z20zvr3Q1ySC/N0BMqEQWtGl/2hM39mma/sBT6FktkTPgy/yl7lfEdb6qOXrCrT/Bk
         +PuFBXLTnjUH+Mn+i7vSma5pe4dl0b17QLL6QhAUVCyaJ7xIYux0v+0iVomF+ZPBj+Bp
         lK0MAYIbQT3F39z94vOkB9KSGv9ux0Y3D2ydUZLAplKDXd0YKuOF0RvJs5sCUdNLQXBX
         B9dAaL7+p3lSNu6hCDzorDfGckU0nTbh81MyXQ4KId1dY1oLF2iva3ufgWxCq2MBTaVb
         Eab0wpq9tLu1TX0cupaNlzgob8SYLZqPLvVXeeet1UqATVkMZmTsEentLpDz5O8wp5bj
         +SYg==
X-Gm-Message-State: AC+VfDwa1J45BN0CYZ9o2SdCyMLUBfQrR4nmjC8UfAaEMCZlMBmHGjRL
        XyQ1Pks/6Dhq35oBpytGuMP4z0x5Bb48pHpQZVQ=
X-Google-Smtp-Source: ACHHUZ5UrV4hi5O/6LMa+K2IC4enXNSU1QB65baNOhQI4Dbf31VRFV6GxKRoFJmVZ2YWXa6VLgVOz9Zwgijsr2E2TM8=
X-Received: by 2002:a17:907:7250:b0:966:b4b:eb0 with SMTP id
 ds16-20020a170907725000b009660b4b0eb0mr16204250ejc.30.1683729908831; Wed, 10
 May 2023 07:45:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a502:0:b0:209:c5a4:ad9a with HTTP; Wed, 10 May 2023
 07:45:08 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <coulibalynina09@gmail.com>
Date:   Wed, 10 May 2023 07:45:08 -0700
Message-ID: <CABeZed5C11dsvw=2NbQ7UUJ2Gh+76eOMF2dUBv415mvjB_fQvw@mail.gmail.com>
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

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
