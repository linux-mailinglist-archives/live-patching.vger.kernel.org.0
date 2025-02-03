Return-Path: <live-patching+bounces-1104-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6D7A25E7C
	for <lists+live-patching@lfdr.de>; Mon,  3 Feb 2025 16:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FA93164542
	for <lists+live-patching@lfdr.de>; Mon,  3 Feb 2025 15:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E770209F22;
	Mon,  3 Feb 2025 15:15:46 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F081B209692;
	Mon,  3 Feb 2025 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738595746; cv=none; b=TWkEPw61TlT5fKWQQTRpJDNLKX+RaHAGkaR7k0j1qvqHmsCkrxQspo+T33sTIAIDTM8VNugUmacTBVwIuXfY+Qj8nL9i7hPn5hqtEszbfMiuTU04SqIOfbtF/MOFWZUDpTTABL4FktmiHp3Gt+8eZ2F3rOtSXalKUNik/YkxCsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738595746; c=relaxed/simple;
	bh=nSgaTk7sgqIAPQz07Pe8LcdQw/W6+/u38L8WjM4fMaY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiQcEvWAB6Wr4aPs9Z1bt/x6l2ZUJ/SJvnjJ3flZ89WtcGT+SLvE4M5/cwdJwhXKNxc0kUvQdA0QKjB3jMtUj79vVugl0bwWQ5n/yLmZfkVLbOxQfH4dx0WUxuw0QMwAdU3j+bT075wO4pz9OSqiVoaeGHeDQbIVMHasK6EUj/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66F2C4CED2;
	Mon,  3 Feb 2025 15:15:43 +0000 (UTC)
Date: Mon, 3 Feb 2025 10:16:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Cc: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra
 <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 roman.gushchin@linux.dev, Will Deacon <will@kernel.org>, Ian Rogers
 <irogers@google.com>, linux-toolchains@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/8] arm64: Enable livepatch for ARM64
Message-ID: <20250203101617.5300f930@gandalf.local.home>
In-Reply-To: <ceabc7b5-a9b8-4f3b-9a73-5cc2af4e9af9@linux.microsoft.com>
References: <20250127213310.2496133-1-wnliu@google.com>
	<20250127213310.2496133-9-wnliu@google.com>
	<ceabc7b5-a9b8-4f3b-9a73-5cc2af4e9af9@linux.microsoft.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jan 2025 21:38:46 +0530
Prasanna Kumar T S M <ptsm@linux.microsoft.com> wrote:

> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -271,6 +271,8 @@ config ARM64
> >   	select HAVE_SOFTIRQ_ON_OWN_STACK
> >   	select USER_STACKTRACE_SUPPORT
> >   	select VDSO_GETRANDOM
> > +	select HAVE_RELIABLE_STACKTRACE if SFRAME_UNWINDER
> > +	select HAVE_LIVEPATCH		if HAVE_DYNAMIC_FTRACE_WITH_ARGS && HAVE_RELIABLE_STACKTRACE
> >   	help
> >   	  ARM 64-bit (AArch64) Linux support.
> >   
> > @@ -2498,3 +2500,4 @@ source "drivers/acpi/Kconfig"
> >   
> >   source "arch/arm64/kvm/Kconfig"
> >   
> > +source "kernel/livepatch/Kconfig"  
> 
> Will this work for ftrace'd (kprobe'd) function as well?

What work? The stack walker? It may require updates to the tracing
trampolines, but it should be doable just like ORC is.

-- Steve

