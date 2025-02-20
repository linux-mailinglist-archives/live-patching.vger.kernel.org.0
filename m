Return-Path: <live-patching+bounces-1220-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD0AA3E3B4
	for <lists+live-patching@lfdr.de>; Thu, 20 Feb 2025 19:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A114F4216E8
	for <lists+live-patching@lfdr.de>; Thu, 20 Feb 2025 18:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C02E213E87;
	Thu, 20 Feb 2025 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ConAiYNJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22DC211A11;
	Thu, 20 Feb 2025 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740075743; cv=none; b=V0txh9eSqvAiME0ky2dqfwxdEBIi7oySTKCJwnxV4fP/lY7TBeXe6OB5bUzXB2pu4VgnOwpcVNAB95ofHx8Q+eUbCyyuLqOleLimJai5MlSK50x8zqRDE4jpRvtJxp7HAOHbmszcQDeanoNO0J2eGJ+GIIUI0jZXcOveroRBjU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740075743; c=relaxed/simple;
	bh=qfyPCheNrKkjIY1NJs7HY2hFww1UAkOPsdSQgC6ryyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYA8UI/EztW88lchRdLYzNl8Cqjt5b8EHPewQ4U93efazp5O+wH65E21u9My8ZDDrmYhKI4i1AcjPrzvWpPYY+4/xlH8Ns1xXwhlxnvJojL6cJkzTGfy4suelyvY14dTcl3aUjjxZProUyTjq9wGxqGU+6oMAsVfAVpsoxhkWaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ConAiYNJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B6FC4CEE2;
	Thu, 20 Feb 2025 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740075743;
	bh=qfyPCheNrKkjIY1NJs7HY2hFww1UAkOPsdSQgC6ryyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ConAiYNJs/H+eqN0mjIKdukO5HQikG3jpBnEA92mtahA1koFY9XlNX1AlO5+0sBQM
	 iVKA7sqDYVhXNF8keZpoysRAwqUywv55Lh3TmYDw0JrlVrGq+lj38UOVFAd1AWiH2O
	 rNew6H9Yy4Kb2cigj6gxch7tgilcLPmLMSYtSnZ5k7KfheKEJgq6v//b9KlGON0KJr
	 wBWmXWpTJd+gsrKJOHOwx7EKHv/ulA+JtRMIH+9U7z0KLEWHigggw4K7rOR4tyRke1
	 9Ll4WOTKelBT1hzyLcAjW4wXxAQ8KiKXeVeqpHFL1LXs6H9tz0jseV+5eTrdRST/DH
	 XF302k9wjkfZg==
Date: Thu, 20 Feb 2025 10:22:21 -0800
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
Message-ID: <20250220182221.vdmmnoyvc2do5mnn@jpoimboe>
References: <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe>
 <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe>
 <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
 <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe>
 <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>
 <20250218184059.iysrvtaoah6e4bu4@jpoimboe>
 <CAPhsuW4pd8gEiRNj920kO8c4JuEWoXT=MhFK-nWvJZ9QseefaQ@mail.gmail.com>
 <CAPhsuW57xpR1YZqENvDr0vNZGVrq4+LUzPRA-wZipurTTy7MmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW57xpR1YZqENvDr0vNZGVrq4+LUzPRA-wZipurTTy7MmA@mail.gmail.com>

On Wed, Feb 19, 2025 at 08:50:09PM -0800, Song Liu wrote:
> Indu, is this behavior (symbols with same name are not in
> sorted order from readelf -s) expected? Or is this a bug?
> I am using this gcc:
> 
> $ gcc --version
> gcc (GCC) 14.2.1 20240801 (Red Hat 14.2.1-1)
> Copyright (C) 2024 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Are you using different binutils versions as well?

It sounds like a linker "issue" to me.  I'm not sure if it qualifies as
a bug, the linker might be free to layout symbols how it wishes.

-- 
Josh

