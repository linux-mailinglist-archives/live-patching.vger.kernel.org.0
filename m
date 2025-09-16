Return-Path: <live-patching+bounces-1654-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5E4B7CF1C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 14:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 191E31BC0E73
	for <lists+live-patching@lfdr.de>; Tue, 16 Sep 2025 23:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F10288502;
	Tue, 16 Sep 2025 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2atb920"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD35D36D;
	Tue, 16 Sep 2025 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758064732; cv=none; b=h/6wwgINJKtDZXtKC//V6hXD0JgkiC+uf4lYctYC+Rvyo4wHXGn/oLY7tcuotxJ9hVG5rhLrJri75iTcHbKgCTZlq30z57m2x82Ng2leSkz0CcWa304pyjL2/RiLgPtu0rLZjqquVnbYlT2pXlJoGMskVF9z+Gm7u0mwThRjh2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758064732; c=relaxed/simple;
	bh=bOXayvBYbkD5K1sBQfX4Rt00mlFVQQ8QmgIt314ZH9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+Fln1lRK432iRC0xRpljBtPJCkypgMTmykeVrx4zt4lHPq8cdEG7vE83YnxUowaUBc2rP+/+WX8hi9VShZDpbVCfJbxia6JfcyhJPBMG/FpOz+gNIA8UDjiC9uF9qNxjQgZZ/aDJbXttmMup/ryu6bbs3yls3ADid7aA/tWLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2atb920; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279EEC4CEEB;
	Tue, 16 Sep 2025 23:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758064732;
	bh=bOXayvBYbkD5K1sBQfX4Rt00mlFVQQ8QmgIt314ZH9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2atb920GocqMHYXDQuOJ/FnuecbtaM3FdVMmC+vkYG2h63NitwjYmuLGdtKP65mE
	 8SvN12uMvXigVMs06amlohnsr57yH5tLV7IkBx3zPekAt1IbgKD2wCLgQMLr+Y5gDf
	 ePcfn1p/EYIG3c1F7kpdXrc0Uq3R5cqWlzhZfECVc3Ac5KoKWJ5r8syaoGvSouVTxy
	 6Z72Af6/rOcPrMvZf1ECzZlZUt/Y+vW8l/6jCKkbh7VGiJEGzKEqtmRhAyh0WSOjaj
	 ZumWcuJPKLiXTe0hHSPteTvkouDu0/mLXrLAd5iVqdeg7ozEbuycf2poHCsNaea/jk
	 GjI1EEfvxVkvA==
Date: Tue, 16 Sep 2025 16:18:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v3 42/64] kbuild,x86: Fix special section module
 permissions
Message-ID: <i2vb4l3ykg7memhl34jkcbyet4myhjwnforwiebwyzyicfmxkm@5jseorvzzy4i>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <cf1cfb9042005be7bf0a1c3f2bdbeebc769e3ee4.1750980517.git.jpoimboe@kernel.org>
 <20250627105328.GZ1613200@noisy.programming.kicks-ass.net>
 <4ezl3egjv36fjkxkkswcianc5cg7ui6jpqw56e4ohlwipmuxai@kvgemh72rmga>
 <20250630073144.GE1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250630073144.GE1613200@noisy.programming.kicks-ass.net>

On Mon, Jun 30, 2025 at 09:31:44AM +0200, Peter Zijlstra wrote:
> On Fri, Jun 27, 2025 at 10:34:15AM -0700, Josh Poimboeuf wrote:
> > On Fri, Jun 27, 2025 at 12:53:28PM +0200, Peter Zijlstra wrote:
> > > On Thu, Jun 26, 2025 at 04:55:29PM -0700, Josh Poimboeuf wrote:
> > > > An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> > > > __bug_table so their entry sizes can be defined in inline asm.
> > > > 
> > > > However, those sections have SHF_WRITE, which the Clang linker (lld)
> > > > explicitly forbids combining with SHF_MERGE.
> > > > 
> > > > Those sections are modified at runtime and must remain writable.  While
> > > > SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> > > > 
> > > > To work around the linker interference, remove SHF_WRITE during
> > > > compilation and restore it after linking the module.
> > > 
> > > This is vile... but I'm not sure I have a better solution.
> > > 
> > > Eventually we should get the toolchains fixed, but we can't very well
> > > mandate clang-21+ to build x86 just yet.
> > 
> > Yeah, I really hate this too.  I really tried to find something better,
> > including mucking with the linker script, but this was unfortunately the
> > only thing that worked.
> > 
> > Though, looking at it again, I realize we can localize the pain to Clang
> > (and the makefile) by leaving the code untouched and instead strip
> > SHF_WRITE before the link and re-add it afterwards.  Then we can tie
> > this horrible hack to specific Clang versions when it gets fixed.
> 
> Oh yeah, that might be nicer indeed!

I ended up giving up on this approach.  It was just too painful trying
to get the toolchain to cooperate.  It does kind of make sense that
SHF_WRITE and SHF_MERGE are incompatible.

What I really needed was a way to set entsize from assembly, but that
doesn't seem possible without SHF_MERGE.

For now I'm just going with marking the beginning of each special
section entry with an objtool annotation.  Then objtool can deduce the
sizes from the distance between the annotations.

-- 
Josh

