Return-Path: <live-patching+bounces-404-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 665AB93B381
	for <lists+live-patching@lfdr.de>; Wed, 24 Jul 2024 17:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 040A1B22705
	for <lists+live-patching@lfdr.de>; Wed, 24 Jul 2024 15:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D481E15B0FD;
	Wed, 24 Jul 2024 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQIRQzfG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D5D383A9;
	Wed, 24 Jul 2024 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721834452; cv=none; b=DG6MOBPgYRD8ynBTl9MWGJscIjPjjiT4CB6a+wDcBmSS7I6PAlmqGnv3pKm2MN5tn/4GHLwLok89wA2j1D2oRNLBN/wLrE8+uGfCiIKfjP2P/8GpC4bmy0Qz26BslAiaXZArW6Vzl8POqoYQKIDJ39Z4dbPPc4v4yLxgX7b2KKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721834452; c=relaxed/simple;
	bh=VIQS1f4LLUtDz8L3mHiOANsnvpMpxB7gwYki6WUhQ5o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OEbK+pIet/cPmvJ8I0t0ylJ/UEiuXvb+LcqF5CCEq5J3/XaSWxSLrdH02ODWcvkkITCPMSkUoiDeqRbSmhuIrIAELli2/qdf3tdx9kC+nXIKmW7w2bbp3C91JtDpRcOUAr3ouHzcYspIrq3GO0jwlFKgzsMN3Okk4SKmow8dJDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQIRQzfG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d2b921c48so2525290b3a.1;
        Wed, 24 Jul 2024 08:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721834451; x=1722439251; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZgCYvZe74EjuwotEC/K0+ANqv3wqwQ9RBQVz46bO8s=;
        b=jQIRQzfGVpGTQTmwLKT0uiWWGXoN9MkOMK5mINyJuFiznTViUS6RVG++W7q6JeD+HN
         KWaxO8fg0Cugjd+IIF3dNy5WlL/+Pk/x2tZJU0HNR4mXBa3wGp5g8D3MDJpmMYwzv+B+
         wxYAcXShqjTz8WJq1+cmDahs96pqPNyHBUP1b4LVujACN+9EpHrcnKBAZWNbEQckbsRE
         eLeEQ0+Xe9tgx76tmLYLvJ2VotTR8RURA39CidCuWaF4fc4DEE1RvVZPEtQSIfwZU8nH
         1/caSmAHjvXoapwqZEhieZ1lcSPBOOD1CwsdXiPcya6BkZSB5lY69TfbSlZ8ecTGH5zj
         tt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721834451; x=1722439251;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZgCYvZe74EjuwotEC/K0+ANqv3wqwQ9RBQVz46bO8s=;
        b=A2FMQn1jrz1Jio8gV/e1dIHPH/xXIilRebMFN1Rt1GhzwEPjJ+JKRXtbCNJf6YpU5a
         9tY7UaVCOjf5Q5MiVbRY1QG3GE6g4gkBYlrrDboBXkJ9xJPp7uUlNIfQfFAoQjStak6f
         5kNeXNF+6s9EY7+PhEbIBKunMzw5b3gitExRccvlxcllAAAzL0vyGoLdp1VDyO5rIN4P
         veT472sty2oTr3uaKThcRG+0LDD4eJvy+UxeDexqYP2f/ECCqfvbT1cS9JY4pmw00YWY
         aVx/w0hO13B3q/JFAB150xIATh/XR6W4bUyKeVngnTsyVNTXaKEzP6vGMhqntK0mX6F+
         4gSg==
X-Forwarded-Encrypted: i=1; AJvYcCUvl5iHdHom3mMEEMbpfFSXn10rIe/Vl5IEPo2OVrXOMbLjnYKZ6vd11xsaKPlgdiW0Z8O6WG8aVFULpcjbWq6Y7GkRi2Kbh++/tnQHGCrULR9e7gym8fgcIosD/1/hcMDTgBz41pUKFgbPpw==
X-Gm-Message-State: AOJu0Yx6hj8d2jsSMT60MX0UdZ6FjhIbyPHM/ByOwgWAtJgwlwWcXr3J
	l1ZhgWD9q0dmPZ4IpJsiCw3cMrBDYIJdS/CHdzINso8x+H+APFo1
X-Google-Smtp-Source: AGHT+IGAwk+DP14de0w6Ofep8xbTauqTQMNXVBkM2KthX23yjOHYOrVTk2bGjnwqWvpXoJr9r8UW/w==
X-Received: by 2002:a05:6a20:3d81:b0:1c3:b20e:8bbf with SMTP id adf61e73a8af0-1c4727fb9ebmr172296637.14.1721834450568;
        Wed, 24 Jul 2024 08:20:50 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70d2245f052sm5653630b3a.159.2024.07.24.08.20.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2024 08:20:50 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: Add using attribute to klp_func for using func
 show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZqEXC7NVStjPA9os@pathway.suse.cz>
Date: Wed, 24 Jul 2024 23:20:34 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A0E6D0A-4245-4F44-8667-CDD86A925347@gmail.com>
References: <20240718152807.92422-1-zhangyongde.zyd@alibaba-inc.com>
 <alpine.LSU.2.21.2407191402500.24282@pobox.suse.cz>
 <07DD1CA1-7E53-4E67-92DC-ECEC11424804@gmail.com>
 <ZqEXC7NVStjPA9os@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi Petr!

> The value is useless when the transition is in progress.
> You simply do not know which variant is used in this case.
>=20
Yes, I agree that if the patch is in transition, we can not know which =
version of this function is running by one task.

As my previous explanation, each patch have a state "transition" to show =
if this patch is under transition state. If this function "using" is 1, =
it shows that this function is going to become the version to be use, =
but not all the task use this newest version because some task is under =
transition (this is the "unknown" state from your opinion).

> Which brings the question how exactly you use the value.
> Could you please provide an example of decision which you make based
> on the value?
>=20

Here I can give you an example.
We are going to fix a problem of io_uring.
Our team made a livepatch of io_sq_offload_create.
This livepatch module is deployed to some running servers.

Then, another team make some change to the same function and deployed it =
to the same cluster.

Finally, they found that there are some livepatch module modifying the =
same function io_sq_offload_create. But none of them can tell which =
version of io_sq_offload_create is now exactly running in the system.

We can only use crash to debug /proc/kcore to see if we can get more =
information from the kcore.

If livepatch can tell which version of the function is now running or =
going to run, it will be very useful.
> If we agree that it makes sense then we should make it 3-state
> where the meaning of values would be:
>=20
>   -1: unknown (transition in progress)
>   0: unused
>   1: used
>=20

Yeah, I agree with this state. I combine "transition" and "using" to =
tell the unknown state. It can be better if this state can be shown in =
using flag.

Thanks!
Wardenjohn



