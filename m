Return-Path: <live-patching+bounces-1985-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKkmBqp4g2nyngMAu9opvQ
	(envelope-from <live-patching+bounces-1985-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 17:49:46 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E448EA887
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 17:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B6FA83006D42
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 16:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7A433A6FF;
	Wed,  4 Feb 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGBTwx72"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A45A33A6E8
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770223664; cv=none; b=EXvRkoCh2lRURELIrqpvFpAr7wz0488J5ERmVC291KPqoZD1GiCOxswhmtiLku3C0CYyAs0l7lZOdR86ms9cj44dV9d1Ery4W5GEqNdXCln3apZlTZoUpcbK2DVyODd6YnhVsEg3HPGiAW1BAeH6tfTf0Uy34ZsMwHsHw6vWa/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770223664; c=relaxed/simple;
	bh=U8fJeTY7zq6xsRqcxuhw5O9Gotsl97NHid1ML5gI2Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KD0TpihATQNLKrw8UhQ1Unm9Oh0D6bzzXcWGSHz7dY213QG/+Fa/5RyME30luSRv4VeAAeQlr5Ghfn8R0PCsP6VsclYH6WSq3o/OKgp1LkabIwhonCj0yWaV9AZir9ssswLQmoxxhiYMgAZd7czCXl7nuXKxA5jCxVjrF6qBHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGBTwx72; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65459C4CEF7;
	Wed,  4 Feb 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770223664;
	bh=U8fJeTY7zq6xsRqcxuhw5O9Gotsl97NHid1ML5gI2Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGBTwx72xxAZXsYslAQG6H2xawUythhR3aUm403vahsZDcF0UJBHXlHVfnVbekxCq
	 obLour9fh3LNjJl3Y/YhqmRKN9gw14l+2cElRSyG0Npg4psyiA11S0YRe5FQhcOVui
	 lreqS9tsDMrFMmJNGFPYRJuWRXNLtt0U5zrvRfNZOpM+pmvBikpPHNQnzKLfVOJD9/
	 Z6DIu/pWco102NjQKwt1PIYsdJ/QBnSTy8HtnIu33XGs/zRVfQBZncBYDC8KJu3t3T
	 9AmHDmU97lF9ysgr2dxkB8TdEZ8ZVUPFsIJ5Zv8Y0gVpd5+OiRnDfR/7d8DVImykDK
	 8zgNlntuh6lGw==
Date: Wed, 4 Feb 2026 08:47:41 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 1/5] objtool/klp: Fix mkstemp() failure with long paths
Message-ID: <jwj6k6bbvga3uaaj2hhtau256t7mvcg65wsv5cpsdrx7cpt4zd@knbng27js6t5>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-2-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260204025140.2023382-2-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1985-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2E448EA887
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 09:51:36PM -0500, Joe Lawrence wrote:
> @@ -1219,13 +1221,17 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
>  
>  	base = basename(base);
>  
> -	tmp_name = malloc(256);
> +	tmp_name = malloc(PATH_MAX);

The allocation size can be more precise with something like

	tmp_name = malloc(strlen(name) + 8);

Also, I'm scratching my head at the existing code and wondering why we
are splitting out the dirname() and the basename() just to paste them
back together again??  Can you simplify that while you're at it?

>  	if (!tmp_name) {
>  		ERROR_GLIBC("malloc");
>  		return NULL;
>  	}
>  
> -	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
> +	path_len = snprintf(tmp_name, PATH_MAX, "%s/%s.XXXXXX", dir, base);
> +	if (path_len >= PATH_MAX) {
> +		ERROR_GLIBC("snprintf");
> +		return NULL;
> +	}

Checking for all the snprintf() cases can be a pain so we have a
snprintf_check() for a streamlined error checking experience.

-- 
Josh

