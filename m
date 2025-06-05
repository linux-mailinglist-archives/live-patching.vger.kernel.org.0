Return-Path: <live-patching+bounces-1480-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD8EACE774
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 02:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6DC91894D6A
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 00:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9094C4A33;
	Thu,  5 Jun 2025 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srTo5u8b"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BF63FFD;
	Thu,  5 Jun 2025 00:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082795; cv=none; b=n4Uutlz/y16GJ55gM8uHxv7biAUsXzNUYCWiLbiGNF4jLKGXtP2IhytaMALNZDzME8qfGrYlNJAtOZB5TKyi6cn5lVon6klaiS+JgiBRSzjhqzgI/Pwx579Bxqn3KAfl4J0IMD+TxJser50zSWqXMwPBPshKWXAVJ27uO0o9d0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082795; c=relaxed/simple;
	bh=VlBPHKswdFhEZ3uF2RVOWoy66b5PdtafEBvGKyASFks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSJmbVVqpCdfDSQrFP9u+NtA+jAPngE1bMDV25m8pCyIf+frp6WEoiZ8RyI/7VXyfvBA5w5eu490IIgSNO1JkiJGXFWpuepbqRflMrlTE2qJ3VLVuiKQmCqMfjC8jmGoCmCZk7aXi7fjFXvQjJdwoTI6TVocSv1bQOn2FoV0f8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srTo5u8b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF48C4CEE4;
	Thu,  5 Jun 2025 00:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749082794;
	bh=VlBPHKswdFhEZ3uF2RVOWoy66b5PdtafEBvGKyASFks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srTo5u8bdcK+mRQcTiVDZD2km4vcQ4GycZv4CBI3adRgnf1DO0xDM8Om2jPlybJ+m
	 qYJqFTCGWGdlifjAPMssjw1uTNDSdy39U0AxafS2BgXt+aUNXtX3hPARxJlE903jy5
	 WTZF12h+XLLBnCTbswDK5vN7jKEiKIftOxXVS+bujHAXy4hYe4O1BDZBKKI3ffpI4H
	 BxAk+IBfo/6UJwcgO+MqVnueMOiUKnxpdFZZ+TFOeICBcp+AwYMjoFKRBmsAOfCjZp
	 Ek4VOQzjhx+dxUW/UGlVHIxuYltVrIXjyTA5WaZyhaR+mI1+5XQQURTY1k9WlmxSIw
	 XmShEl5rWP+6w==
Date: Wed, 4 Jun 2025 17:19:51 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 32/62] objtool: Suppress section skipping warnings
 with --dryrun
Message-ID: <ycpdd352wztjux4wgduvwb7jgvt6djcb57gdepzai2gv5zkl3e@3igne4ssrjdm>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
 <20250526105240.GN24938@noisy.programming.kicks-ass.net>
 <20250528103453.GF31726@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250528103453.GF31726@noisy.programming.kicks-ass.net>

On Wed, May 28, 2025 at 12:34:53PM +0200, Peter Zijlstra wrote:
> On Mon, May 26, 2025 at 12:52:40PM +0200, Peter Zijlstra wrote:
> > On Fri, May 09, 2025 at 01:16:56PM -0700, Josh Poimboeuf wrote:
> > > It's common to use --dryrun on binaries that have already been
> > > processed.  Don't print the section skipping warnings in that case.
> > 
> > Ah, I rather like this warning, it gives me an easy check to see if the
> > file has already been processed.
> > 
> > I typically do a OBJTOOL_ARGS="--backup" build and run dryrun debug
> > sessions against those .orig files.
> 
> Turns out, you already broke this.. :-(
> 
> I'm now having a case where objtool fails on vmlinux.o and make happily
> deletes vmlinux.o and I'm left empty handed.
> 
> Let me go resurrect --backup

Yeah, as I just mentioned in that other email, --verbose should give you
what you need.  It also prints the cmdline args, which is nice.

But also, feel free to resurrect --backup, or you can yell at me to do
it as the backup code changed a bit.

-- 
Josh

