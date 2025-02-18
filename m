Return-Path: <live-patching+bounces-1213-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1987EA390E1
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 03:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A83A7A23C6
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 02:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAD613B7A3;
	Tue, 18 Feb 2025 02:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5BvZu24"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C62A4C9F
	for <live-patching@vger.kernel.org>; Tue, 18 Feb 2025 02:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739846264; cv=none; b=rt+xEcBMHzKyepheA1uiyx5ZYN+qgKJ6ZbLhclb8t0ax75wj5ufDYShV9ensxOiki1WWZ7Bhi+f0PIxp5jkK5hZ+z2R7nSDm79DL3y8F33uXdMv8nPI12lQ1nf+ZCXMNGexXSNAlWJMkzGfvASd22ac40LtqrxZRhZqW06dIvOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739846264; c=relaxed/simple;
	bh=tT6+HjaLgRfQzafu9scfWa2gN0DIxz9Zswgdbz4LG5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sb/D9kNanAKOJpRhDcraftY89HJPBnS+eWcuk/XE9v+N/x4LXVUNcssVCxMIFwEwBPReW97Lmc7S2+TGpimPiMf8QEF9q5o8RKcC7HP2htkOD8qTaE2PED6BYMFJbEVKi3m01OKjk1GVe2kfzqliDlXU+s3hi+eWjzOFnLvRZ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a5BvZu24; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6e67f377236so13485536d6.1
        for <live-patching@vger.kernel.org>; Mon, 17 Feb 2025 18:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739846261; x=1740451061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h15lWJdql5HdpktTnNAK+VrzJAT/w4q07J3Wy8gIV4o=;
        b=a5BvZu245yXtj/HRcnabwR1Hz8Yth64356n19GUdmnaWemQgKbaVqhZVZNEt4uf9KZ
         eSnfqIVMN0YGiYQelhq3pEc6ZnWZ8NsIIB9bT1ZPBSchQabxawhFRGHwgZWkvjFbrL3A
         4+bxf/brc0ls0E9AKAIyK229em9nD8sJAZus+9ng/HyXjwrEmnQg8cHkIGk3wQYC0QOf
         alew9i9+v+W/GYaDfJ/NdvVT/IqpaUuGdr9wK75axQ6YIQzSzUAvCkT8mxoP2gYsqmaZ
         8rV9anTt5bfYkr+zzSV/i/36UKtXoz/hlqfF2NkEqQiU4qcwmfw9QhmqaXI+ivO8qjag
         ngwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739846261; x=1740451061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h15lWJdql5HdpktTnNAK+VrzJAT/w4q07J3Wy8gIV4o=;
        b=wSBMjdojycSHcQs6eMJUN7wCuzdWIzvyK4jfZTTQ3ATKSTUHX20+LDOKkobYPH0/7K
         JWeR3R7E8j3msXH5ut5SGJQPpIEQeLjU5Hzsp9hex9ADQ/SGRPF/Q66VLyBZA0Vp6obp
         0Y4OzBFaJqsGQoV5gJZx5Rt7htiU/bmmQQG79ho9fI88TSUMni97gNit4rxlDK/7YeOf
         JxNpho0xuchLGS7DFdne+mptdMBEFdX0fDdAQVEVu9AMgMQtP2k/mqRHD7Yn+GaM7NxZ
         mErSKT6+2Yr5ch7m/1P+ynn240vBCIkjCJQbVgbdw2zlmsO+zxZnfvKe7rWo/fLtOAm/
         0exg==
X-Forwarded-Encrypted: i=1; AJvYcCUNDLyrpSvWGzuZ0JVNxhpBvr79KWzGRLSGFp8oOr4DaAYBbuJt3lv7XggqT4FiBmSUHt0p5Dz9bfV3Agks@vger.kernel.org
X-Gm-Message-State: AOJu0YwDhqBjpBHhQw1BDrHFJ74lxSM6pPFbMt/y+wMHPsDfUSsTQfyz
	B6biBiuRcX/cIjwOO3gMc7O8O/a1sVaxWwySEuD3zJOw1JIqo7F11qN9YEC3NA9ysd4sRkctdI0
	GLLxvEBfLjNr8te+tgL1D0kTyMvlj+8YopHU=
X-Gm-Gg: ASbGnctW+KLLcZh2EVcIykA0F/q4dpz6PBuIjDg9UZxQ02qMAGdgmGH1r9ueeFQz4h0
	gPN1SOOn8ATVj1bH4TFLqSg2XWUtC3ndJ2+IldZOsLAMSZ1+VniBD0o+Wd9hFDGfCaO8Rflq8
X-Google-Smtp-Source: AGHT+IGOzzezdLP1oRil/Rv/keNn4T+thYyzWh7NVO7RmtfQJxlwMwW4QQk7PMKkGsWOctddLbLy12MO4VRhTnnSxD8=
X-Received: by 2002:ad4:5aed:0:b0:6e6:5d9a:9171 with SMTP id
 6a1803df08f44-6e66ccd4bd0mr198673646d6.23.1739846261528; Mon, 17 Feb 2025
 18:37:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe> <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz> <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
 <Z62_6wDP894cAttk@pathway.suse.cz> <20250213173253.ovivhuq2c5rmvkhj@jpoimboe>
 <Z69Wuhve2vnsrtp_@pathway.suse.cz> <20250214181206.xkvxohoc4ft26uhf@jpoimboe>
In-Reply-To: <20250214181206.xkvxohoc4ft26uhf@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 18 Feb 2025 10:37:04 +0800
X-Gm-Features: AWEUYZmZ9uq0Rf9wfKSCa5CFPOaMj6_JPL2DQ-xLPNMzfWMN6kzGofrEqAtJK-g
Message-ID: <CALOAHbBXkaTtO-h_+3Bzs9s5Hf6ErwcvutnEEiiz+qyUPzfxFw@mail.gmail.com>
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2025 at 2:12=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Fri, Feb 14, 2025 at 03:44:10PM +0100, Petr Mladek wrote:
> > I guess that we really could consider the new task as migrated
> > and clear TIF_PATCH_PENDING.
> >
> > But we can't set child->patch_state to KLP_TRANSITION_IDLE. It won't
> > work when the transition gets reverted. [*]
>
> Hm, why not?  I don't see any difference between patching or unpatching?
>
> klp_init_transition() has a barrier to enforce the order of the
> klp_target_state and func->transition writes, as read by the
> klp_ftrace_handler().
>
> So in the ftrace handler, if func->transition is set and the task is
> KLP_TRANSITION_IDLE, it can use klp_target_state to decide which
> function to use.  Its patch state would effectively be the same as any
> other already-transitioned task, whether it's patching or unpatching.
>
> Then in klp_complete_transition(), after func->transition gets set to
> false, klp_synchronize_transition() flushes out any running ftrace
> handlers.  From that point on, func->transition is false, so the ftrace
> handler would no longer read klp_target_state.
>
> > [*] I gave this few brain cycles but I did not find any elegant
> >     way how to set this a safe way and allow using rcu_read_lock()
> >     in klp_try_complete_transition().
> >
> >     It might be because it is Friday evening and I am leaving for
> >     a trip tomorrow. Also I not motivated enough to think about it
> >     because Yafang saw the RCU stall even with that rcu_read_lock().
> >     So I send this just for record.
>
> Even if it doesn't fix the RCU stalls, I think we should still try to
> avoid holding the tasklist_lock.  It's a global lock which can be
> contended, and we want the livepatch transition to be as unobtrusive as
> possible.

I agree. Since it's feasible to eliminate this global lock, I think
it's worth pursuing this optimization.

>
> If the system is doing a lot of forking across many CPUs, holding the
> lock could block all the forking tasks and trigger system-wide
> scheduling latencies.  And that could be compounded by the unnecessary
> transitioning of new tasks every time the delayed work runs.


--
Regards

Yafang

