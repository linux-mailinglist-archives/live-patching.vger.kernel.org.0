Return-Path: <live-patching+bounces-356-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FF8911874
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 04:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7CC4B2164A
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 02:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588A884037;
	Fri, 21 Jun 2024 02:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrvhHW/h"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E3883CDA
	for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 02:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718936825; cv=none; b=ubfT913qWce+a3IXnTUC72o4d12uRYhzSAsrMqH91KEQXfpWikRKb2U9ysVo5Cim8vWzATYfhk79BETmPXbzErW4FQfOznTsseVh+zpnQMXNwRKLNkMT6wFan0859PhzJDrjBGhEFQhknDaQYFQ4I0Rm8OfnwNBbKXikcOoA3Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718936825; c=relaxed/simple;
	bh=ij19oZE6XcqUcvN4sqEDc2GYoFxKeWYgBFgxTzmyWg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FcnaMGypcAf8YOnX1jNWFzKkuR5BwqmYkiFwh/uYBH++Q8iwMGg7kgvM4x1+r4bHa3Jg5FA0gMCbq+U+eFm2bUJOhhw+L1K3QNw5KDYXe06t4AcSjz+3ihWiOsCeVareETly/J1lhyINKKIgWjroOCPAqS/1gGkJIDEMkCIyKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrvhHW/h; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6325b04c275so15364687b3.3
        for <live-patching@vger.kernel.org>; Thu, 20 Jun 2024 19:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718936823; x=1719541623; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6ntMHNAjJ1iX2gfKda60hTlFXl004x68CBqXMNQ7JM=;
        b=jrvhHW/h7ep1MPZ5wF9CKBzzV5rhZ0enX0zHkr+RV0SPFb44Oo2psGP2Y0as8yTEsV
         W7rQEMF1x658xG0avYIFLzlJEN0RixNsZG5DmIoazhzY60Ifr3Z8w8uG6uRyLhS4ejvB
         DP9ZlUZaFNLuVNk/PDnJM1pAsjMIG4qnMMn5x9v/41yLyoDgz1M5RIOxrwYBKKCkMMvi
         Ys7HdfX51beuGYqEHX81r4TZ7bJuSkwMDPvwG3B6Mhxj6t5ez/AGsJZehhQ5qfzagu7F
         q6BPEP05Cbh6DZEqg6ms962q+na+KJMsI/t8/7joZLHrXapVPLBNMkxQoVohmHRBwAfZ
         uw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718936823; x=1719541623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6ntMHNAjJ1iX2gfKda60hTlFXl004x68CBqXMNQ7JM=;
        b=l8R06GgZucnt+WPhieXTY+5YqgMiTDaYDO75YJJHK4892rCsUB7FsnouQTxzGHZ/a8
         Gtb3YbGYzh0j9o0joAvw5r+UqJJWZL48TIbrBUSXpkyg880oNeQJmNGAlqaT7b4GFtXm
         mN949EHnKxCSDK8EnTSbudrixLLCc71CmaxJandkDatdoZb5EcWyNzkJm/hbHtOGTOsK
         WXjBxz6qNrEG2h2myi6mKUUJkYg6Dbr8Q03QG/B+YskBId0Q/+ZLcXGV0acpt9Byiu0r
         K2AQzcRYosbuZhgDCTkSu1gGgSVcvHs/BmlvMR1SHnf+N/zDoTOGzkpAtfgqHXVN23sK
         27Cw==
X-Gm-Message-State: AOJu0Yz6nqGiHf6fjG/aW+f9sYnb25JvTvsxC7ukrH/7T8/B2Dy6dsmN
	W6ZcTD6Fk7+j7vk8nJefziya1qW4BSWVVaxv2PCCnjV0xXP78oAQ+cQ2E+NrOVXP7dBemXrqDRJ
	GLGf+6nYk7/+0Z8yXuG6q/8ZslV0=
X-Google-Smtp-Source: AGHT+IGca2Qu833RI3wnuJIciw6K6eVMqxCG04QQeKZTBdmFAeVAkzD4G1ZOcT0SGvyd71dqUBfGPK0p4Ap3S64eXbQ=
X-Received: by 2002:a81:84ce:0:b0:627:24d0:5037 with SMTP id
 00721157ae682-63a8ab6fedfmr73818637b3.0.1718936820414; Thu, 20 Jun 2024
 19:27:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com>
In-Reply-To: <20240610013237.92646-1-laoar.shao@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 21 Jun 2024 10:26:22 +0800
Message-ID: <CALOAHbDLYEqhBbHyAzQo+xPLmXy33WsNEkyvcn7WiCu61Cu_hQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 9:33=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> Add "replace" sysfs attribute to show whether a livepatch supports
> atomic replace or not.
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

Hi Maintainers,

Just following up.

Would you be able to accept this series, or do you have any additional
comments or feedback?

Thank you.

--
Regards
Yafang

