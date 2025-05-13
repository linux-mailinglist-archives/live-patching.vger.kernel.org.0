Return-Path: <live-patching+bounces-1427-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C604AB56B5
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 16:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E34F3A419A
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 14:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DDC28DB7C;
	Tue, 13 May 2025 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sSJ9GAbg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1mzpgkhu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="24cqX4/N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qh4ZSxBa"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D0428C84A
	for <live-patching@vger.kernel.org>; Tue, 13 May 2025 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747145155; cv=none; b=RGvN1312qr8zxRlo1f0X4RtDvW58gwTEW5c4xkQNjIAzRFhmPh8X8eap7uGx6k7j5RfSDDcCyDsNb773OXtXJbO29BRQYayCGdgJTGGOKh28W40p4xNSzIt6yUlxiHbm27tLuwMHka+VdtpopZQRTA6UFfJfv4Tjeobq0hU62Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747145155; c=relaxed/simple;
	bh=n+VdClxaSoImHt6QTrO83vynMS5vjcfmMOYmNxH3Mns=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IbcnCAh9e5OMUuGHrc6dBGa30/0flGjWyL6y4PMbY1+i7UqvbWX+N6sKpW85syMwdzAJgiMWiEG1Khi585b63exDIrcxx6SxIoKTsbXuQHG7+tn8qkjQ/jfBLKMg1BVxkwIhEz7OgrVAsZlvc/Qbcjl7NJH1Vwfahad+zdCmc6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sSJ9GAbg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1mzpgkhu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=24cqX4/N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qh4ZSxBa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E84E9211E0;
	Tue, 13 May 2025 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1747145152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIQWasuI/5nFSHu2txE7aGa/G99P4UTJOWGIf1YUyEk=;
	b=sSJ9GAbgcA0RBHE2l/pCXPAG3EUdURiSpwJhOqSEUkNI0EO2CGCPhRSF9Gkj7nkuNg22FG
	p53pmik5kz0zudrt24hpK+Pq8p4KOfX3Arf272nTFrOw+dA0EN+bYgwq7yZGjC3sxmbQEh
	hy0FdVqfN34C7lop7yAtBy6hZkNCqW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1747145152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIQWasuI/5nFSHu2txE7aGa/G99P4UTJOWGIf1YUyEk=;
	b=1mzpgkhuiApCHtX9ke9mMHFzfOkLIHONGwfIaO+MwAkp4K3ptBd8W+upKL3cuQUsIq45L+
	YpTq2W456rml+jDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1747145151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIQWasuI/5nFSHu2txE7aGa/G99P4UTJOWGIf1YUyEk=;
	b=24cqX4/Nv4i4V5EtjYOFUNJU6tNHI/Jr7DspZMyzvs+lQQRGKVVnlZdGwq7jbmQ9SW0qF5
	rIvrpgQuw1d88JBe68vJNhE3uu2doFu7EkXtk2Ofkh4SgwKG/CAHMpzlnOSyR8piG1zQzC
	b0MXy+lGop0oBGklGLcd/vf9lI40Jr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1747145151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIQWasuI/5nFSHu2txE7aGa/G99P4UTJOWGIf1YUyEk=;
	b=Qh4ZSxBag5YhIFVPUsgH/fuuEC/o2qX0SHLFWOO8slzKsEat/zXc8i1eqgQ9TeZcuotl7C
	BR/GNmNfoiMhLQAA==
Date: Tue, 13 May 2025 16:05:51 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
    Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com, 
    juri.lelli@redhat.com, vincent.guittot@linaro.org, 
    dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
    mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org, 
    jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com, 
    Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
In-Reply-To: <20250513140310.GA25639@noisy.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.2505131604530.19621@pobox.suse.cz>
References: <20250509113659.wkP_HJ5z@linutronix.de> <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz> <20250513140310.GA25639@noisy.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	URIBL_BLOCKED(0.00)[infradead.org:email,suse.cz:email,linutronix.de:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linutronix.de:email,suse.cz:email]
X-Spam-Score: -4.30

On Tue, 13 May 2025, Peter Zijlstra wrote:

> On Tue, May 13, 2025 at 03:34:50PM +0200, Miroslav Benes wrote:
> > Hi,
> > 
> > thanks for the updated version.
> > 
> > On Fri, 9 May 2025, Sebastian Andrzej Siewior wrote:
> > 
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> > > needs to stop relying on cond_resched() to make forward progress.
> > > 
> > > Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> > > live-patching, the freezer needs to be able to stop tasks in a safe /
> > > known state.
> > > 
> > > Compile tested only.
> > 
> > livepatch selftests pass and I also ran some more.
> >  
> > > [bigeasy: use likely() in __klp_sched_try_switch() and update comments]
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > 
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > 
> > A nit below if there is an another version, otherwise Petr might fix it 
> > when merging.
> 
> Petr or Peter?
> 
> That is, who are we expecting to merge this :-)

Petr Mladek if it goes through the live patching tree, you if tip. Feel 
free to pick it up :).

> Anyway, I've zapped the line in my copy.

Thanks!

Miroslav

