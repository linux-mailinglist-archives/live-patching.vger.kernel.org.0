Return-Path: <live-patching+bounces-2848-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCuHNUmmC2ozKgUAu9opvQ
	(envelope-from <live-patching+bounces-2848-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 01:52:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC8857538F
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 01:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BA3EB3017094
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 23:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFAD33A9DB;
	Mon, 18 May 2026 23:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMyBxzOA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AACA3385AA
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148357; cv=none; b=t/KCnB09uBLA8NHOqcZ9OO1KqgSnDk4YTDPsdRkJq30U0pJxH6uXQZA69U71TdUqHAGD68Mr229hR+/H4A4/5rZhtapGVdkg9ro1jEIH3QNpsgpPyBwFJagbmoFZIH8ol8tRh48Gfys5WjjOS+jukeI+shTZvkqO0w0whA7/6Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148357; c=relaxed/simple;
	bh=LzSDr7EzCMMbXlGNZjr/bVxnlD3nHDjbwdYJybvX5fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mZKyitwrSsbO68M4MyriC1Z+EibViHcJORI0DdUcSOH7R9zUWd77oRuQ3ZIibWqjwdxl79BA/hbQip8SukbvuiorT6iY9T8clFVSHsEO0rtPT2JiOXY3/Mk/Hhsrum5intDFNuOsPpUZnnVuGlF2fDyVpfaYFe6Z5kxnF5kNcwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMyBxzOA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D10C2BCFB
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779148357;
	bh=LzSDr7EzCMMbXlGNZjr/bVxnlD3nHDjbwdYJybvX5fk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JMyBxzOAP2EYyOZQjWiGSpL1ZvpRaSVV2VdzwzIbJqrxaZ60e7HWOcrYOUkacMCT1
	 hjqxaQ/k4FHEI6xBVGew0uqZiGwB+Nd+PiD/gauRh5xaDO9pHhbeLWS1NxS7C9KN+t
	 LBX7rfBcuDG6WD8EUVQsMHegwl9nXGueXZ1naqGVQXLfoxZO5UUSc7yv7Y519KYBwy
	 GnR4l0FEFWsaYiJm2zpgmggXqobpNNIPrdJ6Mfca+eLxaD78/WDxm4J4jvSaQQid9P
	 oRxX7t7i20Xg8cCo/Zo44ei6Svc+vVVt91CWBIU4NPpeeWELBsL92ADgkQ853wi4GL
	 RoQdY+woDAk/w==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e5c7eb565so36149761cf.3
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 16:52:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9mIsSw0LGP9QPa7TYHjE4G/WYPPWZOYTJGBkpKjMPl/CalAHDFziYx8Oj35HP0MzxKVTCdqgD0Fqb3MzLP@vger.kernel.org
X-Gm-Message-State: AOJu0YxIq+OcaqjK4+6q7gnpSlLu/5IKuCVH2NQk5aByOJHSyw/v4FOZ
	17p7SL5hKP91u96l4reK6ZaeTyRhfC3sbNFI31R8c36lgH92TQiMnrQVzdZGOLKQ+a6Bw7zXQEc
	/n2ICTgX41D8drTDELMozUzNz1j/bRnE=
X-Received: by 2002:ac8:6908:0:b0:50d:a644:69b1 with SMTP id
 d75a77b69052e-5165a1e4c98mr215372031cf.25.1779148356534; Mon, 18 May 2026
 16:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508195749.1885522-1-sashal@kernel.org> <20260517134858.146569-1-sashal@kernel.org>
In-Reply-To: <20260517134858.146569-1-sashal@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 18 May 2026 16:52:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6CuWDqHW6VSKdrUW+pQDDFPkRo8y8PObdT+7aqp6Kx3w@mail.gmail.com>
X-Gm-Features: AVHnY4KpONS14Lrz1Zbo_iX3N5Mvgc6HXLci3oz1pYDGqZNmhQWkWSZgqaRsWoQ
Message-ID: <CAPhsuW6CuWDqHW6VSKdrUW+pQDDFPkRo8y8PObdT+7aqp6Kx3w@mail.gmail.com>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation primitive
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, bpf@vger.kernel.org, 
	live-patching@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>, 
	Anthony Iliopoulos <ailiop@suse.com>, Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2848-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 7AC8857538F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, May 17, 2026 at 6:49=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> When a kernel (security) issue goes public, fleets stay exposed until a p=
atched
> kernel is built, distributed, and rebooted into.
>
> For many such issues the simplest mitigation is to stop calling the buggy
> function. Killswitch provides that. An admin writes:
>
>     echo "engage af_alg_sendmsg -1" \
>         > /sys/kernel/security/killswitch/control
>

With v3, we hit this with fentry and killswitch on the same function:

[root@(none) /]# bpftrace -e 'fentry:security_file_open {@count+=3D1;}' &
[1] 295
Attached 1 probe
[root@(none) /]# echo 'engage security_file_open 0' >
/sys/kernel/security/killswitch/control
[   97.112360] killswitch: engage security_file_open=3D0 uid=3D0
auid=3D4294967295 ses=3D4294967295 comm=3Dbash
[   97.120766] BUG: unable to handle page fault for address: ffffffffb58550=
43
[   97.121212] #PF: supervisor read access in kernel mode
[   97.121517] #PF: error_code(0x0000) - not-present page
[   97.121710] PGD 4a76067 P4D 4a77067 PUD 4a78063 PMD 0
[   97.121710] Oops: Oops: 0000 [#1] SMP NOPTI
[   97.121710] CPU: 1 UID: 0 PID: 430 Comm: bash Tainted: G
     N H 7.1.0-rc4+ #195 PREEMPT(full)
[   97.121710] Tainted: [N]=3DTEST, [H]=3DKILLSWITCH
[   97.121710] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   97.121710] RIP: 0010:fd_install+0x1c/0x220
[   97.121710] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f
1e fa 0f 1f 44 00 00 65 48 8b 15 47 a0 a4 04 41 54 55 53 48 8b 9a 70
0a 00 00 <f6> 46 43 01 0f 85 62 01 00 00 41 89 fc 48 89 f5 65 ff 05 3d
a0 a4
[   97.121710] RSP: 0018:ffa0000000f2fe70 EFLAGS: 00010286
[   97.121710] RAX: ffffffffb5855000 RBX: ff11000100911c40 RCX: 00000000000=
00000
[   97.121710] RDX: ff110001045349c0 RSI: ffffffffb5855000 RDI: 00000000000=
00003
[   97.121710] RBP: ff11000100be81c0 R08: 0000000000000001 R09: 00000000000=
00000
[   97.121710] R10: 0000000000000001 R11: 00000000000008c2 R12: 00000000000=
00003
[   97.121710] R13: 00000000ffffff9c R14: 0000000000000101 R15: 00000000000=
00000
[   97.121710] FS:  00007fb231d4d740(0000) GS:ff110001b5855000(0000)
knlGS:0000000000000000
[   97.121710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   97.121710] CR2: ffffffffb5855043 CR3: 0000000114513002 CR4: 00000000007=
71ef0
[   97.121710] PKRU: 00000000
[   97.121710] Call Trace:
[   97.121710]  <TASK>
[   97.121710]  do_sys_openat2+0x7f/0xe0
[   97.121710]  __x64_sys_openat+0x56/0xa0
[   97.121710]  do_syscall_64+0xc4/0xf20
[   97.121710]  ? srso_alias_return_thunk+0x5/0xfbef5
[   97.121710]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   97.121710] RIP: 0033:0x7fb231e4ee1b
[   97.121710] Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25
18 00 00 00 85 c0 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00
00 0f 05 <48> 3d 00 f0 ff ff 0f 87 91 00 00 00 48 8b 54 24 28 64 48 2b
14 25
[   97.121710] RSP: 002b:00007ffefe160770 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[   97.121710] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fb231e=
4ee1b
[   97.121710] RDX: 0000000000000000 RSI: 000055616f0411d0 RDI: 00000000fff=
fff9c
[   97.121710] RBP: 000055616f0411d0 R08: 000055616f046b60 R09: 0064692d656=
e6968
[   97.121710] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00000
[   97.121710] R13: 000055616f03cb20 R14: 000055616f039310 R15: 00000000000=
00000
[   97.121710]  </TASK>
[   97.121710] Modules linked in:
[   97.121710] CR2: ffffffffb5855043
[   97.121710] ---[ end trace 0000000000000000 ]---
[   97.121710] RIP: 0010:fd_install+0x1c/0x220
[   97.121710] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f
1e fa 0f 1f 44 00 00 65 48 8b 15 47 a0 a4 04 41 54 55 53 48 8b 9a 70
0a 00 00 <f6> 46 43 01 0f 85 62 01 00 00 41 89 fc 48 89 f5 65 ff 05 3d
a0 a4
[   97.121710] RSP: 0018:ffa0000000f2fe70 EFLAGS: 00010286
[   97.121710] RAX: ffffffffb5855000 RBX: ff11000100911c40 RCX: 00000000000=
00000
[   97.121710] RDX: ff110001045349c0 RSI: ffffffffb5855000 RDI: 00000000000=
00003
[   97.121710] RBP: ff11000100be81c0 R08: 0000000000000001 R09: 00000000000=
00000
[   97.121710] R10: 0000000000000001 R11: 00000000000008c2 R12: 00000000000=
00003
[   97.121710] R13: 00000000ffffff9c R14: 0000000000000101 R15: 00000000000=
00000
[   97.121710] FS:  00007fb231d4d740(0000) GS:ff110001b5855000(0000)
knlGS:0000000000000000
[   97.121710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   97.121710] CR2: ffffffffb5855043 CR3: 0000000114513002 CR4: 00000000007=
71ef0
[   97.121710] PKRU: 00000000
[   97.121710] Kernel panic - not syncing: Fatal exception
[   97.121710] Kernel Offset: disabled

