Return-Path: <live-patching+bounces-2310-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EHdEUlw1GkruAcAu9opvQ
	(envelope-from <live-patching+bounces-2310-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 04:47:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CEB3A93D4
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 04:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E4DA5300693B
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 02:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099AC372696;
	Tue,  7 Apr 2026 02:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TU89mm72"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA58236C9C0
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 02:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775530019; cv=none; b=RNJzgR3BJ81MUL6oKqF6LEYTqCweq/Eax1HEnWKF8GXSlLaRStTOD6t+nBFbhfdxEJzk68eYXVOEflXWUeknbMJ8OdtMve4I8usnexnLlNqVzps36b7biPJEfq0G9XATHszael8orAzUq//lUFl+AzqtoODsPBggEnaorft1j8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775530019; c=relaxed/simple;
	bh=XA1jPqiSGeDvmwiElEm0BXTRhAUPzM3jdCv7yUZuUME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evu86JMXdFp8REufjHDIi3sUBEg+cx98HHAQixLgwfasTZzoL3ZZrXMMOhMvGTzuCRav201vMbpzraDHK4sRBMf1JL0lp53a1Lr/3T2agkNu987i/4/XyeMrTVOIiNFDXNrKHjFEdOwma77z933wRVbKJjnRihMyI+FNFTsTxXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TU89mm72; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976ABC2BCB2
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 02:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775530019;
	bh=XA1jPqiSGeDvmwiElEm0BXTRhAUPzM3jdCv7yUZuUME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TU89mm72wOKTdxDkro1Kq8se002dL3UCnEBtb5M2qJ2xD7+8ZosIf5yON0VVVHHl4
	 qH43J4D23Ej5B6XlthsdZQTC4ln2CvL9YZQ0bGsh/IqcV8C9moznJIout8D66owEUR
	 DxrsNFiP10koooNAbxZitGPMwgvi5hmv7a4qrnX9EQ6KEXmf03XZws/A8V5I78pMgJ
	 pYhL3dFIG6NTi6FyFpGc3GXua40HTTLhH0fUcSMWjWv+jNNI0MyWw2BMNFHfP6NVYb
	 2COlXuMrTmAO7MOoZwxyxIvaR+KXsVfDu3YTeuzMAjMgvDGac9Acr2i5SOCpytLtdB
	 YKIr5iN9Iggrg==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50b3488fb31so84806171cf.1
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 19:46:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXZNOijdGcJix3TilYsEF76SVNPS/LUuBD1pvq9FDkTzjPZSJjU0MDz8DU2ntKIwz4Ggb9M39lAVEKP01qp@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9f4gHksHwUR9ACCHLF8Rz2YDQbULp/kEoQ0vAp4HosgCzkG0A
	u6G3FBD/67al3g3eJDuDxkEMCNPjFf6rvYOJrynF+YRXxuVb8zEIRkLNFZRj7yLY/MLHOqRmdgx
	sW0CnYHcIDgTZOkzyrpc0FGSDjq4MeTw=
X-Received: by 2002:a05:6214:4a8b:b0:89c:6543:756a with SMTP id
 6a1803df08f44-8a704fa689dmr207896356d6.18.1775530018748; Mon, 06 Apr 2026
 19:46:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
 <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
 <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com> <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com>
In-Reply-To: <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 6 Apr 2026 19:46:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com>
X-Gm-Features: AQROBzDf6qt6w6BtdXzEGlZp504Ll_WGEoE5KBs4wuhmHRkZHzdlcuSOqgTM86E
Message-ID: <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Yafang Shao <laoar.shao@gmail.com>
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
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2310-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid,lwn.net:url]
X-Rspamd-Queue-Id: 34CEB3A93D4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 6, 2026 at 7:22=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Tue, Apr 7, 2026 at 2:26=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Apr 6, 2026 at 3:55=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > On Sat, Apr 4, 2026 at 12:07=E2=80=AFAM Song Liu <song@kernel.org> wr=
ote:
> > > >
> > > > Hi Yafang,
> > > >
> > > > On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gmai=
l.com> wrote:
> > > > >
> > > > > Livepatching allows for rapid experimentation with new kernel fea=
tures
> > > > > without interrupting production workloads. However, static livepa=
tches lack
> > > > > the flexibility required to tune features based on task-specific =
attributes,
> > > > > such as cgroup membership, which is critical in multi-tenant k8s
> > > > > environments. Furthermore, hardcoding logic into a livepatch prev=
ents
> > > > > dynamic adjustments based on the runtime environment.
> > > > >
> > > > > To address this, we propose a hybrid approach using BPF. Our prod=
uction use
> > > > > case involves:
> > > > >
> > > > > 1. Deploying a Livepatch function to serve as a stable BPF hook.
> > > > >
> > > > > 2. Utilizing bpf_override_return() to dynamically modify the retu=
rn value
> > > > >    of that hook based on the current task's context.
> > > >
> > > > Could you please provide a specific use case that can benefit from =
this?
> > > > AFAICT, livepatch is more flexible but risky (may cause crash); whi=
le
> > > > BPF is safe, but less flexible. The combination you are proposing s=
eems
> > > > to get the worse of the two sides. Maybe it can indeed get the bene=
fit of
> > > > both sides in some cases, but I cannot think of such examples.
> > > >
> > >
> > > Here is an example we recently deployed on our production servers:
> > >
> > >   https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5h=
y9Yqgeo4C0iA@mail.gmail.com/
> > >
> > > In one of our specific clusters, we needed to send BGP traffic out
> > > through specific NICs based on the destination IP. To achieve this
> > > without interrupting service, we live-patched
> > > bond_xmit_3ad_xor_slave_get(), added a new hook called
> > > bond_get_slave_hook(), and then ran a BPF program attached to that
> > > hook to select the outgoing NIC from the SKB. This allowed us to
> > > rapidly deploy the feature with zero downtime.
> >
> > I guess the idea here is: keep the risk part simple, and implement
> > it in module/livepatch, then use BPF for the flexible and programmable
> > part safe.
>
> Right
>
> >
> > Can we use struct_ops instead of bpf_override_return for this case?
> > This should make the solution more flexible.
>
> Upstreaming struct_ops based BPF hooks is a challenging process, as
> seen in these examples:
>
>   https://lwn.net/Articles/1054030/
>   https://lwn.net/Articles/1043548/
>
> Even when successful, upstreaming can take a significant amount of
> time=E2=80=94often longer than our production requirements allow. To brid=
ge
> this gap, we developed this livepatch+BPF solution. This allows us to
> rapidly deploy new features without maintaining custom hooks in our
> local kernel. Because these livepatch-based hooks are lightweight,
> they minimize maintenance overhead and simplify kernel upgrades (e.g.,
> from 6.1 to 6.18).

I didn't mean upstream struct_ops.

We can define the struct_ops in an OOT kernel module. Then we
can attach BPF programs to the struct_ops. We may need
livepatch to connect the new struct_ops to original kernel logic.

I think kernel side of this solution is mostly available, but we may
need some work on the toolchain side.

Does this make sense?

Thanks,
Song

> That said, we would still prefer to have our hooks accepted upstream
> to eliminate the need for self-maintenance entirely.

