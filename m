Return-Path: <live-patching+bounces-1436-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB47ABA138
	for <lists+live-patching@lfdr.de>; Fri, 16 May 2025 18:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D7C1BA8405
	for <lists+live-patching@lfdr.de>; Fri, 16 May 2025 16:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3085120B1F4;
	Fri, 16 May 2025 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0AZM/WH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015F31DDC2A;
	Fri, 16 May 2025 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414429; cv=none; b=IGj9IbCOUBGVkZxPU2Qg8SJUN+2XROKWz48dJHSEalGlj4PydETPjP2HwSDZAE2Y4U4VEvl9BVIScZ1I0oJpUbT6QFL/Ec5dZo+G5TDT0jewT9fmYWNS0TTGe5/kaCF6bMtj2xW5tMsgfDqYqdGq3wSZMnVo56E1uBDPtgnBuGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414429; c=relaxed/simple;
	bh=gNW+7TtMUM7lGkKFYvhyFcX7e8P3pZT4KoiVlpFjICo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DIkwkGD7g4c2NPFRI+WyCrvQb1W7wYBS0PIJkqmDD97f+3Ek9NFIZj4/hQpqzHX/dYWPixNfXvgFyzO7a3v8BMF+/FV+3HzyvF6cNCvKR8rZOqw+6M6FD+XTi59nmwD2uLtriWeVHqCd7McmSWjXQV36Aho19sp24i+RgF6ht4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0AZM/WH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F529C4CEF3;
	Fri, 16 May 2025 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747414428;
	bh=gNW+7TtMUM7lGkKFYvhyFcX7e8P3pZT4KoiVlpFjICo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K0AZM/WHkIM/qkUypevLdnzzY800HqjD+DQk3EspbBN0pK+1enPyE1noNGvw2ISAv
	 sUGRiH8wlgjpHocu4xNNEmFGK920dEw58CkP7ulNE9K1WSfm9nNRleFZBked/yJ71K
	 k5HSSaToM/eFv03ACXW88lKF/+e5QLQgPB4wJjEh5MdnKNulfZLYGaPkeFhI3ChvTN
	 aQlJx2Ixr/hRimseN8QEYqtyhv04e7uwllTn6AyQgSVbUr0zk2+9uWgxBg8/okmU0R
	 S7vAyrAOLrSNFUxD/lBG+VFxmJobAYDNnNLR4zzJRvEJh3Bx7FIezs8Rj1NiDNvH8m
	 rcZA+KYgOakBw==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7c9376c4bddso268406085a.3;
        Fri, 16 May 2025 09:53:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPCyhAbgi0VcNA0KkBnORp/53zTdbiqIW5fJSHtlZwvn6Ls37fZJ+Sjx/0OSd+l2iJei23CbBcEjcwdBwDLJvJ1w==@vger.kernel.org, AJvYcCVWGWNvOihBWc/2nn8rHTWfE2re2A/VqA6GvxZjvXCrbRzA4M2HuOCc+by4gtcdG21GP+aZX8c+xUL7mVL1Bg==@vger.kernel.org, AJvYcCX7+W8EDcC1jbKyKRAWYaRU7Kys2xVVB329cUWLyr9g1IHyzLuM3uTY60lZeP7xHURzqVOQNTcCkHsVej8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsIftRMHgnFbp+LcyoZhnST9YrO7+z44bOSMQI2PLaQP9lwyIM
	a/TEWaZdvf/78DVBGrD0CaNzlnLuOSBIrslJd0PImm4X2l9tlWkmC7RmOmtRdVyL74f2JQp0IwD
	HYJvqE88lZziA7n5VOQ+E+GtiQ0hcA4Y=
X-Google-Smtp-Source: AGHT+IFYMPM8sSmrqIW21t3SlXlT3FCCm2dJlRMJ71bVHCSHc3IMxpcI15wCR4GKjvDMf42liz3czXx0mNeec5L+ncA=
X-Received: by 2002:a05:620a:4551:b0:7c5:5f38:b78f with SMTP id
 af79cd13be357-7cd4673b9femr581672585a.29.1747414427420; Fri, 16 May 2025
 09:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250320171559.3423224-1-song@kernel.org> <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
In-Reply-To: <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
From: Song Liu <song@kernel.org>
Date: Fri, 16 May 2025 09:53:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>
X-Gm-Features: AX0GCFswWuh29mi00OXRAzuYoajxd21bc-p1p3_IOZYYbVK2ROe03x1xdxnX9VM
Message-ID: <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
To: Petr Mladek <pmladek@suse.com>
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org, 
	live-patching@vger.kernel.org, indu.bhagat@oracle.com, puranjay@kernel.org, 
	wnliu@google.com, irogers@google.com, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2025 at 8:17=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
[...]
> >
> > [1] https://lore.kernel.org/live-patching/20250127213310.2496133-1-wnli=
u@google.com/
> > [2] https://lore.kernel.org/live-patching/20250129232936.1795412-1-song=
@kernel.org/
> > [3] https://sourceware.org/bugzilla/show_bug.cgi?id=3D32589
> > [4] https://lore.kernel.org/linux-arm-kernel/20241017092538.1859841-1-m=
ark.rutland@arm.com/
> >
> > Changes v2 =3D> v3:
> > 1. Remove a redundant check for -ENOENT. (Josh Poimboeuf)
> > 2. Add Tested-by and Acked-by on v1. (I forgot to add them in v2.)
>
> The approach and both patches look reasonable:
>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
>
> Is anyone, Arm people, Mark, against pushing this into linux-next,
> please?

Ping.

ARM folks, please share your thoughts on this work. To fully support
livepatching of kernel modules, we also need [1]. We hope we can
land this in the 6.16 kernel.

Thanks,
Song

[1] https://lore.kernel.org/linux-arm-kernel/20250412010940.1686376-1-dylan=
bhatch@google.com/

