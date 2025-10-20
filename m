Return-Path: <live-patching+bounces-1766-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18434BF24E4
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 18:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D16B9464AE1
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 16:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5EB28314A;
	Mon, 20 Oct 2025 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaQo1wuo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E122820A0
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976201; cv=none; b=bW0R7RM0w7xNa02cZ7/vMMg0eR3TXfGXUxkIavkPC76hyV9RlvtMdkslXrDeVn4RAcZ54Cbt2poolJuRwpq9jAO3i3bM/Fne9c5CzboT7zXGB8RLvnb0xWWNQhDIy9F2zk0TLY68eLwFAVt2VOHMdKuSYtW9lthZctu9JoyEFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976201; c=relaxed/simple;
	bh=yGdZ0N+AfzB30hXAzgP2LHXBuiJMPJHtuv1GYkkZxpk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fgciOX2EtnpD9b+oXfzyUgecVLJ45gRybXRUQ5Od9mPu/LynsXJr7ZflhE98xf7JThnpPUiITIrt4KYEHzKlzOC9GQ1vDG2gr46ibWC6x1SY4ILWOzphIBLBxDOyRYWmvbJiFvgoZ4cxtDZea/9iafzaG1Zf6EVIgI2JOfZ5RG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaQo1wuo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D561CC4CEFE
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 16:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760976200;
	bh=yGdZ0N+AfzB30hXAzgP2LHXBuiJMPJHtuv1GYkkZxpk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SaQo1wuoAtPB0b3ao/BTqCggRVf0HJ325eM++M0vFmpQ/vsgPf/SDU/Xh62oQdQWH
	 cTh1l7o/4UkocrjEigM1cvTngjuZVkHFARIOISdKoSqxFhU8RGm2zppkmK8LxhTo3X
	 2qA0487GuZO5zuzRACnWDP915Am5EmNhMfB1HLEHsGqpcIMKmu6eC9c7axlnDl09Jo
	 eYQ5lAGTUt56DoRtN6ndG9joJAJVn+fyWrcUZ8UAZKUlOSSdtVptgRAwz0bkk1inBq
	 +8NA60Mp+VbLJELWk4Pi2yK0bHxwVtHFL1pO7OoUuY6LHq57E8GNe3GEJUGScgsv3Z
	 CLqjeq+87vxVQ==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-54c0bac7d6bso3038413e0c.0
        for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 09:03:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU9OkQpr7N3JmYSIhTWt4SqDNLF+ovQKTBET5InoRhHIyLHT34sS7GFpHnkgEpDgFneX0MsBTCP+qeu/65O@vger.kernel.org
X-Gm-Message-State: AOJu0YzTV9BqMBftxZxWx5ivO69IAlt+SWnnjncZKVNkqS0Z7oOkRXOY
	6WMlwwdFB3WQ0oA/Wkr+sf1ScGRDiE2kE5z2LQlb0eh2FR7YTzihiU7Rpv57faWO+wjQa4xbcVN
	0AGAVyAL8F36ZAc4PZHBf2GfHIwZ9Exg=
X-Google-Smtp-Source: AGHT+IG2z08CFlLD+OvLob1we+uY25LAzGFqRGAFVqMKjjuHwVPPBI0AgWBBCeBgFf72ONChRA19YPA5cYq+S+PrvPA=
X-Received: by 2002:a05:6122:308e:b0:556:40b2:270c with SMTP id
 71dfb90a1353d-5564ef152c3mr4346834e0c.12.1760976200044; Mon, 20 Oct 2025
 09:03:20 -0700 (PDT)
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
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
In-Reply-To: <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Mon, 20 Oct 2025 09:03:08 -0700
X-Gmail-Original-Message-ID: <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
X-Gm-Features: AS18NWBHIPb_WgZzPDm53CmmVteNT2t907KgW60gJzEO2nMR_yXcR6-nmmV1O2w
Message-ID: <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 7:56=E2=80=AFAM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
[...]
> > If you build the kernel from source code, there are some samples in
> > samples/livepatch that you can use for testing. PS: You need to enable
> >
> >    CONFIG_SAMPLE_LIVEPATCH=3Dm
> >
> > I hope this helps.
>
> Thanks Song, working on repro, kernel rebuilt, test module is loading
> but, bpftrace is refusing to attach now to fentries/fexits claiming the
> costum kernel is not supporting it. It did
> attach in the case of stock AWS kernel i copied the .config from. So
> just trying to figure out now if some Kcofnig flags are missing or
> different . Let me know in case you manage to confirm yourself in the
> meanwhile the fix works for
> you.

Yes, it worked in my tests.

[root@(none) /]# kpatch load linux/samples/livepatch/livepatch-sample.ko
loading patch module: linux/samples/livepatch/livepatch-sample.ko
[root@(none) /]# bpftrace.real -e 'fexit:cmdline_proc_show
{printf("fexit\n");}' &
[1] 388
[root@(none) /]# Attached 1 probe
[root@(none) /]# bpftrace.real -e 'fentry:cmdline_proc_show
{printf("fentry\n");}' &
[2] 397
[root@(none) /]# Attached 1 probe

[root@(none) /]# cat /proc/cmdline
this has been live patched
fentry
fexit

Thanks,
Song

