Return-Path: <live-patching+bounces-2297-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOlELZf702k8owcAu9opvQ
	(envelope-from <live-patching+bounces-2297-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:29:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 186EB3A63C6
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80E51303F044
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6DC393DE6;
	Mon,  6 Apr 2026 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYN7DyAX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B89E38F639
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775499975; cv=none; b=ZKIMw2B3eKoJfLBES+YytGKABM6XlIR7WqaW/oejNXx9+rQ0K1Mx6URwftKJJ9UptossSEYBmpiUoDIONJ6Qx4sMGL9AE2X88Z7xlzVpk2Ot+aydmYAhg1dNrYHn4A0T4t5LulvhwzszxPDWcyL3u+S6ySkvWg1yeoxFRn/Cg3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775499975; c=relaxed/simple;
	bh=wfu3SmCWTHG00AoQ7PJHES42wwN+iL5vkZSPgQVh2Jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iD7AMjE00eSn3BKEy+rYUgZkyk8B44KmlqkX5w5YrecexiU5lxsClUfyxeNE1Ih/dnHUV6j6EO4D6OQK96/Hdwt+62l64kWiyhMYyFJCS3OWf1KvI4aBHF3x0tFZxzD9fYTC4o2mYFjKwse13C5mShTLo9sARoG7yAxyHDM2FuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYN7DyAX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD91AC2BCB4
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775499974;
	bh=wfu3SmCWTHG00AoQ7PJHES42wwN+iL5vkZSPgQVh2Jw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cYN7DyAXXgBgmfBSoi8/ao3QWrxwQ0pBTLlvB+UDZrZ4qCxnmPleaQs+LSKrntQJ2
	 aLyykujyqZrO2J6AsYiqp8coGFnvmiocFuIliNSjEKaHK+Xome5I0/pTFJpd1cV9Sn
	 9B7BcKioC4TbOZ7ZsiQWHGljgMsJqYIJFxw4SaQTCdoMFTjAsdqETBX6RewWa0HCel
	 lMd7QeJvscFW770W1qiQlgXGl/iDYs8aC2A3+vnimWH28yZlr1e+dZ2h8AHyFwf6rs
	 Mx4AnTLnFLEQrQCbLhQwh5+uW54WdIPxQIvZET0MpfPTO764jbgoCe+c6iBnQvLKnj
	 X8Q87cavEmT9Q==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89fc4147f2eso55820056d6.3
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:26:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZN9thR13ec15HZEKsQT2H6DhqxHdXS9zGI087GrqH3zPc4JAbQCzDpHW/CGDmr65iIwhMCtmUg6eSrOp/@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw4VQKgL24ZjT9fIBl2MdGVAgoSnXmyLiQm/rbCMp1IL4037qY
	mgpvARwBb7jAdev6Z4m/QRFf/oKA9N8lAV4yb4A60oVyv2n1tTLdduG4uYzAQYELrcAIDtG4nLh
	fXS3oIpOYcRtQzgEu5ag+wjyXF4sujaM=
X-Received: by 2002:a05:6214:610e:b0:8a4:58ff:f0fe with SMTP id
 6a1803df08f44-8a8b9bf9eb6mr127592986d6.40.1775499973781; Mon, 06 Apr 2026
 11:26:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
 <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
In-Reply-To: <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 6 Apr 2026 11:26:01 -0700
X-Gmail-Original-Message-ID: <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
X-Gm-Features: AQROBzDRJyuED_IuM-sGNSexLMTciBEOVA37Zw9sSDoenbrhvTQ8uunGVk8jTzE
Message-ID: <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2297-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 186EB3A63C6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 6, 2026 at 3:55=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Sat, Apr 4, 2026 at 12:07=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > Hi Yafang,
> >
> > On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > Livepatching allows for rapid experimentation with new kernel feature=
s
> > > without interrupting production workloads. However, static livepatche=
s lack
> > > the flexibility required to tune features based on task-specific attr=
ibutes,
> > > such as cgroup membership, which is critical in multi-tenant k8s
> > > environments. Furthermore, hardcoding logic into a livepatch prevents
> > > dynamic adjustments based on the runtime environment.
> > >
> > > To address this, we propose a hybrid approach using BPF. Our producti=
on use
> > > case involves:
> > >
> > > 1. Deploying a Livepatch function to serve as a stable BPF hook.
> > >
> > > 2. Utilizing bpf_override_return() to dynamically modify the return v=
alue
> > >    of that hook based on the current task's context.
> >
> > Could you please provide a specific use case that can benefit from this=
?
> > AFAICT, livepatch is more flexible but risky (may cause crash); while
> > BPF is safe, but less flexible. The combination you are proposing seems
> > to get the worse of the two sides. Maybe it can indeed get the benefit =
of
> > both sides in some cases, but I cannot think of such examples.
> >
>
> Here is an example we recently deployed on our production servers:
>
>   https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yq=
geo4C0iA@mail.gmail.com/
>
> In one of our specific clusters, we needed to send BGP traffic out
> through specific NICs based on the destination IP. To achieve this
> without interrupting service, we live-patched
> bond_xmit_3ad_xor_slave_get(), added a new hook called
> bond_get_slave_hook(), and then ran a BPF program attached to that
> hook to select the outgoing NIC from the SKB. This allowed us to
> rapidly deploy the feature with zero downtime.

I guess the idea here is: keep the risk part simple, and implement
it in module/livepatch, then use BPF for the flexible and programmable
part safe.

Can we use struct_ops instead of bpf_override_return for this case?
This should make the solution more flexible.

Thanks,
Song

