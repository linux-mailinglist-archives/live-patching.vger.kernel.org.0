Return-Path: <live-patching+bounces-2727-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mID+LiPd+WkwEwMAu9opvQ
	(envelope-from <live-patching+bounces-2727-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 14:05:55 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7DE4CD308
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 14:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 095A7300737F
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 12:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC18401A1A;
	Tue,  5 May 2026 12:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aI5qF5W7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8dCKfPbN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aI5qF5W7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8dCKfPbN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0549B401A32
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777982463; cv=none; b=afVfeM++MrufN22zBsUMBcPtPCKbCd2TX6yYEwvfnDZYyNigJiSHUemSzTc1UUcglymCD7RRIlyZgOqmtzRYe6XT1K1XJJYHhsjBZkt64gZ0AvJrrXXub1cyZHWkuqLXOyv8wUaaXNU8OvGvu0X1LVnl8nTfjSsDCeCd6/VlpO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777982463; c=relaxed/simple;
	bh=O9xBYPD1R8nyNdY+EsoGL1B4OmFEha16sjfDtn534xY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=lqM3Fv9mRmHJq/YgTkO2542vufjEMEDL+LudThMDQboMxI72czCnWNAjyxi4q1Ya70MBADmuOIkCx4iazaSn/YPcP7Bpq/0ztGS/JJ/MiroyMY7jcjBH5iQ0VcXQkas26zMdKkYcO1bObKzc1+3HVot1yicHRg/luE8uc5BRDlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aI5qF5W7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8dCKfPbN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aI5qF5W7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8dCKfPbN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 32FA55C35B;
	Tue,  5 May 2026 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777982460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrHl5QhcfXjPWUlmW44HqQPhJDWuSQR9vuJw4DOroEI=;
	b=aI5qF5W72M1guJ8LpOiHdTrSKN2R7rnOVm7WY7eXV35EMOFWf94asK5hVQucdpllIG5yQG
	GKWpJ1AODz1lPMgrtyDmeBAXPQKH2REkoR3fJqFqpmX6iXEA8q2EOk94Gk0qu+QOwJ2fWa
	gDMVrYWHGGC5SKMizrFM1jbPMPd1rM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777982460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrHl5QhcfXjPWUlmW44HqQPhJDWuSQR9vuJw4DOroEI=;
	b=8dCKfPbNS6moIzGmLgeVrl+/6lxAlzh1VcdXHfW2D0jC4YKcSJgTNRsJcHGOEY3v062N0c
	CYpNSbCUjAUnEHBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aI5qF5W7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8dCKfPbN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777982460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrHl5QhcfXjPWUlmW44HqQPhJDWuSQR9vuJw4DOroEI=;
	b=aI5qF5W72M1guJ8LpOiHdTrSKN2R7rnOVm7WY7eXV35EMOFWf94asK5hVQucdpllIG5yQG
	GKWpJ1AODz1lPMgrtyDmeBAXPQKH2REkoR3fJqFqpmX6iXEA8q2EOk94Gk0qu+QOwJ2fWa
	gDMVrYWHGGC5SKMizrFM1jbPMPd1rM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777982460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrHl5QhcfXjPWUlmW44HqQPhJDWuSQR9vuJw4DOroEI=;
	b=8dCKfPbNS6moIzGmLgeVrl+/6lxAlzh1VcdXHfW2D0jC4YKcSJgTNRsJcHGOEY3v062N0c
	CYpNSbCUjAUnEHBQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 44/53] klp-build: Validate short-circuit
 prerequisites
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <ec40bb551a583c7a7c329199e41d21a0f086775c.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <ec40bb551a583c7a7c329199e41d21a0f086775c.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 14:00:58 +0200
Message-Id: <177798245894.9921.12663473555512981124.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=291; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=O9xBYPD1R8nyNdY+EsoGL1B4OmFEha16sjfDtn534xY=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyft/8wqDYvN/qpcixw3nKxj78i+46wxkT7SP+3L104j
 7M7xehDJ6M/CwMjB4OlmCLL673OcoZTcg00q9/dhRnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DIEMHSMGLk4BmOqFCez/k3SMyx3CLh7+PPP1syOXZYr4//Z/PrtuRtXt1umri/dq7mrmWfiwWZb
 JfsMc0ys9D+7+EhNYXuKwd03uhMvhYRwO7Vsrk4vnsiWE8GQyOskHuIluTvxesSB35g3l987rb1
 bc4UnON5ir+cNb5sUWhk05b+bVntj3/IHIqthtySa+nA+9jeIz5vAvL3zYU+cn737LNT31Ydxpr
 hLBxuXrA3P3vr6zvu3XRI3p8y47tb+xWqmov8TRQO5s97395txrtOa4znnyKavZT6Pa0Px687GZ
 623n2yg8iHt+YkKr9A9tqbAf2V/0Js5bdDT8Lvc6e/sVZmmHD8q99j65yj4g907/s3XTnDi+zFj
 MNOn5LQA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 1A7DE4CD308
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
	TAGGED_FROM(0.00)[bounces-2727-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:32 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> The --short-circuit option implicitly requires that certain directories
> are already in klp-tmp.  Enforce that to prevent confusing errors.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


