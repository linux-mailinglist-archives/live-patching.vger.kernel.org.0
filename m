Return-Path: <live-patching+bounces-2286-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCtPLKLPz2m50gYAu9opvQ
	(envelope-from <live-patching+bounces-2286-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 16:33:06 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 197F0395453
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 16:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 640A030D29DE
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 14:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F513C3BF7;
	Fri,  3 Apr 2026 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyWNstTk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA8F3B3897
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775226388; cv=pass; b=qUZZkus5aDC7b9fGWpO0ISirxSfZxX8DFz4VLE6QCTjic5qfKVTdSruaD+w/hg+JPc17t5avCilTJtG4Sx18TxW6Y8EBgtFkifQd/MWsIkOei67ncG0ynsQnocI5Hu3MTMf58mceMyUh6Lcn2eiBkZMXqcofmF9OAemzqzDbSsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775226388; c=relaxed/simple;
	bh=aTlV4pdjF0A3x3G2ruVJgTbo99ALv2Bdf7K5KuSGaA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kjlqSPAeS+OGDbA2Vu4A/PMFjxSWEE+mZ3biuFfBN92Mxt1Fy22iLhJjlVBLOI40usPVvYwIcH+d9eZ9rrwWj0pV7016tm1UlHUG2ePbIfrnMPaBLLGB5qZJrOJTZdag0KMnGwDJY+XNmQgqd1tmJBgQCoFBA9T2DDtK5vHrYrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyWNstTk; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43cf3ee0fc1so2174570f8f.1
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 07:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775226386; cv=none;
        d=google.com; s=arc-20240605;
        b=EOI8/PEnTPDhS1lvXaYHdIApvKmprkWCDIWH4JA7tiC7944nO+Zcp9GP7lssCl49db
         o0H94gL1N4WGYU/rLcXUe8t7Pt0VwJd238zAZmi9qm/0pDttpBjX1i8Inv0xfnzBq1rT
         jDBgaRfHbiX5lUd8Ma5J+N/BK9xM9N5PahXeAeZtUyVovGxoY5hw1Y279ONy8BZQ7+PY
         +wa377887M8o4DYapiq3t/pc5fHYsYL8d3Jug6tR29miKz/Ec2PEUAfYvZmJfwte2+xp
         gtZmRVwNwtJfWoYmSjGVnAJ2tLhfVUWfYgWwIJJVYdngZoUGWCRDZ4PUsA+QqxrPfoEE
         A3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EQG9ormSZqinIg4NJRtHRTZzS9AQV9/8RBCkndY0t44=;
        fh=DM2fnhkcvKh88wJI5liO8SlQqUhMHfggt0CtHZlA6rw=;
        b=dlky4Ejb12Hfs3g/XkZK3Hm6qOQ3ux3fOnB9ujl6z9r7thk0hccqx5n3n1VivkZCl6
         7geD+SQKuO4Cp+0q80krTfd4b94IjLt1tZ/VyiKaYtdnRXgdRcAfb55u2UykMJaZoWwn
         +ZkIM6TCVJpu/OTvl2TC7MbvtzDsXLZ8OgiI6sAeTU/U134cQcS1WbWb1firo/+wlHYL
         +VyKysfrAy4Hw00QFfogPm73Qmt5RHkIlV2WcG9DviWbigjmKsGXw+4f9IDw1AkKdPgy
         POc2/mISntgZB5l8BqrLAP7oWQ4WIHvkbNgc3BTrjm4ltlBUcMti7OmEu72O6lzKSJuR
         h+5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775226386; x=1775831186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQG9ormSZqinIg4NJRtHRTZzS9AQV9/8RBCkndY0t44=;
        b=TyWNstTket7k93kf2CSUZNM3DacCpy86gyKAGSleu8FB3WkuZ8QpXceC3hGg+tZOv/
         pTMNrv2ld/xq6G9W7jDoLNvc/e5DHI2eZj+8wtFXF9o+49AdYy9TdHxHamlvUhtMT5dg
         K3F96DNamKnOjz7Jqpydy7AZtQJc6x7BdyL0JbFpY01mnNfSN10Ron3HEr6rVVr/c1lk
         G1jGdKOMByI2giCQUaVPrNw1s8KvwTdNWhgUK/puHhk8QpIgbWKI39LXTpfFtT1L3ucv
         CE0lGHMbkb5TS6fdnkmyUZecsP+lwS6qb0otlp4T4t4c5bXtGtJ+QsVYLnxd1hduiaLR
         K2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775226386; x=1775831186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EQG9ormSZqinIg4NJRtHRTZzS9AQV9/8RBCkndY0t44=;
        b=jsfzpjruInfekPQUyJlDe5O32ychZGCnyOIq+h5S0tQqGGxfH2YksHD/BN4a030MHS
         GtM629gqxzpi9iWY5G0aHIjKbOKNcLLm8StRB3wlT3aULSXVIXu6vjcQaLAFaRhuMGDv
         PSJsmD8ECC4OuKSNWwJ1AUtuqVd+1Z+/pmZ5yB2kSXDFMetXfIJ+79+bI5pj8mQbFljz
         RVfKzqV9s74zvnyORIEr/I14e0SGOcODWKyxonMmu3DDK1HUBTqTOfFNJm5rAZuDgja6
         q7tzbjQ3yGeQBJuiwUu9FjrtjlJo632DNFD7jNIbHPaBhwnI3bF3zlKXfrVrhw979y72
         Xdlg==
X-Forwarded-Encrypted: i=1; AJvYcCUVB7PstkZS4Gq9eQCH+kEF8vW0LTLg9rGfBowsZBFxYPQ+vE5KRk0ZprQiaR9pQbwkKzd775JiMM/97PDd@vger.kernel.org
X-Gm-Message-State: AOJu0YxppptwnxH51gAECQTpEuMGkCDj2bRvCus43w8KohUtQGwegoW5
	VkkEZTrQX497rb6W9Zk9gFPgeULqR+kILogjEZ701SsqGFrEj+8E9JWdZRBIPYyDiaqgTB647XY
	vvi1coeZpBmqfrpMd286GSFcuscpZpnk=
X-Gm-Gg: AeBDietwXNp5/gbBpK95UfW/1ZNY6OphsMwv2SffC5BgQW7XvShunbbGCFtK6LLDCR4
	hs5GjPvLap+WMfdVWMwmcY+W797o5d7Bmk2tNKoupq8+c2nGQKsBUsy54AM7o/Yjx2SCt+mnz+p
	KuC2WpdSO4QG+BxANL6CVTvm8eOH4sHNs5PNsPkN9mWWyUkq/S7v/le7igzXB5WmaNTbPc/TrfZ
	nzh3XnnLZLGDba21UWiG/XqCzHtOZt1xbJ5+gkxVTp5RxwPiTSXFg2ClpFjP7E+JsCAI7IGskTq
	wdGfZGVi8JJTnRKs6IlhZGpUVZlSmFzYveURLZeAED8K9tOIpgXblC+6rTrsUO4iQEAP0LntOtq
	39UI1dgMLjnDImgzU0arsz4AO0g==
X-Received: by 2002:a05:6000:25c1:b0:43c:ffd8:e25a with SMTP id
 ffacd0b85a97d-43d2115ae92mr12434422f8f.5.1775226385615; Fri, 03 Apr 2026
 07:26:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <2261072.irdbgypaU6@7950hx>
 <CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com>
 <3036842.e9J7NaK4W3@7940hx> <20260403073055.031275d9@gandalf.local.home> <CALOAHbBBf_vWcwZp9kdXhpFOq_oG87X-7Nj2yurZ6LgBpDHwwQ@mail.gmail.com>
In-Reply-To: <CALOAHbBBf_vWcwZp9kdXhpFOq_oG87X-7Nj2yurZ6LgBpDHwwQ@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 3 Apr 2026 07:26:14 -0700
X-Gm-Features: AQROBzDV9yg9kswgmI7b9-0JLFkgfn3BK6Co2WBzJ6xPcvBEERBNPVdO--RgW8g
Message-ID: <CAADnVQJobMwH8Q0LtCrwbD2TkzFaLfRaw9gyVnhDpMWGmLFVvg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
To: Yafang Shao <laoar.shao@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-2286-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alexeistarovoitov@gmail.com,live-patching@vger.kernel.org];
	FREEMAIL_CC(0.00)[goodmis.org,linux.dev,kernel.org,suse.cz,suse.com,redhat.com,efficios.com,google.com,iogearbox.net,gmail.com,vger.kernel.org];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 197F0395453
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 6:31=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> >
> > If this were to go in, I say it would require both a kernel config, wit=
h
> > a big warning about this being a security hole, and a kernel command li=
ne
> > option to enable it, so that people don't accidentally have it enabled =
in
> > their config.
> >
> > The command line should be something like:
> >
> >   allow_bpf_to_rootkit_functions
>
> The feature is currently gated by CONFIG_KPROBE_OVERRIDE_KLP_FUNC. In
> the next revision, I will rename this to
> CONFIG_ALLOW_BPF_TO_ROOTKIT_FUNCS and introduce a corresponding kernel
> command-line parameter, allow_bpf_to_rootkit_functions, to control
> it.

No. Even with extra config this is not ok.

