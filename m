Return-Path: <live-patching+bounces-441-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F2E949460
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 17:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6830E1F2591F
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 15:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976BA17BD9;
	Tue,  6 Aug 2024 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RA1988Mg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C98812E75;
	Tue,  6 Aug 2024 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722957691; cv=none; b=Jnif444sZmlDwQb27p/A80CKGS39otoBytJlS4eJi7wPVVrrwGeoyPXECFVC8GADEdJmqjhYqmRe5wjgSCcnHEXtyN049dZJhvNKTc4IqVXbL3w5cxPb5vzqicsLI9R+c20KazlYxeUcux4jffUNiQCypjNJ1gAKwBfyeM1yq6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722957691; c=relaxed/simple;
	bh=yXypt64uF0w/ShLxbdnq16PrfyJcpZl0iWSpKlVTEjw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=FvuMf1Ef8JCPNPGvGLAMd6SbLMzkTMn4kWrvLNsDyO5h+q4XA3O4tQQXyuPVzh6I0MgFVXvaHMdEaVUhX6Ed57W1xhIeVdoOZS9FWc+Cn9YIFBW4F/nitPg9f43uQZ1Ue17U1QvfKGBq20AuyarQX6X6ESfYtFj0VL5iP1pMKM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RA1988Mg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc5549788eso6429945ad.1;
        Tue, 06 Aug 2024 08:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722957689; x=1723562489; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3oTpRyrb3abk0ueTizPKWSn8WwNP0gHjkntdPT2laM=;
        b=RA1988Mg6FGNI0yMquN5YPKFqyxdP2vnu5KwJSRaEID5jxalXIGlncHA44yizzOk+O
         vuiAU83iFBm4cQzlQDk63R89e+IOx0O4lHUCsdov1MuZLQIv8wBx3BxtyRWtVHqUy9E5
         k5Db+gLxO+bYw5ONAXez8R6KRacGSfnqtnxq3e7hfgX/4GOvqzlRP3ZYruSGvlp1zoPO
         k2/MMAeOcPbB8z7BPWM7hJ4l0KINRusImTjz91IOpZwuegnzirwXzPZ/LOFHKwhaXQY2
         4AkGmIpNGr0E/rZ8z5hpdih73mq03Bde6080zZY//rbkOXUnFIfXinbfSMC5mYT2Vqmj
         yUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722957689; x=1723562489;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L3oTpRyrb3abk0ueTizPKWSn8WwNP0gHjkntdPT2laM=;
        b=N4+44DyIzq5+eIZ+4HnC52pJ5iNTAEjdGCL3IcrhU2273KawwQB7uA7eBcQe4CqN/r
         DaWCx9VwmI+7lUaN7R5CPwj2v8QVwDGZSNDdvP617XOdmwm1uSuF4F+RJMYZAjyJK1f8
         qElKJ0dFjtrv6VMThSPAK7QD9wUtKQN9cLjwKlTHq0XPlW3h693ErKV77CxxBCHS5c4P
         2Vxgo6Fa2XYXzA+3eds/V1kuf+OkdyW9rA2kdZq2qPDdTyPkuvUYjD0fA7AOHRXsZ2vE
         8OKE1L4t+hY7ls56JIdP2hULZA7AUfUX/v7t6dcYILSoqAJmCpqvMnTFY4zlj+Pitfyb
         55SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBXiuBRKMstxSZ70d4uI34e29wfLcrFvQyAzuN7K+mQMbwsBlyB1nLSHFYk5GXpfVp7ib2Ip8Mzkge2UB6Inxr8iWH2F/HtF84BDf7
X-Gm-Message-State: AOJu0YyeW14yjDHxwehmoPEdg9X43RL2NzPzaBu1B2od1fx+WE+u0e7O
	hosfA6d1nIQTnVhzPrAOM1iy7O+q2+lF6hBQGTPQ33Yn0jSbNzpoqJx1dA==
X-Google-Smtp-Source: AGHT+IEGxh6kPnY9wC4MAD9+3SC4BQ0LGo7bdy72buLv3bKeuSvvBJPxTtj7eAqkku941gB4DGSUjA==
X-Received: by 2002:a17:903:1245:b0:1fb:3ce5:122d with SMTP id d9443c01a7336-1ff573bfe4amr217689025ad.41.1722957689376;
        Tue, 06 Aug 2024 08:21:29 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2007728d837sm17172925ad.84.2024.08.06.08.21.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2024 08:21:28 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 1/1] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
Date: Tue, 6 Aug 2024 23:21:13 +0800
Cc: live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <81AC0E7E-24D8-4768-B1A2-CD3688C1525D@gmail.com>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
 <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 5, 2024, at 14:46, zhangyongde.zyd <zhangwarden@gmail.com> =
wrote:
>=20
> From: Wardenjohn <zhangwarden@gmail.com>
>=20
>=20
> static void klp_init_func_early(struct klp_object *obj,
> struct klp_func *func)
> {
> + func->using =3D false;
> kobject_init(&func->kobj, &klp_ktype_func);
> list_add_tail(&func->node, &obj->func_list);
> }

I reviewed my mail again and found some typos and point them out first.

func->using =3D false
is a remaining mistake by the previous patch which will remove in the =
next patch.

>=20
> + *=20
> + * When this patch is in transition, all functions of this patch will
> + * set to be unknown
> */
This comment is left and become useless, it will be removed	in the =
next patch.

Thanks!
Wardenjohn.=

