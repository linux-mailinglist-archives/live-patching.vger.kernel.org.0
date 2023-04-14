Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D665E6E24BD
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 15:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDNNwG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 09:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDNNwF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 09:52:05 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC155E4
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 06:51:33 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r184so2926518ybc.1
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 06:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681480292; x=1684072292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcfxOgi6pPuyx3JQx2LhCifCM9+7U249zzwDa+w8T6I=;
        b=ZTBX69/TUEK8arK/g3QnGFhjr3FULZ3x5cRnmIpPmtcOuYV44XUpXl5//nrakR28Z2
         w75Am4vx/Umg8DhMrv0VbeGNOrUuMYIfXWrheGfAUmQq3m2HeGuFUII95Z0+LYlU9dnA
         6DSFTBt9y7SoxVL4Fd9///a3XqbvslM0D29YuWuQQ+Si6tidvCghqFGaPQ20XfqSBjBf
         xQO3wKy3a2cFvl3nGNc6KUaEMYNRNluNzOyF5+u0qRNbOL0szPkeFYjgY18vLtTLunL9
         ecjceLPM1omql/06xN9rL0+qydZ+13CoFC4xt//3OkjZKg8ebZzYnN4tBSVQEwFKnHlR
         tpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681480292; x=1684072292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WcfxOgi6pPuyx3JQx2LhCifCM9+7U249zzwDa+w8T6I=;
        b=cufCvQBj7FXV1+OyTLBHQn/XW0iJiRRghIKw2XYBFOrRafdoIPCBVNZAxyhqHFZRIR
         mVHvNqypSjMam1sAxhVZs3AjERQVrG/7FKgKXZf6QWpomFQWQjW5KU+r3MNhVFjuT5hh
         eC4UVvGCLBq3gt0QMUi+6BTLv+NXmqisZ97SXeaM7ex0sSne4S8FwORNlgdrZXKqliq6
         I/8SJmrJ97mYdvm+gShZcNCD1nfwZPAAzl6DRULHOYnJRUUpc0/wtNbgCkdN1MoC/n9L
         J6vHu941DsbHXrGpsXSq5lHM/d9Xmboaebo519QMVTbPZuycTjoBVI/caJWIEuyNbG2J
         jPlA==
X-Gm-Message-State: AAQBX9c89btQfLJvp+cTjzxQs+5wQmyjuwU0vrGn6kWZg/GjZ94bH+qK
        M3kHbwzUYCRF39gUNWeiaTmgWoDlZpwe5WVlIeg=
X-Google-Smtp-Source: AKy350aDV+UZ6PbqqGgnhl1bEBZtbHk7L02LctH2TIAvTy+Ch3QwR92W+xFNXoCSuPRXfOeUnEiMSzbPu50JCx8eMiM=
X-Received: by 2002:a25:d80a:0:b0:b8f:6b84:33cb with SMTP id
 p10-20020a25d80a000000b00b8f6b8433cbmr1596298ybg.11.1681480292221; Fri, 14
 Apr 2023 06:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> <87r0sm39pt.fsf@oracle.com>
In-Reply-To: <87r0sm39pt.fsf@oracle.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 14 Apr 2023 15:51:21 +0200
Message-ID: <CANiq72mk8-TZO59+oL2B6Xt8KyZNDBtyaP6TCNLVCdLASjJDnQ@mail.gmail.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
To:     "Jose E. Marchesi" <jose.marchesi@oracle.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        elena.zannoni@oracle.com, indu.bhagat@oracle.com
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

On Fri, Apr 14, 2023 at 2:54=E2=80=AFPM Jose E. Marchesi
<jose.marchesi@oracle.com> wrote:
>
> As for Rust... we have the Rust GCC support and that would fit in the MC
> as well.  We can surely invite some of the hackers working in the
> front-end.  But maybe it would be better to have that discussion in a
> Rust MC, if there is gonna be one (Miguel?).

It is likely we will submit a Rust MC proposal, yeah.

Last year we had both Rust GCC and rustc_codegen_gcc presenting in the
Rust MC (and Kangrejos too), and I would be grateful to have them
again, but if it is best for everybody otherwise, we can change things
of course.

(Is it already known how tight timing will be this year for MCs?)

> For starters, I would make sure that the involved MCs (Live Patching,
> Toolchains, and an eventual Rust MC) do not overlap in the schedule.
> Then we could have these discussions in either microconferences.

Yeah, it sounds good to me.

Cheers,
Miguel
