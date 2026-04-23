Return-Path: <live-patching+bounces-2478-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Lw0JJbZ6WnolgIAu9opvQ
	(envelope-from <live-patching+bounces-2478-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:34:30 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEC344E96E
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 892F930074C2
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 08:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3583DE449;
	Thu, 23 Apr 2026 08:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Iwdzkq3K"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50195364E9A;
	Thu, 23 Apr 2026 08:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776933261; cv=none; b=ojtsmePC+a/jWq39S++HMEjJEMzqrwkQ5RrwGQTlSkYRpMhLZP/MQ+6+oKyPSgdbFAomIJ1Mx18UVQGGEXe/M1xUfGsG11w5Ihwca/WKCwvlTDvsY1RzqRriilLKv0EbL8dyzH6nSlXW06khBo459PxD/PGkZaVNhUxq2uRJA+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776933261; c=relaxed/simple;
	bh=MFfB5dfXeyapl5sa4ZnHR8fZ9qSJ5XyTo7OD3q6mli4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClvtRFh2r28PHeorkKhlcpK5Y4HzWGhS3VuZzun7c+1d1a5/LCVw7GCVL++bk/rAfENnJ3lFFB0uyZy2wHz8TL4daPqjPYLgw/x8HcljYZNZvX1YWLxdgFUWjs3SaWdQdKKd3KlX86o19MnLEauwXB5zu6Nprl+JEqpBClOQKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Iwdzkq3K; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lVHZkIDDu0IVHp7HkGNXOU4FONveGRjXJnyzyG4nRoU=; b=Iwdzkq3KftpvbycHHT5KEgHLKL
	lVxXkosYQB1WA+2BpNxEIpFZEfv5wo4qLm02G6XwOeBl6403vOq7EVuy7cOBBE5Iqpi0qeJZlgslW
	bviww+eb68PYJWfddX2RX9Jp0y8DK7wS6ynXyYdxyYok4/YgByavC0M2YTe9n7PnSUEOntdwPMXSf
	5pCicekMb0Yyy4yPYUigw2nRDwMaHtssYuWqKYKV2iUMz1/feTt3+hA/t9C77VTyukuBwSNyovqy4
	P21ugrxKYFKIIpj8BzRQ4ui/ZIsjIVZ7EofsSJvjuC3/Cgld8j2HA8DOAUXWuzjmI7i0XTjI4/4r+
	YyNxkAhg==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFpVp-0000000D7U2-1wDi;
	Thu, 23 Apr 2026 08:34:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0499B3008E2; Thu, 23 Apr 2026 10:34:17 +0200 (CEST)
Date: Thu, 23 Apr 2026 10:34:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 26/48] objtool/klp: Don't set sym->file for section
 symbols
Message-ID: <20260423083416.GT3126523@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <a051f7f3c6adb479cabe0b4e1f08552f1412583e.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a051f7f3c6adb479cabe0b4e1f08552f1412583e.1776916871.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2478-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:email,noisy.programming.kicks-ass.net:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6DEC344E96E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 09:03:54PM -0700, Josh Poimboeuf wrote:
> Section symbols aren't grouped after their corresponding FILE symbols.
> Their sym->file should really be NULL rather than whatever random FILE
> happened to be last.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  tools/objtool/elf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index c4cb371e72b2..00c2389f345f 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -680,7 +680,7 @@ static int read_symbols(struct elf *elf)
>  
>  		if (is_file_sym(sym))
>  			file = sym;
> -		else if (sym->bind == STB_LOCAL)
> +		else if (sym->bind == STB_LOCAL && !is_sec_sym(sym))
>  			sym->file = file;
>  	}
>  
> -- 
> 2.53.0
> 

