Return-Path: <live-patching+bounces-2312-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id dHbvJJp21GkOuQcAu9opvQ
	(envelope-from <live-patching+bounces-2312-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 05:14:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A243A95BA
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 05:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 837A43016D08
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 03:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D988372EDF;
	Tue,  7 Apr 2026 03:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahofZkd/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DC11FE471
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 03:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775531671; cv=pass; b=npLb8bV3BHKMK8gMvknlXOkWWpQPUTDGo243NK4d1n4p6C1gkecrVBt3XgXPA9LIHB5c14cpVBZmNnOJCfI/ifpvnlMnQ5hd8yTBLllCcuiq5ujZT3LT42GM/lfYKq3128/Akr+Q4kRQIzvayYDUvam3YrFEbsB2vsrc/EdqhJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775531671; c=relaxed/simple;
	bh=squ6n2HGdHi3UxLO+I4JuWRPtoqYf/aQUuDGYO1d7Ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdpMk4JqFv+oJHC+oAdL9Yl6Y/a0JNBaA2d+tC/fBsevfbJ/i0rtl2y3JIe8VjGjTfIX2usevgOZfeiqXxJhV+W6KboYsKrUf2nzdoFv8Wch1vLnn+sC7byyJHvP6Ifw4U91SahYm8GPQn1KpP4ud9AuGa55+slMJNYzuhwenyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahofZkd/; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6505ef94043so1892876d50.2
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 20:14:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775531669; cv=none;
        d=google.com; s=arc-20240605;
        b=N6k5fWnwvgAwqQ8Za2V9FaGRf9m9g38MBQFy6BwVvA1uGI/gegGRCBF2lQYyhJxbcW
         takuiFxlAmoeijKWhk0hqHT1oVJu7ek7oFLu2rOxn2wSCHmN/NF1D4uUL1UEcDIcIQRP
         4WmHINfRT8hkkIPMdv5Di/N8rgBxg7iCS6ULcSxuPSX89DODHBHuR4RUrXQO5UWHnto1
         Z/IsH7lJQH2DRY/7vT/MkzWOqW+fHNamRafJUW24e3Z8WzrJJTT58TNzeAiF8+dJtg1V
         hih5rTb8DKC6LDyIou8qzCwUt7dfMqQaHKiukSQF4K7kSno9O4KmAwYPc9M85ks/wr+O
         S8bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YxsYtPm2hx4YrAVsbIcCgtwuR/ec20rxpqySMN9Lw4g=;
        fh=sqYBvqqPZci0bF7krKLoMoPs9FFxXvH0P9y6hKnM/WM=;
        b=UPJMSBIczXUcvXMXO+altDt+oxozGmXoxzrHwsCeHp7zE0LWrRGU1tpzLoU2oZIAcC
         xorU0qVOh2cpDqpoCxYHGBeBewEfe4SY05HmlnNp9XSjw2UHjHEshy/PEdx0RL3PtQFb
         vj97x0ZyIBNJYNWIw1yjwX5t0qv2DNF48tEzjvARIYidWFR0WYNFSTx6rBuIRlUktFXk
         SXKVodGVGP2OGbO4Ugm4uhGSAUS7V+R4jBotSLmhw089RnA72ZIoB02/pjJWY0YsELRG
         QTrTX2zmyaPfwEV4eXHToHVslbz5kACsPHC7RXDRS+aGaZbL9fO3yWXqfykOFWDyTXHx
         +kVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775531669; x=1776136469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxsYtPm2hx4YrAVsbIcCgtwuR/ec20rxpqySMN9Lw4g=;
        b=ahofZkd/LDlzScpDFA08CbGu322YcV4lsdhPZDiDybFzOFhhNMo91dxCK37eMiltP6
         piG9ccJBTZzI9Z/BFScbfzMqc+xrZPrjgPZU1WBhVsJuhi6LAMexV8yl5LrnTe0c9Dxb
         Ys/7q0YZL+Coc3YuQUyijjudvKeiRt8F/aGq5F0ybfwNVSlyRLzxyPJNYHTr8zVkCWWB
         7ruYtyD2gMzC55+bnislk1Iye22fSsO9r2fnoT4j/fX4wZkTwSGb2cIwL/ZYFcgKgZfR
         b+aP2My5fP72z7x0UvXM6thljPQ9IB6X619zMo7zgTyo8oe1bofWQ041jthxJzV3k1HL
         dBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775531669; x=1776136469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YxsYtPm2hx4YrAVsbIcCgtwuR/ec20rxpqySMN9Lw4g=;
        b=oOjAWukGwRNtKc7gFDr0m+Gzs2Y6b6sU7Q000yK9DBqWwueMg17/fXVeF7UvgA57J6
         pQ+PONvwKosmDfd4ihTdzY4ZCSrjI6jvgPvdnJgJtFnrdt1fYJMwBAhkIhgdzLgXRH9C
         nL6xHwTW2EmOmhEsxQySgXfPiynWycLUrtvihJlehMCVku4XK77eKKvCOijzNdApv4s1
         CKntpQWgyuYg7cFpERT1JBZ6jRc96N8amcTGJ8hE/9w3VhtxcyTBaKAxnbuj2r1yUkF/
         Ul2CT65m0jOhRAV09PL6SVxm9jfmXGp7iCLjZl87qzXvt4p4+nnI8rMuM/x5rgWqa4is
         VhvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXt9aRXfVwT0z4LsczuFikH+uJUv7aGA8rPEaPP4dMxpIywYcZbj2oUmevb9f0XVf41UHurPRVlTbjABdIT@vger.kernel.org
X-Gm-Message-State: AOJu0YzzMrYU65Q2rMu8KmTfdGJmMX53F2oRqtNQGDMkDCnUWYhUqIsB
	apubMSD28ppPnGHtbrDkw+024Y1f4XCjSlVoYHLQ6dlIrgMSUntGLSCLQYJGqjV+FGwsWCgaake
	dABiTudDFTS1Pl0P810zFhL9aycklGlg=
X-Gm-Gg: AeBDiev8ccQXqNn0A15Cih+0ylsMIPCtAtiCw24D8OnGSRQooWf77qJC3ZrtrT54z09
	SrmJUxerkAYS/jj9YUd6eSbWMrnkHk9xCvU1xWJex9OLIXeyCzIeSDXk1Pj8rkG/o3TAsAvveKW
	5WoUZwGrYvH6WsisIxYMT0kJ5W9M5JiEJkOP80RLrrb7zBQbu/x10xVqfZuhWx0hZWY28pAuPhx
	QMxByOsGN/FmLtBTE1OD65942ZZm9H+rMyWnks5qQNKM5Zdx5t0qQOYwS9c4SSnH2rRjNNSVJWt
	Q77BLDk8ARRsZgwIGnZ41X+JrVABq/HEqSDSvXHR
X-Received: by 2002:a05:690e:304:b0:650:3bbc:57a7 with SMTP id
 956f58d0204a3-65048746577mr10316392d50.25.1775531668967; Mon, 06 Apr 2026
 20:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
 <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
 <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
 <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com> <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com>
In-Reply-To: <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 Apr 2026 11:13:51 +0800
X-Gm-Features: AQROBzAwoTocrSdgLlq9jjuaEvd25BiOxk_ha4-MCiHen7ISJudiyPIWC0L9dTA
Message-ID: <CALOAHbAmTAfamStF9sZtO6efWYJ1sbXJp3PbsVapZf7dba91ig@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2312-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,lwn.net:url]
X-Rspamd-Queue-Id: F3A243A95BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 7, 2026 at 10:47=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Mon, Apr 6, 2026 at 7:22=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Tue, Apr 7, 2026 at 2:26=E2=80=AFAM Song Liu <song@kernel.org> wrote=
:
> > >
> > > On Mon, Apr 6, 2026 at 3:55=E2=80=AFAM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > On Sat, Apr 4, 2026 at 12:07=E2=80=AFAM Song Liu <song@kernel.org> =
wrote:
> > > > >
> > > > > Hi Yafang,
> > > > >
> > > > > On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> > > > > >
> > > > > > Livepatching allows for rapid experimentation with new kernel f=
eatures
> > > > > > without interrupting production workloads. However, static live=
patches lack
> > > > > > the flexibility required to tune features based on task-specifi=
c attributes,
> > > > > > such as cgroup membership, which is critical in multi-tenant k8=
s
> > > > > > environments. Furthermore, hardcoding logic into a livepatch pr=
events
> > > > > > dynamic adjustments based on the runtime environment.
> > > > > >
> > > > > > To address this, we propose a hybrid approach using BPF. Our pr=
oduction use
> > > > > > case involves:
> > > > > >
> > > > > > 1. Deploying a Livepatch function to serve as a stable BPF hook=
.
> > > > > >
> > > > > > 2. Utilizing bpf_override_return() to dynamically modify the re=
turn value
> > > > > >    of that hook based on the current task's context.
> > > > >
> > > > > Could you please provide a specific use case that can benefit fro=
m this?
> > > > > AFAICT, livepatch is more flexible but risky (may cause crash); w=
hile
> > > > > BPF is safe, but less flexible. The combination you are proposing=
 seems
> > > > > to get the worse of the two sides. Maybe it can indeed get the be=
nefit of
> > > > > both sides in some cases, but I cannot think of such examples.
> > > > >
> > > >
> > > > Here is an example we recently deployed on our production servers:
> > > >
> > > >   https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy=
5hy9Yqgeo4C0iA@mail.gmail.com/
> > > >
> > > > In one of our specific clusters, we needed to send BGP traffic out
> > > > through specific NICs based on the destination IP. To achieve this
> > > > without interrupting service, we live-patched
> > > > bond_xmit_3ad_xor_slave_get(), added a new hook called
> > > > bond_get_slave_hook(), and then ran a BPF program attached to that
> > > > hook to select the outgoing NIC from the SKB. This allowed us to
> > > > rapidly deploy the feature with zero downtime.
> > >
> > > I guess the idea here is: keep the risk part simple, and implement
> > > it in module/livepatch, then use BPF for the flexible and programmabl=
e
> > > part safe.
> >
> > Right
> >
> > >
> > > Can we use struct_ops instead of bpf_override_return for this case?
> > > This should make the solution more flexible.
> >
> > Upstreaming struct_ops based BPF hooks is a challenging process, as
> > seen in these examples:
> >
> >   https://lwn.net/Articles/1054030/
> >   https://lwn.net/Articles/1043548/
> >
> > Even when successful, upstreaming can take a significant amount of
> > time=E2=80=94often longer than our production requirements allow. To br=
idge
> > this gap, we developed this livepatch+BPF solution. This allows us to
> > rapidly deploy new features without maintaining custom hooks in our
> > local kernel. Because these livepatch-based hooks are lightweight,
> > they minimize maintenance overhead and simplify kernel upgrades (e.g.,
> > from 6.1 to 6.18).
>
> I didn't mean upstream struct_ops.
>
> We can define the struct_ops in an OOT kernel module. Then we
> can attach BPF programs to the struct_ops. We may need
> livepatch to connect the new struct_ops to original kernel logic.
>
> I think kernel side of this solution is mostly available, but we may
> need some work on the toolchain side.
>
> Does this make sense?

Are there actual benefits to using struct_ops instead of
bpf_override_return? So far, I=E2=80=99ve only found it adds complexity
without much gain.
Can we add something like ALLOW_LIVEPATCH_ERROR_INJECTION() to allow
error injection on functions defined inside a livepatch?

--=20
Regards
Yafang

