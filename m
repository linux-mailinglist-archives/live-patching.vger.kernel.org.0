Return-Path: <live-patching+bounces-1167-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E9EA335A0
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 03:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42F9F166BF6
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913DA1F8EEF;
	Thu, 13 Feb 2025 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIpuCeCm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6177523BE;
	Thu, 13 Feb 2025 02:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415124; cv=none; b=R1h8fsUp6faHDA1Dz9bWM4eoiedjlrGAG6cvo9rvLFmV5HcExNfeoiRctJUV6MGZ9KF/MsTgQvSHKF3P3j+RzvPECftgbyzUt8BwTVurOcEvZle0svIXT9ccbmn6O5krlK3Ka8tAYsM71KQawbx1P3nR1a8Cl0/Cql1KlcwPhzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415124; c=relaxed/simple;
	bh=NVMAadp03PD66sbMdEmmFgCNxo+6578DA85rU6KYTFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJ9x+HG5b0uqKP6pjwq35NWMnZuOvXE4/L7MzhXwJHIlcviiYzFZp/DDqyGkzjO+jeAtFA7FzTt+0JIFS/SXxl6f43ZHxoPbdQADMpT1fUom532uxLBRy5zI/1vuqWouAccqFbzpRBJZMcPygSppTIuA8q86slE/hJ9LVFGxTB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIpuCeCm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35861C4CEDF;
	Thu, 13 Feb 2025 02:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739415123;
	bh=NVMAadp03PD66sbMdEmmFgCNxo+6578DA85rU6KYTFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UIpuCeCmfDQNXF2h/LSrWpY3SgAnMNet4mDkuOZypViJd1h8MtN86CKN5X62zTvvv
	 gN0VKC24fSoNgOGHgc8Dual8YCPopwfdKw0nSyq+eMglDZ5ny9V1eehxYworSgAH/m
	 Q7gKblgjGszFiQBZiRMpjxdtmPUg6aQrDF6qIm8oWZ8h4i4K4D5XTyXVJFFSACwnVm
	 Yxbwdh30hnb/2rr285EV91PUSlTRdt69OsPhf+Xy/JN/WmYhxeEzKKzj3GBiqQlqGI
	 rAtXeCq/NfYb0J8kGaS9YpU1dj9gDSz0kn7JrZXRPnPJJn1pmppfIXXhmXwqQEBItB
	 z53rdeuSTBzrQ==
Date: Wed, 12 Feb 2025 18:52:01 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250213025201.tyo3jcp4gcivydyd@jpoimboe>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>

On Wed, Feb 12, 2025 at 06:40:33PM -0800, Song Liu wrote:
> On Wed, Feb 12, 2025 at 4:10 PM Indu Bhagat <indu.bhagat@oracle.com> wrote:
> >
> > On 2/12/25 3:32 PM, Song Liu wrote:
> > > I run some tests with this set and my RFC set [1]. Most of
> > > the test is done with kpatch-build. I tested both Puranjay's
> > > version [3] and my version [4].
> > >
> > > For gcc 14.2.1, I have seen the following issue with this
> > > test [2]. This happens with both upstream and 6.13.2.
> > > The livepatch loaded fine, but the system spilled out the
> > > following warning quickly.
> > >
> >
> > In presence of the issue
> > https://sourceware.org/bugzilla/show_bug.cgi?id=32666, I'd expect bad
> > data in SFrame section.  Which may be causing this symptom?
> >
> > To be clear, the issue affects loaded kernel modules.  I cannot tell for
> > certain - is there module loading involved in your test ?
> 
> The KLP is a module, I guess that is also affected?
> 
> During kpatch-build, we added some logic to drop the .sframe section.
> I guess this is wrong, as we need the .sframe section when we apply
> the next KLP. However, I don't think the issue is caused by missing
> .sframe section.

Right, it looks like it unwound through the patch module just fine.

-- 
Josh

