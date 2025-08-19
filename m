Return-Path: <live-patching+bounces-1620-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B836CB2CD0D
	for <lists+live-patching@lfdr.de>; Tue, 19 Aug 2025 21:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 736F7683004
	for <lists+live-patching@lfdr.de>; Tue, 19 Aug 2025 19:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFCA3376A8;
	Tue, 19 Aug 2025 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZhvRG9Vl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4732C335
	for <live-patching@vger.kernel.org>; Tue, 19 Aug 2025 19:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632189; cv=none; b=e95X7Sh1ItG3JhsEsXTG7eX3gxQm/jLw9WgqT+hRjJbsC9e8J0WzTmBzQirWvAkTD50Rk0/hs7gdTfuD42UeVnkVqnD6zv/d3Q/XE+KuEEjE2rsb9OsUG1LTnZg7FK8bGwCTZ0GniJo5pbTfAwTewF3wtc/RpUzQfA7DjgFuJ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632189; c=relaxed/simple;
	bh=XMTr22jE8+TzIGCkrNbuJr5AyQILau+FIPmP9ww25t4=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=dj1FXAd6+jF5qvyox8AnB5/ZUYGI7eO8MMv90UkKTCOC1XbUH0OnqFPj4nPXpJu4lrOOFv7VcCDz4Rh0kEmEFm/N1xTP/8OM8Y5UFcZ2okSEc9Y6bngDhOUSTwTVdirV/Yukn5i/eKrQDHZqhLAApAPOhOqFSmUbq35mgrcBtDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZhvRG9Vl; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b9d41c1964so3763112f8f.0
        for <live-patching@vger.kernel.org>; Tue, 19 Aug 2025 12:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755632186; x=1756236986; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMTr22jE8+TzIGCkrNbuJr5AyQILau+FIPmP9ww25t4=;
        b=ZhvRG9Vl0pj/TiRwXhF3iSzfCDebouJTmG+cX+DxjORb9DSqD93ZVxRmVEfXrdIvRh
         G/ZYUhmmqt2nGlmjy2UVRbHGEbFG3zI9ADXDQ5COe2vNNdYVtmnFGG8dd9OObciNMKpV
         RMtT7KIH+xz6M3n+5E+rSDLFnndWoVcP6S7OXvf2PQ4TETFdJZQN2qM/BCDNhzigx96V
         AYk8zncvpojcMpVdiGMOekx2ZHq8KpYoKrndMB7GGzure+6vpbBHIDIjL/7kCtwTOb+L
         IzdCy1zd3G491sqEEA8LZgOv4b0wD/eu2fXSB7PQG1ne4WzAEXGf0iXlwlrG0eeUfK6J
         fu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755632186; x=1756236986;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XMTr22jE8+TzIGCkrNbuJr5AyQILau+FIPmP9ww25t4=;
        b=h3jVehkECKoEnhS01nkrYx4zGynfkPc49Fi38uKsNj4BiRcIpUYpH+j0DL7vbDCiyp
         aFxluu4t+HqwAEkMjcF9827GzppDHI8D3pwfIhXGc6qq90ZbL/Kp/12HaP1HWVDjlRm/
         h7o9/KLGnCV9SxZ3tXO7c/jXqd14+Opqiy6wB0wICLwFcA0WxYwvNiIfBU2erU3wkhrS
         qcQfIZ9E8rFOERJ+igg1iZIvl5LkDmCjZBE/ppdR+oJ0R79Ck3BDnryIO+6VJ0RqIsGe
         TPl3va7a/yTQf2zBELg48KOTQJfmxgnY3dx12I3foz9mkVjQrGlbsKYsUhrfek2MfVGi
         3Fvw==
X-Gm-Message-State: AOJu0YwM/cSq+LCoDjW4OlDGcU0sj2QU1K1twOAHnFn5BaPWdpt0WKjk
	NnrUbBWmoid7aPSBfcaDqAbup88loC+9s3LYmNVI+qmHZF3Ek/OqhIcJqxUDfzqS+m4=
X-Gm-Gg: ASbGncuHD15nrV8tVsZGqqXrrLNXvePk8FIIFNHpfA2K+Trq5xPWU5jvfs53v8+huWJ
	RZMOvpPntrJxunMLTYrq+NUqHSJy+/qnX/lFZfDJa0m2RG/nDSO9PL03/1RQr04X0+/0YHGV3yH
	ij9N7YJOSaaVpssgYPDK1+jrzCIc+VPUP+phAxiOOiJo9QhuQLZb8vOgkOen17SlXCE6EA0GjuI
	FoIU3vYEhhIArHJ9n1wdRO+VbvxN+o17tOsY0SxxYsWnWi+Dohpxj1iAyR1YlhCfnQCmeY3M2Iq
	wEsHcs5LN8sTWKzJzOmHoFjxv5YzsU6mSRNSI565u6td/Gu0hko09Yp+DetTYzFpQ2XcnMyTc/1
	fn9fFz9Q76A==
X-Google-Smtp-Source: AGHT+IHBk2tSb5Lmwdms9G3Pkyvfo6Sp5PUfXRSGwyT9Jfwf9OGJ938dge2YMoXl7bFT6nj/p8+rtA==
X-Received: by 2002:a05:6000:26c1:b0:3b9:1109:7064 with SMTP id ffacd0b85a97d-3c32c52f457mr162200f8f.15.1755632185904;
        Tue, 19 Aug 2025 12:36:25 -0700 (PDT)
Received: from localhost ([177.94.120.255])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-53b2bddd926sm2708328e0c.14.2025.08.19.12.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 12:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 16:36:20 -0300
Message-Id: <DC6NO1I1LFU4.1G1WPLKTRZGNV@suse.com>
To: "Josh Poimboeuf" <jpoimboe@kernel.org>, "Jiri Kosina"
 <jikos@kernel.org>, "Miroslav Benes" <mbenes@suse.cz>, "Petr Mladek"
 <pmladek@suse.com>, "Joe Lawrence" <joe.lawrence@redhat.com>, "Shuah Khan"
 <shuah@kernel.org>
From: =?utf-8?b?UmljYXJkbyBCLiBNYXJsacOocmU=?= <rbm@suse.com>
Subject: Re: [PATCH] selftests/livepatch: Ignore NO_SUPPORT line in dmesg
Cc: <live-patching@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Marcos Paulo de Souza"
 <mpdesouza@suse.com>
X-Mailer: aerc 0.20.1-125-gabe5bb884bbc-dirty
References: <20250819-selftests-lp_taint_flag-v1-1-a94a62a47683@suse.com>
In-Reply-To: <20250819-selftests-lp_taint_flag-v1-1-a94a62a47683@suse.com>

On Tue Aug 19, 2025 at 2:37 PM -03, Ricardo B. Marli=C3=A8re wrote:
> Some systems might disable unloading a livepatch and when running tests o=
n
> them they fail like the following:

oops, sorry..

Please ignore this patch, this should be handled downstream along with
https://github.com/openSUSE/kernel-source/blob/SL-16.0/patches.suse/livepat=
ch-mark-the-kernel-unsupported-when-disabling.patch
...

