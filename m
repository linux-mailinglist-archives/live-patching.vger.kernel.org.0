Return-Path: <live-patching+bounces-1064-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5ABA1D83E
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 15:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A143A2F88
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 14:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0CBDDDC;
	Mon, 27 Jan 2025 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWf2Xc1J"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0218460;
	Mon, 27 Jan 2025 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737987819; cv=none; b=h71grXwEWWyb820OKraqUnSx72f9AY2Git1m0yUenDsvSs+Dz4a8DhG6WjU8uqjHFPLHeZwqxiTLp8lDeArOeuP094RUomik6hvTAalgl4MsHraGlQPxB7lRx/63/etTlDe0XuKq07dbvhiS/xn0PBTz+I0GwlXFIF8cICOLJac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737987819; c=relaxed/simple;
	bh=iao2KM9C1HUSBFd5dPBOGudxk7K3s+27p7UHrpz9Fyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KlaCUuwvOM7HPPsGApT5iCJEOO9fRuGn+7lILEbSdwsJ5jjXnquB1yqcPtHMfj4zmEj+WuDX6Db03+RW0pNUHYo1htvxOGgYttHe9Yk0sP56OareesNKjl0bO08LTHC/kIclsGQIlmY/UJohZgRp+mtUigc37le1vkj81jv7R7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWf2Xc1J; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-467838e75ffso62307841cf.3;
        Mon, 27 Jan 2025 06:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737987816; x=1738592616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kwMX9nRGkgQuXpONuR4znqiGcg1UHyjTJegj8uNM34=;
        b=QWf2Xc1JEpkHu3u+L/RBBHINk5PLVt2gLFa/5m5BmzAx8mxOO1zvKE25PUX9lwlYYI
         gIDDrWpqzgB64/1qZjfKofZyQGGG/3lGUdLNM26OYUDTQNRLB0X9soFeo5E1hVxkGz5b
         G4YiT54BalGOw+7kOcnudpfz8uv2ey+ZrGlMzEFrvHQPy5rEwtJkkH6A3QSH22ePW0Uc
         KDQ+4pYmnz8fX3kPHSg2Cc2E7Yap1hLmS5sHNxBSNAlS56UjoWdgflL1+8wTJWXx+OHW
         6ot3jnt9zFSJUWxB2MQNKoOOenIGRgtM2KhHiV/LuBRXKTFC/ESq8JC1GKGMOpL1yUD3
         pfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737987816; x=1738592616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kwMX9nRGkgQuXpONuR4znqiGcg1UHyjTJegj8uNM34=;
        b=OubknzilRZyx262SLr3W5H07bGRMRxmJ6MqF97VV40iMBlccpaxNDF9IZ2zUVKkE7T
         eX+DyEWZDOywPji7vLVvsygvb3k4JF/gdOy7QehLc6KBoZPfF4bLyyHVN1vi7sr4ztGR
         S3Jj7Gmn9GqFyHpVsGAUFu9w4GAjesVeJvHK4SVko01tpi2QX2yDsx8ldU5HzT1Sin0J
         iYjqzJn7BfUyvuC90sPVYy0ggnowdt2Lkpod5kDR2QVUpeR7+UWveXUe5Xa7TOoSDK0b
         5iVAoL9uYYrTfWNBIbZAfMGeAYSqUfIyrSvuDZwAeo2wVBQGlYYBt44JupGoSTqWJw+6
         1IoA==
X-Forwarded-Encrypted: i=1; AJvYcCVFAzqVIRV5d73lwmFFs6EWbAxd9IvnuhP9lDIfoKhATjIXXum2nBbZbpSZSXUCcKEGRIPhzong+4+kx7EnEw==@vger.kernel.org, AJvYcCWVNrNa5bR4yYg/YKwc68p5vQ8a9hI6GU1HM14mv8luGn53NqYJUWVvg5f/I8CEJU8YowqGXq14KUoj8Vg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv7VG+ym/2Y4QmC4a+gDaxvWuAeT/McyRp4yp3u3ynzNjd0d1n
	YypxufWwz/bUwTPd0Ho4jU4Pz+XaSn1qs22AcGJ2tRAI9Hqs4b9mCuYYnOsfXeDKYS/L+WLrrA4
	CqYQj4M3A8iYB1YESI1sBPVJgX6s=
X-Gm-Gg: ASbGncveuWScrj7RvZQbv4ezDqp9CUZxI+wyA3v8r863sNCZbrc8tUk4nZaGf64Nsq+
	fyfAKVYWiPZIfGLG7JQkbsCaDUqtaSavagoZpuQ0IpgwhBlvlHPr+vje6jhyRtDEl
X-Google-Smtp-Source: AGHT+IEKft7kffLkhTz12FuBJbN04mJBQ/pvgPV23sNhNjNednezrl8nWdaXOXNQJExrbJ9vtLM/HPCrx2WRIV6l2Jw=
X-Received: by 2002:a05:622a:34c:b0:467:864b:dd79 with SMTP id
 d75a77b69052e-46e12bc60camr667140201cf.49.1737987816034; Mon, 27 Jan 2025
 06:23:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
In-Reply-To: <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 27 Jan 2025 22:22:59 +0800
X-Gm-Features: AWEUYZk0p6I_SYoAj4l7LL2xICE7--21dlKNCmoa8pVlI83403ZxDnF5b4v3TII
Message-ID: <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 9:46=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Mon 2025-01-27 14:35:24, Yafang Shao wrote:
> > The atomic replace livepatch mechanism was introduced to handle scenari=
os
> > where we want to unload a specific livepatch without unloading others.
> > However, its current implementation has significant shortcomings, makin=
g
> > it less than ideal in practice. Below are the key downsides:
> >
> > - It is expensive
> >
> >   During testing with frequent replacements of an old livepatch, random=
 RCU
> >   warnings were observed:
> >
> >   [19578271.779605] rcu_tasks_wait_gp: rcu_tasks grace period 642409 is=
 10024 jiffies old.
> >   [19578390.073790] rcu_tasks_wait_gp: rcu_tasks grace period 642417 is=
 10185 jiffies old.
> >   [19578423.034065] rcu_tasks_wait_gp: rcu_tasks grace period 642421 is=
 10150 jiffies old.
> >   [19578564.144591] rcu_tasks_wait_gp: rcu_tasks grace period 642449 is=
 10174 jiffies old.
> >   [19578601.064614] rcu_tasks_wait_gp: rcu_tasks grace period 642453 is=
 10168 jiffies old.
> >   [19578663.920123] rcu_tasks_wait_gp: rcu_tasks grace period 642469 is=
 10167 jiffies old.
> >   [19578872.990496] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is=
 10215 jiffies old.
> >   [19578903.190292] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is=
 40415 jiffies old.
> >   [19579017.965500] rcu_tasks_wait_gp: rcu_tasks grace period 642577 is=
 10174 jiffies old.
> >   [19579033.981425] rcu_tasks_wait_gp: rcu_tasks grace period 642581 is=
 10143 jiffies old.
> >   [19579153.092599] rcu_tasks_wait_gp: rcu_tasks grace period 642625 is=
 10188 jiffies old.
> >
> >   This indicates that atomic replacement can cause performance issues,
> >   particularly with RCU synchronization under frequent use.
>
> Please, provide more details about the test:
>
>   + List of patched functions.

$ ls /sys/kernel/livepatch/livepatch_61_release12/vmlinux/
blk_throtl_cancel_bios,1  __d_move,1  do_iter_readv_writev,1  patched
           update_rq_clock,1
blk_mq_handle_expired,1  d_delete,1                do_exit,1
high_work_func,1        try_charge_memcg,1

$ ls /sys/kernel/livepatch/livepatch_61_release12/xfs/
patched  xfs_extent_busy_flush,1  xfs_iget,1  xfs_inode_mark_reclaimable,1

$ ls /sys/kernel/livepatch/livepatch_61_release12/fuse/
fuse_send_init,1  patched  process_init_reply,1

$ ls /sys/kernel/livepatch/livepatch_61_release12/nf_tables/
nft_data_init,1  patched

>
>   + What exactly is meant by frequent replacements (busy loop?, once a mi=
nute?)

The script:

#!/bin/bash
while true; do
        yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
        ./apply_livepatch_61.sh # it will sleep 5s
        yum erase -y kernel-livepatch-6.1.12-0.x86_64
        yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
        ./apply_livepatch_61.sh  # it will sleep 5s
done


>
>   + Size of the systems (number of CPUs, number of running processes)

top - 22:08:17 up 227 days,  3:29,  1 user,  load average: 50.66, 32.92, 20=
.77
Tasks: 1349 total,   2 running, 543 sleeping,   0 stopped,   0 zombie
%Cpu(s):  7.4 us,  0.9 sy,  0.0 ni, 88.1 id,  2.9 wa,  0.3 hi,  0.4 si,  0.=
0 st
KiB Mem : 39406304+total,  8899864 free, 43732568 used, 34143062+buff/cache
KiB Swap:        0 total,        0 free,        0 used. 32485065+avail Mem

Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                128
On-line CPU(s) list:   0-127
Thread(s) per core:    2
Core(s) per socket:    64
Socket(s):             1
NUMA node(s):          1
Vendor ID:             AuthenticAMD
CPU family:            25
Model:                 1
Model name:            AMD EPYC 7Q83 64-Core Processor
Stepping:              1
CPU MHz:               3234.573
CPU max MHz:           3854.4431
CPU min MHz:           1500.0000
BogoMIPS:              4890.66
Virtualization:        AMD-V
L1d cache:             32K
L1i cache:             32K
L2 cache:              512K
L3 cache:              32768K
NUMA node0 CPU(s):     0-127

>
>   + Were there any extra changes in the livepatch code code,
>     e.g. debugging messages?

Not at all.

>
>
> > - Potential Risks During Replacement
> >
> >   One known issue involves replacing livepatched versions of critical
> >   functions such as do_exit(). During the replacement process, a panic
> >   might occur, as highlighted in [0].
>
> I would rather prefer to make the atomic replace safe. I mean to
> block the transition until all exiting processes are not gone.
>
> Josh made a good point. We should look how this is handled by
> RCU, tracing, or another subsystems which might have similar
> problems.

I don't against this fix.

>
>
> > Other potential risks may also arise
> >   due to inconsistencies or race conditions during transitions.
>
> What inconsistencies and race conditions you have in mind, please?

I have explained it at
https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/T/#m=
5058583fa64d95ef7ac9525a6a8af8ca865bf354

 klp_ftrace_handler
      if (unlikely(func->transition)) {
          WARN_ON_ONCE(patch_state =3D=3D KLP_UNDEFINED);
  }

Why is WARN_ON_ONCE() placed here? What issues have we encountered in the p=
ast
that led to the decision to add this warning?

>
>
> > - Temporary Loss of Patching
> >
> >   During the replacement process, the old patch is set to a NOP (no-ope=
ration)
> >   before the new patch is fully applied. This creates a window where th=
e
> >   function temporarily reverts to its original, unpatched state. If the=
 old
> >   patch fixed a critical issue (e.g., one that prevented a system panic=
), the
> >   system could become vulnerable to that issue during the transition.
>
> This is not true!
>
> Please, look where klp_patch_object() and klp_unpatch_objects() is
> called. Also look at how ops->func_stack is handled in
> klp_ftrace_handler().
>
> Also you might want to read Documentation/livepatch/livepatch.rst

Thanks for your guidance.

>
>
> > The current atomic replacement approach replaces all old livepatches,
> > even when such a sweeping change is unnecessary. This can be improved
> > by introducing a hybrid mode, which allows the coexistence of both
> > atomic replace and non atomic replace livepatches.
> >
> > In the hybrid mode:
> >
> > - Specific livepatches can be marked as "non-replaceable" to ensure the=
y
> >   remain active and unaffected during replacements.
> >
> > - Other livepatches can be marked as "replaceable", allowing targeted
> >   replacements of only those patches.
>
> Honestly, I consider this as a workaround for a problem which should
> be fixed a proper way.

This is not a workaround. We should avoid replacing functions that do not
differ between the two versions. Since automatic handling is not
possible for now, we can provide a sysfs interface
to allow users to perform it manually.

>
> The main advantage of the atomic replace is simplify the maintenance
> and debugging.

Is it worth the high overhead on production servers?
Can you provide examples of companies that use atomic replacement at
scale in their production environments?

>  It reduces the amount of possible combinations. The
> hybrid mode brings back the jungle.

--=20
Regards
Yafang

