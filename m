Return-Path: <live-patching+bounces-1475-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23697ACE746
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 01:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3E037A6563
	for <lists+live-patching@lfdr.de>; Wed,  4 Jun 2025 23:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4BA22DA0B;
	Wed,  4 Jun 2025 23:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="teKtqi7X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E701C84C4;
	Wed,  4 Jun 2025 23:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749080952; cv=none; b=RHl29gWVStGhL3hDrsqyfEvDNnLLwGoQDOpd3CkdTBop44ECluLfKuRm9XgNQaphtA0gA53v/FbLTEc19DtmzoAAxmeAOX/KT2lhLLZYumeXStgYLWHjAtSJzuf1MMPShjGLhYlATNbLt4sAKstElCazRMGhhPYO2+kwUDK9Lak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749080952; c=relaxed/simple;
	bh=YH8gDqXeD9oEDKoAo3hLwkwwj8v25fUyBDPYXNcy1cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe+5NJ30Pdv+Z8ga0gvOCxsEE6P+0unl4L1lkvINLBtX8HKniEfT2TAwF6FVgU3PWv+bNcHMuwuvIHkwi68OtzZFnAlfX9KQYVewqPTbDV2Ul9HTQPac5BsVxryYfQRi/m0mSp7N/wEwtBv5CkaqHID/GHVN7lRpY5kAPOjDdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=teKtqi7X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5490DC4CEE4;
	Wed,  4 Jun 2025 23:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749080950;
	bh=YH8gDqXeD9oEDKoAo3hLwkwwj8v25fUyBDPYXNcy1cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teKtqi7X8CGHIkqeMCrZJLLLxjB/SfWOfMIIgSPOh0DaLB3K7MhbUc0OL5iyeM53M
	 v00fP0ykpWopW0m615oJaXu3PVKUM2j6Dng3YZidHpLQDui+1r7OIesZUv619Tdhej
	 Np9rTFlcaFdnyQc0dfL+vu+OtmFTKiJP8ht55xpV3dv3SEE0OJZexNuzxkgmFHRsJU
	 LlEmn1ELg4Fw+lSMKYnXmM/L06AyA03z8a5T7zko6SABs4fe5JY3iww08waNWQ6Dx8
	 3zVU1orilBEw0BAeZIikbAh7ZEptzhp3Xps2c0IPbwZNSdRxkpTh89Mpgn+mw9nvP/
	 72cHWmM6YYTrQ==
Date: Wed, 4 Jun 2025 16:49:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 35/62] objtool: Refactor add_jump_destinations()
Message-ID: <f5ikl4hbijv6xkjktwply7zwgwyupxgbbln6ghpyy4boqrachy@gvjmjqbr675j>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <70bf4b499941a6b19c5f750f5c36afcd6ffd216f.1746821544.git.jpoimboe@kernel.org>
 <29b3d533-94cf-4949-90a1-4a8c9d698a8a@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29b3d533-94cf-4949-90a1-4a8c9d698a8a@redhat.com>

On Fri, May 23, 2025 at 07:46:19AM -0400, Joe Lawrence wrote:
> > -		} else if (reloc->sym->sec->idx) {
> > -			dest_sec = reloc->sym->sec;
> > -			dest_off = reloc->sym->sym.st_value +
> > -				   arch_dest_reloc_offset(reloc_addend(reloc));
> 
> Way back in ("[PATCH v2 18/62] objtool: Fix x86 addend calculation"),
> arch_dest_reloc_offset() was replaced with arch_insn_adjusted_addend(),
> so I think that patch missed this callsite and breaks bisectability.

Fixed, thanks.

-- 
Josh

