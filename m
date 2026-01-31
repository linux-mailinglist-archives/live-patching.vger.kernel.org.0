Return-Path: <live-patching+bounces-1956-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GlDAJJofWk4SAIAu9opvQ
	(envelope-from <live-patching+bounces-1956-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 03:27:30 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5393BC04AF
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 03:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 593E0300C926
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 02:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E393221264;
	Sat, 31 Jan 2026 02:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aiLqOX50"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3691EBFF7
	for <live-patching@vger.kernel.org>; Sat, 31 Jan 2026 02:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769826422; cv=none; b=jZBN/w1H6znvkQw8fai5cMlo/S0Agk0BZlEWvQPLu/7YoWhofpeAAgFFRK6GRAPqtak1X3Z9GMIJfQ7TWGQb6YBjZ8aLyVK0ps7gLLJWnmADwvVysDXt3//jAbLe8zO1T3yobxOH5e3Zf5bYQttLsXBuPR/YJ50+rdWRBsR6fK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769826422; c=relaxed/simple;
	bh=DkaI9KQJIMr3gLIdSLIt8AS1LGhTH3DM1Tk9dFrT2e8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jD9K37NJolstpqXAbDJB9UUrqQbp2j0ilxSdX/FUHY8assAwph7FmqwiDpZ3cNeCT3Zt2nXvkIC9cJMVqqzvatc+2OpGX2xDlAQctCVgH01tJ/+MDYAd165xEG/67LaGYqAKxeqBljeVwfuEsi1RH/Ne1C2VAdLQ+nFfXTAmB+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aiLqOX50; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544F3C4CEF7;
	Sat, 31 Jan 2026 02:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769826422;
	bh=DkaI9KQJIMr3gLIdSLIt8AS1LGhTH3DM1Tk9dFrT2e8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aiLqOX50xxfJjwQPIPTzOscQLmkB3f1FS4YofcFiFavwYlEh8Rg6LWTdzUdFvdig7
	 bu5QvXqAZyhz0Gd0TKSo6/lAB3WEaMMUikX1r03ByY4g9feIE3GPm0Z8nam6Vdz2tL
	 03Htc8JUEa+DlUPtKwoLf0rkj88WDWH3ifP2kAg+joGg4D+ra03/GHgPVOXN+N0ylz
	 6kaIa5nIy0o+/c00+k5Nm8Is1hqj2zqXeFDwHoscrzSOWqc8eAYSbQnIgej+Uxp3KE
	 eg04AC1mH3anCXTCVYmOeSjUZ0GToTMR6lG47JKaSQy56rc8GjZBu77T+6kr1XnPjV
	 zix0/7/WaCWZA==
Date: Fri, 30 Jan 2026 18:26:59 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Subject: Re: [PATCH] klp-build: Do not warn "no correlation" for
 __irf_[start|end]
Message-ID: <2ngp5g3ogtin57nytfvbiq2nh6nfy5qxdianll5eme24owsyj5@a4bxxfkobnwc>
References: <20260130203912.2494181-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260130203912.2494181-1-song@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1956-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5393BC04AF
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:39:12PM -0800, Song Liu wrote:
> When compiling with CONFIG_LTO_CLANG_THIN, vmlinux.o has
> __irf_[start|end] before the first FILE entry:
> 
> $ readelf -sW vmlinux.o
> Symbol table '.symtab' contains 597706 entries:
>    Num:    Value          Size Type    Bind   Vis      Ndx Name
>      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
>      1: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   18 __irf_start
>      2: 0000000000000200     0 NOTYPE  LOCAL  DEFAULT   18 __irf_end
>      3: 0000000000000000     0 SECTION LOCAL  DEFAULT   17 .text
>      4: 0000000000000000     0 SECTION LOCAL  DEFAULT   18 .init.ramfs
> 
> This causes klp-build throwing warnings like:
> 
> vmlinux.o: warning: objtool: no correlation: __irf_start
> vmlinux.o: warning: objtool: no correlation: __irf_end
> 
> Fix this by not warn for no correlation before seeing the first FILE
> entry.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/objtool/klp-diff.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index d94531e3f64e..370e5c79ae66 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -363,6 +363,7 @@ static int correlate_symbols(struct elfs *e)
>  {
>  	struct symbol *file1_sym, *file2_sym;
>  	struct symbol *sym1, *sym2;
> +	bool found_first_file = false;
>  
>  	/* Correlate locals */
>  	for (file1_sym = first_file_symbol(e->orig),
> @@ -432,9 +433,12 @@ static int correlate_symbols(struct elfs *e)
>  	}
>  
>  	for_each_sym(e->orig, sym1) {
> +		if (!found_first_file && is_file_sym(sym1))
> +			found_first_file = true;
>  		if (sym1->twin || dont_correlate(sym1))
>  			continue;
> -		WARN("no correlation: %s", sym1->name);
> +		if (found_first_file)
> +			WARN("no correlation: %s", sym1->name);

It's a bit worrisome that Clang is stripping FILE entries and moving
symbols, but I looked at the symbol table for a thin LTO vmlinux.o and
it only seems to have stripped this one FILE symbol for initramfs_data.o
and made its symbols orphans.  Presumably because this file only has
data and no code.

I actually think the warning is valid.  We should try to correlate those
pre-FILE symbols, otherwise things like klp_reloc_needed() might not
work as intended.

Does the below patch work instead?

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index d94531e3f64e..ea292ebe217f 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -364,11 +364,40 @@ static int correlate_symbols(struct elfs *e)
 	struct symbol *file1_sym, *file2_sym;
 	struct symbol *sym1, *sym2;
 
-	/* Correlate locals */
-	for (file1_sym = first_file_symbol(e->orig),
-	     file2_sym = first_file_symbol(e->patched); ;
-	     file1_sym = next_file_symbol(e->orig, file1_sym),
-	     file2_sym = next_file_symbol(e->patched, file2_sym)) {
+	file1_sym = first_file_symbol(e->orig);
+	file2_sym = first_file_symbol(e->patched);
+
+	/*
+	 * Correlate any locals before the first FILE symbol.  This has been
+	 * seen when LTO inexplicably strips the initramfs_data.o FILE symbol
+	 * due to the file only containing data and no code.
+	 */
+	for_each_sym(e->orig, sym1) {
+		if (sym1 == file1_sym || !is_local_sym(sym1))
+			break;
+
+		if (dont_correlate(sym1))
+			continue;
+
+		for_each_sym(e->patched, sym2) {
+			if (sym2 == file2_sym || !is_local_sym(sym2))
+				break;
+
+			if (sym2->twin || dont_correlate(sym2))
+				continue;
+
+			if (strcmp(sym1->demangled_name, sym2->demangled_name))
+				continue;
+
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+			break;
+		}
+	}
+
+	/* Correlate locals after the first FILE symbol */
+	for (; ; file1_sym = next_file_symbol(e->orig, file1_sym),
+		 file2_sym = next_file_symbol(e->patched, file2_sym)) {
 
 		if (!file1_sym && file2_sym) {
 			ERROR("FILE symbol mismatch: NULL != %s", file2_sym->name);

