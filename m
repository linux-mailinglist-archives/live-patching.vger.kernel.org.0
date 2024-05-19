Return-Path: <live-patching+bounces-275-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7DF8C9766
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 01:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 794D71F210EE
	for <lists+live-patching@lfdr.de>; Sun, 19 May 2024 23:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830EF73182;
	Sun, 19 May 2024 23:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEq1SIwD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C584335C7;
	Sun, 19 May 2024 23:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716162146; cv=none; b=mjgppmhooG63hjfxLtowfM76HpZonwAj5AMg6DbY5RMekIfqJ0ETzE+lu2I2r+xMq44+oQsVeMXXH57f7gLuGh1PbtAj7FIIyV+tnrkUbjhAGbp35fBP4+Oq97euwt6ZDczOwIZbWz1VbWBzd4dRtujVFn6QoCo6M7ZnjRtlMy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716162146; c=relaxed/simple;
	bh=MRLtAIxUxdbSkN7sNm3p+9MsecTxswlihueoor4HZEo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QJeYKgGhxkXUUkV1Ju6oPi8HetYsVKX+cErsd+8C6BtmJH8czrHUbnUm9MC7oQ4YaJSCD6EchfL0kO5HnArSIzE3HXMJ8QdMfPgI+thw9Ev+MyowIYd2Ex16CBRMgiKVD0fxw/wdNtHd7X11b4NMiIsrTdzWBx1gzpjOhIo2ZKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lEq1SIwD; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ecd3867556so60783795ad.0;
        Sun, 19 May 2024 16:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716162144; x=1716766944; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLRcrBmm/JNzbHllRISeYqb+Gjt9Xm96VzYCUAqr+4o=;
        b=lEq1SIwDxswVwnNlP3VynCvstaJ1tUtMXbdjE+C0UUyVdil1aiPDkHtJZI0dHbbA9X
         pcoHUm6TtrqviIS6TUS5eAdD9v0kEpllNkPuN3OuN1/VUjaK/18kLUnq5hf0QUVbxHTU
         WnmkOi1FLcK/JFbtHdqMo5DV1XXIM063GAohafF521TAWmd2slt6uoItnPNNQD4TvYIq
         rGYpuf5g3csACPb6jMsDdMBUbEZ/chBztFlcvvk859yB7T4qwKE5T2evTD51LqK5C1VS
         P/mUyyONE/YWN0kx+ISPGUbb/ZI/Bj7JnjgwSOTqw7dgG4a2+HFtzyYGXt+OMrel0sZo
         IwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716162144; x=1716766944;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLRcrBmm/JNzbHllRISeYqb+Gjt9Xm96VzYCUAqr+4o=;
        b=HeaQVsiX5IFO6Lm7Y4IiyX7ljJwFl1/B7tSOWo/YA2M2JXltHFHmZdinzIoUv3GMaA
         RarCWpPC93/qAxF6rBODUwTMJQtVXPFqp/TEi26UzNRqVO+7bZe758vRoMaItTMAVNtc
         /fw4CScCTGY+4bHyGJFVG56QKb5hbSXzZWoaA4jP2TVFT2jn2OMCpjVUU65K6FErs3UY
         7r+nd8q1qhE0EY6CiT1W+ntxRa5w4MdKqJ96U5+lKTT/9xNJ+SkWvz9A2UiP6ycyuwtQ
         5ihvq75GFRR3YwDhq/KfbFIgUwLnwvMMDuqaWA91LitQOH7xu+oR1sk0yLJK/hg7Nfp6
         j28Q==
X-Forwarded-Encrypted: i=1; AJvYcCVoU2mkaBNtTYxkSSnbZxlepXr0G+5jQdAFYAnBuAkXn74CbZvWY8ec7XLvU7of43+To+i2+RuQmc5kH+E6AUxGedG/PtzhHNN4oS4D2zRsIQKXNA/nYdileX0/FPJb3MS0uJNRZ330oGSqvhh+
X-Gm-Message-State: AOJu0Yw2v/M3Jnl1NpbOBtR73BeWF6kYsmC17amVO2hrHPr793fw7yHK
	/iDFWSVy6Qu3sV3wlkF58sPHeC/fO0iKshGdeqo0cDqP36MI9hlU/3FVQ+sDdYw=
X-Google-Smtp-Source: AGHT+IEKF2ZABsZ3AtRKDb6oyc/rsvkCjgo/aLmta88PM2JCfnw03GunJZVajzG8z8yH5bZzaoc5ag==
X-Received: by 2002:a05:6a00:2289:b0:6e5:43b5:953b with SMTP id d2e1a72fcca58-6f4e02ad963mr29305301b3a.14.1716162144322;
        Sun, 19 May 2024 16:42:24 -0700 (PDT)
Received: from smtpclient.apple ([59.37.8.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2af2a77sm18675298b3a.144.2024.05.19.16.42.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2024 16:42:23 -0700 (PDT)
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
In-Reply-To: <0f78a187-5c64-4d95-a6e8-2b5c42f0c253@web.de>
Date: Mon, 20 May 2024 07:42:07 +0800
Cc: live-patching@vger.kernel.org,
 kernel-janitors@vger.kernel.org,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7DCD3D59-461E-4898-BDAA-FD40D168C243@gmail.com>
References: <20240519074343.5833-1-zhangwarden@gmail.com>
 <0f78a187-5c64-4d95-a6e8-2b5c42f0c253@web.de>
To: Markus Elfring <Markus.Elfring@web.de>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

OK, I will optimize my patch=E2=80=99s changelog in my next patch.

> On May 20, 2024, at 02:05, Markus Elfring <Markus.Elfring@web.de> =
wrote:
>=20
>  I suggest to take preferred line lengths better into account
>  also for such a change description.



