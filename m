Return-Path: <live-patching+bounces-2378-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4HtgG8fl4WmKzgAAu9opvQ
	(envelope-from <live-patching+bounces-2378-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 09:48:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EAE418259
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 09:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BD8523027E5F
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 07:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C59933554B;
	Fri, 17 Apr 2026 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJ+BKbNo"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4198736F411
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776411960; cv=pass; b=I9W4OWN/quDcQBV1M4JGXBnLx7buH6bvqQvIdnQzK2Hf2JzQunntOEJm4qo+De1zyU0oXE6qZiNk6HqrNM0u0i+WJqYhdtjhUoeQmfBaAz4AtCbaZIqEgAanqbBxdS4mbNoEP56ykFi5e8YEpPcX2Rgyk0LnwB2vWK21pM2k4EY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776411960; c=relaxed/simple;
	bh=L4y8xTF3zPC+EUQm7iZfIbHPgLZ2aykhKljwZsePDaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pMpWxvkekSHZBmL9kLJKUdGChWE85gBNuxKAZJfzjjV2d4gPeLJEJNKBh7XX1HxMBlBIS2iAtUGDOidMUIA5JShzDPeGxp09jkD23r0qnuuCOvWzi7HCZkuQwayYf0w4JL874Kqbc8I4huSGImxCYFD81xcjL759MPdOluPiBwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJ+BKbNo; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79a46260385so3290537b3.3
        for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 00:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776411946; cv=none;
        d=google.com; s=arc-20240605;
        b=ENMxcUR9BK5ZhXg6WXzkZQ/8BvH14rFfPj/M26mS+z9Z+yI6gyFt1wc25d+cWhsVdu
         vRmP3JazLITdyHL3Tcyj9Yk//fVEouslIsA7tKfAW2eVOhzErloZpaO5f5ry8wdv6xCb
         EW2+mfMW4I51E2mhLfOfPpCY94xU+XfoaFeh0zDfoY0JYpWucX/05RL5JP9NQDThioaX
         y6O9lJqY9k3u7Gg2v9BymDIka/D3hEp6aObGiw3rvTEDohEGLcW8RLCeL3eZAJyT/WRv
         A1dPWInVtv8xD1S5WhHDH2ZvPy5HLzPoxa7AZFPo6KHFSM0PZg3BGV7432UQ0K5/gWFv
         RYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eG49f8xQwb8uZkR40hS/ZxkgMMC9q41FtSu7g/I17PM=;
        fh=B3j+8dL5MLNsfgRibYaHLhf8C1DPUqdej3r9Zkfkrz4=;
        b=XYLQZOjlAwU1j1g1O/+vS5ROLfFx8Vn7wBqtYcMbOuGZgtQKssKVNv3FN/ELRTCzvz
         v3P95b5CgiUwzAfoUdSdhcX1puT7GKE65PidjE2eLJTFaJEsFhypuAfSxxOHClfXklkl
         8fHtyEnPe9aDmjG+cGYmjlc2T1dnrmo5Z/E43sYpjLPuWF3sQHvfldUamiTjeRDKYR/2
         9kIBcv1f7N7Uj101WVt8E64tr7VmolSZ9tm8nw4rTte1SDtdZtSl72lOzscG2Q43Qqog
         8JNroqLTyoYzCWr6lRYqajqgNSXOAhdpqO+qibu7QjwruPSCNd82nnlpqssJM+uyxTNG
         AoHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776411946; x=1777016746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eG49f8xQwb8uZkR40hS/ZxkgMMC9q41FtSu7g/I17PM=;
        b=KJ+BKbNornArnA5h0QDtGM8R5Xo/b/e1ROoFc4HiiM2rtuuZA11f3Zk19Q8pL6zzqs
         D3KFqJLY3t0lIA3+tIldpNjTrhgiYoQq6A5kY6nhofssVXcnDMt1G+w60XqKRbfkpKdP
         igBjNqNQIpRqckQ0I8jrLWY3tCKFLzAnzGvYQFlAcYOY0fFqdezdiAZrBYqBT5qq5O9x
         18dtoSaKPpV/q+A46waFxEy2xaoJtiHSEecHZSLsZsq/PLIgLqRLLIByUsGXb3XUi8bZ
         rrKUAtd3IHNr7QiDq/3WEtIAJwNVG1uNQ6boQiRSr/B2GTolCgaJbGC/gM0Sft0iRATc
         rdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776411946; x=1777016746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eG49f8xQwb8uZkR40hS/ZxkgMMC9q41FtSu7g/I17PM=;
        b=UoiuGTwJ2dqX6lYe44/aO2doTZ2Ckj1oJLNJIf74xqbenH+8x1UZCJscpfAmqf1ogu
         xAlfYJf9eoRanhfR+MWLEHauaWcpfX8wPSuWh8rGEnaicStQ2OPx5AEuLz596ycuBeyL
         UcLzREMOhJ7wBQb0suhfAc1o6h9NZNaHELGQDRTxKTezAdNFBhz6AdXGdVVba14tL5eg
         sRYyGB3kGr5sWN0wwisUeb0VkJSBEZtXzS1AbEY94vQz9KvUDaN8auLQ2lorzchQPihm
         uvU7oGSa/YSKzQCW+Dk9Uj38x9kx2/ijXy+C7ohJmcl5BeAw3wNGQ9SivbpuJ3aYFQtn
         YS9g==
X-Gm-Message-State: AOJu0YwIpv5S1ZTk61stxGpInoT/w6f1rM8mD2FWkO9OXNekwfB/vAqD
	CUxXRnkSeM/maIRo2RsWW9b0/4ZaP/TQ/mNyXVzuJO78FWyq//hmfbLmfNHDRTu59Yz2BeAl59Q
	0LzxRyZ0FPO07JFJk2UhC0r9Cv/k48Zk=
X-Gm-Gg: AeBDietB2a8ismLVW3J+waqV3RPgoYRb/XqR+staZzybVkSHc/1xLPlTf60IEp891I4
	/Ta+InOLSSQczB3fFDHHN5XkPnJr3E1a6TYbw4Gqs3tWqUrfj447sVFYZ+s5ej821OwWCb6396Z
	UOBLvqOepD4oFf3vxANUVMC4zqIwZ9Iy1oxFw6VWhz76xhomSbu7wcHVFQ842kk5II1sppPom0z
	TCPU27Ooxux25kvs/e+hEqpHmfu/i9+yLF3CVcj1eduCHQ4h3wpYliympzkXyN4AjAwr4Baye45
	N76XXfdIIm8nzRzqhiYRtDFNZoXbcp9pAhl4sweKFl9DBJKYoqE=
X-Received: by 2002:a05:690c:6609:b0:7a1:3088:e528 with SMTP id
 00721157ae682-7b9ececcc09mr16566067b3.18.1776411946241; Fri, 17 Apr 2026
 00:45:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org> <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
 <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
In-Reply-To: <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 17 Apr 2026 15:45:09 +0800
X-Gm-Features: AQROBzA6fw6byWmTYAhFjiy18XAGgQOgnpIrWFhnESgR-3D4LyE6HDe-gwIi6oo
Message-ID: <CALOAHbAwmPnEFgzzrjQWdp=tfR4rZPoyn-at4EYFO0TX6rCLHA@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2378-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 65EAE418259
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 12:33=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Thu, Apr 16, 2026 at 12:46=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> [...]
> > > +
> > > +static struct klp_patch patch =3D {
> > > +       .mod =3D THIS_MODULE,
> > > +       .objs =3D objs,
> >
> >   Nit: I suggest enabling the replace flag for this patch to align
> > with the recommended implementation.
> >
> >     .replace =3D true,
>
> This is an interesting topic. To fully take advantage of the replace
> feature, we need more work on the BPF side.

Right.
Replacement seems to break struct_ops registration and BPF
re-attachment. On the livepatch side, we should add support for the
'livepatch tag' to prevent these types of livepatches from being
replaced ;)

>
> For this sample, I guess we are OK either way.

OK

--=20
Regards
Yafang

