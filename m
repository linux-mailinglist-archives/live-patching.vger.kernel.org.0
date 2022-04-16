Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E72E5034D3
	for <lists+live-patching@lfdr.de>; Sat, 16 Apr 2022 09:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiDPHw7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 16 Apr 2022 03:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiDPHwa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 16 Apr 2022 03:52:30 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C794289A1
        for <live-patching@vger.kernel.org>; Sat, 16 Apr 2022 00:49:48 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id a11so7148637qtb.12
        for <live-patching@vger.kernel.org>; Sat, 16 Apr 2022 00:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=HZfZeLmVOMokRr7TB0HNH09zKqyGhCcsk0PlUzEKmtFlVBNpkZwF9wIj/B2xXPxp6k
         YY9aBbamXAZyCRBrmOYZspz8K6b2gF261LRzuwCsISEcNHeYmMTgRSRbSuZht4gKtsXj
         VR+UyF40DZrKhxqsUUuCXUuijysBtsqW4sM0W9eLwOq5PsH7FRlUzXu8Cw6mP6IpEM6M
         3fAKWiPBttqd+K+hNX/FykzIcUMZtvmQncu0RdTg81rjByoDYCfHBSmFuGV3PEWaFpwI
         tdvJvL4gLUm4rgKE4HDU9HXjUDgAMUrsNaVJXyrdwfALokVihyDfHlKVc/5WjjZcuju/
         sbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=B+hu4h+WDudzvtw00wXCEhJWxvhqcZOtn5Xrg3aRiG2A+6n6CEGRfNeta2leQdS0eo
         1rw10X7l/4eaVwmGUbGoSGuvyx+NXQoxN0n/OfE1kA/FK+Ea759kPHXA5TgRNcGoAadA
         979FtBEmJMqd0c7W7zsi0oHUkDaQzANNKuEW2QzaSf8YeMUl9a3kFVtYJ4QIgv/ygShB
         MEJ6cHF2n/2im3e2hbRrZZPWB6KNFFwK8hhVhcLg+6AiNaHPndgBhzKfHtaZW+canF3L
         JtBCegFmvQNrchRkZbsUMFzsTU+BooO6jHAnLB69UtJrVSogqB54rybIinVm7YGOQewo
         T4Vg==
X-Gm-Message-State: AOAM531UXp3B99XiZuSx3bWT/LJ/lNwgBPtvdAu9qU37h8gdc+oxD5SM
        3PxdWyzhd1ww6QDJGD4LSbkgxuDLXp8A6HVktpJoy8vz1xo=
X-Google-Smtp-Source: ABdhPJyqPyIIDwOMiNzFJhSkDqZ/6iH94Womg2Hy8BQP2BbjUwF1UVS7o6Bseq+AYg+HRInV0sp6+4kQ3BaPCAWRw/8=
X-Received: by 2002:a02:7781:0:b0:326:5eb2:eee5 with SMTP id
 g123-20020a027781000000b003265eb2eee5mr1252275jac.74.1650095377314; Sat, 16
 Apr 2022 00:49:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:1309:0:0:0:0 with HTTP; Sat, 16 Apr 2022 00:49:36
 -0700 (PDT)
Reply-To: daniel.seyba@yahoo.com
From:   Seyba Daniel <royhalton13@gmail.com>
Date:   Sat, 16 Apr 2022 09:49:36 +0200
Message-ID: <CALSxb2y=RX-gk5HjSyih7bSQp1zZmVbBzT+ob_ptsuH8L9eeFQ@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:844 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [royhalton13[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [royhalton13[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel
