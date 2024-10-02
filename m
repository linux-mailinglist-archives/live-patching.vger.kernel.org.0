Return-Path: <live-patching+bounces-704-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC5398D80D
	for <lists+live-patching@lfdr.de>; Wed,  2 Oct 2024 15:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE6061F21129
	for <lists+live-patching@lfdr.de>; Wed,  2 Oct 2024 13:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77CB1D0B97;
	Wed,  2 Oct 2024 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NxZRftrh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282121CFECF
	for <live-patching@vger.kernel.org>; Wed,  2 Oct 2024 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877330; cv=none; b=teQnP6f7SlQ4YyTm4Ezto3LQPzjfl3B4xYsCpTQwwVUbCK/bqshrRfNYdxgNnTAZHrKbwLXphO76OL1cE2gtZVP7/wJkgC6kvEjLIEV8rD76rmxt5UhXKMkQpIBXm2RDcNXfYdVq9+53RPeyaHsBRb0IYfLHgTCSZmGu0xmc+Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877330; c=relaxed/simple;
	bh=RDpSbNQaDPalzXWgewd8bEdAjy1zCTSQo6NGuq3hSPg=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d/CqMYnSPp92xYTGvxRaC2Qrb4+qmcF8gw3W+9EnvfE72HzIWDSAY7lF5SOR7rgUnm/KpeTs7fX3wenyX+UbfGoThscVaiLKa/sHvZmIIEQ4lJ+qRZNYqDXy1DeMgnwDkr/pFacg2/6ETdaZP3cP1PvQGte0+ms7+fxFoqWd07E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NxZRftrh; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c87ab540b3so1605516a12.1
        for <live-patching@vger.kernel.org>; Wed, 02 Oct 2024 06:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727877325; x=1728482125; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDpSbNQaDPalzXWgewd8bEdAjy1zCTSQo6NGuq3hSPg=;
        b=NxZRftrhVOv2NtWBwWxwYyKDMdscMW0QBWux+J8HoIdPM9W8prBONKxoAQr0pmJROJ
         LavHk50fRdbVyUYEdfh+toMsNdzjaXb9hO355eZRfcwiImFBL4Iu0Y91RVHIkbt4pEpr
         j39p0xESRTtJ8/hGYH39aTs0LCieaQGNvPNZJhxjak/S6stzYIOX9Djr3EJQGFpmpaqY
         hG22JWpPiOPOP2KpUQV2qxPuxsH/CXNU8JOrZ56cZcYlyNJ/giIc5XQ6ZZu/dXSHp/Nk
         JpieS4jnttMIJDvwOj18iX6SFFZBtwnqho+2e3V70ppiW93LkOFFW1nOYCly+L/pqWCN
         ybew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727877325; x=1728482125;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RDpSbNQaDPalzXWgewd8bEdAjy1zCTSQo6NGuq3hSPg=;
        b=pSCvPujumWeYb95Eyky+5b8R4oYRj2TQVdxpCvqxZfPwRh7nwnMMIeDJIyru/Qj1Uz
         OJMqRbpkep61ITM4dnXgtCfrydNeSlSERc1IZCfRdZZm9WqO9GSbDSKVdH4DA7Bn8gSG
         /QXWd8e6saZiKePknmwMvz3XL+AOuAulQ1aqo/w1gomjuv8PFcQkat4P2LLB8AEugjzf
         3jQxxlzrBchzNJbHmrSRXpUq8GV0KbbHAQeF71pgWc8IsfMzKnfBsQh/S7KdRdNHqAD6
         BmGdsChr9/Fqremh8oW8AN6w9tdWgJTxpJEdemywp3gOR0eb7Ls73kclOmRlcRqN2dc7
         AXEA==
X-Forwarded-Encrypted: i=1; AJvYcCWu3H5ZQqMLdbP7cf6xOfrcsEfpGxKXBnUxJPbVsfqJlIcZnCAgBg/AOU3j9qwLNRrvuHa5hlzZLLl4zKy1@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+nHgNvdT/d6mvii+Y4n0pKymMpkmweJ2dZAtAMdbbZzh6zb4y
	Jg7Onqq9zk5f/41rIlfgxQJYbjvXHiDUCEB/mzyQ8sKhoXBao6uT2wB0xypel8bxGMZ8lsnVmS5
	0eLTQsg==
X-Google-Smtp-Source: AGHT+IEctmrJcjBla3MxukdSa9h3HgBV8uibC0mDNbF2CRtB14uct2W30kUOVg3kkSfcxIUeHLqaBQ==
X-Received: by 2002:a17:907:3e26:b0:a90:34e8:6761 with SMTP id a640c23a62f3a-a967be75f55mr790298466b.6.1727877325496;
        Wed, 02 Oct 2024 06:55:25 -0700 (PDT)
Received: from [192.168.3.3] (151.36.160.45.gramnet.com.br. [45.160.36.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2775995sm866099566b.41.2024.10.02.06.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 06:55:25 -0700 (PDT)
Message-ID: <33e18a57dedf8295828ef7f6b8daded8bd771999.camel@suse.com>
Subject: Re: [PATCH v4 0/3] selftests: livepatch: test livepatching a
 kprobed function
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Michael Vetter <mvetter@suse.com>, linux-kselftest@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2024 10:55:18 -0300
In-Reply-To: <20240930093308.65103-1-mvetter@suse.com>
References: <20240930093308.65103-1-mvetter@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-09-30 at 11:33 +0200, Michael Vetter wrote:
> Thanks to Miroslav, Petr and Marcos for the reviews!

As the only changes were regarding bash nitpicks I keep my review from
earlier patchset, so:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

>=20
> V4:
> Use variable for /sys/kernel/debug.
> Be consistent with "" around variables.
> Fix path in commit message to /sys/kernel/debug/kprobes/enabled.
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
> =C2=A0tools/testing/selftests/livepatch/Makefile=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 +-
> =C2=A0.../testing/selftests/livepatch/functions.sh=C2=A0 | 19 ++++--
> =C2=A0.../selftests/livepatch/test-kprobe.sh=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 62
> +++++++++++++++++++
> =C2=A0.../selftests/livepatch/test_modules/Makefile |=C2=A0 3 +-
> =C2=A0.../livepatch/test_modules/test_klp_kprobe.c=C2=A0 | 38 +++++++++++=
+
> =C2=A05 files changed, 117 insertions(+), 8 deletions(-)
> =C2=A0create mode 100755 tools/testing/selftests/livepatch/test-kprobe.sh
> =C2=A0create mode 100644
> tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
>=20


