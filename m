Return-Path: <live-patching+bounces-1491-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 558B1ACF997
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 00:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D3A37A3A4C
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 22:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7276327FB35;
	Thu,  5 Jun 2025 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8jDl6lq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE72798F3;
	Thu,  5 Jun 2025 22:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161703; cv=none; b=m7kJEZtKj0szfuqVjm7GMy33cwcyJbgV58BYpdhYqJJrr1CigUMzdVYHEf5MYElkoTotxWIeMmYs/+NHGU6XjUpZKfnBvYZq9gr210RElAfGPMcw7q5r2igoQkPvlvihARd3hpo6qqQUUvKw2Aic5ln6FtH2x6fpKpqZXeL0vxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161703; c=relaxed/simple;
	bh=mhsaYFQq7gy42/4PAcqHn5WEllGemv3pGkKXlEelSls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NwNt9+BankVZdgVnY3xz4aWLiIKJAe9aGqLrzQCAqnXnb9UD/6nx1QsSsds5cmlJyM2bKeOTKmiHW6pIfVZTK/DU0IuUVJx6ywo1ZduP1dh3jSoWhHqUcNq0NU2jqiquHtpE6SwBV0egRl7jv/K0G5mhNkYhYbjZY9fwvShTE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8jDl6lq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F383C4CEE7;
	Thu,  5 Jun 2025 22:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749161702;
	bh=mhsaYFQq7gy42/4PAcqHn5WEllGemv3pGkKXlEelSls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A8jDl6lq2um5arpgpGf4i8zNTViFm7y8mv9dyap+T8+aTsv222UybuznvmbmWiXNi
	 ZAwwlvL+od5iWk0Bc147zG35Y0vZdz5sElTVKQWG5U4YvdpS4MMpR9aLPD17kSy4dv
	 DzJvF33wGIFntnT9878OHyYh23IePuRQ6FZMfFmd5ijA3I0lUt06OEfJCFFUEizKVm
	 QBQuXyF+M8L+983PpxBUW5oNOAYeP5N3MlIXroPyV2V55wyxpTL/lUDKZ855LrAF5J
	 B6QUv8zwIrnv7O1x209xlHx+tCLdzMXdKAlLQrvBW8sv6lO1PoGtdTeS1KSAIQhL2A
	 Czn0EPZycXr1Q==
Date: Thu, 5 Jun 2025 15:14:59 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 45/62] x86/extable: Define ELF section entry size for
 exception tables
Message-ID: <qtaf3nlbje7xzrypzn2gevue2uhmrrx6tqvgp3kgzgmia77mmd@ofabxb75cydw>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
 <d6940b24-d78f-4da5-a8fa-6a408528822f@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6940b24-d78f-4da5-a8fa-6a408528822f@redhat.com>

On Wed, May 28, 2025 at 10:40:55AM -0400, Joe Lawrence wrote:
> On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> > In preparation for the objtool klp diff subcommand, define the entry
> > size for the __ex_table section in its ELF header.  This will allow
> > tooling to extract individual entries.
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  arch/x86/include/asm/asm.h | 20 ++++++++++++--------
> >  kernel/extable.c           |  2 ++
> >  2 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> > index f963848024a5..62dff336f206 100644
> > --- a/arch/x86/include/asm/asm.h
> > +++ b/arch/x86/include/asm/asm.h
> > @@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
> >  
> >  # include <asm/extable_fixup_types.h>
> >  
> > +#define EXTABLE_SIZE 12
> >
> > + > [ ... snip ... ]
> >
> 
> EXTABLE_SIZE defined in arch/x86/ ...
> 
> > diff --git a/kernel/extable.c b/kernel/extable.c
> > index 71f482581cab..0ae3ee2ef266 100644
> > --- a/kernel/extable.c
> > +++ b/kernel/extable.c
> > @@ -55,6 +55,8 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
> >  {
> >  	const struct exception_table_entry *e;
> >  
> > +	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
> > +
> 
> but referenced in kernel/ where a non-x86 build like ppc64le build won't
> know what EXTABLE_SIZE is :(

Thanks, I'll move the BUILD_BUG_ON() to the x86 extable code:

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index bf8dab18be97..d4aae98b3739 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -303,6 +303,8 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 	const struct exception_table_entry *e;
 	int type, reg, imm;
 
+	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
+
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
 		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
diff --git a/kernel/extable.c b/kernel/extable.c
index 0ae3ee2ef266..71f482581cab 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -55,8 +55,6 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 {
 	const struct exception_table_entry *e;
 
-	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
-
 	e = search_kernel_exception_table(addr);
 	if (!e)
 		e = search_module_extables(addr);

