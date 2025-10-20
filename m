Return-Path: <live-patching+bounces-1773-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1BE6BF30B1
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 20:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF142480271
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 18:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475C62D3A70;
	Mon, 20 Oct 2025 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blpO++iQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226DB2C327D
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760986427; cv=none; b=BRVtM3QFXcOvD1P3gytwyBPTSE4o+ySAxl5lQRHOL+ZkNCeYd/Yb6vitkuTOrh46rWFwFh8syxgnLJVcFDuofjiKjwZsEKSnVMpyUWMHVBfu7XOfscoyRN7C6XBDU0tx+/oNr6CkScwKJciNTcnV13WUW3pCNCmufBIgkKXeZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760986427; c=relaxed/simple;
	bh=qqy20fC02BwQYeXyD7Az9uI6m1coRlj3hUMxYhXIsIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sfPn1CtwHlE9qnMFTaN92aIVnbYS87vlfE9Jd/gdTAE7i/hgFoyzHe3goV5ZWFYOVnGZXilvHd0edE2/VdXQEjPZ9VVUDsQBdI/xxaw2kvfADGvGHJY5lhYdM2yzZsWxNRC/XuGd9LDcHIqE9CyeKlJmK3diH9XwLzh0W32eEl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blpO++iQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09BFC16AAE
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760986426;
	bh=qqy20fC02BwQYeXyD7Az9uI6m1coRlj3hUMxYhXIsIg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=blpO++iQUi01kM8jPOHHKKSe+lkJSrLVlh4/mAARhlDTFhN9i3OR0VWP0836hJ4xK
	 1U0vla7yqqVj0BdVsfhuN8rOYTlGsrc2XmLPnrDETsOIYEEcZNFXsf9uQaaiN6OmMC
	 FEND33c6vnayavzO406RZIboHzRocQs6bwRk787BjjYnjPGnJ4bi6OzlN1L3Bk41uU
	 drCJx+r7LX6nr+znngceaw25R7YuK4BtvqtJTPHKhhGjEea4qwVA3wxuEU4k0ijaDU
	 2HbBAjNr2bhYq5or5lJV5VRYXcKyFSYNXx9Q7kajAukN0rUeXRVbzNH4/vbBls3wJg
	 VBC4gU6Asr1+A==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-88fa5974432so645845485a.2
        for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 11:53:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXJeuHMNmuUybLbmE3AIIaKEPkX4z5busokPVRbIcXCx35bfNAoUI+c3yZRl4ZhEd3FJ3AzWqu3Zq+HaHip@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0/S8EVkFWx7S+1DA2R/Br7+57/B0lcfBDz5OX3dUfPo7iFAHN
	jmH+UKK2WAwhFwP4JGobOarMvqMXRzf+PMNF216hkldlJsU/KeLvLoXE57lUQ6OTijw26EsvdrJ
	6HkMmSY3O2kzHZVIQbdDujGPT+B57iaY=
X-Google-Smtp-Source: AGHT+IF8RYk+Yp9iPXvf5Uq3ECDBLVHgI8X2lIIc6DBmKTxaN49Dxnez02PekcaeApGBs1fYAGEpZV1X3U6Wcb9iez0=
X-Received: by 2002:ac8:7c55:0:b0:4e8:b5e8:2a1a with SMTP id
 d75a77b69052e-4e8b5e82f32mr92151831cf.21.1760986425672; Mon, 20 Oct 2025
 11:53:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz> <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com> <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
 <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com> <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com> <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com>
In-Reply-To: <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Mon, 20 Oct 2025 11:53:34 -0700
X-Gmail-Original-Message-ID: <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
X-Gm-Features: AS18NWBcnF6hn6xoxe2Ws1_Cnvr5ZY77sM0_khgt9MIi3RA70IdlmNFCoYA6IrY
Message-ID: <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 9:45=E2=80=AFAM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
>
> On 10/20/25 12:03, Song Liu wrote:
> > On Mon, Oct 20, 2025 at 7:56=E2=80=AFAM Andrey Grodzovsky
> > <andrey.grodzovsky@crowdstrike.com> wrote:
> > [...]
> >>> If you build the kernel from source code, there are some samples in
> >>> samples/livepatch that you can use for testing. PS: You need to enabl=
e
> >>>
> >>>     CONFIG_SAMPLE_LIVEPATCH=3Dm
> >>>
> >>> I hope this helps.
> >> Thanks Song, working on repro, kernel rebuilt, test module is loading
> >> but, bpftrace is refusing to attach now to fentries/fexits claiming th=
e
> >> costum kernel is not supporting it. It did
> >> attach in the case of stock AWS kernel i copied the .config from. So
> >> just trying to figure out now if some Kcofnig flags are missing or
> >> different . Let me know in case you manage to confirm yourself in the
> >> meanwhile the fix works for
> >> you.
> > Yes, it worked in my tests.
> >
> > [root@(none) /]# kpatch load linux/samples/livepatch/livepatch-sample.k=
o
> > loading patch module: linux/samples/livepatch/livepatch-sample.ko
> > [root@(none) /]# bpftrace.real -e 'fexit:cmdline_proc_show
> > {printf("fexit\n");}' &
> > [1] 388
> > [root@(none) /]# Attached 1 probe
> > [root@(none) /]# bpftrace.real -e 'fentry:cmdline_proc_show
> > {printf("fentry\n");}' &
> > [2] 397
> > [root@(none) /]# Attached 1 probe
> >
> > [root@(none) /]# cat /proc/cmdline
> > this has been live patched
> > fentry
> > fexit
> >
> > Thanks,
> > Song
> >
>
> Verified the failures I observe when trying to attach with BPF trace are
> only in presence of patch you provided.
> Please see attached dmesg for failures. Initial warning on boot.
> Subsequebt warnings and errors at the point i try to run
> sudo bpftrace -e "fexit:cmdline_proc_show { printf(\"fexit hit\\n\");
> exit(); }"
>
> sudo: unable to resolve host ip-10-10-115-238: Temporary failure in name
> resolution
> stdin:1:1-25: ERROR: kfunc/kretfunc not available for your kernel version=
.
>
> ubuntu@ip-10-10-115-238:~/linux-6.8.1$ sudo cat
> /sys/kernel/debug/tracing/available_filter_functions | grep
> cmdline_proc_show
> sudo: unable to resolve host ip-10-10-115-238: Temporary failure in name
> resolution
> cat: /sys/kernel/debug/tracing/available_filter_functions: No such device
>
> After reboot and before trying to attacg with bpftrace,
> /sys/kernel/debug/tracing/available_filter_functions is available and
> shows all function.
>
> Using stable kernel from
> https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.8.1.tar.gz for build=
.
> FTRACE related KCONFIGs bellow

I can see the similar issue with the upstream kernel. I was testing on
stable 6.17 before just know because of another issue with upstream
kernel, and somehow 6.17 kernel doesn't seem to have the issue.

To fix this, I think we should land a fix similar to the earlier diff:

diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
index 42bd2ba68a82..8f320df0ac52 100644
--- i/kernel/trace/ftrace.c
+++ w/kernel/trace/ftrace.c
@@ -6049,6 +6049,9 @@ int register_ftrace_direct(struct ftrace_ops
*ops, unsigned long addr)

        err =3D register_ftrace_function_nolock(ops);

+       if (err)
+               remove_direct_functions_hash(hash, addr);
+
  out_unlock:
        mutex_unlock(&direct_mutex);


Steven,

Does this change look good to you?

Thanks,
Song

