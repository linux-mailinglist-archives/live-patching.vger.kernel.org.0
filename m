Return-Path: <live-patching+bounces-2609-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ukAJJsD78mmIwQEAu9opvQ
	(envelope-from <live-patching+bounces-2609-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 08:50:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E3149E3DD
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 08:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DBAC3010BBB
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 06:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5CB34167B;
	Thu, 30 Apr 2026 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nDvuwuyx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+WGGj7WO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nDvuwuyx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+WGGj7WO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F6678F2B
	for <live-patching@vger.kernel.org>; Thu, 30 Apr 2026 06:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531836; cv=none; b=J0M11ARLnS85dZANZ3yG1JRfLcwzowSmNjjxmK35uBqoEKJBdyK39ke6qPqSOT9sE2UmlfO9ENvn5F5gfbmGfuaB3tJm6vtxO8pl3Cj/7m7kUyAf54zVl1yOWJUTNiVMsrXqkxJ6KPn8NN2b6vbO0GRh32WhYhUTt7tL41vrolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531836; c=relaxed/simple;
	bh=lNe18G+lB4wqfL+shspKo220rtiySxUfeP7x1HL/33c=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=h6Sg1gDlxk+m0Hu0gWamrAROFYA6Tn1kdrXPsS2/Wx2gDlsb8l457FeoWtkNKl+YWulOZxkaldMZBTgCRM0CFK1StxgL8mef5W7jsq/SaSkWqOBis5TsXSZ51cWtiRGYaF2Ed38mvRjp0SScuzSbBunZg8uVyd0cPZq6irzQMAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nDvuwuyx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+WGGj7WO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nDvuwuyx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+WGGj7WO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from unknown.suse.asia (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id 289506A7D4;
	Thu, 30 Apr 2026 06:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777531833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=efWIlURFr2yx//8GjTEF8xQGkeJqC3ivATw/v9GaPmw=;
	b=nDvuwuyxUDvOYa7chu4B3UyUkMufnQHimRirJB1uUQ8E5Y/n56XWSfq5FBhkRC4ybMZBvi
	7FUfJWACIeV9aSOH1n2rgx+6UcyVs+gw18z2srifUdwBzEelwDh3sATcb9YbPno0ahtJp/
	59FA66MyrE3mYdx2yHe9qBv4pkFpTqk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777531833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=efWIlURFr2yx//8GjTEF8xQGkeJqC3ivATw/v9GaPmw=;
	b=+WGGj7WOkUVSU7C8yYfoNTpyL3bko1L+zbcLt5pIMhAb1biK8+Occ8TwYvGKdLpqNsMrBH
	P+fg2p8fLwbC6vDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nDvuwuyx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+WGGj7WO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777531833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=efWIlURFr2yx//8GjTEF8xQGkeJqC3ivATw/v9GaPmw=;
	b=nDvuwuyxUDvOYa7chu4B3UyUkMufnQHimRirJB1uUQ8E5Y/n56XWSfq5FBhkRC4ybMZBvi
	7FUfJWACIeV9aSOH1n2rgx+6UcyVs+gw18z2srifUdwBzEelwDh3sATcb9YbPno0ahtJp/
	59FA66MyrE3mYdx2yHe9qBv4pkFpTqk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777531833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=efWIlURFr2yx//8GjTEF8xQGkeJqC3ivATw/v9GaPmw=;
	b=+WGGj7WOkUVSU7C8yYfoNTpyL3bko1L+zbcLt5pIMhAb1biK8+Occ8TwYvGKdLpqNsMrBH
	P+fg2p8fLwbC6vDQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 20/48] klp-build: Don't use errexit
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <f86bf0b781101152b35437bfe0e6a286f3955247.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <f86bf0b781101152b35437bfe0e6a286f3955247.1776916871.git.jpoimboe@kernel.org>
Date: Thu, 30 Apr 2026 08:50:27 +0200
Message-Id: <177753182747.9760.15057230163168246043.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=324; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=lNe18G+lB4wqfL+shspKo220rtiySxUfeP7x1HL/33c=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsxPv7dWHa9ewlixbG9qkydbcX/RzUxtjS9drYfzLgrI8
 wqr+TZ3MvqzMDByMFiKKbK83ussZzgl10Cz+t1dmEGsTCBTpEUaGICAhYEvNzGv1EjHSM9U21DP
 EMjQMWLg4hSAqQ4WY/+nGSP4d+KhS6unnlU/7TI1VszNXGzHz6eds1SqWDoyldcezrLc0O21e/G
 igpfzWB6cTMz42neLIy/mUAGfGCdXcFHrpjibFdYP3u9c+9Jn380le7bZHhPlnOEUuVy3It/XIE
 JjoVRRxPZaX2W27tPSu0RunHh8gZWTycXtzuFrmt2NJTMVjeWquC9/KT+vd2RC78wTFXrpG2/dq
 2p/WvIojtHCscWtJjf4wMP6FrVLeo/fcHxtrLvuN7dZz9Y8y/x96CQBSxmvr/smrWE5X8p8nzeH
 xb+4b5VqXITtIg638h9Zs7dm7vt/S1LpjOntsHNuPL73u65diqtuLz73o6E/zi3l86QdPdGX79x
 8vRIA
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 18.59
X-Spam-Level: ******************
X-Rspamd-Queue-Id: 05E3149E3DD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2609-lists,live-patching=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]

On Wed, 22 Apr 2026 21:03:48 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> The errtrace option (combined with the ERR trap) already serves the same
> function (and more) as errexit, so errexit is redundant.  And it has
> more pitfalls.  Remove it.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


