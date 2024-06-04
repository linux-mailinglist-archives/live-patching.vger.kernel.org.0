Return-Path: <live-patching+bounces-316-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E2E8FAD53
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 10:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF7E7B2213F
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 08:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2648140381;
	Tue,  4 Jun 2024 08:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UdP9Ljqq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969451422C3;
	Tue,  4 Jun 2024 08:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717489038; cv=none; b=ZlQboPFPrjhtsZkndTVS1JHhjsK/TUW9+2ygblI6VedYXGN99E5LFbWTonMra6UGxu8SqPMvew8wVBeOCOK7dPhO7a4A6vTSZ3ptdQSuaZsAi8TJBvdfglWAGkmi22Jo9BAZjjT5gFppsUlI6y0Bbk7unDO5Xz9MPiY4qIrJcVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717489038; c=relaxed/simple;
	bh=9Wf+j/r8bT2i678Is404RDPuyVL0+W6hBWBeanTJwSc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Lqn8Jkqyu3vkFMyOoG2BuXTa3sDEcfD6BeWjb4R9FQMMzXj0Gx28m267HHrtwGnLKSkR+OR0vUcEYe5Xlytmh2BSD7N3J8eKrrCH2iDAIe5VihwPnbgQ8ULTlnQ7/fmtJaITfWgWxVLy0Y96tt8tV0V9z6w5Pm2baHE4p27eFXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UdP9Ljqq; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f6559668e1so19924415ad.3;
        Tue, 04 Jun 2024 01:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717489037; x=1718093837; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Wf+j/r8bT2i678Is404RDPuyVL0+W6hBWBeanTJwSc=;
        b=UdP9LjqqY3UYpJUxTaB+OoM1l2P7DNgSysqOstiHK8/jt8EChNsb69vysMDo0sEhn1
         m+9XKP2bsA1f3JGLRaOdZ7rlXeDPGxNP5oTKQi1/96ZD+lOw9Z6tkB9q+0J7H7NFGakq
         oYWigr0r3QHiCTRXNxVxrxzU0BpfdyA2TgdhO16BqXPKZnpA8VKxGSmRGb5N0Etz5ZQN
         y3F2b84RS1QQI6sZlcp1AuRtxCSgDSxbGsQa0XJtfl6seLiJ+nWxEn1/4YFMeLqkW4K8
         VFexMvC8gqw2jB/A+kh7U/cJzPF5xgs/wPJbkOH0PuMX5OR4bbAWIXUwjR+JSUzU4QEB
         orbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717489037; x=1718093837;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Wf+j/r8bT2i678Is404RDPuyVL0+W6hBWBeanTJwSc=;
        b=iM7oRhvpPvMFPXipvsazjW91TS3FxtfgLq5vHrKJZOOHwPT5bk/msQyS/fyptxs+r+
         BWUPuUep5y0yyUkNQeG9mX5a025d0M7JCEyMqKNiLPnZCaJJ0rIXuIWK4jxStzJZ9u9I
         JhoMoHTPQavslcmrM8WHOBxejxJIZLn19CyKMAIP0G/n7MbgYZZezT1XpGnq/td7JDYi
         YzC190W+bng2akeQwp7u28/SJLF5aNLrFA6z/66/8qoDej9jD+g5I+ngANbamXNzaZtA
         kRDmjoL3LTgGEVQKd6LQeVrmrtIg2p9CB0swE792DE8dlc/jwfvdIk7hbHrgJS4XRaqP
         kT3g==
X-Forwarded-Encrypted: i=1; AJvYcCWpqm5YWoNboQsKbFmlLXRl0HnYK+1GPXwSS97UzP+BQCrW+EP5+tYkP4WDpHCZY63018TiLrPn7x6iaNSwWnG22K4mefVeAVgq6/OVs16n3v7G8Bdts8K3sZsdC0xVHSsAG9sMOFGJTwVq3Q==
X-Gm-Message-State: AOJu0Ywedg/Aa9SPM+LK8pdBoKiJQrmlo3zumgTJxPls1TWpaqQJ+K36
	2IAYLtjQKC/F+7Rou0mRev727djH2GcfDhbqYbRCwoMD2QkeKzkohkvXpw==
X-Google-Smtp-Source: AGHT+IHdof6VcIZi7jyJ7d6rXgJdnuR+v8pNAs2MKOtL3+wKCAAoZXgFVg7deQ3SvxmgwbyFivmaNg==
X-Received: by 2002:a17:902:e5c2:b0:1f6:8290:175a with SMTP id d9443c01a7336-1f682901acamr43966985ad.40.1717489036496;
        Tue, 04 Jun 2024 01:17:16 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63232f26dsm78302805ad.46.2024.06.04.01.17.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2024 01:17:16 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2405311603260.8344@pobox.suse.cz>
Date: Tue, 4 Jun 2024 16:17:01 +0800
Cc: Petr Mladek <pmladek@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C2ABDBE-FBBA-4CD6-A903-B146EBBF4AC8@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <2551BBD9-735E-4D1E-B1AE-F5A3F0C38815@gmail.com>
 <alpine.LSU.2.21.2405310918430.8344@pobox.suse.cz>
 <FF8C167F-1B6C-4E7D-81A0-CB34E082ACA5@gmail.com>
 <alpine.LSU.2.21.2405311603260.8344@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On May 31, 2024, at 22:06, Miroslav Benes <mbenes@suse.cz> wrote:
>=20
>> And for the unlikely branch, isn=E2=80=99t the complier will compile =
this branch=20
>> into a cold branch that will do no harm to the function performance?
>=20
> The test (cmp insn or something like that) still needs to be there. =
Since=20
> there is only a simple assignment in the branch, the compiler may just=20=

> choose not to have a cold branch in this case. The only difference is =
in=20
> which case you would jump here. You can see for yourself (and prove me=20=

> wrong if it comes to it).
>=20
> Miroslav

Hi Miroslav,

Yes, more tests should be done in this case according to your opinion.

Regards,
Wardenjohn



