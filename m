Return-Path: <live-patching+bounces-657-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7A09787AE
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 20:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 875131C213ED
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 18:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F193812C470;
	Fri, 13 Sep 2024 18:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="BJvDICO+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C981EEE0
	for <live-patching@vger.kernel.org>; Fri, 13 Sep 2024 18:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726251426; cv=none; b=rFP8tGtjgLZFrR4Fe4/kq7fqA1+kQSmfuP979wT6Vh3Ce2fS5eE98vJ35iNcSrLD9BqmRaWjpfCMZFDWsW+GX0EebJi7NclDKNIdxtSfDrut7tXYd/5hjgu8nlYBDNWeBFs8z5WRtKE5IgTn0eEvu2jUD147c2zLbwaBVHOvDWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726251426; c=relaxed/simple;
	bh=Zirz1Pivh/a9Lqz7ebesycHuMBNE8FcBNu8UmFdsawU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GYj88olxOKPkSsKpdOPz1b4tY7lncsR89XWyxYq3/a56awyrXSPe3ClNxt9PMbDK3x7VyWgvYTTSR6kN1XjffA988jVlffW7Wf07nDxC8qSXhCkTfOu34RGcl9vJzrrVO6sevs+nRFhLPzUTEiqiNiK39/qZhBQ49jDDr558ZxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=BJvDICO+; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2daaa9706a9so2065419a91.1
        for <live-patching@vger.kernel.org>; Fri, 13 Sep 2024 11:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1726251425; x=1726856225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zirz1Pivh/a9Lqz7ebesycHuMBNE8FcBNu8UmFdsawU=;
        b=BJvDICO+cmcqbF4DdqC9KpiHpyV7RIUE/9xfCe/1le7nJagqF6k6asLX5DpJjtHUdW
         0xk8ID4w+qN23g9FZpxqcwaHctgusKymCzQLy9q/o/roa8pYQpUVmyfrvG7yW6RUcHC5
         K+InIrKwbAjvJWGrpwKVrXY/j3e5ILIHdAA6dpHd81YDrpbajFZr9/XugfIuU1DdvdB1
         On4ELaVGjav6pyQ+hAWKS0yDQY+jtJkvRVKBFndkkg7qxM7WyCJAPZrlN0BQmkkaQYPC
         sM5vcDSlCD3xj6NVT/X+zqcwXNJhotnh5OAWdgW46EchEVLicutrBOyFa6IjD4+VpCs5
         V6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726251425; x=1726856225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zirz1Pivh/a9Lqz7ebesycHuMBNE8FcBNu8UmFdsawU=;
        b=vPBakW7oJggQ8FkQLO3Ga2Us6Sq292+tXKlauDApN4yI6+NFkElPowJVZ5LzRt68r9
         S6Idw2M/XPiy7DehuoA8rkiZ8fO8O5Mr0ifyhaOtYY9XpJ7s5Xst63JmuUm4EgWz0WGe
         tWuphwrcXeahTG7BnoNgCZGcpzuGHhiCDyjaQI0euTJ5SNwJqxoFc2fbbrMtKQhRYO/i
         +2Y5YFuzhOnoelaRtZSqrdLIKXvclYadwOAGJ5Tvf/WwFtbs5OjxF1qWkvEHKxruCCRV
         2hlC0W8Ax8ZtGE8TTJVR9DymGTf/8P6ugtcgdnXTnuQvi77TcSTKBMPtyR42sc4yHEX8
         q2OA==
X-Forwarded-Encrypted: i=1; AJvYcCWnvKg+WrGfmzDaI2053u9EBRZkzyG3IIz2zyRAQGxYenX+eAfzfS6WigDm3kYy3dz+NoXhWmJi2MlOiBkZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxQJv67klMmgnVZxvTXlZw8amPqsfRuhpFMcAu0sKpvcnGba9kl
	gGcvYJxTdrq835bDXhyLextL9KLUDuo70cKy3aGr35B3L49UFL26fQ2We8uFP0LVRc+VvfY6K9P
	HfRd1WDfBxm5wiRYY6s4W522fx4PYRbIw4ySscw==
X-Google-Smtp-Source: AGHT+IHZUwrVez/2PYUqPvng/skwEa4nwyDeCSrWYu4aCAeh0qkWxmBZN32geO/3Zu2ECvk/Sr/60BLsjf2Vkt083wc=
X-Received: by 2002:a17:90a:4906:b0:2d8:9c97:3c33 with SMTP id
 98e67ed59e1d1-2dba0061173mr8075882a91.28.1726251424747; Fri, 13 Sep 2024
 11:17:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <ZuGav4txYowDpxqj@pathway.suse.cz>
 <20240911162005.2zbgqrxs3vbjatsv@treble> <CAPhsuW5GuADzdnsBi9Nx0Rrv2FRnO3c5SwdYA01ZShOCf6RY+A@mail.gmail.com>
In-Reply-To: <CAPhsuW5GuADzdnsBi9Nx0Rrv2FRnO3c5SwdYA01ZShOCf6RY+A@mail.gmail.com>
From: "A K M Fazla Mehrab ." <a.mehrab@bytedance.com>
Date: Fri, 13 Sep 2024 11:16:53 -0700
Message-ID: <CAJKDkqj5VL7fbr2Cn8uW11_Megq8hjCjSTF1UkLLhLj6-KDV2Q@mail.gmail.com>
Subject: Re: [External] Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Thu, Sep 12, 2024 at 9:06=E2=80=AFAM Song Liu <song@kernel.org> wrote:
[...]
> > Red Hat (and Meta?) will start using it as soon as x86 support is ready=
,
> > because IBT/LTO support is needed, which kpatch-build can't handle.
>
> While we (Meta) do have a workaround in kpatch to build livepatch for
> kernels built with LTO, we will try to switch to this approach once
> the x86 support is ready.
>
> There are also other companies that would like to use LTO+livepatch
> combination.

We (ByteDance) would also like to try this approach as we are
interested in live patching LTO kernels.

Thanks,
Mehrab

