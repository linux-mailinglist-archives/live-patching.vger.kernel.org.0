Return-Path: <live-patching+bounces-317-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF17C8FB0AE
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 13:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60E32828DE
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 11:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E24145336;
	Tue,  4 Jun 2024 11:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTdQJEPu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01678144D3B;
	Tue,  4 Jun 2024 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717498912; cv=none; b=oMLI1EkAz5rIQHTr+YM1jsT7e8wGgK4FtnMO6dzsEN4+atmMkmcmjvkiB1jeR/4144y59I7sX1Vkl6RRt6ZwsEde6RNB1aWzd8LnyWMHbzbjZ0cpBq3wdp8vGvGZYL5y4XeTeISeK5RGYkCg8ZhNXFf0BuMmrE7eL7Ic7PKA61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717498912; c=relaxed/simple;
	bh=RTdELaz1SKXD3NwHcPUy4vbMMXa1MXNMWP6KCxm+jjs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LFrR+COFMV5sLyRFReN0Xgv5DfHFwVSIRKJo6ISr3lOQTNuFH6tba43WV4eB91dV00gzadvwW/0/qzQGpdvkH2IITFXF8FP/c0sh0Y6BRYt37ND+2ypTNSSoYq+K0NxQMPr0WGPp0J7eLJxW/1s47buiFAFT+y7e6iu6tY1GDXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTdQJEPu; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f44b4404dfso47383955ad.0;
        Tue, 04 Jun 2024 04:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717498910; x=1718103710; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTdELaz1SKXD3NwHcPUy4vbMMXa1MXNMWP6KCxm+jjs=;
        b=bTdQJEPub9u+u6hw+Lkh7rrMCFWU35PiEkA5nBONKZ4OQOpxiwpcAVQFdAvKPoxsnV
         BNXXUru5SlNRGsa9PXthBn3ZPP65qHyDAHUS6m1ntXnsPW/agOr23glCG7GnT9zmLkjl
         wB/BOTvHV2nsyoY0N3UPEsgxjw4OJ4VQHOWjgHGGn0s76pEKGP9dwXG+tB1gkDxDu+vT
         oHU0udiipIfqD82ygR6vQhws5whAtTWaLPtPCxKsFAAhy256qHvrX1NFF6IH1XwBh8Nl
         FT/48YGENKRX3KWgKRnukc0dBzWuXLRFngiveeL1EE+2o22T+F/2UiY9pfozXFPCawO2
         QKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717498910; x=1718103710;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTdELaz1SKXD3NwHcPUy4vbMMXa1MXNMWP6KCxm+jjs=;
        b=LAPWq33RE4qvcmrvuEznuTYnR4xDpEU4FlZy+hx3O4OnmAUlwJzGSw9WV8FdsKz56F
         hxBXEzQS3r3yoDo4uH0t28RrE8cKi4x9B1bSfzGekGaoDjAd/XJgTQm6n5bCPWnoESUk
         HBi4Ic1nDttmlwZ50zjN22TAVvn6YCIVz7ALUODveBY863NwxIaCD6y2MXfQzMaFp/xS
         POSwVWOPaSMS4Z2Wi157DMIIuOr2Lqr/k0s2uyG9YdH+sFOBYD8nL5IKvCidquuVdoQS
         QjsfTyj5nlmNiu8LnfAxKeBNdL5y+7kghrzYyZYs3Ooc84MPL+GAdC6ZwSAZdKR4O0oL
         jAVg==
X-Forwarded-Encrypted: i=1; AJvYcCXYTYzelHNEiXCVZfgLN9OoPBAGb+LvMizXIWND/50G1MFmt7u55bypSUbVxkqkxqE2YzmSyFBBO2cFfBqdbvSFmPkiBepcrYZvADfTn10qJXK338R8HbRS179lRfeFqWvh0++9mX9Y3zD6Gg==
X-Gm-Message-State: AOJu0YxEjlgoMmaRR7gfDH3OYeFLOHdpY3VRhmVJDD81Wi1BhMH3YPDF
	vLYu+icfIN2BylVNNP1HoNe/6x+7xlGqTrZRtbtd7lX2VQ/SdUd8
X-Google-Smtp-Source: AGHT+IFuCRvEfdmYM0sprFLA64OUtROJMAq4GyCsatZ2klDKgHUPbr6fMi8sTeJRZFwJCFwOFzK88g==
X-Received: by 2002:a17:902:e88a:b0:1f6:8862:aa20 with SMTP id d9443c01a7336-1f68862ac56mr41928305ad.45.1717498910114;
        Tue, 04 Jun 2024 04:01:50 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63235b0absm81240095ad.65.2024.06.04.04.01.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2024 04:01:49 -0700 (PDT)
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
In-Reply-To: <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
Date: Tue, 4 Jun 2024 19:01:35 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <189B58F7-888A-4D5F-91F3-C1EF584FB451@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <Zloh/TbRFIX6UtA+@redhat.com>
 <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> My intention to introduce this attitude to sysfs is that user who what =
to see if this function is called can just need to show this function =
attribute in the livepatch sysfs interface.
>=20

Sorry bros,
There is a typo in my word : attitude -> attribute=20

Autocomplete make it wrong=E2=80=A6.lol..

Wardenjohn=

