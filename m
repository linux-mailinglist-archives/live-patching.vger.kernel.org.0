Return-Path: <live-patching+bounces-2075-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLTUOBDbnGkrLwQAu9opvQ
	(envelope-from <live-patching+bounces-2075-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 23:56:16 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F60917EA08
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 23:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1A6BC3012831
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E95D37BE98;
	Mon, 23 Feb 2026 22:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwpQAq4D"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99A3033CB
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 22:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887370; cv=none; b=FBaMQoFBeRuB3cD6ffl6uk+CRNSteIpwU5GcAsH2I/ZAmSJ9SLuSqPWTzwMhNqcpZ/Xq2TxSN2kkvNF9yiYGWxFQBj7jT1y/nbd2jup0TyIDuVEIYD1SRwG/M41aReRWhw6HGd/k/ZH32ZbvRQI79nQzOQgB+MNV9UPAbChi9PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887370; c=relaxed/simple;
	bh=DYb0mayjH/REdHGJ+vr8Si+QV4GjkCcA4D81Z0EFWPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7c+A06KCRllz5B8NbhbHLljXo3RBIs9AJ/0ySAHavlsLlyBJvWqM46/7lvl45Bpy15K/9VNYsO7QtEjadxPlEkvYS3UK2uzOoK7+IOMgSWpx5tqku3AZDfB7Ce5x7cw9bRkV0vbb4KhX5UJfOFJgbvTOGwyw9E/dBO/1iILSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwpQAq4D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D77AC116C6;
	Mon, 23 Feb 2026 22:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771887369;
	bh=DYb0mayjH/REdHGJ+vr8Si+QV4GjkCcA4D81Z0EFWPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hwpQAq4DH3LvEGYf2yC1ZaI40jnjifS2c/sDyw4Q6xm0hcQc6myOpPrAleIURdjrq
	 7jFarztYTQ7MNhKXjmx8xm+BgR5T3hPFSvTOnt08McDIvjRHIh84sQ6bpHVjvZySdL
	 oGUTfdqwgGwJscQgIG6rYylviOfiaFR4pQj/Hd7krANt29GiPBRCbAgMHzoJohZzfh
	 mbeSpuKfGZwKSmXTRiR51IctCqSCmT/ZWxGYl0AuuCSIRk34NXq3INF79SntAYy7TL
	 wfJEvhWfq863/R8ydGxG8Y1HRVCfhwmVSSOjaf60gP6G78S7STLDahojW6YC/0ga0U
	 BzufaWkLb7ASQ==
Date: Mon, 23 Feb 2026 14:56:07 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v2 6/8] objtool/klp: Match symbols based on
 demangled_name for global variables
Message-ID: <neszhyiktzw4uo4lc556jdfie2xu3dop5j4u7zo4fziqwn75an@6ui4e5fuyv5j>
References: <20260219222239.3650400-1-song@kernel.org>
 <20260219222239.3650400-7-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260219222239.3650400-7-song@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2075-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0F60917EA08
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 02:22:37PM -0800, Song Liu wrote:
> correlate_symbols will always try to match full name first. If there is no
> match, try match only demangled_name.

In commit logs, please add "()" to function names, like
correlate_symbols().

> +++ b/tools/objtool/elf.c
> @@ -323,6 +323,19 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
>  	return NULL;
>  }
>  
> +void iterate_global_symbol_by_demangled_name(const struct elf *elf,
> +					     const char *demangled_name,
> +					     void (*process)(struct symbol *sym, void *data),
> +					     void *data)
> +{
> +	struct symbol *sym;
> +
> +	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
> +		if (!strcmp(sym->demangled_name, demangled_name) && !is_local_sym(sym))
> +			process(sym, data);
> +	}
> +}
> +

I think a saner interface would be something like:

struct symbol *find_global_demangled_symbol(const struct elf *elf, const char *demangled_name)
{
	struct symbol *ret = NULL;

	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
		if (!is_local_sym(sym) && !strcmp(sym->demangled_name, demangled_name)) {
			if (ret)
				return ERR_PTR(-EEXIST);
			ret = sym;
		}
	}

	return ret;
}

> @@ -453,8 +493,27 @@ static int correlate_symbols(struct elfs *e)
>  			continue;
>  
>  		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
> +		if (sym2 && !sym2->twin) {
> +			sym1->twin = sym2;
> +			sym2->twin = sym1;
> +		}
> +	}
> +
> +	/*
> +	 * Correlate globals with demangled_name.
> +	 * A separate loop is needed because we want to finish all the
> +	 * full name correlations first.
> +	 */
> +	for_each_sym(e->orig, sym1) {
> +		if (sym1->bind == STB_LOCAL || sym1->twin)
> +			continue;
> +
> +		if (find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
> +			return -1;
>  
>  		if (sym2 && !sym2->twin) {
> +			WARN("correlate %s (original) to %s (patched)",
> +			     sym1->name, sym2->name);

Since there's not actually any ambiguity at this point, do we actually
need a warning?

-- 
Josh

