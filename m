Return-Path: <live-patching+bounces-608-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CAAB996DB0D
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 16:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFCE81F24988
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 14:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E8619DF68;
	Thu,  5 Sep 2024 14:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5mf1QRD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E84819D063;
	Thu,  5 Sep 2024 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725545050; cv=none; b=UQeJ4qdBdcPgdZIFqeeqqmfv+NTO4XKUBTHp5ZSRro+CCmgKmsiNaRpvmGbf/XS28Nc1+Ti3rF2jznD5x7w5lz9/Jalwz7DsfD9p/wm3AIefpLFulYCGVg8cS/oCptZXgkBDQt2OLmjzx0CY2uwkffR1xm0hTK6ISTUiSu0+jDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725545050; c=relaxed/simple;
	bh=gzhmBa26+EHZsl1gl1YKdKBHsUAHOOnf6c1Vi8oiMW0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=e08IrycayIxADr3ncaUDod+obuUeyjFLvPVEuWG4g5pTYs+7aG/D7F+Fasjr46QMQuV88mV+PQ5W7gkcG8ED1KvTuZN5sYT6MvIXiivK23qv1jLJHPkdhXEUlqM8SF0iFTYD5UwTBIJHuj2lI8t0giEONWwc9eo43RYbQ56YUC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G5mf1QRD; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-205659dc63aso8433815ad.1;
        Thu, 05 Sep 2024 07:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725545048; x=1726149848; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYNDaZPT4tF0L25ucvYmyrqe/wq83Pn5yG5NcXp+fHo=;
        b=G5mf1QRDQGzdmSQkh+JtKU+NxYR0xk5bb1Iot+/zh7HeDuMuF1vSDxLnN4M4Pqiixe
         WXOLXEPlj7+GvHjfXVsEULuOq/KQoxpZ0TZSfVJ9k4SEkqi/LX9SgmHoNYmn3Pjz1b5A
         EtNToo5QeYZN0+FMc6zy6oEcY0JCDh33aedAsTZii3pLS1D9bZEgWd+VtlaWjFMLVpe+
         khOGhj5kIUgd4DaUTnQJPSUGsel12JYqiV/PmG1S4w3QYQ+2OatwQqSnYM5d6USRPRg2
         ouXZvEWUG0/iGAFMyHrXByAHCio5EcRls0zLLl/ZWIa8uMXGK1lIK7HSX5qp3+Vv8Iys
         hkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725545048; x=1726149848;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYNDaZPT4tF0L25ucvYmyrqe/wq83Pn5yG5NcXp+fHo=;
        b=w593WtgQ7QOL57yoxleGknV+VveYYrKpd+rmzLm1NOEQsxWFFd8DTAZ0SEHYcREzjB
         pgTkBGReIc5DnrYfmSmnAUXDOm25E8rHeA0kg/+8qfY+IEHIbqivnnDYrHwLVm6KsEzi
         V17ku1WKh7BsTzSoGwFHMC+w6iZtbc/SOT5adIqO2gxwiRn8sneML0O6mrfDX5wOJB3u
         hvPklJsvCJc5qgPAj3h2mm23w8QKqDerVFTfb8PHRchh6NwL3mNF5uOHYneUw2HyrDaH
         vpNeY6KBcHY3y7iLN+bNyl7kQrVUM1249zHC7nnBjwJ5wri9/aYaibIKPuvpjZ896bNQ
         tdrA==
X-Forwarded-Encrypted: i=1; AJvYcCUeYBnSLS77q0zmxEsIGlMPobe/KP7/iDZsK0sSVw1oPlgK1d5JU+trd6rVW1Ma5tdiqomc/bT9CulGSK0=@vger.kernel.org, AJvYcCX1L4u6uyiOLQIGCcTldFgzuEFy0MOPlW2UZKAQzQDQdvjLZSAnRA/gmi3hdxrvC/Yau2HNwTzxpBwIx4YsPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbiZN9ZZ9hYLw/j99akfAzU6AV4s4md19v6KmfeqhytIA+6Mo0
	/b29Kkly3nBQIRDL424z035LsFcdtldSx5yOV1Y9qFW4hDHhIljkk05PpmzS
X-Google-Smtp-Source: AGHT+IEamEZb7VdE1gnvDpAc/KUDDU8OeSItmzSJzq/5hVybb0LVoRW7CmsPunkWK9qCSj/fLM/WWw==
X-Received: by 2002:a17:902:fc4c:b0:205:5547:92d2 with SMTP id d9443c01a7336-205554794bbmr177887405ad.48.1725545047543;
        Thu, 05 Sep 2024 07:04:07 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea3933fsm29039345ad.171.2024.09.05.07.04.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2024 07:04:06 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240904180648.fni3xeqkdrvswgcx@treble>
Date: Thu, 5 Sep 2024 22:03:52 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B13628F-755E-4081-9E12-EB2F2441BBDF@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <20240904044807.nnfqlku5hnq5sx3m@treble>
 <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>
 <20240904071424.lmonwdbq5clw7kb7@treble>
 <1517E547-55C1-4962-9B6F-D9723FEC2BE0@gmail.com>
 <20240904180648.fni3xeqkdrvswgcx@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Josh.
> Most of this information is already available in sysfs, with the
> exception of patch stacking order.
>=20
Well, this is the problem my patch want to fix. But my patch is more =
simpler, it just shows the stack top of the target function, which is =
the only thing users care.

>=20
> We want patches that fix real world, tangible problems, not =
theoretical
> problems that it *might* solve for a hypothetical user.
>=20
> What is the motiviation behind this patch?  What real world problem =
does
> it fix for you, or an actual user? =20

Here I can give you an example as I previous described:

>>Here I can give you an example.
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

>>>>>>
What's more, the scenario we easily face is that for the confidential =
environment, the system maintenance mainly depends on SREs. Different =
team may do bug fix or performance optimization to kernel function.=20

Here usually some SREs comes to me and ask me how to make sure which =
version is now actually active because tow teams make tow livepatch =
modules, both of them make changes to one function.=20

He wants to know if his system is under risk, he want the system run the =
right version of the function because one module is a bug fix and the =
other is just a performance optimization module, at this time, the bug =
fix version is much more important. dmesg is too long, he find it hard =
to find out the patch order from dmesg.

With this patch, he can just cat =
/sys/kernel/livepatch/<module>/<object>/<function>/using and get his =
answer.

> Have you considered other solutions,
> like more organized patch management in user space?

User space solutions seems unreliable. What we need is just the enabling =
version of target function. The order of livepatch module enable mainly =
from dmesg, which is easily flush away or being cleaned.

If we use an user space program to maintain the information of patch =
order, once the program is killed, the information is loss either.

Neither of the previous user space solutions seems reliable. Only kernel =
space will no one can change it. And it is the most accurate.



