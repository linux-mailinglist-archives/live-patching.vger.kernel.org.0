Return-Path: <live-patching+bounces-2050-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sLsPIP92l2nVywIAu9opvQ
	(envelope-from <live-patching+bounces-2050-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 21:47:59 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BAA1626C0
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 21:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0D2C300BCA6
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 20:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC8513957E;
	Thu, 19 Feb 2026 20:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khqnDHwX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B3026D4F9
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 20:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771534069; cv=none; b=UfaNSUFXuNU/5CGEyp9+YjAYgs3Ycf1pgrZ4fkBggsC/kGAAOFW5GJLFqaeTnxOVbJcYOOgl20GVHrLipQNgTothrU4+IIetaIKX5NyX4gYJvl2lG5K3mbaLeBwB7rsRw4oPVGH+r2NckEUoK4QD62957NFIh6CyY9hIlpU8BBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771534069; c=relaxed/simple;
	bh=UDYomv9+TqVUWRlImL9iXe6vG6bJAKREfAvPDb0TnYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lW8wg3FM/MbM8BpqXZcYOZXTi+YVMfhmnyyfXFxtcJ1gemhEnvwMJya8FVSrWC7B08O3QHW66TjwVewp8AtOLquA9ts5z88NPQacWNzj93w/+oDUydARcxjCizdWLKFOUT/q+3vSlDY/BtPVCwZkMXz6GGX4ZMwF++Gl+42Njeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khqnDHwX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B75DC2BC9E
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 20:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771534068;
	bh=UDYomv9+TqVUWRlImL9iXe6vG6bJAKREfAvPDb0TnYA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=khqnDHwXHRuq/lXUQd2/DkIHcAUSbSiYAf0A4pUuM93cfKscfPk40ILGrMIYbz5kN
	 ttoybWsef+fldMT6gkmt1dunQrFNsAo1MsZdhfm75SjsYnp9nADG1pzrkiT6tybUth
	 3g9HzBQcqmWVWyjVbWHPoeXhct3l56XK9BLiHGCI2O7Ecfe1rl2PxUClyCzsS9CIp2
	 ovFfFh8zc+ZCGTrPANcFxXkAm005/p3NqKzgAc6PqtoyVo2Q+yQEK0ZDDMqtEkcR8n
	 hT7+mUhuKMg/IFMiwD3wh8ypcwaZyzVBPUhPDlg3H+m7oaE9gOVWQg+BcbkkScRRvs
	 J0E0IVrWCknwA==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8947e17968eso15271586d6.0
        for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 12:47:48 -0800 (PST)
X-Gm-Message-State: AOJu0YxoOjb0FOjKNzTW0tXH1jwq8EU9b4kz2ljCGlxpdSNJwFqPizda
	k7OGRzbtuStLV1DiQvbzJgOVMp1vmoFhsVrYRs66bMVjrAw3nsIO9uUNSFhq0bGBhdL++eYP5Zo
	/0JzbXenLzz4Y8zFBaXsTm+Q2fCIvFmA=
X-Received: by 2002:ad4:4ea7:0:b0:895:3a2c:5298 with SMTP id
 6a1803df08f44-89734917e13mr335620206d6.45.1771534067583; Thu, 19 Feb 2026
 12:47:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212192201.3593879-1-song@kernel.org> <aZZEjfxgLWTWODE7@redhat.com>
 <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com>
In-Reply-To: <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 19 Feb 2026 12:47:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6aSew_QGQmRcnjSHK+6jmz2-cgNH4dzamTP20U121OzQ@mail.gmail.com>
X-Gm-Features: AaiRm51yzMS2sqeegEEGErW6SCy_b6azrIjFlYCy4LbfRLUwb8Xy1YVYgYv0YeY
Message-ID: <CAPhsuW6aSew_QGQmRcnjSHK+6jmz2-cgNH4dzamTP20U121OzQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2050-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 93BAA1626C0
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 7:08=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Wed, Feb 18, 2026 at 3:00=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat=
.com> wrote:
> >
> > On Thu, Feb 12, 2026 at 11:21:53AM -0800, Song Liu wrote:
> [...]
> > vmlinux.o: warning: objtool: correlate c_start.llvm.1525119882436692806=
1 (origial) to c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_stop.llvm.15251198824366928061=
 (origial) to c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_next.llvm.15251198824366928061=
 (origial) to c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate show_cpuinfo.llvm.15251198824366=
928061 (origial) to show_cpuinfo.llvm.10047843810948474008 (patched)
> > vmlinux.o: warning: objtool: correlate .str.llvm.1768504738091882651 (o=
rigial) to .str.llvm.7814622528726587167 (patched)
> > vmlinux.o: warning: objtool: correlate crypto_seq_ops.llvm.176850473809=
1882651 (origial) to crypto_seq_ops.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_start.llvm.1768504738091882651=
 (origial) to c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_stop.llvm.1768504738091882651 =
(origial) to c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_next.llvm.1768504738091882651 =
(origial) to c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_show.llvm.1768504738091882651 =
(origial) to c_show.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.1525119882436=
6928061 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.15251198824366=
928061 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.15251198824366=
928061 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_show_cpuinfo.llvm.15251198=
824366928061 (origial) to __pfx_show_cpuinfo.llvm.10047843810948474008 (pat=
ched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.1768504738091=
882651 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.17685047380918=
82651 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.17685047380918=
82651 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_show.llvm.17685047380918=
82651 (origial) to __pfx_c_show.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: no correlation: c_start.llvm.1768504738091=
882651
> > vmlinux.o: warning: objtool: no correlation: c_stop.llvm.17685047380918=
82651
> > vmlinux.o: warning: objtool: no correlation: c_next.llvm.17685047380918=
82651
> > vmlinux.o: new function: c_start.llvm.10047843810948474008
> > vmlinux.o: new function: c_stop.llvm.10047843810948474008
> > vmlinux.o: new function: c_next.llvm.10047843810948474008
> > vmlinux.o: changed function: c_start.llvm.14107081093236395767
> > vmlinux.o: changed function: c_stop.llvm.14107081093236395767
> > vmlinux.o: changed function: c_next.llvm.14107081093236395767
> > Building patch module: livepatch-min.ko
> > SUCCESS
>
> Thanks for the test case. This one shows the worst case of the .llvm.
> suffix issue.
>
> We have
>   c_start.llvm.15251198824366928061
>   c_start.llvm.1768504738091882651
> in the original kernel, and
>   c_start.llvm.14107081093236395767
>   c_start.llvm.10047843810948474008
> in the patched kernel.
>
> All of them are GLOBAL HIDDEN functions, so I don't think we can
> reliably correlate them. Maybe we should fail the build in such cases.
>
> Any comments and suggestions on this one? CC: Josh.

I fixed the correlation logic, with the min.patch from Joe that patches:
  arch/x86/kernel/cpu/proc.c
  crypto/proc.c
  fs/proc/consoles.c

we got the following failure:
Diffing objects
vmlinux.o: error: objtool: Multiple (2) correlation candidates for
c_start.llvm.18238767671416440194
error: klp-build: objtool klp diff failed

With a smaller patch, that only patches:
  arch/x86/kernel/cpu/proc.c
  fs/proc/consoles.c

There will be only one c_start.llvm.<hash>. klp-build fails with:
Diffing objects
vmlinux.o: warning: objtool: correlate
c_start.llvm.18238767671416440194 (original) to
c_start.llvm.4054753011035506728 (patched)
vmlinux.o: warning: objtool: correlate
c_stop.llvm.18238767671416440194 (original) to
c_stop.llvm.4054753011035506728 (patched)
vmlinux.o: warning: objtool: correlate
c_next.llvm.18238767671416440194 (original) to
c_next.llvm.4054753011035506728 (patched)
vmlinux.o: warning: objtool: correlate
show_cpuinfo.llvm.18238767671416440194 (original) to
show_cpuinfo.llvm.4054753011035506728 (patched)
Building patch module: livepatch-0001-min.ko
error: klp-build: no changes detected

This is the best solution I can think of at the moment. I will send v2
patches soon.

Thanks,
Song

