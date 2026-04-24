Return-Path: <live-patching+bounces-2519-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHw2IYVf62lGLwAAu9opvQ
	(envelope-from <live-patching+bounces-2519-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 14:18:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE15945E4FA
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 14:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A7EF300CBC3
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 12:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1009F3BD633;
	Fri, 24 Apr 2026 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DjBVA/wJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="chW8bc40";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VbX9FFjr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M0xVMi3Z"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4863BA24B
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 12:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777033053; cv=none; b=kTwA0m0TMQA9j4qIQ3FyjUigm0knXEImTtK4NXD39NAagFVMdr0aL3buWBVhkf6WcJDxh12Tn5MRntqqMUUnc0LlbxQ6dOIXGbFk1jNBGu4rq6l8iysw3iV2mr/hpAATpjMJOPdWetyBJ+BQAShXB4yqS09l8L4rIthXM0SNcXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777033053; c=relaxed/simple;
	bh=OTPj328k8h2HCGRidF8t3D99EjuMJZ/KHVTR1VwUHLE=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=RIm6QMXQu+kUaB0TDYKkIeb491I50NL10lM9RZNpdKatY5JP5bD6WZUiPsFInGRKRzbQWxfft0Q/VGdMpAI27AzuFZP8rBdJgc8v6nlc2UrExLu2XPOrM8EJSDxlmEqEQdShA4RBvfyO44j5jTsllLH1YFRQ3kzq7upYbnOTNQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DjBVA/wJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=chW8bc40; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VbX9FFjr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M0xVMi3Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out2.suse.de (Postfix) with ESMTP id CBF075BD7A;
	Fri, 24 Apr 2026 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777033051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1p27kcwsak9l72VKqAhR3OpGPKIe9uXTQ3xypdV0/KQ=;
	b=DjBVA/wJNq2qqhPEz0i0i8hhqbxrX2B6oqUInto+qm3VkEdlFMFx5gzL5+oD9WnCSoET/K
	uoIB5p231AmF4O/Gsw4EC5CIXYmYijW3TgFskRkUL2EOxmLUUrykSqN6R5DVfErx2pLzhV
	KhxFJhEJl64peQ/lZ+4PuSMLxBoqfKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777033051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1p27kcwsak9l72VKqAhR3OpGPKIe9uXTQ3xypdV0/KQ=;
	b=chW8bc40PtbBqnNaudesSJTqbDHP3AC0IR3BFBFCBBIjJNLdYCtPNXg2uI9izAOUx+wy1d
	/TlA/sykL1+r8XAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VbX9FFjr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M0xVMi3Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777033050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1p27kcwsak9l72VKqAhR3OpGPKIe9uXTQ3xypdV0/KQ=;
	b=VbX9FFjr6pQkNJ0PwA09E4sWcko8Kc4JMnYHaXs7P9ZwcoYAA6jeSJa6DciqpKT0PvDnrQ
	q6+e57rEhAAOF3Gc522lFVsvh7h0ik5oie4JrIAadGqzwEt9JV3zj1Jy1Z78xWCTX7VwHr
	fcWErGLpVDcwln5wb48/nPE1wzGdkRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777033050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1p27kcwsak9l72VKqAhR3OpGPKIe9uXTQ3xypdV0/KQ=;
	b=M0xVMi3ZQfeQ1RgU6m87EFn+Nfz6wpfxQ+o+ePTbwLc6YDZiIE6jkCu+++takhK/y5+EDR
	sRfoTIWvTueSUMDg==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/48] objtool/klp: Don't correlate __initstub__
 symbols
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <b62dafa3c40576c8e82b062bc24116772c272b87.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <b62dafa3c40576c8e82b062bc24116772c272b87.1776916871.git.jpoimboe@kernel.org>
Date: Fri, 24 Apr 2026 14:17:29 +0200
Message-Id: <177703304919.234971.9364615046091916148.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=527; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=OTPj328k8h2HCGRidF8t3D99EjuMJZ/KHVTR1VwUHLE=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhszX8VH1wqu4D/+7xjNnjYzr+rqjz7zyA0rc+xbv+x1kK
 8kYpHGkk9GfhYGRg8FSTJHl9V5nOcMpuQaa1e/uwgxiZQKZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkCGjhEDF6cATPXN7+z/zB+e3v2hKUy6iJkxvkB+1t+sjAxFSWbr6sPxUa8uhR2vufvlRtDCxa/
 N97VuXvF5v6TFyT25/AfiYmNvLOKbuK/S3G+N3L/83u/H5IW7uOMkJQ+eYOb/q7FNWdYvfHPyqQ
 7GRYs2hE2W0PM7MfnVjz2rNr8JWeWjLmy5MTvAjHti85+Su/1pKblPN8186rV1A6PKPsV1t/9ki
 8yue5VQU+nYb7Lk+x+7+5M9J/GIZlguOFW4+vMGd8WI1Lm26pHVq+UWtQvzT1j/UTcsxSQkPyDo
 tVhL+vwpd4t1djCw6FWze7pFnVtqfyNzQ4TtAq7HNVZFj5qOV6ps2nEtXl7mwZMjGRevuTwx831
 XYP0DAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.66
X-Spam-Level: *****************
X-Rspamd-Queue-Id: DE15945E4FA
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
	TAGGED_FROM(0.00)[bounces-2519-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Wed, 22 Apr 2026 21:03:36 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> With LTO, the initcall infrastructure generates __initstub__kmod_*
> wrapper functions in .init.text.  These are the LTO equivalent of
> __initcall__kmod_* data pointers, which are already excluded from
> correlation.
> 
> These are __init functions whose memory is freed after boot, so there's
> no reason to include or reference them in a livepatch module.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


