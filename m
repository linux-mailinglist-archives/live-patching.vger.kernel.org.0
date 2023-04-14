Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9740B6E2B1A
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 22:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjDNU3f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 16:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDNU3d (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 16:29:33 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25E36A6F
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 13:29:31 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q5so22999500ybk.7
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 13:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681504171; x=1684096171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0e8yJkZMGR8jvDA4uJJWuPSQfvmcArS3FdrhD+Y85so=;
        b=UYl0g8iyf5fhCVkNpfq1ACibfhBUBgZSnxaxuvC2r9jSAfQfKtOkq9+25DdeT6OonY
         j1nPQa5szSjPc38VrTYTRUZGP86CFELv8dYgdO+pixH1+GwRLdfeAsz0+OxfEfT0+7Zj
         fuAa9Z+VHW7XwS08YbmOuD9FzjX4vwRwaYDxWda649cqKvGn9fFI4V6sUf91m3PU/h/Z
         wO7n3gRH3FWRIx3n9cYvM2JbepUxYC7H58yAiKVXTB3JCZak/nyjoiLcemopf/4OboAl
         yvvycYo6xyCJuXqaDGcoo3RX8qTHKmjO62686ZJP5E0hpfGtmtFIJV3CXrLE4Yis1VU5
         m6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681504171; x=1684096171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0e8yJkZMGR8jvDA4uJJWuPSQfvmcArS3FdrhD+Y85so=;
        b=Td/hDgpnHm3Mu5mvnU3Pr0mDd3IL/9JPr+og6jyuMCFKyfnRYnf49lqvHdhtkiTFF7
         SZhAdZcS0yfNxhnIkBJ9btEjM8NxT1DfvOY8tYjAwRls9sWnzHKfCk0ZQFzVmY6HDvIp
         uT5XtRezZK29UqlFJNqvbnWuZB+WutoY+RpRbtM/VFfyUn4xH+ERhJxxPfjNx/zW2Eiq
         BiwouEdKe7AC3AxUAgoXwc5tu4OjGXndYNoblU8lUasG3mx+/2+/aj9eHUGm+JFU48+7
         MUeXaYTrtp4plA5XQAKZrLOpDhl1WN76mthV7IRpinJubd64G2vdwcPjjyrnJ35BA28V
         8dPA==
X-Gm-Message-State: AAQBX9cFLxSOBAlBiROxOqsYnpfddMhQbcdUjq0VFSrwyI+eywJHhRJ4
        lJ2YoX9rdpFtoYxgHhkRqgyPll7EcVKYbzV1Lf5tnjzkUBA=
X-Google-Smtp-Source: AKy350Zu6XIO1FNoBGFjv6x8UL2/cZyc+lK75P8oxX3y3oxm6IYz6PRjXmS3t2lWNiHCSl94PqVmkukqUqKqnL4HmWc=
X-Received: by 2002:a25:d6d8:0:b0:b8f:5680:7d99 with SMTP id
 n207-20020a25d6d8000000b00b8f56807d99mr4513212ybg.11.1681504171111; Fri, 14
 Apr 2023 13:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> <20230414171255.oylmsdizl4waao4t@treble>
 <CANiq72mWVwNfbCiKWdyyX=LXMrXsndO6gnwz_0tgVRt9Nk1KzA@mail.gmail.com> <F9956FA2-BF3E-40D1-AE2A-8F83C83EE72D@gmail.com>
In-Reply-To: <F9956FA2-BF3E-40D1-AE2A-8F83C83EE72D@gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 14 Apr 2023 22:29:20 +0200
Message-ID: <CANiq72m+F+CY8JLvGSjut6JXp1QAcR=92W=e6OMkQZD=HEWCEg@mail.gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 14, 2023 at 10:22=E2=80=AFPM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> That part should be dealt with the recently released pahole 1.25:
>
> https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=3Dc4eb1=
897d1f3841d291ee39dc969c4212750cf2c
> https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=3D1231b=
6b9b4d88e0084bef4254eb1a05eb9935c99
>
> But there are more issues, I'll resume work on Rust soon, after a detour =
on Go, and I think the changes made for Go make the DWARF loading more robu=
st and may even have helped with Rust already:
>
> https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?h=3Dnext&i=
d=3D31bc0d7410572f6e03e3ed9da7c8c6f0d8df23c8

Thanks Arnaldo! On my side, I still have to come back to `pahole` (for
the test cases).

Cheers,
Miguel
