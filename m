Return-Path: <live-patching+bounces-585-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 771E296B2EB
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 275C31F29860
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 07:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467FD84A35;
	Wed,  4 Sep 2024 07:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPjCrppA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB0D3C17;
	Wed,  4 Sep 2024 07:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725435039; cv=none; b=Ka21bXEpG+uHhPOmuFXo+taycdGwdV/1IeWI1OE2AQ7pkUAsz7q0zgUJUndbY16Urz+KSSyKht/9lQSlGFGqYE8hZVNOtUS8QQ5EsaazaduQCVYCjNqKoCsEYtyrgxL8NiB4accicDtGL53aQ4S+8GQpY4k6OKk5wYLYKRtBQK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725435039; c=relaxed/simple;
	bh=QTKAtTr5G+yfYQLqHdlsyK4CKRJFLWXvVZeOskwFYKU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=roRQeKlyZaHr2qD7tgL2RztCNhZjt2RICRp0qQFKuCLHoA73uB9YhhhtLMT67BBJ5HxiWc9/Qjs+Ls9hGQPb2LGIn0gAV8Wvrk3or4Ybu5SXXtTRhCQaGoeYDiSE/4ViRkhZ6as/KOZ48ujG+ys+xSFcIYBScSGsKMOBZ6LzhLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPjCrppA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2055a3f80a4so23571415ad.2;
        Wed, 04 Sep 2024 00:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725435037; x=1726039837; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTKAtTr5G+yfYQLqHdlsyK4CKRJFLWXvVZeOskwFYKU=;
        b=VPjCrppA920ct41KHASAbGrBa4l0Y00bRk9VdpkZDhR/TM3x1ucToZTqxoXC5m5hop
         LG13S4QfUh2fahcPqXQscOj7JzDm1vTx/qkwufDhqd8t2tY9UVDyM76hpzbZOYg+zH86
         c1RNktuvl5yDnpdEFFro2T26iSAMNiOEuFQLgy5Nq/ora0qODZMCNFbDKt1PfYCjDw4j
         o4bshAuQ2fHvh95VONVFmmbgNjBNrmGmesvjWQg6iN2zkMX5ETDWRhwIhUdkTEkPQIuP
         wibSzWJkdaSq6Kadi3WyG1/a6DXl6aVH8xgor4bIkISc0IYk4qwKZdNNmtIC0nz8t+mV
         Q0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725435037; x=1726039837;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTKAtTr5G+yfYQLqHdlsyK4CKRJFLWXvVZeOskwFYKU=;
        b=d1K3gDDcD9ZkAJbTIMKeMf7em+7U/sZUG2y/m9NjYyam4FD5Lp9D/HSmTjn2kwzy1X
         3TZTpWb7uxvxiBLJaV9y8R/UUcOkw2zXRLw8YE0d14flWGxIC3OP8pWSHfHVJxkTpeGa
         LQrljx7FANXzrkCToQuq2vnRatijxnqSTlQ9tpOpmKomZaHB1iOJD7cRpVZwQ1Fwv2NI
         JOulf7tyUygwBSOfHrz1K8mUYbwg3s0P65MvNroeY4T1eljxL67PfsOhzqfM9lgeCmJs
         P2tHMxpbo3ZfivGbnYdK2A85KRwvj5yOT+qPE/WAG4cRIOIAToANNJ7QMz9Z5vc6I1oB
         1e5A==
X-Forwarded-Encrypted: i=1; AJvYcCUMZ7OrNWp9FoC/btPZ2ZwrNLF6u8viNSBECv1y2Od9nPoF8J1LvbTMeQmJeEtUZb2xeVA/Y7AYTD59etk=@vger.kernel.org, AJvYcCUVmj8ft8puSYv54vOUxYcCXCQsX1Pzv8i6r5hz86nei+Qfkgtjt2zuz5MxLw0D2UJwQAm4ZnnWK+6fEJwdhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxretSz+upjN1NNq6R3mThHwn991epbr8wbKhQNl6cDxOv3C9RV
	EgtQyBZ7/hfinyHLASMUfkfJc8yCKLVCSghxqHBYi5jedXUBy3x1
X-Google-Smtp-Source: AGHT+IEEfyttWhlG9CozmqIwNCC2n5zyn3u4pQYri5cmuJivGOBLSQTXTB0wU1XMKkEXqnWk46BiFQ==
X-Received: by 2002:a17:902:da81:b0:206:8db4:481b with SMTP id d9443c01a7336-2068db45e50mr83792035ad.32.1725435036964;
        Wed, 04 Sep 2024 00:30:36 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea38544sm8259755ad.161.2024.09.04.00.30.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2024 00:30:36 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240904071424.lmonwdbq5clw7kb7@treble>
Date: Wed, 4 Sep 2024 15:30:22 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1517E547-55C1-4962-9B6F-D9723FEC2BE0@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <20240904044807.nnfqlku5hnq5sx3m@treble>
 <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>
 <20240904071424.lmonwdbq5clw7kb7@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Sep 4, 2024, at 15:14, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>=20
> On Wed, Sep 04, 2024 at 02:34:44PM +0800, zhang warden wrote:
>> In the scenario where multiple people work together to maintain the
>> same system, or a long time running system, the patch sets will
>> inevitably be cumulative. I think kernel can maintain and tell user
>> this most accurate information by one sysfs interface.
>=20
> If there are multiple people applying patches independently from each
> other (to the same function even!), you are playing with fire, as =
there
> could easily be implicit dependencies and conflicts between the =
patches.
>=20
>=20
Yep, I agree with you. This is not a good practice.

But we can work further, livepatch can tell which function is now =
running. This feature can do more than that.

Afterall, users alway want to know if their newly patched function =
successfully enabled and using to fix the bug-existed kernel function.

With this feature, user can confirm their patch is successfully running =
instead of using crash to look into /proc/kcore to make sure this =
function is running now. (I always use this method to check my function =
patched ... lol).

And I think further, if we use kpatch-build[1], `kpatch list` can not =
only tell us which patch is enabled, but also tell us the relationship =
between running function and patched module.
I think this is an exciting feature...

[1] https://github.com/dynup/kpatch.git


