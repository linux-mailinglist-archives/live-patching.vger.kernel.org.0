Return-Path: <live-patching+bounces-2730-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0PMUBLrr+WkLFQMAu9opvQ
	(envelope-from <live-patching+bounces-2730-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 15:08:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5594CE2AA
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 15:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E4FCA30471C7
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 13:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E47B44BCA1;
	Tue,  5 May 2026 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TBa9tV89";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3k5fnWiK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a0f6eQ5f";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fkfoe2bu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF51243C059
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 13:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777986479; cv=none; b=qEJGA+FtiUdXs8xGilpvQnsKfto1P6zscU9ODCDX+dFkMTpnpt/TEUw+Ro5V6DBn/GOjudeovItQqrt8ZODWkTsQ6VoybCuGbHSaMQiebrKRw3Y0mAkGsNdKTTXJZIwtfRNfv+EsWm1nNYf4OEta0/fibJuRRjfLlsodrttDZY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777986479; c=relaxed/simple;
	bh=efkaRGbov+ZAIOv1O6plC6HvEUImbAcoC0DWBtcJd5Y=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=ClcuF5yZa+uS/nKD/IKFcpTwIvzdx4o07QesByaP3eJmUY6dgYcqXYVuOz1p+O4RpcHuOBnlZzGTbYkaIql2+qorinIbKyexPuNWj4rvL2kSMrZJ9Dvi6ccHayxJ7g3zVVr6V4TAoJQ6Kyd4to+8PoMiH14KlWLiFGmT6+lSSsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TBa9tV89; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3k5fnWiK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a0f6eQ5f; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fkfoe2bu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id D1C295BEE3;
	Tue,  5 May 2026 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777986476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe8h0lf9XIAqb4NChPv695HZRUVHzL9qEnfuBV9ZVmc=;
	b=TBa9tV896AFQtHeVOPHBZ2W2Be5W6eNq15IKETJIbHRrz2giwwjqdUPyj57CX+vobYWzc1
	zXDLdiTqxDgCmTo+NnSXbR9YFf4M56RF796HBMEsU6DA2U2t3c+DHiF1Mai9hZ5EFz+2hR
	EhgyZQB3SAPFV9p6RYhFCQLUJIvzHew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777986476;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe8h0lf9XIAqb4NChPv695HZRUVHzL9qEnfuBV9ZVmc=;
	b=3k5fnWiK1UVTpOr4UDEvUHXHqvDR26AJz8fcpCG3qE9V/IYaoras+mucAYsV3KneG4gHeG
	O809SsPgGTFIVqDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a0f6eQ5f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fkfoe2bu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777986475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe8h0lf9XIAqb4NChPv695HZRUVHzL9qEnfuBV9ZVmc=;
	b=a0f6eQ5fZ4oA5qjaYaN4GTiWbzE5gbEVprp3fXZgrZiPq3fcPBaaav8yZbZiHebktHTesX
	YeHLOUnt7iAvda2QXIv0sMDWYLPbvmqZTSI0I/9rJc8qkuVenA8VsQQuHoxaU+cuuhEnEU
	17ikHWNa2YcT5JjOO0g0ZphbMZ6/8vw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777986475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe8h0lf9XIAqb4NChPv695HZRUVHzL9qEnfuBV9ZVmc=;
	b=Fkfoe2burf+DnAdl9l/Z/SSr8HhSzMCHaZzFN/qGnvT43/nAbJlClKiuIZRfKzVH6h1K7p
	ToA9okqpkBZjz/AQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 46/53] objtool/klp: Rewrite symbol correlation
 algorithm
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <27fcb5a17cc7b6821d8b1c4b9812ebb5b4ee6a5c.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <27fcb5a17cc7b6821d8b1c4b9812ebb5b4ee6a5c.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 15:07:53 +0200
Message-Id: <177798647393.9921.5655000270119550671.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=480; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=efkaRGbov+ZAIOv1O6plC6HvEUImbAcoC0DWBtcJd5Y=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfr1f/uv3acMbJ41ON9bWrFcO6Nwrld1fUd/9Z3Ctyo
 PM+Y9jpTkZ/FgZGDgZLMUWW13ud5Qyn5BpoVr+7CzOIlQlkirRIAwMQsDDw5SbmlRrpGOmZahvq
 GQIZOkYMXJwCMNU/mtj/lyqml7F9TzpTLfHl5eeIno/rLU9yK9y60P76zpX7VVlWWsd+Wk6f7mN
 1Le6qwKyUiFkPF/moObCkc8Y+T3Wr+rCpJ0nZKOPfutmRymvf7Lgqutr11rzGScGSPez2+o6vr3
 Zd/yaU8/iToTXTrttvSu7dOc3ilv76E7/FS7/mwMBqTxWeQ5c5uL5+b3rZqnrvktb9f9b9RQcYJ
 fNu2ZbsXnpluYDehESdQ5f2pMZeN7uveTrVNk+7fc+X+wK8dpWa1aejoh1/H/p/9tRxO9552a0V
 l2+rqjFOT8/vXL9syqLl7We5XKXCTR4IbAi8k3wqkfmnS/bveau+fDfcprBCedLxiQkHJZLNrK6
 H7Zi0AQA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Score: 18.66
X-Spam-Level: ******************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 6E5594CE2AA
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
	TAGGED_FROM(0.00)[bounces-2730-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:08:34 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> [...]
>   same-named candidates, similar to livepatch sympos.  Used for data
>   objects like __quirk variables where no deterministic filter can
>   distinguish the candidates.
> 
> Overall this works much better than the existing algorithm, particularly
> with LTO kernels.

Nice improvement which makes it much clearer.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


