Return-Path: <live-patching+bounces-1497-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABCB7AD0911
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 22:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B6E0189FFAE
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 20:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69402185B1;
	Fri,  6 Jun 2025 20:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVD19OU+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE715217F23;
	Fri,  6 Jun 2025 20:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749241702; cv=none; b=ibq8tcPxT4wK+f55ONbU0v3YLMO8Y3gs+lPiK05nco7nJyFdkRa0g44NWsd9VNfbgzeAWAs8Ng0mp2YmOUqkm0j6D5FbztCDLZGPwpnWPC3SaQ8v6Q+Yiuc4nr9ZLx7RO4TYp5uMUjSuwEln5ovTXh9bs5XVECD7mDDdOPZiPuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749241702; c=relaxed/simple;
	bh=8IILO79EXNgU162PlK4G+w9NQreXJ6wJ1JiN/QMclS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7WdBrYP93XZN34jpUy9NoIFBEyMdvrHuZPk91Kv1XWJRrKb/7bTiVHoe8hpkcxpLI+ntDOPkBepMM803YjByel6LVMIWDK4DC6r8IKr+fAI5l4fLRlfCc0udf6p1hIl5Z31CLRj+WtSFKOxGdPbonRZrQZ7FdMpJWGlcev8SgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVD19OU+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ACFC4CEEB;
	Fri,  6 Jun 2025 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749241702;
	bh=8IILO79EXNgU162PlK4G+w9NQreXJ6wJ1JiN/QMclS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVD19OU+axoDAg6treRJMELka/j7YNU39HAOXBtQGF3cx1PWiW6j/r3IHrNeURKib
	 BCfC6tfE28DM2OGmw9/FfneIKNvYyFoTAxldHpNKYkMpoZXbyIj5+JPfTY6N+Jet09
	 hTxujw18w0cYDAo9aD/aryqXPtvSWCQZTMLk3gENMvat2A4n3ELKegURQWFLM1v7a7
	 9Xw7NqaG8yXyp8F+a3GdflUHCi35eVyBiEtzffkZUA/TuLAaHm9WEiSdewwRNHtwWh
	 JFFro6gWZI6EUYL0dLer+8KpU4rGrJLeDPYUU3zNOl5mc0im7nVOf/LL158YnoprJ+
	 LnD0UNAesTa9g==
Date: Fri, 6 Jun 2025 13:28:19 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <fo7d53hseij2pes7fml5hf2gnmfbuzlr7glpbc7wij2sgctuxx@mpr223nazmgg>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <f97a2e18-d672-41b1-ac26-4d1201528ed7@redhat.com>
 <27bkpjpv4lklcxafb4yifrbdjmfxn2sh67lckom2w7hpmgdyxr@zgty22rlp62q>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <27bkpjpv4lklcxafb4yifrbdjmfxn2sh67lckom2w7hpmgdyxr@zgty22rlp62q>

On Fri, Jun 06, 2025 at 12:03:45PM -0700, Josh Poimboeuf wrote:
> On Fri, Jun 06, 2025 at 09:05:59AM -0400, Joe Lawrence wrote:
> > Should the .cmd file copy come from the reference SRC and not original
> > ORIG directory?
> > 
> >   cmd_file="$SRC/$(dirname "$rel_file")/.$(basename "$rel_file").cmd"
> > 
> > because I don't see any .cmd files in klp-tmp/orig/
> > 
> > FWIW, I only noticed this after backporting the series to
> > centos-stream-10.  There, I got this build error:
> > 
> >   Building original kernel
> >   Copying original object files
> >   Fixing patches
> >   Building patched kernel
> >   Copying patched object files
> >   Diffing objects
> >   vmlinux.o: changed function: cmdline_proc_show
> >   Building patch module: livepatch-test.ko
> >   <...>/klp-tmp/kmod/.vmlinux.o.cmd: No such file or directory
> >   make[2]: *** [scripts/Makefile.modpost:145:
> > <...>/klp-tmp/kmod/Module.symvers] Error 1
> >  make[1]: *** [<...>/Makefile:1936: modpost] Error 2
> >  make: *** [Makefile:236: __sub-make] Error 2
> > 
> > The above edit worked for both your upstream branch and my downstream
> > backport.
> 
> Hm, I broke this in one of my refactorings before posting.
> 
> Is this with CONFIG_MODVERSIONS?
> 
> If you get a chance to test, here's a fix (currently untested):

It was indeed CONFIG_MODVERSIONS.  I verified the fix works.

All the latest fixes are in my klp-build branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build

I hope to post v3 next week and then start looking at merging patches --
if not all of them, then at least the first ~40 dependency patches which
are mostly standalone improvements.

-- 
Josh

