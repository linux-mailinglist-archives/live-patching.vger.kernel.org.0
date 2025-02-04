Return-Path: <live-patching+bounces-1111-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A5ADA27FC6
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 00:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 965E6164574
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 23:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D74521C190;
	Tue,  4 Feb 2025 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xn/nUtW4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494822040B5;
	Tue,  4 Feb 2025 23:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738713144; cv=none; b=L+DhrpvYlc+6TOQWanR9w2ppGYhMzmMzhs+1hzzuP2JOB5Ks+ffyQuwFeIQnDmg7BWLPZg7iUPEHpqffeklJXzWoIwBl31Jb1ki02/9dj9rvGRTtYpFRwgT/vuS8BRWs+6j82ga3ffyCzA2Ih4WXI9mw38ysdjB6AfEgXrDWkVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738713144; c=relaxed/simple;
	bh=ROpZn/Glj3yfoqCyFJh/gnULbk/Up0rRVs9QMr9jX1k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O2YtR0wWWQV5sL5TJQSLazQdeRmWZKtgjlH/SlTNXH8oPgY0VxS9d93M1YYhWFfOdaeyzPsDT89ezWDEwA4uZs/1sBQ1z89zfhD4HLGImJIx3hm3pIFt+29tAEymtpCdhbbIzxJI6T2HL8RxS13r5PMYNX10MzIOvoKSO4jcSTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xn/nUtW4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43319C4CEDF;
	Tue,  4 Feb 2025 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738713143;
	bh=ROpZn/Glj3yfoqCyFJh/gnULbk/Up0rRVs9QMr9jX1k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Xn/nUtW4YnYf0O9ekBHYPrABh3Fc4gzqKipFxv0Ju2g36Abp1xaVEl3JEvMcNv0sJ
	 WUqNkAglYNp682uWrpzK1hmdQ4D9jXwozsc8igqsq2W3qJFZ1xShezYbkFsfeP1Ll/
	 ezu8tLOoPQYcnb0bqcO6U6DujUkB1brek4z5/7gC4zCPEWTkqI3LQ9tm58HPImBAWg
	 ABK+PEBnHYBQhb2XWmC1uPm8IywRMomVGrnfkgLMzL9feX35PnKXlmNI7IaCH6Xtn/
	 PZswfvfUv/m1tTBJLRPuQW6+PVngksGeLPRHAntPDGuca7wDJ1mnPtWvzSMLTsZ1g1
	 zAZi8oy7tqupA==
From: Puranjay Mohan <puranjay@kernel.org>
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat
 <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, "Will
 Deacon" <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org, Weinan Liu <wnliu@google.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <mb61pzfj169yq.fsf@kernel.org>
References: <20250127213310.2496133-1-wnliu@google.com>
 <mb61pzfj169yq.fsf@kernel.org>
Date: Tue, 04 Feb 2025 23:52:07 +0000
Message-ID: <mb61pwme55kuw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Puranjay Mohan <puranjay@kernel.org> writes:

> Weinan Liu <wnliu@google.com> writes:
>
>> This patchset implements a generic kernel sframe-based [1] unwinder.
>> The main goal is to support reliable stacktraces on arm64.
>>
>> On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
>> required support from objtool: it cannot generate orc unwind tables for
>> arm64.
>>
>> Currently, there's already a sframe unwinder proposed for userspace: [2].
>> Since the sframe unwind table algorithm is similar, these two proposal
>> could integrate common functionality in the future.
>>
>> There are some incomplete features or challenges:
>>   - The unwinder doesn't yet work with kernel modules. The `start_addr` of
>>     FRE from kernel modules doesn't appear correct, preventing us from
>>     unwinding functions from kernel modules.
>>   - Currently, only GCC supports sframe.
>>
>> Ref:
>> [1]: https://sourceware.org/binutils/docs/sframe-spec.html
>> [2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.org/
>>
>
> Hi Weinan,
> Thanks for working on this.
>
> I tested this set on my setup and faced some issues, here are the
> details:
>
> Here is my setup [on AWS c6gd.16xlarge instance]:
> -------------------------------------------------
>
> [root@ip-172-31-32-86 linux-upstream]# uname -a
> Linux ip-172-31-32-86.ec2.internal 6.14.0-rc1+ #1 SMP Tue Feb  4 14:15:55 UTC 2025 aarch64 aarch64 aarch64 GNU/Linux
>
> [root@ip-172-31-32-86 linux-upstream]# git log --oneline
> e9a702365 (HEAD -> master) arm64: Enable livepatch for ARM64
> 5dedc956e arm64: Define TIF_PATCH_PENDING for livepatch
> ba563b31a unwind: arm64: add reliable stacktrace support for arm64
> d807d392d unwind: arm64: Add sframe unwinder on arm64
> 7872f050b unwind: Implement generic sframe unwinder library
> 03d2ad003 unwind: add sframe v2 header
> 5e95cc051 arm64: entry: add unwind info for various kernel entries
> faff6cbc3 unwind: build kernel with sframe info
> 0de63bb7d (origin/master, origin/HEAD) Merge tag 'pull-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> 902e09c8a fix braino in "9p: fix ->rename_sem exclusion"
> f286757b6 Merge tag 'timers-urgent-2025-02-03' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> a360f3ffd (grafted) Merge tag 'irq-urgent-2025-02-03' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> bb2784d9a (grafted) jiffies: Cast to unsigned long in secs_to_jiffies() conversion
> 30d61efe1 (grafted) 9p: fix ->rename_sem exclusion
>
> [root@ip-172-31-32-86 linux-upstream]# grep SFRAME .config
> CONFIG_AS_HAS_SFRAME_SUPPORT=y
> CONFIG_SFRAME_UNWIND_TABLE=y
> CONFIG_SFRAME_UNWINDER=y
> [root@ip-172-31-32-86 linux-upstream]# grep LIVEPATCH .config
> CONFIG_HAVE_LIVEPATCH=y
> CONFIG_LIVEPATCH=y
> CONFIG_SAMPLE_LIVEPATCH=m
>
> [root@ip-172-31-32-86 linux-upstream]# as --version
> GNU assembler version 2.41-50.al2023.0.2
> Copyright (C) 2023 Free Software Foundation, Inc.
> This program is free software; you may redistribute it under the terms of
> the GNU General Public License version 3 or later.
> This program has absolutely no warranty.
> This assembler was configured for a target of `aarch64-amazon-linux'.
>
> [root@ip-172-31-32-86 linux-upstream]# gcc --version
> gcc (GCC) 11.4.1 20230605 (Red Hat 11.4.1-2)
> Copyright (C) 2021 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> Loading the livepatch-sameple module:
> -------------------------------------
>
> [root@ip-172-31-32-86 linux-upstream]# kpatch load /lib/modules/6.14.0-rc1+/kernel/samples/livepatch/livepatch-sample.ko
> loading patch module: /lib/modules/6.14.0-rc1+/kernel/samples/livepatch/livepatch-sample.ko
> waiting (up to 15 seconds) for patch transition to complete...
> patch transition has stalled!
> <4>kpatch: Livepatch process signaling is performed automatically on your system.
> <4>kpatch: Skipping manual process signaling.
> waiting (up to 60 seconds) for patch transition to complete...
>
> Stalled processes:
> 340 kdevtmpfs
> stack:
> [<0>] devtmpfs_work_loop+0x2cc/0x2d8
> [<0>] devtmpfsd+0x4c/0x58
> [<0>] kthread+0xf0/0x100
> [<0>] ret_from_fork+0x10/0x20
> module livepatch_sample did not complete its transition, unloading...
> disabling patch module: livepatch_sample
> waiting (up to 15 seconds) for patch transition to complete...
> transition complete (3 seconds)
> unloading patch module: livepatch_sample
> <4>kpatch: error: failed to load module livepatch_sample (transition stalled)

After some debugging this is what I found:

devtmpfsd() calls devtmpfs_work_loop() which is marked '__noreturn' and has an
infinite loop. The compiler puts the `bl` to devtmpfs_work_loop() as the the
last instruction in devtmpfsd() and therefore on entry to devtmpfs_work_loop(),
LR points to an instruction beyond devtmpfsd() and this consfuses the unwinder.

ffff800080d9a070 <devtmpfsd>:
ffff800080d9a070:       d503201f        nop
ffff800080d9a074:       d503201f        nop
ffff800080d9a078:       d503233f        paciasp
ffff800080d9a07c:       a9be7bfd        stp     x29, x30, [sp, #-32]!
ffff800080d9a080:       910003fd        mov     x29, sp
ffff800080d9a084:       f9000bf3        str     x19, [sp, #16]
ffff800080d9a088:       943378e8        bl      ffff800081a78428 <devtmpfs_setup>
ffff800080d9a08c:       90006ca1        adrp    x1, ffff800081b2e000 <unique_processor_ids+0x3758>
ffff800080d9a090:       2a0003f3        mov     w19, w0
ffff800080d9a094:       912de021        add     x1, x1, #0xb78
ffff800080d9a098:       91002020        add     x0, x1, #0x8
ffff800080d9a09c:       97cd2a43        bl      ffff8000800e49a8 <complete>
ffff800080d9a0a0:       340000d3        cbz     w19, ffff800080d9a0b8 <devtmpfsd+0x48>
ffff800080d9a0a4:       2a1303e0        mov     w0, w19
ffff800080d9a0a8:       f9400bf3        ldr     x19, [sp, #16]
ffff800080d9a0ac:       a8c27bfd        ldp     x29, x30, [sp], #32
ffff800080d9a0b0:       d50323bf        autiasp
ffff800080d9a0b4:       d65f03c0        ret
ffff800080d9a0b8:       97f06526        bl      ffff8000809b3550 <devtmpfs_work_loop>
ffff800080d9a0bc:       00000000        udf     #0
ffff800080d9a0c0:       d503201f        nop
ffff800080d9a0c4:       d503201f        nop

find_fde() got pc=0xffff800080d9a0bc which is not in [sfde_func_start_address, sfde_func_size)

output for readelf --sframe for devtmpfsd()

func idx [51825]: pc = 0xffff800080d9a070, size = 76 bytes
    STARTPC           CFA       FP        RA
    ffff800080d9a070  sp+0      u         u
    ffff800080d9a07c  sp+0      u         u[s]
    ffff800080d9a080  sp+32     c-32      c-24[s]
    ffff800080d9a0b0  sp+0      u         u[s]
    ffff800080d9a0b4  sp+0      u         u
    ffff800080d9a0b8  sp+32     c-32      c-24[s]

The unwinder and all the related infra is assuming that the return address
will be part of a valid function which is not the case here.

I am not sure which component needs to be fixed here, but the following
patch(which is a hack) fixes the issue by considering the return address as
part of the function descriptor entry.

-- 8< --

diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
index 846f1da95..28bec5064 100644
--- a/kernel/sframe_lookup.c
+++ b/kernel/sframe_lookup.c
@@ -82,7 +82,7 @@ static struct sframe_fde *find_fde(const struct sframe_table *tbl, unsigned long
        if (f >= tbl->sfhdr_p->num_fdes || f < 0)
                return NULL;
        fdep = tbl->fde_p + f;
-       if (ip < fdep->start_addr || ip >= fdep->start_addr + fdep->size)
+       if (ip < fdep->start_addr || ip > fdep->start_addr + fdep->size)
                return NULL;

        return fdep;
@@ -106,7 +106,7 @@ static int find_fre(const struct sframe_table *tbl, unsigned long pc,
        else
                ip_off = (int32_t)(pc - (unsigned long)tbl->sfhdr_p) - fdep->start_addr;

-       if (ip_off < 0 || ip_off >= fdep->size)
+       if (ip_off < 0 || ip_off > fdep->size)
                return -EINVAL;

        /*

-- >8 --

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ6KoKBQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2naM9AQCVxRhYApBFPGDg+i1uDN2Me6J88sm7
IVmaCz4kXrfSmAEAtLYreAOVjjJwmmOIjV6ipufys5E4bjZOBmZZ4bsajgI=
=FjuV
-----END PGP SIGNATURE-----
--=-=-=--

