Return-Path: <live-patching+bounces-674-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D3297ED53
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2024 16:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B413281AA1
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2024 14:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8464C19D086;
	Mon, 23 Sep 2024 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HMNqhWGg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359FF1465BB
	for <live-patching@vger.kernel.org>; Mon, 23 Sep 2024 14:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727102753; cv=none; b=FMsRysSX/6d2+MJlEW0BwWJbc4kbnty8q28w7rxs/E/ypceQp5sGtdF34dWSoWJzTkHUSBukbSwMevyi8axQVngXDFTWFielmWyM5UoHwUutqWUUUfSe8MaFT3MTY31+KSfounACKFpf+022WMxjZRdvkaG4Tud2Z991bn4z2m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727102753; c=relaxed/simple;
	bh=5NRsXwKuBF1Zs3W/foWqq7Sp7HvXgxKlkNNgfdW03+E=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h/Fh4GZVUBAPa/3FGcoPfUnahyaWMiaav6mgnOjr583opbd5+yq/Ns8kSRHAcXHaIBz4si9WPv7E04nGTrh0H9LrPK/bcYZzXkjll2AIXeYUt5u6XXC1MQRxJn5Xjmq06QDBdQZlWCIj+ETobpJU8PVKRSDNqtFZxf5NyKDirW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HMNqhWGg; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53567b4c3f4so4688954e87.2
        for <live-patching@vger.kernel.org>; Mon, 23 Sep 2024 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727102748; x=1727707548; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NRsXwKuBF1Zs3W/foWqq7Sp7HvXgxKlkNNgfdW03+E=;
        b=HMNqhWGgKu/eIzT1ur5rRtOEwMmGCkc16GtyBBEg8ljOIreoFpJwgale+suJWbwFko
         dWs6sNOOZd/55ENfTMs5CoFNOLyQAqGCbtVj9zfRFfaw/lp5Tob6RO8rHJeuvnX/qEi0
         WOTWqNs/y9Q73lTg4yxhn2MWbfd9GYMaTCzw0PAsqIxneNTc+HZG+cpU7JxuqwNhQ/iT
         wQuY5z840TdmnugHnT0/RpM6mKZuYzbArvAtN/T+D8Bvakz8PfJmw2TXdAV1CArHQDKg
         sYm69/w6MDEmXV94FdzIUWB2xK0J6kzfLxNCq6s7THr+sugR89Y+b0VBX6w84Efr6n//
         X+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727102748; x=1727707548;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5NRsXwKuBF1Zs3W/foWqq7Sp7HvXgxKlkNNgfdW03+E=;
        b=OnNoyjDOwFuP+PTf9rwCHa+q5ZgMpF2y1/9poOKPqdn4vrkAONaTA6dYZ7VR3paWvA
         GxR5gw+JqhkyfDo34Vft7lVncaoTR7zMqST0Aeh6BSkyPv9uj0McCs7MLhzWa8ON5lsb
         7sqUXXtSuCJlWlFCJjE6Er9EDVTRNyD9BVhWesso435gvbkmKBsfhERZaww7EeU1P6nw
         Smhl/5RlHUTHMnaIdCEm/IpobqFp/v+svMFILehzTNWotaoB2twV+WAVRYvTdBQPY2tH
         /+8sCgBE9oTFAwzlu8Jzyh7MV5/62tLx2gyeL5Ng7l1jOFasNFeoitvTlFHU5J6Cc9K1
         o41Q==
X-Forwarded-Encrypted: i=1; AJvYcCXENRfQ2A6fSTtOxdIO0a3QTPzPeUSEGc2ucAIKtEJO4cnXza17tzm8qCP7krgQ9rUNzzbFJh2GwcAy8p6e@vger.kernel.org
X-Gm-Message-State: AOJu0YwnOcf3YXwHxnv3XsgW8VNPL1AVAbd1ju0ML2NybakEgxApvwER
	wi9cbPQY7O/NEg31+q25B/UDm6GvCzpkE8gax2dewC4xcKgwe+GXiRIGGMeSkO8=
X-Google-Smtp-Source: AGHT+IHX9n+o5rnO2Mry3+H4rn2Nsqm42//8eYN5AaanyzprS8/OBlWuUv+9MAznk/hzN2webuG0DQ==
X-Received: by 2002:a05:6512:33d6:b0:536:a4d8:917b with SMTP id 2adb3069b0e04-536ac2e5c80mr6152023e87.19.1727102748201;
        Mon, 23 Sep 2024 07:45:48 -0700 (PDT)
Received: from ?IPv6:2804:5078:964:d800:58f2:fc97:371f:2? ([2804:5078:964:d800:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8493985853asm3121629241.18.2024.09.23.07.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 07:45:47 -0700 (PDT)
Message-ID: <5e544e68ad83fcdeb3502f1273f18e3d33dc8804.camel@suse.com>
Subject: Re: [PATCH v3 0/3] selftests: livepatch: test livepatching a
 kprobed function
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Michael Vetter <mvetter@suse.com>, linux-kselftest@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2024 11:45:44 -0300
In-Reply-To: <20240920115631.54142-1-mvetter@suse.com>
References: <20240920115631.54142-1-mvetter@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-09-20 at 13:56 +0200, Michael Vetter wrote:
> This patchset adds a test for livepatching a kprobed function.
>=20
> Thanks to Petr and Marcos for the reviews!
>=20
> V3:
> Save and restore kprobe state also when test fails, by integrating it
> into setup_config() and cleanup().
> Rename SYSFS variables in a more logical way.
> Sort test modules in alphabetical order.
> Rename module description.
>=20
> V2:
> Save and restore kprobe state.
>=20
> Michael Vetter (3):
> =C2=A0 selftests: livepatch: rename KLP_SYSFS_DIR to SYSFS_KLP_DIR
> =C2=A0 selftests: livepatch: save and restore kprobe state
> =C2=A0 selftests: livepatch: test livepatching a kprobed function
>=20

Thanks for the new version! LGTM, so the series is

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> =C2=A0tools/testing/selftests/livepatch/Makefile=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 +-
> =C2=A0.../testing/selftests/livepatch/functions.sh=C2=A0 | 13 +++-
> =C2=A0.../selftests/livepatch/test-kprobe.sh=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 62
> +++++++++++++++++++
> =C2=A0.../selftests/livepatch/test_modules/Makefile |=C2=A0 3 +-
> =C2=A0.../livepatch/test_modules/test_klp_kprobe.c=C2=A0 | 38 +++++++++++=
+
> =C2=A05 files changed, 114 insertions(+), 5 deletions(-)
> =C2=A0create mode 100755 tools/testing/selftests/livepatch/test-kprobe.sh
> =C2=A0create mode 100644
> tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
>=20


