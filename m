Return-Path: <live-patching+bounces-464-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 836B394B4DE
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 04:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC3481F237D4
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 02:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC04D2E5;
	Thu,  8 Aug 2024 02:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZG9T9rqF"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA8933E7;
	Thu,  8 Aug 2024 02:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723083073; cv=none; b=aDxBGK/ny/rbcwEg77fShiBeV50MfQP345HYlh22GSx4OwqdxTEV30dvaMvcelAyWLDUlTqBWcKkDxUcostGT42vAR3GVav8u0EFUtbm5qodBXAElhdRD7fnW1D8htZ6oWTKLAZoYMrclUzByo8jtXyvvpwKOC/iD8DPJE5oRHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723083073; c=relaxed/simple;
	bh=qq7Awa2XpNPG3HmL4hyJn4mPzzevuZMISdq2nOwB49E=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kBJXWM3DP8NnDf8pBZTN9XbK8Qnac05ARh8WJkVSXM1jNM/1U8Qnb2/P83mCVcumBKz47HUIu4e6ZALxTu83vJYKrDHrPD4yoAULkwvyLddF0kcSyXjnbPUKOybvsdtMN7aqxDqAVc6stKyxzBhKcU4AtbczwXK6pErcU0c8BSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZG9T9rqF; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fc611a0f8cso4997585ad.2;
        Wed, 07 Aug 2024 19:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723083071; x=1723687871; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rh2qAxeMIswpUVNbuNakpRNeB3Veim3jQR9iXS0wNkM=;
        b=ZG9T9rqF10DIIWfyrv2g7vdEMD6rgz1gBVYcH3M7XQYdP1kRtIPTOSdP7zYC77Npd5
         hFaUqRHaOiFtwBTMOVKPd465EcpUf6MeeZHqutzJh7AT7mTWqTpFhQFCX4nKOWafzFkK
         vshiArDl0l/KHKsN35qjVY8tTUz5BOV0X1DRk0KrqpWwRqnE9xUAG4DmBMOUumPTxLkv
         5ek2VyF4YodWGAsooS2EFSX18QIcagCzGWh731xmOasgdOoOFJ7AXDEnuKDNXnAsUIow
         lZBltpKJbfDitO0zrJXq8CrSEito2/sDblawjaxi9APAW9WO4w3AWqnW9CaDOlvo6yol
         hEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723083071; x=1723687871;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rh2qAxeMIswpUVNbuNakpRNeB3Veim3jQR9iXS0wNkM=;
        b=D+A0TmFtMmtoXi0JN1DMFL3+6R7PurrIPd1SlkgBAGNW/b6k0X6YQ7p+8g4GLyoTYd
         fB28iiMEHBKxLzthe7OfTjVBA3551s/hsVLrfLIvTInQWsDUAKVs9Vq5C/00Gc3DZhBo
         tZ69IlwxgrvcN4o9NE8Wse0pKjsgPNFT7cdLCx3Vm/7Sv7YCPx+k3e5LQVWMIYEy1g6T
         9h2c4t9O/FVE7rRK/LehoJJp57/1zaKen5Fmb4io0NkAB94eCp/NAzHsgLsgRaRrjp2q
         t7/ro6j/8Kx4xkriL2zu2CenDej/LQfAXtihtg3BCRNgdx5ecZ4gxgRtbrrpPAJ72oER
         Xc4A==
X-Forwarded-Encrypted: i=1; AJvYcCUuR94uidKJnOAkEKwnxGUOKKzEKg1J1vZVA2MvCw6huzasJ9/4HNXhRRNmkWJ7qFieIQ0pUBOmYaSpKbvxOTg0N8yWqGzcaoKI2HEq3PslhOFabw8vkcIkc3GaVPQjls3mjr6KzWbOZ2bAWp/i4UUZ1JjrOucQFKj05HJs4kd9pg6sDTV3dHj4B7nFdx1zcg==
X-Gm-Message-State: AOJu0YwPTZIriMOXJvJko+H53df7hpo+KpJOLmZuNem7cHBYf5+V4W35
	m+KUEIWbPpFchawx8g6O6H7v6MMfZXt9ImNEnEYI0mDA/IISoo5k
X-Google-Smtp-Source: AGHT+IEccN/3In/A/yvzAAHYBgExNt8p0GrOittDB7WrlvTOeGG15AWAaMHJHYacbPLd1/KvRB/yCQ==
X-Received: by 2002:a17:902:d2cc:b0:1fd:6a00:582e with SMTP id d9443c01a7336-200952641bemr6352305ad.30.1723083070709;
        Wed, 07 Aug 2024 19:11:10 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff59295294sm113086435ad.253.2024.08.07.19.11.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2024 19:11:10 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <22D3CE6E-945B-43C4-A3A2-C57588B12BD0@fb.com>
Date: Thu, 8 Aug 2024 10:10:52 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 Nathan Chancellor <nathan@kernel.org>,
 "morbo@google.com" <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Leizhen <thunder.leizhen@huawei.com>,
 "kees@kernel.org" <kees@kernel.org>,
 Kernel Team <kernel-team@meta.com>,
 Matthew Maurer <mmaurer@google.com>,
 Sami Tolvanen <samitolvanen@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5271E070-362B-403D-A7EE-FB0855F31DB2@gmail.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <87F7024C-9049-4573-829B-79261FC87984@gmail.com>
 <22D3CE6E-945B-43C4-A3A2-C57588B12BD0@fb.com>
To: Song Liu <songliubraving@meta.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> IIUC, constprop means const propagation. For example, function=20
> "foo(int a, int b)" that is called as "foo(a, 10)" will be come=20
> "foo(int a)" with a hard-coded b =3D 10 inside.=20
>=20
> .part.0 is part of the function, as the other part is inlined in=20
> the caller.=20
>=20
> With binary-diff based toolchain (kpatch-build), I think these will be=20=

> handled automatically.
>=20
> Thanks,
> Song

Yep, Thanks for your explanation!

I discuss here just for an interest.

IMO, more people may use tools like 'kpatch-build' to build a livepatch =
for it will be more easy. But I think such tools should also be =
attention to such changes because when it trying to do section-level or =
symbol-level operations. Otherwise it may cause problems :)

>  However, if we write the livepatch manually, we=20
> need to understand these behavior with .constprop and .part.=20

Do you think it is wise to write a livepatch module manually? If we are =
trying to write a module manually, we should also take care of the klp_* =
function calling, while using a livepatch building tools will help =
handle it :)

Thanks.
Wardenjohn=20


