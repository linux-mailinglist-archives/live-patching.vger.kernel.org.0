Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F376211F1
	for <lists+live-patching@lfdr.de>; Tue,  8 Nov 2022 14:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiKHNFc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Nov 2022 08:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbiKHNFa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Nov 2022 08:05:30 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8377D25DF
        for <live-patching@vger.kernel.org>; Tue,  8 Nov 2022 05:05:28 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so8317300oti.5
        for <live-patching@vger.kernel.org>; Tue, 08 Nov 2022 05:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=SsoWGzaAxW5v98CEmuNXLe2Ne4BmcvWD8yXMU3oo7Na0kaYvMekMI+TxdsevX1GZLl
         /Zs4Xk8IQUSMPGCEULp+go/iHgjnMzlRBQApej4GbyQqTXYVzYkHcryCsbiCEmn5t72V
         cAaJRZkAbIYG7lXAh52Yxi/QHadqrpFQFFsE5iSIw9vWHD149SXMpUp6a7XDoxxPBpjd
         4d8FuyURa+2YkRCizgdFygr5pzNsLQF1PXnv2NuN5tVY8TfB79w6SAwf3IBkb8cseLCg
         jf7jUyr8Jl94ibko78rOp0cZAp1T7IneC7UBOO0T1Mi2sPmFmmiGV7XmeK6kDES0u1qL
         gWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=CHNysIyYhSwvvEVJzbpnM8KELHNm1LWvdpAQVQofBx8Ei/sXzWWKGiYHNNkhM3qlTE
         opPqR1+9Jh3bSiL+d0/dwpmtoaCw2wyhVDu3SC6B9HjB9cbgWrbEDtWf06G02w6RBfdn
         51cZekVdJ/mmRslHJ+QteErT4QCPdtJI62Hn0mw5TFsp44vCoDK3m1Lg9oMXfsppi/ip
         PIa86ohf9SGBM+RXIJun3Qgqmf1Gp2JyI8T2cym33vXqPZ5G/YIE2aMX3y0L0LPZElhe
         uBvUjAPe5X/dOjgBQEsaCOnnxmR7auRrrMmNIavI/O1zrBJYJejoNFOIIDNWiiIiWf6M
         +j/g==
X-Gm-Message-State: ACrzQf3OehovuB5R+hf9Y7bi3Q4w8gDVGbP38VO4dowvucD/hjn7DWo8
        EKCx8W5DEg6hFE4aXFCOgftcKONFa5yh8KWYCFA=
X-Google-Smtp-Source: AMsMyM4CCqScQPLhOdfNtNAowZ8EgxipH3RzLtL0fH3xxOFtE43Xwxzs2wzjrA8C4ntK7rUYGIAy4QlqVr7Tz3jX5N4=
X-Received: by 2002:a05:6830:71b:b0:66c:4f88:f417 with SMTP id
 y27-20020a056830071b00b0066c4f88f417mr23641207ots.253.1667912727723; Tue, 08
 Nov 2022 05:05:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6840:5eaa:b0:f64:bedc:f7d1 with HTTP; Tue, 8 Nov 2022
 05:05:27 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <davidkekeli001@gmail.com>
Date:   Tue, 8 Nov 2022 13:05:27 +0000
Message-ID: <CAD7994fFNvUxit=ndT6gYGEPgBY0TKG-sTOP=XPGTZBTYVmV7w@mail.gmail.com>
Subject: Greeting
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:344 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4997]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.abraham022[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [davidkekeli001[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [davidkekeli001[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
