Return-Path: <live-patching+bounces-449-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AAB094A516
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 12:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BA191C2082E
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 10:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171071D2F75;
	Wed,  7 Aug 2024 10:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGwv+vRz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05251D1F73;
	Wed,  7 Aug 2024 10:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723025296; cv=none; b=VAC0geUZsNeZ8GMH1H9cx8xkujfvZfSa6l0VgAiMxaqMbMZcjFHVy5hNXI5Qw5HFCMwbpfOYRavs+vMfHwM6tB/j38KOVdbiZ6ifegDh1XOGddJXvKjt0/6Kj5UUYbYG4l7MPeuR4ezfhP/21KNkS9u0c+dHgCex4rwReIiOmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723025296; c=relaxed/simple;
	bh=pbz9/mWikLj58LPIdHZGqQeOO3Hv+c3Hn1bmQqtGTqE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=n/M3HFW6h9pFEvgDBhoRiAMLZ1GBRGTUPwr4gFKnW92NnigUCf9/WPv05jtazXY/nfZfkIXB2e9u3s+zsBEQG1DIBYAsJ7XEHYXLRVhC+qBUhDCOOwniMOgMaFT90XUzTgKy1nWCem//qDZxPXHYdjZtKywynMV28TLyAlV3uOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGwv+vRz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E3CC32782;
	Wed,  7 Aug 2024 10:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723025295;
	bh=pbz9/mWikLj58LPIdHZGqQeOO3Hv+c3Hn1bmQqtGTqE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JGwv+vRzTcQ/uEot7V4X4z1XWtWOrbl9g9l//D1Nyh/AxgOt7LhAFiqLL8DBuyrsC
	 3INwE3Wn0kxGybNgy0/e2C8aF3fIld4pSPt4R1ZY1RybxNcL2I7BM8rJH5S68rBZtV
	 E2Z0S8T55WUSOGxp+cHmdbMgeMWdNDwP/CAOc/wkbo1OhSKAH88I1y0mpdE9drrqRg
	 zjUehHRCWdVufCGZVz1vJJbcqbrlR71U6AJy/DIXT6WhN/EGF90M3LZlaj/iFSllSV
	 Dh45g7qpHLyXl1lt9aMTz5eYBnzTAclzE+xpZLZRDZt7VoMBbZ4YOijy6J5i8FpFM1
	 KW1eQv3GTbAtQ==
Date: Wed, 7 Aug 2024 19:08:09 +0900
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
Message-Id: <20240807190809.cd316e7f813400a209aae72a@kernel.org>
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

What tracing tools may be broke and why?

For this suffix problem, I would like to add another patch to allow probing on
suffixed symbols. (It seems suffixed symbols are not available at this point)

The problem is that the suffixed symbols maybe a "part" of the original function,
thus user has to carefully use it.

> 
> Sami, could you please share your thoughts on this? 

Sami, I would like to know what problem you have on kprobes.

Thank you,

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

