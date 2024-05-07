Return-Path: <live-patching+bounces-243-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 546D18BD95D
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 04:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E90FA1F21A23
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 02:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0224C6B;
	Tue,  7 May 2024 02:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgcNmS13"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA0310F2;
	Tue,  7 May 2024 02:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715048517; cv=none; b=kcuSuQsaWM1L5O4zlBy/oPQZr/kb/vtkSc8Kb7pIbslAb0nfnxaIu1rxiBwMire2sJs34VwESKNqwzfKVLn9Z69utiY3sLS4eTRrzqDcGYj+TlwcyiUfuauWctfSVG/y2OErCNCGBH7MflYlnvTWaS+K82byZVXRpb1OWyVYt54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715048517; c=relaxed/simple;
	bh=9nQW54+C4h+PA/o2ubGIoYRcvWs5DAna49ifrACI4Og=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NW7bHbNuxxhZ06utRfEmJFoU5kVowSTqbbf5jDbmmXxmsY/fsqIa/trJEWC0ZSBs1mr/K7aw1UlNuKjWDFluH7xlBOo+YXEakF+Z46BAHg7IRzAHgYDnjVXjfL1qNwgYceD0mjlZ5k9XgRlxP/lOMZaRrWx98IjCf+gA69j4XXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgcNmS13; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e4bf0b3e06so23175635ad.1;
        Mon, 06 May 2024 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715048515; x=1715653315; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nQW54+C4h+PA/o2ubGIoYRcvWs5DAna49ifrACI4Og=;
        b=AgcNmS13y++A6qQ59dproyBR2v6T/2lL3FF59Bi/AE1gwXpPAOnfX6zzTB9XtC28eb
         AadOdIVg2zsKqG4P29FoVqGSlPi4+h7WezuJV6ByWy3sXQ1q0GC0TZphWqomRzhRvqbs
         0rYjhug2LWjPxffu0e2ZesSep+h6BS40tXTLJlt/bYidR7gF92/r7sV0UpfRkrMvceAM
         HKYFFpLYusXL2lFP8Hh0ayUmeRq1kuEmYrYEjnW8SWTmC4jISQltLgJi6PCHWwWjFQxG
         k54XiDYRmzVGumk0yNS9Gjdy5NA8l3JSvN1SbL278+FmncFyih2UA9OCSCo5U6C6eN2V
         1iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715048515; x=1715653315;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9nQW54+C4h+PA/o2ubGIoYRcvWs5DAna49ifrACI4Og=;
        b=A2H7207eOGy0L0YIaThjBWMICFKzAkeMdpYaYhz3lP84b03Q8Z/XluhnfPSDuWL87Z
         DIt71RJDRDK0hKuaXSEETNgsTwu68I706CkDQxaZzFCYozHdEm3EYpd+bZMjqHyTN+T4
         l6n+FDslHTeVCf34FV4ZHWNfZZmx6lsJ1G+WlnSsvf8eQaBaNRkBid4N0whAECpPZ05N
         vIRkZMQ6aA/pLcCXOzXmze4putkfRIpJTHMwRJoG1kMWhtTPRiJaTJhglNk4pqIa1tFB
         A2tyy7O1vDUMQ56IRUKa6yg3lVtDLOcidZJfAXi+VY4irZH00/kWgZaBnw/k/jBgpcSN
         NcdA==
X-Forwarded-Encrypted: i=1; AJvYcCVu53S+4/MFjDWbCBYcL7mzer5bUHxg0dhyi30uF6tTmCAyrvv01WbSJXrGWy5n7XxepIhiftzQ3Bp87n4Zb0usfs/ciEh1IYTqZ+9B
X-Gm-Message-State: AOJu0YzbwtGugTwDFEzZhP4bRQ+IhzkhFD3qBSWoGjA9lZplBEDZ6CZb
	LHj3/FUdCz0rc652Zb8quj++xSVgFO/VKpxZSH+icQhMZMYzZwQg8sUDqQ==
X-Google-Smtp-Source: AGHT+IHFo3ZLLchIeUjwzHz6K75/zOue1+PuizBlbVs7J/fqNmMuoABQbBf6Q1XZ+7EiakMy72LQQQ==
X-Received: by 2002:a17:902:eb91:b0:1ee:2a58:cb7c with SMTP id q17-20020a170902eb9100b001ee2a58cb7cmr4089540plg.35.1715048515075;
        Mon, 06 May 2024 19:21:55 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b001ed3702f786sm7451882pla.169.2024.05.06.19.21.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2024 19:21:54 -0700 (PDT)
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
In-Reply-To: <20240507021714.29689-1-zhangwarden@gmail.com>
Date: Tue, 7 May 2024 10:21:40 +0800
Cc: live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0E399FCD-396E-448B-A974-6034F4CF2B53@gmail.com>
References: <20240507021714.29689-1-zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
 mbenes@suse.cz,
 jikos@kernel.org,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)



>=20
> transition state. With this marcos renamed, comments are not=20
> necessary at this point.
>=20
Sorry for my careless, the comment still remains in the code. However, =
comment in the code do no harms here. Maybe it can be kept.


