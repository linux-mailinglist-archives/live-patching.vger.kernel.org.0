Return-Path: <live-patching+bounces-2130-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eAzzIxrdqWm4GgEAu9opvQ
	(envelope-from <live-patching+bounces-2130-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 20:44:26 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 099C9217B59
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 20:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F4CF30488B4
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 19:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00023E3DB3;
	Thu,  5 Mar 2026 19:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NN65Evxi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F312877DA
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 19:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739798; cv=none; b=WtlL30SMs7C4rHDWuTMv9BB6iaTsMMOiwhC+gO7T11F8/2bjFs4c+ZXHieIfMfMkYShuWR5GuEVbo8SGxGGt5Zrjcm8e1ruwUIAi+FTsBZM9kntbc1W3ug/qeBgh4TpmjdpxuQIsllTypggqQMrfIhtaIuRPrqZPP6GAInOzXIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739798; c=relaxed/simple;
	bh=qW143HAwkH2l7Iivf/aqhFq1jbZqNvHXrvu+kO+oqIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdWoEqcrzFwk4ejt1SjgXcxcKt5scSVw65J0k9y4vutikaX7bntMWh5gMGblt7RSGNQog1f9nCQerLm/RFsrIGqyS4UBZLN5EbF3KdbxRcrhHg6hMTuPEiH1hAMN8fwSmIu8KmCVZXlGJADyuw6KQa8qUP1Quk+AgXZlF5clHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NN65Evxi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31C0C19422;
	Thu,  5 Mar 2026 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772739798;
	bh=qW143HAwkH2l7Iivf/aqhFq1jbZqNvHXrvu+kO+oqIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NN65Evxiibr2VSZXZh9q/6XMnfDPBBYB7s9PVyxcwQHacBw8e9SkPVjfduN8YXD6K
	 UN21U3gQg1uVKsbm2OWwqSI9++ofZI6QPqE+xHHK/8h/lfP6RrLFZNmbMoEI4ynSYN
	 V/IBh/eEsW4AbFkw0Qah3WjOtEdM3r0WN7sKNZHpMCvGhea3wCpIccaeTCA8hMUTOb
	 XIhPZbBMJa/KPPm/wxqT1y2P09RHIXXrWRCCnfFk/T+23OHif4xw8Ua78OfFroedNz
	 814UbexqQr6uPcXTwkNVSTMlee1fIueM59SMiPG9zvDoePhNui+kKpwsQb9puLRsFR
	 2R0V8UdK3H8PA==
Date: Thu, 5 Mar 2026 11:43:16 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v3 3/8] objtool/klp: Use sym->demangled_name for
 symbol_name hash
Message-ID: <el2c3kyz3s2tzwqmfk5npyopzykzpax4clt523jysktxpxcysq@vvojeeq6vyf6>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-4-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260226005436.379303-4-song@kernel.org>
X-Rspamd-Queue-Id: 099C9217B59
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2130-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 04:54:31PM -0800, Song Liu wrote:
> +/*
> + * Returns desired length of the demangled name.
> + * If name doesn't need demangling, return strlen(name).
> + */
> +static ssize_t demangled_name_len(const char *name)
> +{
> +	ssize_t len;
> +
> +	if (!strstarts(name, "__UNIQUE_ID_") && !strchr(name, '.'))
> +		return strlen(name);
> +
> +	for (len = strlen(name) - 1; len >= 0; len--) {
> +		char c = name[len];
> +
> +		if (!isdigit(c) && c != '.' && c != '_')
> +			break;
> +	}
> +	if (len <= 0)
> +		return strlen(name);
> +	return len;
> +}

This actually returns the index of the last char rather than the length.
Should "len" be renamed to "idx" and then it can return "idx + 1"?

-- 
Josh

