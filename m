Return-Path: <live-patching+bounces-2731-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJpGLpny+WmcFQMAu9opvQ
	(envelope-from <live-patching+bounces-2731-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 15:37:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A8F4CE9F3
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 15:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FCC330182B2
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 13:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856864611F4;
	Tue,  5 May 2026 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KGKvFb6h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tH9/Pjm+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KGKvFb6h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tH9/Pjm+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEE43F6610
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 13:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777987713; cv=none; b=Fmwg20ReLWTC/P6d8xlplnErmyKor/8VjvlYVvdXFotMCVB7qBGflF/Okn90eQbJ5OHtK0+zmcvVRMkoHoZG4p27v1C95WQ+Ct+ZhdW/+BmIQ3fVjXo/yolsm1Ri5vh7Ch6Jlx6icrJPScp4/oED2lO5jr8rHgRUYY4hKiAVg+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777987713; c=relaxed/simple;
	bh=DimIdk5HlRCufO3Dc/Bn998Xbr1NfifgQDE9c9IFfYM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=qjZer8MUboGuRgKMapxmEox++z3l9xlUomwNwRtaHHJJBsSV20ln8Vq1M0gIyeaqefThukx1JeP1YLdZ08RAhjjIn/jYc14QJ/IhjUanBUz9cEe39FUCb8fGJqzCKyT68kPTryh/RkK/lAo5OCK1UzKd8PTJ3qwDpFeNjPRYTCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KGKvFb6h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tH9/Pjm+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KGKvFb6h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tH9/Pjm+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 39B315BDEA;
	Tue,  5 May 2026 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777987710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPtqYPg7TzRenPG60LYbz3Ttvrk6cpyBCzsgF2D3RgE=;
	b=KGKvFb6hSeDYxhIegME2zB34rAAuwWSnL4w6xXfydb/P/pFcIrCc850VbsyP/fG9C0dtKX
	GhJp0V10BvP370uD+vHgW5b8mwPD8tYtu+sWoc6CJxgyRMUOXffEjqtgd3iecjhxN3iRuN
	7wxtJHLsT0KmSaB105Wp5jqA8Lsjy0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777987710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPtqYPg7TzRenPG60LYbz3Ttvrk6cpyBCzsgF2D3RgE=;
	b=tH9/Pjm+3g4dLKxpeH9nqcELPIMAl6a+5aAlXcddaQemlEvrp39sybVsfif9an9BRtCA09
	Cn5RycGM4wahD5DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KGKvFb6h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tH9/Pjm+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777987710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPtqYPg7TzRenPG60LYbz3Ttvrk6cpyBCzsgF2D3RgE=;
	b=KGKvFb6hSeDYxhIegME2zB34rAAuwWSnL4w6xXfydb/P/pFcIrCc850VbsyP/fG9C0dtKX
	GhJp0V10BvP370uD+vHgW5b8mwPD8tYtu+sWoc6CJxgyRMUOXffEjqtgd3iecjhxN3iRuN
	7wxtJHLsT0KmSaB105Wp5jqA8Lsjy0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777987710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPtqYPg7TzRenPG60LYbz3Ttvrk6cpyBCzsgF2D3RgE=;
	b=tH9/Pjm+3g4dLKxpeH9nqcELPIMAl6a+5aAlXcddaQemlEvrp39sybVsfif9an9BRtCA09
	Cn5RycGM4wahD5DQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 47/53] objtool/klp: Add correlation debugging output
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <492432266706503947483b831a17a1c118dc5007.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <492432266706503947483b831a17a1c118dc5007.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 15:28:28 +0200
Message-Id: <177798770822.9921.4931528114661604262.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=293; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=DimIdk5HlRCufO3Dc/Bn998Xbr1NfifgQDE9c9IFfYM=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfH+qkgjMz9yid1J3tHzeVJX2CRXL0kkWPbGRO2pfIz
 mKYaPqpk9GfhYGRg8FSTJHl9V5nOcMpuQaa1e/uwgxiZQKZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkCGjhEDF6cATPWccvZ/+jMrXp5dveL7dgZB1Ye/b0YE8ZkmvgtIl1wfr/JusvU+to/Sa2oOiYX
 quVr95a1qYLkofdU2zn/7xfgs+TNTu/de5Vn4V9zl5VrV8j9PZ9+6afE3/2y6wUnep/8maAlo8L
 GbJnbPD7He+XWFGofDUdHEdQ+7Nk/ymGj0POibW666aPS+FzkC5xjEc0PZfgWyd3a/WuMzU9Lyl
 KLhSe7FbG+4HBWZNvmX/j21Np3bf8bfl4+lJ2e5BThu+KOldMX0rsu0Tf+mLfJX0L501IDXoE54
 VUiV/JlSifu7qpNOr2OctGcPQ5qxudOlogfzvM6G23SudlpQfCDE8pL26l8/z2QHVYj87m5NDU0
 ok5gJAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Score: 20.71
X-Spam-Level: ********************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 22A8F4CE9F3
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
	TAGGED_FROM(0.00)[bounces-2731-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:35 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Add debugging messages to show how duplicate symbols get correlated, and
> split the --debug feature into --debug-correlate and --debug-clone.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


