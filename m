Return-Path: <live-patching+bounces-2293-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIOgAz2R02mrjAcAu9opvQ
	(envelope-from <live-patching+bounces-2293-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 12:55:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD843A2EDB
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 12:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15BAD3010175
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 10:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA6B32ED3A;
	Mon,  6 Apr 2026 10:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aa3n5j/D"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281FA328B7B
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775472954; cv=pass; b=Pw3qn46zB4K0YEb87vtRfe/RFp60A8JslPiI7yf4dzUWrbRjnim8sd4z8oR5hZLcRPRkcKqiCOg1u1tbqHQRc+a+faOKk3dUb1Wu81BLysmCY1haGWX4aVGSW57aXDVH9W8heguQjQ7/iz1K3Wao/2P1KoZ1NkM7Yk0i/APdkec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775472954; c=relaxed/simple;
	bh=yqtwijJFAq2Vipx/7BM0rX+3bcBaOGswp9DDHJJf19A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kVrtxHbLwjnJfRnFM2oe11d9iekzBiJweuvVYDu/NoJpBjCRYmA7inZtoaeEsj56DhQQdWeeEHiJN97XmzlQf8EqusybNQ7VzYZT8rgwMReDRCWvUzWBiqvJTi0WKQB6Hw5SkaOxZftyBvwAze+/TBGg6f9u4xDnmhWHSkcp7ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aa3n5j/D; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6501c0399c4so3323157d50.2
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 03:55:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775472952; cv=none;
        d=google.com; s=arc-20240605;
        b=Ojn7LWtzrUfUSi3a1boJFDTgyGyh33vKt8sprPfj+B3a1HWIcceCgdUo1T4lobtqae
         s5AKK5o3qkNEjJoB4OM+6wjRUgOBorv9i92TrzIdQh4ZSZUEJwv8LrOvgQVSXTmAeIQP
         xrwBt8ppZni+ft1727+r5uGDVBYZi9Iz4wI1kDGCQoGgR2SxYdOHL6ZBlOAmAgb5qE0G
         0fQISeJtU/0GoQ/Qoq9XZZrdqUutifClBlW2Bk61kjFv+5AuekBgn9W6NG8qSNVFm1uE
         ciEP/eEjNvmKVt7ZdDqw1KzCv8dPsH5eHZpXZmlVI3Ij/O5EQdyc8nJvLpGnHJXUD6Jj
         k8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7uq6NOmuMF5oFq3KCbCddyHNt0qGPgVd9ZLN7F8nbAE=;
        fh=Z3hsT59nU+2MsXZ0SDA0kHeeMze/dudvA+sMPSM2Lls=;
        b=TEoCIuQOyyS9GcwYFzEDJV5yzKWuOrn3owFvhS/bAm+ET95yjD57Y5jAVT3+C+qT6p
         BAu5Zj53qo87dKQfBqsg1t288ZSyVTdD//PXUb9LQgl+ESGSb4PiJuXtd96m6Gej60na
         HyyW/Tz89SxanNMms7uu4UonHbapv210dZp02T4tFK0KcWvTnc6LmFsMKr+nprr97YKb
         jnKk17YDHwqLjwEJD5ygozOAu6QRq5KAkNVyQtJ5McRagKxpX/NX94mUmli6AtcRqsL6
         mGQz1grKc01SVqAMmC6pC8PlqPsSoz8M+sXRNFH9pklIET3c3HhlHklfDW5Xjk++8Bxg
         dilg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775472952; x=1776077752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uq6NOmuMF5oFq3KCbCddyHNt0qGPgVd9ZLN7F8nbAE=;
        b=aa3n5j/D15RKLLEqR7to+GtxRAGugLHhde/cNcdw2n7LGYBdwRAHAjMAdRqbnbDP1i
         7DF98zVf+wT3iy5LrysjBm1on0an7JDysMAtLEx2NIwI3yCnB+WuUhs6FdaZ5uELrOV5
         qWqB0KU+Fos4hz7W/17uTAlBctEZRSrWIXVE+qKC5arkCQJaZ58MdOE0D5utVNMLnswe
         c7GnIcoiDSYaB/oETBk1FF4k48pnNtESF6ogwUak4rnEj70GC+ipG+ej6rNVgyicuKkF
         alhzu23eVnFcSIz5NzqNDX25nUxBrETs9OaH1qxN9E5D00/gUgGDQ5nr8qFBeAXEj9hh
         SMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775472952; x=1776077752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7uq6NOmuMF5oFq3KCbCddyHNt0qGPgVd9ZLN7F8nbAE=;
        b=XG+ABQAUBAMChJ47Arj5CuLNSRr/rt7MO/kwkwSFh4TjFe0FQGFV/YOC+SdyrD75J0
         IKyKogyRKGIXsl1Xpxln3cen9k45C4LecFQsf3m+LTH+gxfi2/fblfZZpnIOKrFITZLV
         uXYRpwtnTpsQDyJW9S4KHiO4VUslum6YsWvTXwONb9ijYoWkSdJqtVHG/9w1zdzkDiwC
         9BQyXHL1oEs2nh5QorVDrR9sz93VH+LYb0JJarRMrTPMGC8nlD8pVVxEyJA8Dupr92Si
         /P3bW3EFB801XhIpVvZC9Amoz0gozo94Cpt6LNieh06BKC29KP6DdiB6Bin2J5A9/021
         KRcg==
X-Forwarded-Encrypted: i=1; AJvYcCXVdh/SmTRtSBB4S9/jtuj71Mb81gLtNqNxngirruQWuDkr9x0Kgy37ZOk8MbJPMLmnEoYf91MdSNF9Yg07@vger.kernel.org
X-Gm-Message-State: AOJu0YwvfQHjkxoADCg8PR/WuKk+dev5FJKqAtLkctumql5WAr+TXbkY
	FTJP6xp6Dgm4qILBCfCGvhr3va8z43JSRSIU6mq0d0xllcYVwT6Pw+fvpGpzkmt1h9j//qyjJGV
	fUlxn+laFcZn0K+fgS3FlZJEw0T5A+90=
X-Gm-Gg: AeBDietgG8iCFVwgHT1LGgQCVUBD2iYMD9GElOKJLu5Gcj1Y19Qey7dfr5p4P2ZBnOv
	e0GqUMbhfYFr56PdC13u1K6a6DtsCDf1xgVLIKgBbMHvkiqMgU7voCKlr879/rL5Cq6xqGbehCI
	CvKSPQS2i9lRZImzXK/6g4zM5T5rDoqYPOtBfv7825SvJGrzpslKKwsnAhW2X7Ew0bT0SviXZbQ
	NxEBnNjESp5YCeyouI3Ux1FFR2Ydv0rywxbq9/BQuei6MnFMR9PYYamLuXjFvaSSlEjJAv7ILYZ
	cDxSd0QhK1r3lzJW9cREn65BQ20tm6HyxSpdMHE=
X-Received: by 2002:a05:690e:14cf:b0:650:17fe:1a9c with SMTP id
 956f58d0204a3-650487755d2mr11770998d50.33.1775472952117; Mon, 06 Apr 2026
 03:55:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 6 Apr 2026 18:55:10 +0800
X-Gm-Features: AQROBzAue1hvnBCCEMF_NUELA-CKaaUqDrVovMjW_KAS9zf6eAY3_xH0-Hp_7YU
Message-ID: <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2293-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Queue-Id: 5BD843A2EDB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Apr 4, 2026 at 12:07=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Hi Yafang,
>
> On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > Livepatching allows for rapid experimentation with new kernel features
> > without interrupting production workloads. However, static livepatches =
lack
> > the flexibility required to tune features based on task-specific attrib=
utes,
> > such as cgroup membership, which is critical in multi-tenant k8s
> > environments. Furthermore, hardcoding logic into a livepatch prevents
> > dynamic adjustments based on the runtime environment.
> >
> > To address this, we propose a hybrid approach using BPF. Our production=
 use
> > case involves:
> >
> > 1. Deploying a Livepatch function to serve as a stable BPF hook.
> >
> > 2. Utilizing bpf_override_return() to dynamically modify the return val=
ue
> >    of that hook based on the current task's context.
>
> Could you please provide a specific use case that can benefit from this?
> AFAICT, livepatch is more flexible but risky (may cause crash); while
> BPF is safe, but less flexible. The combination you are proposing seems
> to get the worse of the two sides. Maybe it can indeed get the benefit of
> both sides in some cases, but I cannot think of such examples.
>

Here is an example we recently deployed on our production servers:

  https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqge=
o4C0iA@mail.gmail.com/

In one of our specific clusters, we needed to send BGP traffic out
through specific NICs based on the destination IP. To achieve this
without interrupting service, we live-patched
bond_xmit_3ad_xor_slave_get(), added a new hook called
bond_get_slave_hook(), and then ran a BPF program attached to that
hook to select the outgoing NIC from the SKB. This allowed us to
rapidly deploy the feature with zero downtime.

--=20
Regards
Yafang

