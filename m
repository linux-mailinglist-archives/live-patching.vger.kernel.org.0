Return-Path: <live-patching+bounces-1602-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E03F8AEB57E
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 12:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DEFC16A9CC
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 10:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF3A298CB0;
	Fri, 27 Jun 2025 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N2fbB8AQ"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC469298CAB;
	Fri, 27 Jun 2025 10:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021618; cv=none; b=D/D73PvdmTNYO4FQOLDBddowdFjCs27k5X5fDjMHKyrWPaCnrLbipRRvk5hEbTyIrAl007cghRDOgmKTv63FRYCn/iI1IHUJ72pmdFI1mnn8Urx23b7zQkryfOSAMu635zSIsv8Z+GYAmG8SXFgmOnJJywgkaGwfN4Z5v2CgCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021618; c=relaxed/simple;
	bh=pxfn6oqKdlWo0GE6HNa/lOA15Wgs5GoyzyY0cfYI/yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBVaNU5LjAp9VK5chG86d3+vBvXYlPj8vIpWPLwYpjUoMrw6U0LISezQ2eCf/XvcUu/tm1cYTnHdmxoZmJgOFaDCuboQ8gXjgGrSGwy2m6AZQbqytu252/dkpFFueLB4wFRlHZQ7lRmal0Xnk084IhJQ+tQ0gQk1nIkAN8/JjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N2fbB8AQ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yCxgES6+AiHPFhHwzvZQriIUuOAhP73ey2SdBgFz/io=; b=N2fbB8AQAxXkgTuwSRm3lirbgY
	Fr/CG3CxVovqXOyEBuQuoCvNL7ZrEEPq0MDA8nPN7C6lOfXmC035UazzdKQ33I/le4S7i4A/zMRHR
	/BfH0T1GC8C3OWJLXHMHsb1gB46TxliXFBvsNAsA+OGhQ8lvbxKFeo8pzx4PTo69FBFUt+R288JNP
	8k41oO+e45FzSn+NWw3Qo4goR1118JiUYo56O9WyuI3bKuPF61Nbs6ZfpPnj0TnDXjNaWdVsutCZA
	mhKyPvcFFtE6HgDvfz7mvvKjsD7ygpivWkx1Q26bjc9OrO2x1BZHsc1g0R5woFGd7axMGMpBSsqL+
	Naol2nfg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV6i1-00000006J3B-00U4;
	Fri, 27 Jun 2025 10:53:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 911C1300222; Fri, 27 Jun 2025 12:53:28 +0200 (CEST)
Date: Fri, 27 Jun 2025 12:53:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v3 42/64] kbuild,x86: Fix special section module
 permissions
Message-ID: <20250627105328.GZ1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <cf1cfb9042005be7bf0a1c3f2bdbeebc769e3ee4.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1cfb9042005be7bf0a1c3f2bdbeebc769e3ee4.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:29PM -0700, Josh Poimboeuf wrote:
> An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> __bug_table so their entry sizes can be defined in inline asm.
> 
> However, those sections have SHF_WRITE, which the Clang linker (lld)
> explicitly forbids combining with SHF_MERGE.
> 
> Those sections are modified at runtime and must remain writable.  While
> SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> 
> To work around the linker interference, remove SHF_WRITE during
> compilation and restore it after linking the module.

This is vile... but I'm not sure I have a better solution.

Eventually we should get the toolchains fixed, but we can't very well
mandate clang-21+ to build x86 just yet.

