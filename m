Return-Path: <live-patching+bounces-2287-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBfkEtLkz2kS1gYAu9opvQ
	(envelope-from <live-patching+bounces-2287-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 18:03:30 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 999463960DF
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 18:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21F46304DE8F
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 16:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432653CAE74;
	Fri,  3 Apr 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1f5lNwJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6683CC9EA
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775232060; cv=pass; b=s4mZJrvF4UGNiMlVv/06/vrY8RMU8ZR7Ri4geKUqJvFwjT2CN9pyyGLF8bUKvztKrodu0sAtSqKgw01l5L+h1KAUUxC8MbwKUrhC06yoH89Ua+Nqjd+Mltektm+z36xyY309NrJO9R6R1ygO5VaZlFYoOQ+ObQU/NVrIUk/ITmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775232060; c=relaxed/simple;
	bh=4J8XcLhyQNpn4ct//tlB3JgTqU1q9N+kL/BF7kTxfb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mn0mfb3LiYbCIqrk8TpLfjLCf0dWNcHA+NeSwZWYluQanPHDNVO8nSF5Xp+daC60r7JFpDJe08F7a/1aF6GJPI1N0g6nSZG+F3mA4PDw5j3Ff4GiN/RoheL+Y1cbAMP96dgTgVvy/rsST+19DwkP+VnNc0xvGNfmEXYh5tTcT4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a1f5lNwJ; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-797ab169454so33148667b3.3
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 09:00:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775232057; cv=none;
        d=google.com; s=arc-20240605;
        b=e9/1Uz4esGU6osJFXqqAK9NUob1CL7kcxvPCS/F0P5lOJHwYu7yibcpPBGryE4inkX
         szFV+AhlaH6kqkcBW9tnIAJJW9DZ8rfQbpW8yOV1xQ42BndAiJUk5J/ule8SXf16pSFB
         TNYUwWflQvXxhZTubRbj8aJS32Iew5SOJ1r15T9sBx2DMN+5gaqyQsG7whWbIKgPy8aP
         q7buclwTVbcv0LFqQa/zPtoao3ZqWcKp+jJ47nrAfFqoUGd43CQbGycdcwED+PT24EL9
         rBqR9OSxa9F7YfEgzhRxA3uwQtBWvrCqG324TSyaLMeuCeJMo5cNkhzqUXNFtOcGBPKQ
         Njsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=smlalJP6W4oXJb7plM4HOYk8mDYdhNOc9XE7DYiHv4c=;
        fh=KU+tjwAGAZ+vdxvcYPGE6DuQIt3WyqRBPAHwWGTihME=;
        b=QJb/sdmRVuLyQY8NFPNvu4R5JKXUaPPqCBi6iml79iqEwxSL2k4CJcfn6GyJ0+MVkU
         cHh7oVP8M/r69A7Z3bdHwSwqn3ZJ+6t8Yd8apz4+BEz5NoIR501Yt+MgLEia4fgeVV97
         cSKHJm+v/JMjJFN509bEV7mfbj3Kz08LcibIguau2Ik6cZjbGIiwDrS8NZjQDmbsGjHL
         Ym3ZhYDmVSsO2WYM8Q3f5SJywLtdebexEHX2v8xzpRMZKNq9qCaVT9Qg38s3PyyMSgWa
         jsiBFQQlTMlFKhuA6n4T1GXH9tJB23mQeG5MQHx02j8nlXbsF5AZqZCM1zpAL4zdAzU+
         NhiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775232057; x=1775836857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smlalJP6W4oXJb7plM4HOYk8mDYdhNOc9XE7DYiHv4c=;
        b=a1f5lNwJiAm0TGs+sEWU6QfG2WtDoFox/x/qmgvsumuMWIYC9S6+T/cIQX3T1Y1duX
         lId1pWuHWQSyO9v2RgjofvPo0/vdceanEvNpb7zVV49TLxz0HqqW12CpxNV8z/rKdMME
         5j4+5pcx83XncSRS09GllTtDVmiZRq+TJUOf+Vqi3ZKMkH2WfTdXit4m1T+Cgp6dToHK
         ZJ1NTfsLmpFsosakca71KXC7iVl4ex13VfGLmDRsEheEnfwacl8mn/Egl8rEJQpWuxSA
         GcKpHHzuhFp1IIMxa8rLvEnvOVlu0Ro6huIEh7Pm7fsYRv4bUb8dljHYdtOfKRO8rhnI
         nmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775232057; x=1775836857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=smlalJP6W4oXJb7plM4HOYk8mDYdhNOc9XE7DYiHv4c=;
        b=i2Xz09S9vehzntXncp/e5WL/RvVgCqbrnfaSra15kGbGQQW+gDvaq4IZCdWHa+yDi6
         Ja/eX1o+xbFRbRbiyeS6vHbMIy3OA3OXGhs37lQ6Simtsfq6Xg8ijforXNtMAEy8F8Ux
         F8wEXaoyNZjnoAFvb69dHvv3wAXIL/C/cP+YzJOIo6GylEGsowmSFvxrmev0I8zW8XrL
         37mSCzt+WD6Nzr+rc1Ny/pLWr/WRNNZHX6i+QyO0vwtULySuRrouUDReAQrsA7Qz4lTI
         c0pm5g5w3JSbYuZ8Tw8nGDvk9S865u0nmP7mYfOq9VzCQ8OMidqOEgFMlfQm05ZVmVnE
         CdZg==
X-Forwarded-Encrypted: i=1; AJvYcCXVdQXRB0mRcgLa1TRpceakA8hNeUvO7LC8/t0V8+PisZCKdzZNlZ8lqlnsmcRkRMsxvjlGkiNFCBXy+3m+@vger.kernel.org
X-Gm-Message-State: AOJu0YwUWgq/C9rkq+1nsR61p0Zu9MHpStD7wv/cei7hCcmTsq6C1UA1
	gCmBlSBMzoxT0qHmx8qQu5YhGrKnE5zKPofsMuNV7g13D6d7byN+0YNxRiwXzc8o4/39NEOHB85
	7d+4LYSTtzmnWt8RvDLzfjVtTRpi84Zk=
X-Gm-Gg: AeBDietrlIwZPXFyhXb9pQexrjV2uL0GIRZB7nMa9MiFKtnGXonqxDz0c6BavHTtkG9
	zaJZ0BHFgyYtNv1wZBL/yM9Mv6THh664bUKhWXMvaaPW3Ee5W+zakXCd16yNNKSS3lZan58MTOg
	h6sRXxy4m2mhAo0g8NtjmntYMteaPUzG9zlysH88zidg4SysKiIFhuG4qUMjMnwIZaN2Iy+fnJd
	7/JH3m/98TmpoQUDoGKD1olOYzL5oTrJ9WVjAgDnngdSJJlerbt7U/NgMnylUaRBR4a9TxW9V7G
	P3cxczipbKhVyqlbaEj+Yut6PnZA1gE/UZiuz/Q=
X-Received: by 2002:a53:df06:0:b0:650:b0d:f4bd with SMTP id
 956f58d0204a3-6504874d4e6mr2666334d50.24.1775232056866; Fri, 03 Apr 2026
 09:00:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <2261072.irdbgypaU6@7950hx>
 <CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com>
 <3036842.e9J7NaK4W3@7940hx> <20260403073055.031275d9@gandalf.local.home>
 <CALOAHbBBf_vWcwZp9kdXhpFOq_oG87X-7Nj2yurZ6LgBpDHwwQ@mail.gmail.com> <CAADnVQJobMwH8Q0LtCrwbD2TkzFaLfRaw9gyVnhDpMWGmLFVvg@mail.gmail.com>
In-Reply-To: <CAADnVQJobMwH8Q0LtCrwbD2TkzFaLfRaw9gyVnhDpMWGmLFVvg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 4 Apr 2026 00:00:20 +0800
X-Gm-Features: AQROBzAveI_l2DNpt7U84Ib2Mv4Qw04LElhCVGE816Jd6EhbLPSjW1ZrRCTxVQU
Message-ID: <CALOAHbAiNQaVYO3WeNvUBzw+4zAM-ZjgxYWKX5e_0Fw+KX-ZPA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Menglong Dong <menglong.dong@linux.dev>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, 
	Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	KP Singh <kpsingh@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, 
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2287-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FREEMAIL_CC(0.00)[goodmis.org,linux.dev,kernel.org,suse.cz,suse.com,redhat.com,efficios.com,google.com,iogearbox.net,gmail.com,vger.kernel.org];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 999463960DF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 10:26=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 3, 2026 at 6:31=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > >
> > > If this were to go in, I say it would require both a kernel config, w=
ith
> > > a big warning about this being a security hole, and a kernel command =
line
> > > option to enable it, so that people don't accidentally have it enable=
d in
> > > their config.
> > >
> > > The command line should be something like:
> > >
> > >   allow_bpf_to_rootkit_functions
> >
> > The feature is currently gated by CONFIG_KPROBE_OVERRIDE_KLP_FUNC. In
> > the next revision, I will rename this to
> > CONFIG_ALLOW_BPF_TO_ROOTKIT_FUNCS and introduce a corresponding kernel
> > command-line parameter, allow_bpf_to_rootkit_functions, to control
> > it.
>
> No. Even with extra config this is not ok.

I will send patch #3 and #4 as a standalone patchset to upstream the
hybrid livepatch first and then figure out how to move
allow_bpf_to_rootkit_functions forward.

--
Regards
Yafang

