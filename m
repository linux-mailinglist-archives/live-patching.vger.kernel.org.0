Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26776867B3
	for <lists+live-patching@lfdr.de>; Wed,  1 Feb 2023 14:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjBAN5l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Feb 2023 08:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjBAN5i (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Feb 2023 08:57:38 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B432F5FF1
        for <live-patching@vger.kernel.org>; Wed,  1 Feb 2023 05:56:36 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id ud5so51659576ejc.4
        for <live-patching@vger.kernel.org>; Wed, 01 Feb 2023 05:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vXBxd/amqP8jRMvIMgs9B7l5mxQYDhnU3O7R1ZZ9/4=;
        b=ZtW1NqZutzuZzmUABylvmzkbsGVZvysJPPxYrPi3hG01OzadcuLScA0M/+ejBUHml1
         0GAIB7g+c78M+R7f5C+SS3kfZjoSKNpvwy6JUf647XTf5MVm08Wf83Ea1L3ER6V2ReF5
         XDyhLqV0NodQLrfJaX+TCbok4jUbsQRSrIAuczfmp6RxbOBxvcndwjSc2xHzSrleygcX
         FiPyVV+2+HVBTVotbhpNUySDoqDEk53ZO9kjZ/wTtsy0AqBKxYlkXcKlwEfTMpE4f4Gn
         UKmlknNUWwiZJfsbM1rZDlSTxrd20CchrrkCUwj5YUh118r3iIpmQLcca7J63oXYZzcp
         F4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vXBxd/amqP8jRMvIMgs9B7l5mxQYDhnU3O7R1ZZ9/4=;
        b=TnMYVP/1/QVR2zFK9PeKrrs6DhfBdBiClof5Y53wxEVk53OFi831qro1lDFdusGTYh
         SPt0Hp0NlpI3Lsq09J4Pu3JusQdU34Vln3/X3fXr9+hj6PcObFiQoQvirIGezS2am+lB
         rcFLOFRhUCXL5Wsw7IVQEWhah2xJy1Z8kfcitDG4lRri70N2Oo0e7lhQQoEND56s1M+R
         yvN0q9qRC0AXXBFEpONz30+pbk33NuuycXy9cCcs7ucCRAhLcrZ8eq9x9u7tlLej/UWl
         7WHC92yG3IgCBFMwlJR27uvxzEhjj4T0sRO3+5s0GhDQhBsuOi9Qj6DGbvxSpNxW8P1G
         T6zQ==
X-Gm-Message-State: AO0yUKUfCmIIfXgG1dB6e3AG7bexaVOxmEX3aA8Euv/dNXxfV/G9zRIw
        08oe1VKluE59s6l6NKNvfuXf4UstGjeMKluHo1Q=
X-Google-Smtp-Source: AK7set8Ij6y5gLodB6qoqWjNbU7lg/CqhGEktBwDl++KOJWWgn7XRD0a3aNcJY0VV4/iAnLFbz3BdMs9zY9SV4utP0Y=
X-Received: by 2002:a17:907:10d0:b0:878:7f94:9274 with SMTP id
 rv16-20020a17090710d000b008787f949274mr795329ejb.66.1675259788376; Wed, 01
 Feb 2023 05:56:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:20d5:b0:87b:59d1:9c07 with HTTP; Wed, 1 Feb 2023
 05:56:27 -0800 (PST)
Reply-To: a12u@c2.hu
From:   audu bello <tel802e@gmail.com>
Date:   Wed, 1 Feb 2023 14:56:27 +0100
Message-ID: <CA+byAN4inUbE2d51F+pNQYi7P_Lj9bvavVSbN4Hqq-JLQ3=oyA@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

-- 

I've reached out a couple times, but I haven't heard back. I'd
appreciate a response to my email about pending transaction
