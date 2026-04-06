Return-Path: <live-patching+bounces-2295-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPnUNUOU02lWjQcAu9opvQ
	(envelope-from <live-patching+bounces-2295-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 13:08:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B55B3A307C
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 13:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B32E7300D958
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 11:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652AD330B30;
	Mon,  6 Apr 2026 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZ4QxFvv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF89F326D51
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473728; cv=pass; b=VuXLI2zByuJEd/DFd1iAXH5rZC/EDkyRQsi2fsYRD2JYMDU1IRY1hTW66sm1XH5TXGtEaH1kAnmCqGhA0+smb8g1wVkmxS15xe9OCTgrEvA2wTB+iMO6ZvMXvXYTKJ1o9MpCW6sdAd+Y3q0vYvoVb8okc37S6x0xnGQeIposDPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473728; c=relaxed/simple;
	bh=3Mn9GDNV4q4vxUyTCDjrB4FuPzCEazKiwy8siM7vem0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kFECXtQiV0gFatawxuHBegEBgsehjquFeSvMsfH98uRunr8nZHne/y70FI+qjNjn/Atu/dKE3pKywx0tWoYwdWnzeqbJgO8snBj6DW9rHVUneTwJt5Od6mU7G4n8G+8eZTEejYxKFHV51sL62Prh+PGkJYaJEvd/sd08d4jahx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bZ4QxFvv; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79c20063a32so37488087b3.1
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 04:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775473726; cv=none;
        d=google.com; s=arc-20240605;
        b=EeiMd+2+ilZCxRs7hAw8hRmMoeubc4XOm4uPFd3SCdmtz45KgTSMlocb6iZO9kcDdL
         Latddgg8Mxykb5NfeHkpogLKddNSR/IyiEtgRpH+0gpsaQpWthkitDe57DKYygsh+LZN
         Ld0iLD08ZX//alRD9FDaWzXyWcpr2Ap6Q0bFZW/zELIAkKdnrYk6uhhfff5O0/5wTSH5
         aFnx0zeA/otIFtFYcVL5ojuO3vJ/3wcm2P1pE1MjJ/mGd0bpin5olE+oOlFou8es2+G+
         F/9fj8NAGDT167INuA0W8/SIrfgZyM4ashQOmclkIy6gwDjS9SUF11qVa3h2OuP1L59i
         qe+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zRgqqTkqqqhQIPLoGqXnLl2qMP89ZJM8SI/ZvvSsQH0=;
        fh=8aYfpwwJhlWAvyd6KMua5tGNoXLBuVc72xBhiwCUNto=;
        b=h+vBu9sWR2yZ0/U0OBBdnQdlBkKljOV6YGqQCHL9JS1M5Mh7Hgywk3NKG+qYVXGms9
         n2s1Z0q5/pbgSJhrJNi54EZT5cBFz9VjXNxs0x57CNp8ktdwkba9gyf84jKmrEvqD0D1
         JuH1eZB63o+sP0x4t98yiVsTEwHEc6vyeB98R9NfmRZr9eCtRjgYFh5iiUS9hTGlRXHN
         fHDvztCvNiDbY0jRuPUj2qpc/Bq0+eEtd4odobGujbehwXqPHHbCUWgEoZEHphVWZgkr
         GC+9YN2Lb1DT364c633yrlm6Xl3x/7rH2edLWRRBWku2KviiWn66X3zYQ3T7FXU1AHRe
         xpcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775473726; x=1776078526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRgqqTkqqqhQIPLoGqXnLl2qMP89ZJM8SI/ZvvSsQH0=;
        b=bZ4QxFvvCM5l3OfS17/UpRJc6ZJYHUz5HZaKqfP8flALIwz3RSXuxVwG0I5ZJkIycL
         za6eysKesfA0qTLX4yCyCNKpJIaoCIMQrsntOK5NZxezP7j1ZZNMBUOguMZMFoH/ixWP
         fZmSSqGg5rwuZzBwv4Cnd8OgGluo2uBJuX5dgVEar6b5luVlWgLCS8FlypKqSRWFr8Om
         JgTdHP3cPcaa4za0n3e0gOd99RUeMQxVxMtc8Oh3rnP8nISVZWxJeLd0Ccz6AWjOk5IZ
         7JNVANzPpUcQMnoQkrxKlojWRNcO0+Y2RsW1GzgUFGSUdAkUqhuf38puYV1VY8+QCwJI
         Lyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775473726; x=1776078526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zRgqqTkqqqhQIPLoGqXnLl2qMP89ZJM8SI/ZvvSsQH0=;
        b=PWGOc4WcDKZ1/lpE2jyRE4bgcyrJ7hbqyhGfl4xH+RiZV0TBIM7NWU9b65zmcm7uGq
         SUh7ZRe6SlrduTAqHwoQFq1brQt7yllXdMf324weU/hf5v0BzwvgOuf/AqYgCvOSE2yU
         CBKe5cA73Xj9gwloLjDopD6Ci6HsBWgP0ckinVP6nOQAm2A0Wzk9F+1NaN1Zkp/ElBis
         JKTu2l7DTZ56S16+cj4URRtGiKpEFgaJj3hqY8MWG+vdblUdwi0nP9U09yR9sk+qFYhv
         8zzV9oYrY9W+EQ8w6y76KQalmjxd9TMcXOCvperwYupSr2i/wKieDk0HRQvAw8Fu0+56
         B20Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYySbV+hedb4obk0Z4CvIjHVkVovzsmS/Sl9uhuaZAvPHPZNNsZOxeUl4QtWywBAvyRZKDHX3ld/IF/195@vger.kernel.org
X-Gm-Message-State: AOJu0YybpZgmociFGKTdyJyotvqwdNu0wBFb+omfd95bhNP6w2IiAQZm
	aDk6GWLQ61YEjopwWqKWgFgANCeSSUCjelBNdRvffXjvSmudUxP7HKj7GAssyBAkc6dGh7j2h2z
	iM0dRLt2UL0IMjhafWtxlluWu/zlvvtk=
X-Gm-Gg: AeBDiesN8eExHXIQZ99lXm1n2iYnFTcKOBmuHzhkoeMvlxBlVM5z3LfCYzuLqtB4/WH
	2FrKV3nZnoc2dkhe5cGWNrH/s1bRqlqFBY3GVVf5QUvcnS7ICN38Kfk7DdWlmUIqQKx2NIARg/L
	KZwYqhrwpvZQT92vGwOxFZHqg+XwpUHWn/ty66FDN3vyz2F5UNtQin4S6q/fX5SOzhXVBCc6ryV
	zMqFZ2a/lgaLBvFbtrfGEJDHRpzNQtOZfLDXs5374SLsWo4YQ8dXfrH4dCEpjLJYGVXiCF1TA+V
	LnrJ/1lirwGU0etROmvOFBJcZ12XgxdyRdpb3Ug=
X-Received: by 2002:a05:690c:660c:b0:79b:e051:96e8 with SMTP id
 00721157ae682-7a3bdd81cb4mr120300357b3.19.1775473725931; Mon, 06 Apr 2026
 04:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com> <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
In-Reply-To: <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 6 Apr 2026 19:08:05 +0800
X-Gm-Features: AQROBzClNHdpWRN0VTHhIbiSXgzDQrDfqIlpgmQNcrbfQYOo_c0hDREkWaKO-G0
Message-ID: <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Song Liu <song@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	kpsingh@kernel.org, mattbobrowski@google.com, jolsa@kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2295-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[google.com,kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3B55B3A307C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Apr 4, 2026 at 5:36=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Fri, Apr 3, 2026 at 1:55=E2=80=AFPM Dylan Hatch <dylanbhatch@google.co=
m> wrote:
> [...]
> > > IIRC, the use case for this change is when multiple users load variou=
s
> > > livepatch modules on the same system. I still don't believe this is t=
he
> > > right way to manage livepatches. That said, I won't really NACK this
> > > if other folks think this is a useful option.
> >
> > In our production fleet, we apply exactly one cumulative livepatch
> > module, and we use per-kernel build "livepatch release" branches to
> > track the contents of these cumulative livepatches. This model has
> > worked relatively well for us, but there are some painpoints.
> >
> > We are often under pressure to selectively deploy a livepatch fix to
> > certain subpopulations of production. If the subpopulation is running
> > the same build of everything else, this would require us to introduce
> > another branching factor to the "livepatch release" branches --
> > something we do not support due to the added toil and complexity.
> >
> > However, if we had the ability to build "off-band" livepatch modules
> > that were marked as non-replaceable, we could support these selective
> > patches without the additional branching factor. I will have to
> > circulate the idea internally, but to me this seems like a very useful
> > option to have in certain cases.
>
>  IIUC, the plan is:
>
> - The regular livepatches are cumulative, have the replace flag; and
>   are replaceable.
> - The occasional "off-band" livepatches do not have the replace flag,
>   and are not replaceable.
>
> With this setup, for systems with off-band livepatches loaded, we can
> still release a cumulative livepatch to replace the previous cumulative
> livepatch. Is this the expected use case?

That matches our expected use case.

>
> I think there are a few issues with this:
> 1. The "off-band" livepatches cannot be replaced atomically. To upgrade
>    "off-band' livepatches, we will have to unload the old version and loa=
d
>    the new version later.

Right. That is how the non-atomic-replace patch works.

> 2. Any conflict with the off-band livepatches and regular livepatches wil=
l
>    be difficult to manage.

We need to manage this conflict with a complex user script. That said,
everything can be controlled from userspace.

> IOW, we kind removed the benefit of cumulative
>    livepatches. For example, what shall we do if we really need two fixes
>    to the same kernel functions: one from the original branch, the other
>    from the off-band branch?

We run tens of livepatches on our production servers and have never
run into this issue. It's an extremely rare case =E2=80=94 and if it does
happen, a user script should be able to handle it just fine.

--=20
Regards
Yafang

