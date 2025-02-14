Return-Path: <live-patching+bounces-1207-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 390BEA3663F
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 20:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAC3416E6D9
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0ADE1B6CE3;
	Fri, 14 Feb 2025 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnhThuL1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828371B3F3D;
	Fri, 14 Feb 2025 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739561902; cv=none; b=lrIfgih/BnwSe0iY7Kpc2SWCln+IX3OO1BriJ6NZEP1JiO+lcFttgTMjqdzhWmkVtjoxD7m89o1ytGICkbAvxZcorr6xY6Mn43Rl0RYzP8yIQ6z96REpqMjpJiqkiFeB5V3joHEqZ/mD8Ehcy0ihY0T+abZrHgkvuC+LYp289/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739561902; c=relaxed/simple;
	bh=V9sAZVtvPpbSHwjX3+ZKyFuEV2FgXN7gDRROnOTXxIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHoTW5TSQ843CxSI5VIIeuidcKP7Z6j+HHm0CQra5yr1DHvanERIKkD4421ZzQ03Xd6qPTiqZzGJVJ53Xkv+UikWHi0DjfnxKhKo/EtRTYZOdCk36+HRgvpKIaxLLHCLrpuFFuWd+w7iBjGmon8dxupP7vYE4z3G9nxyUZVpktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnhThuL1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2DFC4AF09;
	Fri, 14 Feb 2025 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739561902;
	bh=V9sAZVtvPpbSHwjX3+ZKyFuEV2FgXN7gDRROnOTXxIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZnhThuL1rcyP/53Er7fRg9dl+i87uptxy5JQc7SC4U6VmxXJ+WDod5dQKlypT9FeX
	 j84/E3srsPnLeibvW05a7qQd6yW7DfP9qhQY8kti0796mhX2AnWAK1N5CCbmk1ZJZm
	 GLM6JpU50PhHU01Ab3frOCCpEWSIO8AsC0J8b82gmgQJJMebcU1WlIUapLTvpAjv5n
	 m6KDXAL0CXO+GEqzCLB7T1yaudSUIhnp+00c3K4/EYEMTB83+DTP4onhooYBeG00hf
	 LqMauNPIGSrgMOtWZxmc9Jp7NLCQlMQ9O65BXS/qRw2+4fmL4BK1vWGcT9ZkQ+o3K8
	 gLVdiRpc9Jp8g==
Date: Fri, 14 Feb 2025 11:38:19 -0800
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
Message-ID: <20250214193819.22yet42umilpugv5@jpoimboe>
References: <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
 <mb61pa5apc610.fsf@kernel.org>
 <f8d93a1b-3ad0-4e19-846f-c08d9cb19f48@oracle.com>
 <d91eba9a-dbd1-488f-8e1b-bc5121c30cd1@oracle.com>
 <mb61p1pw0qrpi.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <mb61p1pw0qrpi.fsf@kernel.org>

On Fri, Feb 14, 2025 at 06:58:01PM +0000, Puranjay Mohan wrote:
> and the linker script has this line:
> 
> .sframe : AT(ADDR(.sframe) - 0) { __start_sframe_header = .; KEEP(*(.sframe)) __stop_sframe_header = .; }
> 
> So, do can you suggest the best way to fix these warnings?

Just add *(.init.sframe) like so:

.sframe : AT(ADDR(.sframe) - 0) { __start_sframe_header = .; KEEP(*(.sframe) *(.init.sframe)) __stop_sframe_header = .; }

-- 
Josh

