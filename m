Return-Path: <live-patching+bounces-1208-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0079AA3665B
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 20:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 882C118923FD
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6461D7985;
	Fri, 14 Feb 2025 19:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If1z8UYM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DE91C84B3;
	Fri, 14 Feb 2025 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739562164; cv=none; b=Z2t+PMMjExWMKlJVi32qMrNwvZ712gVafgS77ahtksRg00IaVsVoin6h/dcvn6Lzagliehg+Ed+TBhZZp8cTWqYoRrfU0O5DGLlcfqWiPuRvauBlNvbBR6Nwrongar48ddfBAS2X9xwhzDXwJJJTQdI0IKTJ0Vl9RILX5LDy/Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739562164; c=relaxed/simple;
	bh=j8RbUnTVR+Rmdyxe3mjujeaLymNY6BVjB/yjOURYHBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tD+hhCrn2rwzzvf3zFmw8T65NFXLvn76XcJdc2mUm7GmuqO+s5GpJTxeGjySFUZICszrMo2YuXkX4amB5FNGzP6R3h1OA1duDvc7kWw16YvqxuJB/WJpMNFIvNvH0llEqev5ZZQ9elC3k1Vfd5ToZncANpLBPKHCsrkZBTAR9jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If1z8UYM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5BDC4CED1;
	Fri, 14 Feb 2025 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739562163;
	bh=j8RbUnTVR+Rmdyxe3mjujeaLymNY6BVjB/yjOURYHBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=If1z8UYMrV18l2O39VsnXxyaZX8j5zqCs7PfU7UiHofpUd0X0H+YHHVk1t/Zw+b4/
	 eL+iiJzA1kIcgYiZQWhrjTrE8gm4hDWOkx1Xkziz4YBmkbRF6uSvpyObFlqsZ9+c4D
	 4HfNbweBxiFFpugcKa++4K7rPMll4aqQB6BNnQlWlFXjYpQ+e3Q4lXOCtvCgFex/gj
	 12AQ1FPMo7xdby/Gdbc00tsCjGcqjWxkbGzIUR67jveSRPnpVEzoE6ohrSxUjPxx8d
	 SIlFCyr5xnX9Sx5EMfpt/w7xgyik+6soixxL8IXY16+k++w4OZI4PIGG1egPo/0zym
	 5vltoOGyMwrhA==
Date: Fri, 14 Feb 2025 11:42:41 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Song Liu <song@kernel.org>,
	Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250214194241.3aymq2kr6gky5zfv@jpoimboe>
References: <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
 <mb61pa5apc610.fsf@kernel.org>
 <f8d93a1b-3ad0-4e19-846f-c08d9cb19f48@oracle.com>
 <d91eba9a-dbd1-488f-8e1b-bc5121c30cd1@oracle.com>
 <mb61p1pw0qrpi.fsf@kernel.org>
 <20250214193819.22yet42umilpugv5@jpoimboe>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250214193819.22yet42umilpugv5@jpoimboe>

On Fri, Feb 14, 2025 at 11:38:22AM -0800, Josh Poimboeuf wrote:
> On Fri, Feb 14, 2025 at 06:58:01PM +0000, Puranjay Mohan wrote:
> > and the linker script has this line:
> > 
> > .sframe : AT(ADDR(.sframe) - 0) { __start_sframe_header = .; KEEP(*(.sframe)) __stop_sframe_header = .; }
> > 
> > So, do can you suggest the best way to fix these warnings?
> 
> Just add *(.init.sframe) like so:
> 
> .sframe : AT(ADDR(.sframe) - 0) { __start_sframe_header = .; KEEP(*(.sframe) *(.init.sframe)) __stop_sframe_header = .; }

Actually each probably needs its own KEEP:

...  KEEP(*(.sframe)) KEEP(*(.init.sframe)) ...

or so.

-- 
Josh

