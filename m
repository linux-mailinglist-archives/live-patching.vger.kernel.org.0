Return-Path: <live-patching+bounces-2575-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aI3qC6Cx8GkfXQEAu9opvQ
	(envelope-from <live-patching+bounces-2575-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 15:09:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3792A4858F0
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 15:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6DB183076B82
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 12:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D3B40243E;
	Tue, 28 Apr 2026 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O7gedYO1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lVGwoNX3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O7gedYO1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lVGwoNX3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E79402451
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 12:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777378372; cv=none; b=b772eKbjJxKkf7H/Jq+mv7bVUV3p3C5eqkUuiIUKRls0H4JuB1J5SezhvJpZN8/IwEQaOCkvvtuCMf2qZQ5x0QJ7yCfPxyZsrbpzvsLGe7GLzZNTJgkW8TQ2SvJrieRk4RcEhR7gSbWr1rgio/SBFhLTadpGV1vU8cdXRRrlGpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777378372; c=relaxed/simple;
	bh=SvvjyxN4h/mnVkrLCKw5rrXcqpwvssAioiPn0QU8Muo=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=sOV9h1Rr3f/8KEJ8jImgpzI99UPvcA8sgL+MVSk1imwFdfJpJyJ95xr2Zy7KK8fayvda8EYuR3qly6stejhUe8cXd8tsin2PoZva6Bmwf+iXJ/NsFI7/DvNZLsKmyqe5PnlmKRpeXN8Q64k1p7OjzfbtpwjYQ0dWZZFYZ6FPm48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O7gedYO1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lVGwoNX3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O7gedYO1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lVGwoNX3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 3BACC5BD47;
	Tue, 28 Apr 2026 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777378360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPYIs7h+GtsN8p1mPQujvbaG/qEgEobiWK6PXdZ7bjM=;
	b=O7gedYO1IXRQh7wjBB4a/P8hLqdJgOAmUHfY57sSBCyBZP1/0HsF41dWocXZ/9UnSjktHs
	T1q6qeUlZ41ZPh0YssRyRk+OChD0T47UL+KnDmbNxGwnnW4m7vP3wheG/xhQhi1hb0A8uh
	oH6rSgFYh/bhjvMSLTpeB7RJH1qYcm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777378360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPYIs7h+GtsN8p1mPQujvbaG/qEgEobiWK6PXdZ7bjM=;
	b=lVGwoNX3REYPpXozRZ9X6Ki+z/PrjVqskDwmQ26vGCczBTspX2pu+qVvf3nXF+r2ASJtpG
	ITN0MH7XUVI2XsCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O7gedYO1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lVGwoNX3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777378360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPYIs7h+GtsN8p1mPQujvbaG/qEgEobiWK6PXdZ7bjM=;
	b=O7gedYO1IXRQh7wjBB4a/P8hLqdJgOAmUHfY57sSBCyBZP1/0HsF41dWocXZ/9UnSjktHs
	T1q6qeUlZ41ZPh0YssRyRk+OChD0T47UL+KnDmbNxGwnnW4m7vP3wheG/xhQhi1hb0A8uh
	oH6rSgFYh/bhjvMSLTpeB7RJH1qYcm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777378360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPYIs7h+GtsN8p1mPQujvbaG/qEgEobiWK6PXdZ7bjM=;
	b=lVGwoNX3REYPpXozRZ9X6Ki+z/PrjVqskDwmQ26vGCczBTspX2pu+qVvf3nXF+r2ASJtpG
	ITN0MH7XUVI2XsCQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 11/48] objtool/klp: Fix handling of zero-length
 .altinstr_replacement sections
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <99099e77dffb352f97c5276298ab344c186a3ee2.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <99099e77dffb352f97c5276298ab344c186a3ee2.1776916871.git.jpoimboe@kernel.org>
Date: Tue, 28 Apr 2026 14:12:33 +0200
Message-Id: <177737835357.11371.10822107396048907769.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=333; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=SvvjyxN4h/mnVkrLCKw5rrXcqpwvssAioiPn0QU8Muo=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswPS8xvh/dKTk1zM00pmL9/5eED12wiFq7jldx2NtVp5
 +cOt2jTTkZ/FgZGDgZLMUWW13ud5Qyn5BpoVr+7CzOIlQlkirRIAwMQsDDw5SbmlRrpGOmZahvq
 GQIZOkYMXJwCMNUbCtj/h6x1n5b3577SzP8fEk4vbAvxmbWGOVs4z83hXvjBXkXviylOr6cINDU
 G7d4d0nH6eWVMyZ4DvlPyVh/YVWDXW7VQtW3dQe98sZ7Vi9Yoy0Rk7rvz6ecBP42FGga72p1Py3
 iutq5W4FD6ZPuGR35aS/vNw3y7Z54MN405ZPDX+JqI2KqUdY3TL9/eUeCZucsi59gn/Q1vt9+29
 K/1TnJOLEvMeOIctf/Sy93LxLQCxYQ+MhYbuWSKqnTVLema7/Ixn2OChdWVOYeuxkbPkI24X23F
 OyGVRWdqi3bKCSP+aA31mAUa6co51ywivtz/la8osT0xef68haH1bq0GkYz9JjyFR3briUW49Ud
 ncgMA
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 3792A4858F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
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
	TAGGED_FROM(0.00)[bounces-2575-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:39 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> When a section is empty (e.g. only zero-length alternative
> replacements), there are no symbols to convert a section symbol
> reference to.  Skip the reloc instead of erroring out.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


