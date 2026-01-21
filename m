Return-Path: <live-patching+bounces-1916-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOmxOVtJcWn2fgAAu9opvQ
	(envelope-from <live-patching+bounces-1916-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 22:47:07 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9320A5E3F7
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 22:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A02617AA3D2
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 21:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEEC426693;
	Wed, 21 Jan 2026 21:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLATTZcZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00458425CF2;
	Wed, 21 Jan 2026 21:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029469; cv=none; b=DTHmpCX1uobQwFVKi9AgaTE7OVWX4OW0RhCinOwha7wPpRuERVerRwCVNBXIvNadQlpyFzl9P4sCWo73VLkFf3Os/7hKfbymxTc/eMXJhXn8iMrllJGgbcweXx/kQY+SWcldkJV2hel2KQhHVPbkwUaKD68bX8YPxD9/HEhDZZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029469; c=relaxed/simple;
	bh=vwU3Ze7jvFloOb/ZR8n9fLTnuD9K06QrgUL8i710Cf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTJTPrAaBYBqZkvJuIX4Tt2ELuIZOkMf6IHzhyMpId7lLWUop5Lf0JAqjgyCpMx0Lp/B+/anxVZxVRSzkBwGU3kIqlP6+e4lWJRzlgd6Mb4dCkTdeL8hZNQxeI1xsWRKDLHe6isF4p3anRx4vS2A/988Yshx9KVX76AvHg3lp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLATTZcZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C081C4CEF1;
	Wed, 21 Jan 2026 21:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769029467;
	bh=vwU3Ze7jvFloOb/ZR8n9fLTnuD9K06QrgUL8i710Cf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oLATTZcZQitd2TJ7z7e3UnWY/Zjr03Y3tvoizEbUQKre8ihzrm2rA3Lc4USzULken
	 gw/Q76PJmtCuPL2euuuSdAErqDBKG1s9JIB4fnc6B/mBCl+GBJIm6MLP6WTXc5wGZW
	 dhjiZdtd3ox/8hTrlGqFU1PnKLvERO1Y7aBIOyP0BuLSdeHCYtWNIM9uPJa/Lzq44Z
	 UFWTtIw9KjMl7tTXfBqEw5q68TQ5n3YHdb5WYs4ebETpywDvoiG+PKhsU6vRiausBD
	 tDKMIR7mZA5IWkW+xAau/vCHZYE8SqN/A3kRKz917lMiE4xe9CMModqi6bIlZisUa5
	 MSRHK9C66KNGw==
Date: Wed, 21 Jan 2026 13:04:25 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, 
	Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Fix having __klp_objects relics in
 non-livepatch modules
Message-ID: <okmrns5zlxqkwrou5rspq3zyakuv4gwwe4do7yovjbeaa5eajh@fud5amphpycu>
References: <20260121082842.3050453-1-petr.pavlu@suse.com>
 <20260121082842.3050453-2-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260121082842.3050453-2-petr.pavlu@suse.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1916-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9320A5E3F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 09:28:16AM +0100, Petr Pavlu wrote:
> +void *klp_locate_section_objs(const struct module *mod, const char *name,
> +			      size_t object_size, unsigned int *nr_objs)
> +{
> +	struct klp_modinfo *info = mod->klp_info;
> +
> +	for (int i = 1; i < info->hdr.e_shnum; i++) {
> +		Elf_Shdr *shdr = &info->sechdrs[i];
> +
> +		if (strcmp(info->secstrings + shdr->sh_name, name))
> +			continue;
> +
> +		*nr_objs = shdr->sh_size / object_size;
> +		return (void *)shdr->sh_addr;
> +	}
> +
> +	*nr_objs = 0;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(klp_locate_section_objs);

How about we make it even more generic with something like

void *klp_find_section_by_name(const struct module *mod, const char *name,
			       size_t *sec_size);

?

I think that would help the code read more clearly.

-- 
Josh

