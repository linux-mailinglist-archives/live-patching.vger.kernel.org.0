Return-Path: <live-patching+bounces-1342-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A60DA71995
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 15:58:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E701887EBF
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 14:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AD91F3B98;
	Wed, 26 Mar 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NpJx9C0J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0deEB+x";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NpJx9C0J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0deEB+x"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192CB1F099F
	for <live-patching@vger.kernel.org>; Wed, 26 Mar 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000755; cv=none; b=ukkdMzCNxdvTcwsSBpLPMkAURBs+GF1WJjl5RP0STCeaM9p9+izdpeeWZnp0hbEVxqlYYDmbjUWo7fwZ2p9sGGUmE38eOIaZtyo3ktzygLtg9B1STWXc7etYLdUb8XFZXCi2MW8pl2W6p2hdNEU3HQOaN5RNc0XR5YbQWRmajl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000755; c=relaxed/simple;
	bh=oRQfEWTYZ08/oOm0K0ADbcTp+N32/kFThtFnAan3zDw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DYu6j8Kp2pYl9mUSzfRHfbCA/jZyMRMaFqQNddWRgNQNETMblAQILk0PtCavonkK7dM8LyMFH3KD1LNz4Vg3IZN0qv84ty8hzWYwA29UXu4E4nOpEMDfAQee97WuQ9cqv839Uhdywl2WV4z4fzF2X4N5Ms8kLyc7f8HWcEj3w+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NpJx9C0J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0deEB+x; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NpJx9C0J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0deEB+x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C9AE2118D;
	Wed, 26 Mar 2025 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743000752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rxlJlxjV8vCzmndxFu0DV5OLDzz/TCyjVVPXeZeSLIg=;
	b=NpJx9C0JZ6V3mm52BM8cied6rmghj232WOpri3JEJC/eiwrrsyYmboL+cPskjsIy9Ih4kM
	P2rgpCcfT4uPflhJWWXMCmB4kTpsXXyqoK76MKpGp1L9Qy67jXAzQazft73R91ZI6gnFB1
	OjwsZ8sguTCRzc/9YLcbumABjTh3zPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743000752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rxlJlxjV8vCzmndxFu0DV5OLDzz/TCyjVVPXeZeSLIg=;
	b=N0deEB+xX+1esDSDaDlR4tBPTSJ2GMDEm1K4FXjQj5iWe9II4zdDvfNDwKWGh+7HAWTocK
	9bdoJmR+rEqZLvAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743000752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rxlJlxjV8vCzmndxFu0DV5OLDzz/TCyjVVPXeZeSLIg=;
	b=NpJx9C0JZ6V3mm52BM8cied6rmghj232WOpri3JEJC/eiwrrsyYmboL+cPskjsIy9Ih4kM
	P2rgpCcfT4uPflhJWWXMCmB4kTpsXXyqoK76MKpGp1L9Qy67jXAzQazft73R91ZI6gnFB1
	OjwsZ8sguTCRzc/9YLcbumABjTh3zPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743000752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rxlJlxjV8vCzmndxFu0DV5OLDzz/TCyjVVPXeZeSLIg=;
	b=N0deEB+xX+1esDSDaDlR4tBPTSJ2GMDEm1K4FXjQj5iWe9II4zdDvfNDwKWGh+7HAWTocK
	9bdoJmR+rEqZLvAQ==
Date: Wed, 26 Mar 2025 15:52:32 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
    mingo@kernel.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
    dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
    mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org, 
    jikos@kernel.org, joe.lawrence@redhat.com, linux-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [RFC][PATCH] sched,livepatch: Untangle cond_resched() and
 live-patching
In-Reply-To: <20250326144212.GG25239@noisy.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.2503261547000.4152@pobox.suse.cz>
References: <20250324134909.GA14718@noisy.programming.kicks-ass.net> <Z-PNll7fJQzCDH35@pathway.suse.cz> <20250326103843.GB5880@noisy.programming.kicks-ass.net> <alpine.LSU.2.21.2503261534450.4152@pobox.suse.cz>
 <20250326144212.GG25239@noisy.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 26 Mar 2025, Peter Zijlstra wrote:

> On Wed, Mar 26, 2025 at 03:37:50PM +0100, Miroslav Benes wrote:
> 
> > If I remember correctly, we had something like this in the old kGraft 
> > implementation of the live patching (SUSE way). We exactly had a hook 
> > somewhere in the kthread freezing code. This looks much cleaner and as far 
> > as I know the fridge went through improvements recently.
> 
> Yeah, I rewrote it a while ago :-)

Right :)
 
> > Peter, so that I understand it correctly... we would rely on all kthreads 
> > becoming freezable eventually so that both suspend and livepatch benefit. 
> > Is that what you meant by the above?
> 
> Well, IIRC (its been a while already) all kthreads should have a
> FREEZABLE already. Things like suspend-to-idle don't hit the hotplug
> path at all anymore and everything must freeze, otherwise they fail.

Good.

> I was more meaning the time-to-freeze; if some kthreads take a long time
> to freeze/patch then this would want improving on both ends.

Makes sense.

So I am all for the patch. See my comment elsewhere though.

Miroslav


