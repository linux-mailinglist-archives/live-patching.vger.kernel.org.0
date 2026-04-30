Return-Path: <live-patching+bounces-2610-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LQlKcj78mmIwQEAu9opvQ
	(envelope-from <live-patching+bounces-2610-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 08:50:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D1949E3EB
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 08:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0D2DF30091D4
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 06:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D973B34167B;
	Thu, 30 Apr 2026 06:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yCaLZH4X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hg+NN6Oj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yCaLZH4X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hg+NN6Oj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BCE78F2B
	for <live-patching@vger.kernel.org>; Thu, 30 Apr 2026 06:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531841; cv=none; b=CimGv/a6rv0aaNAc83a7QKhyR1puccHQKAePzEQsv0ME72PYT/tydL0Ott+ateSgyZIjaPmCuKENZw3vKqGhGvlXiu+x4Bfpxr6iHCIt9AT7URY9ylzcYlh64yaqlSNXcYg/QAWsEs4/frNbGVD9tJdSzvpnpVn6TWjzG579Hd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531841; c=relaxed/simple;
	bh=Fh2sZj7GKbqrr3+5sv0jQfo8iCSlBMBRwECwi/yF2rQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=T25KRR/2dbooQIo9Q8hieCQtkWMLUmGzdPlsR7TlglDFQpY+kRB79HXMH4TQVO06noJfTsai3MBBclNB19NVkGgzaYlGDRKIx3Jmr0HypFm7Fz4keAKysM4HnG1wcqUpfwnP3CRx3tmEJBTYXSt62VpLgma8lZcGEqNhOJ7yGhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yCaLZH4X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hg+NN6Oj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yCaLZH4X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hg+NN6Oj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from unknown.suse.asia (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id D07B56A7DE;
	Thu, 30 Apr 2026 06:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777531834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGEmEemhwMFLFLzz+XM0/i/ovnHZdvOVdlRI2BuSulw=;
	b=yCaLZH4XTLvjq0F7gE0FC4u6sdj1KYiGJpc0OR1+YQJX81InP0tDL6h6IPzDLOQglVgJcn
	b8+o2Z/pIQDEltH1mXOkBRKG3ZbvP1HutPDFunH/dvv9xEj/B+f9cBynryTCfth82pH7O+
	w0M5mK+h4UG2xFkMn2ncLsA/qmdxG/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777531834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGEmEemhwMFLFLzz+XM0/i/ovnHZdvOVdlRI2BuSulw=;
	b=Hg+NN6OjFQk8f9v+GP3wyp7Rv6Mt7G1uFg8M5nEEP33MLvtw+td0f16v1E1KWh2t7xK7wf
	4kxoI6HXFAEsxpAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yCaLZH4X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Hg+NN6Oj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777531834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGEmEemhwMFLFLzz+XM0/i/ovnHZdvOVdlRI2BuSulw=;
	b=yCaLZH4XTLvjq0F7gE0FC4u6sdj1KYiGJpc0OR1+YQJX81InP0tDL6h6IPzDLOQglVgJcn
	b8+o2Z/pIQDEltH1mXOkBRKG3ZbvP1HutPDFunH/dvv9xEj/B+f9cBynryTCfth82pH7O+
	w0M5mK+h4UG2xFkMn2ncLsA/qmdxG/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777531834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGEmEemhwMFLFLzz+XM0/i/ovnHZdvOVdlRI2BuSulw=;
	b=Hg+NN6OjFQk8f9v+GP3wyp7Rv6Mt7G1uFg8M5nEEP33MLvtw+td0f16v1E1KWh2t7xK7wf
	4kxoI6HXFAEsxpAw==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 21/48] klp-build: Validate patch file existence
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <66e3edb75bf1924c650bce43835acc2053d1cf1a.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <66e3edb75bf1924c650bce43835acc2053d1cf1a.1776916871.git.jpoimboe@kernel.org>
Date: Thu, 30 Apr 2026 08:50:27 +0200
Message-Id: <177753182748.9760.3702785932988502845.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=242; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=Fh2sZj7GKbqrr3+5sv0jQfo8iCSlBMBRwECwi/yF2rQ=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsxPv3ec5mNYaq3xvbk1tubcQjbduYEdB51OZql+OzGLZ
 8E1+w1TOxn9WRgYORgsxRRZXu91ljOckmugWf3uLswgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BgxcHEKwFSLWbH/U67i3zrr+82iNTe+tv6wuf8xXfnHSf0d9uJTqi8XPsg1i2wuZLWQPC0
 8TWjLd54Arx6BuDPz8k4J+nO/cXga8Sxu3rmVdR8Ny6PKd789b5B63Yw39EzpnmNusXaKsUKmZb
 Pf/DwYvo7j84fDy49cuPtZ3ciuMED9auTxNWv37fSfsP4Rj7trleMbw31ivHw8XZ+mPPo/O6tTb
 m32poc9PizP2TnXHsnd8kl0pczJlA9d4Vy/5BUtE28yeH9Mf2miFN6bs3R9/8X6l4EPF5fPWvD7
 QfvmSPd3DXcqcyOedsyTXxbnvSGR/0JUbqDxsR112+I3n1p/09Ulv+jqspzW0h+Pq0IiVN9o852
 5XqLJCAA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.11
X-Spam-Level: *****************
X-Rspamd-Queue-Id: 96D1949E3EB
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
	TAGGED_FROM(0.00)[bounces-2610-lists,live-patching=lfdr.de];
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

On Wed, 22 Apr 2026 21:03:49 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Make sure all patch files actually exist.  Otherwise there can be
> confusing errors later.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


