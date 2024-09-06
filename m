Return-Path: <live-patching+bounces-623-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0E496F9A1
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 18:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6387EB2406B
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 16:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6A61D47A3;
	Fri,  6 Sep 2024 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyruBEwW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118FE1D45E4;
	Fri,  6 Sep 2024 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725641617; cv=none; b=PRzVJC9sNSWCGH5qC2HgiDsZSZj38gA5AEwUNnN+pY+zzS0wo/ZrMp//srpSOkn8IxVS9JgPtB2UgbU9sGmiA0J9d5ZuCLl/28R8ixWDakkgBItb+VsmKsZo0BgYFtt1C7hBk40l35WV1UQtGaKijv2km/ZAts4uDnBtRWWzwCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725641617; c=relaxed/simple;
	bh=/ThUTBYspHXQBSfRUxF6HmGrSKvr2OGqbfWcUF4UObc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d61dOylMWI/0HexKotyPpvaHIVepWeuwj/MMa6dXN/2vWKjcfC6F53c7C/6kdcC/IA9ARUuGPTal/p25h0/lyTh7tD4qLXF4g7vOEXYZtgbwb65DtMgDtPDTMpPF5LpJWV11w4BgyjMF5wuUQMdQT/YxjOWuN3at3ubPyZ9RT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyruBEwW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164B7C4CEC6;
	Fri,  6 Sep 2024 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725641616;
	bh=/ThUTBYspHXQBSfRUxF6HmGrSKvr2OGqbfWcUF4UObc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HyruBEwWLcbPX17qbzQfY1C2ip6Y2yzW72gI3vBbMvE/BByyFk8op7Ry5lMOhOjuS
	 DhXhNtkOQxWnk5y1eYQzyr2YZ9g5Tvcn138gZm3d89XD+Kb0ry/kaQoQwmsWkx0HLT
	 B8DkyJ1C12mgGBA4pT44O6XAqhiTQm3/LfDYe18Di5fvbmKr+a0wGUXfUaC5OD8oWR
	 gMfW28fcRsUc51Apm54Z61EVVPmIyHX7bmyYPVbCEzw3pqNXIID32Qm9JRJPn2PZCi
	 8OeddGcrCsjQh8I/MIunHcG+yJvbaTwNokYiqhaKrFBwFB3HX/LUMIqCWzIOlYJ/Kr
	 nTutgLKPXIf1w==
Date: Fri, 6 Sep 2024 09:53:31 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>, Michael Matz <matz@suse.de>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240906165331.u2vlaurjfotxci6h@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240903082909.GP4723@noisy.programming.kicks-ass.net>
 <20240904042829.tkcpql65cxgzvhpx@treble>
 <20240904123918.GCZthU9rOJLWUKBbsv@fat_crate.local>
 <20240904164429.hstbg5beejt32mlu@treble>
 <20240906101909.GAZtrXHVweqJJ2j82v@fat_crate.local>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240906101909.GAZtrXHVweqJJ2j82v@fat_crate.local>

On Fri, Sep 06, 2024 at 12:19:09PM +0200, Borislav Petkov wrote:
> Right, I was talking to Michael about it yesterday, CCed.
> 
> He suggested that you might be better off creating these annotations by
> sticking the required info in a section instead of generating symbols.
> 
> I.e.,
> 
> .pushsection .klp_objects
>  .size \\name\\@, \\end - .\n"
>  ...
> .popsection

".size" directive references a "name" symbol, did you mean it would just
annotate the entry like so?

  .pushsection .klp_objects
  .long \\start - .
  .long \\end - .
  .popsection

That's definitely possible, but it's much less cleaner for objtool diff,
which works by cloning symbols and their dependencies.

If the symbols are your concern, they could easily be stripped with a
trivial change to scripts/kallsyms.c:is_ignored_symbol() as Peter
suggested.

-- 
Josh

