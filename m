Return-Path: <live-patching+bounces-2709-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMdrEXPE+Wn2DgMAu9opvQ
	(envelope-from <live-patching+bounces-2709-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 12:20:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3794CAFAA
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 12:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 248CD30BE4FE
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 10:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF003603F6;
	Tue,  5 May 2026 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e1XpEM9k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VR430qgU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wgg0voof";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="21NcxSQ5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF5933EB17
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 10:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777975551; cv=none; b=isuLnPD0xOYyro2EXqzZpOhawtqQWRVw/yfjahht1sRT42lRfr+pDlO0Ub4VnYrdv6ogNgmPdX8eXd6iiNqCqAszbMOUhMNXSnc8xVnoErIYm3SWi1s6HXhjK7nVCujwU2Vki1zMWMZreNNAra7P7x77ZB07gDYuU3Mddari8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777975551; c=relaxed/simple;
	bh=wFioVYx+s1HXTRmGRgfpYO37x8QUKmlQEJeUXRAlLHQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=sJb9bEL1TQP3DQ3xi+DbnYtXuIAiWEkDB6zJuVFLoCWbakiDMKF/6LMo6UthW8Xs+O4n6TrFYKCgO4uAmcfzhXHemKqbQJagBvs9PqjcTA033U4/gHO+XHLoOWy60RDkW0wT4saAewcWyfU1pU40XrrRNZEJGKrr4rM1iFFlWzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e1XpEM9k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VR430qgU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wgg0voof; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=21NcxSQ5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id DD8C16A807;
	Tue,  5 May 2026 10:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777975547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7AuNZuv+elByHB6PBffM5IFwLj3jL4dDyZByREqLxo=;
	b=e1XpEM9kDBll76sKJr1JRV6I8f/7Bl+Eei/Nt3wkgIie1iZAr6QWqnLnW8NjyLjUHtegS7
	Bgtuz+IMzD0qWPHbcF/p2ZUAsKVfsjR3PGriLWkfWE9oSxLEgium4D5kJbp6zpnpYtttmj
	Fko3pEUYzFyJ8cwMJbH4q7P+IJ+tHNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777975547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7AuNZuv+elByHB6PBffM5IFwLj3jL4dDyZByREqLxo=;
	b=VR430qgUlWRYp1zlmZtAGSWtxb7LJ9PPO023Se/KP416SSpRRY1XciUunFz3rUm0aQo8Rw
	Q0mkmR9fEvJocUBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wgg0voof;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=21NcxSQ5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777975546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7AuNZuv+elByHB6PBffM5IFwLj3jL4dDyZByREqLxo=;
	b=wgg0voofyPc1t8QC98X6o9Kbaz0r4djVrHqiMtXfTBRR9EyEEKUUEF35je/++dIAk8KAii
	my3Ef9uJAYQ6o9H35WjzYDgRs/gnVv+ysI+vqlySebLvkG6V+F6AoSQr+dVORfGCCHuq2+
	ucIOnoZFjFw8dl5U73KXQY+snzVDIqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777975546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7AuNZuv+elByHB6PBffM5IFwLj3jL4dDyZByREqLxo=;
	b=21NcxSQ5hmWj9Y1leXpEc7UFEY7PSHzlSBvAsDYQG7e9zoY4ujjYpV5pmTZj5xo3VTwXY4
	LPBVXevG4fUGBrDg==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 24/53] klp-build: Fix checksum comparison for
 changed offsets
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <6392d4f0c8837ccc0498a1c79a2d9534dacfce82.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <6392d4f0c8837ccc0498a1c79a2d9534dacfce82.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 12:05:45 +0200
Message-Id: <177797554542.9921.15231697922536568953.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=539; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=wFioVYx+s1HXTRmGRgfpYO37x8QUKmlQEJeUXRAlLHQ=;
 b=kA0DAAgBgX1r3ESrGywByyZiAGn5wPqiu60jbY4sMPRZ8Rhj+Rqtcumj/eiCl3sW99cCzvr0W
 YkBTwQAAQgAORYhBOu9Qx4xlG0wKXvu3YF9a9xEqxssBQJp+cD6GxSAAAAAAAQADm1hbnUyLDIu
 NSsxLjEyLDIsMgAKCRCBfWvcRKsbLPv3B/97FP0AicbSzsGMxwN2vNaSgltbVqBcQev+HF508JO
 bQb2fCbezFxqf2B9dxAM9Vjb46tKpJYsgcKUS+fkWbG6CAT0codvF/qe/zn1+HBngZPQ4+6pmob
 DHKaZPgN7uqm8vunzGiL58i/lLwqIneDCl9kd9OhRoNl2lhILPZjTfHgicVMkYLuCCmX7l43019
 0Pzl0R92IkOKvskM3jsudZTezHPQLggIgDDaRR1HSrgdkW3/jQeCEmJhH//8YS72xwEk+0d5aci
 O/1FAyDHEfmWMIk/BFectXBIUKvFMZopH17kpVcv2BAHoO8OIwJq3gvd5ZbsB4T3sfpntGBZxyT 8
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Score: 17.39
X-Spam-Level: *****************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 4C3794CAFAA
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
	TAGGED_FROM(0.00)[bounces-2709-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.967];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:12 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> The klp-build -f/--show-first-changed feature uses diff to compare
> checksum log lines between original and patched objects.  However, diff
> compares entire lines, including the offset field.  When a function is
> at a different section offset, the offset field differs even though the
> instruction checksum is identical, causing the wrong instruction to be
> printed.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


