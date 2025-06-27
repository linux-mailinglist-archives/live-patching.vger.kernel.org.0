Return-Path: <live-patching+bounces-1605-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D88D5AEBDDB
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 18:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6CDA188ED7A
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 16:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910912E9EBE;
	Fri, 27 Jun 2025 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNt8grNt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6709C185E7F;
	Fri, 27 Jun 2025 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751043205; cv=none; b=VbFIAC1C34App4Vmwla5KcnToOuDkYUily2VaE0p8xiRUD/M3m1FCuWLXnv7wMwqnHFyDxwoxVxT+aHnRksZ7m9ZycdinVZlqnk6lHDpqMMtQzbgkQC7l7uwJRGpNBooDSIhbyY9sNWEf9uim9Gum9v5bpNP0FiTpepQ6XYxjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751043205; c=relaxed/simple;
	bh=ccATosXyxXQlHe4NKAd5BvIv0kPJiggqGKY6i2T8wBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3slARsqnkbeMPQDFHWh7MnhvPXChffrzlqDhN/Csba9SgpCCe4f/YeGU3UZBomUK1VbWUxLO1f7vRk50A0rIpktnHjtUHjmsk6r05rVBpSmEFX4bNabbKmIMUab4X4YfDgwbDdMXuXxk1cfnr58dA8cffRp8D0jhMrOX+50lOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNt8grNt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DCDC4CEE3;
	Fri, 27 Jun 2025 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751043205;
	bh=ccATosXyxXQlHe4NKAd5BvIv0kPJiggqGKY6i2T8wBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XNt8grNtO46jdDDp3vVlMDMrRylSrDDuqJTB6+AoJlnQu7hr2uYR1N1pEmfnTqNJH
	 QwP5HWoXxmO0aW2OB5avIz7g46N/K3aaNR3CXeAIN8wuxJVSpu2RWSTOT6tMwaYxhf
	 R0X0VGhgdbYC/HLzd+V4e0C40IKx0UIGxFqrWPf0yqi+MRPnyrDZAnycllHVvqdCZU
	 uw4H5Wnkx8NqRw6aViyaIeYtLq2z3oOWOPsew9uW3tm9ZIiOGgxH20lXTn9JhHKCIc
	 FPqydLfDN13WEqv44Tp2R3XTvEvW0q5GSHbBJ7VJC9znzv3zFQguAAaK6JCkzMOKC4
	 P5cOwje3W812w==
Date: Fri, 27 Jun 2025 09:53:22 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 29/64] objtool: Mark prefix functions
Message-ID: <dy47cs5h55my4tsldr5e64wgk7njw4a2ka7uu766ptmeyudemh@vtmbvqb52yjc>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <f277ca3e78d662268d6303637b1bba71c2a22b1f.1750980517.git.jpoimboe@kernel.org>
 <20250627103158.GV1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250627103158.GV1613200@noisy.programming.kicks-ass.net>

On Fri, Jun 27, 2025 at 12:31:58PM +0200, Peter Zijlstra wrote:
> > +static inline bool is_prefix_func(struct symbol *sym)
> > +{
> > +	return is_func_sym(sym) && sym->prefix;
> > +}
> 
> func_is_prefix() ?

is the function a prefix though?

> Also, since we only ever set sym->prefix when is_func_sym(), this helper
> could avoid checking that again.

Indeed...

-- 
Josh

