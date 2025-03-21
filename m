Return-Path: <live-patching+bounces-1315-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13758A6B4B3
	for <lists+live-patching@lfdr.de>; Fri, 21 Mar 2025 08:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77D1817DFC1
	for <lists+live-patching@lfdr.de>; Fri, 21 Mar 2025 07:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE4F1E7C27;
	Fri, 21 Mar 2025 07:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nX+OR3/J"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC50E200B0;
	Fri, 21 Mar 2025 07:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541118; cv=none; b=ppYG66aSEihdzS42n48hY4rock9lCXNiIobm85SThtDu21MsC+PoKrqh3d97kMpaNJgKRzAhaeAmF1AWWlLHH9N11BwJRDrKZdCGCbjdDpSVBUxm7PDueag1PzKKGnsS6sYrXQjVNpdamhEm4kxIXlyLwVfa4uxt65ujnfDqErM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541118; c=relaxed/simple;
	bh=LudmvTxSdtMKoCGghxA/xCu1HALOjr3FVanGtdDN6VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mePuIdGbWwyjUuk40pHe5YR5Ib/WLBAeU/GiTliZwfCnMqdWENnzsCPTtUwjVEPSXQ07vW9o/vfthRyqRCs8TwT3mp15+HBY25V+1L9/4b/coSUFUpCaF7uUF/eLQ0LPZbErMnslLR7nSm+g33OL1kyB3nenwzyFcVlpUZ7HKhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nX+OR3/J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D46C4CEE8;
	Fri, 21 Mar 2025 07:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742541118;
	bh=LudmvTxSdtMKoCGghxA/xCu1HALOjr3FVanGtdDN6VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nX+OR3/JMJ4fn3FGm4PDb/rQ03GQ7tdgCyI6MNpkteWlE7XFsBOTnIJeTVaDbOEqJ
	 YwG3lhJVKBJxuLJNwbUoKQejA2nNXR5tYKo3Ym3aQP/TWAOM9FuU1BTVL0gORaGR0i
	 S9azE0cUwgubeLAXXdGmyBglyuIotoKDx4mCVyewudX8iVHqUpMrwRJm666DUZxbSA
	 50tKZY84fUuvQCs4s8/Xjd1fxjhlFvoJKB0ng8+G1KmyT3hAyn/RTKegJOcdmNdgjR
	 xYbQSInOJpfmm8+YuDDqwLucXYea+eG03AUghYbeHnxL9n/LKtJw7dh+hes02Q+Qz/
	 AqpXvIRsEbkvw==
Date: Fri, 21 Mar 2025 00:11:55 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, indu.bhagat@oracle.com, 
	puranjay@kernel.org, wnliu@google.com, irogers@google.com, joe.lawrence@redhat.com, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <etrj2xdtc6djnwtwlghymlu4c3gg5wnyg3qqfdiod4g6hjgzzi@yxj6no3stqjv>
References: <20250320171559.3423224-1-song@kernel.org>
 <20250320171559.3423224-2-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250320171559.3423224-2-song@kernel.org>

On Thu, Mar 20, 2025 at 10:15:58AM -0700, Song Liu wrote:
> With proper exception boundary detection, it is possible to implment
> arch_stack_walk_reliable without sframe.
> 
> Note that, arch_stack_walk_reliable does not guarantee getting reliable
> stack in all scenarios. Instead, it can reliably detect when the stack
> trace is not reliable, which is enough to provide reliable livepatching.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh

