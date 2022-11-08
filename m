Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F030620E82
	for <lists+live-patching@lfdr.de>; Tue,  8 Nov 2022 12:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiKHLTR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Nov 2022 06:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbiKHLTQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Nov 2022 06:19:16 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C71F588
        for <live-patching@vger.kernel.org>; Tue,  8 Nov 2022 03:19:15 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id 63so11166603iov.8
        for <live-patching@vger.kernel.org>; Tue, 08 Nov 2022 03:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1oIX0Lu3jFWZXVxNPQntM2Fj3qbMNn8z1UsbYrWkRo=;
        b=jpbpbGjAvXIQHyD17Q6JzX0L+z8GowGw3Q/1gyT19s3DJ/JmitbEHW5mFMd2IgZBXm
         iWYaifYHFmcRRberh+xFLURxBZx/MMkyPHxGcKa4M58iUvbbymU5z5HjneBnETAUyRfX
         QwfYrqvBYKqlIT3JnPhsEIfglwbYVhYpIDAGUn8QQcHkvdUL66b7EbZwdQxEI1IeB3Zm
         rYyE2TMNVK/QmzbVr+ylbXJG6fe/mgDLpF9WOkmpypSSruRMZNCXa+fJhCw6s9LR+uEr
         0pLshlbiCC4ueCWpqpAYJXgqNwWglp0yjhNMjvImeiSpPG01UDSgK1xK+hs2xKbJwvCV
         1iIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1oIX0Lu3jFWZXVxNPQntM2Fj3qbMNn8z1UsbYrWkRo=;
        b=hwAzSDDEk5PJXNJSZ+1ml49LLkZfsOQYx9kXoeSurUCgCHIBkbPOSRpNffviUqxYku
         dTpEZiNdmkOhS5ee8WnRT9tCAEheqAFHegq6loxXmNpHJzFDDNvt6lWFPrNjl8OYvQTq
         4x/Pd7eYFpsn+2QzH6SkW5BlVxBH++Oh+7xhXakpsSlO1d8NV/FC+dYKCfT9YxTbM6xc
         9gDAuIOpIKqipzMu80a93oUi4530PVIjNgKF782gh2f8h6Lgg9UOSAD7CaeOL7R3lkKX
         vW6XCWuqced0dnrvBeXC7SxnYJuWvSA18BujYUGYunOd+Cv04SzzhqRP7laOOmekVuYj
         s3TQ==
X-Gm-Message-State: ACrzQf1XRZDLbx9RcFrooR1sqE1YAT3Q/EF7bzqolBVoPaxb85TZIEjM
        0g9lfE7o2V/Or/uy6phEop8VB0e1ar1RkjtxBNY=
X-Google-Smtp-Source: AMsMyM43oaxY7tKD8OjmHNKUf9iNz8BqPx7yMLWyWavV+zHxhllgs5YNKqOsXXiyiyiSR5fceAD8bKl/PRRyCENEIVc=
X-Received: by 2002:a05:6638:d84:b0:373:2ad5:232d with SMTP id
 l4-20020a0566380d8400b003732ad5232dmr32559065jaj.251.1667906354847; Tue, 08
 Nov 2022 03:19:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6638:38a9:b0:375:4a9b:180d with HTTP; Tue, 8 Nov 2022
 03:19:14 -0800 (PST)
Reply-To: mrinvest1010@gmail.com
From:   "K. A. Mr. Kairi" <ctocik1@gmail.com>
Date:   Tue, 8 Nov 2022 03:19:14 -0800
Message-ID: <CAKfr4JXxkL8EKNhgOoKtAwiNk4SuR=DBqdVGB7_Fe08E7RHLTQ@mail.gmail.com>
Subject: Re: My Response..
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d34 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5028]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrinvest1010[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ctocik1[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ctocik1[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

-- 
Dear

How are you with your family, I have a serious client, whom will be
interested to invest in your country, I got your Details through the
Investment Network and world Global Business directory.

Let me know, If you are interested for more details.....

Regards,
Andrew
