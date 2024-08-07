Return-Path: <live-patching+bounces-460-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7611A94B21D
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 23:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 328F8283B95
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 21:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790F8149DE4;
	Wed,  7 Aug 2024 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pg2YAtJX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490A113D882;
	Wed,  7 Aug 2024 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723065971; cv=none; b=Ap+yWZ/I3qiVjcmMvkmVZXCGUhUMrOGdK/+3ChnEwOe4Yua60pjFoVTvOCht0UKlbBsC8dM1neGnxYu+JRcDfbupYS21nrZZO0g5XgDmxYTFe5mqiFIEEc5ZhHbcunHLqs9a4Nyta/tTx4UVGcuE5sRY/G3FLceC7EiB8SYESNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723065971; c=relaxed/simple;
	bh=+dF/DQa58fdxlXROLNrt5+UDez98yoEbLnwBDvuLovA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DCsZGoeVdMOXqzkWsX8V+8KcHu3MfmM0sH0j5YT5J/vmPbnzqKAIk3dn6kqGPalV79NXSpGL5aeFj1eBlxe7nIWpgEYOrtq0s/RR0j8hMwl8PrMlS2ZG4lEV/UCIk72gKG8ChlR6dDl63j0+2QxrXfcK1OmDNl98BXUOkf1etSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pg2YAtJX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E05C32781;
	Wed,  7 Aug 2024 21:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723065969;
	bh=+dF/DQa58fdxlXROLNrt5+UDez98yoEbLnwBDvuLovA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pg2YAtJXDKA754iQY+O3kbADxENpHpsAdpDWJGatyql4gId7PKN+B0/r4xpU61ZuD
	 jq6CjU3MmBp4GpJ5a72C1wIoebH4uH8slbBwBaMYINMx3rC3kEzfgJu25iLyWvS1Ao
	 6efRaYvmuIGfp9bUGiz0EQJjCzABdQkcGQr70PklaEs92T8yHmfn3wegyqqPHCWQaC
	 3wW3fFQObp2papUPaIyN8OIjNVASSOJ2aJgesRbYfdzYlyVGk2NSEGNPA7RCorDR9R
	 esWqya0UovOtkENcu3bn22i5ErRNq1EICgVSya/85q5qFgAtkSyEDPi9gu0isR7WPk
	 Lhod3alLOjvLw==
Date: Thu, 8 Aug 2024 06:26:03 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Song Liu <songliubraving@meta.com>, Steven Rostedt
 <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr
 Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Nathan
 Chancellor <nathan@kernel.org>, "morbo@google.com" <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Leizhen <thunder.leizhen@huawei.com>,
 "kees@kernel.org" <kees@kernel.org>, Kernel Team <kernel-team@meta.com>,
 Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-Id: <20240808062603.f4a180fa2153881874eb0dc0@kernel.org>
In-Reply-To: <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
References: <20240802210836.2210140-1-song@kernel.org>
	<20240802210836.2210140-4-song@kernel.org>
	<20240806144426.00ed349f@gandalf.local.home>
	<B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
	<20240806160049.617500de@gandalf.local.home>
	<20240806160149.48606a0b@gandalf.local.home>
	<6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
	<20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
	<BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
	<20240807190809.cd316e7f813400a209aae72a@kernel.org>
	<CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 7 Aug 2024 08:33:07 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> Hi,
> 
> On Wed, Aug 7, 2024 at 3:08 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Wed, 7 Aug 2024 00:19:20 +0000
> > Song Liu <songliubraving@meta.com> wrote:
> >
> > > Do you mean we do not want patch 3/3, but would like to keep 1/3 and part
> > > of 2/3 (remove the _without_suffix APIs)? If this is the case, we are
> > > undoing the change by Sami in [1], and thus may break some tracing tools.
> >
> > What tracing tools may be broke and why?
> 
> This was a few years ago when we were first adding LTO support, but
> the unexpected suffixes in tracing output broke systrace in Android,
> presumably because the tools expected to find specific function names
> without suffixes. I'm not sure if systrace would still be a problem
> today, but other tools might still make assumptions about the function
> name format. At the time, we decided to filter out the suffixes in all
> user space visible output to avoid these issues.

Thanks for explanation.
IMHO, those tools might change their assumptions and decide the policy
that it drops suffixes (as you did) or keep the suffixes as it is.

> > For this suffix problem, I would like to add another patch to allow probing on
> > suffixed symbols. (It seems suffixed symbols are not available at this point)
> >
> > The problem is that the suffixed symbols maybe a "part" of the original function,
> > thus user has to carefully use it.
> >
> > >
> > > Sami, could you please share your thoughts on this?
> >
> > Sami, I would like to know what problem you have on kprobes.
> 
> The reports we received back then were about registering kprobes for
> static functions, which obviously failed if the compiler added a
> suffix to the function name. This was more of a problem with ThinLTO
> and Clang CFI at the time because the compiler used to rename _all_
> static functions, but one can obviously run into the same issue with
> just LTO.

Yeah, without 1/3 of this series, user can not specify llvm suffixed
symbols on kprobe events. However, as perf-probe does, users can use
the relative offset from a unique symbol too. (kprobe does not care
the function boundary.)

Thank you,

> 
> Sami


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

