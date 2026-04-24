Return-Path: <live-patching+bounces-2512-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBpmLK4262nRJwAAu9opvQ
	(envelope-from <live-patching+bounces-2512-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:23:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B7D45C201
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A1A513005989
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 09:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DF3372B24;
	Fri, 24 Apr 2026 09:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gJH/gq2D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="inicMgu2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gJH/gq2D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="inicMgu2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6106386C24
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 09:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777022634; cv=none; b=DnqQ+q3SuvnTxjJsxHf86qdmIXyTQnbgPYtN6P0pbHZyRC79KZpjX3kwoUj0knFAvcw+mTVphYlerVHL5BrGfRMyNmnfV9iu7uLBhQ/9lUWr5FXTmbRQFHHtU8w8Qqj5Maw5unZn/uXw96C15m7xzjgTOyLUwRoHskSw21Ssz6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777022634; c=relaxed/simple;
	bh=Ohp7zDwjaMaXVIX3w7ZmmTCoNy6zYuEs//RyS2wB3Rg=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=PtyLfMfUGi6rqigPeZVLechMO8CBHgD7jBYzfSxMb4+1t/x2gPpN4yyVSAUStu3CpWC4xabyC62rbPukJtDRUG4+sAK5B1GXmNgJqOt1gzwLDDlYCGGCeLL01zL1tZ4FgUBd7eWcgYT9L4DM+Sr8q55zdCdih2wn60D9L4qkK0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gJH/gq2D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=inicMgu2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gJH/gq2D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=inicMgu2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out2.suse.de (Postfix) with ESMTP id E9E7A5BD8D;
	Fri, 24 Apr 2026 09:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777022631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldaP/mGpn57f6VyMkjdHrZh2IV3IZs1LCANhZjK5Mf8=;
	b=gJH/gq2DOSJQIRC+NkugkIah34B2XkDZ+j04bO5sHQH6C4+Flkx81P/6GQk9Tj5WoN6Y9O
	DBddwGaQRZRZdkaW9Dy+cjsWk7u/+WLvdNh6QJmw507XoKho+ZqS4t2XolL/kdxFlQHK2Z
	X2bai9wV7870yltK98jrli8k8po1W2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777022631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldaP/mGpn57f6VyMkjdHrZh2IV3IZs1LCANhZjK5Mf8=;
	b=inicMgu2/v7Y+UMcfpE3X5iIZYqhgUvniVnviceS5hCUhLyzshsmHLIOYYIzV0ASQSz4/g
	bUkK3iHImY8N7+Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="gJH/gq2D";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=inicMgu2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777022631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldaP/mGpn57f6VyMkjdHrZh2IV3IZs1LCANhZjK5Mf8=;
	b=gJH/gq2DOSJQIRC+NkugkIah34B2XkDZ+j04bO5sHQH6C4+Flkx81P/6GQk9Tj5WoN6Y9O
	DBddwGaQRZRZdkaW9Dy+cjsWk7u/+WLvdNh6QJmw507XoKho+ZqS4t2XolL/kdxFlQHK2Z
	X2bai9wV7870yltK98jrli8k8po1W2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777022631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldaP/mGpn57f6VyMkjdHrZh2IV3IZs1LCANhZjK5Mf8=;
	b=inicMgu2/v7Y+UMcfpE3X5iIZYqhgUvniVnviceS5hCUhLyzshsmHLIOYYIzV0ASQSz4/g
	bUkK3iHImY8N7+Bw==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/48] objtool/klp: Don't correlate __ADDRESSABLE()
 symbols
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <ea9af1b6136e9aa11589e592d0fc59e4ef414579.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <ea9af1b6136e9aa11589e592d0fc59e4ef414579.1776916871.git.jpoimboe@kernel.org>
Date: Fri, 24 Apr 2026 11:23:48 +0200
Message-Id: <177702262868.199199.17632749620515020845.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=270; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=Ohp7zDwjaMaXVIX3w7ZmmTCoNy6zYuEs//RyS2wB3Rg=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhszXZsvC+gzv/Nq0QLr58/dQw99hcyTjVjtdKjx9KD9lk
 cgH+UnfOhn9WRgYORgsxRRZXu91ljOckmugWf3uLswgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BgxcHEKwFTfeM/+h1vq88JfRyex3Fq2cdf+5lsGvvwTldfEXXs5QTCT85v7L5GrmnVxUg9
 bVs06wOy3MtzZRrXu1NEgnR1m3r36zjpO6/41ORsv9DedvX/rtVgpA0/uL7+6dLIdvwr9L9m9jm
 fNxuB9E0PzJxlMMn8y+c+pa7vnd3MlP15l3iv0rOjcVYuHpvz7TPPd4thvldU+OC5ybXN5JP9Up
 53nbFqEGnSW+gdm3naST9ip7OxZ4fPkzknbQkfvfa+vLEm+niR4OVA032zdibRNGz3exdvH3XGb
 8j5jikpCZCq3wAQT6VAnAyZ23Y3r1Yonm58UPlQUazFv/o4/a3XrgxLarfI/aa1oSJwccPx+9IS
 r6x5dAgA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 18.20
X-Spam-Level: ******************
X-Rspamd-Queue-Id: 59B7D45C201
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
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
	TAGGED_FROM(0.00)[bounces-2512-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Wed, 22 Apr 2026 21:03:31 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Symbols created by __ADDRESSABLE() are only used to convince the
> toolchain not to optimize out the referenced symbol.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


