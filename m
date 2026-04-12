Return-Path: <live-patching+bounces-2333-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id h0+0LKGe22keEQkAu9opvQ
	(envelope-from <live-patching+bounces-2333-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 15:31:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01AA53E3FF5
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 15:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA5B43011108
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 13:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9484337CD28;
	Sun, 12 Apr 2026 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cczCth2K"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD7E37C932
	for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776000664; cv=pass; b=nlDLbcTCBpIHUYL/IwCBOiCMADQ3ASaOOxT3giYWkGdFzYNTWo/6TeW7TRcSqs9LG9zQrx62pSLPFH5scvW5rZR99YpTgYotC4A7DL0/xwlfRku7iX9JgonRqfx/qfPxBONaO5olGDA1iHswYgYW2mPaPkNpj0tj3oAVgKiIaXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776000664; c=relaxed/simple;
	bh=C6RY+r5Ylx4J7Ow2wiGd1LhoQuZdYHn356nitvzkRbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ORtuxfaDDI5cHoA1ZAh+RP+eQhlIVjLkoCPu6EJesRHAUc/css+UboKFzTAhBlEXZ12AVFQlM84QiTG41BPmNOtsNJ4Br0x2Jq7Rp20V+G1RQUJN+hep8911UZLwej3O3xluEt9mrUU6R7if2PuGCIHJdfDxBO5i3lVQkwhX+GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cczCth2K; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-79853c0f5b9so40783487b3.0
        for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 06:31:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776000661; cv=none;
        d=google.com; s=arc-20240605;
        b=HKLvETxEAYWYPsdU2zsGPZ8pj3DLtRdkKjiqd9BAOOXQ+p66hwhJ81t6wPcBm4AoOB
         pw8nx1vRbZDCX9rglDSwRmwDeaWv1XnwSQYJhd9eJVQJzTRGHQTiZ3pwukOmu/ZQmcJK
         t18eGQJVRvdl9Otet9BiXyRT/eXJPaVZ0YHr0wI4omPckpKDqo9pfyRvzPHjgZy1wW0L
         nBCHJPSkWj2Cw7DH/b9rITsfg6sn2y7BvnQGGZYPjD8n0Dn2Q6ZEavPXzOLk3nShI35a
         DZTdvao85PA0VdLIYAzZW9nnsRppErE3wyNwz/KOY17BgSMrIVOg3YK4qWXUGvXsdWAd
         8QDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DXgBrho6CsK2+t2aCD8rZwM6Rey4DYcpPa87+rv2X+o=;
        fh=a4vpdrUgYwP1qX5++cQIlldzTFZbN9RQQmkcQmGRiY8=;
        b=KA7+NVXyNpriezZgM4U4LCTL+BMPX5fneUSEYaT8bIwDJKG8prpUMjib+PvMifDKPm
         16rdLGghJb5ZwYD0GKShwZUm78AC3DNhRA4EbUqJ+tl5rS4TA3mPIRoWtl4EUrdLxY1+
         mrlr7p5YmdtnVjYAk8RMRlQP4zUs/AZ6ApFAdEb5r6y86hWnjGCTGqLbtc/yRyTkjcR7
         CRCbQBz7xNZhAJzvbJjh9X8Z09EZcRm9ILbZL+g6yZ7sCo4MwfVGt8vW+0JOF2/P2ady
         hvvSSV5jZuVLSh8rs0eesZjou5t73MJNh9TXbjW0Mz6blOdjEKxXrSTOgNMfK+k+RMSq
         o+Vw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776000661; x=1776605461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXgBrho6CsK2+t2aCD8rZwM6Rey4DYcpPa87+rv2X+o=;
        b=cczCth2K2sLrPD/N/YtRFYIWH/K5oQpNo2MbO63jR7NHToIIVLtbjhFkN+DrOXvExl
         Tg4QrGPYfiJ/PPNLeI1zmXFG9nQS404LC+bh0X56h+tIGRtYylTrzausH9VjXutVzP09
         Bvu5y+iKG8/S+T8XjWZu5PPy0i4bmG9PVW2ZlD8JS5cLn6w8RSKjxefOsS1TXw+qmT63
         g2HFvm7ff7qGhNG7hVfE7Li9jaYFumJHU2EJ0gq2g8uhg9XRusNlHP0QiPY/YKy7s23t
         8zJwJNPlShAA8cEQFLSVgraqOcsypIf/qt4TwZWv3Q6J8BIGZ483BshRrN4EsaG0QLFj
         PiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776000661; x=1776605461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DXgBrho6CsK2+t2aCD8rZwM6Rey4DYcpPa87+rv2X+o=;
        b=JfGzLZkL+YvhSV6s0VufQdPqqRJv1BLomZwYDBSB9ZPRVFNk7BUFYk4Ky6RQ7p2XIS
         l1sPh0zGvL9tf+bhWmYWDJOL0P91id/FWfztBvvjG92PwY0L2XMSp7vdDGeUCzt3AxfP
         ScMtLAXKuMPwucxRcKDS61JzQNAKJjwazNw+IXJmBurLuV/avhBgMqq8PKYsNJ88AbPm
         n732OCUhgxUnWd9zVoFONF1MVJDFhZ4q7ul86hjfkxYCqIVYCT5V0VBxVfZUST55+OFk
         D2mI2IOG5UAeRHZvJeNZarDj/TOg7KmYv6lhCA/KBT1LI0lnxmOWHOTKIwOusADOaZWz
         aJUQ==
X-Forwarded-Encrypted: i=1; AFNElJ8vt73g653/KZLJSuVYhXysSqqf6gNtuTwyqEpbU9VZFV1qm9xuD4Hbz18h8pYlVTnfy8YPDhY23lIYjGko@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjlk1PIJJCN1A1O+jzzpR5k/FGTJXz0pn+Qnvu2ndyYJignXxB
	fHAc7dCrE6hK4YAoCc26rSpiTvxPOrWe/L1b7+ErfMFrYMq6Vf9wQfg92YSmLtalUHhgo3Mk9JJ
	PW3jTYZdaCLG3QB0hP9SPhkE3g0rfLbs=
X-Gm-Gg: AeBDievt9pj+cmMgPmpEhj9t4NMRwQa7z/BswLfo/0dkg29R8w+8NfiMGbWQuNnZ3MZ
	bxOK77cOedM7AYbsddkqoml6foyxaJ6jdol6yFG0NRAGB8F/g0CMphvSip3yqlvMDtqs28dkIvT
	gisLqW/AEaqyBHp2wI4xxUfj6kdSS0Ekbx8GIzrnPNF/7oeoy3ounZ7k6Bijz+SeG1PV7/6HjD5
	78wsI8+Q7TqcPEGS8tECjzc2VYPvArt2NDZ/M7zdOCnXUjLWBkXdioSsA9XatoCwcFf9lUc/naK
	0eOpxoa0Ytq8X+GfizRfAQ4vWBrEMJMG0d8LhzkX
X-Received: by 2002:a05:690c:8e1a:b0:7ae:dc4a:ff6e with SMTP id
 00721157ae682-7af702dbb9dmr92247417b3.24.1776000660995; Sun, 12 Apr 2026
 06:31:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
 <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
 <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
 <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com>
 <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com>
 <CALOAHbAmTAfamStF9sZtO6efWYJ1sbXJp3PbsVapZf7dba91ig@mail.gmail.com> <alpine.LSU.2.21.2604091205250.31526@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2604091205250.31526@pobox.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 12 Apr 2026 21:30:25 +0800
X-Gm-Features: AQROBzAhZ7uy9uCOnehpJbZd9tdZu27AddmcCPfaAwa94iQun-8NAS1qnJVKEUo
Message-ID: <CALOAHbC3-_zW2CbHccy8kCzuBj0x4LeraeEt5DdUV=CdrxCnNw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Miroslav Benes <mbenes@suse.cz>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org, 
	pmladek@suse.com, joe.lawrence@redhat.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kpsingh@kernel.org, 
	mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2333-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 01AA53E3FF5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 9, 2026 at 6:08=E2=80=AFPM Miroslav Benes <mbenes@suse.cz> wrot=
e:
>
> > Can we add something like ALLOW_LIVEPATCH_ERROR_INJECTION() to allow
> > error injection on functions defined inside a livepatch?
>
> No.
>
> I am sorry but you always seem to find band aids to your set up and how
> you deal with live patches internally. While I can see that something lik=
e
> a hybrid mode might be useful to people if done right (and we are not
> there yet), the combination of it with bpf overrides or anything like tha=
t
> is not something I would like to see in upstream.

The upstream kernel already allows for combining BPF and livepatch to
override functions. Song=E2=80=99s patch offers a great reference for
implementing this without changing the kernel:

  https://lore.kernel.org/bpf/20260408175217.1011024-1-song@kernel.org/

--=20
Regards
Yafang

