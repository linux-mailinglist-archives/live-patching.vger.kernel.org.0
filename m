Return-Path: <live-patching+bounces-1435-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C97AB69A5
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 13:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E994E1B4585B
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 11:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BB9221F27;
	Wed, 14 May 2025 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D6QKCYAc"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53B26FA46;
	Wed, 14 May 2025 11:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747221486; cv=none; b=ETs9N1qbI10EmxCa4APgkRAYajVTepJVge7+anRozfhljKMSKlpBmzl/yBudLfB1+DRojFGtmI7R5695iifZYG3GQSUHSU8Zhv2dG6TIJGleCA7YRm6pQMO4l6pglMxBzHEHUNHZaxq9tGBO78+WoeNqWX/hsfe7fMtQ1r88yKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747221486; c=relaxed/simple;
	bh=ImfTXaWkk1+hN0PmnUt6ex6F3XnpD13fp+9U2QnEG2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/2KkImnxqs/UMQAwhpuBDa+ts9CblrudvCtrbt83+8n203uIfZsi4a4NsXr8UW9tAg7yu4HAaZJjyBs6TBbujBCBY4GHu3obS1S5U04/AP6K2knD06EaE3ITRKsv41MA+xU9uGfz5OQQUfdKf+ekQN2o9wJUvXECm02d1HR/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D6QKCYAc; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ImfTXaWkk1+hN0PmnUt6ex6F3XnpD13fp+9U2QnEG2E=; b=D6QKCYAcXlofdQS2LF0MKo4JkN
	dFQwI9iHkMVh7ao18DuIiQcm7niD1NUGzgZkccZxQ8TCPZ65pzk5iioyxduQnbKd7Lz+6vKiZUCJL
	VtzgrJwU1RnzOb4cO7jJwLNwCLl9foiwMAjRto73VD/nBQgfpp/LAP45j4/n/YN+lbMwKCmgIpqd8
	M9rIm0/ynXjzO72r9hueWw6KSVkWHsv+MXlBerfhiMpOMppG7alUxy2NcUjFKD+5iM9WKqCaJy0ok
	48U+TPFZ3MGlnVLdSt12DwFrfJGcF2DsVtS4mB7AoP7aHAamf0R/aQ/e3KmQtFX0sj3TQ4T4Ig5FS
	V3qjFeLg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uFA7V-0000000CCan-3r4c;
	Wed, 14 May 2025 11:17:54 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2F74E30082A; Wed, 14 May 2025 13:17:53 +0200 (CEST)
Date: Wed, 14 May 2025 13:17:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <20250514111753.GA16434@noisy.programming.kicks-ass.net>
References: <20250509113659.wkP_HJ5z@linutronix.de>
 <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>
 <20250513140310.GA25639@noisy.programming.kicks-ass.net>
 <alpine.LSU.2.21.2505131604530.19621@pobox.suse.cz>
 <aCRnsN-2x4vpjpCx@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCRnsN-2x4vpjpCx@pathway.suse.cz>

On Wed, May 14, 2025 at 11:51:44AM +0200, Petr Mladek wrote:

> IMHO, it might be easier when it goes via tip. Peter, feel free to
> take it.

Done!

> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Tested-by: Petr Mladek <pmladek@suse.com>

For some reason b4 didn't pick up these tags, added them manually and
force pushed it again.

