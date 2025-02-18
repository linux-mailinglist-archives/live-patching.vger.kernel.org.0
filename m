Return-Path: <live-patching+bounces-1215-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0A2A3937C
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 07:37:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 234E816A615
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 06:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01BD1B0F32;
	Tue, 18 Feb 2025 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFt5gITJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0F7482;
	Tue, 18 Feb 2025 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860625; cv=none; b=r5LyXzMc4pgoGfuxiGWUvb7fHkiyP63ijS+hhxO8A7Rl96GlTDDqeVnJd6YlqD1WwlDTxEa/fsSq0SHrRAti1uNQZjdE+tNrHPteSWacK99CMAY/EC7ou/1FbawILAq/EDHRTEvRV1wkiHpwbVbW/jFcmC6mBN71vI2ItLERK4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860625; c=relaxed/simple;
	bh=2fzRHHC2KgFRx5omBTKDd3nCc7JnwkHdxnqOzs25YKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RevVjtf37GUm0/iKAC1UX6HZQKyBa9fmK4fNLWWh0dygq5u0TlSQ9ZweiZxNbIxqHjiIVLVhwlwaT1yagMdIJBbheD6gCTEonly99y84SH/ti2Tbo2M6GnirVlmcumGGsGVfGzTgabWSCglAfAKsnQeHp4z87Xe9dAdc4zOD34I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFt5gITJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798D1C4CEE2;
	Tue, 18 Feb 2025 06:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739860625;
	bh=2fzRHHC2KgFRx5omBTKDd3nCc7JnwkHdxnqOzs25YKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jFt5gITJ3Rhhkz5w5yO6yIJbChhiyry2bgre9WlaPoIGDwpQj9qk7bgDVpTA3uhst
	 Rri//lhNZbhWud7lH0X1D1SsJ2LHpbSLQzscqXcLJKaTsEJQIe3ucD1XJs8jdQiQ84
	 kcsKJZ8XIK1JXXLz6ZfBVHaCL5yFofD5snq540y79a22Cw9QwGFQOvK0OX4Gc7Nfab
	 5xBbBjbKfP12JWZx1nU/e1Uu6BKH+A8iAa6ialCLVnUV14tHdkqmuJqaJx0mvoU7vU
	 pWzBHFEZp1lX32rjMeV7klHMSLWd/7ezMDtcNeua5WFN7xapJ0kqKdp6iuEdUkelGI
	 a81k4R7aETMIQ==
Date: Mon, 17 Feb 2025 22:37:02 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe>
References: <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org>
 <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe>
 <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe>
 <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe>
 <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>

On Mon, Feb 17, 2025 at 08:38:22PM -0800, Song Liu wrote:
> On Fri, Feb 14, 2025 at 3:23 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > Poking around the arm64 module code, arch/arm64/kernel/module-plts.c
> > is looking at all the relocations in order to set up the PLT.  That also
> > needs to be done for klp relas, or are your patches already doing that?
> 
> I don't think either version (this set and my RFC) added logic for PLT.
> There is some rela logic on the kpatch-build side. But I am not sure
> whether it is sufficient.

The klp relas looked ok.  I didn't see any signs of kpatch-build doing
anything wrong.  AFAICT the problem is that module-plts.c creates PLT
entries for regular relas but not klp relas.

-- 
Josh

