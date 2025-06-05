Return-Path: <live-patching+bounces-1488-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C945ACF89C
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 22:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8C6E16C26C
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 20:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3EC202F65;
	Thu,  5 Jun 2025 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cn0pnvb9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220441FE44B;
	Thu,  5 Jun 2025 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749154367; cv=none; b=px3qp57NAHyy8s2ILsOtb4XiRRze0lsudIFegm4Erx0IGkEriQ/GW4PGqfjodEV0Y7vPD2CmUg/ALAECH0uZftH4wAJ1+SMaQHR8vq1J0KaOzO3meLzndHh7aVFmMJ92auYCJv3SsCpddd4Ri8DZ9slxTbKXlgha5Q2Y9w2ekxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749154367; c=relaxed/simple;
	bh=v+1wOsotRzGcLl4+pWDHHGDBSmgsLs2nD0tQqzlXX2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HG16/aGtQEJLsZTocYLqvzAtI3IOI0QfCYROGOCoDOYiDr4Khcqimcjp0id9aXu+gJV98YkF8XYxgMZWf2On2C1sDgEfQRRcVXUfUomI1VpVvz5huf9JMHO/XkZCd/uIXjePePNsv6olDm11SoQerm4S1ibhuxkQ6k2ncoXI+bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cn0pnvb9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F8AC4CEE7;
	Thu,  5 Jun 2025 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749154366;
	bh=v+1wOsotRzGcLl4+pWDHHGDBSmgsLs2nD0tQqzlXX2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cn0pnvb9wKhKvJTNY3YDs+mbPW1r4l3LQwSzRkDDbNsDPMvIg9tRNVMCOI+hi2n/c
	 O28Cp6MNrUyUZRMRiBzdkLcfCygfgTfXLqUusfU3g8YDGeSX0uUqa7/GZ9xoAk/pbr
	 LX55U7XvoX3YLOQH5MV7pXrL9WOGG6sAD/qOcQeIwI1W9TZV5CCgm8e5W7By5wP0Se
	 xtnQv2TO7Uvv1zwdyIPEMVAZfbsEr5ZfpnPteh2lLt/rTb1qk4w1ELh/Bx3lNbBjSa
	 euClTFxdtrVDasNBcV4GGO0/0moiMbTO924XswcRs3XATesqq9bQVUCm9M6jBg92az
	 +M5OfqAh4fG6A==
Date: Thu, 5 Jun 2025 13:12:43 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <jqwyjrmxnwn6lfthyulg3ps4akmw4l6aax66qk6unk7ia6fywm@h2atxp4bu5yq>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <20250526184700.GS24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526184700.GS24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 08:47:00PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> > +#define SEC_NAME_LEN		512
> >  #define SYM_NAME_LEN		512
> >  
> 
> > +static int validate_ffunction_fdata_sections(struct elf *elf)
> > +{
> > +	struct symbol *sym;
> > +	bool found_text = false, found_data = false;
> > +
> > +	for_each_sym(elf, sym) {
> > +		char sec_name[SEC_NAME_LEN];
> > +
> > +		if (!found_text && is_func_sym(sym)) {
> > +			snprintf(sec_name, SEC_NAME_LEN, ".text.%s", sym->name);
> 
> So given SYM_NAME_LEN is 512, this SEC_NAME_LEN should be at least 6
> more, no?

I suppose so.  There's also the .rela.text.* and .klp.rela.sec_objname.*
prefixes.  I'll just bump SEC_NAME_LEN to 1024.

I should also double check the snprintf() return codes.

-- 
Josh

