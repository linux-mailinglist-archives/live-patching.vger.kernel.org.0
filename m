Return-Path: <live-patching+bounces-447-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BBEF949C8C
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 02:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD224B20C3A
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 00:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4EB72119;
	Wed,  7 Aug 2024 00:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyArvJZm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A704E817;
	Wed,  7 Aug 2024 00:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722988928; cv=none; b=DYJupc3n4PnL2gcs7byUckOVZvFTfW18Fv07twd0dXrQXu7wiWYWCHWxSjQcDf0jH0U6s8OZDDRmwGA83gAFBHl5w4l+naHKq65aeLQbTg6EraXvm69iAk6Wi3dMF0CBWERE5NXJodsmJYQudJKjmiL6D9BaZNxdxHm2uLo7pN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722988928; c=relaxed/simple;
	bh=iZQwoKXmd4y5JYgAIsSoD5NbVcgC7h8OZcIMlcokcP8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=q2NHxnpTwwzkTt7ghnXzXTo8XJSuLn+A6FHuWhrdLU1Vh9hiEZLYB8KD6H3GZ9h+bsO45iArBxOiB1p9JfohSP1X2QoVAaSpkmsCb40/Aczt+LEisAugkI335fCRdXkf57mFneZJqOgj02qNLNa316ZDUzkkd13MLqWF/BltyMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyArvJZm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2FDC32786;
	Wed,  7 Aug 2024 00:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722988928;
	bh=iZQwoKXmd4y5JYgAIsSoD5NbVcgC7h8OZcIMlcokcP8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VyArvJZm6q6+ZSi0ZNleZzuoGBGiVnfpUl+UtLX+KRz8pcLWO43m+UOr/54QSXwtF
	 QL9IVNfonB8WhvjE6swnefbUW25OWEYtjdKguZsDrKD50vGML8FxoGSccjXRLN42Xh
	 UjvVPH0DCG/JQOLqVAeP7ds6+tVdttWWRIbhqav/J+HSU2sUa6yspbbSpGkijv2c9c
	 E2UPQ2taDlDLTSoVyK8Hk5V5MbywU7rsnfTA706mgULWSNUz1LuQhAefVi16fG4hV9
	 d3iy3B7n3OfJOMPTsgbht67bb9mSsZUgMI9smplZIuFMJa3MK1PVpuY2TcwTfcZ+AB
	 o6fNjIOPvp9KQ==
Date: Wed, 7 Aug 2024 09:01:46 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Song Liu <songliubraving@meta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr
 Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Nathan
 Chancellor <nathan@kernel.org>, "morbo@google.com" <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Leizhen <thunder.leizhen@huawei.com>,
 "kees@kernel.org" <kees@kernel.org>, Kernel Team <kernel-team@meta.com>,
 Matthew Maurer <mmaurer@google.com>, Sami Tolvanen
 <samitolvanen@google.com>, Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-Id: <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
In-Reply-To: <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
	<20240802210836.2210140-4-song@kernel.org>
	<20240806144426.00ed349f@gandalf.local.home>
	<B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
	<20240806160049.617500de@gandalf.local.home>
	<20240806160149.48606a0b@gandalf.local.home>
	<6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 6 Aug 2024 20:12:55 +0000
Song Liu <songliubraving@meta.com> wrote:

> 
> 
> > On Aug 6, 2024, at 1:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > On Tue, 6 Aug 2024 16:00:49 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >>>>> + if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
> >>>>> + addr = kallsyms_lookup_name_without_suffix(trace_kprobe_symbol(tk));
> >>>>> +    
> >>>> 
> >>>> So you do the lookup twice if this is enabled?
> >>>> 
> >>>> Why not just use "kallsyms_lookup_name_without_suffix()" the entire time,
> >>>> and it should work just the same as "kallsyms_lookup_name()" if it's not
> >>>> needed?    
> >>> 
> >>> We still want to give priority to full match. For example, we have:
> >>> 
> >>> [root@~]# grep c_next /proc/kallsyms
> >>> ffffffff81419dc0 t c_next.llvm.7567888411731313343
> >>> ffffffff81680600 t c_next
> >>> ffffffff81854380 t c_next.llvm.14337844803752139461
> >>> 
> >>> If the goal is to explicitly trace c_next.llvm.7567888411731313343, the
> >>> user can provide the full name. If we always match _without_suffix, all
> >>> of the 3 will match to the first one. 
> >>> 
> >>> Does this make sense?  
> >> 
> >> Yes. Sorry, I missed the "&& !addr)" after the "IS_ENABLED()", which looked
> >> like you did the command twice.
> > 
> > But that said, does this only have to be for llvm? Or should we do this for
> > even gcc? As I believe gcc can give strange symbols too.
> 
> I think most of the issue comes with LTO, as LTO promotes local static
> functions to global functions. IIUC, we don't have GCC built, LTO enabled
> kernel yet.
> 
> In my GCC built, we have suffixes like ".constprop.0", ".part.0", ".isra.0", 
> and ".isra.0.cold". We didn't do anything about these before this set. So I 
> think we are OK not handling them now. We sure can enable it for GCC built
> kernel in the future. 

Hmm, I think it should be handled as it is. This means it should do as
livepatch does. Since I expected user will check kallsyms if gets error,
we should keep this as it is. (if a symbol has suffix, it should accept
symbol with suffix, or user will get confused because they can not find
which symbol is kprobed.)

Sorry about the conclusion (so I NAK this), but this is a good discussion. 

Thanks,

> 
> Thanks,
> Song
> 
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

