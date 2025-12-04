Return-Path: <live-patching+bounces-1899-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C072CA4A9D
	for <lists+live-patching@lfdr.de>; Thu, 04 Dec 2025 18:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EFEA307B0A3
	for <lists+live-patching@lfdr.de>; Thu,  4 Dec 2025 17:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2419308F1A;
	Thu,  4 Dec 2025 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srAcDH7t"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208629D293;
	Thu,  4 Dec 2025 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764867737; cv=none; b=VAjmwk8kSPz/DBZYDip/H2Gj7cZrXUV6uMCw53K7NBh2iOeAnhxRI6ebAdehTNopRQqZv+FJP7cskPdssaT0IeXTpd+xmZO9V6NgMJHtmLJd/P1LQT9JX82LYkRlenB1tJIiSTIbAMEwKT8VwBhCZYijZrCQo4i+it30igSny4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764867737; c=relaxed/simple;
	bh=13iEa0+z129ikR3aa/Pwup5u+HFhKCAQGb9qOZ0MIAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrN/mPEtST5iO2TtVRvYhN7MAjlZjV3Z5cnvgZcCSpvQjw4WCS7zm5FWslMkooj+vCapEEcipijqnXnu/qqtaA1wzPX7O7P9kXj5JeFo3YrwWVVWMZmt2j/9zyU/a2stPR4PfoIT11pSokf8Ut7x6xlwTdZTEn2pHnWIuY9dgnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srAcDH7t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6DFC4CEFB;
	Thu,  4 Dec 2025 17:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764867736;
	bh=13iEa0+z129ikR3aa/Pwup5u+HFhKCAQGb9qOZ0MIAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srAcDH7tLMjQD9i63bKgpju4hyNBR5nAPPyvTeJYXtegvaEjizsqdiBcfeFnZLeaY
	 wMKPUFXbinv1nhXKHrtwff7xWRudEF8GcsMTwKXUSBvBeWpmSqQ5LhOLP0J39vTJXY
	 pDbyXSfu0S9gncnZXam/eOFXqmmJ2DqKOlBD2YsxO4AXUNCH1f6dgnPGWojEpPIJ5B
	 HrZvq2I+C717NFQuqJSHFZ50oHEvTPzADycFXkl8qlCz3pFhhDjRGhqRjQGaDgLLlc
	 M4OHRJlEArf2PEW8+0ig3wFn81aIAK/AVs0p9cKSYHTJphhMDPzDT9O052vwIpBk3W
	 LzChnTG+GN99Q==
Date: Thu, 4 Dec 2025 09:02:13 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, bpf@vger.kernel.org, 
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
	Raja Khan <raja.khan@crowdstrike.com>, Miroslav Benes <mbenes@suse.cz>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/2] bpf: Add bpf_has_frame_pointer()
Message-ID: <y27knofa4opun2vn3xjrowbtgphzkjo24lbfvdxc2segiztihu@k6q7f6ymronr>
References: <cover.1764818927.git.jpoimboe@kernel.org>
 <fd2bc5b4e261a680774b28f6100509fd5ebad2f0.1764818927.git.jpoimboe@kernel.org>
 <aTGU5zRKWWU78mCS@krava>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aTGU5zRKWWU78mCS@krava>

On Thu, Dec 04, 2025 at 03:04:23PM +0100, Jiri Olsa wrote:
> On Wed, Dec 03, 2025 at 07:32:15PM -0800, Josh Poimboeuf wrote:
> >  	EMIT1(0xC9); /* leave */
> > +	if (im)
> > +		im->ksym.fp_end = prog - (u8 *)rw_image;
> 
> is the null check needed? there are other places in the function that
> use 'im' without that

That was a NULL pointer dereference found by BPF CI.
bpf_struct_ops_prepare_trampoline() calls arch_prepare_bpf_trampoline()
with NULL im.

-- 
Josh

