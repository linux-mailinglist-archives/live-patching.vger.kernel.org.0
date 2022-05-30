Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E8D537AF4
	for <lists+live-patching@lfdr.de>; Mon, 30 May 2022 15:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiE3NCD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 30 May 2022 09:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiE3NCB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 30 May 2022 09:02:01 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3061717E1C;
        Mon, 30 May 2022 06:02:00 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q203so11299583iod.0;
        Mon, 30 May 2022 06:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/nsX7tQgFVjCVndQ6RpFV7BObhww0aFphEST3Aew1pU=;
        b=aDBnKozUQpAbtuN5D/ooDBBqSx3Y+oo5MQ+1QeE2crNOB4+uZi4F8AFaQo9IURBPMv
         TVWtenQ8DPSkeu06Zak5ks2S0Dg84W67tc+vI5DtTswEgZk0k2+gKNpJrlE5EJbOodqG
         Vdxm0mdvIGW6kx8eUFHGJWjG24kkF6b+xVMNWdVNSCFR2Bmjq0viGo30qySCSC8imz1j
         5z4u2g9ZUnnau7guKEFPonzFCeCgumyuk0EIouAa59SVc8aqIe1q1Xtsd+OmaJdST0aP
         8BEyiBJL9ImKKd5CZTG7axLZNZNcTTOKhiZMNC0fAeljoM4c/Avg9Rhmy9lgOHrQzCx2
         JA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/nsX7tQgFVjCVndQ6RpFV7BObhww0aFphEST3Aew1pU=;
        b=79lmhcP105YbKJX1Hk/34Yo9ey9MeCwVB4u6uWwL/kMOLxkzFIwCWnvCH+0mN477vG
         KCW6bQG7yugO8SvKiSgDrbZ8AZazFEEK7c6QKRITk6VW0Ogi4Sl63RFJGh7wvYyTpp7U
         Ss6nEZ3O0vXpFPFu0zXYJ/gbXmtsiRB36qTLmwvHHQpZaW5exZZAHcdHIzueMIcyjIdZ
         R09Ndkb2MIvTTVCpTOEyA01GaMBaEcLBeKg+bkWEnt+iYq/zmcKTTObyBg4zAYSNJlwX
         /ho8Tk3UmI8ZeEUvmc69sy8wavfJ7FGwopOkhcHGgDIAJXppukDc7aAKB0KDgkJmShmG
         iaKg==
X-Gm-Message-State: AOAM53173F8XARlvS0wlmU8bg6jwagNgORAzswyymofaIUxlbb9LFhWg
        D+TUcHj7ahVJMuvEBPc4kZwI08mmhqn1XjBGNr8=
X-Google-Smtp-Source: ABdhPJz/KcdushmmWd5Wmx13C1o+XFxVQFOFTt9BakFoqOPc639maIlLVqG2CA9llEfhnfiqOLefeStVd6eXaJtnvLM=
X-Received: by 2002:a05:6638:f89:b0:32e:89f4:e150 with SMTP id
 h9-20020a0566380f8900b0032e89f4e150mr27709726jal.308.1653915717905; Mon, 30
 May 2022 06:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220523020209.11810-1-ojeda@kernel.org> <20220523020209.11810-4-ojeda@kernel.org>
 <YovvIQeN3lmOYzJO@kernel.org> <CANiq72m6ttD9QpB3nW-5B+M1seknv0GZ4-DqtF85qTg6Lvxnhg@mail.gmail.com>
 <459385ee7ccf4fcf3e22d4a11b4f438d648422bf.camel@kernel.org>
In-Reply-To: <459385ee7ccf4fcf3e22d4a11b4f438d648422bf.camel@kernel.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 30 May 2022 15:01:47 +0200
Message-ID: <CANiq72=TmWvVUR8yAAU-oT9=TdYPJC0sGxEBv4aVKBHKdEOjJg@mail.gmail.com>
Subject: Re: [PATCH v7 03/25] kallsyms: increase maximum kernel symbol length
 to 512
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
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

On Fri, May 27, 2022 at 6:27 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> The honest answer: I don't actually remember what I was thinking
> (other stuff stole my focus) but my comment neither makes much
> sense to me. Please just ignore it, and apologies for causing
> confusion.

No apologies needed!

> There's something I'm looking into in my spare time right now.
> I'm experimenting with interfacing keyring types to Rust. The
> first step, I guess, is to provide a Rust abstraction for
> assoc_array.
>
> I've skimmed through the patch set and have now *rough* idea of
> patterns and techniques. My opens are more on the process side
> of things since there's no yet mainline subtree.

Thanks a lot for taking a look and taking the initiative.

> If I send a patch or patch sets, would this be a good workflow:
>
> 1. RFC tag.
> 2. In the cover letter denote the patch set version, which was
>    used the baseline.

Sounds good to me. Alternatively, you can use a `--base=` pointing to
one of the commits in our `rust` branch.

Cheers,
Miguel
