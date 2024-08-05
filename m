Return-Path: <live-patching+bounces-438-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A7D947B4A
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 14:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3ED131F22B75
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 12:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14E1158DD1;
	Mon,  5 Aug 2024 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rf0caaJm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A51553BD;
	Mon,  5 Aug 2024 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722862427; cv=none; b=jpTmscI5R4ocxs04eYgLk0ElqGY/DgrTNeqmgPHeuxfKKB5GTk2ggUo74dY/Pp9aAXHxRGaerFnYXkLx7dPRcRrilHOMfuntpX0iLUo+ymsFBFmoSCX0tELIuDAFh5nLIufcWFn/wnaOMXFmig3pqHS/kz4ziEZrD/Nov8dfGlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722862427; c=relaxed/simple;
	bh=zkSccOrcHN9PwIDKSBmcd1Mtr3VA44oYrKtVXgICUv4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RerpdFYGFmn65jcLtOiDqgpCnPFeV5fi/BNir7/hOXjnLkxr/46mazg1idloupRyuC3MV0kRJy7Qf6D2MrBDirhuMXsZnUmj1RKVelHMaKgszTJQ3agDGvBG8MY3Xr/BXZpDdY0ets42Cco4BLzR+1fIcKh82lqnNzmZrgIYjmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rf0caaJm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C153C32782;
	Mon,  5 Aug 2024 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722862427;
	bh=zkSccOrcHN9PwIDKSBmcd1Mtr3VA44oYrKtVXgICUv4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rf0caaJmPTBZhGYv+4fGx3xwDnH3mr0CxL4hNFHK18ODZW5F+yGiLiBNzHvB7f0FX
	 nfLpSC3vtXOsN5osjOWYQTW1NeqMw9wX+5lorxNQGHMawSU+0b0TDemKZ80usZBDbm
	 b0icR/chV3fzrg5niUdj/EjwrvM/D0uhKCQUZ0s6Qbg2YCMuw+KqpMmo6bnefnZsMu
	 clB9gP4BThQ8quESKZrYEKCw0bF/BJj5QrLore2V8ZpQZEniOM5GUWa4ckB/hnBIxW
	 9qGTxRlc7zS2/1fEvCDxWohPLu+P2/8GgwWVUlIwL1wLNQy9mGA9dmRfb3JMrZn0hH
	 +G1idVf2Fj2TQ==
Date: Mon, 5 Aug 2024 21:53:40 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Song Liu <songliubraving@meta.com>
Cc: Petr Mladek <pmladek@suse.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Song Liu <song@kernel.org>, "live-patching@vger.kernel.org"
 <live-patching@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 Nathan Chancellor <nathan@kernel.org>, "morbo@google.com"
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Leizhen <thunder.leizhen@huawei.com>,
 "kees@kernel.org" <kees@kernel.org>, Kernel Team <kernel-team@meta.com>,
 Matthew Maurer <mmaurer@google.com>, Sami Tolvanen
 <samitolvanen@google.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Message-Id: <20240805215340.1e647b9bb1f35af6bd4b909c@kernel.org>
In-Reply-To: <2F42C167-319A-46F2-A6C8-95B59F675D65@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
	<20240730005433.3559731-3-song@kernel.org>
	<20240730220304.558355ff215d0ee74b56a04b@kernel.org>
	<5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
	<Zqz_BwG1fcQaUsoY@pathway.suse.cz>
	<2F42C167-319A-46F2-A6C8-95B59F675D65@fb.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 2 Aug 2024 17:09:12 +0000
Song Liu <songliubraving@meta.com> wrote:

> Hi Petr, 
> 
> > On Aug 2, 2024, at 8:45 AM, Petr Mladek <pmladek@suse.com> wrote:
> 
> [...]
> 
> > 
> > IMHO, it depends on the use case. Let's keep "ping_table/"
> > as an example. Why people would want to trace this function?
> > There might be various reasons, for example:
> > 
> >  1. ping_table.llvm.15394922576589127018 appeared in a backtrace
> > 
> >  2. ping_table.llvm.15394922576589127018 appeared in a histogram
> > 
> >  3. ping_table looks interesting when reading code sources
> > 
> >  4. ping_table need to be monitored on all systems because
> >     of security/performance.
> > 
> > The full name "ping_table.llvm.15394922576589127018" is perfectly
> > fine in the 1st and 2nd scenario. People knew this name already
> > before they start thinking about tracing.
> > 
> > The short name is more practical in 3rd and 4th scenario. Especially,
> > when there is only one static symbol with this short name. Otherwise,
> > the user would need an extra step to find the full name.
> > 
> > The full name is even more problematic for system monitors. These
> > applications might need to probe particular symbols. They might
> > have hard times when the symbol is:
> > 
> >    <symbol_name_from_sources>.<random_suffix_generated_by_compiler>
> > 
> > They will have to deal with it. But it means that every such tool
> > would need an extra (non-trivial) code for this. Every tool would
> > try its own approach => a lot of problems.
> > 
> > IMHO, the two APIs could make the life easier.
> > 
> > Well, even kprobe might need two APIs to allow probing by
> > full name or without the suffix.
> 
> The problem is, with potential partial inlining by modern compilers, 
> tracing "symbol name from sources" is not accurate. In our production 
> kernels, we have to add some explicit "noline" to make sure we can 
> trace these functions reliably. 
> 
> Of course, this issue exists without random suffix: any function 
> could be partially inlined. However, allowing tracing without the 
> suffix seems to hint that tracing with "symbol name from sources" 
> is valid, which is not really true. 
> 
> At the moment, I have no objections to keep the _without_suffix
> APIs. But for long term, I still think we need to set clear 
> expectations for the users: tracing symbols from sources is not
> reliable. 

OK, I understand this part. I agree the problem. Even if the symbol
is unique on kallsyms (without suffix), it may have a suffix and is
not correct function entry.

I think to solve this issue, we need a better DWARF, or add a symbol
suffix like;

https://lkml.org/lkml/2023/12/4/1535

Thank you,

> 
> Thanks,
> Song
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

