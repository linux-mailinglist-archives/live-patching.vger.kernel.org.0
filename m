Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535036F49AA
	for <lists+live-patching@lfdr.de>; Tue,  2 May 2023 20:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbjEBS1R (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 May 2023 14:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjEBS1P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 May 2023 14:27:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1617612A
        for <live-patching@vger.kernel.org>; Tue,  2 May 2023 11:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3C78620AE
        for <live-patching@vger.kernel.org>; Tue,  2 May 2023 18:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E52C433D2
        for <live-patching@vger.kernel.org>; Tue,  2 May 2023 18:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683052033;
        bh=nIbsi3HhbRHK+IkmH8Kr8W6fJJ2tc1iOrqWHLpkp0HA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d1YBWpIGc5XZOZG7nGDVpWt7D0T6+m3zOCOGKu646ZhzM5ZRy64Am4h5yp/fpsNR7
         s2KjaSMt0wjB9fwgszGsKW59HSlbLRZ9xQ7F8ywH+uEj3F9NbX9BK1JxMThACBBJS1
         aaUxReK7Rc64TAbDG9xk4dTe1E39aPACd5p7wZaponqqTYlHYAAEKO7J7YS1wFrrqJ
         xADb+vGLasS5BwSs/zZIYbxtqSmPxi/pQhFHDGygRJjt/I0oIi++fuWj0mzT3wg/5l
         /bBEu4l1FHgqB4akFxSeeoLndZV56E3HjMnyWGdQ5BYj2izuppO9VgsgqgO6fCvFPb
         t9OhxYa2uUV+A==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-4efd6e26585so4938943e87.1
        for <live-patching@vger.kernel.org>; Tue, 02 May 2023 11:27:12 -0700 (PDT)
X-Gm-Message-State: AC+VfDwpnFj83XnhUyqYTdseQz/i/BTJQcCHNEGgBP85jIAjBP6WRWDh
        ZsDWU+ZV2O7lNXOUGTvLnaK3a3m25qe6pofKVnc=
X-Google-Smtp-Source: ACHHUZ40GldoCtyG1URZy5IAUjnqA0+4fHAloetxCuA/IF+9eqrovCuU/I/7D3pYMcy2Z3QQxKZJ0R8n6BjhrHC8UXc=
X-Received: by 2002:ac2:4c19:0:b0:4ed:c3a1:752a with SMTP id
 t25-20020ac24c19000000b004edc3a1752amr219139lfq.45.1683052031060; Tue, 02 May
 2023 11:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAPhsuW58LYU8iRCjoeChCyQ_7gqZvp6_U-fJr2Crf6gOniA51g@mail.gmail.com>
 <20230502135630.580a98ea@gandalf.local.home>
In-Reply-To: <20230502135630.580a98ea@gandalf.local.home>
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 May 2023 11:26:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5V=3wNCZ7HV2su65FmDr9ynnXMG5HQj4o5zLQVG8zDwg@mail.gmail.com>
Message-ID: <CAPhsuW5V=3wNCZ7HV2su65FmDr9ynnXMG5HQj4o5zLQVG8zDwg@mail.gmail.com>
Subject: Re: Question about inline, notrace, and livepatch
To:     Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@meta.com>
Cc:     live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+ Yonghong,

On Tue, May 2, 2023 at 10:56=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Tue, 2 May 2023 10:40:28 -0700
> Song Liu <song@kernel.org> wrote:
>
> > We hit the following hiccup a couple times in the past few months:
> >
> > A function is marked as "inline", but the compiler decided not to inlin=
e it.
> > Since "inline" implies "notrace" since [1], this function doesn't have
> > fentry/mcount. When we built livepatch for this function, kpatch-build
> > failed with:
> >
> >    xxx.o: function yyy has no fentry/mcount call, unable to patch
> >
> > This is not a deal breaker, as we can usually modify the patch to work
> > around it. But I wonder whether we still need "inline" to imply "notrac=
e".
> > Can we remove this to make livepatch a little easier?
>
> The history behind this is that there were cases that functions that were
> inlined, were in critical paths that could cause crashes if they were
> traced. In testing they never triggered because the developer's compiler
> inlined them. Then on someone else's machine, the compiler decided not to
> inline the function and the system crashed. It was hell to debug because =
I
> was not able to reproduce the issue, as my compiler would always keep the
> function inlined!
>
> But a lot has changed since then. I've implemented the
> "ftrace_test_recursion_trylock()" that catches pretty much all recursive
> bugs (and can ever report when they happen). So I may be open to removing
> the "notrace" from "inline".

Thanks for the history! Let's try to remove this constraint.

Song
