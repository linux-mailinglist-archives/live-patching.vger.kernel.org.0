Return-Path: <live-patching+bounces-365-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CBB915C18
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 04:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A306C1C2143F
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 02:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE615374F1;
	Tue, 25 Jun 2024 02:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFBbeAp/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A7282F0
	for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 02:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719281714; cv=none; b=C1F209+kef6duZz/4OcyAuLZtLs0RqRuTyLRSJt/BYU5osk8QG553PMXXmIe7LdLZcq5IkDTjk3iuSXFY7p/Rhh1VJPbYJaR24+YHD97C0WUlh3ALpooWMwuQI+BWPpSSPD3/oFQpeFu6Dqh5zMDLIszrZtue01sTLR/PkcRztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719281714; c=relaxed/simple;
	bh=ANbKRiATE9je1ZqF2m4zj8aEFTpsyMgl79AoK+P0+7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cm/vy+HGgf8sc2mtPXb3MwYzj79qSWsNwIOl/g1CLD4m6bgNpZ6yCktJOiGlRVcWmqDkTJsc3eAhcCSAtBAXaQYOyN5lULBLoDtUt9GtMnEj74KrZRdSaQ7Cie4XReWeTLEiuke2H37sXH3/o6hCtHSjkr9eEPmewPGSz/Fzuug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFBbeAp/; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-79c03abfb18so9734585a.0
        for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 19:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719281712; x=1719886512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFV+ipZ68cWrWu4ovVmw7eSqNQG31TQ3gktNGQQxLOI=;
        b=lFBbeAp/j6zQKCOKNPrb6KcJWJY5SB6QjVxjDaFp++vbBGN9w2GL8YiNe9m+X2q6Am
         oVVsdqLPGFG4GzVeTYR+JR4mOtOCwxmxD6qGlNKW/X1we5BXEdHg5IQxqp1N0Y7RbIYx
         lbhPAGKWcTIGK4f5sYDrdEou1zk8EoZNKHEMbdAdqAc9RX0TZNVhwqqV7ugX0ZSGG6Eu
         Scxw5Gi82cl5wUpeFxs9nkuBJAx5UiNCwvBL0mu7Zt8FXoeTMICek4f2v1BDiwhjzfGo
         YiQS3ZN4ty6gjMKCF/NqlkZoAfz8KRie0Pf41kvt6N0daxHa/IubYYFOqpJNbez87E7X
         Pdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719281712; x=1719886512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NFV+ipZ68cWrWu4ovVmw7eSqNQG31TQ3gktNGQQxLOI=;
        b=v19BD8EuMrXaEsEwj1KpzyufVG3hMH+7P96kJOcixgrShRbdYILA6bl2BLP9WRUrNu
         Cetomccix+5pOQIeB+XP/+kn9njorWaV5nGbRZ/3XvZBr7Q1jB3ips4VsYBNejvMZTM/
         89Kn+WGBIjzfpgJ4OSe0NBZMLrgtkwuobExYUTPd8EqFtJyf24bhunv4Zz+v5JFmeqhg
         Lx/ov5k8L8WFm7hpjBo49e1uPGf9XUMSV0Lx9EnTyTEEHwnJacMxOVLCOAp2K2gIzwnU
         NZ0R3MOYgSfSpiW0kFB8uItbAZbUdfoVMcmGI/ZaCIUEh5+/4f5HnV1fFDpJ3rEyuic/
         iNzA==
X-Forwarded-Encrypted: i=1; AJvYcCVhBVuktqrhgdGmDHUikvTAXUECmRiBY60K1CqcXCIomELXopAxFl3tpOb/yWrAFqN03A8DZjsVMxAjWbytnCNCOuctm31BOOXw0YYIBw==
X-Gm-Message-State: AOJu0YytKzIYk6JTHjNIhmO5y5LyJorPVr0RahlK93cJA2TmLIVtNSZy
	LvZGXSc4sPPeGaSbzoj6lt8zlI4gUzd7Da/PnMDdwcEN65yE2YjApjCKhBkXsWIx7jbHcuz/Ptd
	xT9Nh6ul8BBk5B6S4sdyj2lpgrjY=
X-Google-Smtp-Source: AGHT+IF09cRSCX7F6ijCeTC1gSGXjFjYX9BGVy2d2SHB7VS73IhxSRsCqKCjXE86bCKL4RIkFLCFxAs7gzmRkywfGLw=
X-Received: by 2002:a05:6214:d06:b0:6b5:49c9:ed53 with SMTP id
 6a1803df08f44-6b549c9ef8fmr68494766d6.37.1719281712060; Mon, 24 Jun 2024
 19:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <20240610013237.92646-2-laoar.shao@gmail.com>
 <Znl4u_dWfqK53G3k@pathway.suse.cz>
In-Reply-To: <Znl4u_dWfqK53G3k@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 25 Jun 2024 10:14:35 +0800
Message-ID: <CALOAHbDYosGNuFWaJHpc5nX3Vgnjhx4z2aNkFY4dhvKV53cF2g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] livepatch: Add "replace" sysfs attribute
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 9:46=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Mon 2024-06-10 09:32:35, Yafang Shao wrote:
> > When building a livepatch, a user can set it to be either an atomic rep=
lace
> > livepatch or a non atomic replace livepatch. However, it is not easy to
> > identify whether a livepatch is atomic replace or not until it actually
> > replaces some old livepatches. It will be beneficial to show it directl=
y.
> >
> > A new sysfs interface called 'replace' is introduced in this patch. The
> > result after this change is as follows:
> >
> >   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
> >   0
> >
> >   $ cat /sys/kernel/livepatch/livepatch-replace/replace
> >   1
>
> The description is not sufficient. It does not explain why this
> information is useful.
>
> The proposed change allows to see the replace flag only when
> the livepatch is already installed. But the value does
> not have any effect at this point. It has effect only when
> the livepatch is being installed.
>
> I would propose something like:
>
> <proposal>
> There are situations when it might make sense to combine livepatches
> with and without the atomic replace on the same system. For example,
> the livepatch without the atomic replace might provide a hotfix
> or extra tuning.
>
> Managing livepatches on such systems might be challenging. And the
> information which of the installed livepatches do not use the atomic
> replace would be useful.
>
> Add new sysfs interface 'replace'. It works as follows:
>
>    $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
>    0
>
>    $ cat /sys/kernel/livepatch/livepatch-replace/replace
>    1
> </proposal>
>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>
> Otherwise the change looks good.
>
> With a better description:
>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
>

Thanks for your review and suggestion. I will do it.

--=20
Regards
Yafang

