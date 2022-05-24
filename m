Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41908533012
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 20:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbiEXSIL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 May 2022 14:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiEXSIK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 May 2022 14:08:10 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC856B02B;
        Tue, 24 May 2022 11:08:09 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p74so15507503iod.8;
        Tue, 24 May 2022 11:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CCoZCqf5DZYvmFYZUo768NlduYJytxgbzyAhxTX5D1U=;
        b=q2dwl0J2dE5Opv7iwInHFK6zBnH929Y3nD3A6TYfLHOnbC9AvRSf7PDJj7QYG6I75l
         Oe82wo/Q91vqQ0OLGuTqXlgbuF8R4iCcGz6gIvUenR20l91PHKo7quUeDLTt1QoivWqm
         ZSL5LUEQgRpqJBYCo3Iti7C/2Gb2deSsPqdedmJKeywIP4FOwZjMwXwV0++1jrLR7M64
         hDblFWjeRmC9ycbkg0SFEgxiGjQxYY2+rK0KeqxUuq3CzHBLko+5krfiMUscD5WErVsG
         TSGcWGfR9cO5n3x0u2Qdu9i/m9XY7j+cFqU4PbOT9ir+2GBaiX3lmyGPhtAR7N5Ge8Sw
         lh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CCoZCqf5DZYvmFYZUo768NlduYJytxgbzyAhxTX5D1U=;
        b=h6NRsVSQ5KTU9NeJWo8qYXMV1+BnlP76hfGm42KhiNgL34QL9RhB9FGsN7uJsWWFWM
         i1vSovRBShKRP7VW10nip+xK83wHFBskpc7hNEWV4bMI2s9tz6tVWYUbKEi83jGEOwsp
         QzfKTuAnP/CCr1NfvoO1qi/qr5K78K2RoM+Wh69o01anzldI/Y3j5RmtZCy4iDkeTNIJ
         d1Q+tp1hsJcEln7fa8g1QB3/eKWb0hsuQZ4UzkquebhOfADTPBZ2o+BU3onwT3Sy+GWq
         RoWVHqGOrEhd0YwkdACEOkYMMAB6OS+G4g9VM0x+xWGhp4zpmkc7UiThGBQLomNOfTrT
         vEUA==
X-Gm-Message-State: AOAM5317hINu+kvCLsM8Wk2UZEUu+NJMqAmphk1e2ZO+rZdzgkbLGCPi
        /VwWy14VjmjP/KW+QYcXXTYg0a9iISZAiACtEf17p8dN+eA=
X-Google-Smtp-Source: ABdhPJwvMP45iKh6ctuzwjBEHsLMCZ2t2DJi6jHsM/Qh2syL2Byl+RUOpcjkYiO4u9890rA2qvaWtrRoh3wi4zvrHZk=
X-Received: by 2002:a05:6638:22c3:b0:32e:ac50:aeb3 with SMTP id
 j3-20020a05663822c300b0032eac50aeb3mr9147129jat.186.1653415688617; Tue, 24
 May 2022 11:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220523020209.11810-1-ojeda@kernel.org> <20220523020209.11810-4-ojeda@kernel.org>
 <YovvIQeN3lmOYzJO@kernel.org>
In-Reply-To: <YovvIQeN3lmOYzJO@kernel.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 24 May 2022 20:07:57 +0200
Message-ID: <CANiq72m6ttD9QpB3nW-5B+M1seknv0GZ4-DqtF85qTg6Lvxnhg@mail.gmail.com>
Subject: Re: [PATCH v7 03/25] kallsyms: increase maximum kernel symbol length
 to 512
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rust-for-linux <rust-for-linux@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
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

On Mon, May 23, 2022 at 10:33 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> There's no description what the patch does.

I am not sure what you mean. Both the subject and the last paragraph
describe what the patch does, while the rest gives the rationale
behind it.

Cheers,
Miguel
