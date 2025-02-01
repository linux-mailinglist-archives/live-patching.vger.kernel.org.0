Return-Path: <live-patching+bounces-1100-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00026A24671
	for <lists+live-patching@lfdr.de>; Sat,  1 Feb 2025 03:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CCAB167A41
	for <lists+live-patching@lfdr.de>; Sat,  1 Feb 2025 02:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913FC179A7;
	Sat,  1 Feb 2025 02:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TL0Qpnoh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254C1C125
	for <live-patching@vger.kernel.org>; Sat,  1 Feb 2025 02:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738375490; cv=none; b=VRXJ3bk14gPbgktuRD7DAaiYMxU8qX4jD6poA1sx+YbouVH7hxg/StxnkCqK+A6q1NL9gmNJU7fjhzO0ad3uGjI38TrkcZHx7I59aaDIs3w9zidVBffI4k0TX48Q03wZ+rgAyloKicfTTsWLUOe3uqYoXejNxL+IMLgkvPPbhBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738375490; c=relaxed/simple;
	bh=5RFI3Ke8rIGEBm6Exj2vqz1Yu1agA71PH5j8mdLO7gU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kjuERS++DFan+iM25wS9iCWJfxJubNqdJVAxLNVknEb7TWA+Xu56bA3PGP3IxDokMw9TSYvoNz3PFv5+3cLO7aYiSA6U3zNS/LtBY4bbXD3jN+dKdJ2zdxrsqh2NXIBPceoEkSJw7/Texm79X3xLtOuI3lXpBdd3WIIQYFSUU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TL0Qpnoh; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-216426b0865so46683985ad.0
        for <live-patching@vger.kernel.org>; Fri, 31 Jan 2025 18:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738375488; x=1738980288; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5RFI3Ke8rIGEBm6Exj2vqz1Yu1agA71PH5j8mdLO7gU=;
        b=TL0QpnohqtM2Hi/RlBdkhkZ39FKmGQKwKyZhq/n5UPuGHLYpvfXMiwgWhy3GdWAxB9
         IJhPyPJaKHOvk5O7PGlZZfIbqXsvlyyrUr2lqRQ0biXZixluvqgmHL1SEwtoZ3hOvp++
         QgFXm/ui/4OkiKoG6uwW2uBN8vQp9Ve5O/Pqp/FulWDGfFiAmCf8n3zj84IQvR3FdhAt
         0+pDBlntNEBPoEPey7wogK91+AaD5lQ9JMbh4j6H5tWuuJ5I+jez+aljoeL2DeVlryjv
         JgWBvxd4m/yDPsdpMJLDjvqE1MvNVoZ0hfGbxEC9nxTvDwYvsgxiN6agPtEYG1H0gaXo
         0+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738375488; x=1738980288;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5RFI3Ke8rIGEBm6Exj2vqz1Yu1agA71PH5j8mdLO7gU=;
        b=E1iiNiBSEBu6zbQjOmKlD2HzpDtBWpPQjEbzult841HtRdOmkUX5L3CT08ag5ElOHU
         qxgZzw6a9cb5O3vXwJYxVvGpMS1qcaw8HidSpCuVY0rTxj8fd0HHXhRhsbPxYo6oZr4n
         bnwfuRZH89PygTZPOh6jny4vYbStjC+8WeY3A2INU9yAhpFu8C9VrRs97EbaEpMV3BXt
         vhw1k0opmeFXHV5OE9NVsC8I9gKB4/GkU5mLqmnGSOEn6INgrXTiCrH4I1JPD/qt8Boq
         9orglzuqqoTMXpGy9hhgZuaSmeoHk4Zeguf5RZxDSMrjZBiHp5vwguCUpqRJV5t1ZHZX
         VWHg==
X-Forwarded-Encrypted: i=1; AJvYcCXC+M3NZpJCJyhn4fP+nKwCwHdNQHBb3a/Ckz37+p895dSBYQf9h0OYUfElOreQ2uUToel+iGoburQudFXG@vger.kernel.org
X-Gm-Message-State: AOJu0YyIEUcjRxJuktlktWBqGpucB3Kn3aUGugI0v8VfziG58vuPT6k9
	SPKemlcs98T7GXfNyB6xqFetTTYTKbiTrPT42AYUedweRea50nRy
X-Gm-Gg: ASbGncs+IFXn5NBz8fEfTTmRSK6Oeb4c+6XTV2i/2yYDChVOnY1QNIKDbIBvAx2wYcP
	5Uv4r1GAGvL8cV3nDf5n1q4mmw44GCks8DNsSqUsWso1ZgN1MTLZdfAr0+KYxGpAxL4Z6f88mtp
	RQUm8w7sPpAKq7EtVAyEuMr3Npn7zvkTaCHQwab2qoBlnEQNnsgTs+dHNLsiQ+3rd7ZI7mUNnz8
	bSkbmpOCwTvtfP2eB8nIrYJxiBRUOdXzdUO5kB8SHySynBKObShfrxYk8rqxM886EcWUQsXz6Gh
	S5sZtdlupj/nrDEiOKg=
X-Google-Smtp-Source: AGHT+IHzIdSdG88r8SDpM2DsP3B+QBkcux9V+QI3T+x4EB4Z29gz54xsuSkGWaNVpyf8ymaLF1k8RQ==
X-Received: by 2002:a05:6a00:1d07:b0:725:e325:ab3a with SMTP id d2e1a72fcca58-72fd0c14ab0mr17899885b3a.14.1738375488247;
        Fri, 31 Jan 2025 18:04:48 -0800 (PST)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73001ed4cdasm464295b3a.131.2025.01.31.18.04.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jan 2025 18:04:47 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by
 klp_try_switch_task()
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Z5zSmlRIv5qhuVja@pathway.suse.cz>
Date: Sat, 1 Feb 2025 10:04:32 +0800
Cc: Yafang Shao <laoar.shao@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 mbenes@suse.cz,
 joe.lawrence@redhat.com,
 live-patching@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <86736F95-020D-476F-999C-8666A6B0BC23@gmail.com>
References: <20250122085146.41553-1-laoar.shao@gmail.com>
 <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
 <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com>
 <Z5zSmlRIv5qhuVja@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Jan 31, 2025, at 21:39, Petr Mladek <pmladek@suse.com> wrote:
>=20
> You got it right. I am afraid that it might create a livelock
> situation for the livepatch transition. I mean that the check
> might almost always break on systems with thousands of processes
> and frequently created/exited processes. It always has
> to start from the beginning.
>=20
> Best Regards,
> Petr
True. It will easily raise the problem that some important process =
cannot successfully finish the target patch state and make the =
livepatch-fix unable to work on some key process(which may happen). =20

If this happens, I am sure it would be a nightmare...

Best Regards,
Wardenjohn


