Return-Path: <live-patching+bounces-2722-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KWqAhLZ+WnNEgMAu9opvQ
	(envelope-from <live-patching+bounces-2722-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:48:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC224CCF52
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AAD893092E34
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FABE39022E;
	Tue,  5 May 2026 11:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FIcSv933";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rQBzMBqr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FIcSv933";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rQBzMBqr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12838F957
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777981423; cv=none; b=TRTISULhhVaJGTPIsOzBSZNJbMO/CmrDdjUuMFQQNsvi31/4v5rmHd6qRvbuxnU2XJNbF7cy+1+POmXoRfSXHuQQfCiaOQKVl3WSaihDIMv/MI5aW/nZUaFvgfKbzKp7Wq0GO2hUyckIrNe3Rr2R2kBA3HNovrC01Tf/kLKJZDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777981423; c=relaxed/simple;
	bh=Jmrc9QDVTQ6TCg2+yMkomIWdO4u+SFaOfX+RU0IQWIM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=nYAfZH8hqMmh90hkGcygzCbbnN2bbf09vYKdJF23Hycl/Br7rr+icKL3D0vLN+kc/TqN1mcECXwu1QY3a87lKscEiiy7z+N6ubTTpOPzMKHBXiEixecn+pEz/qNLq1A63xY1059wnkOUZGWOenopB/zPxNPvG6jgP10d/OaRvdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FIcSv933; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rQBzMBqr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FIcSv933; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rQBzMBqr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 5CC945C164;
	Tue,  5 May 2026 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777981420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1F1IMX1vrVQQWv2vSE34FclQt6nEO6RqJePI4CxmdI=;
	b=FIcSv933kIqZ9/lhh6OUc89XYYsK/tlid/KwZn9TzQL1xKQKYSS6Hn9LHLIes3bqUnm8F2
	oc0qkU0tjCsDmSPCiYoKIh8j8e+oXezskGzvNMoOVmzQU786jDGe9xtPBxZ+TTxjddXm07
	SP6typfr7+yeQF3gDcPzM528nTYupnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777981420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1F1IMX1vrVQQWv2vSE34FclQt6nEO6RqJePI4CxmdI=;
	b=rQBzMBqryorAWCEl50LdDdnGEMc8JnFojCZZzH4UpKdS58SfLP+5oIPNqp4STz5u+Kwug9
	Bt7wDnQauAw0EjCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FIcSv933;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rQBzMBqr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777981420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1F1IMX1vrVQQWv2vSE34FclQt6nEO6RqJePI4CxmdI=;
	b=FIcSv933kIqZ9/lhh6OUc89XYYsK/tlid/KwZn9TzQL1xKQKYSS6Hn9LHLIes3bqUnm8F2
	oc0qkU0tjCsDmSPCiYoKIh8j8e+oXezskGzvNMoOVmzQU786jDGe9xtPBxZ+TTxjddXm07
	SP6typfr7+yeQF3gDcPzM528nTYupnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777981420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1F1IMX1vrVQQWv2vSE34FclQt6nEO6RqJePI4CxmdI=;
	b=rQBzMBqryorAWCEl50LdDdnGEMc8JnFojCZZzH4UpKdS58SfLP+5oIPNqp4STz5u+Kwug9
	Bt7wDnQauAw0EjCQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 39/53] objtool/klp: Extricate checksum calculation
 from validate_branch()
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <a455b47ef57dcc3506cd97e3c2027ac744941cf1.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <a455b47ef57dcc3506cd97e3c2027ac744941cf1.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:43:37 +0200
Message-Id: <177798141795.9921.5118223797275878948.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=486; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=Jmrc9QDVTQ6TCg2+yMkomIWdO4u+SFaOfX+RU0IQWIM=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp+dfrshni3wmTdJacU5RYi+HAyqa23cwTwstmA
 oJFcsLpXlGJAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafnX6xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyzPsggAu9ai5GmtZB4AfdqTll8MYQVbrrHSUQL
 4NUDeopxJmWXysYJLStlEKQNuO5DpMs5U9WqRvbk5Q0BfqyW9vzUyn2cd+VXza43L37Aqc8MNHs
 TqH+P4KUXsiGBpd/AEFWh0DCziS9kE1MOQxSsE870Hs6hStX9RgzBwzJvYD7TrpcYqMyRinVIMs
 Af0OrEfkSPF0I88I0ufyEjMz2n90Kgp2Ig1JTyDTVBt3HH0juE/2A2Brv8AqZEis9/rd/GAPF6e
 eX0ZlbGxtREZMQE39/GRpXGfjbNlsnLeAD+0LomT56xBHIv9pTn/pQSomNtvPczUCe7nu58gZmn
 pkVUlJ1pDTQ==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 7BC224CCF52
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
	TAGGED_FROM(0.00)[bounces-2722-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:08:27 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> In preparation for porting the checksum code to other arches, make its
> functionality independent from the CFG reverse engineering code.
> 
> Move it into a standalone calculate_checksums() function which iterates
> all functions and instructions directly, rather than being called inline
> from do_validate_branch().
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


