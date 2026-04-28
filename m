Return-Path: <live-patching+bounces-2578-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNdZNIqt8GnOWwEAu9opvQ
	(envelope-from <live-patching+bounces-2578-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:52:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4014851C1
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F41830BC3C4
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 12:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A703543E4A4;
	Tue, 28 Apr 2026 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hGzPOc2Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rUu/OMyO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hGzPOc2Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rUu/OMyO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097C243D50B
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 12:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380210; cv=none; b=B8ghRLc6Riy3+5Ocl0lLMpQlyj6g2g7lHMBouX2IX1DbkovTrBdJWbuMs24oxTHJuihpo79G0h8zMRBjjzq4jvT+N0pXCnD52n1lTWo0fsNiLejfODzs0w/UxXKjjvwEHIAdENC+kfsv//080esgt2Rl1QdANMDsjctZXVki5NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380210; c=relaxed/simple;
	bh=j9zSvycfEI+cqAeqeLhj7cyloZsUH9IobGzcXD4Ol0g=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=a1gpuM2ckkJ6jKPi6nCw/OdURZgbzEKrpF/y1vFPkPv54Ltgi2v3oGW0hL7xbsFkLsYGixxCX2ZdOt1nGxJ44bzZfbYqknUFlhLntKaoraOt5T3qmyC8zVpZC/sJSY1g2ILdFnhDidXlpfcafRrkZ/n8sUwvJtDP/6YAMf63Hec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hGzPOc2Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rUu/OMyO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hGzPOc2Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rUu/OMyO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id F1E7E6A85C;
	Tue, 28 Apr 2026 12:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/AXqg09/vAHVrcNUKkgCZqB8aBJIKXygM2QhrPjIh4=;
	b=hGzPOc2YV1et2upi/9Jr+Fu6ZM7wV1yHoGnpWrB1CFAfkhUStaFWLQYTegonVcGjiVSgQh
	obdvUTlWcCh7UxbXO5qmROtua/yq/KfHYZ7O9Pg5fiqgP3gV5nq2NJjs76REYEVy9uXJQy
	hZgr/ZkHKW5YZc1MNEv6Qlyaj5AYiuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/AXqg09/vAHVrcNUKkgCZqB8aBJIKXygM2QhrPjIh4=;
	b=rUu/OMyOd9ZgUCBFYZJy0ii/RTsi+0dMX1OakF77I3gUEbtNBcxEOmbnlJblFduEH7oWKV
	Q4x0TtX+ZTKR9TBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hGzPOc2Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rUu/OMyO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/AXqg09/vAHVrcNUKkgCZqB8aBJIKXygM2QhrPjIh4=;
	b=hGzPOc2YV1et2upi/9Jr+Fu6ZM7wV1yHoGnpWrB1CFAfkhUStaFWLQYTegonVcGjiVSgQh
	obdvUTlWcCh7UxbXO5qmROtua/yq/KfHYZ7O9Pg5fiqgP3gV5nq2NJjs76REYEVy9uXJQy
	hZgr/ZkHKW5YZc1MNEv6Qlyaj5AYiuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v/AXqg09/vAHVrcNUKkgCZqB8aBJIKXygM2QhrPjIh4=;
	b=rUu/OMyOd9ZgUCBFYZJy0ii/RTsi+0dMX1OakF77I3gUEbtNBcxEOmbnlJblFduEH7oWKV
	Q4x0TtX+ZTKR9TBQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 14/48] objtool/klp: Fix extraction of text annotations
 for alternatives
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <5e67de043745aec66abf963edbd74d13c5ea142a.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <5e67de043745aec66abf963edbd74d13c5ea142a.1776916871.git.jpoimboe@kernel.org>
Date: Tue, 28 Apr 2026 14:42:55 +0200
Message-Id: <177738017546.11371.6806389605715238829.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=455; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=j9zSvycfEI+cqAeqeLhj7cyloZsUH9IobGzcXD4Ol0g=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp8KtRnpNbGiH4FXZKqCzElMtGnG047Z0jG4bOm
 jwNBD12h5iJAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafCrURsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyy+UggAspa/WZUOLOqUbHrvoXiOL0Us4enuxbr
 ph4nMepGJoY+ALC3sh16QK+U3lBm88FxSrpo+/Y+0+75JNb34no5JcUodVBTSop1upy26bEfGQQ
 nKN00/sDcKR51tf1oL836wPeLF3T4/ERY1tQV2XsirWWgnwwcoC1nC8riHbu9r6ivD3QmNWV0MD
 drbtzHLvreK+VDax9bUbyTsjAUcX9D0qdTG33/Z6+979gC/8XipWgi62XTCPNvGFX6ocXgAu9Ca
 40xylpswP9yG1dnnhdhUAsGNZB4IGJomXh/7ABKgQJntqB3s0rqOjmLRs6TePFVmZ5jZvjNcvDA
 z+AkI3pX96w==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.69
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 2F4014851C1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-2578-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:42 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Objtool is failing to extract text annotations which reference
> .altinstr_replacement instructions:
> 
>   1) Alternative replacement fake symbols are NOTYPE rather than FUNC,
>      and they don't have sym->included set, thus they aren't recognized
>      by should_keep_special_sym().
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


