Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637724BF84B
	for <lists+live-patching@lfdr.de>; Tue, 22 Feb 2022 13:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiBVMqX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 07:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiBVMqW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 07:46:22 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D407122F69;
        Tue, 22 Feb 2022 04:45:57 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id m185so19907419iof.10;
        Tue, 22 Feb 2022 04:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U1ifEzLtc0/IOyR4lb+9b3bafVQrz8ZMVMZkGpwnl1U=;
        b=i76dJOhkFq8SztC0GExmH1uRM2VwnD7q2OJnYWUJU/iF0PQU+x9lrc3+EmWBIFcGvL
         J1bhvCIwvsnv+r5jvgSqbWFNMzDQi/fkoyfBpOyJlh7Yd3OwL8RlFsTO9YPJUbt9TmPx
         9K4jZ+1tBdveWtBI0GJ5mEstrDASH6hsW4eaNCN3RVMymoTMdyMgeh1+JVS66iPXCwKv
         PSwkKY8DdQIgLwZ7JwzxiIRu5wv49ZvFlxl98BuUdYd7rJHfJXzRxoccaxOK0erxR0fn
         D5StrbL3o33jb/PnhcccOqu5oxyQ/iBagDoHrFPRR9YBWaPVc40IjlzQOdYdziGOtRSM
         d2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U1ifEzLtc0/IOyR4lb+9b3bafVQrz8ZMVMZkGpwnl1U=;
        b=iwYli7yqnl8OD+RMOA+ZlsUmNPerlGqhOkg/HA4cTBDPlJvLMi/9R/7MVjtWZDkEaC
         ffsTTmnYQZIO42BP4HalnzpRmQrDs9WWXUO3XaQVLIACzWmvt4JKwmwItLfVnv70EX7h
         b+keZTZzu3ypUsjTRbMFb1gzimTCUi9dl8g89UcUHHwj5lsX6fs1Sirt9JDhc+7vqbgR
         BuR0p0aFojHl0oTbL6Q0TtJV7hsYEl+Z42SJwQ7pzjhiCj5wvnELY1k9gJo+vnoAMUFV
         T101J66zda79/4aglzi7Y4k5HHoYt6LTCVBnRE0ooFT6YtCqp2XO7Nsk/wh3ybh6XZJU
         e0jg==
X-Gm-Message-State: AOAM533eBCdFqsZSNHtIwd0PIBvDVcOgfaaAnRY3sLz3hpVgbf3FJcC4
        a+LrFIh3b5jdAcFFcEzTTLJzvLGRaVU9h5LuRXU=
X-Google-Smtp-Source: ABdhPJymHE6i7ESiN393PHVS6YIBpky1wMcpujNvwpJKoPffDiP/DnwSThAkfeJCZxjFtj2rDCsPAcGB3UOwdk7NQ0g=
X-Received: by 2002:a5e:9248:0:b0:640:70ff:4e28 with SMTP id
 z8-20020a5e9248000000b0064070ff4e28mr17211058iop.44.1645533956554; Tue, 22
 Feb 2022 04:45:56 -0800 (PST)
MIME-Version: 1.0
References: <20220212130410.6901-1-ojeda@kernel.org> <20220212130410.6901-3-ojeda@kernel.org>
 <YhScgnV+n7w75WH7@alley>
In-Reply-To: <YhScgnV+n7w75WH7@alley>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 22 Feb 2022 13:45:45 +0100
Message-ID: <CANiq72m77SNEGfxz4Ggi6Uth1-7NsDvT9D1XbCFByYHne1x6Cw@mail.gmail.com>
Subject: Re: [PATCH v4 02/20] kallsyms: increase maximum kernel symbol length
 to 512
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rust-for-linux <rust-for-linux@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        live-patching@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On Tue, Feb 22, 2022 at 9:19 AM Petr Mladek <pmladek@suse.com> wrote:
>
> The livepatch selftest still pass. Feel free to add:
>
> Tested-by: Petr Mladek <pmladek@suse.com>       # livepatch
> Acked-by: Petr Mladek <pmladek@suse.com>        # livepatch

Thanks a lot for the test, Petr! I will add the tags.

Cheers,
Miguel
