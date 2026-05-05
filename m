Return-Path: <live-patching+bounces-2716-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEaAC0rV+WlsEgMAu9opvQ
	(envelope-from <live-patching+bounces-2716-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:32:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0EA34CCB20
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3C93030144E8
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EBB39022E;
	Tue,  5 May 2026 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="waBcIWNN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H8Ege6DZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="waBcIWNN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H8Ege6DZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3811038F928
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980724; cv=none; b=sgpJlv4yG9Vbv8hRQq8fmTS6F863xX7qFbb3Mpi//2JFoYi/sapju2PHnZMqZIUbON0AAEQ/Q9aCqGFb5KFloKFhc05cxGPAXrcusTguVrIDvTl7Nw9Bi852s0KmAw8x/t0RLXWi2lv+mszJ/OzoKQXF891YeS5Tou2VUVJ4jMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980724; c=relaxed/simple;
	bh=FOtbR+eQ8HvE68pf8pIzEfjG6PAbJLPLHqWf6TCnPes=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=u0w3x5h/Vwz528KJBu7VnWCsEkdfnMyrHAd8M5IHGWGfVpAgDvFG93HR6yvutL1wv+adh5Yj4xtTPFZ+STME7t8pcwFKQTy4+bALoIKlCVctO7Hlm5NIGJ/nNVsQALzTqjv2VO19eKpxR1rzTMZ65OV+RC2Hu3TBN+CqY07nfsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=waBcIWNN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H8Ege6DZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=waBcIWNN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H8Ege6DZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 634A55BFC4;
	Tue,  5 May 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0hBDra5UzQmGLrZVJb4Uee8gjzoDHw1bPTMeAgr6+w=;
	b=waBcIWNNK+Uv2f2kWSToJI4/zdS2Wf61nJYrneYD7iopY2OnLv3vbUoho0ljqTo4BYYsdF
	LNFLLCqhUHEmpcAl3TNV/E++4YhB4UxaJxFK8q2NtSeXhgVp+veXCwpz2o5YCBiKwsqeZ+
	1hKvX+TjFT4dUZtgHy9BcL6M9YcUbzA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0hBDra5UzQmGLrZVJb4Uee8gjzoDHw1bPTMeAgr6+w=;
	b=H8Ege6DZQX3G9yxRHS5UxCCkFtXPZkU5j7tgWVxLvN8nt5UuHOwnjCH0ciaw2RnEM7qz2f
	29tLEVN/7HOInVBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=waBcIWNN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H8Ege6DZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0hBDra5UzQmGLrZVJb4Uee8gjzoDHw1bPTMeAgr6+w=;
	b=waBcIWNNK+Uv2f2kWSToJI4/zdS2Wf61nJYrneYD7iopY2OnLv3vbUoho0ljqTo4BYYsdF
	LNFLLCqhUHEmpcAl3TNV/E++4YhB4UxaJxFK8q2NtSeXhgVp+veXCwpz2o5YCBiKwsqeZ+
	1hKvX+TjFT4dUZtgHy9BcL6M9YcUbzA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0hBDra5UzQmGLrZVJb4Uee8gjzoDHw1bPTMeAgr6+w=;
	b=H8Ege6DZQX3G9yxRHS5UxCCkFtXPZkU5j7tgWVxLvN8nt5UuHOwnjCH0ciaw2RnEM7qz2f
	29tLEVN/7HOInVBQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 30/53] klp-build: Reject patches to realmode
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <aeab7294c81cafe98ff363220fc2815f44c4032b.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <aeab7294c81cafe98ff363220fc2815f44c4032b.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:31:45 +0200
Message-Id: <177798070548.9921.18071827190206783782.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=282; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=FOtbR+eQ8HvE68pf8pIzEfjG6PAbJLPLHqWf6TCnPes=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp+dUj2f2YXJ185JDrnsCnvTcEaTqpGJl8M0x72
 uGThZ5UTaOJAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafnVIxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGywfrwgArCIsJIQT9jhwhdMjxvCaVQD1jPElden
 5lLB1d6gLkoB4D7+JL4GY2VffbrOulBKgak/DQwni9U9VB/tQSMmaLW/jvok+suD8dbgqun2+29
 X206MxRjdGTfojZ7i0u6U1otKWlHbqxgv1amlr4GD5FREt1BzAMacnARemFCM0wTvLEOwg4Y+gY
 Hjp1kIuIAp2e9j+It7o6s4yto9SUWmjbtQd/5ytT/az0AfDY6JHgdjMxdYTvOl9lnWPugvIk7xI
 9+/Ti6aDKnNdndW/O1USQWutWr419Za8OWNmnz0qRRDnDsE2xWkP/CEdObME2cr5SweHG+WHKP3
 7kzxlyz7fKg==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 19.79
X-Spam-Level: *******************
X-Rspamd-Queue-Id: C0EA34CCB20
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2716-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:08:18 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Realmode code is compiled as a separate 16-bit binary and embedded into
> the kernel image via rmpiggy.S.  It can't be livepatched.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


