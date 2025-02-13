Return-Path: <live-patching+bounces-1180-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC000A33F50
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 13:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E86E188374D
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 12:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B82C21D3F7;
	Thu, 13 Feb 2025 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDoE7HP/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7982D21128A
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 12:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739450394; cv=none; b=aYpDWTWNEOoYzMk0HTCsIiHgehP0n0itx5fWmtAmc6q/XlP2rLE7hHIa7DlfpWECk4cvfh8qO9pAQ4buAO443hR7+29feUiWoiYwerJIcZjT7jmg7+v9l0T+DKEdLhi5fiRRzcTgm3tyvT/naHGbA1JmWfgBmw5nuKtYQ0/lmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739450394; c=relaxed/simple;
	bh=IEQwDvmK9UlhHy5MXvZSjwtU2sHOYWFmCKstL4Z5rm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBvNisXTmG+BkEu9Z8ycG7zuVhKh5TE34qLzDi1xva6jDXX+kIHXGk5oWY6olm2UBN+Y0EEhBLWpMFaTWkGiKHd7P//UuI9Fm3RPBpg30u1/WDh0PGb7Fd6ksvC8DU+A3fwH5MPh/Ryntu4DSS7Lvp33CS+ePZSCC8vFXGQEtCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDoE7HP/; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6e4562aa221so8882446d6.0
        for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 04:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739450391; x=1740055191; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tQ9OGudYxaJ3C3GMqmReHMtSnAnPlr3flnhnF8Y8Ck=;
        b=MDoE7HP/Sbfa1gAE5ccWrdwP+keR3vDjT4qhOGXio1ZyCtGoXBojPa1L7UyCl7ICNX
         1ZBK7T2b7xzsel7x2/2lRXZL6hi8v+istwjkBVlPXAHaE+t2PDk+OIWD62IyegtAd99Y
         ooaKX2yvIHJ63Wf0mr/QvtuS6eURvTUS8BDVzbtBJrvvHBElOqG1ZSCZGNA5MVr7i6XB
         7MwS25U12Ty1FJeU5WWap59yeQLR4XRgG9D+hSKcUvj185p9PilMZzlTxdiKfErrqWVk
         lUkmOdDytQFbgfiRAKz6OJNeV5mN7hh3KAIQxHWpBF2fgrxpINtrvOABc3UzkfZW/kOx
         vAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739450391; x=1740055191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8tQ9OGudYxaJ3C3GMqmReHMtSnAnPlr3flnhnF8Y8Ck=;
        b=wcKJEPPTsgmQWxS0AD1gEVq22LI1SUD5tJ8FNuaBMebgpSLXq6XJejZqS9lms+SCu5
         kEAhkBa62Uh96R96bOjUcLEfJqK3iJoB830BMprVTImtlzBqOPiBrQOSyQBf2cNQsnzU
         0olbHOW3D48bRC2QXmIIFGONvkP3FJNnF/l2gvjcyEIQc52GZp/xNZlELNNMnRlxJ3fK
         7vD1UwlMJ1//L7V07zgPaAtnkkiqKjbAR/OmKCUvdryj3D5/q8wJi7bwM5vM2/SOGFhf
         yh+7nx9PWURFgfEAqmuBkrL07ZbGrxR1gq0+61rZaZ7hbMnjTtF4J8fvbT7dtizIkzSA
         o2Lw==
X-Forwarded-Encrypted: i=1; AJvYcCXU09bYijWQVyA5S0gS5EYcC39p0389mxFHFVCf0c1CBRIlKLquSGJMoNWzzO9QmkCzcNg3DYgarSF+puPE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+4HrXcWUs4lwpTXwuQPF1ly2mVY9xYUTnCBiYofYnvdMgerRN
	YXYCjqLYMdwCqOm+9b0CKHVuf1TKtf9WmUhL03xJYH+CYpeulHLv2+IeGlp7cev/pI47bYQj/64
	nLJvyQA2T+Ssdcztyu1Ec4JTTJ9k=
X-Gm-Gg: ASbGncv/4687Vgqi6KscouH4d3XSwqBRqgalSDunNlbqgFTLumr6zOQojrKJBh7h2xb
	BdMXSYRrc4dfDtHp6N4+tL2BGIwwR20EKrR3YXRjIGSHlfdotcoTyEqtoHiRMy4mIA2tcmU/Ytx
	8=
X-Google-Smtp-Source: AGHT+IFf3ep7DJhD85BHlEuRpM96DBxXGOuqF2+bkoZbtEDRd5yBWwc6mWMaNXbs9ZeL1f1FF1qJxVVe1QeshNt45xM=
X-Received: by 2002:a05:6214:e49:b0:6d8:848e:76c8 with SMTP id
 6a1803df08f44-6e46edb4a74mr110965046d6.42.1739450391161; Thu, 13 Feb 2025
 04:39:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz> <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
In-Reply-To: <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 13 Feb 2025 20:39:14 +0800
X-Gm-Features: AWEUYZksttcFAGF4adIyh5EHjQ1ojizws-jK2yyaog8u2fNUsX8aTQv2izIKYYI
Message-ID: <CALOAHbD+JYnC0fR=BaUvD9u0OitHM310ErzN8acPkFZZwH-dJQ@mail.gmail.com>
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 8:32=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Thu, Feb 13, 2025 at 7:19=E2=80=AFPM Petr Mladek <pmladek@suse.com> wr=
ote:
> >
> > On Tue 2025-02-11 14:24:36, Yafang Shao wrote:
> > > I encountered a hard lockup when attempting to reproduce the panic is=
sue
> > > occurred on our production servers [0]. The hard lockup is as follows=
,
> > >
> > > [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:42110=
6 is sleeping on function do_exit
> > > [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:42124=
4 is sleeping on function do_exit
> > > [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:42145=
7 is sleeping on function do_exit
> > > [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:42240=
7 is sleeping on function do_exit
> > > [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:42318=
4 is sleeping on function do_exit
> > > [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:42358=
2 is sleeping on function do_exit
> > > [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:42373=
8 is sleeping on function do_exit
> > > [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:42373=
9 is sleeping on function do_exit
> > > [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:42383=
3 is sleeping on function do_exit
> > > [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:42389=
3 is sleeping on function do_exit
> > > [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:42389=
4 is sleeping on function do_exit
> > > [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:42397=
6 is sleeping on function do_exit
> > > [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:42397=
7 is sleeping on function do_exit
> > > [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:42461=
0 is sleeping on function do_exit
> >
> > This message does not exist in vanilla kernel. It looks like an extra
> > debug message. And many extra messages might create stalls on its own.
>
> Right, the dynamic_debug is enabled:
>
>   $ echo 'file kernel/* +p' > /sys/kernel/debug/dynamic_debug/control
>
> >
> > AFAIK, your reproduced the problem even without these extra messages.
>
> There are two issues during the KLP transition:
> 1. RCU warnings
> 2. hard lockup
>
> RCU stalls can be easily reproduced without the extra messages.
> However, hard lockups cannot be reproduced unless dynamic debugging is
> enabled.
>
> > At least, I see the following at
> > https://lore.kernel.org/r/CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M=
0zgdXg@mail.gmail.com
>
> That's correct, this is related to the RCU warnings issue.
>
> >
> > <paste>
> > [20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
> > [20329703.340417] livepatch: 'livepatch_61_release6': starting
> > patching transition
> > [20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 is
> > 10166 jiffies old.
> > [20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 is
> > 10219 jiffies old.
> > [20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 is
> > 10199 jiffies old.
> > [20329754.848036] livepatch: 'livepatch_61_release6': patching complete
> > </paste>
> >
> > Could you please confirm that this the original _non-filtered_ log?
>
> Right.
>
> > I mean that the debug messages were _not_ printed and later filtered?
>
> Right.
>
> >
> > I would like to know more about the system where RCU reported the
> > stall. How many processes are running there in average?
> > A rough number is enough. I wonder if it is about 1000, 10000, or
> > 50000?
>
> Most of the servers have between 5,000 and 10,000 threads.
>
> >
> > Also what is the CONFIG_HZ value, please?
>
> CONFIG_HZ_PERIODIC=3Dy
> CONFIG_HZ_1000=3Dy
> CONFIG_HZ=3D1000
>
> >
> > Also we should get some statistics how long klp_try_switch_task()
> > lasts in average. I have never did it but I guess that
> > it should be rather easy with perf. Or maybe just by looking
> > at function_graph trace.
>
> Currently, on one of my production servers, CPU usage is around 40%,
> and the number of threads is approximately 9,100. The livepatch is
> applied every 5 seconds. We can adjust the frequency, but the
> difference won't be significant, as RCU stalls are easy to reproduce
> even at very low frequencies.
> The duration of klp_try_switch_task() is as follows:
>
> $ /usr/share/bcc/tools/funclatency klp_try_switch_task.part.0 -d 60
> Tracing 1 functions for "klp_try_switch_task.part.0"... Hit Ctrl-C to end=
.
>      nsecs               : count     distribution
>          0 -> 1          : 0        |                                    =
    |
>          2 -> 3          : 0        |                                    =
    |
>          4 -> 7          : 0        |                                    =
    |
>          8 -> 15         : 0        |                                    =
    |
>         16 -> 31         : 0        |                                    =
    |
>         32 -> 63         : 0        |                                    =
    |
>         64 -> 127        : 0        |                                    =
    |
>        128 -> 255        : 0        |                                    =
    |
>        256 -> 511        : 0        |                                    =
    |
>        512 -> 1023       : 1        |                                    =
    |
>       1024 -> 2047       : 26665    |***********                         =
    |
>       2048 -> 4095       : 93834    |************************************=
****|
>       4096 -> 8191       : 2695     |*                                   =
    |
>       8192 -> 16383      : 268      |                                    =
    |
>      16384 -> 32767      : 24       |                                    =
    |
>      32768 -> 65535      : 2        |                                    =
    |
>
> avg =3D 2475 nsecs, total: 305745369 nsecs, count: 123489
>
> >
> > I would like to be more sure that klp_try_complete_transition() really
> > could block RCU for that long. I would like to confirm that
> > the following is the reality:
> >
> >   num_processes * average_klp_try_switch_task > 10second
>
> 9100 * 2.475 / 1000 is around 22 second

It looks like I misread the nsec as usec, so the total average
duration is actually around 22ms. ;)
I=E2=80=99ll double-check it to confirm.

>
> >
> > If it is true than we really need to break the cycle after some
> > timeout. And rcu_read_lock() is _not_ a solution because it would
> > block RCU the same way.
> >
> > Does it make sense, please?
>
> Makes sense.
> I hope this clarifies things.
>
> --
> Regards
> Yafang



--=20
Regards
Yafang

