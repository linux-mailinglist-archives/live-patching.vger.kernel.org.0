Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E545574AFE6
	for <lists+live-patching@lfdr.de>; Fri,  7 Jul 2023 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjGGLeZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Jul 2023 07:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjGGLeY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Jul 2023 07:34:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60429E
        for <live-patching@vger.kernel.org>; Fri,  7 Jul 2023 04:34:23 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b6ef64342aso27786301fa.3
        for <live-patching@vger.kernel.org>; Fri, 07 Jul 2023 04:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688729662; x=1691321662;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HB1ZBmrI8lJQ2iZKSS1/QjY2dlcegRSejhR78gpSgws=;
        b=fesoF8e5faReTdBi4hjlI1+OvTvH5vK6l0maJFmWIuyW8hrBMJ4tD1TvCP0DLGzrrf
         m8Ibb3T71RJ8V3+85cAuWx1DNPgbR/sQjKhODAUcuFpgamJvWLIcMw9IWm8ll+MoJXiz
         WE4+0MjUDpmzPXYgnjILkvjzXgN2S/dq+wEHEFRdxS3rzalHnAKc6syJrRPi6tATsh2F
         Mcq7n4rzcAB5AxPc1WruPJW7sj/q3R9g9bZRJqAhjGWGuBcWvx8YhA3rwAbUr1YAGPB6
         ab2tjy1VsbjPWU8jUoNvXSrtq3iU4YSbZIp04EL/coy4LOr6RdFYlpHbfL4ovlxLwg2E
         q/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688729662; x=1691321662;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HB1ZBmrI8lJQ2iZKSS1/QjY2dlcegRSejhR78gpSgws=;
        b=kwMub51T8+p+In0M9vn6ra1egm6Jw/sagCC5JBfjkavIrNGvzed8A/5OPG+M39famC
         r0HhxdxIibnTApxZCDfHLXGs9pfl22G4epYG/7i1WOQPmEF5pimlpLVn/rnTclBDUQs4
         YJlQ/uwOwnmEsGQCbIXIBQLeG18zqlGtNvNkaWQv87Z03aQrkN4s1T5UjKX5Qem3g86V
         RFnP5QJF3LFnvmqdM3JtjSD4MPnltd5mxpI/RFFFyLHc+IwM8EV7cpU9NfnX5ggmLd9p
         Xakq+ppBWiJh4fb0qP5YrCQ8Hsk4LA9rFzUAnkvkATT6ichU698qhHWlnFNR7sfmse3F
         x5Nw==
X-Gm-Message-State: ABy/qLbdf6QauD2S//ihWseLU+v38AaeHHdxWishF1N8BGYK2n8ErX/c
        EiEfBscHMX3oiXuez3bWNlJn7VjbHpZIsOXtepg=
X-Google-Smtp-Source: APBJJlFvgE3XPnl2pUBXl+hLSjdn/0Ad0xrMugh3YZzi7Rv91sGAhmEDZHbsWpOE8CB+gBnDdLXFx8im1wGUMSO7pCg=
X-Received: by 2002:a2e:9455:0:b0:2b7:29b:d5a5 with SMTP id
 o21-20020a2e9455000000b002b7029bd5a5mr3486874ljh.34.1688729661530; Fri, 07
 Jul 2023 04:34:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dr.attorney25@gmail.com
Sender: mmbbr2019@gmail.com
Received: by 2002:a05:6022:338e:b0:42:f7b5:db61 with HTTP; Fri, 7 Jul 2023
 04:34:21 -0700 (PDT)
From:   Benjamin Addy <dr.attorney25@gmail.com>
Date:   Thu, 6 Jul 2023 23:34:21 -1200
X-Google-Sender-Auth: sjafDie3qXFW8YljWVASBZDYATI
Message-ID: <CAD7Yj0674WSF0FRzr1i82OVOQ702Nvg-QKytDFGqDjSMA+WvZw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HK_RANDOM_ENVFROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello
I sent you an email earlier.
Please confirm if you received
Yours sincerely
Dr Ben
