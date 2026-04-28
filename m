Return-Path: <live-patching+bounces-2579-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NdaLKGt8GnOWwEAu9opvQ
	(envelope-from <live-patching+bounces-2579-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:52:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4B64851C9
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AC8D3117DA9
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 12:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F0643CEC3;
	Tue, 28 Apr 2026 12:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GROYRHIu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YdjzmAaL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jOXQKI//";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DIe39zJ1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D7442882D
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 12:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380228; cv=none; b=rKeGt28JqRPYCqMCHURvt84nwFjPFGIp6QChHa39xKK+sMwH5oOoolbexkcO47vpHhliZXy1ocTsB6uxft6Cj9+ve6wsOb7/BT1RrRJydbTZ0mmBKX5CUX8Jgk05u0vHa9gdMQF/FTy3uRM6Fbg4fbd7pkA//HUUa/Wr5Ydd4lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380228; c=relaxed/simple;
	bh=0cdlsUdYlzIGzifRJTeDg47PJApbqlfi7C8okV5eOl0=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=hjmAI6qhQvt+maeJtQeFeE79Uz6cgXa/f3qzFwd9z08yJTDvR+AYh+SEWR0ivMkxmvHJTKb9ejtv56w6YIHdzrk2xnA5Y60LEGUsfjz6OUvweFIV34mnNRzLtRtDgcVM+n6ehmbeuAOooSZ5uBsqhHKe3j/S5/Wz1UbTtqofsbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GROYRHIu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YdjzmAaL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jOXQKI//; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DIe39zJ1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id 27C876A865;
	Tue, 28 Apr 2026 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbrMd+GiDxh5oya+5LhguNgN2Q/6PV1js3j8HI9Udz8=;
	b=GROYRHIuWILNbCLY+I1Y6DQ7mFuLsOwSgNKhk670E5ndxuBwojZ/CpUYlTJVS7Wcf7eeYZ
	tCzDwcIad0gvaI86JMQV8KSmcQwZTdpZI5QAsXOca7XrRgivFV+GufLenAzJ8iXAJINwDQ
	F6WJfwDWeim5KUD0NXwykx6ta7BDF+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbrMd+GiDxh5oya+5LhguNgN2Q/6PV1js3j8HI9Udz8=;
	b=YdjzmAaLbR78qYM1zliKMerBDZXWfcK0fiwGzrbuvFhJXmmYsMYnLLZsQSHkSyLjfpSh4E
	oKNMskkmGS1G8rDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jOXQKI//";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DIe39zJ1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbrMd+GiDxh5oya+5LhguNgN2Q/6PV1js3j8HI9Udz8=;
	b=jOXQKI//kOZMOTEgQsURWdK7QiWvE+5azcU7VW4d+UAEbcHpifiBK5rxvT+k6zw4jEgSzu
	x1yilpc00Zd6rWcIwANB4qXF8KeXwAjCJvbPhRH1qq7lxCx+bW8EtWNSFGqBEPWkAQOqtu
	3qTgnYpj/8oouFHYL+XboZoOFlMC84s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbrMd+GiDxh5oya+5LhguNgN2Q/6PV1js3j8HI9Udz8=;
	b=DIe39zJ1UnBWSWS7X215X/4j1Vm5T4uKCk7+4aGSVcqt7osq131kVwZK8pJEJ+Y+Oi6cjO
	qFKiJ5Eayt1HEHBQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 15/48] objtool/klp: Fix kCFI trap handling
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <2022e064d670290bfc4ce96207c64b2282d39959.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <2022e064d670290bfc4ce96207c64b2282d39959.1776916871.git.jpoimboe@kernel.org>
Date: Tue, 28 Apr 2026 14:42:55 +0200
Message-Id: <177738017547.11371.16718846653085454245.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=467; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=0cdlsUdYlzIGzifRJTeDg47PJApbqlfi7C8okV5eOl0=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp8KtRDo4nJkIsIw9w6sDdWO3NR4MgjJ/u5I4vp
 DNu5J1vgn6JAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafCrURsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyyfYwf/bj6IASho5I/8yHiPKEBWZAxRzxS3df+
 i8e6/0Nhnp3MCGMPoj16WAUPW1XubkwbeiLcCfwbC8nzYnzEUmfJdB7fXV4gJn9vetaPG6fWdNe
 knMpYBpQ/O5dJSO2wBwxAhRlxoK49Z0ksUnO3xVPRC/SanxP4FaCFnJPdeBhmluktyWVEQYv9+O
 HNW+BpkiJyZTLtEok7PBe5bSfAH94qHX+K7rdKzGcSJn+15dhyVVF0Z3ilPQqL1moCttbTv+pT2
 d+Gu2XVLHte4lf/Tqej8IbjN34CVs0/10hG1rtn9QfLuouQggMu7Tvvd4b4/Rf6lJwpH+ZfvTyv
 zJiNsdf+ESA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.13
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 2B4B64851C9
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
	TAGGED_FROM(0.00)[bounces-2579-lists,live-patching=lfdr.de];
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

On Wed, 22 Apr 2026 21:03:43 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> .kcfi_traps contains references to kCFI trap instruction locations.
> When a KCFI type check fails at an indirect call, the trap handler looks
> up the faulting address in this section.
> 
> Add it to the special sections list so the entries get extracted for the
> changed functions they reference.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


