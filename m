Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DD4578A2B
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbiGRTBr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 15:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiGRTBd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 15:01:33 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7D82F64F
        for <live-patching@vger.kernel.org>; Mon, 18 Jul 2022 12:01:25 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 7so4977056ybw.0
        for <live-patching@vger.kernel.org>; Mon, 18 Jul 2022 12:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=pnbDdnpvX4mYDYV5CRqaJvhzaSiMqOVFkErOQ5Pzifx8tuUa04IKy6n7IiCjzLXijk
         t2C76rNYwUIEG4lPN9Fjb6YY7tJXBQGvGitKajrJRjomWx0rYr1OaMuVH7CtK5jBV+7g
         eylU8JlvN7wg0OUvDjOCD8X0SSLVY7GRoxMVyLyFiKGN9qku4cN+f5NJ3VTmsjg79U4J
         IW7yA5T+dnMdFNGdpd73IQIX94c+RUM7ZfVVMvotD9zOfPtjLeS0j5oaOfj/ZyXtAofO
         JR+zPO4xaShzKsktqSwRx+++PgNHNh0awqGSmbMm2Flq/2iT6cBaq0fV/6Wp0ztl+XR7
         q8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=NkC4E2jXjj2A3TocmhQDaG62H+lKov92e96XCHc+SvTziAOnwLjfemIu7vU46Ffi2x
         ZteKqUWxcZG2VDAd68Rm6gWZZc9MvnGf2tl7b+goswwvgcDMPeiQtMWBPRmTnhibM/40
         N1p6ROp6Qa3JFmFdWdCLBTSPc7mLb6G8q1o26rm2D9J506OPvjDH+oAJgAJjI6Wk74u7
         v/wGMtT2Bh7tM627+tUSBjr3enY+hBb4IQvDjGPZw/gjl4O4p9uIDWlRgSXyp/Ext4on
         FslIeAUGvtgyp929Bpo2VYpvIh6D6oYqiN/AF2YBZj2lPpvm0/T+JnEm5WNSGBQojCwh
         GNYA==
X-Gm-Message-State: AJIora8XVT4KDBX3LBeq9tuRJ8qSiY5ndN5RdUMkAFmJfEx8Rvq5A8PU
        EKRLSSh/RL4Ty5vMfj1A2dTOKmz6WK93ZmEms/I=
X-Google-Smtp-Source: AGRyM1tA5Yi4Jod79cl5mqd3QT1aAEESagRMPNZOm5UwgHu2PzOvpiSRE97wxbp8RZLaAbTwGkibS3+yhRgIcwaBi5o=
X-Received: by 2002:a25:d690:0:b0:66e:c2fe:bebe with SMTP id
 n138-20020a25d690000000b0066ec2febebemr30019628ybg.198.1658170882261; Mon, 18
 Jul 2022 12:01:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6919:4004:b0:cc:50ff:b3d8 with HTTP; Mon, 18 Jul 2022
 12:01:21 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <sgtalberts@gmail.com>
Date:   Mon, 18 Jul 2022 11:01:21 -0800
Message-ID: <CALPTejNG_cfRDr18o1f6So9+eoAnXkgfd7AtP2kcvLLgsjrWFg@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Dear,

My name is Dr Lily William from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lily
