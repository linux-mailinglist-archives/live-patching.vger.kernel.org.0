Return-Path: <live-patching+bounces-1606-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F10C0AEBDE7
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 18:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD30C1899639
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 16:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D42B2EAB65;
	Fri, 27 Jun 2025 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCWLsIdC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E69EEDE;
	Fri, 27 Jun 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751043334; cv=none; b=VS1wZ6FbpqMgn82rNlAgy6rnZ3NY8JJY4ouF3ReVe3Es1d1HpxD0vvFoW4upZ9+FwuwgRlxEDXYQLpUF4qBn/9fYfpoN1+k5J5dWtjLtueStwvjHzX515fnN3qzkD47J+VKcy79sfyIH8k1upvNp0Wtxnzz0hjh8h/mHrQYbSFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751043334; c=relaxed/simple;
	bh=Yp5x1qAvIVckjNxZdzXQoxusyqiTWxQXK0b6azS+QuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTrTke00pwRHzwSN3J1CnoqSo5q3W1cFUmyzcBiUSm1X7P/em8Y0KII1OIGG8I63BiwyLQyGsme/HI2tJqba95/Fhvgohm56Z4B8UAkQ7/XCNP40hSIZM3gYld8HCFl78M684JRzIHk17ysJwxJ/eRKgYuE15hi/cWddEPMx3/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCWLsIdC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D23C4CEE3;
	Fri, 27 Jun 2025 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751043333;
	bh=Yp5x1qAvIVckjNxZdzXQoxusyqiTWxQXK0b6azS+QuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nCWLsIdCFXGSMIWDscE5n0stzwsjApyob+KlQk7bl+ibo3bXvfmtfzO21wijG17JH
	 mXmstkHmLOo2bvxvLgVXRpST0vM0ZETNZv++7Nlj7fGMTuDsBGWc2HUaHnwyyC9ELp
	 vDYP98p9lV+d6QKLcJh7BNjEw3DPnErLSinXlhG7F24n7qPQElbtnAPBJ9yyXw1Od7
	 49ZMdsGn8HGp/mETG2riqQaQQXSmK+WH2eIlKj3L1qyOe0oQaq0dgINqiay+Lwt6HF
	 79u2I9rLOIbaT29OurYwRIlGWu2T9eKqTiYU+WHJ2zkg+uJPfeyIXeZUtH3TtUNF1f
	 vHQ+dEFCrCPxQ==
Date: Fri, 27 Jun 2025 09:55:30 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 44/64] x86/jump_label: Define ELF section entry size
 for jump labels
Message-ID: <dhuk7aokj2hpqy3q65uqpv7bz4pwvg2zhngyfh44y7gmiujg4y@h6s354xixgf2>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <7217634a8158e56703dfe22199f1b9c08c501ae3.1750980517.git.jpoimboe@kernel.org>
 <20250627104818.GW1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250627104818.GW1613200@noisy.programming.kicks-ass.net>

On Fri, Jun 27, 2025 at 12:48:18PM +0200, Peter Zijlstra wrote:
> > +#define JUMP_TABLE_ENTRY(key, label)				\
> > +	".pushsection __jump_table,  \"aM\", @progbits, "	\
> > +	__stringify(JUMP_ENTRY_SIZE) "\n\t"			\
> 
> Argh, can you please not do this line-break. Yes it'll be long, but this
> is most confusing.

Yeah, I'll go indent that like the extable one.

> > @@ -29,6 +30,9 @@ int main(void)
> >  #else
> >  	DEFINE(LRU_GEN_WIDTH, 0);
> >  	DEFINE(__LRU_REFS_WIDTH, 0);
> > +#endif
> > +#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)
> 
> How is HAVE_ARCH_JUMP_LABEL_RELATIVE relevant here?

#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE

struct jump_entry {
	s32 code;
	s32 target;
	long key;	// key may be far away from the core kernel under KASLR
};

-- 
Josh

