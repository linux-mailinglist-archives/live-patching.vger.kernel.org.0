Return-Path: <live-patching+bounces-1179-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 535AAA33F34
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 13:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8A96188D72A
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 12:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0D6227EB1;
	Thu, 13 Feb 2025 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdRK0t0p"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6394E227E90
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 12:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739449978; cv=none; b=uvJbmmD2kB2bsn3rsRpjvyXcdK8emT/C+Dxi9CBR18Hup/Q/m3Vkd92xvpZCdf7VaZHYg9aXLEPDgZys+XlsBFe0jlWw5xdMvWd/yhWJ+qIKvGUecV0YjaTpBsegV6fVNvNfjXVpxPTNhRb/GC94qunW/S5rv3ujywU+9Xk5Jz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739449978; c=relaxed/simple;
	bh=wFD+vLetKrt7ccoObnD7D9cUV+9vXGzFS/zayJK0WpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8GwlbRCG77oS/bCXL9eX81KjrQwKRfXuPLAcWkCA6VBBfveEiO5FzUdJPlH3ZsG2F9IazI30Oq71tavI0T60EVBK9YY+8ecEpnUwvggrT3vAdbFkSzl0xmOv44ZA7GJuf9ayXGon++kyBXBi6fkRPmii2jrBFsJ9hjgr1qyiWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdRK0t0p; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6e4565be0e0so9575856d6.3
        for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 04:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739449975; x=1740054775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0K3frho1Yd9DhysjsLrV9ue9h0NeWvSRZRSyhqh2Rqo=;
        b=LdRK0t0pgPdmYxmi0rq05I5blFdPBgbJ+olV7Ze7dkyHsM3FD7E4VqRNK1bjkN6QXK
         siQ6xEIVNH7T/16SMVWQXuVA1qLyJYBuUEZVYiAJYkN0A5xZU8tPaE6f1b37mjiQ5975
         E7jDzR4N8aMbMfPbW+gsG19I3ELy05y1912e9NQu4a6BYhxEvA+202iZy0Fpi3UcmQTH
         eKq+rc445Ydt5sHAlEXZcC2h8bYJiTzv5BkPS7WyrwIn6ZNYwCEaXrnrL0Ce7HZtHD9m
         AY/qqfCCghDEQ0mT2HgOUfQlxrmGq/psLnWexHniEHTLB99xuy+lurgGva2H8MBcs3L+
         5OBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739449975; x=1740054775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0K3frho1Yd9DhysjsLrV9ue9h0NeWvSRZRSyhqh2Rqo=;
        b=cDfXat5flK28V4zDZ9/sH6KhBW2oCguud/YbVRhzVKX35DT8g6uGmIoP0xm6zz/Klt
         p3u0VCgW8s3TlGzGP0nkhDONO6veIrhZa5p/6hXfu+CBc8HMKhI2kz6/DHbejutHkp0H
         zymCOgzD82j9EE1Q1olRDgcivEhHw+lYAb7cIM7LQmu9rHM5FDOQEGpfYwBYfYvVVMSx
         Duk/0RuWsNZRzc+k3JUFZ/ZMr/usiOC0XWqst312hXUFMqEKvilDECxGBy/aqhwiYwZP
         xTvaQa9x1T6a9sjPKNEaMp60L3kmcxHVwHBm9M2JYoFrTujjIr4P6Kz9yYRPTIlnVqSy
         EttA==
X-Forwarded-Encrypted: i=1; AJvYcCUCX7riT8i11ugSCaRoKXyN/a7iSzZbfC/kR1+w56cwSGdQtunQgJdV7bQNe8xSZIZyI9aSvU09zvu09h17@vger.kernel.org
X-Gm-Message-State: AOJu0YzIKPU7J0YewbewNyu8o8JU+kd0nDwwIwUNIMGCvfI/bmP1lN8F
	vrsTaTe3HXFW5ODojRTQeWyupjTplEx6s5xxKDToWCA9n6DdyCLjfkGsOHEgJsnVUpAJ+0G26GV
	HDf/56M/32+VTfgJ4nBn21p9F2LQ=
X-Gm-Gg: ASbGncuZaPNi7sYLYZl62uoGAae9A0S7XY/ql9EJPEUTgLQUCkX4oIA/DuL1K/acuyt
	GyUQcF7GYlOnB+xpKZZ1KGy47iuXRLw3BO87UYJWoimCqoPJIkj6gHOTZXiZ2+m+tkn2g3DOjqV
	o=
X-Google-Smtp-Source: AGHT+IFOLxbwMM2JO3VPJQfNoebCFabuCR3k9RMvi2kuM56OQRgS1oeYyergBV99yTnAW3DWrpWEd4iMiwoLcNlKaUU=
X-Received: by 2002:a05:6214:2421:b0:6e6:6240:afb with SMTP id
 6a1803df08f44-6e662400c24mr6633696d6.3.1739449975136; Thu, 13 Feb 2025
 04:32:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz>
In-Reply-To: <Z63VUsiaPsEjS9SR@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 13 Feb 2025 20:32:19 +0800
X-Gm-Features: AWEUYZk2-kW1QWHLxv7C-Z6_9LEB1H0xB_cwYqQv_ba-iO8KKYBrHBHt5BAfOy4
Message-ID: <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 7:19=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Tue 2025-02-11 14:24:36, Yafang Shao wrote:
> > I encountered a hard lockup when attempting to reproduce the panic issu=
e
> > occurred on our production servers [0]. The hard lockup is as follows,
> >
> > [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421106 =
is sleeping on function do_exit
> > [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421244 =
is sleeping on function do_exit
> > [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421457 =
is sleeping on function do_exit
> > [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422407 =
is sleeping on function do_exit
> > [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423184 =
is sleeping on function do_exit
> > [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423582 =
is sleeping on function do_exit
> > [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423738 =
is sleeping on function do_exit
> > [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423739 =
is sleeping on function do_exit
> > [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423833 =
is sleeping on function do_exit
> > [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423893 =
is sleeping on function do_exit
> > [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894 =
is sleeping on function do_exit
> > [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976 =
is sleeping on function do_exit
> > [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977 =
is sleeping on function do_exit
> > [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610 =
is sleeping on function do_exit
>
> This message does not exist in vanilla kernel. It looks like an extra
> debug message. And many extra messages might create stalls on its own.

Right, the dynamic_debug is enabled:

  $ echo 'file kernel/* +p' > /sys/kernel/debug/dynamic_debug/control

>
> AFAIK, your reproduced the problem even without these extra messages.

There are two issues during the KLP transition:
1. RCU warnings
2. hard lockup

RCU stalls can be easily reproduced without the extra messages.
However, hard lockups cannot be reproduced unless dynamic debugging is
enabled.

> At least, I see the following at
> https://lore.kernel.org/r/CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0z=
gdXg@mail.gmail.com

That's correct, this is related to the RCU warnings issue.

>
> <paste>
> [20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
> [20329703.340417] livepatch: 'livepatch_61_release6': starting
> patching transition
> [20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 is
> 10166 jiffies old.
> [20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 is
> 10219 jiffies old.
> [20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 is
> 10199 jiffies old.
> [20329754.848036] livepatch: 'livepatch_61_release6': patching complete
> </paste>
>
> Could you please confirm that this the original _non-filtered_ log?

Right.

> I mean that the debug messages were _not_ printed and later filtered?

Right.

>
> I would like to know more about the system where RCU reported the
> stall. How many processes are running there in average?
> A rough number is enough. I wonder if it is about 1000, 10000, or
> 50000?

Most of the servers have between 5,000 and 10,000 threads.

>
> Also what is the CONFIG_HZ value, please?

CONFIG_HZ_PERIODIC=3Dy
CONFIG_HZ_1000=3Dy
CONFIG_HZ=3D1000

>
> Also we should get some statistics how long klp_try_switch_task()
> lasts in average. I have never did it but I guess that
> it should be rather easy with perf. Or maybe just by looking
> at function_graph trace.

Currently, on one of my production servers, CPU usage is around 40%,
and the number of threads is approximately 9,100. The livepatch is
applied every 5 seconds. We can adjust the frequency, but the
difference won't be significant, as RCU stalls are easy to reproduce
even at very low frequencies.
The duration of klp_try_switch_task() is as follows:

$ /usr/share/bcc/tools/funclatency klp_try_switch_task.part.0 -d 60
Tracing 1 functions for "klp_try_switch_task.part.0"... Hit Ctrl-C to end.
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
       128 -> 255        : 0        |                                      =
  |
       256 -> 511        : 0        |                                      =
  |
       512 -> 1023       : 1        |                                      =
  |
      1024 -> 2047       : 26665    |***********                           =
  |
      2048 -> 4095       : 93834    |**************************************=
**|
      4096 -> 8191       : 2695     |*                                     =
  |
      8192 -> 16383      : 268      |                                      =
  |
     16384 -> 32767      : 24       |                                      =
  |
     32768 -> 65535      : 2        |                                      =
  |

avg =3D 2475 nsecs, total: 305745369 nsecs, count: 123489

>
> I would like to be more sure that klp_try_complete_transition() really
> could block RCU for that long. I would like to confirm that
> the following is the reality:
>
>   num_processes * average_klp_try_switch_task > 10second

9100 * 2.475 / 1000 is around 22 second

>
> If it is true than we really need to break the cycle after some
> timeout. And rcu_read_lock() is _not_ a solution because it would
> block RCU the same way.
>
> Does it make sense, please?

Makes sense.
I hope this clarifies things.

--=20
Regards
Yafang

