Return-Path: <live-patching+bounces-1133-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 104B5A2CAB1
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 19:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E165188B235
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 18:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1A2199EA2;
	Fri,  7 Feb 2025 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kx89Hbxu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4899C194AD1;
	Fri,  7 Feb 2025 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738951320; cv=none; b=ONK1pAvu4ctFDRTcaZ3UOftoLJWkKnvJRo4seq8r4Voh/beSpbSE9d42znqlWH6yfbEZjWhgV2DLvsg0lfuDhTDo8fNI5IRx5fqCNDFZNTdR//2fV14zabuZwmdx4QlC1h3kN1Xq6kFxH8HYNv2oK1eff1LbEIMf+0aTa+mwnPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738951320; c=relaxed/simple;
	bh=1d6FcR1MsuxyT9npMdDyYCQ3GcBkzXyhynsiiKzrzHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWg7yuoXYjN+2YgfyX8iedKQZJiIOcKf9I3EitS6o18AWltjyupoKUKuHwun6JnJl7M9eKmdyHdudWDvbLwS05x4J+gp2DwH+Q5jt6e7El5EjkxztMBWbB8bGbFMBhCimHfELRFFnvrBa9VemhDF5O+dZ0cYczzMDtpeo8oftwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kx89Hbxu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC02C4CED1;
	Fri,  7 Feb 2025 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738951319;
	bh=1d6FcR1MsuxyT9npMdDyYCQ3GcBkzXyhynsiiKzrzHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kx89Hbxu1wvihiHngrVL82NWGks1Q2DmwfZkp3jYn+QASb7FUTDYY9SsZ8Fb+7OS+
	 e47rHTq+CtVZ8O21OgTcVbBfj7w0+KozrlvPuSoSwNDdBqcZQLZbYZUzUqHKqDnlgT
	 KmPV+X46eTRwDHoop96D16YmrNuKMcDv+OHGTO63qnkUXj5QaQ4okBrp1E04XFtkPc
	 0bfwNWO7ZrpO1XVR/4o8qawoA0JhTTk8DHDZmGKZrVv182eUYmlUTvQiB43QfbHFZH
	 fdVzmJw5aa5j46yRqJt+GLCUpQ8qndx4bt2hq1AbBQLdakgADpbgESKtd7NqigE8et
	 KJOXxSgcuPe4w==
Date: Fri, 7 Feb 2025 10:01:57 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Indu Bhagat <indu.bhagat@oracle.com>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/8] unwind: build kernel with sframe info
Message-ID: <20250207180157.j25afocbe2kkkbv3@jpoimboe>
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-2-wnliu@google.com>
 <303e0c91-2351-4ccd-8948-b400ac5d2b7f@oracle.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <303e0c91-2351-4ccd-8948-b400ac5d2b7f@oracle.com>

On Tue, Feb 04, 2025 at 04:22:27PM -0800, Indu Bhagat wrote:
> > +++ b/arch/Kconfig
> > @@ -1736,4 +1736,12 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
> >   	  An architecture can select this if it provides arch/<arch>/tools/Makefile
> >   	  with .arch.vmlinux.o target to be linked into vmlinux.
> > +config AS_HAS_SFRAME_SUPPORT
> > +	# Detect availability of the AS option -Wa,--gsframe for generating
> > +	# sframe unwind table.
> > +	def_bool $(cc-option,-Wa$(comma)--gsframe)
> > +
> 
> Since the version of an admissible SFrame section needs to be atleast
> SFRAME_VERSION_2, it will make sense to include SFrame version check when
> detecting compatible toolchain.

Also, Jens pointed out that checking for '-Wa,--gsframe' isn't
sufficient, as it still succeeds for architectures that aren't yet
supported:

  https://lore.kernel.org/b89bcb68-d010-4041-aacf-15b934675705@linux.ibm.com

so in my patches I have:

config AS_SFRAME
	def_bool $(as-instr,.cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc)

Though I'm not sure how you would add an SFrame version check to that.

-- 
Josh

