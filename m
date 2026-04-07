Return-Path: <live-patching+bounces-2309-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SG4yF3Nq1GletwcAu9opvQ
	(envelope-from <live-patching+bounces-2309-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 04:22:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 583BC3A8FD0
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 04:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DDDA6300D57F
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 02:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C134C1F5834;
	Tue,  7 Apr 2026 02:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pbHA7w5D"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8273502AC
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 02:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775528543; cv=pass; b=A0Gqrz1LVjNZQkPq0O2AHqbxI1Hdo03mMzZ73o3NJXG13Z3N7SNaV5qOT/qRAJAxtGM8CXyqyo52faXPySiFoYbjUpMr/qZqpNpzyRySlbVpB5lC0eDYQoWVI/cCqd0VogF5nkqj4GyUifRZTBy/mK3sjaYZUQPmZnhuE1vU2cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775528543; c=relaxed/simple;
	bh=NLGRqjeuKpGNc91JbpQik1MBmKlqX+MA4yQsWR41Rmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p6+zOC1DGb0lXL59DrqyXoj0gH4uZr+p6ioJMqYY/ng8dAWVzdOvOGseldTV5SGRY/mPmMdB3Tj6vheeX/zmMf9JJhhKR8IbCHoms29PWDoj+4+6i3JE6CcB95KchLzGZGULw3Xns3OvDZoVeA3S+AQdgFtbDSFW6eeEs5NP0Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pbHA7w5D; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-65075c2ba66so714120d50.1
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 19:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775528541; cv=none;
        d=google.com; s=arc-20240605;
        b=cTEwFhupxU6rd7wADxZZxcp3JHTKSk4I5KbXV4mLcGogXOhtBWcLF+snfO0LU92ow2
         2g8QSRRNDWNJiG5Yyn0rDBI9N2H8Mz2LNghwQY2/3CO6WpspFebgC64wn3WsbYU0fAqY
         hOx64BTZMhGKLtD61NozHxiR31FHz3soQDJYYrlMF9G8j+Aw6KJgatE5HMgRa4BJGDZD
         fT674t6Eo+qTe/63LibYNvSeYmvqceQ3L9a3yoOUbGauah6DewVwIDTVr/KguQAoDSWQ
         1KK+YbfK0UqeQFraBOhlU04OaYRN3QDujbwR2lcMz0LyyGxjYb25pV1z5NogYHNS77ra
         miNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hi0ALShgexmGG4t5YaOzHqoGmz/vsFovN1VLyQXTOrs=;
        fh=QP9bmT7UytZBKl2jR2Ig9pg0TzvVtpBuSyyQ1dPwJvA=;
        b=HhWvccD5vYMp+rKsewYxmB7hY7lmltJFpNhxnxqOwt61J5UszJ3Hh5j+ejTmZf10nM
         GVarZk2C5L4f9+POGRsSo9J6qOWU12yjaBSSUXpMHLs0mUx8ThZTyjfO4nANFesehuOn
         7mtWx5FAXddMHA2QtgVGleVc2zy3FLL/tLumegsLQ7dXAvMgiwb9lJW7AJ3qICXedrPd
         f+MQdqzbR3lPXsRupAgTBheUzlHrfESpS4KSh4ffmmXaKdr2ul+S423k2uJ6/T5Bv5ao
         y+yBBcw8rT1sidpFZljB3VjdhyxqMRhNc4o/xSyWFnUO8x6288pBwtK+ZMc7lQNx76m4
         wsxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775528541; x=1776133341; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hi0ALShgexmGG4t5YaOzHqoGmz/vsFovN1VLyQXTOrs=;
        b=pbHA7w5Dek9gqYazNwXy8Wev2rvy9OVweUsIbi+wRfrskH12GZbkNUvVLVp1G75SSl
         xdihA+z0qyOP+JcYV940qHTv3HiyybT+50NATYRfV9jslA5bgmBDcaA9E/yXk7dfuoY3
         4FZ5I2hI6lnVWHXTYg2m7KOFifM3pvBX+gsHuVPyR/mD8JwFavJ01hzUkUHZ27nvXVY5
         Yj3Nr4q2ocH/LHlrpNX9ft7Z2RXUt/pqTP2To9ApkYOHXrr1lXMMQHezW+qbJK9aHH6i
         q/stAYMHjDNjYreNhcNBEEgNLcilP/Ga9bIfOemsgrhH3rctNv+oIjDT0urzFOULbSSq
         XwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775528541; x=1776133341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hi0ALShgexmGG4t5YaOzHqoGmz/vsFovN1VLyQXTOrs=;
        b=rm3KGEFqlLyxo9NxwkinSl7dg3cab7YHlPV2FDRmxPugs501O9HKTZqyOE5YORo7CJ
         v43EsdcWVbUMOPKNqFNVvAcZjVPzuoiYkMAP/t6mDuAudOYcPkX6XJzM64T3+wYeb2Oo
         s9wCS3KUnnlKZ5Z2hmOvqAHSCIcZOzBFHkO73FCQ7cXW2yYzkoqAhG4sPjAMr6yk2jKW
         f+511I4yYRbry8TKgoMSp25mknCHlnLwC6tp+Bf6NgiERR5FGE6tQ3jS4qIUhyI7rDFh
         OStHB3krfBk6Nj/Va1yM3zNKPD1qjwbQsoFjPEbO5uU9gObGoBrtuyYOs3yO8qyPztr1
         oyMg==
X-Forwarded-Encrypted: i=1; AJvYcCVvmvMmezcCfodJBzLkw6F4OIIIK1K5ac762fD+BTVUopq9/4bN04mybh929nZhYQfYspX7VOkeIN0YyBg0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzq0vESKS7EEwBivfgcDpcIrr5/ZAiBTIC/Wu1RfkbudTFX3p2
	XEWpIodibY83vEEyo8IZ+oUOlEnRfyTGRQTMTeFruwUFkflsj5UOwTY4uuSLN42fz7kN+cdALHf
	VCwKfdw+hBO0FEM6XXX332rbiCayzIAQ=
X-Gm-Gg: AeBDies5fEk1Fi7r+xkjJexms+Zzapw3ZKDBugAE8X+TOV6iQkpUnyjeGYYoLilX+IT
	5YUYaPZY5DyPw3ZltW3qAisRzQEBVE1tsFA+HXvNFgSlnMkT2USuDzIUxhWZcWf+EkkT3n2vPpT
	gxN/rZZwSCCjJVwTxDxtmDwv8LqGisZ/5ZLQDGZ54Ch84Eg+ATjmiD2Al2FOHgJTrIiBoesxfk+
	dtrVb6kDtlee/BSmeL730GVZVD/+hh3eV4GhD8XSSX4mkZeamhzxG+XSk+apWfXuNuYPQzwLQKN
	mmcz9f5psfNhd1lJbm/yKQPnPg7jbcbt5iohxs4Ydm9AJq2pbu4=
X-Received: by 2002:a05:690e:4841:b0:650:42ea:26da with SMTP id
 956f58d0204a3-650486c18c3mr11636012d50.4.1775528541024; Mon, 06 Apr 2026
 19:22:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
 <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com> <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
In-Reply-To: <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 Apr 2026 10:21:45 +0800
X-Gm-Features: AQROBzBkgo3KxI2MHJmBlrvcZpAG1jaYfSLmu1S4rqwNflNyNo9B1VXQaeJKRX0
Message-ID: <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Song Liu <song@kernel.org>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2309-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 583BC3A8FD0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 7, 2026 at 2:26=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Mon, Apr 6, 2026 at 3:55=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Sat, Apr 4, 2026 at 12:07=E2=80=AFAM Song Liu <song@kernel.org> wrot=
e:
> > >
> > > Hi Yafang,
> > >
> > > On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > Livepatching allows for rapid experimentation with new kernel featu=
res
> > > > without interrupting production workloads. However, static livepatc=
hes lack
> > > > the flexibility required to tune features based on task-specific at=
tributes,
> > > > such as cgroup membership, which is critical in multi-tenant k8s
> > > > environments. Furthermore, hardcoding logic into a livepatch preven=
ts
> > > > dynamic adjustments based on the runtime environment.
> > > >
> > > > To address this, we propose a hybrid approach using BPF. Our produc=
tion use
> > > > case involves:
> > > >
> > > > 1. Deploying a Livepatch function to serve as a stable BPF hook.
> > > >
> > > > 2. Utilizing bpf_override_return() to dynamically modify the return=
 value
> > > >    of that hook based on the current task's context.
> > >
> > > Could you please provide a specific use case that can benefit from th=
is?
> > > AFAICT, livepatch is more flexible but risky (may cause crash); while
> > > BPF is safe, but less flexible. The combination you are proposing see=
ms
> > > to get the worse of the two sides. Maybe it can indeed get the benefi=
t of
> > > both sides in some cases, but I cannot think of such examples.
> > >
> >
> > Here is an example we recently deployed on our production servers:
> >
> >   https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9=
Yqgeo4C0iA@mail.gmail.com/
> >
> > In one of our specific clusters, we needed to send BGP traffic out
> > through specific NICs based on the destination IP. To achieve this
> > without interrupting service, we live-patched
> > bond_xmit_3ad_xor_slave_get(), added a new hook called
> > bond_get_slave_hook(), and then ran a BPF program attached to that
> > hook to select the outgoing NIC from the SKB. This allowed us to
> > rapidly deploy the feature with zero downtime.
>
> I guess the idea here is: keep the risk part simple, and implement
> it in module/livepatch, then use BPF for the flexible and programmable
> part safe.

Right

>
> Can we use struct_ops instead of bpf_override_return for this case?
> This should make the solution more flexible.

Upstreaming struct_ops based BPF hooks is a challenging process, as
seen in these examples:

  https://lwn.net/Articles/1054030/
  https://lwn.net/Articles/1043548/

Even when successful, upstreaming can take a significant amount of
time=E2=80=94often longer than our production requirements allow. To bridge
this gap, we developed this livepatch+BPF solution. This allows us to
rapidly deploy new features without maintaining custom hooks in our
local kernel. Because these livepatch-based hooks are lightweight,
they minimize maintenance overhead and simplify kernel upgrades (e.g.,
from 6.1 to 6.18).

That said, we would still prefer to have our hooks accepted upstream
to eliminate the need for self-maintenance entirely.

--=20
Regards
Yafang

