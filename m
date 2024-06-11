Return-Path: <live-patching+bounces-350-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4794904267
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 19:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CAAE287394
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 17:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CD24C634;
	Tue, 11 Jun 2024 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="foLIcTEq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2F55579F
	for <live-patching@vger.kernel.org>; Tue, 11 Jun 2024 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718126934; cv=none; b=NiXU4uIZGoTJg3ABo5el3XbDu7Y2iyBXR+2oAoB+Jw+GfCHGN1VSGYHZRiMiomr4ToAyjCvZJxyKfYcmMD/lhRxODkAd5dEv6zoXFN9kAredyByGtkMjJXEk9lzrlCi5MqLDueDogYgkgnuiReFD9aYhqvGmaGyc9esy+U+dneM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718126934; c=relaxed/simple;
	bh=ocvyyfpZDSL8e6wjO09J+d3K7wF1TgHuhL9mHWeEmHU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OPs1wXkh/kw88vpaNCaIuuHdhtRiZzvKIEXW2PSpvcBlINoGfkxmIfw/ffMVSdOib4xOdk0lsbHVsysFaw8MR2w+VD8CzvYpXfXL3Uwe9HkGMiS75JuHTF59KczxwX2mkhhkfBCz1QQojTM+u2Vll6W2plMWaTV0rPNowWnMnAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=foLIcTEq; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57864327f6eso110477a12.1
        for <live-patching@vger.kernel.org>; Tue, 11 Jun 2024 10:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718126928; x=1718731728; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ocvyyfpZDSL8e6wjO09J+d3K7wF1TgHuhL9mHWeEmHU=;
        b=foLIcTEq0GuqUNpN8W9UnUmKZxSUhrowY0Bn7wpipZg8artSAiqPX8Zv1bPdGBBjDN
         ZigfY0bW4eJArfbapsddZpStnPF4ZA7nTl5xYDNub7tBGEe9hhrA0hxX6UM+ZNyyEZVP
         f4y2YJl80bVZeBN6tSPAscMcOqHlsLuikrfJ4pk+OTCBUAanV4KQLqcDUwJyj6fRLd/e
         ZuO3J91U5wxMEd9g2qDId1Vunp9OoCVTpM/2beMLytq280BOT4+KIjQHjs6RHnpB8WRv
         bVmurZLLnQDztOYPTNs1jmGnshvanM/Hwx6orEowcLAdlhkf0juenvNNjr7RVAVzF34H
         vphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718126928; x=1718731728;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ocvyyfpZDSL8e6wjO09J+d3K7wF1TgHuhL9mHWeEmHU=;
        b=dQyhe9XVFBdW0JpJpdxPfbF8LEB804zVzw2YSWENx+Ajxu/6qnlulneiVUKhTT/MBG
         n2GzajMB978xJ4/SKTqSP8bip1xSk9+/x9fbmWvS5ptsbx54E1la7aPlvwx4C+A6cVFK
         l4WX1xM9A5dlJ01lszMTN6h9iWeJ8gDYmi7Hn5fgZUklGxyZ/PAXxDqw68s/WRwSZwMC
         mt8IdFK7gFsZVdDRtXJl6sQyup1R+kjUCWar8jmZIe8Wsxh8JgU/3x4/GxKUtkgHc1fe
         TqX5vRU1CiRDVHjxu280R2GIWXeYnHpfpybunUU4ABrRGgChVQDFdJbb1Ri1Jiz14jgt
         CR1Q==
X-Gm-Message-State: AOJu0YzN1+uLyIedCuNOi9WOPo3jQSfeFEtnr/rCpjHNh5LcIp8emttc
	nuX/FgfSINFXm8zq/sTvUHWbvbUDOPR8uzO4eI3Cez6/lWmu7yqrChwzhv4YGLY=
X-Google-Smtp-Source: AGHT+IG6llivDwGex9xrzVp8F7vIy7qcupw0coHRTAPWBicjr406/kjpXkUtlbM5pTBW00GCljNGKw==
X-Received: by 2002:a05:6402:510b:b0:57c:9471:d108 with SMTP id 4fb4d7f45d1cf-57c9471d20dmr1917385a12.0.1718126928043;
        Tue, 11 Jun 2024 10:28:48 -0700 (PDT)
Received: from ?IPv6:2804:5078:8ad:bc00:58f2:fc97:371f:3? ([2804:5078:8ad:bc00:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57c9d2e40a8sm869243a12.23.2024.06.11.10.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 10:28:47 -0700 (PDT)
Message-ID: <fc0516a5331c4ad157e1d93340bd02deeafe5cc3.camel@suse.com>
Subject: Re: [PATCH v2 2/3] selftests/livepatch: Add selftests for "replace"
 sysfs attribute
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>, jpoimboe@kernel.org,
 jikos@kernel.org,  mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org
Date: Tue, 11 Jun 2024 14:28:43 -0300
In-Reply-To: <20240610013237.92646-3-laoar.shao@gmail.com>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
	 <20240610013237.92646-3-laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-06-10 at 09:32 +0800, Yafang Shao wrote:
> Add selftests for both atomic replace and non atomic replace
> livepatches. The result is as follows,
>=20
> =C2=A0 TEST: sysfs test ... ok
> =C2=A0 TEST: sysfs test object/patched ... ok
> =C2=A0 TEST: sysfs test replace enabled ... ok
> =C2=A0 TEST: sysfs test replace disabled ... ok
>=20
> Suggested-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

LGTM,

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Tested-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> ---
> =C2=A0.../testing/selftests/livepatch/test-sysfs.sh | 48
> +++++++++++++++++++
> =C2=A01 file changed, 48 insertions(+)
>=20
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh
> b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 6c646afa7395..05a14f5a7bfb 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -18,6 +18,7 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
> =C2=A0check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
> =C2=A0check_sysfs_value=C2=A0 "$MOD_LIVEPATCH" "enabled" "1"
> =C2=A0check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
> +check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
> =C2=A0check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
> =C2=A0check_sysfs_value=C2=A0 "$MOD_LIVEPATCH" "transition" "0"
> =C2=A0check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
> @@ -83,4 +84,51 @@ test_klp_callbacks_demo: post_unpatch_callback:
> vmlinux
> =C2=A0livepatch: 'test_klp_callbacks_demo': unpatching complete
> =C2=A0% rmmod test_klp_callbacks_demo"
> =C2=A0
> +start_test "sysfs test replace enabled"
> +
> +MOD_LIVEPATCH=3Dtest_klp_atomic_replace
> +load_lp $MOD_LIVEPATCH replace=3D1
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH" "replace" "1"
> +
> +disable_lp $MOD_LIVEPATCH
> +unload_lp $MOD_LIVEPATCH
> +
> +check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=3D1
> +livepatch: enabling patch '$MOD_LIVEPATCH'
> +livepatch: '$MOD_LIVEPATCH': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH': starting patching transition
> +livepatch: '$MOD_LIVEPATCH': completing patching transition
> +livepatch: '$MOD_LIVEPATCH': patching complete
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> +livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': unpatching complete
> +% rmmod $MOD_LIVEPATCH"
> +
> +start_test "sysfs test replace disabled"
> +
> +load_lp $MOD_LIVEPATCH replace=3D0
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH" "replace" "0"
> +
> +disable_lp $MOD_LIVEPATCH
> +unload_lp $MOD_LIVEPATCH
> +
> +check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=3D0
> +livepatch: enabling patch '$MOD_LIVEPATCH'
> +livepatch: '$MOD_LIVEPATCH': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH': starting patching transition
> +livepatch: '$MOD_LIVEPATCH': completing patching transition
> +livepatch: '$MOD_LIVEPATCH': patching complete
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> +livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': unpatching complete
> +% rmmod $MOD_LIVEPATCH"
> +
> =C2=A0exit 0


