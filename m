Return-Path: <live-patching+bounces-454-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE95494B0E9
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A73571F24655
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 20:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714D5145A0A;
	Wed,  7 Aug 2024 20:08:32 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505BA364BC;
	Wed,  7 Aug 2024 20:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723061312; cv=none; b=E2RTvzq1hPsporr6oSmjEJpjNSC7FRz7BOLSs6JhhEKyp2G3QAilCxhG+uEibQbYoBt6cobHON6yXaNewQowJ+1Upgk8pDe6aXHIASQhR01G8ki4kpbrWxef7Yh02x1udfx+0b6F32LQiTJ21MerQ+dEwtCw5uDKdl6YrRC/Sjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723061312; c=relaxed/simple;
	bh=VlF0Eedmz7/4NAV+JIdWlb1hHgZwCVfOaxXUkFTCDCw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLNQ6kF0uX5o7MniYdRQMU7QiEBgvCjn/S5zwqu8dDPlMWuMpG2RD8wgug1B1vJcBuOEc7ASWQjmMwreKFHZl8CeFkhIZYvMigk+kK+iUUniTMKY0vJ39tpWmL8INfgzjNzaa8o3kEBiFhnbt4Ugbc2oOiYfMxi6O5omo50pp6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0ACC32781;
	Wed,  7 Aug 2024 20:08:27 +0000 (UTC)
Date: Wed, 7 Aug 2024 16:08:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <songliubraving@meta.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
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
Message-ID: <20240807160826.269f27f8@gandalf.local.home>
In-Reply-To: <2622EED3-19EF-4F3B-8681-B4EB19370436@fb.com>
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
	<2622EED3-19EF-4F3B-8681-B4EB19370436@fb.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Aug 2024 19:41:11 +0000
Song Liu <songliubraving@meta.com> wrote:


> It appears there are multiple APIs that may need change. For example, on gcc
> built kernel, /sys/kernel/tracing/available_filter_functions does not show 
> the suffix: 
> 
>   [root@(none)]# grep cmos_irq_enable /proc/kallsyms
>   ffffffff81db5470 t __pfx_cmos_irq_enable.constprop.0
>   ffffffff81db5480 t cmos_irq_enable.constprop.0
>   ffffffff822dec6e t cmos_irq_enable.constprop.0.cold
> 
>   [root@(none)]# grep cmos_irq_enable /sys/kernel/tracing/available_filter_functions
>   cmos_irq_enable

Strange, I don't see that:

  ~# grep cmos_irq_enable /proc/kallsyms 
  ffffffff8f4b2500 t __pfx_cmos_irq_enable.constprop.0
  ffffffff8f4b2510 t cmos_irq_enable.constprop.0

  ~# grep cmos_irq_enable /sys/kernel/tracing/available_filter_functions
  cmos_irq_enable.constprop.0

-- Steve

> 
> perf-probe uses _text+<offset> for such cases:
> 
>   [root@(none)]# cat /sys/kernel/tracing/kprobe_events
>   p:probe/cmos_irq_enable _text+14374016 
> 
> I am not sure which APIs do we need to change here. 
> 
> Thanks,
> Song
> 
> 


