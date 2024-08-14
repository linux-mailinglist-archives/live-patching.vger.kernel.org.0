Return-Path: <live-patching+bounces-492-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4FC2951CFF
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2024 16:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D98671C20E1E
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2024 14:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C8C1B32B1;
	Wed, 14 Aug 2024 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RstFQ6GC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8331B32BA;
	Wed, 14 Aug 2024 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723645418; cv=none; b=InrDXrLOJRwx7iBfUSYfL2O6io8rwnWJRdOJzxrta5K9ocwNsPxPysIr7i0R/C8PMkepnK9AYhLILagBdeAMJPTDJDyzymyff+dDkEO36OoaYPWtnYyhBNwKdQ73HIx3JVqS8FKZyKZPOqXESAiiNejm2FvOID1v/6kiQXwlPeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723645418; c=relaxed/simple;
	bh=j74WdyQXVWcDrfg5XPtYj9eG6pkEqtR24h8qsuz6yMg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mdX+kxxF+W2A3veT4KuTb2ZxTKfCJoOZjbhvjGk4OVleCV8ho/C/uaft+ciUiU8AVUPdPWMOY/Lt0r6joQC4VnOdhiP5wsRsRGOCc4FiHAp20mmq6Vk1AdlPR/3qIe26SN9zrpcDeZuIavTnUjskHsNBJU3Q163U+A8KkHy1foQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RstFQ6GC; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70eae5896bcso5951175b3a.2;
        Wed, 14 Aug 2024 07:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723645417; x=1724250217; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZEwBbTOSCcz+gyRlt+RtWB3gJ5IyjKyciqGik3kfB9g=;
        b=RstFQ6GCO31rsvLrfwQAqa8V5c8NDj5d4vXVDB2r3JFXa3oxnjxl1KP1lFLT4k7d+/
         E5JPeNY0ytyE2TsYiBx5ljBVoGZlh81hBXD/IJhwMwu6N2x3vR+j4m1sCmHV1vNU3Yra
         aCwlVh2qMU6CTv6QyvLOJ9l7AIgOXzB5gchrnv5DFgVCICccIPiV75WMu9kS5t8WlTLS
         VcN2S4TaRcJ0PZGZTo685BGhv4foakIfDLouqSHEQMJ5QOeC6Ko+eI+TUbtTGjWgUrYd
         s96Getx4gNYJmcyKVzLn21Z4nZdlTksFLPECXqg38wRielRhlfFjpKjJ5pkNEQ3yBviy
         8b2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723645417; x=1724250217;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZEwBbTOSCcz+gyRlt+RtWB3gJ5IyjKyciqGik3kfB9g=;
        b=l7bSw43KelI9VUtpEWW4tDz0J/D7srQPCOq6GoIWtnvXqWAm6YBAXl0vw07CNVlOo4
         80DtQskoTTcbAhB0toAjesO+8XTo3nVm65TdEaT44sCRfjsprZKzIpBcph1/npq7XMfH
         aaDysjWsfXmscIKGyiVqI3xbscp7TkjH2rEBlLz/4Dwz4GQdJkvVEJx7A/mwlr8WD2XF
         01PGTqGiGWzdxQH3Og3soxOhu1PARh+CK5R8GpCWO+y0mkIcLSFh8xxTZlQa1B6lmiTH
         vEJcFASMIkjCk7cU7d++aSrPGozBTMLkpNEpJLMGyoV1LbYvTcvQmd8+NckdzssL0DXb
         Frmw==
X-Forwarded-Encrypted: i=1; AJvYcCVijxoupeC9Wp393PKJiefAXDZcU3L9CSEwO2TgB3VVsRvcNLchWu11s/wAQFAF6ZLhhYFUIF9eXn7m0wyFo8PpTifLcQPdkmH+xOb1hyEc2YLBtSjGEG/ia3DrdzK46hEnRFqlyLOSpRhx4g==
X-Gm-Message-State: AOJu0YwFsENN6QR6MJ/sO8S48bKb7XNl620IXbCw7ehvU32kSRvEILaN
	nlWJMyNPdvHRq8dxqCFgclE9h7fFYbW1R8OOmEsgfZ1hSjg1dV/r
X-Google-Smtp-Source: AGHT+IHKOerRTaU/O8AUqtGWUqkzMwgVb12bcqegnY6XFKcrBPfiFZ6VqdyO6G1gA0kJF5+ncgbjRw==
X-Received: by 2002:a05:6a00:2e89:b0:70d:3420:9314 with SMTP id d2e1a72fcca58-7126710dea9mr3518367b3a.12.1723645416552;
        Wed, 14 Aug 2024 07:23:36 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58aa1easm7398268b3a.53.2024.08.14.07.23.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2024 07:23:36 -0700 (PDT)
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
In-Reply-To: <ZruEPvstxgBQwN1K@pathway.suse.cz>
Date: Wed, 14 Aug 2024 22:23:21 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0BFE862C-BD2B-43D1-B926-11A48BBC8C1B@gmail.com>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
 <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
 <ZruEPvstxgBQwN1K@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 14, 2024, at 00:05, Petr Mladek <pmladek@suse.com> wrote:
>=20
> Alternative solution would be to store the pointer of struct klp_ops
> *ops into struct klp_func. Then using_show() could just check if
> the related struct klp_func in on top of the stack.
>=20
> It would allow to remove the global list klp_ops and all the related
> code. klp_find_ops() would instead do:
>=20
>   for_each_patch
>     for_each_object
>       for_each_func
>=20
> The search would need more code. But it would be simple and
> straightforward. We do this many times all over the code.
>=20
> IMHO, it would actually remove some complexity and be a win-win =
solution.

Hi Peter!

With your suggestions, it seems that you suggest move the klp_ops pinter =
into struct klp_func.

I may do this operation:

struct klp_func {

/* internal */
void *old_func;
struct kobject kobj;
struct list_head node;
struct list_head stack_node;
+ struct klp_ops *ops;
unsigned long old_size, new_size;
bool nop;
bool patched;
bool transition;
};

With this operation, klp_ops global list will no longer needed. And if =
we want the ftrace_ops of a function, we just need to get the ops member =
of klp_func eg, func->ops.=20

And klp_find_ops() will be replaced by `ops =3D func->ops`, which is =
more easy.

Is it right?

Best Regards.
Wardenjohn.




