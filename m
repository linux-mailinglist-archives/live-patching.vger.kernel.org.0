Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1693330D002
	for <lists+live-patching@lfdr.de>; Wed,  3 Feb 2021 00:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhBBXw6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 18:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhBBXw4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 18:52:56 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A89FC0613D6
        for <live-patching@vger.kernel.org>; Tue,  2 Feb 2021 15:52:16 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id m6so15475615pfk.1
        for <live-patching@vger.kernel.org>; Tue, 02 Feb 2021 15:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvyHIYmrAMfcUjU2HzXYuSfOiDXorFLduwgI7Bqj73I=;
        b=ez8LC3AcVzaauh80wZJxetxlLZ6TgAOQqSwwJ2SGb/oU6fKeES9x1dM3ZnQGS2dcyJ
         Zyq6D94tw+fLjWZUcs++s/sgnWI1xd7d/M96o/4zF2Nqf1JfWdCCDxusCsP2gX5KGifG
         uwsdM7QhFXi3ZMyRtUXLqQiOyvNjJzWtltNQCw7UYjZEYEFE8R3bXMZRpqNE52nrZYou
         zIJH+MCzSTe6STPq15rmfpHT6HjFCzG1KTPZr1CZHb/FvfUs17qfTGDcCgly8KkVAgqL
         bp+8RJvtd/jc10ajrYGdEnlh6Y+qcEyy0YP8SzbhKyMu/Xe+LYwVm4mzA1AechxkgGcE
         mA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvyHIYmrAMfcUjU2HzXYuSfOiDXorFLduwgI7Bqj73I=;
        b=e2kJgY1MEBpSelSnyoxgPZJJZhQ6vvBf/K98CHnK+xjx4w4apWt/K0UeujWCuHsz7h
         to2yh6+udFWFoNEI4QVcciCdo1lmoyFUfzcgUqNoH544NFMFnPTfbKwCjfj1MyAlSJpG
         +XZET02iK+IWjHHgb3d0807tdkaI9yCkSwValLjVhY1bIjYn8v47TbnQw0cMOaUILyE3
         8nc5JN/WOjgDM+Re2qTanA6RNPA1HSkzsFMVa53Bb3PwarMGnqEs1H0G8s4eBw9Ggtxu
         wl6Ana3PEF9G9IyT/NZl1xbLRz1ESZPwCs2uqu6KQqPk30msRz1sLrTmEtq8VjL9ZPcv
         EZOA==
X-Gm-Message-State: AOAM532d9q1vgR6boUt7LUR2jTLhzZ9YzxuOONzRcFUUueWvcqOMY000
        sBfKVql3e1yd9azcr8PdtW5jY2JpPAzaO2UQTASshQ==
X-Google-Smtp-Source: ABdhPJyQ+VhM9DJvj4MIbfNfTV9TUVCg0FT7/uAsDWYVJdwDBx4dEvMAL2wmpyU68vRtlTmCwnnXfpK72UT0OfpWNwg=
X-Received: by 2002:a65:4201:: with SMTP id c1mr590436pgq.10.1612309935701;
 Tue, 02 Feb 2021 15:52:15 -0800 (PST)
MIME-Version: 1.0
References: <20210120173800.1660730-13-jthierry@redhat.com>
 <20210127221557.1119744-1-ndesaulniers@google.com> <20210127232651.rj3mo7c2oqh4ytsr@treble>
 <CAKwvOdkOeENcM5X7X926sv2Xmtko=_nOPeKZ2+51s13CW1QAjw@mail.gmail.com>
 <20210201214423.dhsma73k7ccscovm@treble> <CAKwvOdmgNPSpY2oPHFr8EKGXYJbm7K9gySKFgyn4FERa9nTXmw@mail.gmail.com>
 <20210202000203.rk7lh5mx4aflgkwr@treble> <CAKwvOd=R_ELec5Q3+oe9zuYXrwSGfLkqomAPOTr=UH=SZPtKUw@mail.gmail.com>
 <20210202233636.nvbl6wivgnhacbvg@treble>
In-Reply-To: <20210202233636.nvbl6wivgnhacbvg@treble>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 2 Feb 2021 15:52:04 -0800
Message-ID: <CAKwvOdnr5LcVbv2=2h+j8-ekvoB6PezmSOWhPzZdMaDG6eniag@mail.gmail.com>
Subject: Re: [RFC PATCH 12/17] gcc-plugins: objtool: Add plugin to detect
 switch table on arm64
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-hardening@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Peter Zijlstra <peterz@infradead.org>, raphael.gault@arm.com,
        Will Deacon <will@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Bill Wendling <morbo@google.com>,
        Pete Swain <swine@google.com>,
        Yonghyun Hwang <yonghyun@google.com>,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 2, 2021 at 3:36 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Tue, Feb 02, 2021 at 02:33:38PM -0800, Nick Desaulniers wrote:
> > On Mon, Feb 1, 2021 at 4:02 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Mon, Feb 01, 2021 at 03:17:40PM -0800, Nick Desaulniers wrote:
> > > And yes, objtool has been pretty good at finding compiler bugs, so the
> > > more coverage the better.
> > > > The idea of rebuilding control flow from binary analysis and using
> > > > that to find codegen bugs is a really cool idea (novel, even? idk),
> > > > and I wish we had some analog for userspace binaries that could
> > > > perform similar checks.
> > >
> > > Objtool is generic in many ways -- in fact I recently heard from a PhD
> > > candidate who used it successfully on another kernel for an ORC
> > > unwinder.
> >
> > That's pretty cool!  Reuse outside the initial context is always a
> > good sign that something was designed right.
>
> So basically you're saying objtool is both useful and well-designed.  I
> will quote you on that!

Haha, all I'm saying is that while I'm not proud that it did find bugs
in LLVM (and I do have existing bugs found by it to fix on my plate),
I don't see who else or how else those would have been spotted, and I
can appreciate that.  I think the tools given to us are broken (by
design, perhaps), so anything that can help us spot issues might help
our code live longer than we do.

I also think that there's room for improvement and experimentation in
debug info formats, though there is currently a proliferation to
support.  Live patching and eBPF seem to have some functional overlap
IIUC, strengths/weaknesses, and their own unique debug info formats to
go with it.  Supporting each one does require some level of toolchain
support or coordination (or complexity, even).
-- 
Thanks,
~Nick Desaulniers
