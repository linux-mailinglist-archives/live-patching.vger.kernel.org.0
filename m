Return-Path: <live-patching+bounces-2728-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNDQCrzd+WlPEwMAu9opvQ
	(envelope-from <live-patching+bounces-2728-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 14:08:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 803E04CD3A8
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 14:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 85CF2300D9EC
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 12:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDACB3914F5;
	Tue,  5 May 2026 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wQsQVwPI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CJla0rhp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rDNkvswN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qp+vS2Uk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8F1413249
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 12:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777982874; cv=none; b=WgLTSkCqVSloOglAXDOVqIZLdmoEvgOlUOZGOmzWSqKJ75M4mVr+pXMhtuHnLVLuLxdkW3RQHEZfj4xRprhsYrHeLGPVHK7VDv4KnvLaL5PGkFi9Uq2AiAVz39ygvw/noDKg9EXnHYBPTCDsVG+Ugq4Lo+3hWB+fnBfEMUWoyDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777982874; c=relaxed/simple;
	bh=F1ug9jEifChAUxXeEULQktN9BsXhcXYTGuYphjIAnqA=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=PbnvZpXA83QOsF9xlR3/7WQIpbQNVoq2gXc/+IgWJ4rYDqQEycGOKToDYkEhNh59t1R6d6yGPU7yLqYeF4ogB0IjwlcXmIQ4TGIpTeusyASZ81JoLQ5q8UeJ6phHKeHJLEAw3ty3QqwPbjWRyAYkFlNe9C3a+I22no58d4wKKD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wQsQVwPI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CJla0rhp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rDNkvswN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qp+vS2Uk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 96DD25C607;
	Tue,  5 May 2026 12:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777982871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkCzrrS15NhtrWApxPAQZbGq3DsJZPG8gIX++20Wn5U=;
	b=wQsQVwPIN7XApURZN0eoGxPMNV8LeYhbmcMih+BpRlM2N430r5IGdu2uiTRsQZAc86f2hU
	f15a2jfe6ckSguBdUj0IjNRD0shDjEMx/ER3BLlah7lAG1tw9uZv9W84gTl4Ap/CzCFCTg
	sxMFYnSoDcTrXEWZFyJjrheswaB3ceU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777982871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkCzrrS15NhtrWApxPAQZbGq3DsJZPG8gIX++20Wn5U=;
	b=CJla0rhpD7OErM1XQyMF/NCF/RkP6jDpRwE9zNT0w28p6g8kEIzaSN79h1LKByw2jYDIB8
	Y/qx25wGFXIPs2BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rDNkvswN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp+vS2Uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777982870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkCzrrS15NhtrWApxPAQZbGq3DsJZPG8gIX++20Wn5U=;
	b=rDNkvswNnhqTa3XGJZYzlmnpyzfwyTekK0BWsEzKZsorm1c7QN7OuYwuBGu/ZYQB3FDOYQ
	peoP60ScqvhKlht0Rk89xOxFGZRvDeJwZ9rwv2IZSQYO3d71GDFBVMbT79+B4ieBjOMWlf
	XfYZbtkAtAU3YeMGpfj2wf3C63O4p3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777982870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkCzrrS15NhtrWApxPAQZbGq3DsJZPG8gIX++20Wn5U=;
	b=qp+vS2Uk8WMjHg4HM3MO1j2stMwh4OLzeYjVETnCZQeBA7ntkGF+VUTAWJIH1C/DX1bQPO
	vpWiHM62Nu6GnhDg==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 45/53] objtool/klp: Calculate object checksums
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <88ebcc903a3c534f2c7d35b95f62d845105d40af.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <88ebcc903a3c534f2c7d35b95f62d845105d40af.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 14:07:49 +0200
Message-Id: <177798286937.9921.7200092304113350371.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=240; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=F1ug9jEifChAUxXeEULQktN9BsXhcXYTGuYphjIAnqA=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfd6f9NaqOZzs8TzrPesfhA7YXDn6TmtTwX3jaZn3te
 I37CnsPdDL6sTAwcjBYiimyvN7rLGc4JddAs/rdXZhBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKm+dpj9q6yB1AHF/S5fdFg2dPfbLXLqz8pf7KuSoxAw4YCBoIrbFRbx2U+s1oU
 eePrDi3ntyW3vU885//Mx2qjkofX0xIkbNTUdJpfZzMIDdnD+3rtKdQcf4ybOWQ1n5ma6n83d2p
 NtyHf6ubLbH4Z4qXvfrTZOa4u+/USxd9rLH1WNlZ/Kvmw8xdcUcLQtP03ygPYmzbNvnLjdrV5WX
 d0oyfb8aYtP10Zl48p1ne9fbbk2X2TPrN03QiaUxxr0yifFrKgziKz0NLxqGbLzzvc6E8U7/bWL
 H3z4Hj6b4dBjrdv6D/R9VQV+iYpKRy6bkPn8mMWOek3p513pvIu2rzu3+hz3pQWKc7ds0lyxM+1
 EmSsPAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 803E04CD3A8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
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
	TAGGED_FROM(0.00)[bounces-2728-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:08:33 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Start checksumming data objects in preparation for revamping the
> correlation algorithm.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


