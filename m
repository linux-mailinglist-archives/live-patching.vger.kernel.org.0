Return-Path: <live-patching+bounces-1191-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB426A354FE
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 03:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 088F31891017
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 02:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BF970831;
	Fri, 14 Feb 2025 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fDIKkTSQ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA858275414
	for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 02:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739501138; cv=none; b=jVOapgFNuEL2865IaJ5ERk8yVXXdQZAa5zDCk97hKs7Vthq9a0X9XcDs0/jNb/S6MQ8r67oiY9Ozpr18IrZ/jRbqedHGQEmrmzXj2VguMpJtRIdv3Y/eb/y0r4yrmTftxQ7EcdWAgaO24RMU5gTvUI5r/9850cBKcT7MZAdx704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739501138; c=relaxed/simple;
	bh=EU53PLosLiEgpzKexqm+suuE9vmyp7+xnyyaUqJg6m0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D2HsaCsWoW9UFBc83qZLRYv0QbAiLqgBlils3XcMGMs+qiTE/pyj60xPwbSzPbfuXApdBDYit2O8PNgD6JyBr6N0oAuUCzNUsUY8+KPOWl/s14/DbEnnbyOTdsf0xhvpLuA6TpEUb4ZhVYTGXVDTEffiKKqp84jz777XWRpNy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fDIKkTSQ; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6dcd4f1aaccso28839246d6.2
        for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 18:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739501136; x=1740105936; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80yBFbxiLOXgUAzjqIMIVNP9KkxmF4uMHGCmfjSl5xs=;
        b=fDIKkTSQfNakO0HSk/M/caFS5aNSdyJLrA734/nfmlukZPYWEeA+lnNv9vY4UeL8kA
         XWuAVPUlh+aXmQLG04BH1FjLX+GUtrbSus0MQDTsVeXOk/uK0KBouS1iSizu3UXXyZFL
         X9KluXUhLqXMsgczlJgY8x0+C3gIaadna5qV8pZ9UXGU6ZHyOleM4ieSNnNsqqV4p2bW
         buHiDb8I6rdvSEC2pExAESeh0TssnLD7Q7zlAKLYmMwu9RAZJ0o/QOXF9wZLM/gERVL2
         ZcdwjC7QA5Wk0F3LvcElVTLvG82MJGBqkJ/GaXdwWd593SYVOwhUY1LFRUTSqGXG3sFF
         18vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739501136; x=1740105936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80yBFbxiLOXgUAzjqIMIVNP9KkxmF4uMHGCmfjSl5xs=;
        b=BPTuV0RFNYLq2iABNNl3WxxHhdxazisdqYg5eJCLdbGzvptPsxqfz6q6MRcV5LOP4v
         kE44W6R1xi/l7A1SB+fg6XzKbU+NqVT63dH9MUJdG9+af975CFXoperOmNK0dQeUh1U7
         W5A4KGoSVZQpqi/ehUoC5HgOczXXij7d9EmEkk0VtxUhYoyIQ5dhaFgYQlTDkSfr2Auf
         BC7hiX5Wn3PvgOpyQ+mw2eMndeYBtO9Ufp3cr9Pv7nrzZeJ/Wj+E0F5xZupPqg/n3k7w
         vB4liaxN+/K40071Gl3l54E2kKjZNVjM9iBKNTN3OHluxFjVGPn6ILggTiuMhA4IaHkM
         HRmg==
X-Forwarded-Encrypted: i=1; AJvYcCXBn/0Ho+sm2xB2RtGB3tTS4si5+RYTXDb1nTabxH+FG+wXaRcZI7ZOyT/wdb+oRVUlm1drYs6LL+Y9ul2A@vger.kernel.org
X-Gm-Message-State: AOJu0Yza2BRtpG9FIn7kt2hDDZtYOLl83ol4n0aesI8FmTdMGZupTU9O
	aQXUh2ls5us+ZD5O/djKMYoZxrb+oMim6cwLvTAsRGvc33NULW6VYCwhfFEOYxCaoahfaoO3v3f
	LGnalnsQG9k9cSh781ooZH3COrt0=
X-Gm-Gg: ASbGncsBDMUSuLO4sZJ6VmkEuIYPtS4YBcLrCkbmbLI+maAee3muYSKkehnODkYKJkO
	pjtud6YpNANZ6/GGAh4pGnp7wCfBs8HR0aI4Z3eqM0FuYqjQFzmMzqSlfK/iVB8SsvKlPwFrxe4
	k=
X-Google-Smtp-Source: AGHT+IF94kXY83F2uEmqF+RV5ZIBHgUd64wBaZUDmI47PUJhmDIf6d5b2CPY1hXxMsvR5TZEjjgIhTFrWzMS0U+fc0g=
X-Received: by 2002:a05:6214:f0b:b0:6d8:932a:eaa3 with SMTP id
 6a1803df08f44-6e65bf20eaamr107048476d6.3.1739501135629; Thu, 13 Feb 2025
 18:45:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz> <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
 <CALOAHbD+JYnC0fR=BaUvD9u0OitHM310ErzN8acPkFZZwH-dJQ@mail.gmail.com>
In-Reply-To: <CALOAHbD+JYnC0fR=BaUvD9u0OitHM310ErzN8acPkFZZwH-dJQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 14 Feb 2025 10:44:59 +0800
X-Gm-Features: AWEUYZlfGq4mYul-QSyujO969q7ZZMVTSaDe43fTI29wtjoLceGzWKSuXaXx3IE
Message-ID: <CALOAHbB46k0kqaH8BZk+iyL46bMbz03Z8sk7N+XuYM3kthTsNw@mail.gmail.com>
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 8:39=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Thu, Feb 13, 2025 at 8:32=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com=
> wrote:
> >
> > On Thu, Feb 13, 2025 at 7:19=E2=80=AFPM Petr Mladek <pmladek@suse.com> =
wrote:
> > >
> > > On Tue 2025-02-11 14:24:36, Yafang Shao wrote:
> > > > I encountered a hard lockup when attempting to reproduce the panic =
issue
> > > > occurred on our production servers [0]. The hard lockup is as follo=
ws,
> > > >
> > > > [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421=
106 is sleeping on function do_exit
> > > > [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421=
244 is sleeping on function do_exit
> > > > [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421=
457 is sleeping on function do_exit
> > > > [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422=
407 is sleeping on function do_exit
> > > > [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423=
184 is sleeping on function do_exit
> > > > [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423=
582 is sleeping on function do_exit
> > > > [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423=
738 is sleeping on function do_exit
> > > > [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423=
739 is sleeping on function do_exit
> > > > [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423=
833 is sleeping on function do_exit
> > > > [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423=
893 is sleeping on function do_exit
> > > > [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423=
894 is sleeping on function do_exit
> > > > [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423=
976 is sleeping on function do_exit
> > > > [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423=
977 is sleeping on function do_exit
> > > > [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424=
610 is sleeping on function do_exit
> > >
> > > This message does not exist in vanilla kernel. It looks like an extra
> > > debug message. And many extra messages might create stalls on its own=
.
> >
> > Right, the dynamic_debug is enabled:
> >
> >   $ echo 'file kernel/* +p' > /sys/kernel/debug/dynamic_debug/control
> >
> > >
> > > AFAIK, your reproduced the problem even without these extra messages.
> >
> > There are two issues during the KLP transition:
> > 1. RCU warnings
> > 2. hard lockup
> >
> > RCU stalls can be easily reproduced without the extra messages.
> > However, hard lockups cannot be reproduced unless dynamic debugging is
> > enabled.
> >
> > > At least, I see the following at
> > > https://lore.kernel.org/r/CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ=
+M0zgdXg@mail.gmail.com
> >
> > That's correct, this is related to the RCU warnings issue.
> >
> > >
> > > <paste>
> > > [20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
> > > [20329703.340417] livepatch: 'livepatch_61_release6': starting
> > > patching transition
> > > [20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 i=
s
> > > 10166 jiffies old.
> > > [20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 i=
s
> > > 10219 jiffies old.
> > > [20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 i=
s
> > > 10199 jiffies old.
> > > [20329754.848036] livepatch: 'livepatch_61_release6': patching comple=
te
> > > </paste>
> > >
> > > Could you please confirm that this the original _non-filtered_ log?
> >
> > Right.
> >
> > > I mean that the debug messages were _not_ printed and later filtered?
> >
> > Right.
> >
> > >
> > > I would like to know more about the system where RCU reported the
> > > stall. How many processes are running there in average?
> > > A rough number is enough. I wonder if it is about 1000, 10000, or
> > > 50000?
> >
> > Most of the servers have between 5,000 and 10,000 threads.
> >
> > >
> > > Also what is the CONFIG_HZ value, please?
> >
> > CONFIG_HZ_PERIODIC=3Dy
> > CONFIG_HZ_1000=3Dy
> > CONFIG_HZ=3D1000
> >
> > >
> > > Also we should get some statistics how long klp_try_switch_task()
> > > lasts in average. I have never did it but I guess that
> > > it should be rather easy with perf. Or maybe just by looking
> > > at function_graph trace.
> >
> > Currently, on one of my production servers, CPU usage is around 40%,
> > and the number of threads is approximately 9,100. The livepatch is
> > applied every 5 seconds. We can adjust the frequency, but the
> > difference won't be significant, as RCU stalls are easy to reproduce
> > even at very low frequencies.
> > The duration of klp_try_switch_task() is as follows:
> >
> > $ /usr/share/bcc/tools/funclatency klp_try_switch_task.part.0 -d 60
> > Tracing 1 functions for "klp_try_switch_task.part.0"... Hit Ctrl-C to e=
nd.
> >      nsecs               : count     distribution
> >          0 -> 1          : 0        |                                  =
      |
> >          2 -> 3          : 0        |                                  =
      |
> >          4 -> 7          : 0        |                                  =
      |
> >          8 -> 15         : 0        |                                  =
      |
> >         16 -> 31         : 0        |                                  =
      |
> >         32 -> 63         : 0        |                                  =
      |
> >         64 -> 127        : 0        |                                  =
      |
> >        128 -> 255        : 0        |                                  =
      |
> >        256 -> 511        : 0        |                                  =
      |
> >        512 -> 1023       : 1        |                                  =
      |
> >       1024 -> 2047       : 26665    |***********                       =
      |
> >       2048 -> 4095       : 93834    |**********************************=
******|
> >       4096 -> 8191       : 2695     |*                                 =
      |
> >       8192 -> 16383      : 268      |                                  =
      |
> >      16384 -> 32767      : 24       |                                  =
      |
> >      32768 -> 65535      : 2        |                                  =
      |
> >
> > avg =3D 2475 nsecs, total: 305745369 nsecs, count: 123489
> >
> > >
> > > I would like to be more sure that klp_try_complete_transition() reall=
y
> > > could block RCU for that long. I would like to confirm that
> > > the following is the reality:
> > >
> > >   num_processes * average_klp_try_switch_task > 10second
> >
> > 9100 * 2.475 / 1000 is around 22 second
>
> It looks like I misread the nsec as usec, so the total average
> duration is actually around 22ms. ;)
> I=E2=80=99ll double-check it to confirm.

I've confirmed that during RCU stalls, the average_klp_try_switch_task
value isn't unusually large. However, the real issue lies in the
extended duration of the klp_try_complete_transition().

- The RCU stall

[Fri Feb 14 10:14:56 2025] livepatch: enabling patch 'livepatch_61_release6=
'
[Fri Feb 14 10:14:56 2025] livepatch: 'livepatch_61_release6':
starting patching transition
[Fri Feb 14 10:15:10 2025] rcu_tasks_wait_gp: rcu_tasks grace period
32001 is 10073 jiffies old.
[Fri Feb 14 10:15:14 2025] livepatch: 'livepatch_61_release6': patching com=
plete


- klp_try_switch_task
10:17:50
     nsecs               : count     distribution
         0 -> 1          : 0        |                                      =
  |
         2 -> 3          : 0        |                                      =
  |
         4 -> 7          : 0        |                                      =
  |
         8 -> 15         : 0        |                                      =
  |
        16 -> 31         : 0        |                                      =
  |
        32 -> 63         : 0        |                                      =
  |
        64 -> 127        : 0        |                                      =
  |
       128 -> 255        : 2        |                                      =
  |
       256 -> 511        : 5        |                                      =
  |
       512 -> 1023       : 3        |                                      =
  |
      1024 -> 2047       : 806      |*                                     =
  |
      2048 -> 4095       : 30382    |**************************************=
**|
      4096 -> 8191       : 10806    |**************                        =
  |
      8192 -> 16383      : 65       |                                      =
  |
     16384 -> 32767      : 9        |                                      =
  |

avg =3D 3562 nsecs, total: 149912461 nsecs, count: 42078

The avg of klp_try_switch_task is only 3.5us.

- number of threads

Fri Feb 14 10:14:48
12106
Fri Feb 14 10:14:59
11900
Fri Feb 14 10:15:10
12004
Fri Feb 14 10:15:20
11899
Fri Feb 14 10:15:31
12293
Fri Feb 14 10:15:42
11831

At that point, the system has around 12,000 threads, so the total
duration comes out to approximately 12,000 * 3.5=C2=B5s, or about 42ms=E2=
=80=94well
below the 10s threshold.
However, the duration of klp_try_complete_transition() exceeds 10 seconds.

10:15:41
               nsecs                         : count     distribution
                   0 -> 1                    : 0        |                  =
  |
                   2 -> 3                    : 0        |                  =
  |
                   4 -> 7                    : 0        |                  =
  |
                   8 -> 15                   : 0        |                  =
  |
                  16 -> 31                   : 0        |                  =
  |
                  32 -> 63                   : 0        |                  =
  |
                  64 -> 127                  : 0        |                  =
  |
                 128 -> 255                  : 0        |                  =
  |
                 256 -> 511                  : 0        |                  =
  |
                 512 -> 1023                 : 0        |                  =
  |
                1024 -> 2047                 : 0        |                  =
  |
                2048 -> 4095                 : 0        |                  =
  |
                4096 -> 8191                 : 0        |                  =
  |
                8192 -> 16383                : 0        |                  =
  |
               16384 -> 32767                : 0        |                  =
  |
               32768 -> 65535                : 0        |                  =
  |
               65536 -> 131071               : 0        |                  =
  |
              131072 -> 262143               : 0        |                  =
  |
              262144 -> 524287               : 0        |                  =
  |
              524288 -> 1048575              : 0        |                  =
  |
             1048576 -> 2097151              : 0        |                  =
  |
             2097152 -> 4194303              : 0        |                  =
  |
             4194304 -> 8388607              : 0        |                  =
  |
             8388608 -> 16777215             : 0        |                  =
  |
            16777216 -> 33554431             : 0        |                  =
  |
            33554432 -> 67108863             : 1        |******************=
**|
            67108864 -> 134217727            : 1        |******************=
**|
           134217728 -> 268435455            : 0        |                  =
  |
           268435456 -> 536870911            : 0        |                  =
  |
           536870912 -> 1073741823           : 0        |                  =
  |
          1073741824 -> 2147483647           : 0        |                  =
  |
          2147483648 -> 4294967295           : 0        |                  =
  |
          4294967296 -> 8589934591           : 1        |******************=
**|
          8589934592 -> 17179869183          : 1        |******************=
**|

avg =3D 5630258522 nsecs, total: 22521034091 nsecs, count: 4

The longest duration of klp_try_complete_transition() ranges from 8.5
to 17.2 seconds.

It appears that the RCU stall is not only driven by num_processes *
average_klp_try_switch_task, but also by contention within
klp_try_complete_transition(), particularly around the tasklist_lock.
Interestingly, even after replacing "read_lock(&tasklist_lock)" with
"rcu_read_lock()", the RCU stall persists. My verification shows that
the only way to prevent the stall is by checking need_resched() during
each iteration of the loop.

--
Regards
Yafang

