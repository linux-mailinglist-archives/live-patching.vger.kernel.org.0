Return-Path: <live-patching+bounces-328-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3988FF4A1
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 20:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BDB8B23C71
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 18:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259C01993A1;
	Thu,  6 Jun 2024 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eR+tIULi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C95319939C
	for <live-patching@vger.kernel.org>; Thu,  6 Jun 2024 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717698491; cv=none; b=q+mO2weFHWIRmlVNbnTtrt6Qbao0o0+qg+Mj5P4nYVumZc6z+NVIP/Y6AxdTlYL61b36dZfXm6z1GHl47bgKsgNEfXXBYxnBIExxFkyQfPetICv/QryAgDj7Kz7pd5096mmGSYixs8A912rfsdMyuiop4CJOiz+jO4Os/Xripzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717698491; c=relaxed/simple;
	bh=hXBCWGDl6iQUiGgI3mnJqEYYxAygCL92+j7yppmzxuw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uSmXtxZWUMMitsLjP3DQgNsK9GF3cI3vJx5nipA/FgeCHk3482F8dEasPKqhn8ezns9jD434xXpdiJ+5zpX0DsmlXuBGbzeOovzFlF2ffpYzxVcz22DqbDTvcLLNix/MMDQXx98qJqvkUvXtJ0R9bySKnCcRnMPu0s2AfvoUcSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eR+tIULi; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-35e573c0334so1438900f8f.1
        for <live-patching@vger.kernel.org>; Thu, 06 Jun 2024 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717698487; x=1718303287; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9pp+YQLbn+mewrs9te441F0Mjx0zH5J0mECKySXrOe4=;
        b=eR+tIULi2oHBRMmc8VtesRQm+o3A9ShyBCKqnLXSpoP/8rMnvJgTAwMsd0AsrCUDtD
         5PD2+BHa9zAGOmkQDP5wwkFAYGG4B9Vy5m6qumnLeAy8rhG2IN7uCKxwcuRugrFw+t3o
         3P4pl/9W+K5YpMO8MlR4fy5D3JQhvzBjjuI3CwW5LS3mMXo+//xhyfcUSCpJZ9W7ddqx
         lWiju48rjE0G9e2Mtg9TQZ+4YtLL8tFOXQGSoUyD0x0iXa9KZcsabtM7u4Pe0IVa3ONZ
         BP83RGu9sfmODdAmxARniqd5LJp8LQmxY463EvZajTOiWm0W1ODcd9wWyOJLJTRPzIyF
         Dr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717698487; x=1718303287;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9pp+YQLbn+mewrs9te441F0Mjx0zH5J0mECKySXrOe4=;
        b=HkXH8TbknDfveWFSTELNxowdDO0AfrVzQ9n9tGyL/Nwobav+s7LASAIl9P0IDvuVkJ
         qn4v080MtgYqd+9/j/vCsUMfwKtkpk1FopE7mt3Pe9BlbTVeDMjdt8gkUHBPS+vWulBy
         LULThjKea4N6lcMVrEOmrGSyWCp1tmi/+nVmAU5Y/TglC6FITqgqdC/uuQdFqT8n1RuH
         6ZFrw6029+nTQYw/fikVtM/6eURau7ALjCLwrA1okISgjaMKw1uB+4xMNZC0IBsDuQs7
         gZsZM3fdvc9Z2W6lXpbn5CQxEFb1D2YW+Vcy9UkT9IS8y31evc2ZqmT7HSBOqhDF4XAW
         BEjg==
X-Forwarded-Encrypted: i=1; AJvYcCVajx54Hh6lbKZZboPpZyQnr0kqLsg2RUOO0rqDlUqazt38GC9k2aVJ8k/A/9sqt92kGMKQ8TOVKxojwtek9NhHKLiNhHiNtX8TnsKhfg==
X-Gm-Message-State: AOJu0YyfZMMCFvNho+qaDOtkstvp8azML3XLmmQ8ZbXv5UFDaXs7QG+z
	8+JlpJljFZHj2itULHsNJ4+RchJ9WcNCM4Fg+iwvVVSexk1SbFwt3JKSv823kuuh5OBdhuzszRO
	i
X-Google-Smtp-Source: AGHT+IGPYw+ErGrFYTd1ZWI76ONo/bVUSy0lOdhvbOoId04ZnFhN69Ko8hQMDbBfXHaA0IyeYu8obA==
X-Received: by 2002:adf:f10f:0:b0:357:8a96:4eef with SMTP id ffacd0b85a97d-35ef0ddab9amr3182950f8f.31.1717698487366;
        Thu, 06 Jun 2024 11:28:07 -0700 (PDT)
Received: from ?IPv6:2804:5078:851:4000:58f2:fc97:371f:2? ([2804:5078:851:4000:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2806bd7ddsm3880114a91.40.2024.06.06.11.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 11:28:06 -0700 (PDT)
Message-ID: <0c3d947f230e2c7b737cffc2b6a326962edd890c.camel@suse.com>
Subject: Re: [PATCH] selftests/livepatch: define max test-syscall processes
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Ryan Sullivan <rysulliv@redhat.com>, live-patching@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
  joe.lawrence@redhat.com, shuah@kernel.org
Date: Thu, 06 Jun 2024 15:27:53 -0300
In-Reply-To: <20240606135348.4708-1-rysulliv@redhat.com>
References: <alpine.LSU.2.21.2405311304250.8344@pobox.suse.cz>
	 <20240606135348.4708-1-rysulliv@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-06-06 at 09:53 -0400, Ryan Sullivan wrote:
> Define a maximum allowable number of pids that can be livepatched in
> test-syscall.sh as with extremely large machines the output from a
> large number of processes overflows the dev/kmsg "expect" buffer in
> the "check_result" function and causes a false error.
>=20
> Reported-by: CKI Project <cki-project@redhat.com>
> Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>

Hi Ryan,

is this the same patch that you sent on ? I couldn't spot any changes,
and you also didn't tagged a different version for this patch.

> ---
> =C2=A0tools/testing/selftests/livepatch/test-syscall.sh | 5 ++++-
> =C2=A01 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/livepatch/test-syscall.sh
> b/tools/testing/selftests/livepatch/test-syscall.sh
> index b76a881d4013..289eb7d4c4b3 100755
> --- a/tools/testing/selftests/livepatch/test-syscall.sh
> +++ b/tools/testing/selftests/livepatch/test-syscall.sh
> @@ -15,7 +15,10 @@ setup_config
> =C2=A0
> =C2=A0start_test "patch getpid syscall while being heavily hammered"
> =C2=A0
> -for i in $(seq 1 $(getconf _NPROCESSORS_ONLN)); do
> +NPROC=3D$(getconf _NPROCESSORS_ONLN)
> +MAXPROC=3D128
> +
> +for i in $(seq 1 $(($NPROC < $MAXPROC ? $NPROC : $MAXPROC))); do
> =C2=A0	./test_klp-call_getpid &
> =C2=A0	pids[$i]=3D"$!"
> =C2=A0done


