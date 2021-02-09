Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C309A31544A
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 17:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhBIQsW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 11:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhBIQqe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 11:46:34 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540FDC0613D6;
        Tue,  9 Feb 2021 08:45:53 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f2so23217875ljp.11;
        Tue, 09 Feb 2021 08:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ucw59OKhM9Q+zWkYzS3DfxjYeaWxtahJyWWZM+ZSxcs=;
        b=CksqofXNoheIa9e1LmljJyAtF5mIk/2VO9Knc5og6IIcHV3s+qa62XPGPBZbukFUc3
         llf8VuBHfG4uQkV4ZcWZTsHju69yHLidkySv9wacWjQUlssJMOqjXvNdtJUBoednu1Em
         qryZm5jdr0AZY7z/ZooZKOUUZMFrsLLnAPUwW7yntjouTNDO1FDSE/KCQE0DI2KMkkCr
         Tfeio6TdlWhCWmxpkNL/dYuGvhFgaKZsFK3jafISWZf/9oawVz69aoT2/qljhF5wCSPW
         XJT418JirCZ6+xQkOQzuwqEFDZV9jSRUVJ9wd2TkG2xLjLpUlU+NISXqT/pBPsi09kEj
         qcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ucw59OKhM9Q+zWkYzS3DfxjYeaWxtahJyWWZM+ZSxcs=;
        b=Ig1Zv+kXU53r0PZAnW0YsMO8j7NcbBlS7f28ifoIg2ADcMdYXQCxZ/kEMa9eEGHLxP
         8qMG/f+ln5pgHdoiXuY4DiOs2SJNZJXN/ekIIFDd7dbm2aE75pPFYOKNxRhVpfJ4HYDV
         lpRnWG+jg9xpRtdHlTaOb7TNE8cozMLCCiAkiejY8+cqd6yo5Ruprp3FJyjE3+fQqysS
         uUmC7LK4CpZy7yJ9Pwt8ZAvD1QlXMInK5ujJDFewKmBcYt1wFtNnx9d95na3ET5glyYZ
         vCH2xk3ARf//tTpIeY0sSx+3gHZDQq3SmzoFvoOwJu3CuIT+YRiyUN6zOCwlzS0a60cf
         ijWg==
X-Gm-Message-State: AOAM532gKEWCB++J4pwvv6SFGGRBzaE6UJhGtuitcqwEm6jWMq7lsNGK
        FOBS5haMaZbyZkl/hEkj1HC1ZreRXPnZefGJ0QE=
X-Google-Smtp-Source: ABdhPJyKBJ6ktL1eFnp+AoAxD/FKdiQevwz7oTqE1bleouoAFpSG94b5wPM3hE3xefsG58tczevDsSO/zUqG03qJFds=
X-Received: by 2002:a2e:3507:: with SMTP id z7mr14328131ljz.32.1612889151851;
 Tue, 09 Feb 2021 08:45:51 -0800 (PST)
MIME-Version: 1.0
References: <20210207104022.GA32127@zn.tnic> <CAHk-=widXSyJ8W3vRrqO-zNP12A+odxg2J2_-oOUskz33wtfqA@mail.gmail.com>
 <20210207175814.GF32127@zn.tnic> <CAHk-=wi5z9S7x94SKYNj6qSHBqz+OD76GW=MDzo-KN2Fzm-V4Q@mail.gmail.com>
 <20210207224540.ercf5657pftibyaw@treble> <20210208100206.3b74891e@gandalf.local.home>
 <20210208153300.m5skwcxxrdpo37iz@treble> <YCFc+ewvwNWqrbY7@hirez.programming.kicks-ass.net>
 <20210208111546.5e01c3fb@gandalf.local.home> <alpine.LSU.2.21.2102090927230.31501@pobox.suse.cz>
 <20210209094953.65d2f322@gandalf.local.home>
In-Reply-To: <20210209094953.65d2f322@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Feb 2021 08:45:40 -0800
Message-ID: <CAADnVQK-qdE6mHUogeaQo9Av_58cLptosmfUVmdMzW7gJn5UVw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 9, 2021 at 6:49 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 9 Feb 2021 09:32:34 +0100 (CET)
> Miroslav Benes <mbenes@suse.cz> wrote:
>
> > powerpc has this
> >
> > static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
> > {
> >         /*
> >          * Live patch works only with -mprofile-kernel on PPC. In this case,
> >          * the ftrace location is always within the first 16 bytes.
> >          */
> >         return ftrace_location_range(faddr, faddr + 16);
> > }
> >
> > > > I suppose the trivial fix is to see if it points to endbr64 and if so,
> > > > increment the addr by the length of that.
> > >
> > > I thought of that too. But one thing that may be possible, is to use
> > > kallsym. I believe you can get the range of a function (start and end of
> > > the function) from kallsyms. Then ask ftrace for the addr in that range
> > > (there should only be one).
> >
> > And we can do this if a hard-coded value live above is not welcome. If I
> > remember correctly, we used to have exactly this in the old versions of
> > kGraft. We walked through all ftrace records, called
> > kallsyms_lookup_size_offset() on every record's ip and if the offset+ip
> > matched faddr (in this case), we returned the ip.
>
> Either way is fine. Question is, should we just wait till CET is
> implemented for the kernel before making any of these changes? Just knowing
> that we have a solution to handle it may be good enough for now.

I think the issue is more fundamental than what appears on the surface.
According to endbr64 documentation it's not just any instruction.
The cpu will wait for it and if it's replaced with int3 or not seen at
the branch target the cpu will throw an exception.
If I understood the doc correctly it means that endbr64 can never be
replaced with a breakpoint. If that's the case text_poke_bp and kprobe
need to do extra safety checks.
