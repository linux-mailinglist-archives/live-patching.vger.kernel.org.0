Return-Path: <live-patching+bounces-1163-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 221C2A33588
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 03:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8D791664D2
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A3820371F;
	Thu, 13 Feb 2025 02:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fU/py2/5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CE35949;
	Thu, 13 Feb 2025 02:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739414176; cv=none; b=bv97GU2PLt72QF4QeqlHQqft2Htbz5G/ekJ4ZHei5Fob/bjOBjjDt3ltbf+kA/8SAt1t7VrvlgZ9sPa/2Mpe9PD2uQEescnD1AS6zQxddyTwxGmFZpKI30dIVgIPldawprHLqIun0DCgIiJyR4gf07AInSWpRav8bO6O+oyD+F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739414176; c=relaxed/simple;
	bh=0LZA3Dk55GU/mf3dBAZucD5FmCQnUrHzHQPxy4DxLvM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IpgS4+3ay5Z8C7eA8DcX3WVw8/4iETYtRXTQb6UhC0BzER4fFkCn28gY1OlaRa+qSfJgct8BrLrDzJV2eJ78gvmClqzSH13FMK632oBiLH4P+0PD79d3N1Z4PZzaco/1nmmuZe5dEil/TQN8ljC7zfgT7h3aGPLJ52M3f0R/csE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fU/py2/5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B48C4CEE4;
	Thu, 13 Feb 2025 02:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739414176;
	bh=0LZA3Dk55GU/mf3dBAZucD5FmCQnUrHzHQPxy4DxLvM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fU/py2/5/h+YyeBZn5j1I1ZBMYdx/6oLJF2ObEFygqJQh8iQMr+Vgg+BCDFwnOOgN
	 j2SkOOTAr2/83vJHgknyrHpTYCUO7U2iRh+kYgGI5MzV2A2S+YNaolIktx2tB4Fyga
	 RkGbAmvbgeZ81HcwDWfAC7TCmAcWIoNCysXxk19Td0tTEiOc81OOwQ+8uGeCBIq8UQ
	 cvBs0uEhvvhX2ZkL9rbmY4vk9nUvuPS+ApGZehNtEztmwfS5Mp2Kf+vsrO2MbsYV72
	 GYc8roUFK8po3YRKD2YfLDw0NOHPPzUiWUKL/a/aPBsJPvM3PKJ9fuPRvqxPhA5C5J
	 iUJNvJndHicmw==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cfeff44d94so1235205ab.0;
        Wed, 12 Feb 2025 18:36:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/zKYHvpOTAKtVpGRRStsW5gwlmkWUbhrzwScJk88/waCPUjq7w1ynIntJhZshswu5/SiDwTOdMA1IJ1+W/tcoIQ==@vger.kernel.org, AJvYcCVSPINnZre6Rwk9L54rLhDYEZSyaaK+BMkOYg2wiYDzrcpSiitJRYhXSWKRehagGcCJ9mYfxSUOIS/nrzV8MQ==@vger.kernel.org, AJvYcCWLTYe4NQYDMaNh0ZY21218vbVaKfM3NfVBKUcC+Gpv8Kg9pACc3yjpL2o3uoOd7qeJvOcjlmTC5j0QGTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBe2j1nChI8pUtRtj9pbKlZ/91MR3F0IdBiR7C2DJx6uGbJMFi
	vxr7FanZaJIFsFvblga7JEqKYjbdEZ5eqKxPiCVuReJrkc1ntMJhjcVpR9om/6OvzuAZFZMrO5J
	9H+oXrHzjOoOLfpIPKDI4UIbMTbI=
X-Google-Smtp-Source: AGHT+IGDj2J0OHevO8QEQS0jvMevG6UrVBK1iAId7Z2DfMKsGXl46gboSFwpFlNNcT0VV1oo2M+dSTTrNrkg2Qwl3Gc=
X-Received: by 2002:a05:6e02:2145:b0:3d0:235b:4810 with SMTP id
 e9e14a558f8ab-3d17bdfa664mr53584585ab.2.1739414175488; Wed, 12 Feb 2025
 18:36:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
In-Reply-To: <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
From: Song Liu <song@kernel.org>
Date: Wed, 12 Feb 2025 18:36:04 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
X-Gm-Features: AWEUYZndb8uVj1ZCPeY1y41WIbcZA7aFbamgt0wsHnDo-n41aP3_D4efD7B1YYo
Message-ID: <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 3:49=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Wed, Feb 12, 2025 at 03:32:40PM -0800, Song Liu wrote:
> > [   81.250437] ------------[ cut here ]------------
> > [   81.250818] refcount_t: saturated; leaking memory.
> > [   81.251201] WARNING: CPU: 0 PID: 95 at lib/refcount.c:22
> > refcount_warn_saturate+0x6c/0x140
> > [   81.251841] Modules linked in: livepatch_special_static(OEK)
> > [   81.252277] CPU: 0 UID: 0 PID: 95 Comm: bash Tainted: G
> > OE K    6.13.2-00321-g52d2813b4b07 #49
> > [   81.253003] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE, [K]=3D=
LIVEPATCH
> > [   81.253503] Hardware name: linux,dummy-virt (DT)
> > [   81.253856] pstate: 634000c5 (nZCv daIF +PAN -UAO +TCO +DIT -SSBS BT=
YPE=3D--)
> > [   81.254383] pc : refcount_warn_saturate+0x6c/0x140
> > [   81.254748] lr : refcount_warn_saturate+0x6c/0x140
> > [   81.255114] sp : ffff800085a6fc00
> > [   81.255371] x29: ffff800085a6fc00 x28: 0000000001200000 x27: ffff000=
0c2966180
> > [   81.255918] x26: 0000000000000000 x25: ffff8000829c0000 x24: ffff000=
0c2e9b608
> > [   81.256462] x23: ffff800083351000 x22: ffff0000c2e9af80 x21: ffff000=
0c062e140
> > [   81.257006] x20: ffff0000c1c10c00 x19: ffff800085a6fd80 x18: fffffff=
fffffffff
> > [   81.257544] x17: 0000000000000001 x16: ffffffffffffffff x15: 0000000=
000000006
> > [   81.258083] x14: 0000000000000000 x13: 2e79726f6d656d20 x12: 676e696=
b61656c20
> > [   81.258625] x11: ffff8000829f7d70 x10: 0000000000000147 x9 : ffff800=
0801546b4
> > [   81.259165] x8 : 00000000fffeffff x7 : 00000000ffff0000 x6 : ffff800=
082f77d70
> > [   81.259709] x5 : 80000000ffff0000 x4 : 0000000000000000 x3 : 0000000=
000000001
> > [   81.260257] x2 : ffff8000829f7a88 x1 : ffff8000829f7a88 x0 : 0000000=
000000026
> > [   81.260824] Call trace:
> > [   81.261015]  refcount_warn_saturate+0x6c/0x140 (P)
> > [   81.261387]  __refcount_add.constprop.0+0x60/0x70
> > [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]
>
> Does that copy_process+0xfdc/0xfd58 resolve to this line in
> copy_process()?
>
>                         refcount_inc(&current->signal->sigcnt);
>
> Maybe the klp rela reference to 'current' is bogus, or resolving to the
> wrong address somehow?

It resolves the following line.

p->signal->tty =3D tty_kref_get(current->signal->tty);

I am not quite sure how 'current' should be resolved.

The size of copy_process (0xfd58) is wrong. It is only about
5.5kB in size. Also, the copy_process function in the .ko file
looks very broken. I will try a few more things.

Thanks,
Song

