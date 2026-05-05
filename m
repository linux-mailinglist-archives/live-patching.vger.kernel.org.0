Return-Path: <live-patching+bounces-2714-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BUWGqXW+WmDEgMAu9opvQ
	(envelope-from <live-patching+bounces-2714-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:38:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D07674CCC9B
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4C2CE308C965
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E103630A7;
	Tue,  5 May 2026 11:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ls49n+2D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hrdHuTP+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ewcnGVKt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S7MrFSrN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DD730F934
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980712; cv=none; b=WDQ/PnQIla4QnLaxjfcobSKl1KesAgFomWtVjh04MeOSDOCXYK5vPeUEEXffrkx1N0LePyzsujQsDV8dCcrZ5eCqqUDbe1lBoEt0i61R+ykdZ0Vn0PnW+2DLbIi2kZe6NGEgzRc965NmPxflm5XTKhCX5UX+Lg7CvftNh759lPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980712; c=relaxed/simple;
	bh=9jc6vAgrIQRSxoR9JajoOzOOl84pS0TXPUrKt3CUt5M=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=FfKPX5AXO0qT3jXEm7y+8zXbyALnWpZNwOnBOgPqq7uzSiXUxWKCwP64fN2i8907ZPVNJ222xRXnmv/nXA/bm7RrRtqqSeiifBn/i11HmLYzaKCGEqp+9YM14c+Xr7qlM5/dgfwg5TNODjv+ZTBOQOYMw4N4+Tquon6h3A6M/T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ls49n+2D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hrdHuTP+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ewcnGVKt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S7MrFSrN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id AE9C05BD19;
	Tue,  5 May 2026 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpvGbyNTnOXcFCAU4FL+YavrlHhUpUHikVc3jRHTTCg=;
	b=Ls49n+2D4u5dTwg5LiOS8G+vVk6iuMJD7Xmr5jnzHpgLNM0BkTDXfeHiRy7gQMreMDgto+
	PLFrBSZ6NvN//+RhEO7RB3buJGg0v/qdso1VCXcF7kd2Pb8zputGda8NWHggFkGfRAJ7mZ
	2YljtQbS5fci5Nm0J/fFtRByBaeSUO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpvGbyNTnOXcFCAU4FL+YavrlHhUpUHikVc3jRHTTCg=;
	b=hrdHuTP+ZQc2UNuBo3Uf+/vn1XhTYsT+54lf50KRisPoVyqul94r8fiHJ0s8C6hyN1TsaB
	nQBey4NxvTRwc4CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ewcnGVKt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S7MrFSrN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpvGbyNTnOXcFCAU4FL+YavrlHhUpUHikVc3jRHTTCg=;
	b=ewcnGVKts18gTxeL1SmHhFC7bmu+KYjnhKyaVhwtdMe09/wBMigoVsCA4nEUvUj+rEGTPS
	SfwvzwunDxE3v19nDGgal5gl8ZtyukX8HXhxjyV+1Rkq4I90co1kpSTgyzlEoRHjOMZ3pG
	mdCbulU3TNDGihBnx5Izez1V+jpaMo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpvGbyNTnOXcFCAU4FL+YavrlHhUpUHikVc3jRHTTCg=;
	b=S7MrFSrNwNpNSTaIWNXnIwmcoIQtFWLeqverQO6RtdntYuR+fo6ZrcE5h0i6A97emzSgNo
	3mo52/S3wrenNRBA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 28/53] klp-build: Fix patch cleanup on interrupt
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <cfc3c1d5096764d0cd79ef85e833b8ce098f0838.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <cfc3c1d5096764d0cd79ef85e833b8ce098f0838.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:31:45 +0200
Message-Id: <177798070547.9921.11861675906138011082.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=474; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=9jc6vAgrIQRSxoR9JajoOzOOl84pS0TXPUrKt3CUt5M=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfV5VfVTJVXVwzSftn5clp//lfTvVM67ZkSP1q/FkyR
 yF0I69TJ6M/CwMjB4OlmCLL673OcoZTcg00q9/dhRnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DIEMHSMGLk4BmOq5Vew/GXdG31+gGXB484o1DEL3zyoFffXJFk7l6TO62Rt16QS3rQLzTPecHek
 CR5bs067UeGm4L3fJxTfv/x7a89Mo7PS0DdlyXb3GtY8uNzTVRD8xTv39Ysqv+JApnyZv5HnVPe
 NB14+Z5QHvpBduOP9r+kbh+QySjd82ii+qsWYNOS4QVyY365n63V2LhRPmduRM3fzDzNWJ80Wb1
 r+Dgb5hXmp7phdf7WpeIy7pc2vlhbmLnltOc58ewqt5zHRn3Y+wx9o7DZc2eq0Qalrh650jaJb3
 lskr8krflEBfL8+u3fVzU9b4JWd5s0peDarslZqjFtYUuXwew3OWlf3ZWmktH5a7um3nP94xvf7
 5iihrAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.88
X-Spam-Level: *****************
X-Rspamd-Queue-Id: D07674CCC9B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2714-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:16 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> If a build error occurs and the user hits Ctrl-C while a large patch is
> being reverted during cleanup, the cleanup EXIT trap gets re-triggered
> and tries to re-revert the already partially-reverted patch.  That
> causes 'patch -R' to repeatedly prompt
> 
>   "Unreversed patch detected!  Ignore -R? [n]"
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


