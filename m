Return-Path: <live-patching+bounces-1302-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7449A684A6
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 06:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4446219C32FF
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 05:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AA22066D6;
	Wed, 19 Mar 2025 05:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPPNVaVB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D0801;
	Wed, 19 Mar 2025 05:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742362798; cv=none; b=kmvT79xlMp/7v2uMUuKqyi6zhZ4ckuZYSlbPh2adDIjwznvaJ5IqGMLRHv9Xq38o+rWxRGEg7JS4+K5z8Ib0zZa2mhuUjUtZbjSBCe+ZPoR+jZQGTQsIFB3iIes+dQyIL3whc1QyFV33mZjCLzV51PWisfSkCUg5qYjylp6sQ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742362798; c=relaxed/simple;
	bh=SSaYbMiudPMxmZdaaCLLVz0v1iCsVRHIWVKduwiZFO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COyDtITtGeu8kI1bAcIUrS9O/XsU8IhVvdo7ktMMAxJBU5WVz5RFULA7TsUCRDC8QI6inedDoPAe1Yf/UQoMHtIra/w+Ft8UvjxjamGg9NSdnx1cSh8Z27xI7oIyWW0MxLA0MuxZJykJvRSWFuM/4tT77BFbjIrLlJz+FwVFlcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPPNVaVB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2152C4CEEA;
	Wed, 19 Mar 2025 05:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742362798;
	bh=SSaYbMiudPMxmZdaaCLLVz0v1iCsVRHIWVKduwiZFO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPPNVaVB2tsCJjXcWL+hMpGUYU9Fm1O+ahyqX7WMS9b2LMRjm+Em3mDBtPLotCPFm
	 83/dhNxzj0uUgOGKsqVz8uwkuCtJJuI/oND3GqMnRPsSHymHk2avYaTIMmWf1FsdAm
	 Xqh2RMhImHrLsd23rUdrrQeeR6MpWBJKaoZYN+aAghG3Sl4XlEXL7pjQq1BFgyvppf
	 +0SZvUqzhtJEIFYPesQiEV5aTQhY+EgPNrGCCWQ7OCSgoHiNn66cL4X2iIqjYsONyB
	 RcSzTei6CidAkT32PVL8HZFM1Ft5wILBr3xqb9V5ee4d3dsBkS0d/9IqX5I0ASuD1R
	 O+a6xCXbCtvVA==
Date: Tue, 18 Mar 2025 22:39:54 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, indu.bhagat@oracle.com, 
	puranjay@kernel.org, wnliu@google.com, irogers@google.com, joe.lawrence@redhat.com, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <ifqn5txrr25ffky7lxtnjtb4b2gekq5jy4fmbiwtwfvofb4wgw@py7v7xpzaqxa>
References: <20250308012742.3208215-1-song@kernel.org>
 <20250308012742.3208215-2-song@kernel.org>
 <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
 <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>
 <ox4c6flgu7mzkvyontbz2budummiu7e6icke7xl3msmuj2q2ii@xb5mvqcst2vg>
 <CAPhsuW4BEDU=ZJavnofZtygGcQ9AJ5F2jJiuV6-nsnbZD+Gg-Q@mail.gmail.com>
 <pym6gfbapfy6qlmduszjk6tf2oc2fv4rtxgwjgex7bwlgpfwvs@bkt7qfmf7rc4>
 <CAPhsuW6_ZA+V_5JK+xy4v3pyQ-kaZzUooxO=4L+c95fHaW38ig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW6_ZA+V_5JK+xy4v3pyQ-kaZzUooxO=4L+c95fHaW38ig@mail.gmail.com>

On Tue, Mar 18, 2025 at 08:58:52PM -0700, Song Liu wrote:
> On a closer look, I think we also need some logic in unwind_find_stack()
> so that we can see when the unwinder hits the exception boundary. For
> this reason, we may still need unwind_state.unreliable. I will look into
> fixing this and send v2.

Isn't that what FRAME_META_TYPE_PT_REGS is for?

Maybe it can just tell kunwind_stack_walk() to set a bit in
kunwind_state which tells kunwind_next_frame_record_meta() to quit the
unwind early for the FRAME_META_TYPE_PT_REGS case.  That also has the
benefit of stopping the unwind as soon as the exception is encounterd.

-- 
Josh

