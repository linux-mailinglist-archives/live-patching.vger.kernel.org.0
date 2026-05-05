Return-Path: <live-patching+bounces-2713-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDxWC33Y+WmbEgMAu9opvQ
	(envelope-from <live-patching+bounces-2713-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:46:05 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DE04CCE54
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D716430F64AD
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A619406283;
	Tue,  5 May 2026 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PHq3CVhU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Wtob/eX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PHq3CVhU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Wtob/eX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF9387367
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980418; cv=none; b=hjIg7o70rE7r+9tdkq19BMrG1VvcPyLHZ/B8sUsQFEVyEX/E4SIhNbUfrzk436i32zgL6Ju+XXigPISYo1iByq0uneGTp+E8x/LZiQdZnW8uC25QwwxZDD6ZYWIvffy9hvMz3xypcgfqWw6EI8amgcJXMEhcjBmnhWqKcdixsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980418; c=relaxed/simple;
	bh=YOD1kRWGa79JovfiCNYIqOoirWA3LdZZrGDAYUfMFTw=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=MZXjcPMGvwByC7L+JnJHlvzQR7RNwUDsDH82lCa8wKzZ4/hU7zh1q1u3sNWfPXKujgkAXd4YfLPer4A+z8pmT5FugTLZ/mEb5DYAsB6NfOUg/omfsdrndDTymSq6Rj3u870cvQMsjP1DEV8npHWzMXrgZYhvb+VsxWzOUCRZaGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PHq3CVhU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Wtob/eX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PHq3CVhU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Wtob/eX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 240C35CB75;
	Tue,  5 May 2026 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFMlzel4NC5hjgfoy3b0qOi8USUThFRJffPLHE2imLk=;
	b=PHq3CVhUibD/BkOMxTv6wrZ5Q+ZIsGZxQKJGFNAMYjmwRxQDLO5ovEIx7EMZz89wSpAN89
	lfTInA8zESZlvR7ZGMRQM8KhzosmsMCDYgUju38Qg7oxCD38mBG+CeCzpn9ACTodqjnBvy
	hRpADIi3dsK6o+TYybPlYBd+T+69gFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFMlzel4NC5hjgfoy3b0qOi8USUThFRJffPLHE2imLk=;
	b=1Wtob/eXSvwDneSKqczTQ6RD7b+GA4na34E/d8uOBzByOStImKvo01D+0Aq2SJuB7vDF0I
	PDU60RaLTLTX6yAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PHq3CVhU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="1Wtob/eX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFMlzel4NC5hjgfoy3b0qOi8USUThFRJffPLHE2imLk=;
	b=PHq3CVhUibD/BkOMxTv6wrZ5Q+ZIsGZxQKJGFNAMYjmwRxQDLO5ovEIx7EMZz89wSpAN89
	lfTInA8zESZlvR7ZGMRQM8KhzosmsMCDYgUju38Qg7oxCD38mBG+CeCzpn9ACTodqjnBvy
	hRpADIi3dsK6o+TYybPlYBd+T+69gFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFMlzel4NC5hjgfoy3b0qOi8USUThFRJffPLHE2imLk=;
	b=1Wtob/eXSvwDneSKqczTQ6RD7b+GA4na34E/d8uOBzByOStImKvo01D+0Aq2SJuB7vDF0I
	PDU60RaLTLTX6yAw==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 38/53] objtool: Add is_cold_func() helper
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <a84513224f38c7c7ca2cf2a4930f87d43a76908b.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <a84513224f38c7c7ca2cf2a4930f87d43a76908b.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:26:30 +0200
Message-Id: <177798039059.9921.13891493188550666521.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=212; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=YOD1kRWGa79JovfiCNYIqOoirWA3LdZZrGDAYUfMFTw=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfl9/MtW4q8Gp1a9xo+ac399b0c1eDc4MFD31fIX66j
 GWxaEp5J6M/CwMjB4OlmCLL673OcoZTcg00q9/dhRnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DIEMHSMGLk4BmOpP79j/aebM3fRh/uvLZtHBz59/Ef38SzTs4PmZ5udtjbdfVD7/SnvHFP8pkaJ
 iTxK5jWNqUl1DOxTuRPw/oXGWq/eOW6TZ6ufHGDbWNho03M5JycwLun+U5V/rtN2z11ZwzWnJOm
 O0xvTu1tQfFv+42Otd4jOa/t+17M7TWqqvvdTuw7EvUx53/Hu2wPxTwnuej8+9GzT9+rOyKzLVX
 0iefv7A9f95ne5splsSST4iyi9yqtROb/OMuyvzQi3wrmq3vMBkt4xcHcbrAbmvA3Ts8xt0ZNXP
 dDxoUZ3eZzJbz/9yv7i6oew0x0M+XadCFn9NVNh+eo10pRbz97V2f//lmYhXeNilHPysfFgzarZ
 WpQ0A
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++++
X-Spam-Score: 19.10
X-Spam-Level: *******************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 97DE04CCE54
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
	TAGGED_FROM(0.00)[bounces-2713-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:26 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Add an is_cold_func() helper.  No functional changes intended.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


