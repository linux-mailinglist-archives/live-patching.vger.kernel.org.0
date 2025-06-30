Return-Path: <live-patching+bounces-1609-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C11CAAED5B1
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 09:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B02A818982BC
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 07:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B978220F37;
	Mon, 30 Jun 2025 07:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WCYzZIq+"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E2122127B;
	Mon, 30 Jun 2025 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268720; cv=none; b=aClKQmAl5MXg0mSAtmkgsGhm49YbJQLY5L8sUQi2HuLhTW7dH9zgXvYE4zc+bonjQKU9GtsiuxyejmoCxnFpsorGe4j74uiUbdXQeTvG7u0/e49T7VsyHZTw+Knuxg4DPW9RAKeqbHu7g5q4ovFUfwbYTDewhcZ7mtOGCuPcPkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268720; c=relaxed/simple;
	bh=3rYAjCRTrh6l66mjY4sYxk4vwQkRMIvjC4jv++QEL9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlNMV8NI4fFu57vMJ+OxZ5XnhpvOaqUSw2XKjW1z/y041euA2fmAj1K/mxHJMI2zIcoqZdUIiugSq+KV2p9bQ+bvF2qPYWiezPNFd216Qg5rYuhHYib+b5f8NpE7M8Mx4KOK/LMEJbb+S1a158R6wkQXObHnE26xAE2NfwQvpBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WCYzZIq+; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u0Dp7Gg4+QNsvSZ8/+JO1eFeH7KonMvVlVzeM0Jd988=; b=WCYzZIq+XmGkes3+ajxt/4QOrV
	hBpXUXcZew36OiTuUcZ77xVR8rvAyRNpBIZoUsbZJuz9Eyi90b91hp2uL7Yzi7hP2dO9b3TByd4KS
	C8ZgMOOKCtA2Ni2r3Rn0iVJS8FJ5wE2vqFKwXi1vnow2TyvQApwHdK2rbwHsTZH3VGGgZjxaCqb9S
	yjY3VguspqAOaYqSewKkB8yYVwYjJEwEUvMMOXLgrb6Zvx1Iq5/jWRGhv/Li6YwZj+i2DHYIPJjnM
	bewIpkW4YTSvTR039oA1EM+g1ybpCLHPldLTE73VEK0kWhVOvEY74esAW5Ousa2xskyc/kfc7xz/J
	taOkjPOQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uW8zR-00000006k02-2pFN;
	Mon, 30 Jun 2025 07:31:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B8930300125; Mon, 30 Jun 2025 09:31:44 +0200 (CEST)
Date: Mon, 30 Jun 2025 09:31:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v3 42/64] kbuild,x86: Fix special section module
 permissions
Message-ID: <20250630073144.GE1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <cf1cfb9042005be7bf0a1c3f2bdbeebc769e3ee4.1750980517.git.jpoimboe@kernel.org>
 <20250627105328.GZ1613200@noisy.programming.kicks-ass.net>
 <4ezl3egjv36fjkxkkswcianc5cg7ui6jpqw56e4ohlwipmuxai@kvgemh72rmga>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ezl3egjv36fjkxkkswcianc5cg7ui6jpqw56e4ohlwipmuxai@kvgemh72rmga>

On Fri, Jun 27, 2025 at 10:34:15AM -0700, Josh Poimboeuf wrote:
> On Fri, Jun 27, 2025 at 12:53:28PM +0200, Peter Zijlstra wrote:
> > On Thu, Jun 26, 2025 at 04:55:29PM -0700, Josh Poimboeuf wrote:
> > > An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> > > __bug_table so their entry sizes can be defined in inline asm.
> > > 
> > > However, those sections have SHF_WRITE, which the Clang linker (lld)
> > > explicitly forbids combining with SHF_MERGE.
> > > 
> > > Those sections are modified at runtime and must remain writable.  While
> > > SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> > > 
> > > To work around the linker interference, remove SHF_WRITE during
> > > compilation and restore it after linking the module.
> > 
> > This is vile... but I'm not sure I have a better solution.
> > 
> > Eventually we should get the toolchains fixed, but we can't very well
> > mandate clang-21+ to build x86 just yet.
> 
> Yeah, I really hate this too.  I really tried to find something better,
> including mucking with the linker script, but this was unfortunately the
> only thing that worked.
> 
> Though, looking at it again, I realize we can localize the pain to Clang
> (and the makefile) by leaving the code untouched and instead strip
> SHF_WRITE before the link and re-add it afterwards.  Then we can tie
> this horrible hack to specific Clang versions when it gets fixed.

Oh yeah, that might be nicer indeed!

