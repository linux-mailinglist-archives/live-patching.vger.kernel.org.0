Return-Path: <live-patching+bounces-1650-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F8CB56FEB
	for <lists+live-patching@lfdr.de>; Mon, 15 Sep 2025 07:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1FD03A4774
	for <lists+live-patching@lfdr.de>; Mon, 15 Sep 2025 05:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223EE275B1B;
	Mon, 15 Sep 2025 05:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKgQ34JA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F252920E6E3
	for <live-patching@vger.kernel.org>; Mon, 15 Sep 2025 05:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757915559; cv=none; b=r6MGiCSajuMN1Rm97aZ9LahmnSRPaGoA5C4vnQq939tROUmvJVEJAzBmjJzUm6DqDtpCxJZUtXvsot9fJfAACjrsM2ALnDCLzkGk8OzV6Adjt7+p7qi9kXDdL8ruq/6rt/6E7o55UN+S/4oTLMnIViAboNZnMRPZpu/MCb9Vmik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757915559; c=relaxed/simple;
	bh=yJ4G6gWCyHjvrSjk2ZSLA+uz7hH91T4w1eX4A3rCfAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZosP5MnFTCS20bCmdo0SJDiKvUE5ttP2iOM8rd9A3qT2gVoO7ej1FgU3j/enCu+Ef8wVKahZFdscqvCKHKN4gmrNpTdcHFvQkvSDLz5uxohmOdIHTPPxLU5qQ6DWCQuYigWsBXadfxF0sEb/cRhjZWOKauMRmx+7Xfbn/k4mqp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKgQ34JA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3A5C4CEF1;
	Mon, 15 Sep 2025 05:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757915558;
	bh=yJ4G6gWCyHjvrSjk2ZSLA+uz7hH91T4w1eX4A3rCfAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HKgQ34JAUlu71k2SZGcwbA654jSNxgYoE+aE97e/xNM7ErB5sqxs46nGARIjtRO8K
	 YOhvgRzrqom27m6SvB/doA5ozBQvRK+ZPcSfJyszdsHEjLkElqH44eJ4p4GXRJPDe/
	 cyrwOk+HJjkU9VH64Qo4eZC6q1eSyWfmnTY+fk+ifm32Jn6wsliLJvOSnKSxWQIjUw
	 VsE3TFs1lSKMloK512v0L8zVYPxs/8INBeeqmC5sLNLttu8UnK3ZDwLoSt72Y3vgq8
	 1qWYJWHx7nb6bC34OHMVvpT92zQYlD3/tapLWFZuTcUa5ok+MufWN72xU9ZlXzo0XY
	 D9eiF6O35r3gg==
Date: Mon, 15 Sep 2025 11:13:35 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, live-patching@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2 0/3] powerpc/ftrace: Fix livepatch module OOL ftrace
 corruption
Message-ID: <zu74w6gtt4z6jqwkwjqamro4e3v5qwcotwwp76fgu7oghgwqla@bjhg53sknonx>
References: <20250912142740.3581368-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912142740.3581368-1-joe.lawrence@redhat.com>

On Fri, Sep 12, 2025 at 10:27:37AM -0400, Joe Lawrence wrote:
> This patch series fixes a couple of bugs in the powerpc64 out-of-line
> (OOL) ftrace support for modules, and follows up with a patch to
> simplify the module .stubs allocation code. An analysis of the module
> stub area corruption that prompted this work can be found in the v1
> thread [1].
> 
> The first two patches fix bugs introduced by commit eec37961a56a
> ("powerpc64/ftrace: Move ftrace sequence out of line"). The first,
> suggested by Naveen, ensures that a NOP'd ftrace call site has its
> ftrace_ops record updated correctly. The second patch corrects a loop in
> setup_ftrace_ool_stubs() to ensure all required stubs are reserved, not
> just the first. Together, these bugs lead to potential corruption of the
> OOL ftrace stubs area for livepatch modules.
> 
> The final patch replaces the sentinel-based allocation in the module
> .stubs section with an explicit counter. This improves clarity and helps
> prevent similar problems in the future.
> 
> Changes since v1: https://lore.kernel.org/live-patching/df7taxdxpbo4qfn7lniggj5o4ili6kweg4nytyb2fwwwgmnyo4@halp5gf244nn/T/
> 
> - Split into parts: bug fix x2, code cleanup
> - Call ftrace_rec_set_nop_ops() from ftrace_init_nop() [Naveen]
> - Update commit msg on cleanup patch [Naveen]
> 
> Joe Lawrence (3):
>   powerpc/ftrace: ensure ftrace record ops are always set for NOPs
>   powerpc64/modules: correctly iterate over stubs in
>     setup_ftrace_ool_stubs
>   powerpc64/modules: replace stub allocation sentinel with an explicit
>     counter
> 
>  arch/powerpc/include/asm/module.h  |  1 +
>  arch/powerpc/kernel/module_64.c    | 26 ++++++++------------------
>  arch/powerpc/kernel/trace/ftrace.c | 10 ++++++++--
>  3 files changed, 17 insertions(+), 20 deletions(-)

Thanks for fixing this! For the series:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


