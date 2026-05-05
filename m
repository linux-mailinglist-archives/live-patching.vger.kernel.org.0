Return-Path: <live-patching+bounces-2717-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 7qP4If3W+WmbEgMAu9opvQ
	(envelope-from <live-patching+bounces-2717-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:39:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D724CCCD7
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2D16308D279
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02D438D6A4;
	Tue,  5 May 2026 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YJsPuL9y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9J0xLMc7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YJsPuL9y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9J0xLMc7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3638D6AD
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980732; cv=none; b=hU/FDD4X1MGY7uzzYSPaLg0kSRGvQPZqCLyetjbzH1JQTFzlDXdFKSyRc+87aUEqnrclH1Q+rwV1Wxa6eg7UTa79GVltd8qNuJm/atKTLT069c9Sb3zXPYmqUmU62EItYKWaDKn7PQo8whuRPedTsLZjncrIPf7dLfNS0snBeqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980732; c=relaxed/simple;
	bh=9uVMhwBlKoKBu987rx5Cri2nFLAX3ThAowWd2UGH+zk=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=dLxSZ9TY3FijdD1zPvu2EE0Qw+u//BrN5aWsfNE7nWxI3X39rJkv/8laK+AmUzZbMFmL2CZKMhjYGMXNx1EoAB7ylR4sCZuZZNYVlNQ1XmO+9C5tsjP/4/kiSfWFcmQSrwP7m6PF7uz40cfCVCvk5HeGPuoKtL+otYlSSqJg4cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YJsPuL9y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9J0xLMc7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YJsPuL9y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9J0xLMc7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 876E25C165;
	Tue,  5 May 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7KbXEp5/++5XjslmAtiiDc1umLOlcjzUYLHgaYtPpo=;
	b=YJsPuL9ymC+UEwcPEBxTEV/uSfp+MvmFzPVcWmfmbvVLyDTtXrx2dHyNCOvCFUFf5JpCkb
	62wyaBCBKkQVqa0G1fsJj3W/h6z7N0G/kVIgISnJzxj/FEDgnMbPP3wFa4njCbtCjrFZOi
	ghaWD++v+STimCNd+s4kVrw77e9/gFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7KbXEp5/++5XjslmAtiiDc1umLOlcjzUYLHgaYtPpo=;
	b=9J0xLMc7rdekH1DIv0BGBhtP0lLt770ugqCtjvKgUbnajwgBaGItsydBae5ySYfkZ0xKOm
	XpMkzYSu85RumrAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YJsPuL9y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9J0xLMc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7KbXEp5/++5XjslmAtiiDc1umLOlcjzUYLHgaYtPpo=;
	b=YJsPuL9ymC+UEwcPEBxTEV/uSfp+MvmFzPVcWmfmbvVLyDTtXrx2dHyNCOvCFUFf5JpCkb
	62wyaBCBKkQVqa0G1fsJj3W/h6z7N0G/kVIgISnJzxj/FEDgnMbPP3wFa4njCbtCjrFZOi
	ghaWD++v+STimCNd+s4kVrw77e9/gFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7KbXEp5/++5XjslmAtiiDc1umLOlcjzUYLHgaYtPpo=;
	b=9J0xLMc7rdekH1DIv0BGBhtP0lLt770ugqCtjvKgUbnajwgBaGItsydBae5ySYfkZ0xKOm
	XpMkzYSu85RumrAw==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 31/53] klp-build: Print "objtool klp diff" command
 in verbose mode
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <949a2ff797f2c7e366dedc760aea726e7cae1b11.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <949a2ff797f2c7e366dedc760aea726e7cae1b11.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:31:45 +0200
Message-Id: <177798070549.9921.2434615313766423015.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=283; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=9uVMhwBlKoKBu987rx5Cri2nFLAX3ThAowWd2UGH+zk=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfV5UdWl7/TFg9a/Ij0QerFPauicovfafQcfKGv+u3R
 dKvbBilOxn9WRgYORgsxRRZXu91ljOckmugWf3uLswgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BgxcHEKwFRf9WP/H7an7uv7w4nfVZasz3Gw3Cvy6lzg5w07Xv2ZZ39S/IpJLb8E9/zlM+v
 Fa7hu889ylbz8bj/HDQdXjpefN7RM/pac3fFGueti1PV+p6WLJ3t0d2rNUONvmzdHWrLw8SzFp9
 +TY2yluJvlNNzOfPq7rmPVwS9hC5aecv7E2rXM/hL71ZBFfM+eTr0V/SLwFUPz7a3aqdEPi62+x
 4j7rpsiEdvF4F8/M0JwdeP5FdsYAiJm/OFheaKWfr6ipOXmn6eaBtqMMe+UwoofZmZNXlmt1nS0
 5sv7a9a+L1WdBfOPKfIzH5I532Smqeoy4/qZAqd/hgwWrBJf1t5S1t7dsmKm3oUJ1yr0H/9j9z3
 Ltyn9FAA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Spam-Flag: YES
X-Rspamd-Queue-Id: 42D724CCCD7
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
	TAGGED_FROM(0.00)[bounces-2717-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:19 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Print the full objtool command line when '--verbose' is given to help
> with debugging.

With the Sashiko fixup you sent elsewhere

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


