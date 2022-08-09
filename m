Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2974A58E2C4
	for <lists+live-patching@lfdr.de>; Wed, 10 Aug 2022 00:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiHIWOg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Aug 2022 18:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiHIWON (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Aug 2022 18:14:13 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB262180A
        for <live-patching@vger.kernel.org>; Tue,  9 Aug 2022 15:14:10 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h132so12615294pgc.10
        for <live-patching@vger.kernel.org>; Tue, 09 Aug 2022 15:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=GI1h58u9NHz7rI/vIwOU5DkUcoHPmL+b4tk5i/xxv5Y=;
        b=ivqN4vSJlNq3W7Ij26QrIYQgAAbtzyHhDYgw3RI00F2cloUUAUm1JYijh5lnVLZz9X
         KEPDDh7bdWa1YzGCMq3rF5HWsdwHmNIt4v2RqnnIC403AhoSTQSvHrH7MN2le6CkrZFG
         ysSBq5H6/K3AVV6jphpr2A3SndC89d4vobBGvrKiJ2xBte572I0erbzkxTvb4Rhtxl/R
         o6wgsR5HVxWZAEARh9y4T49iEtP/fEiaQ/misNzyfCGXgRfs2Yh4I523LV0IIz7ntNsg
         Gco+yBVtROP/gqliwfG1I0YwuFQ8In1vAUSW6InpgUI/rfaiKM+1olV8CVOTLXeN5fBU
         Zsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=GI1h58u9NHz7rI/vIwOU5DkUcoHPmL+b4tk5i/xxv5Y=;
        b=OC9NQ0K8MSKny2e4vUXPt43hgvaRsL/M9DRhm7X3Co8JdNhC7IECjNtn4zUuHBz3/q
         IsJ8gaHwPcU5fqK+NW4Qc0xI622sqBrisfT581K1QtsRuEjVkt/CSPgj5cgiHJY18Nq7
         iDwojae91UtQpGgmOjh85XJ5GZ134N+tems+ZxnZW0wKLpa8U7fXHPOGPhB+CDGaDXP1
         /pEFFU01/3cPSLwLAhswAb2nDJGhlX+8TRYWB71LZ4ERx0o5G3EfPT1BLvh0BX994MF1
         gb/xXlcFZbshgdjYP0rNJIH+etScdzs55gBKBQJaYgbRcPSL+VWtR9l6TtCkygPTTiYG
         +QOA==
X-Gm-Message-State: ACgBeo1LuiffPASLknmDIVdD3w6UQflVqKQRaX+Q/lP36BVXcPAwP45W
        5Q87wgAuGjL0lNSDWmHZ+7T9TrUCyIZa3VCe4iM=
X-Google-Smtp-Source: AA6agR5fl3xc+UV0ZHc2SfL8VObnywBaeZVGbrjxrZgZGluYIhW0MPTo1IgOdbEfcNZPHqlB0PyO0dDmsiocwlLFxa8=
X-Received: by 2002:a63:69c7:0:b0:41c:590a:62dc with SMTP id
 e190-20020a6369c7000000b0041c590a62dcmr20010492pgc.388.1660083250233; Tue, 09
 Aug 2022 15:14:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e8a6:b0:2d4:fb1c:cc5e with HTTP; Tue, 9 Aug 2022
 15:14:09 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Dr. Ali Moses" <alimoses07@gmail.com>
Date:   Tue, 9 Aug 2022 15:14:09 -0700
Message-ID: <CADWzZe6trnhQMTzAwxVoNzTO4rSHFXia7QSZSOi6=gxZb77E-Q@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:534 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alimoses07[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [alimoses07[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

-- 
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

My regards,
Dr. Ali Moses..

Sincerely,
Prof. Chin Guang
