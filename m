Return-Path: <live-patching+bounces-1972-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 3zOkJmCKgmlfWAMAu9opvQ
	(envelope-from <live-patching+bounces-1972-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 00:53:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5E7DFDB3
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 00:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C593302414E
	for <lists+live-patching@lfdr.de>; Tue,  3 Feb 2026 23:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25F5331A63;
	Tue,  3 Feb 2026 23:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDZIZLki"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF010320CBE
	for <live-patching@vger.kernel.org>; Tue,  3 Feb 2026 23:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770162781; cv=none; b=uC8e64DhvZdNOj/+O4Jdaa7FP3bREUjIhqFItH+prRR3MTH7bnXX+QPeBmBbitBWcJdikTaRkbfJ0NhUT8OR6SBd6yjvN2JaKZrP3FCPEFLC4eqgX25lFsIVZHcbVruXXSzo7wGfCtDCuCAjcypOXbFu+8iAA6fsyQMwHYicM1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770162781; c=relaxed/simple;
	bh=aoexM9I1Vc/9X13XqE6/mL90X+EuVVbbTyD8aUTF4Uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgr/XvgIcOHpzi26DdGueuvToJ01sM6JY4MjRhIQlgayBRxVuLGpH3/gxSKaHD+MJ1nhcHIV1gUIJ32XpYfpds2V+VCqlQY6XQz0Ih1sHpAmm5ySwl5141ugtGcNx1HT+bX4LY3JTCt9K/V/oL5JNSHI6rw1aiMCxjQeLzRFXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDZIZLki; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F0AC116D0;
	Tue,  3 Feb 2026 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770162781;
	bh=aoexM9I1Vc/9X13XqE6/mL90X+EuVVbbTyD8aUTF4Uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDZIZLki3ZaCxOtIXRXWE8LQwFgIsmSk5uET8fy1POItBDDFwUXmm47XaVEHAn2X9
	 jdoa9vk7p5XlHoQ4eXnDlXK5Kgb1u5SUWSu65RsBGuaB8ZtM2ccJKlvYfHkXYUgK43
	 quev+yQ+7feU/xfEs3/TjhqrIk+6VjLY3VT2/G++hTncxXbfvMT9wTtwR2s9QyFzn4
	 I5m55NJbPsQDnLsOmeHZBaYoXOylFp8n1qhhUSxMOuGiBCFHwR0aEsEMEjmAKCuJ7c
	 fozHKBfSCudalA2LiKsBzMW7t2LRicR4M0b0SHxrRRJv/BsFi2SSLcjyxidJgm1jND
	 rrZsUB9nvaOpw==
Date: Tue, 3 Feb 2026 15:52:58 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Subject: Re: [PATCH] klp-build: Update demangle_name for LTO
Message-ID: <3rufoy2rjvt4apzwplyn6g6cafrz5hxh2b2ug3cmljndctauo5@bskwjecforne>
References: <20260203214006.741364-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260203214006.741364-1-song@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-1972-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: EA5E7DFDB3
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 01:40:06PM -0800, Song Liu wrote:
> With CONFIG_LTO_CLANG_THIN, __UNIQUE_ID_* can be global. Therefore, it
> is necessary to demangle global symbols.

Ouch, so LTO is changing symbol bindings :-/

If a patch causes a symbol to change from LOCAL to GLOBAL between the
original and patched builds, that will break some fundamental
assumptions in the correlation logic.

Also, notice sym->demangled_name isn't used for correlating global
symbols in correlate_symbols().  That code currently assumes all global
symbols are uniquely named (and don't change between orig and patched).
So this first fix seems incomplete.

> Also, LTO may generate symbols like:

The "also" is a clue that this should probably be two separate patches.

Also, for objtool patches, please prefix the subject with "objtool:", or
in this case, for klp-specific code, "objtool/klp:".

> __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695
>
> Remove trailing '_' together with numbers and '.' so that both numbers
> added to the end of the symbol are removed. For example, the above s
> ymbol will be demangled as
> 
> __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar

This is indeed a bug in demangle_name(), but not specific to LTO.  The
unique number is added by the __UNIQUE_ID() macro.

I guess in this case LTO is doing some kind of nested __UNIQUE_ID() to
get two "__UNIQUE_ID" strings and two numbers?  But the bug still exists
for the non-nested case.

> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/objtool/elf.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index 2c02c7b49265..b4a7ea4720e1 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -445,9 +445,6 @@ static const char *demangle_name(struct symbol *sym)
>  {
>  	char *str;
>  
> -	if (!is_local_sym(sym))
> -		return sym->name;
> -
>  	if (!is_func_sym(sym) && !is_object_sym(sym))
>  		return sym->name;
>  
> @@ -463,7 +460,13 @@ static const char *demangle_name(struct symbol *sym)
>  	for (int i = strlen(str) - 1; i >= 0; i--) {
>  		char c = str[i];
>  
> -		if (!isdigit(c) && c != '.') {
> +		/*
> +		 * With CONFIG_LTO_CLANG_THIN, the UNIQUE_ID field could
> +		 * be like:
> +		 *   __UNIQUE_ID_addressable___UNIQUE_ID_<name>_628_629
> +		 * Remove all the trailing number, '.', and '_'.
> +		 */

A comment is indeed probably warranted, though I'm thinking it should
instead go above the function, with examples of both __UNIQUE_ID and "."
symbols.

> +		if (!isdigit(c) && c != '.' && c != '_') {

Ack.

-- 
Josh

