Return-Path: <live-patching+bounces-440-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4DE9480AB
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 19:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A34DB1F21951
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 17:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF92A15CD58;
	Mon,  5 Aug 2024 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aU0Hxp7W"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B22481A7;
	Mon,  5 Aug 2024 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879995; cv=none; b=dAjShRN0BIp8aV6uxpHCKJHXdLIeVQCejGwI3LpMSEQZR4O1S9QP0jxEzjbH061XF84I+FPOOBJVy4wTD9aSTnY341R7eFGYE4uYkGzVd7a8KOISXWJ5et7gUOrkYxi9ltGZo2S0fDEZgmcwuI1ghB89DRDIJgfzYfC6EOt1eec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879995; c=relaxed/simple;
	bh=Gx+4NhliD1/MYKaWvRPgeKiC8Ozr9TsuLJGZf7Sl7gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ttn4FVBwawrBUHzzUYHXHKgL1OQZXVO4VNPSD1Tmq6YT3kFIJXsuaf/tSTwZpA8tR8D0E6LIg+Pf25w1e6kj/KgkEnkgGPkfpQMJjEVaeFDMXuN7RErb9jgynj4/NC+PDkNQwSq+BKpMTsSty3pZ+IinUGDpbak4NBM6qLnSDFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aU0Hxp7W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26D3C4AF12;
	Mon,  5 Aug 2024 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722879995;
	bh=Gx+4NhliD1/MYKaWvRPgeKiC8Ozr9TsuLJGZf7Sl7gk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aU0Hxp7WYGPBt79fq/G1zNMFeWp4pEOTSLgWTye4U4GLssF1IkI8HcaFDQrZU6cMb
	 Nfx69UwUFStApMMVK+1tICy6JbHpYkKuK9czhsq3P3+6xFWOhkhqrl+cEraBWYRScq
	 vrA9p08uvFPoUn/Enct6x9loVbTcGGBV9T+ogf0hDSNqIjNz+GtMFk7bWAExlqAzat
	 kckiXQN2JWW41RwmmptnZPwiLajRWFHmI+HWifKHe+XYvglptrw7t/M1SIMoLBxLAI
	 6/G1LmNTfoWtE7+Ga4JYJ/73LJVSrm/jSYTrzmeyFA9WkbbvmalgNsY7Ek+3kEv9QB
	 960/8cC0kQt1g==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-530ae4ef29dso11517546e87.3;
        Mon, 05 Aug 2024 10:46:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWhOUscwc6zo8Nf4p+0/Xc691GdshHYbR4PwSRXA6Z76bsMZY6d3kTeuywfPVCfJxMsmzQcn+8h1dc+FveaT/WEjBp+DVwCvhKcRdh2PZUMf2LR+rjFyneGLXv04la1x3aFQ5cNwRKXjQCQ4xTD/BpG
X-Gm-Message-State: AOJu0YzKAjDdLEIqaejAVkymGPDQyRmR+l8wixBgONb4v6tpxCTRrsR1
	zWPBeSyFUaQ5Kd50IIksWlu0lxpKaSKKCw0RSkCmmcx9IO9dOSDGtYLvK0Rtl4IQ1Lta36QQc9V
	iKM+wiHjkFtm3+exf7AWfP0hxEZU=
X-Google-Smtp-Source: AGHT+IG3yL9p3oXntJjAV6RufVVHtCDR8RPr8Pey/VmQyx+q/WuBdDKFYhg2gH+XnhoFAiL0xDOEsCTDYsBcMMEMijg=
X-Received: by 2002:a05:6512:1593:b0:52d:582e:4111 with SMTP id
 2adb3069b0e04-530bb3810c5mr11445282e87.18.1722879993290; Mon, 05 Aug 2024
 10:46:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802210836.2210140-1-song@kernel.org> <20240802210836.2210140-3-song@kernel.org>
 <20240805224544.e0a4277dff4ac41d867c6bc1@kernel.org>
In-Reply-To: <20240805224544.e0a4277dff4ac41d867c6bc1@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 5 Aug 2024 10:46:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Axj1LaK3D09KuevQo2Otg7U0toDEPjop1dEnrUFtzAA@mail.gmail.com>
Message-ID: <CAPhsuW6Axj1LaK3D09KuevQo2Otg7U0toDEPjop1dEnrUFtzAA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] kallsyms: Add APIs to match symbol without .XXXX suffix.
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org, 
	morbo@google.com, justinstitt@google.com, mcgrof@kernel.org, 
	thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com, 
	mmaurer@google.com, samitolvanen@google.com, rostedt@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Masami,

On Mon, Aug 5, 2024 at 6:45=E2=80=AFAM Masami Hiramatsu <mhiramat@kernel.or=
g> wrote:
>
> On Fri,  2 Aug 2024 14:08:34 -0700
> Song Liu <song@kernel.org> wrote:
>
> > With CONFIG_LTO_CLANG=3Dy, the compiler may add suffix to function name=
s
> > to avoid duplication. This causes confusion with users of kallsyms.
> > On one hand, users like livepatch are required to match the symbols
> > exactly. On the other hand, users like kprobe would like to match to
> > original function names.
> >
> > Solve this by splitting kallsyms APIs. Specifically, existing APIs now
> > should match the symbols exactly. Add two APIs that match only the part
> > without .XXXX suffix. Specifically, the following two APIs are added.
> >
> > 1. kallsyms_lookup_name_without_suffix()
> > 2. kallsyms_on_each_match_symbol_without_suffix()
> >
> > These APIs will be used by kprobe.
> >
> > Also cleanup some code and update kallsyms_selftests accordingly.
> >
> > Signed-off-by: Song Liu <song@kernel.org>
>
> Looks good to me, but I have a nitpick.
>
>
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -164,30 +164,27 @@ static void cleanup_symbol_name(char *s)
> >  {
> >       char *res;
> >
> > -     if (!IS_ENABLED(CONFIG_LTO_CLANG))
> > -             return;
> > -
> >       /*
> >        * LLVM appends various suffixes for local functions and variable=
s that
> >        * must be promoted to global scope as part of LTO.  This can bre=
ak
> >        * hooking of static functions with kprobes. '.' is not a valid
> > -      * character in an identifier in C. Suffixes only in LLVM LTO obs=
erved:
> > -      * - foo.llvm.[0-9a-f]+
> > +      * character in an identifier in C, so we can just remove the
> > +      * suffix.
> >        */
> > -     res =3D strstr(s, ".llvm.");
> > +     res =3D strstr(s, ".");
>
> nit: "strchr(s, '.')" ?
>
> Anyway,
>
> Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks for your kind review!

If we have another version, I will fold this change (and the one in
kallsyms_selftest.c) in.

Song

