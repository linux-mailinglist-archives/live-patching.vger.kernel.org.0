Return-Path: <live-patching+bounces-596-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0EA796C3CF
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 18:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C4A21F26C71
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 16:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B7F1DEFD8;
	Wed,  4 Sep 2024 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sga6PWfW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6004C1DB55E;
	Wed,  4 Sep 2024 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466552; cv=none; b=DPdDEMLrLs60zsAJjYsvbn2hNhif5/IJM5NH6LyU0wg0CSToxBLaXJ7J9IQGLybrb5Cbg12HIS/oMwNNMxD8rH/mVryu2Q+S6RwHLECI8eraJd7ZYw3vEws35zYmocV2WH8PRRKYemEBEhpR351+R98G3+E9YpaZn7mCpXk80rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466552; c=relaxed/simple;
	bh=xCaWHSmBgBQ1hu7O2tST2ymPM4n+Wuz+5qgEwQQrVvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BX9Am/TAN4lEG08Y00jEGJzzuE2pDIfTlflT8jaHCkBe9uoWPL7A0qweQX15XA1GWv0sBjK8Je9u6jD1EVLLW47jX9xRPcLPqClrIjVSvhWYRACT//47YJ9Ec2skeCalqWZEX3MiYrPxSiB9J4ufwYO8fI4glPN4JwZWUoS1RTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sga6PWfW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79672C4CEC5;
	Wed,  4 Sep 2024 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725466551;
	bh=xCaWHSmBgBQ1hu7O2tST2ymPM4n+Wuz+5qgEwQQrVvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sga6PWfWxr0+FkmMcQuePtfL60XEWwJARFOnvQCsESAbyeaK+C29hKLdB/3qAWS82
	 avRYeM0wYI6PnlaGOD2QWSGuRvX4RVyGaoZcK+yyNljmsMDSYqEkMtVBenLR7yOqMh
	 0cYJk6WGprGiT6KRsQ6riBn1zQ1YNwIS1qhY4Oz5A2H+RRdWlOJQDC9iLMkURYte82
	 +L1/xI/nqbpCgdXc8raqwCbPp0Ggp3vGtmsUnctT5LzUdjChfsa7JRjDPYcjLUZo/O
	 Kf5Gub349RaS4i4nIQiEqgCC7oyYvtCae3gWQdPusipnRJrWc8U93t/rJQftjmEs8Q
	 HtEuI8z9NnitQ==
Date: Wed, 4 Sep 2024 09:15:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: laokz <laokz@foxmail.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 21/31] objtool: Fix x86 addend calcuation
Message-ID: <20240904161549.y3gif5bnyj7reysa@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <43433a745f6db5afb513d015a6181bc40be12b4f.1725334260.git.jpoimboe@kernel.org>
 <tencent_65EFC9C0B6F4B36D24BFAFBEBEE912D71A05@qq.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_65EFC9C0B6F4B36D24BFAFBEBEE912D71A05@qq.com>

On Wed, Sep 04, 2024 at 05:24:21PM +0800, laokz wrote:
> On Mon, 2024-09-02 at 21:00 -0700, Josh Poimboeuf wrote:
> > +++ b/tools/objtool/arch/loongarch/decode.c
> > @@ -20,9 +20,9 @@ unsigned long arch_jump_destination(struct
> > instruction *insn)
> >         return insn->offset + (insn->immediate << 2);
> >  }
> >  
> > -unsigned long arch_dest_reloc_offset(int addend)
> > +s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc
> > *reloc)
> >  {
> > -       return addend;
> > +       return reloc_addend(addend);
> 
> reloc_addend(reloc) ?

Oops!

As you can probably tell, I haven't tested (or compiled) anything other
than x86 yet.

-- 
Josh

