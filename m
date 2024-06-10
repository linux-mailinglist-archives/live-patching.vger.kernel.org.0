Return-Path: <live-patching+bounces-346-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DC49027A1
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 19:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7AE11C21766
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 17:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC99145354;
	Mon, 10 Jun 2024 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdvQSGJA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D90145328
	for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718039953; cv=none; b=M4qwE9BzWUyZfB0ABJRAsE+A9moxexxp0y5V2RJdnGEEGqYJZBhvKt5E76VH2IPfDMMmwI75KCvuWBdhDHONM3R0QLWpZyip6bJs5XGxy67pJI+rhtR12LZ3j5tZA5pd9FzLyr1rTmbidX7FMYLJW1vsvToUngRy9inpxs/p5m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718039953; c=relaxed/simple;
	bh=Y+6YFnSyFSZlt4D3OUXvRaI2qgFuKtQ2afapPBYLCUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NY9CcZ5sZo/VayUbEYDcVZIM1/ffiDzErvWDrmj+D01JybRjPktFBQoaJkKa0ndh030EfsUVV93pb4NW0Pj4wzxt2sfyaspy9LKfKFFS+JJdrbZWQpZ7p9o5wRlMAnj0wy+a0qOEy8eai+zqP7BfUnJXgqkAGVm+KbUmz07TWCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdvQSGJA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B7C2BBFC
	for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718039953;
	bh=Y+6YFnSyFSZlt4D3OUXvRaI2qgFuKtQ2afapPBYLCUw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sdvQSGJA5BqK+QGg6VyYjYF4G/ZL9a3ngF34/Vb4nk5gkG+vZp7y+VNOs/+Q7Kq40
	 dK1uAsD5CAJl9naOYi1JqNfNCQ0B6pkLxJ7OU/TSHazqKlhxrKr2+fEJSqPHtXQAmn
	 bSLDgMXQhkdSmBWBCug9MCWfJd7mjeWoU2d0OXVI3D1cY0Z1xO2GoyK8iTHS70ZSaw
	 1XjMAA4SsRxe26JqLvpO+QkXP0YQdW5QVMR/ysqUQmGetNSaqIj6wOs5KMD4E3twSf
	 I7BX9CuvfxeYh+1CcUpbDSvN25zNl1YlUGWCa9H2eyOlrYve0aBR3oteZ6j8KmJSAF
	 GF+shunI9kurQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2e78fe9fc2bso66964561fa.3
        for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 10:19:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVWDfzSyUHssiAo/LKipY/DgCc+qU4IbeVJyCX3Y5R6RlREToMWqQyz5hfZNa8V+7ep5rS+/DiiFjV0Cw28yLbRhcLoYbt7YIgnbl1XCg==
X-Gm-Message-State: AOJu0YzcMkjXCumBhsPT/gtTg2TXTsV94sgioD8o5FmkXIJZeG7ur4G5
	UeJ2Ejfssvh/ChPiLxo8otLTWdomz60I8ngj8wI7bn89VslhW26JL9jTEdaZ7Djm4gE6Dom6Scd
	AHWoElkmrQ13+meucjXxd8tBRhcI=
X-Google-Smtp-Source: AGHT+IGS4XbPdsw0pDAPisPcYPQrtAoLX/ueWygPJMaI015CixpnSX+L4jKY2EwOvTmYnEFRb0P5E7e01Nr2T1kWEww=
X-Received: by 2002:a2e:81c2:0:b0:2eb:d825:e720 with SMTP id
 38308e7fff4ca-2ebd825ea75mr45062371fa.22.1718039950541; Mon, 10 Jun 2024
 10:19:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com>
In-Reply-To: <20240610013237.92646-1-laoar.shao@gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 10:18:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
Message-ID: <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yafang,

On Sun, Jun 9, 2024 at 6:33=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> Add "replace" sysfs attribute to show whether a livepatch supports
> atomic replace or not.

I am curious about the use case here. AFAICT, the "replace" flag
matters _before_ the livepatch is loaded. Once the livepatch is
loaded, the "replace" part is already finished. Therefore, I think
we really need a way to check the replace flag before loading the
.ko file? Maybe in modinfo?

Thanks,
Song

>
> A minor cleanup is also included in this patchset.
>
> v1->v2:
> - Refine the subject (Miroslav)
> - Use sysfs_emit() instead and replace other snprintf() as well (Miroslav=
)
> - Add selftests (Marcos)
>
> v1: https://lore.kernel.org/live-patching/20240607070157.33828-1-laoar.sh=
ao@gmail.com/
>
> Yafang Shao (3):
>   livepatch: Add "replace" sysfs attribute
>   selftests/livepatch: Add selftests for "replace" sysfs attribute
>   livepatch: Replace snprintf() with sysfs_emit()
>
>  .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
>  kernel/livepatch/core.c                       | 17 +++++--
>  .../testing/selftests/livepatch/test-sysfs.sh | 48 +++++++++++++++++++
>  3 files changed, 70 insertions(+), 3 deletions(-)
>
> --
> 2.39.1
>
>

