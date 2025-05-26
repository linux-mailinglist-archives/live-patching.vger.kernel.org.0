Return-Path: <live-patching+bounces-1469-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 892CEAC43F6
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 20:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FBC07A9D20
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 18:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD971DF27D;
	Mon, 26 May 2025 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d5koAKS2"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B973025634;
	Mon, 26 May 2025 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748285848; cv=none; b=Z/jINmXPVb64wew0UA+8VQPZOwZ1rJdqZwQwkfbbovr5M7+o5QkQPzponAHYGRWWyA8ONCA8UOOxhUDdqUprCP65E3URLdP7Sbe72d2BUP2AE1X0m0Njbiafl9f75WFdl+pt9isFgSSJPw7bYfvxKecBH33xpeHgI81j1DThDCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748285848; c=relaxed/simple;
	bh=uQUADzOm+ngUl9P/JN2YU35zA0AUKTxoZmjGwPIJRGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DA7WSGU/y10bFLxL+RXH35AnJA7qf9i8xG3nLzAtez3zLxKMBw1pnf4uM9GjlUxtxVR2qSto4HmaFogf0fKWtn6aBZk2/pQhO+WdjUabYybTdmMXxzQe5IqgKiIdjQTw0RwXsOSNDGgV656ePmhL6AHdF4FutcYRndHGOQ/QRvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d5koAKS2; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S2Ld20zI/n3uSTEXzJ/RZIxRMypfW2HK4Zw3V52I/Kw=; b=d5koAKS2+n7dSZMTUiO9hQXmpF
	WrwMf4Ksv5oheu49/X179hapnEU67trZBw+s4crdSbdC0he0dCWPQcYal3PuBtb3Odb4PZ49Njdvr
	L+hWJN1T3bzw0mwUmAsv8CHB0716SjdqHjhW+EzsztA0e9N1CmB5+2EXrF9CMBGGnF0HwjIhVahZA
	Jlq3uQEKmyfOa70jXYDr38Jy7kxegDdfosvz4fmpaH9eitDuSMroQMUx8mt+KN6i08Xa/NjmN60QW
	vI37R6QNByflgNrLmP/7Tg7RjSF9LMhQ+YSaLlFG+TSCy6tvHcPE2qq8PnhBjyZbtEI9IqWq1Tcus
	BXJgG75A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJd0e-00000001yGO-359f;
	Mon, 26 May 2025 18:57:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4941F300472; Mon, 26 May 2025 20:57:16 +0200 (CEST)
Date: Mon, 26 May 2025 20:57:16 +0200
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <20250526185716.GU24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
> index 4cfd09e66cb5..f62ac8081f27 100644
> --- a/tools/objtool/include/objtool/elf.h
> +++ b/tools/objtool/include/objtool/elf.h
> @@ -17,6 +17,7 @@
>  #include <objtool/checksum_types.h>
>  #include <arch/elf.h>
>  
> +#define SEC_NAME_LEN		512
>  #define SYM_NAME_LEN		512
>  
>  #ifdef LIBELF_USE_DEPRECATED
> @@ -50,10 +51,12 @@ struct section {
>  	bool _changed, text, rodata, noinstr, init, truncate;
>  	struct reloc *relocs;
>  	unsigned long nr_alloc_relocs;
> +	struct section *twin;
>  };
>  
>  struct symbol {
>  	struct list_head list;
> +	struct list_head global_list;
>  	struct rb_node node;
>  	struct elf_hash_node hash;
>  	struct elf_hash_node name_hash;
> @@ -79,10 +82,13 @@ struct symbol {
>  	u8 cold		     : 1;
>  	u8 prefix	     : 1;
>  	u8 debug_checksum    : 1;
> +	u8 changed	     : 1;
> +	u8 included	     : 1;
>  	struct list_head pv_target;
>  	struct reloc *relocs;
>  	struct section *group_sec;
>  	struct checksum csum;
> +	struct symbol *twin, *clone;
>  };
>  
>  struct reloc {
> @@ -100,6 +106,7 @@ struct elf {
>  	const char *name, *tmp_name;
>  	unsigned int num_files;
>  	struct list_head sections;
> +	struct list_head symbols;
>  	unsigned long num_relocs;
>  
>  	int symbol_bits;

ISTR us spending significant effort shrinking all this stuff. How does
this affect vmlinux.o memory footprint etc?

