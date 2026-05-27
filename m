Return-Path: <live-patching+bounces-2907-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6NGQBVUOF2oR2gcAu9opvQ
	(envelope-from <live-patching+bounces-2907-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 17:31:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C8E5E6E59
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 17:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 17699300F61B
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 15:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5403C9895;
	Wed, 27 May 2026 15:30:48 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC672380FF3;
	Wed, 27 May 2026 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895848; cv=none; b=m7WQc2yXgQaBOmT3AKhA6dT+ORyvFPBevI4gimCBapsdbOTwRjYxclrhdb3LdAFmDyTHDnMxXnRZz6k/b0VGRIomAQLDtcGnjoQSlxcgeJ75hBaElosuuV0NE3VBLeVMWdST3eIiNnT3R7bIWuPm3SNDGBzA/kRdVKNosogVvPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895848; c=relaxed/simple;
	bh=pJJ/HoF2eidmfdtOIs5JrkNnpQrJrLqOkwxCfd42Coc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nf9sTaqWr4CzEKZ+nrwAf3SW3D3kBT3vaBw69fsEKPwJpvrsdXqdEwmm7JatSz4CQwHR2LZLeFFq1w4pHV/Z2adP32Wj3UJ4BVNQWG1lVLFv61CvT4Q9/kLe+PVsqqrsjkm9NPej2R78Sk0/WmdMoa2s9CejJlMDfHd6pJdaR3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C476A0651;
	Wed, 27 May 2026 15:30:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id B12158000E;
	Wed, 27 May 2026 15:30:29 +0000 (UTC)
Date: Wed, 27 May 2026 11:30:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang Han <wanghan@linux.alibaba.com>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chen Pei
 <cp0613@linux.alibaba.com>, Andy Chiu <andybnac@gmail.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, Deepak Gupta
 <debug@rivosinc.com>, Puranjay Mohan <puranjay@kernel.org>, Conor Dooley
 <conor.dooley@microchip.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri
 Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek
 <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
 <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung
 Kim <namhyung@kernel.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/8] scripts/sorttable: Handle RISC-V patchable ftrace
 entries
Message-ID: <20260527113028.4b21a5de@fedora>
In-Reply-To: <20260527123530.2593918-2-wanghan@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
	<20260527123530.2593918-2-wanghan@linux.alibaba.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nnbmrnfbfe1wryzsbgekpraefim6x8ui
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+K9+QhA9jGvAkANPOLEFyENvfDDvbRRfc=
X-HE-Tag: 1779895829-775147
X-HE-Meta: U2FsdGVkX19wPgPqZNdREAfoBR1Mb1SYjw1Qr1fZaDsU2ZIANjz8nzdue+HVeK2Zhwus4Rq5inE4ARZBKtoCeWe0ubFDOoBMTV3DKQduvwyTdxCeh07J7RG5bppBc+QRHCVi7uGFASdNJj+Oti7v6B7UoYG7kOcUTzoJfTcYLn6i1oNAkLtatX5dFGJ42OfJuyqGbtFf4isoqhy6vAe2t5vof90x/DNH1LA33QEhaSjdAyLuvTQJJ5fUBWe1UcfAmfqIoC+fFFXc4qnBunytWGTMyWgTrUEAGXAkcg4nDSzBsQsE2ojHfd921ji7ceBLhwTIJqKgDUiQes6K8DANThowqvNnaXHa
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2907-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[30];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[live-patching];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 10C8E5E6E59
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 27 May 2026 20:35:23 +0800
Wang Han <wanghan@linux.alibaba.com> wrote:

> Signed-off-by: Wang Han <wanghan@linux.alibaba.com>
> ---
>  scripts/sorttable.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/sorttable.c b/scripts/sorttable.c
> index e8ed11c680c6..b4061c2c03e1 100644
> --- a/scripts/sorttable.c
> +++ b/scripts/sorttable.c
> @@ -901,11 +901,17 @@ static int do_file(char const *const fname, void *addr)
>  		/* fallthrough */
>  	case EM_386:
>  	case EM_LOONGARCH:
> -	case EM_RISCV:
>  	case EM_S390:
>  	case EM_X86_64:
>  		custom_sort = sort_relative_table_with_data;
>  		break;
> +	case EM_RISCV:
> +#ifdef MCOUNT_SORT_ENABLED
> +		/* RISC-V uses patchable function entries before function entry. */
> +		before_func = 8;
> +#endif
> +		custom_sort = sort_relative_table_with_data;
> +		break;
>  	case EM_PARISC:
>  	case EM_PPC:
>  	case EM_PPC64:

So basically RISCV has the same problem as ARM64 with patchable
entries. As this may happen for other archs in the future, I would like
to group them together like this:

diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index e8ed11c680c6..b3d9073d9fbc 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -891,17 +891,23 @@ static int do_file(char const *const fname, void *addr)
 	table_sort_t custom_sort = NULL;
 
 	switch (elf_map_machine(ehdr)) {
-	case EM_AARCH64:
 #ifdef MCOUNT_SORT_ENABLED
+	case EM_AARCH64:
 		sort_reloc = true;
 		rela_type = 0x403;
-		/* arm64 uses patchable function entry placing before function */
+		/*
+		 * arm64 and RISCV use patchable function entry placing
+		 * before function
+		 */
+	case RISCV:
 		before_func = 8;
+#else
+	case EM_AARCH64:
+	case RISCV:
 #endif
 		/* fallthrough */
 	case EM_386:
 	case EM_LOONGARCH:
-	case EM_RISCV:
 	case EM_S390:
 	case EM_X86_64:
 		custom_sort = sort_relative_table_with_data;

does the above work for you? (Although I didn't even compile test it).

-- Steve

