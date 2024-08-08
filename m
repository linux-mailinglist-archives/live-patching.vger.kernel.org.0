Return-Path: <live-patching+bounces-472-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE75A94C203
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 17:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71BD51F233E7
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 15:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A48A18FDBF;
	Thu,  8 Aug 2024 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vAqFMnrR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE2F18CC0C;
	Thu,  8 Aug 2024 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723132355; cv=none; b=ug+AU+BapxOVePYtnPH/fSszA0QaMSOuihxbIkr8eHiLZ4apzuteOv9oqDEbmvpbKhy2psqViopsk4QgfFoPWQpfqflSylD0BOZumkod3Cl7XGrlU73R3zTJdrXiSKvWcXuHcBFQ4LBCYiuDpiuFwOcdWyZkUkpKl1afK53yp6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723132355; c=relaxed/simple;
	bh=MA4u5QG0JWizBNPse3ag1v+wZ1LBB64y0nsxcrcwrUE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=BNlNheGPqbeJwdPN6GhAKJTPkSfs0gjEEzDsK96aI06WN7rRmayvbXZ5d6X7wpFXIQKfCcbBoPYApW2TDFj3QhNTpWJdWrycUkwnwI0Ix31SKZnIV0USPaZCwc9DosCzCA1nAneBjd/hSCIPjUIxAd6cCEIGCGjVBP+hE1N2eXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vAqFMnrR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B1EC32786;
	Thu,  8 Aug 2024 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723132354;
	bh=MA4u5QG0JWizBNPse3ag1v+wZ1LBB64y0nsxcrcwrUE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vAqFMnrR8sj7HPQkCaZS/kG+otY1sqXMMCDLasHIl8fmyTbo4YgD8UVUwbNWfAfW4
	 4lm22vVQKfheEBRBQQ5/r3eBnB0FZZJj5sajoGJz0gbULl73B7ZOMKYIOCVNzU7fTD
	 /kwb4TIfYwkZxkt1Lkl2unmR+q/z0JJ30Ol2Qvr0KyodAsMR87mahVepyTAkbMlDji
	 OO3062ngXGHCbCUkdUxB6pD3XZVYA2u9Cl/zbMMlcuiVWN8POZq8NzezDKqTI6tRge
	 jioPA8hXytrHJGd4uH0vafwJCAB5bErMwt4n8DBixnI0yYzGFjXW5bEgVAsEH2QCxd
	 ajpQ/aUNK0+EQ==
Date: Fri, 9 Aug 2024 00:52:27 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <songliubraving@meta.com>, Sami Tolvanen
 <samitolvanen@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Joe
 Lawrence <joe.lawrence@redhat.com>, Nathan Chancellor <nathan@kernel.org>,
 "morbo@google.com" <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Leizhen
 <thunder.leizhen@huawei.com>, "kees@kernel.org" <kees@kernel.org>, Kernel
 Team <kernel-team@meta.com>, Matthew Maurer <mmaurer@google.com>,
 "Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-Id: <20240809005227.d5219493cb181243376db4be@kernel.org>
In-Reply-To: <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
References: <20240806144426.00ed349f@gandalf.local.home>
	<B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
	<20240806160049.617500de@gandalf.local.home>
	<20240806160149.48606a0b@gandalf.local.home>
	<6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
	<20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
	<BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
	<20240807190809.cd316e7f813400a209aae72a@kernel.org>
	<CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
	<09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
	<ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 8 Aug 2024 11:59:00 +0200
Petr Mladek <pmladek@suse.com> wrote:

> On Wed 2024-08-07 20:48:48, Song Liu wrote:
> > 
> > 
> > > On Aug 7, 2024, at 8:33 AM, Sami Tolvanen <samitolvanen@google.com> wrote:
> > > 
> > > Hi,
> > > 
> > > On Wed, Aug 7, 2024 at 3:08 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >> 
> > >> On Wed, 7 Aug 2024 00:19:20 +0000
> > >> Song Liu <songliubraving@meta.com> wrote:
> > >> 
> > >>> Do you mean we do not want patch 3/3, but would like to keep 1/3 and part
> > >>> of 2/3 (remove the _without_suffix APIs)? If this is the case, we are
> > >>> undoing the change by Sami in [1], and thus may break some tracing tools.
> > >> 
> > >> What tracing tools may be broke and why?
> > > 
> > > This was a few years ago when we were first adding LTO support, but
> > > the unexpected suffixes in tracing output broke systrace in Android,
> > > presumably because the tools expected to find specific function names
> > > without suffixes. I'm not sure if systrace would still be a problem
> > > today, but other tools might still make assumptions about the function
> > > name format. At the time, we decided to filter out the suffixes in all
> > > user space visible output to avoid these issues.
> > > 
> > >> For this suffix problem, I would like to add another patch to allow probing on
> > >> suffixed symbols. (It seems suffixed symbols are not available at this point)
> > >> 
> > >> The problem is that the suffixed symbols maybe a "part" of the original function,
> > >> thus user has to carefully use it.
> > >> 
> > >>> 
> > >>> Sami, could you please share your thoughts on this?
> > >> 
> > >> Sami, I would like to know what problem you have on kprobes.
> > > 
> > > The reports we received back then were about registering kprobes for
> > > static functions, which obviously failed if the compiler added a
> > > suffix to the function name. This was more of a problem with ThinLTO
> > > and Clang CFI at the time because the compiler used to rename _all_
> > > static functions, but one can obviously run into the same issue with
> > > just LTO.
> > 
> > I think newer LLVM/clang no longer add suffixes to all static functions
> > with LTO and CFI. So this may not be a real issue any more?
> > 
> > If we still need to allow tracing without suffix, I think the approach
> > in this patch set is correct (sort syms based on full name,
> 
> Yes, we should allow to find the symbols via the full name, definitely.
> 
> > remove suffixes in special APIs during lookup).
> 
> Just an idea. Alternative solution would be to make make an alias
> without the suffix when there is only one symbol with the same
> name.
> 
> It would be complementary with the patch adding aliases for symbols
> with the same name, see
> https://lore.kernel.org/r/20231204214635.2916691-1-alessandro.carminati@gmail.com

I think this is the best idea what we can do for tracing/stacktrace with
same-name symbols. But the root cause here is a bit different, that's why
I rejected the last patch.

With compiler suffixes, the source line aliases should remove those
suffixes and add new suffix like below.

1234 t name_show.llvm.12345678
1234 t name_show@kernel_irq_irqdesc_c_264

> I would allow to find the symbols with and without the suffix using
> a single API.

I wonder why we need it? for ftrace filter?

The same symbol name does not mean the same function prototype.
For the kprobes (and fprobes, ftraces too) user must specify which
actual symbol is what you want to probe.

Of course if user can say "hey kprobe, probe name_show", but that is
unclear (not unique symbol) so kprobe will reject it. If there is
.llvm suffix, user can specify one of them. But it is still unclear
to user where in the source code the symbol is actually defined.
So eventually, we need the debuginfo or this @suffix.

Thank you,


> 
> Best Regards,
> Petr


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

