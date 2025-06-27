Return-Path: <live-patching+bounces-1595-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E05AEB28F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 11:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D97CF566F62
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 09:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA302C08BB;
	Fri, 27 Jun 2025 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bwkUVUgA"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CAB293C66;
	Fri, 27 Jun 2025 09:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751015606; cv=none; b=lUaE+VmLQcUE5lDcaztPsotj/pRamfEsViGnk7cZWn3QFGyvkmd8GN6wqLatdHVOqGpcR4xrQw2JM+cRKp82e733uv9uMXUjkdUALvz0MZoFQyWk7qR4XgH+wE8U92lIQDwYBX9ulTvABcfgN+W1F5MFyi5B9gz02MAuRgHSyJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751015606; c=relaxed/simple;
	bh=poWVzOnHetZgZU7IdKfAmHG/waKkAXe7Ld6cd9s7APc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5MK8fWV3iYfxFWXr6BF8btHtVb9jyjdbfpFjZOpabIDixcj76OVhTf7bkQbzWYcVeodwKZIQlfN8/lNgileu2d6U5PKk0Dxiw4x4m5ZsghUhV+LsN0d8TL0CJd7+6LfjLCOCNlS9domi2U1JuknW+hByOVvke3AYYSWgW0Vk4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bwkUVUgA; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jm4R/gQ1agew1insNV1QFxJtrJoIL+kzIrLuWUHpbLw=; b=bwkUVUgA1yQ6yfsPR8uVtfI39r
	KN4WCmC9f8s3NSJujCXr7Zi4Sk18FCbCBFmxt4XhBQbgPHlFdy3u5cUZVaEJuYAg9n40KyepMrbQK
	RwYW/bObLrrdSsPZjZppOyfH+6jS1JqfO4qLsn2LvpmQXsLBIarS4i5Db3EF1PckJZdeneDwTPw8K
	Rij7AoW/mHkOAzv4G6iUHGgNXiSDsRMGV5iHO68UsMnYpSu516bbEzebbtstDkhsRGheE5Wkzpi6T
	zNm+yukOhGzytWL/l7BaWD9nHQqvsrhHECwXQ9GlIDk+dkmUVWoZaC5HojsVvDMKRVqt7x74dHgS3
	DCVMovCQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV58x-00000006HbP-3n0F;
	Fri, 27 Jun 2025 09:13:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B81ED300222; Fri, 27 Jun 2025 11:13:10 +0200 (CEST)
Date: Fri, 27 Jun 2025 11:13:10 +0200
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 17/64] objtool: Fix weak symbol detection
Message-ID: <20250627091310.GT1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <19b1efe3f1f6bac2268497e609d833903aa99599.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19b1efe3f1f6bac2268497e609d833903aa99599.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:04PM -0700, Josh Poimboeuf wrote:
> find_symbol_hole_containing() fails to find a symbol hole (aka stripped
> weak symbol) if its section has no symbols before the hole.  This breaks
> weak symbol detection if -ffunction-sections is enabled.
> 
> Fix that by allowing the interval tree to contain section symbols, which
> are always at offset zero for a given section.
> 
> Fixes a bunch of (-ffunction-sections) warnings like:
> 
>   vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x10: unreachable instruction
> 
> Fixes: 4adb23686795 ("objtool: Ignore extra-symbol code")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/include/linux/interval_tree_generic.h | 2 +-
>  tools/objtool/elf.c                         | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/include/linux/interval_tree_generic.h b/tools/include/linux/interval_tree_generic.h
> index aaa8a0767aa3..c0ec9dbdfbaf 100644
> --- a/tools/include/linux/interval_tree_generic.h
> +++ b/tools/include/linux/interval_tree_generic.h
> @@ -77,7 +77,7 @@ ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
>   *   Cond2: start <= ITLAST(node)					      \
>   */									      \
>  									      \
> -static ITSTRUCT *							      \
> +ITSTATIC ITSTRUCT *							      \
>  ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
>  {									      \
>  	while (true) {							      \

IIRC this file is a direct copy from the kernel; this should probably be
changed in both?

