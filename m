Return-Path: <live-patching+bounces-1293-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A709A67C33
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 19:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E578B3B72F1
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 18:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952C71A5BAD;
	Tue, 18 Mar 2025 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3SC6WWD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6A91684A4;
	Tue, 18 Mar 2025 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742323543; cv=none; b=gYAmthRHog2w7t1FA+hhCyBKLtsXgSLdSYI3vgDeOUx2Ds51MzgNPZyiNMYfGWoQzpVsGTtq2UVAWBqwZYXg4aHhm+7EJHTADu03U8r8DPd9gwLYlBpaNb2Au3BkxJqHOkvrrwk3boZOmlQW1cgr3cWB1lHaad//Gh/hTlnYG6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742323543; c=relaxed/simple;
	bh=n+PUy+yopYknWroJKoiUzm5LTEE1VxdaPvpJQi/jNwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5TMrmlAW28OgxlIFvutBkA9lpWHUZLad2Xt+EmkI2nJ6+6aesNp60BFwR6cUIsbM2UDJ3Y9bPpF1B2ekhFvPWThtMr2+tYwdfWW7oOeSITbA7SogtI3JSytdnPaTLBDNgcm/K9jZGH3Bb/AuGQw+jI6aDe47KAPTHy+03BBOHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3SC6WWD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1F4C4CEF3;
	Tue, 18 Mar 2025 18:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742323542;
	bh=n+PUy+yopYknWroJKoiUzm5LTEE1VxdaPvpJQi/jNwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n3SC6WWDV15A2K2efve0VqxxDLf0xP6wH/IFBx9zD4fq5jCClG86D5pFmrdUtd7q3
	 ZPX7jUZx5Dz/ayPCQsyXyVnhbaBZ/CLHTLlb/O8YgvdzSMjiTL7Xq5jviMlmEUI+e4
	 e0p8pUQatcGeicbTO0IvDr22XfuZ0aFE+wlQPmPaB/9ymzT+oHwpPTB6l3SJVk3lus
	 WY3s1IUzlCZ8bLFYccLqdtLUL4v92bSd93MulspnauZBwoSMuOJuKyqYZkYYwuBeah
	 rJdirlmWrZUSvxrkWkwRmV9hhrJPPx42U4lhWyvMOhBIYaAiIL+1euGSohYUPdONPB
	 qa9OJGULvLtZg==
Date: Tue, 18 Mar 2025 11:45:40 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, indu.bhagat@oracle.com, 
	puranjay@kernel.org, wnliu@google.com, irogers@google.com, joe.lawrence@redhat.com, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
References: <20250308012742.3208215-1-song@kernel.org>
 <20250308012742.3208215-2-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250308012742.3208215-2-song@kernel.org>

On Fri, Mar 07, 2025 at 05:27:41PM -0800, Song Liu wrote:
> With proper exception boundary detection, it is possible to implment
> arch_stack_walk_reliable without sframe.
> 
> Note that, arch_stack_walk_reliable does not guarantee getting reliable
> stack in all scenarios. Instead, it can reliably detect when the stack
> trace is not reliable, which is enough to provide reliable livepatching.
> 
> This version has been inspired by Weinan Liu's patch [1].
> 
> [1] https://lore.kernel.org/live-patching/20250127213310.2496133-7-wnliu@google.com/
> Signed-off-by: Song Liu <song@kernel.org>

This looks incomplete.  The reliable unwinder needs to be extra
paranoid.  There are several already-checked-for errors in the unwinder
that don't actually set the unreliable bit.

There are likely other failure modes it should also be checking for.
For example I don't see where it confirms that the unwind completed to
the end of the stack (which is typically at a certain offset).

See for example all the error conditions in the x86 version of
arch_stack_walk_reliable() and in arch/x86/kernel/unwind_frame.c.

-- 
Josh

