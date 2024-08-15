Return-Path: <live-patching+bounces-498-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 929F99537E1
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 18:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 417ED1F21E85
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 16:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E45C1AD9E8;
	Thu, 15 Aug 2024 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fltmfZLk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535294C69;
	Thu, 15 Aug 2024 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723737951; cv=none; b=RIxa3sp1/Fg7tr8o9NjBqLCYrVQEKA92WKZiGLAV+FEqv3YK6eKk/HsT559+YuYt8JOMcvDXxkORj0xz6PjDJ0sjaAMdi+Gxfmi3blkn3nRBET6TBVSrMqf63WbNvoX7amQsfHeP1OehxZeG6l9kN0Wz/WU28EBVyiT9+mle5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723737951; c=relaxed/simple;
	bh=CBOevHigSWlKc1CP6LXMym86BM1K1D2QL4AShtyZ3dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szVqlF7zdmNLOuQy4klC/aegeYFnNBU8v98RNIv0/SXtbn0E8/59HMD9dDuVrq3hYMkbvV0s46psO1wlKa0R3ulZkiuXs2rJDT/vBpQp1XvcN1da0JiwegQx1UEw6Bexl1JcgMrpJ9FHIPdKdlyQQ/Q+ajGpTh+2PnN6Eodpb7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fltmfZLk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15E3C4AF09;
	Thu, 15 Aug 2024 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723737950;
	bh=CBOevHigSWlKc1CP6LXMym86BM1K1D2QL4AShtyZ3dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fltmfZLk+i9IGTOFePmU6zvkcECcUpd+M0zdk5vP1UgwshC7lQT/Fhq4DVpd+yz3h
	 YDTp6ytmPlMFD51nP+EvWjZ20ZIf6QKIL5fOn7o4oK2hk4lYUFNBpYrUbLVo+z6DTX
	 EVKY7xe58vo4U4OvikxPg9LIce//9dfTBvyTN1bM35DeMPqHVRpE0k1a/w5CGCzp6H
	 ZQsS2kzgPRUryjCVonh6uV2y16ZY3u8HGKPrse/GeiAp4wxSxCn+ER73sLGGxHbZuH
	 rbAhG3B2hdsCwo0QvGw5qIYmA7HRxLcGJhJz4AO4l1sCnfwlz/7WjrR4nsqvnksU9R
	 KTrbYsikT34+Q==
Date: Thu, 15 Aug 2024 09:05:50 -0700
From: Kees Cook <kees@kernel.org>
To: Song Liu <songliubraving@meta.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Song Liu <song@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>, "KE.LI" <like1@oppo.com>,
	Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Fangrui Song <maskray@google.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	"morbo@google.com" <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Leizhen <thunder.leizhen@huawei.com>,
	Kernel Team <kernel-team@meta.com>,
	Matthew Maurer <mmaurer@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Message-ID: <202408150905.97DAE1A@keescook>
References: <20240807220513.3100483-1-song@kernel.org>
 <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
 <Zro_AeCacGaLL3jq@bombadil.infradead.org>
 <5D28C926-467B-4032-A31F-06DBA50A1970@fb.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5D28C926-467B-4032-A31F-06DBA50A1970@fb.com>

On Mon, Aug 12, 2024 at 06:13:22PM +0000, Song Liu wrote:
> Hi Luis,
> 
> > On Aug 12, 2024, at 9:57 AM, Luis Chamberlain <mcgrof@kernel.org> wrote:
> > 
> > On Mon, Aug 12, 2024 at 09:21:02AM -0700, Song Liu wrote:
> >> Hi folks,
> >> 
> >> Do we have more concerns and/or suggestions with this set? If not,
> >> what would be the next step for it?
> > 
> > I'm all for simplifying things, and this does just that, however,
> > I'm not the one you need to convince, the folks who added the original
> > hacks should provide their Reviewed-by / Tested-by not just for CONFIG_LTO_CLANG
> > but also given this provides an alternative fix, don't we want to invert
> > the order so we don't regress CONFIG_LTO_CLANG ? And shouldn't the patches
> > also have their respective Fixes tag?
> 
> kallsyms has got quite a few changes/improvements in the past few years:
> 
> 1. Sami added logic to trim LTO hash in 2021 [1];
> 2. Zhen added logic to sort kallsyms in 2022 [2];
> 3. Yonghong changed cleanup_symbol_name() in 2023 [3]. 
> 
> In this set, we are undoing 1 and 3, but we keep 2. Shall we point Fixes
> tag to [1] or [3]? The patch won't apply to a kernel with only [1] 
> (without [2] and [3]); while this set is not just fixing [3]. So I think
> it is not accurate either way. OTOH, the combination of CONFIG_LTO_CLANG
> and livepatching is probably not used by a lot of users, so I guess we 
> are OK without Fixes tags? I personally don't have a strong preference 
> either way. 
> 
> It is not necessary to invert the order of the two patches. Only applying
> one of the two patches won't cause more issues than what we have today. 

Which tree should carry this series?

-- 
Kees Cook

