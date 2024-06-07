Return-Path: <live-patching+bounces-329-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 215418FF9ED
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 04:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5B971F23F16
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 02:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C88ADDD9;
	Fri,  7 Jun 2024 02:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Afh4I9jx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DCCDDAB;
	Fri,  7 Jun 2024 02:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717727228; cv=none; b=TkUt855CLqE9VlUY2tu5C0AztTII1O+85skTsnrjAhPyjiakQCb3fv4N+T20sfTbgzzYespMnuTEhonqS6kYu4sZPTEGS+vrVK5KqrIkU9o7n+TFoRqVlsYLp30OqhcUuA85ukHkSOoOKIcAogFMxEXhyMKLcrQJhrkUm6rN/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717727228; c=relaxed/simple;
	bh=FMviLWiM9TAuVnien3DOdHoozNOjUgtoS3TQejc5Dsw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=k5nr7x2rxRijUoCqP5lW4LJe4qlqfeXWQz1qylb5QRdLss71XpbRN36dd/+PGXHithYolzXGyu+E4xuhw0IX6Oo2yVunwUy+hVDZyWZxkJlf74MQvpmE3iqlzQWczxlVgcMERxdHdvD18xquU/1AH6BrQetcSO/GQM4UPryfqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Afh4I9jx; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c2bab8d69cso439431a91.0;
        Thu, 06 Jun 2024 19:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717727226; x=1718332026; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PRTAWrhjr+QRdN9ZBsFIxqJeIplqLVctoeE5yPLMKA=;
        b=Afh4I9jxNnEqCbp47P43mQ+JCNYok5cqTNlxHnNHDyXqlwPBd2kEtaXdUga+uec8Xd
         fibr1kBL05LK6jgDb8FNWM3blQt0nq0NhoSmxmwvvpvDKUp93OVSB415hPnMwYVeDPSt
         NJ2k3HqLbP02cDCZefoHCZzFNiQozGD1lXT8a25+SEOd0YPb7EOnYTZUhs7g5nnyfgw7
         7eww/nrIBr2kdVBDsUvSxgeW6NLD/CH/KhCYmAUA+5vWD6XZ6OX+P+Hsu1hK5nihgjB3
         /qUUI4HThCVJym1vD0+ZeUfI6KETAvvjX6aqOxrdxKqlGFAcQZM3dihkBbdBOH1LcFdY
         mWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717727226; x=1718332026;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PRTAWrhjr+QRdN9ZBsFIxqJeIplqLVctoeE5yPLMKA=;
        b=bN7msbrloLvjg8kU9cfuH/ft+H5mHBigtw3k3MoD5+ZtYf+7ex79gIxuTq1//x66t9
         OlKlcoj32c9bSrXwgKF+mCNXVQiM4JpxT/bmqG5JdANQXSizfZnxuuv0hxSgcHY07LZK
         p+cjt1O6HD9/Fyc+e4qumie8fiX9YD5j/Iuthw4ZcYgwOTlgUteqhRcCRbwipV9Hcvqh
         v3h2zxfBRMqovGyG1Be1BoVoNuMMqIF748pVlI9tmRTvdArT8yoTi5lM9QxYN7pDpcn3
         1CPCnXBEp33bwzuULmGPNobdQQjvuKfz8PLeaUk7SKU7GTQ5+ZhxI9OT2aLME8l/1OFi
         SZHg==
X-Forwarded-Encrypted: i=1; AJvYcCX2Z35T48VVDMe7wSQpP+VjM3I2DyBQUxh87evjX5FF3DAx9VW/S9yfKgnMTZyXPC8yiCpWAQd/x6fuPf9GrPpBaWEUIbB/BLFHS3ibz+lkRYhXo/qJ54h/0PKCGAlt8KbRVz8HGS0ODqjovQ==
X-Gm-Message-State: AOJu0YxUrAMyfADdOm7BbRLjmsID1bC2Wtcty5g36/ZGQtftqv3wSpen
	fyaXQq8Ed6TuS1B+dCnftqMsyTCDsFKu3TZVVIOF5llNIiWIrBxH
X-Google-Smtp-Source: AGHT+IFrzSv1SVs70dIStUa/t69Z7VUyPkuWZwNdij5/ygL0LC3+cC6DXCNw5z9wTu9xTAXSiKO42Q==
X-Received: by 2002:a17:90a:1157:b0:2c1:9e9e:a751 with SMTP id 98e67ed59e1d1-2c2bcc0b514mr1242592a91.22.1717727225818;
        Thu, 06 Jun 2024 19:27:05 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2806398afsm4344667a91.1.2024.06.06.19.27.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2024 19:27:05 -0700 (PDT)
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
In-Reply-To: <930d7361-64e9-a0fc-eb04-79d9bf9267fa@redhat.com>
Date: Fri, 7 Jun 2024 10:26:49 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E4079557-7518-44E3-8C43-3DB055D541A4@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <Zloh/TbRFIX6UtA+@redhat.com>
 <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
 <Zl8mqq6nFlZL+6sb@redhat.com>
 <92FCCE66-8CE5-47B4-A20C-31DC16EE3DE0@gmail.com>
 <930d7361-64e9-a0fc-eb04-79d9bf9267fa@redhat.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Jun 6, 2024, at 23:01, Joe Lawrence <joe.lawrence@redhat.com> =
wrote:
>=20
> Hi Wardenjohn,
>=20
> To follow up, Red Hat kpatch QE pointed me toward this test:
>=20
> =
https://gitlab.com/redhat/centos-stream/tests/kernel/kernel-tests/-/tree/m=
ain/general/kpatch/kpatch-trace?ref_type=3Dheads
>=20
> which reports a few interesting things via systemd service and ftrace:
>=20
> - Patched functions
> - Traced functions
> - Code that was modified, but didn't run
> - Other code that ftrace saw, but is not listed in the sysfs directory
>=20
> The code looks to be built on top of the same basic ftrace commands =
that
> I sent the other day.  You may be able to reuse/copy/etc bits from the
> scripts if they are handy.
>=20
> --
> Joe
>=20

Thank you so much, you really helped me, Joe!

I will try to learn the script and make it suitable for our system.

Again, thank you, Joe!

Regards,
Wardenjohn


