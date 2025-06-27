Return-Path: <live-patching+bounces-1603-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A23AAEBC29
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 17:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D09633A78A4
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 15:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E5D2E1C7F;
	Fri, 27 Jun 2025 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ep2KcfjS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB9E2750E7;
	Fri, 27 Jun 2025 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751038935; cv=none; b=rpX0O5SCd/f1tNVMnINtDLDkRUBDnm3lAbyv4qSmbB9HuWsgoSm5dmxkpFr71pR4WToVsx8cj1oqXSrxZ0kkquRJMJIddybz/Im7N8IW8vsmxJjyvD6HQ8IIiFYW4hCDASA5QY4FEz+gpSxtC5h1iC0omJREm9dUb5saakGN3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751038935; c=relaxed/simple;
	bh=WFAN7EW/n4gUHqFudLKPDPjqeABmZo3zQslljOqjU+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9+fx3eZucXPaCOx3fI61qbxiMgKckN4n6e+qHfdqlZAAnCLfqoLK9zFwSQItJKKwfSXYXXKeQyCl0eaaKZs79GUq4KwbrCvawDnBri8MYnxAYFnpt6mL983oSFryc8JM9DkXCTFcLPup6ma8OoGsQcXG0qecijNvSFq2WpZMo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ep2KcfjS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518DBC4CEE3;
	Fri, 27 Jun 2025 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751038934;
	bh=WFAN7EW/n4gUHqFudLKPDPjqeABmZo3zQslljOqjU+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ep2KcfjSk8obvu/zlhoVnB5L+kp1KUfoqDAkZ2uKAJClaaiHPLfUUrgs1u3iK/5oB
	 qp2Em6LhMl6DIDG3QLloASHfI73M0RG8jjt+9+0hR+oRotOYlYSezsFAN9ZkqHA43R
	 r4Otz6LLaiRAScEv+I7R2mS4ZzUGhdYNqnrA3NM+cEdo4TtinnKn1A7QmZPNy9mZzS
	 pOUJopilDKCqlorUHMoae4F+UpZWiHWZ2BOT50ZyFbaTEr9AlgD1z760a6vO9pvp2x
	 hD/XMVjI7GYDP0C8bcWZj6rnV3xNH5CuzsDlTRfMDE7FAH/uo+5OL2h4dAepDPdtVY
	 L9uSu/qPrsfCA==
Date: Fri, 27 Jun 2025 08:42:11 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 17/64] objtool: Fix weak symbol detection
Message-ID: <5x6xrmb6srf6arbx354jegakel2pe6b3eh3xokemjeuagbm7s6@ywwoh4gbyhyu>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <19b1efe3f1f6bac2268497e609d833903aa99599.1750980517.git.jpoimboe@kernel.org>
 <20250627091310.GT1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250627091310.GT1613200@noisy.programming.kicks-ass.net>

On Fri, Jun 27, 2025 at 11:13:10AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 26, 2025 at 04:55:04PM -0700, Josh Poimboeuf wrote:
> > find_symbol_hole_containing() fails to find a symbol hole (aka stripped
> > weak symbol) if its section has no symbols before the hole.  This breaks
> > weak symbol detection if -ffunction-sections is enabled.
> > 
> > Fix that by allowing the interval tree to contain section symbols, which
> > are always at offset zero for a given section.
> > 
> > Fixes a bunch of (-ffunction-sections) warnings like:
> > 
> >   vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x10: unreachable instruction
> > 
> > Fixes: 4adb23686795 ("objtool: Ignore extra-symbol code")
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  tools/include/linux/interval_tree_generic.h | 2 +-
> >  tools/objtool/elf.c                         | 8 ++++----
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/include/linux/interval_tree_generic.h b/tools/include/linux/interval_tree_generic.h
> > index aaa8a0767aa3..c0ec9dbdfbaf 100644
> > --- a/tools/include/linux/interval_tree_generic.h
> > +++ b/tools/include/linux/interval_tree_generic.h
> > @@ -77,7 +77,7 @@ ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
> >   *   Cond2: start <= ITLAST(node)					      \
> >   */									      \
> >  									      \
> > -static ITSTRUCT *							      \
> > +ITSTATIC ITSTRUCT *							      \
> >  ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
> >  {									      \
> >  	while (true) {							      \
> 
> IIRC this file is a direct copy from the kernel; this should probably be
> changed in both?

Ok.  We should probably enforce that with the sync-check script.

-- 
Josh

