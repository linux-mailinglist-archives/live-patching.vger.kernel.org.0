Return-Path: <live-patching+bounces-246-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 993A68BD996
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 04:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 192D7282A92
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 02:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD333A1C7;
	Tue,  7 May 2024 02:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOOKQ6PM"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E23946A4;
	Tue,  7 May 2024 02:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715050585; cv=none; b=WYwdELkSMQqr0Coa0ri5rKLiJMzKJPBM4QewQvqMrooYIw25LvtkXIxDoD3Z4izc9SKX58ZkJNeOtgtoXK4FWmACpbH/eYUpCZezGaCfOWC5w6Ikw51B3wntsBLEJ11/3cUiHEKG2z9Yg4Tf+MUgufl1UudyrIUEf1ABBsFerAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715050585; c=relaxed/simple;
	bh=E9petGmYpRAA3lt0YHUI+HJalaOjossZVaIcHNHMFfk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CR0VDKlFtmppZWGYmnjVPy9v4bInR87FrYPdRgceozZ8zf3hRI6OzlyFrrMk3QYVOPu6d1TJO74jFAwnuyur+oMABgXP2dk14USyE/TCs8rz4gNYWFBAriVEybFGoUjpIf6+/m9ItxN7mDp/j0fwSPxPQL+JUoSV9Ixrc40659w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOOKQ6PM; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1ed96772f92so17489045ad.0;
        Mon, 06 May 2024 19:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715050584; x=1715655384; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuB0cDt0MPPF6Tnoc3vs8z84zOu4lewdlXgK9t/pEtw=;
        b=gOOKQ6PMWHJ8hs6I/4daV6CVL1mnyuMZsFkQ9ynbPQc9wjn6WKgx9uDLcJU1W48Wr1
         +W+peIDtJyrgir9M0Unj0TfBSy6LArd6k/7XUH/gevvrKwi4/xKru7IvVqmNkAeIeCrf
         oktpZkFXDkhNIRV3/aDzITIfUSkuP+irTDVb+Hv91V+FmYbZdegrxHN5kQ7SuFnMYwFb
         30InujF5PdPWXF0bEoNn18WU/jY9iVCMiZkignqbuLaT1SFzDg5J5zx6QK3k0N9q3Fev
         bt0ATlz2PQv1nuUgyQ364IihU2znV2eAGRcgWJB61bqXqzhcqTl2TipWThDXpMKeLr2R
         H4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715050584; x=1715655384;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuB0cDt0MPPF6Tnoc3vs8z84zOu4lewdlXgK9t/pEtw=;
        b=OdXwWZ51KOMTotKiM6CNoGlMrb33NSP2nmuYqwZw4gt8Pq5d4FivhmsDuryZG1LJ5j
         QIgllofPAdGkJaZkr1ETD6S9RrAJgu3cQg9uRZACAOFcc2FtuUk5B0onIYVId+moUuW5
         UIFxBRUrvTNuw9NiANA6yCjQK8uQjAM8V2U/LnBpjtc855bwWjoN0/zW+fH1xvwBbpeR
         S9EzD45rbAejmy68aa5+9vtUwOpKgr9W7RTCzxj+seebjpqAEOCcM3OgGzVgVEVQCIf3
         rIZ+b25xAGxSlvaZaR75Oe8Nrk5bmQfF9hHceDR3sGnjukvJ3C6DVaIYG8ZN+KJuSoh4
         2G5w==
X-Forwarded-Encrypted: i=1; AJvYcCVE4rBtRqwpwM78wuifMM0+VPZcYNT64H5wZq8dXPgksjOI507DfKZq4gwNaizZhNo25MhmedFxdwZ3kYaItAL1gudjmixG7tC01Kox4YFPYh89RukzlX9zCycYmsGmGrhnDKrbtaTJlL4/yA==
X-Gm-Message-State: AOJu0YxlybsTOali/bjtIKepLSLEH7aiJ/6w6ach8LfDfP6al0VjVEED
	arxkFCUe2t+bbgyjn0a4sTR9yjcbavih0hLPzSjCOovhpPx4kkdJxxf/sg==
X-Google-Smtp-Source: AGHT+IHWQ5TVZRJqidzvz0Cx5yJb3tyXCAt2/3z7NISSelR1S3G88Bh5o80NwQRXCveeElb4atVEwA==
X-Received: by 2002:a17:902:f78f:b0:1e9:9c6e:9732 with SMTP id q15-20020a170902f78f00b001e99c6e9732mr14436514pln.19.1715050583734;
        Mon, 06 May 2024 19:56:23 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id i21-20020a170902eb5500b001db8145a1a2sm8916897pli.274.2024.05.06.19.56.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2024 19:56:23 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 0/1] *** Replace KLP_* to KLP_TRANSITION_* ***
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240507024151.6jto4zraqfbqxcw2@treble>
Date: Tue, 7 May 2024 10:56:09 +0800
Cc: mbenes@suse.cz,
 jikos@kernel.org,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4010C687-88C9-43FC-B8C9-80981B04807F@gmail.com>
References: <20240507021714.29689-1-zhangwarden@gmail.com>
 <0E399FCD-396E-448B-A974-6034F4CF2B53@gmail.com>
 <20240507024151.6jto4zraqfbqxcw2@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3731.500.231)



> On May 7, 2024, at 10:41, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>=20
> On Tue, May 07, 2024 at 10:21:40AM +0800, zhang warden wrote:
>>=20
>>=20
>>>=20
>>> transition state. With this marcos renamed, comments are not=20
>>> necessary at this point.
>>>=20
>> Sorry for my careless, the comment still remains in the code. =
However,
>> comment in the code do no harms here. Maybe it can be kept.
>=20
> The comments aren't actually correct.
>=20
> For example, KLP_TRANSITION_UNPATCHED doesn't always mean =
"transitioning
> to unpatched state".  Sometimes it means "transitioning *from* =
unpatched
> state".
>=20
> --=20
> Josh

OK, I got it. I will remove the comment later. After all, comment is not =
necessary at this point after we rename the macros.=

