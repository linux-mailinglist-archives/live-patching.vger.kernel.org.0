Return-Path: <live-patching+bounces-288-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3CF08CE1FF
	for <lists+live-patching@lfdr.de>; Fri, 24 May 2024 10:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 876A6282E22
	for <lists+live-patching@lfdr.de>; Fri, 24 May 2024 08:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99F882872;
	Fri, 24 May 2024 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPYxb0eJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F7E17578;
	Fri, 24 May 2024 08:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716538173; cv=none; b=gHSGXZQy4IqG9ENK7U/O3HE6+M2b5zhA/iugiQJMpLvQ7obKd3ZZjJt5iMyanxEqCZaEa8m9//1v+GRHv6R3YSkp1CMIYAFXaoN/ahqudVw01tfi0DLE5grcsYn0oGwfkodA/7DiXEkmgkaEJAlLz1hlagsQuQ7th110T2nUx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716538173; c=relaxed/simple;
	bh=Zkj2JsIkfE+bq2wOsgBsTDSgz21PZZORITW3xZI1H74=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RqL0mqTRnKGFLXbjhIseaiuJP+BOrwNbufMEUONkzEk2bFzGM6MJuXaG662Itl4owwMPIrIx9vmC1tm5YyFq5u6pudLz29yWtJqI8KdFqKmOZjicu1h0DTlmU3qbHbHaDafD75dw6McfYYWE4AHj6/UDfT2mtvN1eGv6q6YYdmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPYxb0eJ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6f8ecafd661so574426b3a.3;
        Fri, 24 May 2024 01:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716538171; x=1717142971; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zkj2JsIkfE+bq2wOsgBsTDSgz21PZZORITW3xZI1H74=;
        b=UPYxb0eJWdjue9zhgYHawAOlmqAEwHCT7WSCYyh8CkYNkG2rKKLU6Sqbtz9ma99rGh
         8XvC1rqEOjIShJX9lK59eIqxtuHUBUhse0p/8HhlALaVyo8szmEPLaH5rJgpcCR3774F
         KMs8nc1B+fzCoPJGtueWHkkOJjxuB6wUpnikGDCcj2+VHkwQr67zyUajc73vIYSnexPP
         iu3aKub1zvUsb/qolHCdGGg8yqhe48wnZqHB+0q22cSBYQvBEdLxvmhiCCI0de/u0Wxk
         aUU1Hy3STdf1G5G0o2B9zj2xYZSuIb7BY7FIN/BO4K4G1J3q4eVdarp1WLj6hC3umJrO
         wvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716538171; x=1717142971;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zkj2JsIkfE+bq2wOsgBsTDSgz21PZZORITW3xZI1H74=;
        b=hBN+bRNeI8lUK+Cgf+TGSrbDvcYszL6+/74iXd1kY8wwTR2QdiOXE0vFvdulGwQXQw
         uI7dAc4WBPUHou5atDPCJu6gLXLIZ0h/Vjye6pUboN7J8FaelMzIPCO263xL/XYo1KT1
         /sNMWuL0l1WMRoSQrqix/uKSzH3s84oY2gytWLEqrB09bFdwN60+3Cx7AGUuv0SX87CO
         ZkXIzwdexQXEeFCrrRQ+eDC4I56fIqUl4dXF5OSRaeA1wtTYDm1w+YlHe6iVm5nQPz6m
         CGuJPTn9usgJBXmTPnDJnRaYA+U6Z4N9v6tocuFxmSwWWMtQpcFzNhLjWjeuDhSi9P4g
         YH5g==
X-Forwarded-Encrypted: i=1; AJvYcCWiNopqV8k0TqaucKH7v+M1Vb+QId/OKinjCyP+LG/WNRq6O3EXFaCnw2dJWtnSro0z/2+uRO/31LTyq8GFooqQgS8NRnBl94UnWJ+XWNovmVMhzZtDooygYE2eambyAcaa5TZkQi9v2q6S5w==
X-Gm-Message-State: AOJu0YypgHYlflkqYqX51MSQ/6tDG8o3IL88kcklF6jJs36IItJ+CDpG
	ZotkhO34uC9g0hQ890wxTq16lxjtrbAMsXBIYq3ZSVkLwxiwUk3ZNzWBW45e
X-Google-Smtp-Source: AGHT+IF6YJAZ9Ra9s5FChAtubXnvhoRTT2zAP15GFcXYujj/VAOzbeTtpvpRUQ8FX2bzyrVGMHSiWg==
X-Received: by 2002:a05:6a20:3d88:b0:1af:e151:a934 with SMTP id adf61e73a8af0-1b212e5c01emr2044559637.59.1716538171508;
        Fri, 24 May 2024 01:09:31 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bdd9f4c604sm2739097a91.41.2024.05.24.01.09.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2024 01:09:31 -0700 (PDT)
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
In-Reply-To: <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
Date: Fri, 24 May 2024 16:09:10 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <17CDE51B-D42D-471F-8E32-64C8D9C06413@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On May 21, 2024, at 16:04, Petr Mladek <pmladek@suse.com> wrote:
>=20
> Another motivation to use ftrace for testing is that it does not
> affect the performance in production.
>=20
> We should keep klp_ftrace_handler() as fast as possible so that we
> could livepatch also performance sensitive functions.
>=20

How about using unlikely() for branch testing? If we use unlikely, maybe =
there is no negative effect to klp_ftrace_handler() once this function =
is called.

Regards,
Wardenjohn


