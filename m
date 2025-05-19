Return-Path: <live-patching+bounces-1441-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C429ABC507
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 18:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7EBB7AD7DC
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 16:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C168286D76;
	Mon, 19 May 2025 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNOIRe6l"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12151FDA9E;
	Mon, 19 May 2025 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747673861; cv=none; b=hF0/U3HuMucdnpqsdPsHccvZ8LEIx3qZuQ9188eBlY+V8gI/v8DzVQrPsReJ+WUZ8MEB2yfxLgPRFCpTWMS/mvJ70co6x0cPYuOozrF8MOUmfE+Yak1TAR2BZFsQedqUrmbQnfatVyjf1U10lzNE2rT1Dbm+4b4pNclMbr7MDWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747673861; c=relaxed/simple;
	bh=IRKTNHfasU8+lo/XRIkxokS5HAPWIZgFKA1nHJYL56g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P1vT1yfVy9aIDa5c68jfLrS4B2EMPssK/iHEeZmBaP/5lEvjqrdo8IyvIY6m5+GMAInyI+7QpfGRWowlM5cEGvFgjLDvCZHrrq6tqiCj4LgMp2kQkaMmMubYLUnLd8jjc8exi8BByZFZ4nPaYigH0Em6FHpVJFy4Sz/SHO10+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNOIRe6l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3C8C4CEF1;
	Mon, 19 May 2025 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747673859;
	bh=IRKTNHfasU8+lo/XRIkxokS5HAPWIZgFKA1nHJYL56g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oNOIRe6lZs7jzW6yF8dc/2pf+jxK9H6XJ6yGxQb7WUVmS4MBMBIoRoxO3s4tLxvPD
	 qCHZUZ2TcZULip9ppmX4JKa47qerHL330KIOW2kCitvaolZyVZoQDvVma5aAmqOYmG
	 HdHfhz5mWE6y5F3MGctO7ehNrUmrlRZ5JHwYNx1BPqruAzXBMDwCmQ7g5ZkLIlnszu
	 osLehQG5He4sWXdVGHNWMRBBIcZLk7wVuV1ntYcwJXL7/9vjnlQrY2h01/azYxa7IE
	 sXSHSicrNYXdHkzX+V3MgS6NNs5q2FsAjqCDhDYrOUiF2Y3O1qIYvAGYD7opo+I5PN
	 6FPwDtjuo+3/g==
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-476977848c4so50816711cf.1;
        Mon, 19 May 2025 09:57:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUAnCOvjP7dQjU+lz3ioOOIExI1+lkbPJfrkJswgdyclI9E8MRP+sj545zh3Bi3UfRO5TtGbTQE0X2f7SYyA5vXXg==@vger.kernel.org, AJvYcCVpBQJGAlbvuW05hAmzxOFFU8oDaUGbahPC13AJKwS47wn1pbGYJejXpZgnSkdX4b9AjViwZiFkZWtejbbFNQ==@vger.kernel.org, AJvYcCWvUg54kk8MNxBSN9dHZWYXjF6hElR/sNn5GnRUn+O9VH+FerSPS5q+J0ccfo7rnSZ3vrENxAdUpz7wsC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhJpBqJUj+pfVz007i6rbaiYQG/7uhwaiMn6DQKRzXmEEgRT73
	6L+SB+67ldvYWfLoiyXx6/DMHWMprb6tneb7d0B3PV1/NXT1/RdM/2ByNSz+58IEGNHGNvipU+4
	9HRNk89pIwwtwrPnG6Twcz5HalPkJbkE=
X-Google-Smtp-Source: AGHT+IF4eIILYLE82QhVaFVC1hc40xNHoFgLB4h94upYDsq2OsAWvZWF03w5aHy3ywmb0cwEeuEgMULJtrLNil5Qb+Q=
X-Received: by 2002:a05:622a:2610:b0:494:7c90:da18 with SMTP id
 d75a77b69052e-494ae47daf7mr251639231cf.38.1747673858027; Mon, 19 May 2025
 09:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250320171559.3423224-1-song@kernel.org> <20250320171559.3423224-2-song@kernel.org>
 <aCs08i3u9C9MWy4M@J2N7QTR9R3>
In-Reply-To: <aCs08i3u9C9MWy4M@J2N7QTR9R3>
From: Song Liu <song@kernel.org>
Date: Mon, 19 May 2025 09:57:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4UVkXdShpo2TvisPhr6S1jFPkS_BKXAjN9cT3=k5SAFg@mail.gmail.com>
X-Gm-Features: AX0GCFuUA2XAT-QJ7wQt7Tq4_RFoArpXkaTjxNGeXw5LP4FBthHONfACFli45WE
Message-ID: <CAPhsuW4UVkXdShpo2TvisPhr6S1jFPkS_BKXAjN9cT3=k5SAFg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Thanks for your review and the fixups!

On Mon, May 19, 2025 at 6:41=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
>
[...]
>
> ... and then in future we can add anything spdecific to reliable
> stacktrace there.
>
> That aside, this generally looks good to me. The only thing that I note
> is that we're lacking a check on the return value of
> kretprobe_find_ret_addr(), and we should return -EINVAL when that is
> NULL, but that should never happen in normal operation.
>
> I've pushed a arm64/stacktrace-updates branch [1] with fixups for those
> as two separate commits atop this one. If that looks good to you I
> suggest we post that as a series and ask Will and Catalin to take that
> as-is.
>
> I'll look at the actual patching bits now.
>
> Mark.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/ arm64=
/stacktrace-updates

For the fixups:

Reviewed-and-tested-by: Song Liu <song@kernel.org>

Tested with 2/2 of this set and samples/livepatch.

Song

