Return-Path: <live-patching+bounces-1478-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E32ACE75D
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 02:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55A3E189349E
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 00:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB890136E;
	Thu,  5 Jun 2025 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aafXWzSe"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF936D;
	Thu,  5 Jun 2025 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749081876; cv=none; b=e6G84a4Nrz4Fz+OQ1LNaQRQmCLtzp41Mdnop6sZUqE90nR7GsMnjPvZyHf090rOblSeWdp9orMXIID5yXMlYGW3SEY/cxM3nefknH4lVN6VaHCtcnKLv7kCKme5KVXXlkP3dnJDKbKp924+FcfLO0OOEVPdvyjrOGuUltPzxg9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749081876; c=relaxed/simple;
	bh=fG7CS8UcFYi2yhT/A7/PcuUjtV5PNse5wW8m63oIo6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRli95HU8OaKDXxrXmxYDk6AgCob2/JU2y6VCHPB4xlJ/gHnlz0X04mWrtm35OrbvRgGwQbu5oEQFRIXvWlHs8bLpKHRlU8RyoiP0l/exPvqGgsgRDLshb7en0ZDYB6H/XQZOpHO7DwX7X/qM2PVi6+Cmu578T7ff5QI29MGtOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aafXWzSe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D9C4CEE4;
	Thu,  5 Jun 2025 00:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749081876;
	bh=fG7CS8UcFYi2yhT/A7/PcuUjtV5PNse5wW8m63oIo6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aafXWzSeJXugkmFi+0coGA34S0bHRfPuDaSg1KGxhfunjvgF4e0KQjVTFjow29o7R
	 9Hn9wneqOQwpfseX1p/9QDUeTAwFJl4jmMv/TQLpU2pyFrri6NeDcSqcZjv+LiBx6J
	 PdL/bwC17CV3UOJ0+ddt6QcXFkEabdsP/6dJX95kV3vOnEu2fbYZhgeoBepMQMdIql
	 ivYYZjhbVla7hlYe95HYmd1onTg2tjGbj8XWHho4tlmWMaozaLOCyIFqMSTITRx+nB
	 K01ydjZ5yp484XnY+J/BocX/phcwKa//yycCGFW/anwFL4d5hIWZWgFHnpqmgHxkjX
	 k1GItrQgMIGKA==
Date: Wed, 4 Jun 2025 17:04:33 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 29/62] objtool: Mark prefix functions
Message-ID: <e2hv6jkitxvbtaqj377dvpwtn5tyaoux53ofkkegxcn3fapbcx@kfqxactn4ogj>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <c4233972de0b0f2e6c94d4a225c953748d7c446b.1746821544.git.jpoimboe@kernel.org>
 <20250526104355.GM24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526104355.GM24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 12:43:55PM +0200, Peter Zijlstra wrote:
> > +++ b/tools/objtool/elf.c
> > @@ -442,6 +442,11 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
> >  	elf_hash_add(symbol, &sym->hash, sym->idx);
> >  	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
> >  
> > +	if (is_func_sym(sym) && sym->len == 16 &&
> 
> Where did that 'sym->len == 16' thing come from? I mean, they are, but
> the old code didn't assert that.
> 
> I would rather objtool issue a warn if not 16, but still consider these
> as prefix.

Ok:

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 9a1fc0392b7f..2953aa8d2b81 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -442,10 +442,12 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
-	if (is_func_sym(sym) && sym->len == 16 &&
-	    (strstarts(sym->name, "__pfx") || strstarts(sym->name, "__cfi_")))
+	if (is_func_sym(sym) &&
+	    (strstarts(sym->name, "__pfx_") || strstarts(sym->name, "__cfi_"))) {
+		if (sym->len != 16)
+			WARN("%s size %d != 16", sym->name, sym->len);
 		sym->prefix = 1;
-
+	}
 
 	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
 		sym->cold = 1;

