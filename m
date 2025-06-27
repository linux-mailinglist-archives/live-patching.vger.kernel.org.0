Return-Path: <live-patching+bounces-1600-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC34AEB567
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 12:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90EC03A5C51
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 10:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A257B2980B2;
	Fri, 27 Jun 2025 10:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nmw6WcqH"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2311D224893;
	Fri, 27 Jun 2025 10:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021499; cv=none; b=MoOWkoK1Nl2sRve4sDY6c04jxq2qg1q/Kk55v///mPGNzIAKbcDJudOzT6oTd492xZQM0LJo3qeWn7gIm9XQfsiQ9IkaCDjkRYdtQC7JPTSdsKIYWghLtvMzyv+L/k5GdPQizpqsj+v3Lndrqcpi55pXVXUu6vhY+aq5F5PwwXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021499; c=relaxed/simple;
	bh=jdYC4qkQlpXy/vbbM74VX4/Gy52Ex+KIwLqtC2cGaxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9/yodFqJD0/xP7DAKQhw9FBr058Gk+LKRPMmrpzTEN8bU4HKJb8o5M7FR7aU6upFasFbDHBSBRDY/GpefYoubsGGgwKypujsfz2Pgp2Hadl5321VRjdGvRHALNiBwtpRGub73TfYZCfhnc6CY+xiluD68bB0pTztTXmkPiXBXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nmw6WcqH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jqQw3L3y4X4QwIjNFZ0bS1J78cjAWZ3Xw0qp4ewaJR8=; b=Nmw6WcqH0R3LQ38gVD/bUVIW6p
	9cCqI27TbG4yLizc6fXvtGcZg8uLHVAtx8V4DOEkZXDv9MMtmoXKDQYBsvVfibTs/5nSV/hAzidQ6
	DBzPTSyQiVcIk7WP0rZAYnmdzHfVZwouvyj5Fkk8TIo7Q7EGLrltnSfoQMz3C7Tjq/OTitU+ALOb7
	Zr0zKEV6xybJTY4xJo0nxTmi7HxnAkkcr8KWSgSQcSMpqpJLWoLpxA2uj9DdOuhocAiEcn0Chnasd
	f9K5YAz2okek3KfybZTVej1jQOBpF3cnjodma2z9F6fTProeq5BtFRXAVbmGKEWdSBMVtdkj9v1NK
	Wjxi5Fvw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV6g2-0000000Drww-0LUu;
	Fri, 27 Jun 2025 10:51:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9598B30017D; Fri, 27 Jun 2025 12:51:25 +0200 (CEST)
Date: Fri, 27 Jun 2025 12:51:25 +0200
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 45/64] x86/static_call: Define ELF section entry size
 of static calls
Message-ID: <20250627105125.GX1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <6c3466449d8c721af903ccc5e16251e36f678236.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c3466449d8c721af903ccc5e16251e36f678236.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:32PM -0700, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, define the entry
> size for the .static_call_sites section in its ELF header.  This will
> allow tooling to extract individual entries.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/include/asm/static_call.h      |  3 ++-
>  include/linux/static_call.h             |  6 ------
>  include/linux/static_call_types.h       |  6 ++++++
>  kernel/bounds.c                         |  4 ++++
>  tools/include/linux/static_call_types.h |  6 ++++++
>  tools/objtool/check.c                   | 11 +++++++++--
>  6 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
> index 41502bd2afd6..e03ad9bbbf59 100644
> --- a/arch/x86/include/asm/static_call.h
> +++ b/arch/x86/include/asm/static_call.h
> @@ -58,7 +58,8 @@
>  	ARCH_DEFINE_STATIC_CALL_TRAMP(name, __static_call_return0)
>  
>  #define ARCH_ADD_TRAMP_KEY(name)					\
> -	asm(".pushsection .static_call_tramp_key, \"a\"		\n"	\
> +	asm(".pushsection .static_call_tramp_key, \"aM\", @progbits, "	\
> +	    __stringify(STATIC_CALL_TRAMP_KEY_SIZE) "\n"		\

More horrifically confusing indenting.

>  	    ".long " STATIC_CALL_TRAMP_STR(name) " - .		\n"	\
>  	    ".long " STATIC_CALL_KEY_STR(name) " - .		\n"	\
>  	    ".popsection					\n")

