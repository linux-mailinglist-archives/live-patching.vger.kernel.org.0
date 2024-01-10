Return-Path: <live-patching+bounces-125-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6A58299DC
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 12:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63EEA1F24696
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 11:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5462481C6;
	Wed, 10 Jan 2024 11:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gdl71Hfl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6028847A74
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 11:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cd1ca52f31so44793271fa.3
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 03:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704887577; x=1705492377; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ascI3xEuxrf+bAlJwJVPOceO1Ba41fBXLhKR9/Lb0M=;
        b=Gdl71Hflbb407enSn4alWalPSH5SsIQ0ZHIaaZe8D0u71yhZnbDkHrWE+PUL1owm2o
         cjfTmFw9+XXgEYlcYdoe/eP7WCse1jBOeXk2BX7AHPycWdfljlKpqiHriUdQEEwDuXYT
         y1MqCMy4HQakc+VpEdEXQ8dfGjKp09AQ+euLWSO+0igJ/4U7B/PHcvpYkklV1TMb4A9w
         dn1bQcUSi6JCGyxU/EDFWdoeIvRRDoENvqEzFDQfTQGuxXBft8jnwBZ0x7wiPqA1FiL3
         HCkUilfuJg1vb7HR+AOtbsegGL9siSg9G6L/1ZfhAqVc68x4qzjwKINFfdfu3Noz4y9P
         XB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704887577; x=1705492377;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8ascI3xEuxrf+bAlJwJVPOceO1Ba41fBXLhKR9/Lb0M=;
        b=NGrwkAv1CCfXxQr9Yy0SD8gaqucZwfsG+YADbqSJ+5IvCCEirRGQE4E87nJWJlhah4
         i40SRzrhFhKMBidqjfuipC4kg1TdgUx1A05gbaETxDYrjmzijtsURNCKYGYTzRvHL8wQ
         jn/Dx9Wc7AZk1p92e5+S7vTmOBXI6e5aGwfAI8GE78GhIw6pf1nU1jpvnR1bKahRC8fk
         fCfqcH1AEyvGy4WDaraMIyEEvahi5rzPrUu+qYl9FihnozoCCs34JB5Egivu64Co97lV
         e/mtvngD96RH4GKMPVveqPtJ2cRJJHrl4RgAY7L0kQS0IxcmLIInT/Fm7HYSx5vrtt0+
         8RuQ==
X-Gm-Message-State: AOJu0YxvUgyYTiFkW+/4TQMa+cVVJzuYL0kXjuXG8hl7Zpa92+PkRkyz
	7EPwJyv0svdYRYEPyWSveJxE+GhG2AUZFXi4IvemR3UgFpM=
X-Google-Smtp-Source: AGHT+IFjRjXihoh86m+G3Yr5b8NvPJZa3SwH4ZNapMKpUeHWqNjgYy7MBcO323nu05pBRl0uC1fM4g==
X-Received: by 2002:a2e:9bc5:0:b0:2cc:77b0:7655 with SMTP id w5-20020a2e9bc5000000b002cc77b07655mr490080ljj.8.1704887577374;
        Wed, 10 Jan 2024 03:52:57 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d81d2000000b007befc059cf2sm102410iol.6.2024.01.10.03.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 03:52:56 -0800 (PST)
Message-ID: <761e2fc21e72576a4704572b50d9fc5b4a1cb9e1.camel@suse.com>
Subject: Re: RFC: another way to make livepatch
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: laokz <laokz@foxmail.com>, live-patching@vger.kernel.org
Date: Wed, 10 Jan 2024 08:52:49 -0300
In-Reply-To: <tencent_8B36A9FCE07A8CA645DC6F3C3F039C52E407@qq.com>
References: <tencent_8B36A9FCE07A8CA645DC6F3C3F039C52E407@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2023-12-21 at 22:06 +0800, laokz wrote:
> Hi,
>=20
> Is it off-topic talking about livepatch making tool? I tried another
> way and
> want to get your expert opinion if there any fatal pitfall.

I don't think it's out of scope, but what exactly you mean by "another
way to make livepatch"? You would like to know about different
approaches like source-based livepatch compared to kpatch, or you mean
something different?

Thanks!

>=20
> Thanks.
>=20
> laokz
>=20
>=20


