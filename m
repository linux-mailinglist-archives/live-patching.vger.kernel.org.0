Return-Path: <live-patching+bounces-1476-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D16ACE74F
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 01:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD853172355
	for <lists+live-patching@lfdr.de>; Wed,  4 Jun 2025 23:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E27F25B1FF;
	Wed,  4 Jun 2025 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3S+JAQ/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B7979D0;
	Wed,  4 Jun 2025 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749081187; cv=none; b=Ya344sxV3YsVId419JbusWBn6fNA8jQKQoL5jcJBD6gOi+kO2BW43vNX95qMOJ9HcC8Qtj6BzkvOPcDBcH0y+t3hsrk5Y5/KUdHq4vb9i/73Vzt72HbFiHgG+FuvhOEazDQVk5+ONK5OZRyeqvBJrsOQoQae7Ve2oxa8lLZ4t1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749081187; c=relaxed/simple;
	bh=uHUGsqf5ZMZXheRER1HD5daqU3HlQsR4EkkzSEZSb8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nokOd89/8h809ONjM7N68gBxTpBdj/fJZ3Y40gZfcwKc64DM2wXwkbbW1fDTY/Gqm0Tvtf3JktwkGdAQrwtOZh7nSlGYmk4m3g8I6i+qeY5SueYvvaf5w+bbNc9V0btTE/RhbzwZps95yzhF0Ij46oTK+Z7Ak8UogA7qRoykVdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3S+JAQ/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9835AC4CEE4;
	Wed,  4 Jun 2025 23:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749081187;
	bh=uHUGsqf5ZMZXheRER1HD5daqU3HlQsR4EkkzSEZSb8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M3S+JAQ/d2afW4x7l30MX9OJsmIt8bLxLGfmz+Y1hrZgoLkWfSIIzNScSzIWKlNLJ
	 iSI6NN7tYkKecFqHeup2ezu3g++xwtcrAgXRAiLrOFKLifYLuraeNoQR9EABXvmuZo
	 wltya5BBow6tj2PelvgtGRtYmtONaOzD3/Ywc43gE4fgWge3cPSHMG8rIS5ld8Aa5l
	 Qh6djueuJbn+wIWFSew4WBCtwYhpxzwwXaMZZzogmm6h0ev/jAx+X6Ohal48HMnLH7
	 aUoP+u9J78HbTY6+OZwjBmvT1Y/jIrPwgHG9b1qLfPc2Q9l/79yU4iEBBqAYpBJx5v
	 UZVzVopW6jO5A==
Date: Wed, 4 Jun 2025 16:53:05 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 18/62] objtool: Fix x86 addend calculation
Message-ID: <tvf7obye6afduyyefjrgicut2ehtyy4dkabxzxudtb55njsoba@4bhwzl3ftxeo>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <8064f40394e9f0438a36f53f54e3b56f8e5b5365.1746821544.git.jpoimboe@kernel.org>
 <20250526102315.GK24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526102315.GK24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 12:23:15PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:16:42PM -0700, Josh Poimboeuf wrote:
> > On x86, arch_dest_reloc_offset() hardcodes the addend adjustment to
> > four, but the actual adjustment depends on the relocation type.  Fix
> > that.
> 
> > +s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
> >  {
> > -	return addend + 4;
> > +	s64 addend = reloc_addend(reloc);
> > +
> > +	switch (reloc_type(reloc)) {
> > +	case R_X86_64_PC32:
> > +	case R_X86_64_PLT32:
> > +		addend += insn->offset + insn->len - reloc_offset(reloc);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return addend;
> >  }
> 
> Should this not be something like:
> 
> s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
> {
> 	s64 addend = reloc_addend(reloc);
> 
> 	if (arch_pc_relative_reloc(reloc))
> 		addend += insn->offset + insn->len - reloc_offset(reloc);
> 
> 	return addend;
> }
> 
> instead?
> 
> AFAIU arch_pc_relative_reloc() is the exact same set of relocations.

Yeah that's better, thanks.

-- 
Josh

