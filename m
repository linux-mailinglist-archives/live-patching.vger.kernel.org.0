Return-Path: <live-patching+bounces-1459-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CB6AC3DC6
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 12:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65F63189629F
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 10:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68731F4611;
	Mon, 26 May 2025 10:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HOOYW56h"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDB6143C61;
	Mon, 26 May 2025 10:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748255012; cv=none; b=O3wwnXlX9zWKQb+N2WD4rAWbBm+7ST0eSjvqF95HYuUTt+k/XPhCm3lgijt9es/+z6iApJPv+IhztiC/kPkbXApgGTQx3ONOVnKpq+AzSkDYhBd7FMIrcitlwl7mI94lykZAJPioGJbOAoYkHvets5JDNcus9RpJ+j8QapyzSLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748255012; c=relaxed/simple;
	bh=xnQ6VmXRAwGuRZ5aPYiYgFzNnkSeQSoU+MVnGMzg23k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHVhjDBbuasor6lAhblcY8MAVWHD4YmJsAv64V9jtxc5rZ4/wlJw+NBMIK+XzYGgiPuFKqLrFzLPTJQcs5idirXH1IKHydtkDuY+stKG3LUpp5bqr/zTwcXP2E6lG789ZtiuOnSzIjy9z1DZZpy7BgCijA02guQdeCcpRh9cjzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HOOYW56h; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cgs5/uCgKWvg2WW05ScLvnLsCpBRvuGnBxviL1faJB0=; b=HOOYW56h9te7cwsmaaN5N1VBW1
	rsov8WhEkM/50QZGK4FVLZIjJuf4l0cfJdABB18/h3NucmhKVZvpsKXduv6ZDq9LbXSllJ1IttnAb
	X/lhFMnBFWcN9vuNRKrNgfK+KrEoIz79Sk6X14i7FkZ4NJCKGruJncb6fys65jWJKyvmFjVDORDcR
	OTkclYCO0Evu5ey8cVdllfcDMvPPyt7E6fc3ZR+ulXPddt8KWVmV1VCIn3y2CpbaeNXDL0/BMbpk0
	yNcyZnfShQ0ejC1PGWwwRnjX9Zleij/5AaGPCebbab5GUag5Bx0Nm49gjl++sBtJVTZrEr4u4Wfek
	MyByUrAw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJUzD-0000000BIlD-3GK0;
	Mon, 26 May 2025 10:23:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 29919300472; Mon, 26 May 2025 12:23:15 +0200 (CEST)
Date: Mon, 26 May 2025 12:23:15 +0200
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 18/62] objtool: Fix x86 addend calculation
Message-ID: <20250526102315.GK24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <8064f40394e9f0438a36f53f54e3b56f8e5b5365.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8064f40394e9f0438a36f53f54e3b56f8e5b5365.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:16:42PM -0700, Josh Poimboeuf wrote:
> On x86, arch_dest_reloc_offset() hardcodes the addend adjustment to
> four, but the actual adjustment depends on the relocation type.  Fix
> that.

> +s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
>  {
> -	return addend + 4;
> +	s64 addend = reloc_addend(reloc);
> +
> +	switch (reloc_type(reloc)) {
> +	case R_X86_64_PC32:
> +	case R_X86_64_PLT32:
> +		addend += insn->offset + insn->len - reloc_offset(reloc);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return addend;
>  }

Should this not be something like:

s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
{
	s64 addend = reloc_addend(reloc);

	if (arch_pc_relative_reloc(reloc))
		addend += insn->offset + insn->len - reloc_offset(reloc);

	return addend;
}

instead?

AFAIU arch_pc_relative_reloc() is the exact same set of relocations.

