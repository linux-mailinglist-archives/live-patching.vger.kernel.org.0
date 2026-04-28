Return-Path: <live-patching+bounces-2576-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMW0EsXA8GlPYQEAu9opvQ
	(envelope-from <live-patching+bounces-2576-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 16:14:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B07486B0B
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 16:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 89B3630B802A
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 12:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BEAE439005;
	Tue, 28 Apr 2026 12:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ddxhsm16";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UwvL9AW8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ddxhsm16";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UwvL9AW8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AA943D504
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380186; cv=none; b=O21A0zCwyxpu9TZZmgV4vzbph/iF986fqKk+iYpcYBF0UaaPTG6g13qyELXAMi7nhJbgWgW6Rs6WyGZ7YQGCXRI6PXb/kr3PlhXZnwPPyXDi0jVgcJgtUhuTzD9+71/emRgPbEPVrJfkEu2jzdWng/OJ1pNURgF1ItDwIHcH8pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380186; c=relaxed/simple;
	bh=YLo4HdoWAavQR85kHUyi05vt3OQUEANL8JUhswEbf3Q=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=gySPBBK5uX9AR57gnWFgCyRoEpriU5AzVs08nj3KhbTldQ7iOi+4snILA01c2m0/9hfEzfJH8fnd7U3gb2nlGOY8JBZui7SBA4Y343QZKJU5ODeM8UCOywhBSdqn2vLsh+BN0WobuwNrvm39TmfUrRvJ/1odMwNjA1hqZ9/3Go0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ddxhsm16; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UwvL9AW8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ddxhsm16; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UwvL9AW8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id 7403A6A855;
	Tue, 28 Apr 2026 12:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+2son+Tigq+kJ/g+2iRuOIPLhmqOFES90LteJEmicA=;
	b=ddxhsm163JF+nTCn0eD8G/mDuJkc4pCjBeu9M4cHA3PA8a9HTrvLdVbv2Cy2lO/Y5Bk3lo
	Z7odb9QxTG6F3w9SUeSguOJmkltSawpn2tGtRfOQFaTS37cJs1q2GxaoXWFXX2o/uXUF4B
	kMShTLi0N+Bia729QvQsr0a7GXPgb5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+2son+Tigq+kJ/g+2iRuOIPLhmqOFES90LteJEmicA=;
	b=UwvL9AW8uUBNbhsnKZf2n35VdEZ9XAPft7tO3enRSrbdKXuVofYWCRaDQM8QFC38OMaoyV
	WYW+vDK/gSyVHVBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ddxhsm16;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UwvL9AW8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+2son+Tigq+kJ/g+2iRuOIPLhmqOFES90LteJEmicA=;
	b=ddxhsm163JF+nTCn0eD8G/mDuJkc4pCjBeu9M4cHA3PA8a9HTrvLdVbv2Cy2lO/Y5Bk3lo
	Z7odb9QxTG6F3w9SUeSguOJmkltSawpn2tGtRfOQFaTS37cJs1q2GxaoXWFXX2o/uXUF4B
	kMShTLi0N+Bia729QvQsr0a7GXPgb5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+2son+Tigq+kJ/g+2iRuOIPLhmqOFES90LteJEmicA=;
	b=UwvL9AW8uUBNbhsnKZf2n35VdEZ9XAPft7tO3enRSrbdKXuVofYWCRaDQM8QFC38OMaoyV
	WYW+vDK/gSyVHVBw==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 12/48] objtool/klp: Fix cloning of zero-length section
 symbols
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <2a02cb0d5de7a60f5ef135dac071c93f6303bd82.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <2a02cb0d5de7a60f5ef135dac071c93f6303bd82.1776916871.git.jpoimboe@kernel.org>
Date: Tue, 28 Apr 2026 14:42:55 +0200
Message-Id: <177738017545.11371.11359100423490469258.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=279; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=YLo4HdoWAavQR85kHUyi05vt3OQUEANL8JUhswEbf3Q=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswPqwPfO3Mk7z9hlOwu/sT/d+7jy+quieebfE52cbKf6
 6x+oNXayejPwsDIwWAppsjyeq+znOGUXAPN6nd3YQaxMoFMkRZpYAACFga+3MS8UiMdIz1TbUM9
 QyBDx4iBi1MApvp0Gvv/pCyv9wXsF5YVNfrdXDpTx+nHu79TxH+y6DRs/M+8Y0bOqyhnkanqbx0
 vlKWaOp+u5fqfMfHmvRym/cwJlR3uTip+V21VE4MC/mddtYtNLlZw+y4beXiy2ZSSxhQWmcWl6W
 FaypUSyvMabuwxffMtuJznSvZXh9l2iqfzV4uv+Tv9YILZZv3A/fWrxHY8Ytvh5bZ8buP3ptsxc
 yaLqb6dwMw94TWbtfLEU21R5ZsXeVgefK3HlmnLcL/ifXUz28yM71seV5pzyCSutirbF3lSo+5V
 tcwV/8tpvP7MkwN3BW9/IGpxw2XxSaXMndqv/p7Y0PQ/bXebCHu45NINE15H1Oe/6nQPvCnJt8N
 K9SIA
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.17
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 40B07486B0B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2576-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:40 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Fix NULL dereference when cloning a symbol from an empty section.
> sec->data is only populated for sections with non-zero size.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


