Return-Path: <live-patching+bounces-680-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3613B9850D9
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 04:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACAB41F24C44
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 02:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4942C147C86;
	Wed, 25 Sep 2024 02:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HH3JzMW2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B252907;
	Wed, 25 Sep 2024 02:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727230089; cv=none; b=ZRxP/GlluWhYaTog916/NKtz70lQJKyCIghQdS4AepCoDcq1Kx84MFhgv9uzffK+v9YNqfBzxFSu65PulRhPpAInTNuj4gNINsyGpJy8Js6wa8xoF0yV6M/Gd3GR02ZjMSbVGlr+JefxcEF64KeU76xI6yD1+JD9nVX0KGqV9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727230089; c=relaxed/simple;
	bh=YQdyEEZJ5a6/ep7DkjM00giP8OFpMEW3FmhXIjpNbqQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kR5eglDXbm0W4Hhe0qugJaNCcv5aoyPr9TSBN4PYEP/2b5BxyX33VzGkcxL8cQ0FX67fR9TW2Lwyxa/t+NUtR/FatPMFAEJa9Q7QutNZDREGiSuqdcMDVhuAEtCwWzqOTX7amM7hoCeGNg+4jgJas1V/RIKDuiDOgqSlf/bLSRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HH3JzMW2; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-205909afad3so70398965ad.2;
        Tue, 24 Sep 2024 19:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727230087; x=1727834887; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQdyEEZJ5a6/ep7DkjM00giP8OFpMEW3FmhXIjpNbqQ=;
        b=HH3JzMW2uX1oGuLTpo0yUoMGMhFhclpnd2rUgenPi+MZ8ReEjSxptgph0NiicnRRHq
         BbO2Htt01i/x+jskG8FzFTkwcQagh4/sm3WwmexMWTrMQ+M006c1KBjJzVomWmIWpTcw
         +J1hmQIZsPa+MsTlo+7KI8LQVTl2iqOBDSKaXcgF7R7yVRJXbgfZJt19vPGesKtejRyA
         vst5N7AjlS9SNRbrrU7YOBU74aTHTbx1Y8G4JXZII9iv9h5T+4bwWRFuiJfNQRbgHlzy
         e3Ko9tkkd4gmnWgMLIfDYEdKFNEqnDIWICuohCWSbaVjaYvxB3dgr4mK2+rmUhJhBu4N
         uLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727230087; x=1727834887;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQdyEEZJ5a6/ep7DkjM00giP8OFpMEW3FmhXIjpNbqQ=;
        b=feaiZYYFbnV9sBn7hIZhwLwsztmmCUT/ogcQ8QsdY38G+MV2dgdjmb0DA+a5NAg35E
         yShvkc2NhZy7uFI1O/sSuN8h/5r9Gs/1lSXj5OKh6wjBbpdS6EBg89sSW7gGMSMqTK5t
         qQswQ6a8kQsa6VMtCUgTDvLYpvxqb3+Q3EkHYr65JlP94lwgbqPyPzPHRI+xEEO6wi+3
         diU3Vp2I8mbCP0CLSAYjYAhEThTK+Mv3n6eH/JjEE4eikbq5JqzdvEtqSBGDC/iECqB9
         YHEfP7aGp+yW+2ZUpME20Vbw9UbYb+oTCdCv+ZaQN8PnnVNMQLiGqekbxXB2RkOPAN31
         y6tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgGkILq7QPzyUMJZNrsQPCmTeBYHDSD01HBCnNaYm92jgR2M4ifKv6lGc0ZDi/drqf2tL/oQ/PMuEmYxQ=@vger.kernel.org, AJvYcCW7nIhhP8VRsJp6dqxAijKaeSzKrVMP7aHn8jLJEkFbW6yRIKXgTx94ybI++uY7DYydIjp7DDB3DCAlbJ78MA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvs8N1jfX7nzLxP8suMCCfq+R27QQJZkd4HGoThQw/R3i/ZWUu
	tXGY7f9n/eqnl4k6W2YkZn91BFBf0I7/cfX7y22GxpEvv5/cGILB
X-Google-Smtp-Source: AGHT+IGewTRV5H15P5hfG14X46jcfTk14wLdVb4BYVwml0icSQRScEsD55EY8vGvckQSsvtcX2osCw==
X-Received: by 2002:a17:902:d510:b0:206:bdb7:7637 with SMTP id d9443c01a7336-20afc4c79f7mr16973245ad.48.1727230086993;
        Tue, 24 Sep 2024 19:08:06 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af17e1ac3sm15644515ad.150.2024.09.24.19.08.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2024 19:08:06 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH 1/2] livepatch: introduce 'order' sysfs interface to
 klp_patch
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZvKiPvID1K0dAHnq@pathway.suse.cz>
Date: Wed, 25 Sep 2024 10:07:50 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F420EDF1-976E-4B76-A1D7-83CCA8F3023C@gmail.com>
References: <20240920090404.52153-1-zhangwarden@gmail.com>
 <20240920090404.52153-2-zhangwarden@gmail.com>
 <ZvKiPvID1K0dAHnq@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi! Petr!
> On Sep 24, 2024, at 19:27, Petr Mladek <pmladek@suse.com> wrote:
>=20
> This does not work well. It uses the order on the stack when
> the livepatch is being loaded. It is not updated when any livepatch =
gets
> removed. It might create wrong values.
>=20
> I have even tried to reproduce this:
>=20
> # modprobe livepatch-sample
> # modprobe livepatch-shadow-fix1
> # cat /sys/kernel/livepatch/livepatch_sample/order
> 1
> # cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
> 2
>=20
> # echo 0 >/sys/kernel/livepatch/livepatch_sample/enabled
> # rmmod livepatch_sample
> # cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
> 2
>=20
> # modprobe livepatch-sample
> # cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
> 2
> # cat /sys/kernel/livepatch/livepatch_sample/order
> 2
>=20
> BANG: The livepatches have the same order.
>=20

My bad...lol...
I tested this patch under my env but ignore such important scenario. =
Thank you very much! Petr!!

This patch do have problem, I need to rewrite it again. I am sorry, =
again.

Sincerely,
Wardenjohn,=

