Return-Path: <live-patching+bounces-321-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 423718FC1E9
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2024 04:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E45662850AF
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2024 02:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3C761FD8;
	Wed,  5 Jun 2024 02:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K44FjehC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DF9184E;
	Wed,  5 Jun 2024 02:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717555128; cv=none; b=f/ooANMui+0flk0ndw/OvGh7N84CRNaS81NvVDBD4zDOpZDsvv/ikhs5XDcop7Xz4FtYjUMM4F01qCC4EBpSn4acO5jWBtCwsxxdYvTCowHauJtYPF9TJUHYr/ADqTtVVaz0DEZ4mWuJEmG+K0w4HYxt6EWq5lhWi05tCNLsOxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717555128; c=relaxed/simple;
	bh=o3Q+An7UbPnqyumzqn80+Os+5NZcJj0peU4WCy4Kv7s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lXocMiPu5+zfXcOz/KGYPb3WcqodXRP9nKVh6lj94lwycU/eehvyP0DllX4eJoCixT5bkFBV6zqTPNcntKchoUgMobe2O4pQa/c5j2q7eh6XEAvIu9DKvdsDMDpKdxurqD1E4jOyGEgROJSsd8AjFlKMcgKXiZaX5lhAn+nk8o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K44FjehC; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f612d7b0f5so3214405ad.0;
        Tue, 04 Jun 2024 19:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717555126; x=1718159926; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9Mn2tgnwaXoeTQLCzoy4FJf82lfTlzOR2ZRomROvLw=;
        b=K44FjehCcaGe9j9aU4UGdYhWW+NosDSLjD3oen6NN6FWhvicqrhdth0aamzK26JLrS
         y/rCZAXn3X9esM4B+i5lAlfqCD3fi6FE/c2bgrSWyuFbxCAEvDSZn1AgRCi11X4TLYAs
         pTe19BEO9JciXQvRmK63P7gq+GkSav/f2cvZ545h6fLnRDKtryspuWXAV9JqS7Jcq7Pw
         feAU6BtYzq/M8wnIsZdSV+dLioHsENsEFS1EaEw0l3bAJHxh17N6/rQzPGS98tAk0eWO
         dmG7u/iRyHmTxyJV48rHbWJjnH8soOHAcvmtfMuZDMtWGC1FFviKaQLxuOBqWo9M19bN
         9HqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717555126; x=1718159926;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9Mn2tgnwaXoeTQLCzoy4FJf82lfTlzOR2ZRomROvLw=;
        b=DUtmphzIDg5DfIjKcqQuYardAcoITKoQDOH022kKTivxNv/Fe5CMAs9YBZ/LLdHSXy
         Cfx5DhhSYC0JGCyPaJcBGQ8ZT9n1ex66TRbRJqDPxZOxN/vnV7cMisq/7oxQwwSm4MP7
         czHos7it/c2WQdD8rBWAzpgSdnxRlD8WOEAl/SZ84/YvLoSKhXsSt8BCN8x6Do/aPJSD
         nFso+rohccoSLUfzCl62HgyJYvKVUSOonJKBXft1YqPl6jNjF/JgTVVNCjCXAUyBW3kO
         bb7/st7Fel4Z5+tQjts5lQj3U9pAr7/MOpV2/UYZb43DTskDzqJVDOvRZrwI0MCwMIId
         2XrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW2VRkZvvxGTlGkB3V8ASZdCsMVF20l+i7fk+bL9Xy56580Lq6nXPooWiG6HybRK3vLg0zHAZI1Aedf6ePhxNHUXA4NaqCK77CLfkvB6VstjM0W1Wr4RTqL9yJXlwsOsXYdaOPF1oCLYPQQA==
X-Gm-Message-State: AOJu0YzmRX3Im6iBNMdJlPeK0Rf944kJS1jtHXUed8GE++v/lG8nzGLd
	CPmSD9cvdmhsvjXtjh6+9do+htbtixpYsVUj2sVthfM1qh/pw1Pm
X-Google-Smtp-Source: AGHT+IFRVr5algcuw8/KClM8hkRmEu+E2w3uP6RNF2NuqcYe30WC3IZe+Pe2Mrgp3uv9cQZakQJ2SQ==
X-Received: by 2002:a17:902:e752:b0:1f6:83d1:a232 with SMTP id d9443c01a7336-1f6a568d292mr22496495ad.10.1717555125500;
        Tue, 04 Jun 2024 19:38:45 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f64cff714csm72692195ad.215.2024.06.04.19.38.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2024 19:38:45 -0700 (PDT)
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
In-Reply-To: <Zl8mqq6nFlZL+6sb@redhat.com>
Date: Wed, 5 Jun 2024 10:38:30 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <92FCCE66-8CE5-47B4-A20C-31DC16EE3DE0@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <Zloh/TbRFIX6UtA+@redhat.com>
 <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
 <Zl8mqq6nFlZL+6sb@redhat.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi Joe,

>=20
> Perhaps "responsibility" is a better description.  This would =
introduce
> an attribute that someone's userspace utility is relying on.  It =
should
> at least have a kselftest to ensure a random patch in 2027 doesn't =
break
> it.
I sent this patch to see the what the community thinks about this =
attribute (although it think it is necessary and this will be more =
convenient for users).

If this patch is seems to be good, I will add a kselftest to this =
attribute.

As Miroslav and Petr said, keeping klp_ftrace_handler() as fast as =
possible is also important, which I need to find a way to keep it fast =
(or just setting the state to be true instead of a judgement?).

> The kernel docs provide a lot of explanation of the complete ftracing
> interface.  It's pretty power stuff, though you may also go the other
> direction and look into using the trace-cmd front end to simplify all =
of
> the sysfs manipulation.  Julia Evans wrote a blog [1] a while back =
that
> provides a some more examples.
>=20
> [1] https://jvns.ca/blog/2017/03/19/getting-started-with-ftrace/
>=20
> --
> Joe

Nice of you! Thanks! I will learn it!

Regards,
Wardenjohn


