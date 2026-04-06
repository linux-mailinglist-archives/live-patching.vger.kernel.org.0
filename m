Return-Path: <live-patching+bounces-2292-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GmqJG9G02meggcAu9opvQ
	(envelope-from <live-patching+bounces-2292-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 07:36:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E043A19BA
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 07:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7857E300A134
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 05:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455A530BB8D;
	Mon,  6 Apr 2026 05:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZBzJWZ2d"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1CE4A07;
	Mon,  6 Apr 2026 05:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775453802; cv=none; b=h8YYfhtmIeG/PX63uwe8wNw+Qw4CGkXazhHM69ZWLf6sHzCeGP86YIMcC7MjmGa0miV7I/VuoqPflz2zdvxHzdi0PJ9LSwQ3/dACZoH7R9hHy7AbkWoF+W1mUwWYkW4r9MEbeETqixQXu/cwFuMB+GqMsQgMK7i2NA50vdCqpIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775453802; c=relaxed/simple;
	bh=+6M15O916TUMWzhDmnzXg/R/5LwcNdcZFuE9/ntikaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxEdtfY491xYvyNWfCYwShw9f7iPIGEPs5cPN1Jg4zsWc6i2vwYlw92twoFu0pfW426DNkOYH1hQsYFdBfp8G8DveW1yIsOf6cgTcwOuY3h+73F2wASbpGl2r/68X84PCAyTcU1TcsXSYPvhwTmXNAIUwi+iq+25LbYF3x3EaSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZBzJWZ2d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RGIYpWNa4i33V/14ZSVaKdY9xlfeN20xwvIS5EPGEHs=; b=ZBzJWZ2dHCgQmcYtF3M0ABW3e8
	Uijea4y/vu8Giae5M6EKT3XWHdFKaQFfIBatXzkMDhWk72WiNT8huuh3MyrOgf97NohII7i3VNxPp
	/XN75TO86neDII7NjYT/0PKOozlETrzwizjsewii4HMPElDOzPRAUdPOahs1pmRkFq4sWBjjbtkgZ
	IFqxbJLemO9qKX3MMOXWcOLe+X0IDEJsgFpua9IgXwOXfRFxpvAu2lnEo3PyrEeiLHhg5XaHUeVtb
	dhJ4iQo7Xmwtn0HML8xljZnoSEliq3gMrTQKdbTeMrO52UyqtIqjbDPCheeBsEw0zav8P447PsjXw
	XHCbCLCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cdR-00000004oWG-31PD;
	Mon, 06 Apr 2026 05:36:29 +0000
Date: Sun, 5 Apr 2026 22:36:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org,
	mattbobrowski@google.com, song@kernel.org, jolsa@kernel.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
	yonghong.song@linux.dev, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
Message-ID: <adNGXfRI84mZrUSs@infradead.org>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402092607.96430-1-laoar.shao@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2292-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:mid]
X-Rspamd-Queue-Id: 00E043A19BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 02, 2026 at 05:26:03PM +0800, Yafang Shao wrote:
> Livepatching allows for rapid experimentation with new kernel features
> without interrupting production workloads.

Myabe it allows, or based on the rest of the mail not quite.  But that
is certainly not the intent at all, the intent is to fix critical
bugs without downtime.

> However, static livepatches lack
> the flexibility required to tune features based on task-specific attributes,
> such as cgroup membership, which is critical in multi-tenant k8s
> environments. Furthermore, hardcoding logic into a livepatch prevents
> dynamic adjustments based on the runtime environment.
> 
> To address this, we propose a hybrid approach using BPF. Our production use
> case involves:
> 
> 1. Deploying a Livepatch function to serve as a stable BPF hook.
> 
> 2. Utilizing bpf_override_return() to dynamically modify the return value
>    of that hook based on the current task's context.

Whol f**. now.  Is this a delayed April 1st post?


