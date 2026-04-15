Return-Path: <live-patching+bounces-2352-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMNwKaNA32kxRAAAu9opvQ
	(envelope-from <live-patching+bounces-2352-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 09:39:15 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8F3401719
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 09:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1728930B32BF
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 07:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA123A5430;
	Wed, 15 Apr 2026 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sfAIvHvJ"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4E01A8F84;
	Wed, 15 Apr 2026 07:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776238743; cv=none; b=PO5mSfYH4gSZf0ujntiLFtcOjHCos4Qxxh1CDo49sxw23CZwNb87pda1I1O/K6KMXV4L/rw4nLyARn6JWYyq+EXcxihtXb4/3AM6LQWAA+pZQKmkgKOxKwy7lrjlyMCBJQHcs/FYRU1NTNlhsXYL/AX6DVnCXMwfi1cSICYNOh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776238743; c=relaxed/simple;
	bh=D8IG/VXCfqcnsSgZAVBK8M5wjgHKHse8qQaQUHB5uFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hX81JfEBn4wU6Mwn1IFjiig4OJO0dHwzhJSGGX7hfcLPrRTF20vX+aZvZspwBJ0/keOfLJpC9Yg5qYMfoEVCOK6uZVSPXcNODXr99wU3txOdI5VIBM7boDPqbgmZmUyFI3f+UaKXOiaEHasCRmwITpkIzMkyJP9bpv/wcZSjx1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sfAIvHvJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=02523h4/XIkVhgJ/vZX6OsXKOEk8gdqo17d4C/+74kY=; b=sfAIvHvJxJpthG3Xc2imVY/Hny
	3u+iheK16tltZrKVxY0W+Tqvi0LL6Wo2rGmYqg2NW7gFbWPrKjtlFkwux6bn2+pr3san/KDZLb4/L
	C6GtQrCUlMhNVTspr89p3YcZAtfJEN4hYMsJRuyiiVrnemtEm1lC6LY4wCWOqlqDCkqqANADpOqhM
	cxJH4fAp4cBQFZ/04Ft33u9X2TsbOruFO0jfu9hUnqCnkr1Ib+bnVz1bc020u+AqlHRT6lV+kPCTa
	KWM+LRMk+xz1Quqi0mss6p6k2rkspgW7gtGnhprWTZo2O+NY/r7uDgC89/KfdzRA0OUZ7foxyoJxg
	4UQgbT3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCupi-00000000jwo-2mQw;
	Wed, 15 Apr 2026 07:38:46 +0000
Date: Wed, 15 Apr 2026 00:38:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
	sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
	song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
	rostedt@goodmis.org, mhiramat@kernel.org, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Decouple ftrace/livepatch from module loader via
 notifier priority and reverse traversal
Message-ID: <ad9Ahq6BXQbHA1LS@infradead.org>
References: <20260413080140.180616-1-chensong_2000@189.cn>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413080140.180616-1-chensong_2000@189.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2352-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[48];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,189.cn:email]
X-Rspamd-Queue-Id: 2E8F3401719
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 13, 2026 at 04:01:40PM +0800, chensong_2000@189.cn wrote:
> From: Song Chen <chensong_2000@189.cn>
> 
> This patchset addresses a long-standing tight coupling between the
> module loader and two of its key consumers: ftrace and livepatch.
> 
> Background:
> 
> The module loader currently hard-codes direct calls to
> ftrace_module_enable(), klp_module_coming(), klp_module_going() and
> ftrace_release_mod() inside prepare_coming_module() and the module
> unload path.

And that is bad why?

>  13 files changed, 290 insertions(+), 74 deletions(-)

This is a lot of new complex code touching a lot of places for no obvious
gain.  What is the reason for this series?  Does it prepare for something
else?


