Return-Path: <live-patching+bounces-458-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BE994B1A5
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24348282F0C
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 20:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1FD146585;
	Wed,  7 Aug 2024 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPtmR41C"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112D62575F;
	Wed,  7 Aug 2024 20:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064154; cv=none; b=YjEX/+jELMQluf/LsLwjxZabetIrcKostuEvUdotqLtkoc7wK3ZTliioZXa5lEyDSN/ZMQigMFjhcpFrI0D7OgQh3pQjGKotxw6m8VRv7krxk0rTncOikhPgnYlhHJSiu3x5mW/U2H//zsW74coF2N8RSc0QDM8hxE7Kym2Bcqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064154; c=relaxed/simple;
	bh=EaZgcA3NtRAmtxQ7KZE96Vk2UBjW9UO69pLCY10zeOU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Ib9Fbx2Yiin7hmxrLsXAJiDyEpsfcN36t4hHCn4n3Y6wDOxJnMC4wM6OoVq/9aae5ghqaU3Bpjw4P6A4uuoBi55qvttFBfGXgnhnkGJvfMutnToQVtb2tkZeLZYzAYeGMSv0DaxRKR1XnAA53AzpYhG2bDl0aDte5aiW0ZciCA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPtmR41C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3EFC32781;
	Wed,  7 Aug 2024 20:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723064153;
	bh=EaZgcA3NtRAmtxQ7KZE96Vk2UBjW9UO69pLCY10zeOU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lPtmR41C4gg3atA2WrJ4WPsI4+3VjEXnkpMl/2QBNAD9rzgCm805CjQUYQIrVG4oI
	 myMKNdhyxoMIRaiZep7hSjD1qYN598NiOe9vWsWZ5StkTgod1PQ3rYNHDgmYdgim1p
	 CQabP3YQaQfw4qR1adoDmX/+2R0mZbWQiiuyiYtvbJg7O5XxGva++AMnYJQnrSdKtC
	 3aiFa7aO4yQhiK7VFAy0o87UPWGKpo+2DOdF50i/pHVJrIg+FWKKXuUtRTl/B4Gfc4
	 5h7WOXXs5H1cw7lMYniX81Vsa1GD24Uf/S8AVma0JmwOWo52fY0fm2g1e6HsW9MYg/
	 i77DTdIrALRgQ==
Date: Thu, 8 Aug 2024 05:55:46 +0900
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
 <samitolvanen@google.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-Id: <20240808055546.9b7f8089a10713d83ba29a75@kernel.org>
In-Reply-To: <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
	<20240802210836.2210140-4-song@kernel.org>
	<20240806144426.00ed349f@gandalf.local.home>
	<B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
	<20240806160049.617500de@gandalf.local.home>
	<20240806160149.48606a0b@gandalf.local.home>
	<6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
	<20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
	<BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 7 Aug 2024 00:19:20 +0000
Song Liu <songliubraving@meta.com> wrote:

> 
> 
> > On Aug 6, 2024, at 5:01 PM, Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > 
> > On Tue, 6 Aug 2024 20:12:55 +0000
> > Song Liu <songliubraving@meta.com> wrote:
> > 
> >> 
> >> 
> >>> On Aug 6, 2024, at 1:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>> 
> >>> On Tue, 6 Aug 2024 16:00:49 -0400
> >>> Steven Rostedt <rostedt@goodmis.org> wrote:
> >>> 
> >>>>>>> + if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
> >>>>>>> + addr = kallsyms_lookup_name_without_suffix(trace_kprobe_symbol(tk));
> >>>>>>> +    
> >>>>>> 
> >>>>>> So you do the lookup twice if this is enabled?
> >>>>>> 
> >>>>>> Why not just use "kallsyms_lookup_name_without_suffix()" the entire time,
> >>>>>> and it should work just the same as "kallsyms_lookup_name()" if it's not
> >>>>>> needed?    
> >>>>> 
> >>>>> We still want to give priority to full match. For example, we have:
> >>>>> 
> >>>>> [root@~]# grep c_next /proc/kallsyms
> >>>>> ffffffff81419dc0 t c_next.llvm.7567888411731313343
> >>>>> ffffffff81680600 t c_next
> >>>>> ffffffff81854380 t c_next.llvm.14337844803752139461
> >>>>> 
> >>>>> If the goal is to explicitly trace c_next.llvm.7567888411731313343, the
> >>>>> user can provide the full name. If we always match _without_suffix, all
> >>>>> of the 3 will match to the first one. 
> >>>>> 
> >>>>> Does this make sense?  
> >>>> 
> >>>> Yes. Sorry, I missed the "&& !addr)" after the "IS_ENABLED()", which looked
> >>>> like you did the command twice.
> >>> 
> >>> But that said, does this only have to be for llvm? Or should we do this for
> >>> even gcc? As I believe gcc can give strange symbols too.
> >> 
> >> I think most of the issue comes with LTO, as LTO promotes local static
> >> functions to global functions. IIUC, we don't have GCC built, LTO enabled
> >> kernel yet.
> >> 
> >> In my GCC built, we have suffixes like ".constprop.0", ".part.0", ".isra.0", 
> >> and ".isra.0.cold". We didn't do anything about these before this set. So I 
> >> think we are OK not handling them now. We sure can enable it for GCC built
> >> kernel in the future.
> > 
> > Hmm, I think it should be handled as it is. This means it should do as
> > livepatch does. Since I expected user will check kallsyms if gets error,
> > we should keep this as it is. (if a symbol has suffix, it should accept
> > symbol with suffix, or user will get confused because they can not find
> > which symbol is kprobed.)
> > 
> > Sorry about the conclusion (so I NAK this), but this is a good discussion. 
> 
> Do you mean we do not want patch 3/3, but would like to keep 1/3 and part 
> of 2/3 (remove the _without_suffix APIs)? If this is the case, we are 
> undoing the change by Sami in [1], and thus may break some tracing tools. 

BTW, I confirmed that the PATCH 1/3 and 2/3 fixes kprobes to probe on suffixed
symbols correctly. (because 1/3 allows to search suffixed symbols) 

/sys/kernel/tracing # cat dynamic_events 
p:kprobes/p_c_stop_llvm_17132674095431275852_0 c_stop.llvm.17132674095431275852
p:kprobes/p_c_stop_llvm_8011538628216713357_0 c_stop.llvm.8011538628216713357
p:kprobes/p_c_stop_0 c_stop

Thank you,

> 
> Sami, could you please share your thoughts on this? 
> 
> If this works, I will send next version with 1/3 and part of 2/3. 
> 
> Thanks,
> Song
> 
> [1] https://lore.kernel.org/all/20210408182843.1754385-8-samitolvanen@google.com/
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

