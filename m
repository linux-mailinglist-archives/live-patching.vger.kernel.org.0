Return-Path: <live-patching+bounces-347-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4882C902E49
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 04:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFD14283B5B
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 02:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517DA15A870;
	Tue, 11 Jun 2024 02:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAoUD8Cf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE3159917;
	Tue, 11 Jun 2024 02:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718072618; cv=none; b=gJQrcPA82BWyopG61GTny+jzhowlHHoB9tB2JaWU9rBcWaNP5D2HdnrcuEqeCn1I8opikPYFoHEnKSUgruTjStUsSW3pB9cQWEDisLbAN2tRnZ1OppPYQ3SWKWW0NLjRyTawl7kTKhN6V8XvfPI7okjUg8zvG9y59Zoy/ggZObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718072618; c=relaxed/simple;
	bh=qVtYDYysCAldC4l1dqMdXwdZ4JRo0kfnmWGAVwyLSnk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Cbu1FySLAWuGBPA5kDMbHo0xTE92+ZLTpAFX8ka26XdN23ry10ubE0bhKg9VDrCt8HNB4Kz/9NTqN3JJL4EZnGPbm822gMOuAogRgAX9/srKfPzYlor4YmX0lKq6MrErJdXpLbrhaqLuur30bAGyPAyWhz4K9anQ9PcMEKewCU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EAoUD8Cf; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6f977acff19so1394090a34.3;
        Mon, 10 Jun 2024 19:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718072616; x=1718677416; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVtYDYysCAldC4l1dqMdXwdZ4JRo0kfnmWGAVwyLSnk=;
        b=EAoUD8CfUOAKTpUbcwvC4gtmIqr40bwgIrzgJs5BYPi5fOSYr1mQOU4jXmsZ6AHOTI
         4wir2NyHTgWKH3ZaeNHeMoOEvBHZd4iKEKLAnkQ6j4CnPNiPfQAPAuBCZOcgPX5GsG+L
         y3osQ9FITFRJ2FNdsCMP/I8dDvWxQoWcNg/0Guwg2uP1DdLh7Wptqyxvj/4h6TFEerAa
         NdNvtoELaVTFoIEXpKQL0UAL8+Kfc6bHT3GXTiSUupoEzb+Ug4zW2sw5eS+7ez7vqLhz
         SFKu1nRtvwpLbUaUeQUi56qVSRpcDHmHI9fn/CIdYCXyC0jPBiXRC38zAX9wai4/x6R7
         RiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718072616; x=1718677416;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qVtYDYysCAldC4l1dqMdXwdZ4JRo0kfnmWGAVwyLSnk=;
        b=PDjddSzfdbQZVTwVaiPoVeDLxYRB9y2DZ8hdYOcBpXlwfIZeY4tG5jmQ7vp8uR4Q2H
         DhxcELS/sKu/WJYM4VYznZf/YP5vZbv8o29F2aGGS+oXT63jEHkU6W1QUawGnXre2IyQ
         Ya4d2xtqNU6nMJTRS+VPrTcpHlnqThtOy59SsJ9lmJTTGBnvjMirIRA6/4JERgon+/Bh
         4H+HJSp8ieZKF1VJmtRLNQltKh1zlx5n2BOzuXaUIetSnQgNROH7hjyPeNQWScvXMJxh
         LbrlETAfhU5h+fGTstzgderG9BvTpgT9iJS8E9dTYPh4RJarS+nwCoy0TNvTn4bn/kvs
         6ZTw==
X-Forwarded-Encrypted: i=1; AJvYcCVaM43okpTFvqvPzdC7866GOg/gjMaAjPZXN+sa9rbKBQwS90vnu2EK3bHAIAzGU+WOjejQ09ANy2inqe8w8oCUy3FsEfdTFdDQ4gTQrOXA9ATobrMMQkL50PIO+uAPd0CXAiQ9wyXNntOS6w==
X-Gm-Message-State: AOJu0YzsLE5V8qsA/b4XEh7jPH+sJHib2FJIQu21yrVA/9hLnd8cccL9
	PSgAm4MMeXjrrXg+ji+9VvVT7qe36b0KSlbWskFCgWAxGMXOO+qV
X-Google-Smtp-Source: AGHT+IEPof0PitngtHu0sy+Xa4LZLAEKg2xIrrOE2oK4VzBuKdwgoDX4qR/YGc7NINeioI6Q4OXglA==
X-Received: by 2002:a9d:7d0c:0:b0:6f9:b3e0:56db with SMTP id 46e09a7af769-6f9b3e05bdcmr4669859a34.31.1718072615762;
        Mon, 10 Jun 2024 19:23:35 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6e668a494c4sm3977259a12.22.2024.06.10.19.23.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2024 19:23:34 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <CAPhsuW4MZ7-UopzbsqhEGzH8FLTK_rTOd05heGOQXm+H7a4a0A@mail.gmail.com>
Date: Tue, 11 Jun 2024 10:23:19 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0560A816-843A-4FCD-B4E6-D2B1085298CF@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
 <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz>
 <CAPhsuW4MZ7-UopzbsqhEGzH8FLTK_rTOd05heGOQXm+H7a4a0A@mail.gmail.com>
To: Song Liu <song@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> We don't have very urgent use for this. As we discussed, various =
tracing
> tools are sufficient in most cases. I brought this up in the context =
of the
> "called" entry: if we are really adding a new entry, let's do =
"counter"
> instead of "called".
>=20
> Thanks,
> Song

Hi, Song

I hope to find a way to optimize "called" will be set once in =
klp_ftrace_ops function because as Petr said this function should be as =
fast as possible. But if use "count", this variable will be called every =
time klp_ftrace_ops run.

Regards,
Wardenjohn=

