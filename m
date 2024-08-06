Return-Path: <live-patching+bounces-445-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCA89498BE
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 22:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B5C1B23052
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 20:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2492155307;
	Tue,  6 Aug 2024 20:01:03 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920731547DE;
	Tue,  6 Aug 2024 20:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722974463; cv=none; b=bMCa4dWsuMpdZfRZeeZv5E+XYzG/eUhDOVDr0PeySBC7YI9HIm8/O9Rr0iGTDd87bnSk5e4388JdQdHTssJnToG3vXUPtdSXt/UJdTkOU5L8dfmkqeuGVnmqe4KCh2nrbaBT38HETm9dCTIM+YhJpv5mb4SWMaH9j1L8QMo/nBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722974463; c=relaxed/simple;
	bh=LtvbirBLl/FBSBSTs2FebEYxe3x5raFLdt0tu1khpII=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5L+BbebHIQDBf6dTBs7ly3PshmkBEpqscE380E/yZ7KHgF5mWvOPHX4uCDowrCPljPQWfUT6reej0NmhNrqgaNL1gNEJVcOweLscL/gpFY2KbmROVOdQJ5XWMzXnm416yCNWKVN6V3ozB1Fg65EtR8QarDf/sc5/5Gt9d/kh/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BC8C32786;
	Tue,  6 Aug 2024 20:01:00 +0000 (UTC)
Date: Tue, 6 Aug 2024 16:01:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <songliubraving@meta.com>
Cc: Song Liu <song@kernel.org>, "live-patching@vger.kernel.org"
 <live-patching@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe
 Lawrence <joe.lawrence@redhat.com>, Nathan Chancellor <nathan@kernel.org>,
 "morbo@google.com" <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Leizhen
 <thunder.leizhen@huawei.com>, "kees@kernel.org" <kees@kernel.org>, Kernel
 Team <kernel-team@meta.com>, Matthew Maurer <mmaurer@google.com>, Sami
 Tolvanen <samitolvanen@google.com>, Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-ID: <20240806160149.48606a0b@gandalf.local.home>
In-Reply-To: <20240806160049.617500de@gandalf.local.home>
References: <20240802210836.2210140-1-song@kernel.org>
	<20240802210836.2210140-4-song@kernel.org>
	<20240806144426.00ed349f@gandalf.local.home>
	<B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
	<20240806160049.617500de@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Aug 2024 16:00:49 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > >> + if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
> > >> + addr = kallsyms_lookup_name_without_suffix(trace_kprobe_symbol(tk));
> > >> +    
> > > 
> > > So you do the lookup twice if this is enabled?
> > > 
> > > Why not just use "kallsyms_lookup_name_without_suffix()" the entire time,
> > > and it should work just the same as "kallsyms_lookup_name()" if it's not
> > > needed?    
> > 
> > We still want to give priority to full match. For example, we have:
> > 
> > [root@~]# grep c_next /proc/kallsyms
> > ffffffff81419dc0 t c_next.llvm.7567888411731313343
> > ffffffff81680600 t c_next
> > ffffffff81854380 t c_next.llvm.14337844803752139461
> > 
> > If the goal is to explicitly trace c_next.llvm.7567888411731313343, the
> > user can provide the full name. If we always match _without_suffix, all
> > of the 3 will match to the first one. 
> > 
> > Does this make sense?  
> 
> Yes. Sorry, I missed the "&& !addr)" after the "IS_ENABLED()", which looked
> like you did the command twice.

But that said, does this only have to be for llvm? Or should we do this for
even gcc? As I believe gcc can give strange symbols too.

-- Steve

