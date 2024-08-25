Return-Path: <live-patching+bounces-514-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BA395E3F4
	for <lists+live-patching@lfdr.de>; Sun, 25 Aug 2024 16:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A1FE1F21516
	for <lists+live-patching@lfdr.de>; Sun, 25 Aug 2024 14:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9500313D28F;
	Sun, 25 Aug 2024 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/r+oMYP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D34320C;
	Sun, 25 Aug 2024 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724596643; cv=none; b=Qg91pExtvxIs8D5j+soPEEcmXdTGXSSWPHEM3QNYvzON/VR7hGo97CtCF+JIukGd00MNqUCOYE+AaabZxwHd3lA3cvDVUVahjhQZc0rJPz6X1kmLbR4uKIxMJK+Ltrf0lw9CM76EQmzHBc9Mdq29fXHOAOhqe5JqkYZrPBwBLRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724596643; c=relaxed/simple;
	bh=bcfaR3Ia1v0cVAj3dSnAjPImEKQQqoPr3BJzACBaPEE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lHU1k6Efteo76V884V36Sc9urYsa6sI4AHptC8CG3C1azGYplbb38ybDFbzQn1zOLAoJMzdFW0b7HmZdXB6LD7hDFxbRp6Cb3unf2tS4sJEyH3/ufk6pc3ylnzh811B/dTo3AHcEYuOC38vaRsSH5u7B2G5PrzZ3a69UnNdXaTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/r+oMYP; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7141e20e31cso2955252b3a.3;
        Sun, 25 Aug 2024 07:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724596641; x=1725201441; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcfaR3Ia1v0cVAj3dSnAjPImEKQQqoPr3BJzACBaPEE=;
        b=k/r+oMYPtIx6lLytcnKgBkWJIZ4q21IdtmF8DHmSBckw3tQxeTLEnpm9sSi7smY/eQ
         Bkz8pFRnvH4TNltpO6IqeLZ7amj/a3CbBn2OWXLGZGwuxyRjVr+ixnIkilke3OhvaVBJ
         LMGOf2VKShLNsUZkZ56nEwVEYbLanDegYfZF2CtEK2ik8CXVCJleahNwMCZusYmg1o1I
         HGUec7s+liakF6IL9e4ANXGLlvWm8hgGU34vHD7AQtjXXgYTRtLBJHIb4RjTxqIw6fAW
         WcClWsMP1/jvhJ8BwATV/CRNMs4/ESEOy9RbOYjJsfnnydQxgXSK5JS4IOT1iDJ4o4EC
         glOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724596641; x=1725201441;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcfaR3Ia1v0cVAj3dSnAjPImEKQQqoPr3BJzACBaPEE=;
        b=wUKUc9Sj9llV0/BiVgcIZ5McDBPZt26LVT4bxfo4XRbCY4+3V2ltUasBl72+3wETBi
         hXk22MPx6I/L8SfXx6/QjsudDLzHzPIoCLgQhdORFQMzM93JHlOWVTzmlIWGGm+LjWpF
         xDvpGtlXAUklg+ky1nYLgVhHmY3enI3szCix4DcYKb39rYBiq8j9bXI1vbjhBQwcZwax
         fy0YI6pHU9FXY1dRolPgJmYZw++2MtG/L4zzizcQ8hPncs5qh/UA/kMZWAOKNveVf1mo
         JCYF61dRkqMUJNCN8Ts1vebsqlZB4S3BG3rkgEixQ12d80LPG7hhF0bS3LpWsuiUB0p8
         uKUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzFQhGxyKyTnOvcyd328lGtCGa6HfhTi6bB10jEPrNEvr2uRq3ygFC69DJ4e8pTCFltZWhQ2NS5825jMU=@vger.kernel.org, AJvYcCXI68etcCQ2fg9Xdt9Gee1//V78jx8I1K209FoB5sLFelaKAySCWqJPPRaW4abFDwZkP1qX5COo+OqD0KrgAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx/J5LWQc9GscishpLdx1TYuywfUPA93sdB9id7XybZ+1sca7h
	XgLjBNltzW7C22/ngZOUXeVnSI+h8j38r/aM2m4HUsQj0Pq8PfsQNvxiKYaP
X-Google-Smtp-Source: AGHT+IFS+ySC2coJy5JKTZjUkeP2oRrQFN0FNlB40rsrFpCEc96bMq8SbqFX/PXvwq9BTdn11fIebg==
X-Received: by 2002:a05:6a20:d504:b0:1ca:dcae:a798 with SMTP id adf61e73a8af0-1cc89d19911mr10561045637.9.1724596641450;
        Sun, 25 Aug 2024 07:37:21 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d6136fd98esm7900754a91.3.2024.08.25.07.37.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2024 07:37:21 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v3 1/2] Introduce klp_ops into klp_func structure
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Zsq3g4HE4LWcHHDb@infradead.org>
Date: Sun, 25 Aug 2024 22:37:06 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 jikos@kernel.org,
 pmladek@suse.com,
 joe.lawrence@redhat.com,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C3B45B71-C7D1-45EB-B749-39514A49C521@gmail.com>
References: <20240822030159.96035-1-zhangwarden@gmail.com>
 <20240822030159.96035-2-zhangwarden@gmail.com>
 <Zsq3g4HE4LWcHHDb@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 25, 2024, at 12:48, Christoph Hellwig <hch@infradead.org> =
wrote:
>=20
> On Thu, Aug 22, 2024 at 11:01:58AM +0800, Wardenjohn wrote:
>> 1. Move klp_ops into klp_func structure.
>> Rewrite the logic of klp_find_ops and
>> other logic to get klp_ops of a function.
>>=20
>> 2. Move definition of struct klp_ops into
>> include/linux/livepatch.h
>=20
> Why?
>=20

Hi, Christoph.

When introducing feature of "using", we should handle the klp_ops check.
In order to get klp_ops from transition, we may have more complex logic =
for=20
checking.

If we move klp_ops into klp_func. We can remove the global list head of =
klp_ops.
What's more, there are some code in livepatch should get function's ops.
With this feature, we don't need the original search to the one ops.
It can be simple and straightforward.

Regards,
Wardenjohn=

