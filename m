Return-Path: <live-patching+bounces-1524-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64086AE23B7
	for <lists+live-patching@lfdr.de>; Fri, 20 Jun 2025 22:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDD6D3A74AD
	for <lists+live-patching@lfdr.de>; Fri, 20 Jun 2025 20:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B833221715;
	Fri, 20 Jun 2025 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Km9WlWZ8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E0D30E853;
	Fri, 20 Jun 2025 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750452343; cv=none; b=UCwVMFdzez5igg2QefY7vDr93Ojq1gsHVAh1oYttm0wPGou6OuoD28St4Rq0IqjZq3rv3oa7dOMC2RVqFUVeNpmore1cUe6OhhQ4EjGBHO07DK1Xvp/TXiNXSsrVAjrEt5hkouUeDU/lx2e/5L350MfJMu3Waxhk/lPGoQ56fNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750452343; c=relaxed/simple;
	bh=jT4pwqZu770AfPs28HMcGmVZzo3HY+8w0IIFr8RfnEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fl6ZDTZlbdDA65/YqFNvk0FaZ1SOQd2f+PsaVG4GhqfcP/rrSYbXUsouHj1VNFlwI9pn+RR0OOUpJLGlS23I296xhYc2EEWqQ7MBmP4xiZkepvwZzyNrA3fNzCCspo1EdS5ZwhIXPb97ECiXC4I6iIZ6iYROlQjZc5ceHOZQz+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Km9WlWZ8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE60C4CEF1;
	Fri, 20 Jun 2025 20:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750452342;
	bh=jT4pwqZu770AfPs28HMcGmVZzo3HY+8w0IIFr8RfnEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Km9WlWZ8piXCl6DiJrKe7nSuIAVy89OBxZ/F2yC6z2uFmzzZ0HJ50o24DIxhecwRg
	 LEbWwl5ANkRf5ZnwY7jbgn4QmCmhxu2vf3UNuye+ZfgJKq9GNCHfNisBbkvjrEdNe4
	 +VZmjs0UCagKjevJsfNO7Qg0yi0yvBaKUOv8aaLjeHp7usDux70Avhkrca3Dhw2ziM
	 u+FrFalwlzkurJEJ8TW7RkbMjWusXZ/ANfQ2Z24rDFQkNap8ugwZRx9DINsx7gQQhT
	 Y9+IiaDf3A3dkbA5KoTMI2Ut0Pn8aB1hQmyUueSptzNdimRfFp2o7CcpyDs3wAMTyf
	 s7BMKQfxWpHWg==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4a745fc9bafso23438961cf.1;
        Fri, 20 Jun 2025 13:45:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVjY46pTVXxd2rg0x1v5gv/ClKYWjEy8imUPsWSH24dyWEnCzU691Wh9OmhhMtkL2XJgaeUjrhrGZ4xVUINyhp3@vger.kernel.org, AJvYcCVo0Sot/7pJ3C8THOW2KAXiMSABXhmcLCwBMI1BWmetyzhY76G6lc2UNEwMYLFKnVAv4C5vJ4ZbOHuezJwcPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxL+GxUWuhkyyGGZmU06F0jgFg4QqdDXXpMP97YBelZU3nzXVSd
	vGdi55BVnPhOII/DPq2N7VS+e68y6H6oarR5rA4y1kYE3aNmuTuh3Y+HsVNGD0TSNexQsy1F6wp
	+O5lJuYXvpcSvxByqJwS3eaOqqIuk9Rg=
X-Google-Smtp-Source: AGHT+IEqMF68Qb4iQprw6czg61CaUToifU0J6UPsPV9YLZ7gihEJwGZpOcdvBvogvqyX3ZOWruWS8i5+uiniaUPHRRo=
X-Received: by 2002:a05:622a:488a:b0:494:731c:8746 with SMTP id
 d75a77b69052e-4a77c382e85mr53421641cf.23.1750452341633; Fri, 20 Jun 2025
 13:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250521111000.2237470-1-mark.rutland@arm.com> <175042293850.3925078.16138215907121902894.b4-ty@arm.com>
In-Reply-To: <175042293850.3925078.16138215907121902894.b4-ty@arm.com>
From: Song Liu <song@kernel.org>
Date: Fri, 20 Jun 2025 13:45:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4s+vGdMqJiGSvacUtq_-JQeRyk2jqBRPiB=7WBXvpj3A@mail.gmail.com>
X-Gm-Features: AX0GCFvCWPmDIR1-1Yb6I0cEDSp7hG_-dHzlYvPC7MjDarzq5GtcXfASg7KKw8s
Message-ID: <CAPhsuW4s+vGdMqJiGSvacUtq_-JQeRyk2jqBRPiB=7WBXvpj3A@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm64: stacktrace: Enable reliable stacktrace
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Will Deacon <will@kernel.org>, andrea.porta@suse.com, jpoimboe@kernel.org, 
	leitao@debian.org, linux-toolchains@vger.kernel.org, 
	live-patching@vger.kernel.org, mbenes@suse.cz, pmladek@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Thanks for landing these patches!

On Fri, Jun 20, 2025 at 5:36=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, 21 May 2025 12:09:58 +0100, Mark Rutland wrote:
> > These patches enable (basic) reliable stacktracing for arm64,
> > terminating at exception boundaries as we do not yet have data necessar=
y
> > to determine whether or not the LR is live.
> >
> > The key changes are in patch 2, which is derived from Song Liu's earlie=
r
> > patch:
> >
> > [...]
>
> Applied to arm64 (for-next/livepatch), thanks!
>
> [1/2] arm64: stacktrace: Check kretprobe_find_ret_addr() return value
>       https://git.kernel.org/arm64/c/beecfd6a88a6
> [2/2] arm64: stacktrace: Implement arch_stack_walk_reliable()
>       https://git.kernel.org/arm64/c/805f13e403cd


At the moment, we still need [1] to enable livepatch for arm64.
Would you mind landing it soon?

Thanks,
Song


[1] https://lore.kernel.org/live-patching/20250617173734.651611-1-song@kern=
el.org/

