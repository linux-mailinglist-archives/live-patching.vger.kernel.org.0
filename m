Return-Path: <live-patching+bounces-1431-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5993AB67DC
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 11:45:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA72E3A4436
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 09:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFD5231A21;
	Wed, 14 May 2025 09:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QmlzMFpi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8AC230278
	for <live-patching@vger.kernel.org>; Wed, 14 May 2025 09:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747215896; cv=none; b=hj13aQ4+80xlMIqIPlrjV3RblV/JDRGjb95Sdi+7WjGdwJwCMX99rwDazyNQVX2DT+IeNSrgETPU5m8xfU9GDpqk83IyzpfJM91+eK979WA9rjymSiXM6ILJtECYpXvBbhP/uv3atjT0NqYuCM1AoYMUA+L9tguvSd5AJ/vGQIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747215896; c=relaxed/simple;
	bh=Zn4zpe0vq/Cog1u5FSWrBKwbijYy0b4wPlo2LEAa4BA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aq22Z+aSoUGxnJfKbNhJKpSRsfZ9FR4KGsoI3R9ROPuzGaDMLfyNUR75VqN5LfivgjeNt+0UIcR8MyDqIKn5p4/xPGmGuFHoabv4FoL3n8q9CC6PmRmuuLVycw6w8aKn1Ureph+JxsPxNWuMrXjrpmR2nF6SnGnS8kkC2GvZ34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QmlzMFpi; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5fbf534f8dbso10073325a12.3
        for <live-patching@vger.kernel.org>; Wed, 14 May 2025 02:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747215893; x=1747820693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2q9R53V/fDMcpMH8guJFLg3icpz0ciPeizfC22LHQ0I=;
        b=QmlzMFpijvPGx32siDe6hsh8cNyMuvXMDukDf/FPV5ZwkCgPYy4hGgCJTII9BZ1JLk
         Rpj5MD23jFDZwb+3W9yuYkmhpr2rbr5AKo6wnkAatNjhz9DqHCMQGtSrHg4WR+Z8EJRz
         GI2cKZm4TbIms/DdBfunPzVLG8umBhKZ2WVorxMklrFyngb/WO8HrQ3dOf51CV+21425
         WaBZQ207R/Ne5/hmArbo71cywNPAe3kLrDZXuEqK2L9VKo+QXZhXJuhOtr4LuRrH/C8Q
         6tQUnW0XahIeqSagZH0uk4P1OXnYeC2Ag/73iAPAE5MgoAhF0/DbAISAi+8+2vwkW2Tv
         OOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747215893; x=1747820693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2q9R53V/fDMcpMH8guJFLg3icpz0ciPeizfC22LHQ0I=;
        b=i7kKcLv0vD5ENwoTNUvuqXFZJ81Bv68ZPpClaVM2gjINdvdjVHzjJXIvPcdiNO8KuF
         Y1qXhr4ihl9u1dBKFgeg2jTTEMUFIyBb83LgEbW73kRMgcvtoyO7FNkbqzk4k3mXHB2z
         x3/+phygK4oALfJqLH5kQxD3OAqHwC7nGdTbiDCTJmuoHAvCan2ebi+bROGs6OyyfSk7
         bY6zmto1SlY4V6WOs1wwuCtRBXkj+W8zAC9VldH82BUEye0vgGPqWOr+k5bO6ZqCcbSK
         ypXtQIB1mrwo6RD1fPV8RxsjB+I1wynZk9D9XJ2cdzbKxVjXOlTwNnhpRVXkGfNDDQXo
         hqCA==
X-Forwarded-Encrypted: i=1; AJvYcCU99ZtzhEcDHQkxpAgrsBGqev+q2b88k8NY5ho14KrxYXx9lPU+9EZol+E+XRau8RdSrx/kbxYhc1tgwMp5@vger.kernel.org
X-Gm-Message-State: AOJu0YxF5utpwcg8NlRt23cfRBdZqzfzl37wGP0iFL8GK6OsT5xqnSOD
	/gzMXCiZYYDXY4gWxeR6IY1tHVKn2Pzw0aU3pBICMoytcChfgPEZkLaaFl3Jl3k=
X-Gm-Gg: ASbGncv4LzuqVhETin9c+aj9ySEsjVQ3co6d61Fe8PkDzTOdkpaID05lVpSzYJSNa0f
	ZRSwaXmz0qGvlTFRMVVwnHzlgfdhpYAPDr6bPHLYBZDOJJX0fLInfTFORyz+GjdBDG3k9hZ2rCS
	VHTE77xHaLVGnswQyMRME9uyvvtZIkkmIOuqqh+zMigBMJviggp0eBYiKuhktmjOI5bEFVJO/p8
	EG5JSeLv8txK9DGJzEhn5Aj/f2rQNJhZUM75ZEE7OtdSu25QUBOv5OLfqhhxZY69nZ8MyC+BMrU
	im29fOelVr1FFSiHK626zP24wshD5klX28H+H4vC+6rj1TWvqSSMeg==
X-Google-Smtp-Source: AGHT+IE96oxIRsIzDau62o1mwFDV6pP1y6bpVXTUnqkiWb6obYj5PC8SIj6KP+Uab5KGwnBB/dtV+Q==
X-Received: by 2002:a05:6402:268f:b0:5f8:5672:69cb with SMTP id 4fb4d7f45d1cf-5ff986a37b1mr1905243a12.5.1747215892878;
        Wed, 14 May 2025 02:44:52 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ff9ab7e329sm822698a12.37.2025.05.14.02.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 02:44:52 -0700 (PDT)
Date: Wed, 14 May 2025 11:44:49 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <aCRl9h_p3Yu8Gxci@pathway.suse.cz>
References: <20250509113659.wkP_HJ5z@linutronix.de>
 <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>

On Tue 2025-05-13 15:34:50, Miroslav Benes wrote:
> On Fri, 9 May 2025, Sebastian Andrzej Siewior wrote:
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> > needs to stop relying on cond_resched() to make forward progress.
> > 
> > Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> > live-patching, the freezer needs to be able to stop tasks in a safe /
> > known state.
> > 
> > @@ -365,27 +356,20 @@ static bool klp_try_switch_task(struct task_struct *task)
> >  
> >  void __klp_sched_try_switch(void)
> >  {
> > +	/*
> > +	 * This function is called from __schedule() while a context switch is
> > +	 * about to happen. Preemption is already disabled and klp_mutex
> > +	 * can't be acquired.
> > +	 * Disabled preemption is used to prevent racing with other callers of
> > +	 * klp_try_switch_task(). Thanks to task_call_func() they won't be
> > +	 * able to switch to this task while it's running.
> > +	 */
> > +	lockdep_assert_preemption_disabled();
> > +
> > +	/* Make sure current didn't get patched */
> >       if (likely(!klp_patch_pending(current)))
> >                return;
> 
> This last comment is not precise. If !klp_patch_pending(), there is 
> nothing to do. Fast way out. So if it was up to me, I would remove the 
> line all together.

I think that this is not just a speedup. Right below is a read memory
barrier. It says that we need to read TIF_PATCH_PENDING here to
make sure that klp_target_state is correct after the barrier.

Anyway, I agree that the comment is confusing and might be removed.
The comment above the memory barrier might/should be enough.

Best Regards,
Petr

