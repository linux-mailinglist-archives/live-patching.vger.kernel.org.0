Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018A36E2A69
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 21:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjDNTEu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 15:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDNTEt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 15:04:49 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DFCE77
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 12:04:48 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id r184so3990913ybc.1
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 12:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681499087; x=1684091087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tt9OSuzUProwBkcQGWXzT0w76UeMdk2H/BGIzjeqp+M=;
        b=pz5CouZW8nYnSeU3XmSDGf/Y4B11KPW+hqHa8ou3BWVFb69kkf22/HkoubTaz8YEz1
         KIoFVTxE8ms7L9K/Zs2kZDsMqK6EWMDk90lq6T3UznZchihmbj04DYYE3t67UB2mOcWO
         HhEeuU6djEopv1yWLubpH0Pe1+LDJ3qCZ0KooLYd0RZL6l0BqeDPG5Ua6bL0PgdtBU1f
         P9fU2K4WeRtRDNKYvFBz6YKQ2opYwXKMGvjB5gnMQgGC+4eQWd0Bb81RY5qHHmsa5L+a
         swJzSKXyGlLiFAZYUKEM4HNFtPVTx6vmZNT8KZ6OM2smpy+W6FTGIFtEp52LxO4hPaJU
         tBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681499087; x=1684091087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tt9OSuzUProwBkcQGWXzT0w76UeMdk2H/BGIzjeqp+M=;
        b=fGeYD2rcPzyG6o9Uns+0A4UrWLzt9YTi4O1/JeLrro8gV8RqgXnCL/GmbmZPm2Mc7U
         9gSVBUKo86dp6sYqFqNL8M7y+4xvGQED4Ngb90MHOxt6M3zOZ/yd19yNzIAzVaUEpv/I
         OvAEc9lrrDNkB3CU7x/IF6cZPMPDdCi2E/awm4BN41heGQrAvcuyIK4MLEh/gdP6735f
         uYcv167DM5cHSGQioK3rXlefqWNtcVb/0CTxHw6WI0St/GVHPNTHPE5XWpckhhi0raGO
         6FGYZ9ytpeSyHnjC6GSJP5AG0sCxEp95a/bGd4WIJgzccO/F7ZL2EQnAjkLWeC0lW7FH
         k5GA==
X-Gm-Message-State: AAQBX9fbtqPN/gqBEhLsWYTqb+Oviz7faYV5+7RV5u8wrTF5msWiqxpj
        aNrwviKdtxE8mp5P2HClww5jXyD7b9joSeRqLns=
X-Google-Smtp-Source: AKy350ZScO03X0ssl+pqnSBfwlmKZ6L7phE8PYlPLD3IVn6cDH/CvC6PWGYlg1uiWY+oTsDcGP6Md+TUkRJ0+sL5cPk=
X-Received: by 2002:a25:da89:0:b0:b8f:4f1d:be06 with SMTP id
 n131-20020a25da89000000b00b8f4f1dbe06mr4499252ybf.11.1681499087383; Fri, 14
 Apr 2023 12:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> <20230414171255.oylmsdizl4waao4t@treble>
In-Reply-To: <20230414171255.oylmsdizl4waao4t@treble>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 14 Apr 2023 21:04:36 +0200
Message-ID: <CANiq72mWVwNfbCiKWdyyX=LXMrXsndO6gnwz_0tgVRt9Nk1KzA@mail.gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
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

On Fri, Apr 14, 2023 at 7:12=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Not to mention how objtool will react to compiled rust code (has it
> already been tried?)

Rust uses LLVM, so it should be generally fine -- at least some of the
checks appear to work. For instance, I can trigger:

      RUSTC L rust/kernel.o
    rust/kernel.o: warning: objtool: .text+0x0: unreachable instruction

      RUSTC [M] samples/rust/rust_minimal.o
    samples/rust/rust_minimal.o: warning: objtool:
_R..._6kernel6Module4init+0x172: unreachable instruction

via a random instruction in the middle of nowhere in the former (with
`global_asm!`) and a jumped-over instruction in the latter (with
`asm!`).

Moreover, we were already getting warnings when rethunk / x86 IBT is
enabled (since we got `objtool` called for `vmlinux.o`), e.g.

    vmlinux.o: warning: objtool: .rodata+0x18c58: data relocation to
!ENDBR: _R...IsWhitespaceEEB4_+0x0

    vmlinux.o: warning: objtool: _R...into_foreign+0x5: 'naked' return
found in RETHUNK build

I can send the patch to run it for all Rust object files via
`$(cmd_objtool)`, unless you think it is a bad idea.

Having said that, tooling may indeed have issues, e.g. Arnaldo (Cc'd)
is improving `pahole` to avoid assumptions around struct layout like
field reordering (which Rust does by default).

Cheers,
Miguel
