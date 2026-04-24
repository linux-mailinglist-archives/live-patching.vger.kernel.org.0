Return-Path: <live-patching+bounces-2516-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIj2CmhW62n2LQAAu9opvQ
	(envelope-from <live-patching+bounces-2516-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 13:39:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A09145DDD9
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 13:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 830DE300F9E1
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF203BD641;
	Fri, 24 Apr 2026 11:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fWO8qu+Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OXfDWqSY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fWO8qu+Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OXfDWqSY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F93BB9F5
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 11:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777030623; cv=none; b=IC81JQ/YAoDJdSqsOMd8zABILbAW5CRZpygZxKXZceEFoc4Ue/xAltr981mUcgVA95M6OuKkksgqsnfqN++Wn5g/41pbS7J7uTrHPv3jlSb6cFoehsrICrUQKCtW6grtSTjkh2a6suvUPoK2ez9OCHkDrf4PZiUKu95xIzmorys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777030623; c=relaxed/simple;
	bh=mKHw75EJAmHUSAlvsnOUjTNqJv5/Ve2crV4dPHGQe+E=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=tDtRMEZBpKNmSYx/0ZnIpL7QhcsLvvlpUjbSDQZjebSc+yCnxeWjiYCiuPPHThNMN9H4brUaUKZYU9b8qfhzaDARBMLNPQ1SJZuLaBu0qxp9Ui6zps8OKNFXZMt6+t3nQz6tw0b0nZYepC2icn6uBnUIanOI3CovVxDu6sK6d3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fWO8qu+Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OXfDWqSY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fWO8qu+Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OXfDWqSY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out1.suse.de (Postfix) with ESMTP id 890E86A843;
	Fri, 24 Apr 2026 11:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777030620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eza5DjtBR0MnuSNj5UP/ZcMn+3Ci9BiMSU1DwHCE9MY=;
	b=fWO8qu+YkG0n3Gprpv0CrIn53IQVXZpBnlXIvNNin2cw3Ta5pDrZ773rpH4UFzS9UuNbJY
	1MDYWB6NxItMG05qB7vnf6pkW9q3DFMwNpMYAkhbhPR51atYsfDpKbulsyU+7I8rVu2OkH
	hd3F9qz4v38PR1K5cxfka1eEse5o7fk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777030620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eza5DjtBR0MnuSNj5UP/ZcMn+3Ci9BiMSU1DwHCE9MY=;
	b=OXfDWqSYjatEOXBN9Vmy9n0EYYkMnrO82PWvm67vwZpAc0vZO44vQ4f3ZNZNrGJbnywJZC
	qxnihIWLQWwqykBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fWO8qu+Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OXfDWqSY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777030620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eza5DjtBR0MnuSNj5UP/ZcMn+3Ci9BiMSU1DwHCE9MY=;
	b=fWO8qu+YkG0n3Gprpv0CrIn53IQVXZpBnlXIvNNin2cw3Ta5pDrZ773rpH4UFzS9UuNbJY
	1MDYWB6NxItMG05qB7vnf6pkW9q3DFMwNpMYAkhbhPR51atYsfDpKbulsyU+7I8rVu2OkH
	hd3F9qz4v38PR1K5cxfka1eEse5o7fk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777030620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eza5DjtBR0MnuSNj5UP/ZcMn+3Ci9BiMSU1DwHCE9MY=;
	b=OXfDWqSYjatEOXBN9Vmy9n0EYYkMnrO82PWvm67vwZpAc0vZO44vQ4f3ZNZNrGJbnywJZC
	qxnihIWLQWwqykBw==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/48] objtool: Move mark_rodata() to elf.c
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
Date: Fri, 24 Apr 2026 13:36:58 +0200
Message-Id: <177703061875.234971.10586137560816140938.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=532; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=mKHw75EJAmHUSAlvsnOUjTNqJv5/Ve2crV4dPHGQe+E=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp61XcSmi5xxkrY050uXJNGPNr/tAygl/O+Oz5N
 EnkSOFAjxyJAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCaetV3BsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyxUnggAsD6RVYwqgsIOEE2BPjd9orncKjOruaj
 2Iy5Pd9qvtCcKf6oAyd9RJOe79gKEqjVwCYZYfKQIdD9X5xs42racNBv+BVWsGGPBSso1zotFCe
 qFJJue2LfCnsHM4i9yt6vOii19nXnW9ERXpzKFaJ81bmlNDprJRvHalfnLzl/ibByZHKyqr7Yyt
 Vrl2hUUZccJBn8sv6WNtndQ4Avbt1P+55ANHdvT4fuq0Q+poNuB211Y1RKmiGpwdh3ovpBk2Qu+
 SrzdZrYkK1ixG4U3t6H0Gq65KOWs0/7gHf0mApLEWoCvza9d5CpmryOYMSkf/ijxQAfmgGej17o
 /6aWn8a9LMg==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.60
X-Spam-Level: *****************
X-Rspamd-Queue-Id: 8A09145DDD9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2516-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:33 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Move the sec->rodata marking from check.c to elf.c so it's set during
> ELF reading rather than during the check pipeline.  This makes the
> rodata flag available to all objtool users, including klp-diff which
> reads ELF files directly without running check().
> 
> Add an is_rodata_sec() helper to elf.h for consistency with
> is_text_sec() and is_string_sec().
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


