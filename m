Return-Path: <live-patching+bounces-305-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD9F8D62CD
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 15:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21BA21F21376
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 13:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7033156F42;
	Fri, 31 May 2024 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="immgQWah"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFFB76026;
	Fri, 31 May 2024 13:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717161579; cv=none; b=mGbyFAxDZLrhMVv/UYdluRkXZialWhs8RAlOEjFD8AN68EfugnZC0Y6y5Gvj+E1Um5Y/DlgfQnOC4h5g391ahseR1bgRz9wzZXiRB3iWrJ2E44/QSiCe4Em0UCqOO4C/L7sL1sep3cTGvluou5EcT1EtIZKF6HssDeSc7TeXO88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717161579; c=relaxed/simple;
	bh=Ln1OISLqzkvO7q4pgAQ2+OO9D+pHbnIJhNJj2chbtyU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mmK6jNlp0sWNwkIVHjI+AvHv0EOBuUvK0laHi+1nU7ZbGM3+tmNNow+ztozuW4iqfjhfA9LRbPkrvYyzREaTYCYUNU/NbSjngIB8Vd1naeTtuKC4C5im1Lz9T7bDNSAvK5bVo1A5dCbKWWrNHr17luxhQx2n4BBsrYrdxfOAb7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=immgQWah; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70222db9bf1so1893851b3a.0;
        Fri, 31 May 2024 06:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717161578; x=1717766378; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ln1OISLqzkvO7q4pgAQ2+OO9D+pHbnIJhNJj2chbtyU=;
        b=immgQWah79AR5HS9UBeRhCJu9elongZrg9h+38ruhUpqIJErGkaHRNi+O+0Ug0wVqh
         UPVLLbzj8IaYn562eEfEsXKzWBX0X0+Gm2+c658o58Qekr+44/nzLZnfMPA/4EUa0s7Y
         3JsPB7Pcb3NQX1JfLPlbRHFpWbBTaQMbt4ab4y6mhbN1fVLykb5gTRNMYUdjYEt69zIl
         lNsVQVETvSu55iKDWNOqqcqZm5XrXMrb6ksYAudtQaV5wllsYEqBzpK7nTnRUucoAN+J
         nvlhBJPfMuzqvHlAByAPmKk6O3YaYByv9/yONPs4LHO/NKmpyvehE5nuN4lhG7KZRHa+
         t1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717161578; x=1717766378;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ln1OISLqzkvO7q4pgAQ2+OO9D+pHbnIJhNJj2chbtyU=;
        b=m1EQwv8hias3zC9PIbeeJIfTT/3ZPXqW7FAaoHQMRwUqwkYIz47jnuxYy+7GiN1hT0
         ii3ea0N87eelkssGi42X5APyVP6of9dn4CE9yv5t2QVGC7Zw3m2zLEaM1ma6kzEnNbmk
         Cr/7kfK7p+6mrL0IZDmQXASXLvHpwGt5xVLYii+uIv7O44j2sQgDU3jlDqnKDCutIDap
         mIAPtHzPRqJRQWvY3dHlzB3sDXWzHxp2+SRv9vIqs7nD7lnHMYSssBnvePvQbWWZ0atC
         /UV8vUYI7Q0jRYEOze/8J4HfSArmkM5bNOw09lUI5Jlgk7Q/qy8y93bpiB30bDNeOCag
         FgVg==
X-Forwarded-Encrypted: i=1; AJvYcCU85QHs5m7JVkx701L5/O2yj1Gnqkr/M9cildZljt+47RMzrzVvcrI9VWG+Tmbqmrcu3xkiDvr2M+CxWw7GM+YvuUckdYVQ4SKa/9QGyQdHAbDKdsyRC1/CiJeBXwM4OPSMS1B4Ngp+jXSXTw==
X-Gm-Message-State: AOJu0Yx07rE4nU0KLUUbnsy4z/nUpTNbo3dADh1u/DMNo59utFb6e6JA
	dDKD134WCZhqlOrs50K9DIsQUiRwuoaZnRWU/DvP96MgBGMcMkFS
X-Google-Smtp-Source: AGHT+IGIUPQutMPK8751Pkw4pehwlkHYrXG9G2ipMmwaUCfNcuk+EJ/77EGFhhPURAQtpTtqJuDVfg==
X-Received: by 2002:a05:6a20:6a21:b0:1b2:10b6:4a10 with SMTP id adf61e73a8af0-1b26f11be3dmr2531598637.21.1717161577586;
        Fri, 31 May 2024 06:19:37 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702425e0aeesm1354141b3a.87.2024.05.31.06.19.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2024 06:19:37 -0700 (PDT)
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
In-Reply-To: <alpine.LSU.2.21.2405310918430.8344@pobox.suse.cz>
Date: Fri, 31 May 2024 21:19:19 +0800
Cc: Petr Mladek <pmladek@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF8C167F-1B6C-4E7D-81A0-CB34E082ACA5@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <2551BBD9-735E-4D1E-B1AE-F5A3F0C38815@gmail.com>
 <alpine.LSU.2.21.2405310918430.8344@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On May 31, 2024, at 15:21, Miroslav Benes <mbenes@suse.cz> wrote:
>=20
> Hi,
>=20
> On Fri, 31 May 2024, zhang warden wrote:
>=20
> you have not replied to my questions/feedback yet.
>=20
> Also, I do not think that unlikely changes anything here. It is a =
simple=20
> branch after all.
>=20
> Miroslav
Hi Miroslav,

Sorry for my carelessness. I apologise for my ignorance.

> Second, livepatch is=20
> already use ftrace for functional replacement, I don=E2=80=99t think =
it is a=20
> good choice of using kernel tracing tool to trace a patched function.

I admit that ftrace can use for tracing the new patched function. But =
for some cases, user who what to know the state of this function can =
easily cat the 'called' interface.

It is more convenient than using ftrace to trace the state.

And for the unlikely branch, isn=E2=80=99t the complier will compile =
this branch into a cold branch that will do no harm to the function =
performance?

Regards,
Wardenjohn



