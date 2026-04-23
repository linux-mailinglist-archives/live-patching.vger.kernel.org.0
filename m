Return-Path: <live-patching+bounces-2476-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKtINR/W6WmglQIAu9opvQ
	(envelope-from <live-patching+bounces-2476-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:19:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7920344E6FC
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6AC18300D749
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 08:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3484C390C8D;
	Thu, 23 Apr 2026 08:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PPBAbF/4"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9182E62B5;
	Thu, 23 Apr 2026 08:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776932361; cv=none; b=XvJzeFH+HkEH4DTvUcEgIp+b2LHIRzDKAgBbyP3NRjcy1RQxUJhwST1VzDss/HXwsV4CD67DNn2Vz6CyBRbhVHOuej95QQGUNhIaESDpF2VocjeUWNCTyvYcWV0VkpXqzoSZUDHNrFwG80HO1AZrfeBqHHS4mwx/19Q7QKIhDxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776932361; c=relaxed/simple;
	bh=vxu10vOY7KBvyyYOzFxz8C5TS8Ur0tNPYY9KRWY+LE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dI34pVkH57QpxZPK4c8LtqjEwMNQ+7Hxz+9EZlJTTdLe9ZDDwRI4GDspjBqfYlWnwLqZKYJqpbgk+Jol6r6g8iLfLZZldT81KoOHsKcqUiprCsCk6HIT019O6AcK1qCymx59/gxPEmveSa11LQ//CMVvPUSJB/k9hiotCPB9jl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PPBAbF/4; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vFOOsg4UiufiYM36RUqKKF94CWeNbURB9GtoSxaRY6Y=; b=PPBAbF/42zbH7Kg5MKET1F81ZD
	TT/E9vpafEWJG29y1V+saPxzqBUuPr5SUPIUaA12kiZDqWknYuj+2Ucgpc5EpnbGhyo50VatctM4e
	llt8FZqQgHgZghxc5Y25qYxCbMf53YePCAobtGzdfBesUOJ4NeplCjwoE39kXijSMGaHAhhkivXzE
	sIZ//DrFkrre+RNIF19Z2NmCz1sLFbP7PKTIh1UBWAQWSvh9CKdyI81JcObZetNZttwoFLCK+XP+M
	7ylZK0swhIcgBY+NnrG64YmGz2X58exJ4L7xlSrMtMgYUmuLSsad7lSh8d/xm8M5bi8LhEi/lwl2U
	OBxk4R5w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFpHG-0000000CdE4-38Yt;
	Thu, 23 Apr 2026 08:19:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4637B3008E2; Thu, 23 Apr 2026 10:19:13 +0200 (CEST)
Date: Thu, 23 Apr 2026 10:19:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 05/48] objtool: Move mark_rodata() to elf.c
Message-ID: <20260423081913.GR3126523@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2476-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MAILSPIKE_FAIL(0.00)[2600:3c09:e001:a7::12fc:5321:server fail];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,infradead.org:dkim,infradead.org:email,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: 7920344E6FC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 09:03:33PM -0700, Josh Poimboeuf wrote:
> Move the sec->rodata marking from check.c to elf.c so it's set during
> ELF reading rather than during the check pipeline.  This makes the
> rodata flag available to all objtool users, including klp-diff which
> reads ELF files directly without running check().
> 
> Add an is_rodata_sec() helper to elf.h for consistency with
> is_text_sec() and is_string_sec().
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  tools/objtool/check.c               | 11 +++--------
>  tools/objtool/elf.c                 | 13 +++++++++++++
>  tools/objtool/include/objtool/elf.h |  5 +++++
>  3 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 9b11cf3193b9..5722d4568401 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2566,7 +2566,6 @@ static int classify_symbols(struct objtool_file *file)
>  static void mark_rodata(struct objtool_file *file)
>  {
>  	struct section *sec;
> -	bool found = false;
>  
>  	/*
>  	 * Search for the following rodata sections, each of which can
> @@ -2579,15 +2578,11 @@ static void mark_rodata(struct objtool_file *file)
>  	 * .rodata.str1.* sections are ignored; they don't contain jump tables.
>  	 */
>  	for_each_sec(file->elf, sec) {
> -		if ((!strncmp(sec->name, ".rodata", 7) &&
> -		     !strstr(sec->name, ".str1.")) ||
> -		    !strncmp(sec->name, ".data.rel.ro", 12)) {
> -			sec->rodata = true;
> -			found = true;
> +		if (is_rodata_sec(sec)) {
> +			file->rodata = true;
> +			return;
>  		}
>  	}
> -
> -	file->rodata = found;
>  }
>  
>  static void mark_holes(struct objtool_file *file)
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index f3df2bde119f..ac9da81a7a2f 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -1172,6 +1172,17 @@ static int read_relocs(struct elf *elf)
>  	return 0;
>  }
>  
> +static void mark_rodata(struct elf *elf)
> +{
> +	struct section *sec;
> +
> +	for_each_sec(elf, sec) {
> +		if ((strstarts(sec->name, ".rodata") && !strstr(sec->name, ".str1.")) ||
> +		    strstarts(sec->name, ".data.rel.ro"))
> +			sec->rodata = true;
> +	}
> +}
> +
>  struct elf *elf_open_read(const char *name, int flags)
>  {
>  	struct elf *elf;
> @@ -1222,6 +1233,8 @@ struct elf *elf_open_read(const char *name, int flags)
>  	if (read_sections(elf))
>  		goto err;
>  
> +	mark_rodata(elf);
> +
>  	if (read_symbols(elf))
>  		goto err;
>  
> diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
> index 25573e5af76e..c61bd57767f9 100644
> --- a/tools/objtool/include/objtool/elf.h
> +++ b/tools/objtool/include/objtool/elf.h
> @@ -296,6 +296,11 @@ static inline bool is_text_sec(struct section *sec)
>  	return sec->sh.sh_flags & SHF_EXECINSTR;
>  }
>  
> +static inline bool is_rodata_sec(struct section *sec)
> +{
> +	return sec->rodata;
> +}
> +
>  static inline bool sec_changed(struct section *sec)
>  {
>  	return sec->_changed;
> -- 
> 2.53.0
> 

