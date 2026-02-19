Return-Path: <live-patching+bounces-2049-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPDWLdl+lmlRgQIAu9opvQ
	(envelope-from <live-patching+bounces-2049-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 04:09:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D299C15BD6C
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 04:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 34BFA3004639
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 03:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613E2264A65;
	Thu, 19 Feb 2026 03:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSpCXJe7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E76A1C84C0
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 03:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771470548; cv=none; b=MiAskAFKHH5LaPsS5q6VeaYJ4gtBXUylVW63XTH+ocBT+97mY7GUSNCQlRjjRIkpyzONGaPGsTUT81um+Lgg4JQqUJ8/pEUtrxZlqyTN5/G81uBQMV5IOjYJmULwt2/6ftaLIodsJHA/k2gkkSpbXyoA1y5/o8+iPo8M0HbgKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771470548; c=relaxed/simple;
	bh=usFfb2DWEGYkqB6s5YamB8ke0UmUf25QM/jlX61qd6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCviV741UiiJsqwSQ9yXbiNMX7wFpUJ69BQ42L1b5zSUK81g/Xfh/+Iwgl8bUp/cap2mvWlgKU5PHNcFYDrVvMThlzmqHpp1RQ+YYWRjc9+6Byz9VZhKH6rToo++Ob56GQe2CEe8hUUq5Qv11a1FrebsdJsnilqtWSSXgb8KD5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSpCXJe7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B773AC116D0
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 03:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771470547;
	bh=usFfb2DWEGYkqB6s5YamB8ke0UmUf25QM/jlX61qd6A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bSpCXJe70GQiRlOtZDB2Sl/zR/dy7hv3l9qbijp41xHgzHJicabTLmzDOzXRUhHQ9
	 aCYarlcvT8qchrXo8YNyJsm5F1BVE4HqSm4YIEdJGi63mi/0Xq9TBmY3+xAXWn2tfT
	 +gaRiEC0yCLNDjkuTG1r2On+CYLediL11rGbSCUkcQl7uzj0af9OlpF2YkGH6b2yk6
	 t0zHEdLdBe6/PiW/DZ79/cQmhxFcabOo6uuEbMEyBD1dnPFCQYGqxGmLzodUm9vH3g
	 +2/jpTafsnzEhOCY/8Ba0G4bRthdyVfSeluYuViG+ZVHPKvHKv4nNM4dXfNMztGQB3
	 rvVcposUoTUQg==
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-505e2e4c35fso3692021cf.3
        for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 19:09:07 -0800 (PST)
X-Gm-Message-State: AOJu0Yx2iXdPykpjttJJxTcz6MiI/X0XF7AqMAUZ3wt8qNt9JA9QYpYs
	mEyTk+ERX6WtA1IDuqn0VaZpgVVhQmdFK+zwoX6MHZDDOab1pvjk4DB75agUPrwlOmaimYdrSqP
	y8X/Asy/IkMj7aowjjkdnLuRSXc8GlZw=
X-Received: by 2002:a05:622a:120a:b0:506:9b3a:2199 with SMTP id
 d75a77b69052e-506e924c7e1mr50446261cf.67.1771470546786; Wed, 18 Feb 2026
 19:09:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212192201.3593879-1-song@kernel.org> <aZZEjfxgLWTWODE7@redhat.com>
In-Reply-To: <aZZEjfxgLWTWODE7@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 18 Feb 2026 19:08:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com>
X-Gm-Features: AaiRm52dR8ixynGzKJbIE_26gaM3H3N6cZvKfmw1GH5nyfmzJub5FR5g1OmhAho
Message-ID: <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com>
Subject: Re: [PATCH 0/8] objtool/klp: klp-build LTO support and tests
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2049-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D299C15BD6C
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 3:00=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> On Thu, Feb 12, 2026 at 11:21:53AM -0800, Song Liu wrote:
[...]
> vmlinux.o: warning: objtool: correlate c_start.llvm.15251198824366928061 =
(origial) to c_start.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate c_stop.llvm.15251198824366928061 (=
origial) to c_stop.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate c_next.llvm.15251198824366928061 (=
origial) to c_next.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate show_cpuinfo.llvm.1525119882436692=
8061 (origial) to show_cpuinfo.llvm.10047843810948474008 (patched)
> vmlinux.o: warning: objtool: correlate .str.llvm.1768504738091882651 (ori=
gial) to .str.llvm.7814622528726587167 (patched)
> vmlinux.o: warning: objtool: correlate crypto_seq_ops.llvm.17685047380918=
82651 (origial) to crypto_seq_ops.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate c_start.llvm.1768504738091882651 (=
origial) to c_start.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate c_stop.llvm.1768504738091882651 (o=
rigial) to c_stop.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate c_next.llvm.1768504738091882651 (o=
rigial) to c_next.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate c_show.llvm.1768504738091882651 (o=
rigial) to c_show.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.152511988243669=
28061 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.1525119882436692=
8061 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.1525119882436692=
8061 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_show_cpuinfo.llvm.1525119882=
4366928061 (origial) to __pfx_show_cpuinfo.llvm.10047843810948474008 (patch=
ed)
> vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.176850473809188=
2651 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.1768504738091882=
651 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.1768504738091882=
651 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: correlate __pfx_c_show.llvm.1768504738091882=
651 (origial) to __pfx_c_show.llvm.14107081093236395767 (patched)
> vmlinux.o: warning: objtool: no correlation: c_start.llvm.176850473809188=
2651
> vmlinux.o: warning: objtool: no correlation: c_stop.llvm.1768504738091882=
651
> vmlinux.o: warning: objtool: no correlation: c_next.llvm.1768504738091882=
651
> vmlinux.o: new function: c_start.llvm.10047843810948474008
> vmlinux.o: new function: c_stop.llvm.10047843810948474008
> vmlinux.o: new function: c_next.llvm.10047843810948474008
> vmlinux.o: changed function: c_start.llvm.14107081093236395767
> vmlinux.o: changed function: c_stop.llvm.14107081093236395767
> vmlinux.o: changed function: c_next.llvm.14107081093236395767
> Building patch module: livepatch-min.ko
> SUCCESS

Thanks for the test case. This one shows the worst case of the .llvm.
suffix issue.

We have
  c_start.llvm.15251198824366928061
  c_start.llvm.1768504738091882651
in the original kernel, and
  c_start.llvm.14107081093236395767
  c_start.llvm.10047843810948474008
in the patched kernel.

All of them are GLOBAL HIDDEN functions, so I don't think we can
reliably correlate them. Maybe we should fail the build in such cases.

Any comments and suggestions on this one? CC: Josh.

> And since we're here, it looks like there's a type:
> s/origial/original/g.

Fixed!

Thanks,
Song

