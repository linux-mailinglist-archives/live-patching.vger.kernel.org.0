Return-Path: <live-patching+bounces-2570-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NDpA1gP8GnTNgEAu9opvQ
	(envelope-from <live-patching+bounces-2570-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 03:37:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E8A47C765
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 03:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 721EE3014BFF
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 01:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE8B2D8399;
	Tue, 28 Apr 2026 01:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KEW2u5Kh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F8C2765E2
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 01:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777340242; cv=none; b=GgZM+YPgvXKX1HsVBg22ERG4uVo9ORqM+ETVOsweCb5PgSDD23a0EPWI7QT4s/047pbBVkAW10vFYmQkM19afL7zv0px5WIwhhenPr3303jqF2SP6u3Kir5bO+49HxHxxf7SqfDUZ7VcwiVQ+kMaG9AQ14zQHrkVoBdtgeXEQug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777340242; c=relaxed/simple;
	bh=sWMzUcLrzPgbcgZz1EwDNZqDBjT61x7ZjN+TeO/Rljw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OFWXrTaDvFbnLbUhlMYZKRY8zXD1zbD9Kw/zUU9uxuquo28CfknR4yFnuTne+/JTd7yssfg3I1/rJNzYjLp6qA1VaSupHSZZjtxnj+5T83rny91c6Pb8wKWoJEYtxvK8TUfgg5BDn9FUWZCgTFNbu61Il/PAFkVAxAX7L8KXOAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KEW2u5Kh; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4411e1eba51so7492020f8f.3
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777340239; x=1777945039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEl1Am/J5g4qr5YLKQUgLc7phAWVNiM35M/zkbiuaic=;
        b=KEW2u5Kh08RMFQEDPIsFTrfzapefcGgkSAWEaDrNuRZydH5jYXW3IFW0YWE1bF4BEf
         ISD0gm2jjL43+eIdTEaDGR/r/rjBVw0g5Y3ANJoqT/wYni63Y5u12m7w2+m10QpmiDse
         GHjc97I9H/VFejMjLY2vYQ5a6ZqSb0xyG/IkQ/h22uhQWFz5eRc3TmFLZOIeej3V2h15
         YJXlttGu0zokECnNl0cEvgLFblc+2BLhrX6tDhlcbAOsvQhSntxytBNQzZmmqy2TNGS9
         aBx9WrHRC7RRvenTaHe4QMSUBhXD2VcGk0EtymSRJePc9h8433bSf52LRZ+zemMbaPn3
         lQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777340239; x=1777945039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YEl1Am/J5g4qr5YLKQUgLc7phAWVNiM35M/zkbiuaic=;
        b=dSwl2ftoX9CoaBizWmIigVeHhFcj4Hj9J28Tf1qDed1lB39h18qVP7Cnv79LurEvIf
         3PX2eVDiEByxYuKK7vrjmmvRTPOLNX7cVCsrmzBwpKyZMxJGIMjFUeyKtBIBPWcG5zfi
         i4Yp5SibvJqQRiTXbp3qBlaBEnwu3hHPDz6H5/D70oBc0EdIa3AWKD591GK85MpiYnpR
         qobT/vBkUZdOuObQcK9iw/l1SI/VOWEw26g3lEiMz+gUBlSJPdVQRh+39pCttQdh9bO9
         Ug368Ma+j0N2dMBiTNNWmzt9EWEcsJYUngPnam8ad2mxbkEkqr6RnkE1ptLmv6tNzwfk
         BYCA==
X-Forwarded-Encrypted: i=1; AFNElJ/6KpaF9a3iYLiPefRPmTsCHL9SGAb4PW6ziNhEO7irSKhKEldcIyHFvP1JSbZRt+0gT0LwSiObc3A/eQz3@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+74eCSZOrTRw/QhUzk9TW5UG2ofIAe9C1kiCPHLoLk2D7l8tb
	jZxYQHXiwzOMZtQ3h8mi5eNsoqBvMHC0a+nc+qskNn6PW6B16CQfTooS
X-Gm-Gg: AeBDietO1J/9Ynzv19mZbNOs+zih8Hk8e5xk4bthciSo280gd1xrWb/iykBIshq4dLo
	reZmtHgiN+v+P+LKX3ptNMdLkg71rtFRvKUCdWm3zxXsMXagGCpEMiGy26NChdUJcEYke+IFBZH
	OdpVIZiboEyAjHlyW1ID+jj9x4BiTYDh2+1btOGXIuFuj0lQS5DdUfhK8gUHX6sOWaP9QInkVmI
	TaF76jFccbS0MNPoLi0DXUSHcLvvuUgzCh3F6KGiNTQJuBTp6P0RPIGYgDYNDrUpI1N9pTLqWeN
	zTs32Xdxm/u5DsC62OMmhPdTTnhW1XCGLOCozI+nUgNFWiBTiBnAEeioKTJgdAzqibO4/TRLM0j
	yo4W5z50J5gE3AQpOnu6Iz3MMOSN+SD8QfEAtu/6dgSsELslBof2xKSrzebNTeR50wd0cyX/0Gi
	4E3nsqHE16bx1S4OyFt/ZpZTRF4IlHOHCI7KA1XzTuVEGPCl5q4GQBa98udsqSriK+80nZvmk9E
	68=
X-Received: by 2002:a05:6000:26d2:b0:43d:68d4:7469 with SMTP id ffacd0b85a97d-4464896354fmr1715053f8f.11.1777340239237;
        Mon, 27 Apr 2026 18:37:19 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463cb59e5asm2709414f8f.5.2026.04.27.18.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 18:37:19 -0700 (PDT)
Date: Tue, 28 Apr 2026 02:37:17 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, Joe Lawrence
 <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <20260428023717.6a7c68c6@pumpkin>
In-Reply-To: <c7vi7gpfrybjmngjoqu2jmirh6jp53bpw5edeoeupz5gwhw6gx@fvcn6l6vgl47>
References: <cover.1776916871.git.jpoimboe@kernel.org>
	<70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
	<20260423084758.GY3126523@noisy.programming.kicks-ass.net>
	<n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
	<20260423151925.GG1064669@noisy.programming.kicks-ass.net>
	<gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
	<d5ex4fawfive7trcvhsptu2dwr5l5yru5q6bsx5zh3sqlle26u@navby7ru5z6t>
	<c7vi7gpfrybjmngjoqu2jmirh6jp53bpw5edeoeupz5gwhw6gx@fvcn6l6vgl47>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76E8A47C765
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2570-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Thu, 23 Apr 2026 20:38:02 -0700
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> On Thu, Apr 23, 2026 at 04:30:47PM -0700, Josh Poimboeuf wrote:
> > On Thu, Apr 23, 2026 at 09:23:12AM -0700, Josh Poimboeuf wrote:  
> > > On Thu, Apr 23, 2026 at 05:19:25PM +0200, Peter Zijlstra wrote:  
> > > > On Thu, Apr 23, 2026 at 08:16:08AM -0700, Josh Poimboeuf wrote:  
> > > > > On Thu, Apr 23, 2026 at 10:47:58AM +0200, Peter Zijlstra wrote:  
> > > > > > On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:  
> > > > > > > PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> > > > > > > generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> > > > > > > __pfx_ symbols were considered redundant.
> > > > > > > 
> > > > > > > However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> > > > > > > FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> > > > > > > the hash and the function entry which have no symbol to claim them.  
> > > > > > 
> > > > > > If you force the function alignment to 64 bytes, the prefix will also be
> > > > > > 64bytes, rather than the normal 16.  
> > > > > 
> > > > > Sorry, how do you get 64 here?  
> > > > 
> > > > DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y  
> > > 
> > > Ok, so in that case it would be 5-byte cfi symbol and 59-byte NOP gap.
> > > Or a 64-byte pfx for the !CFI case.
> > >   
> > > > > > > The NOPs can be rewritten with call depth tracking thunks at runtime.
> > > > > > > Without a symbol, unwinders and other tools that symbolize code
> > > > > > > locations misattribute those bytes.
> > > > > > > 
> > > > > > > Remove the !CFI guard so objtool creates __pfx_ symbols for all
> > > > > > > CALL_PADDING configs, covering the full padding area regardless of
> > > > > > > whether there's also a __cfi_ symbol.  
> > > > > > 
> > > > > > Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
> > > > > > __cfi_ symbols to cover the whole prefix?  
> > > > > 
> > > > > Yeah, I suppose that would be better, via objtool I presume.  
> > > > 
> > > > Yup.  
> 
> I discovered it's not just FineIBT, it's basically any CALL_PADDING+CFI,
> like so:
> 
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> Subject: [PATCH] objtool: Grow __cfi_* symbols for all kCFI+CALL_PADDING
> 
> For all CONFIG_CFI+CONFIG_CALL_PADDING configs, the __cfi_ symbols only
> cover the 5-byte kCFI type hash.  After that there also N bytes of NOP
> padding between the hash and the function entry which aren't associated
> with any symbol.
> 
> The NOPs can be replaced with actual code at runtime.  Without a symbol,
> unwinders and tooling have no way of knowing where those bytes belong.
> 
> Grow the existing __cfi_* symbols to fill that gap.
> 
> Also, CONFIG_PREFIX_SYMBOLS has no reason to exist: CONFIG_CALL_PADDING
> is what causes the compiler to emit NOP padding before function entry
> (via -fpatchable-function-entry), so it's the right condition for
> creating prefix symbols.
> 
> Remove CONFIG_PREFIX_SYMBOLS, as it's no longer needed.  Simplify the
> LONGEST_SYM_KUNIT_TEST dependency accordingly.
> 
> Update the --cfi and --prefix usage strings to reflect their current
> scope.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
...
> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
> index ec7f10a5ef19..254ceb6b0e2c 100644
> --- a/tools/objtool/builtin-check.c
> +++ b/tools/objtool/builtin-check.c
> @@ -73,7 +73,6 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
>  
>  static const struct option check_options[] = {
>  	OPT_GROUP("Actions:"),
> -	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
>  	OPT_STRING_OPTARG('d',	 "disas", &opts.disas, "function-pattern", "disassemble functions", "*"),
>  	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
>  	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
> @@ -84,7 +83,7 @@ static const struct option check_options[] = {
>  	OPT_BOOLEAN('r',	 "retpoline", &opts.retpoline, "validate and annotate retpoline usage"),
>  	OPT_BOOLEAN(0,		 "rethunk", &opts.rethunk, "validate and annotate rethunk usage"),
>  	OPT_BOOLEAN(0,		 "unret", &opts.unret, "validate entry unret placement"),
> -	OPT_INTEGER(0,		 "prefix", &opts.prefix, "generate prefix symbols"),
> +	OPT_INTEGER(0,		 "prefix", &opts.prefix, "generate or grow prefix symbols for N-byte function padding"),
>  	OPT_BOOLEAN('l',	 "sls", &opts.sls, "validate straight-line-speculation mitigations"),
>  	OPT_BOOLEAN('s',	 "stackval", &opts.stackval, "validate frame pointer rules"),
>  	OPT_BOOLEAN('t',	 "static-call", &opts.static_call, "annotate static calls"),
> @@ -92,6 +91,7 @@ static const struct option check_options[] = {
>  	OPT_CALLBACK_OPTARG(0,	 "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
>  
>  	OPT_GROUP("Options:"),
> +	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate and grow kCFI preamble symbols (use with --prefix)"),
>  	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
>  	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
>  	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
> @@ -163,6 +163,11 @@ static bool opts_valid(void)
>  		return false;
>  	}
>  
> +	if (opts.cfi && !opts.prefix) {
> +		ERROR("--cfi requires --prefix");
> +		return false;
> +	}
> +

Wouldn't it be more friendly to have:
	opts.prefix |= opts.cfi;
and change the help to (implies --prefix).

	David

