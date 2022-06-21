Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3965552EC0
	for <lists+live-patching@lfdr.de>; Tue, 21 Jun 2022 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349342AbiFUJlG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jun 2022 05:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349359AbiFUJkS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jun 2022 05:40:18 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F327275FD
        for <live-patching@vger.kernel.org>; Tue, 21 Jun 2022 02:40:10 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id w6so23509254ybl.4
        for <live-patching@vger.kernel.org>; Tue, 21 Jun 2022 02:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/0bRExIb6Mv4sy5raFRmeQINC+UUx7zEZcUUOWWOPJg=;
        b=cmkSEiLqO1fNUDEP3rNf5qOPjvJRVW8Jm83aEefNEuwXOV90scHGX5U9YVGaA25ck8
         cC+HCEsrwzgo9tGelTkzvyDlqj5DtvuaEczQ/1sW4D1spUwtKiCMDeXClTTyturEjCEn
         siMi6mLDh3fnSK+t+YhUfx/GBy+7zNR/vRSSrF52NDY7pKynY9P64zu2FiVBf5ojEIO8
         nkRoSKTXoBIrQON+opIkdf60olGYi9ZOlA5xgezkK3rtV7o2+WcH/94YcHw4Jo0EyN91
         tmM7af4D9Qb94rEqzUznzHJ5QJXDuJ1Myj7LVS7xKj7KhnfoRg9SKDywqVEXBFUV+dv4
         LzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/0bRExIb6Mv4sy5raFRmeQINC+UUx7zEZcUUOWWOPJg=;
        b=ZT1cWnoQC8DX8Q6RaqWU3UOUFVwTwl364sf57v6dgrhVaQwpbZVVXTUz/onekY1MUZ
         2eM/MFLt8i+XUaiCnlR83OsOt96Jx7wjbXidNEsUX25exrMma3poLPHM/AoOyWcwR2fA
         nUIfxl3p0zSWObAPLPG5RfytoFsdqiMmyZlP/WmyQk7voak20YRkyseyQ3P3S5JhIVhr
         3dTqaBYB3Y9Rm6N8R/BNOw1uKwE0dfjjzytqhHuqABzLtR/x346d1pU9AqxCi/4t0ofr
         wT3twLpzPu6gSSupHnrHNPVeRkkCgtCYJGaZ9esESlVOeJtaGF1gY3T9r2oPrTZO+YmI
         zjzw==
X-Gm-Message-State: AJIora9Irs0+y53HyxQ3+179Q7LPzvAWrGgOkhNx38M8us9z2fhjb63V
        djqMWVpuxPfThbot3J23081J00cSyvvRWi70p2k=
X-Google-Smtp-Source: AGRyM1uV1dvLUR6M2cOcJUgpPFVz0orNusRBYRVuJPJS7zFnkSzPFV/GCTOzWjVLI/IcKao/fyoMFxfXMDOdlGHxvvk=
X-Received: by 2002:a25:9bc4:0:b0:669:5116:533b with SMTP id
 w4-20020a259bc4000000b006695116533bmr2071597ybo.537.1655804409953; Tue, 21
 Jun 2022 02:40:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:e10a:b0:2d9:e631:94d0 with HTTP; Tue, 21 Jun 2022
 02:40:09 -0700 (PDT)
Reply-To: dimitryedik@gmail.com
From:   Dimitry Edik <lsbthdwrds@gmail.com>
Date:   Tue, 21 Jun 2022 02:40:09 -0700
Message-ID: <CAGrL05aozO8RFMsJYXUFqF0K0Rv0usAQ2Q23=4A-m9Uqdq80mQ@mail.gmail.com>
Subject: Dear Partner,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b33 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lsbthdwrds[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello Dear,

My Name is Dimitry Edik from Russia A special assistance to my Russia
boss who deals in oil import and export He was killed by the Ukraine
soldiers at the border side. He supplied
oil to the Philippines company and he was paid over 90 per cent of the
transaction and the remaining $18.6 Million dollars have been paid into a
Taiwan bank in the Philippines..i want a partner that will assist me
with the claims. Is a (DEAL ) 40% for you and 60% for me
I have all information for the claims.
Kindly read and reply to me back is 100 per cent risk-free

Yours Sincerely
Dimitry Edik
