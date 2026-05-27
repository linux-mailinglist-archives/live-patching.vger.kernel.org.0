Return-Path: <live-patching+bounces-2896-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAcHJwDhFmo9uQcAu9opvQ
	(envelope-from <live-patching+bounces-2896-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:18:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E98EA5E4074
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 268FC303F7E2
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 12:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6CF83CAA3A;
	Wed, 27 May 2026 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aDP7eDGA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6714378D88
	for <live-patching@vger.kernel.org>; Wed, 27 May 2026 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779883793; cv=none; b=HL+CzHpk+mfCHabK0U8Td/EV/uundaMz1tesahW5cnK14uplcquTyjd/XOrCtRVtO6Lp5LInrf2ghmbsJWryQlZW4YYFjnflW1yrIFmVrf4G8ccFrB0wg38piWRvIK3eFj4GFukA0TgbifWFduS1Fs9HLUtOYXDipYiPTrRELaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779883793; c=relaxed/simple;
	bh=drfjH7o548i+540WGAubuCmL5rG/O56cLDfTL1pqmIM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hKUeKs8W5qy+1KF/wK/+Wd4wd5t+VLu9ch9Dc+W3G/hOPuARElH2YhGEzYnPvdpJGk219RaRi6ue5dzWwCOKBhI1ci+GRmeOX4hz4Fu8sXUAyG8rYVL8Oc1UbKfladOsAfZz3+yqt/ypWus7Fc3lj1mP7A9U7vWml0jDfnhwfZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aDP7eDGA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49041fb8c23so42115025e9.0
        for <live-patching@vger.kernel.org>; Wed, 27 May 2026 05:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779883790; x=1780488590; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gNImo5uz/kWBnbovfRMfhXVPnRP4ApbZCS3Az/Sla4I=;
        b=aDP7eDGA+o7dGtU/FNlK0VMk+iSUkrxI81hLrVuPi2TSoGRoX8YucH8wIN/+N1I2D2
         zmk/iqwm2DEHTx5639SoJNIUQd4rI7x0NpqJp8YFJDlXK7MK3Gx2FtZPHmBqKoA9esby
         3IqXZgt66CR8Eg+e+tU+VBtKEechmq4cc092NB7+ZkP58cKgvQq1YrPR/kAhNIc5prLc
         NBGo/PBMKuLNUpLyFNYS7n58nOw7n3nviDjXl4ZvywjUEAhXagd0Gg5/BB9N2B9o2eSQ
         fUTt4d5nQ1rwb+mZiQfzukLjsmv5TJ3k2bdTQE7Zr6feFQRxJWMIsRKbJgQup6pqye2E
         9q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779883790; x=1780488590;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNImo5uz/kWBnbovfRMfhXVPnRP4ApbZCS3Az/Sla4I=;
        b=F3vIJUuxY0nN+6FEND8lqpCtd91RPtVm+gJZ9jANpKHNlLEVISNscasz2v7xZoEgTI
         MOdDOcKPR3LXBqWrzkOheBb99kji3QU5SCuGrfw9AyTsgN62U9yAR1HlemND7Dm57WFP
         vI9lMLXa234PLF7ztiMKuYK4WtJpx7oPtqtQdPVdCOBKA/J9/oVFR4gHfTnICMyFWdXg
         ZYP3L+PXmF0IquJazKbICvemT+Ar8/kh0lEBIU2SIseE/8qsw/YijoJb/siA168ZbVDw
         tyV9qoUUWnd5AzsEkURzMb23OhMFdCQUDgNSDRSsxgGB3w+/OSsy0H2KJYWRAfzMNckV
         dIxg==
X-Gm-Message-State: AOJu0YzcKpKZIw0SIDRsWXI4/BxFkXXJmkIjbOPHkwwh5P+fj/NGaHha
	wJ/aVJaOSi45pXL1KMqDXnWLbNC6cRIg+5aWdbrkVqYn095dX0jY1rDP3zrLBcBVGQNtAblVE75
	chgLf3Bw=
X-Gm-Gg: Acq92OEB+G+Z0fMVWUcy9d/hviFuoV3blorZUi1JFPhUzAak0aKmF68CZpmsDxddJUx
	/JcWPnDU4i5mWTgd9IUi020SsHrsbr7XPCxrLkDcishCtHSkicbZ2ZGGUb+Hfdh3hUNwvwTFp7h
	x/BxPypQMrz72OThxiuHLeuh1ay1Te8CLcCiTQNb4NfjfgzDPcu9ALpRovIvQe4msvaaARw37EU
	ghzuUWw4ps9fZkUhsADIoHHlOgTloKAaloiyT7oJrVhmISCvjQ5M2z2sfG42lqle1bKyT6k2OqU
	QKMl9pc1ozshZ3h+3HFQSzm3X3A+hxX4AUCwtnp/oT49pMAeq6fMUxR4eKVmMiJoyXBXK01HNTu
	TqIXhty1hCvZdckA92MFzRKu0XfwLMpoKgRPkgplTBtquoZkTkevHRMZbRwPAiUsyDk8j+voLQ+
	vqXmFtZe2B69sfNXg+Ckn48ZQx+I1cHwhuytb/h6fWaXm2W2uvNoBY7aToFdRf5c4l8Kkl+UJop
	ffs2fbMQ/bUMB7F
X-Received: by 2002:a05:600c:35d6:b0:490:4973:91a0 with SMTP id 5b1f17b1804b1-4904973932amr354441475e9.10.1779883789964;
        Wed, 27 May 2026 05:09:49 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-586f791fa49sm20367234e0c.12.2026.05.27.05.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 05:09:49 -0700 (PDT)
Message-ID: <cd470b3b399aa01dfa54a758eca77e58c672d314.camel@suse.com>
Subject: Re: [PATCH] selftests: livepatch: set LC_ALL=C to fix
 locale-dependent test failure
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Qiang Ma <maqianga@uniontech.com>, jpoimboe@kernel.org,
 jikos@kernel.org, 	mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, shuah@kernel.org
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 27 May 2026 09:09:44 -0300
In-Reply-To: <20260527095929.1504032-1-maqianga@uniontech.com>
References: <20260527095929.1504032-1-maqianga@uniontech.com>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2896-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E98EA5E4074
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 2026-05-27 at 17:59 +0800, Qiang Ma wrote:
> When executing the command
> "make -C tools/testing/selftests TARGETS=3Dlivepatch run_tests",
> the following error message was reported.
>=20
> TEST: livepatch interaction with ftrace_enabled sysctl ... not ok
> ...
> livepatch: sysctlo
> : setting key "kernel.ftrace_enabled": Device or resource busy
> livepatch: sysctl: setting key "kernel.ftrace_enabled": =E8=AE=BE=E5=A4=
=87=E6=88=96=E8=B5=84=E6=BA=90=E5=BF=99
> ...
> ERROR: livepatch kselftest(s) failed
> not ok 5 selftests: livepatch: test-ftrace.sh # exit=3D1
>=20
> To fix it, set LC_ALL=3DC.

Would you mind adding more context here? Can you point exactly why is
this failing inside test-ftrace.sh script?

Have you double checked if you had any previous loaded livepatches why
trying to disable/enable livepatching?

I'll test in my environment, but I'm pretty sure that it used to work
not so long ago.

>=20
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>
> ---
> =C2=A0tools/testing/selftests/livepatch/functions.sh | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/tools/testing/selftests/livepatch/functions.sh
> b/tools/testing/selftests/livepatch/functions.sh
> index 8ec0cb64ad94..ecf27c1120f1 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -4,6 +4,8 @@
> =C2=A0
> =C2=A0# Shell functions for the rest of the scripts.
> =C2=A0
> +export LC_ALL=3DC
> +
> =C2=A0MAX_RETRIES=3D600
> =C2=A0RETRY_INTERVAL=3D".1"	# seconds
> =C2=A0SYSFS_KERNEL_DIR=3D"/sys/kernel"

