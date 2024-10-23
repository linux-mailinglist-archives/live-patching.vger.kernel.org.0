Return-Path: <live-patching+bounces-753-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5412B9ACACC
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 15:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 841D31C20F0C
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 13:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BC51B4F0B;
	Wed, 23 Oct 2024 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mU+gqAWH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714214B94F;
	Wed, 23 Oct 2024 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689061; cv=none; b=UzC2uV434J+ZWT8rEpExHDqfSMKZf+XVfPgiGTfzuG8OJYR6H9LGCun5BB81tA05cHMO28lMyFfj5arTQ4hmagx4KzKByZhpV2a1hgFatBSfDAYZSdpLcqA6P8XsH5PrmzzIWiJ5Md6kn9EXUV1xPkTTbyuJ76w+dZbdmQmk9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689061; c=relaxed/simple;
	bh=cBfmrlBSfEjkwWoQphvN1hCBGz3UX25x8xMEoPM2ncE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=n6Sr2fEExtc83JBK+bgziwyjEucx3lDHi6941dEXvKFxttExS2GIfR00C+xkPf5K0S9Suo7L1uMEqpecaIbG7oJ4UV/X3OXPjR6sOSaNCCdbbD3RA1M3VRGzdi/feOQ8Hj/30bxKSIKC1XcJLKRmcJBQciRgmWsn/NkQtm+ck8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mU+gqAWH; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e3d523a24dso5057050a91.0;
        Wed, 23 Oct 2024 06:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729689060; x=1730293860; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBfmrlBSfEjkwWoQphvN1hCBGz3UX25x8xMEoPM2ncE=;
        b=mU+gqAWH9a9nwBUIJtzI8LjgDwVAxjxYq1NYzDtIbHZrvV+mp4V2/2GgEu2gXeP7Lc
         o1FKf98Ak5KKf/byCJLDrookOO814W+6G16k0SVNIb0oaPPR5GH+X9uGhzJoGAZ6zonG
         ON5Dc8KBpO/lodVD74tKI29FoM+WxxCAwv4ibI/8Xc7PN7wzLnLHxJHpP8TpXuaARCef
         EGPGktApLc8K1Uz1K63zjAPivIOWeI71D5nbO4+9EGpjvDFvgdTtr36dVGr1Dfb/gFP9
         DGjzWFsYmVkSm14Bw9BxoWMhawf6N3I7Js0yPEtrL2Y83UL/te6sJn4tMeGqFNvcPC0H
         t79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729689060; x=1730293860;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cBfmrlBSfEjkwWoQphvN1hCBGz3UX25x8xMEoPM2ncE=;
        b=janWhnVLwJd2vW615/4m7l0thPqf7obwV4IbroUzh2sXkmnoR4KIwoVSRaGppQTdHo
         mLdRksK8HBPQ7CNqINRnfX19ppLu5vQ39fG6nUG5eeXRRZIdEtwEvR6L2vnXg0YdVmjF
         LB+rLwCpFyTgWI0pyQG1h/AGjHt+wm+/uQ0IEAcjzzEWAZbn0J1TV8CNNj/VbLemvJ5h
         FcH55t7Xf4XakvK5koC7WCIF5y+Tt7ASIkSPwiLIFo0lwfiPrQQiRuf/RZrtsxLYe8++
         LZ1ZvDT8PKa/u2m29O6Fb2pGdBJjn7SJng2tpZWw93J9qzZDmgVfwKqQEwt9uViFOBsy
         iSyw==
X-Forwarded-Encrypted: i=1; AJvYcCVmzXN/7WGMlVabAssZlXJUbeiURV6bqu3TZpwkMKSF7n4ZTJ9XLeA3j0oMZ5JjHVnXEjIcKfzXZAaxjGM=@vger.kernel.org, AJvYcCW7TYSYGV6x+5A2lGk06ey+pApF9ms7ZzqXhyha1Z2f4fLrUfNB21KrdHCvLjxXS9m8nppHsKGC/Gf8lk/TNA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc/uWtQyewupFrOayBokTVR4EqYO1OSYnUJIG51WjmLHT42zId
	H3g/jq1O1Fd4hv58bsRJfALkYFduwuDkuPjGOyhRtmKEPq2odvyl
X-Google-Smtp-Source: AGHT+IGHhMQWlSVTp6HZMNeIo9OnRSVLvx9o6fv8H0IlJRx+pvtkGbmT2fc2kFO58D6++pvP8toFiQ==
X-Received: by 2002:a17:90a:fd98:b0:2e2:e6fa:cfef with SMTP id 98e67ed59e1d1-2e76b6deb3dmr2391639a91.25.1729689059786;
        Wed, 23 Oct 2024 06:10:59 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76dfb9b85sm1439745a91.45.2024.10.23.06.10.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2024 06:10:59 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] selftests: livepatch: add test cases of stack_order sysfs
 interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZxjuNBidriSwWw8L@pathway.suse.cz>
Date: Wed, 23 Oct 2024 21:10:38 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A7DB7574-7DD4-4D79-8533-1A8A104EFE24@gmail.com>
References: <20241011151151.67869-1-zhangwarden@gmail.com>
 <20241011151151.67869-2-zhangwarden@gmail.com>
 <ZxjuNBidriSwWw8L@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Petr.
> On Oct 23, 2024, at 20:38, Petr Mladek <pmladek@suse.com> wrote:
>=20
> Please, try to send the next version together with the patch adding
> the "stack_order" attribute.
>=20

Do you mean I should resend the patch of "livepatch: Add stack_order =
sysfs attribute" again with this "livepatch selftest" patch?

Regards.
Wardenjohn.



