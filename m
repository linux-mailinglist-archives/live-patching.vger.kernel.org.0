Return-Path: <live-patching+bounces-315-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B21EA8FAD42
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 10:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E305C1C21AA3
	for <lists+live-patching@lfdr.de>; Tue,  4 Jun 2024 08:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1811420C4;
	Tue,  4 Jun 2024 08:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AhM6M1LJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D13822075;
	Tue,  4 Jun 2024 08:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717488916; cv=none; b=h3Q6x+dr9HdOhzcRokmrsb2ZZnBN+K9/P5NveRYqFCq9EL76/cOCuGR4LXXkiSZojrSWO7c8ysxsB8+U3whF06n2+tKfMwzBuDMIDre9guBG1mH1b+Hc4Iq814cTDq6ObUfBgxiojbG+sOOG/jGhPQn2nA1nhQAOJ/MPzUWyq14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717488916; c=relaxed/simple;
	bh=SiX9bU/SSzgD9E5S9viuz+JnacYTqPrTB5aQ2SneiwQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UzAoKyV5CA6acfOnjPw96w8wiXLLiz1JMtnK88C99p0ynUmwo/DLrAlrXsYm00ayBssRzxwo1aefLBcEvUB0JzFjpcEPKZpaFFg1AEw13Zq0URsBQhwMcj2Fud3ZEuVMvrwsKRuTfxuXWsfuPPhwx0l4hmkMO6Jkate11LtpzVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AhM6M1LJ; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-24c9f628e71so2701878fac.1;
        Tue, 04 Jun 2024 01:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717488913; x=1718093713; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9kBLC2p8nuUCMtg4XVXYIpFmhV0cX45MX1PAkKRQxk=;
        b=AhM6M1LJ8k6r7k9vjpu29xnronuJldOHe7yIwNzFObtx/M8i+C0AhnaKd6rLEYYRL+
         LJQH1sxH+AVLF2htrGhcUi7N8/i6vAOHfqwnEFbLwqYn2k6ND9l+4Mq7jdczkd1KfYAE
         wJJ4Y3LizGthzntWB51xpS50JXngSJ5zZ80GBRcBC4AZLoPsBEwKVfUQROvMQgpGWjkl
         vH89S3AU94w5+ld0RedfvKpB1FdS6iD7IBKDCez6tI2eDNNDc2YN7u1dcsf39dRzfj8d
         boU1IX1Gv1MIeLatVgl/UrwEOtBuFQt6COJ2d9kLqgXI/Ti9v02oqxlnX565s8kNjQaC
         V+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717488913; x=1718093713;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C9kBLC2p8nuUCMtg4XVXYIpFmhV0cX45MX1PAkKRQxk=;
        b=WPlqFagGc+2ZDDl8MrGVqYHbCfAhTbwF9OqN6NAjtCZ+JrEaTMdaoVtjZjFFCRPzEa
         B5a0KPf2j+hxcbXexmLwFkXuMrKMdPbjU8hSOUBjAZFgEvuc3ouL5w/AkPJDT4cTKEbV
         TQMumKXMLvAGdJc17v0FyQa58mQxuwRByLvTZyNQa3KRgoX9siXCWVomxynHuijQ0yge
         m129EwdkSecwsNZT/159WZ4eIgyP9x6DvShSK1Wlqz8sUtWOaVgA+AuT6iLIC1zIX5Xa
         FQ5pa54FPH6Lx9s15WI7+SFNEq74QGFcTgI556Vifo7Nj3ZmFVi39E4TJ24IJTfVIu94
         0hww==
X-Forwarded-Encrypted: i=1; AJvYcCXefhk3uCA3ScaKTaMLXkqXVbW3fds6oL62P7+eIlhJ8KUJ2MZjDPKVGV2o6gFYXRdGa3H27XXyyM8kYw3enEnOLV/QGQ9tzaoM+U4Zt804KqDqY9X9aCekJoEOHM4DIJfO0iasgfxusbXicw==
X-Gm-Message-State: AOJu0Yy6ZE/p4CHzQYiiJ+MWSStcy6cSwhxMjkK4nVYt2isg5oB04vTb
	iIIRPDBlPG9g35WRjWQ8/a552Cg2mEIHmnGkWbMoX4/6ou2GB/PP
X-Google-Smtp-Source: AGHT+IGxxo/EDxnbf+imLgIkZXImnPeMXFLmcv02HJWF4yho9L0RYS1z8JiNY+0E1fVn0cFFzIlg+Q==
X-Received: by 2002:a05:6870:d61e:b0:244:c312:4c84 with SMTP id 586e51a60fabf-250bf12ca2bmr7740638fac.7.1717488913459;
        Tue, 04 Jun 2024 01:15:13 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242c270c7sm6582411b3a.220.2024.06.04.01.15.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2024 01:15:13 -0700 (PDT)
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
In-Reply-To: <Zloh/TbRFIX6UtA+@redhat.com>
Date: Tue, 4 Jun 2024 16:14:51 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <Zloh/TbRFIX6UtA+@redhat.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Jun 1, 2024, at 03:16, Joe Lawrence <joe.lawrence@redhat.com> =
wrote:
>=20
> Adding these attributes to livepatch sysfs would be expedient and
> probably easier for us to use, but imposes a recurring burden on us to
> maintain and test (where is the documentation and kselftest for this =
new
> interface?).  Or, we could let the other tools handle all of that for
> us.
How this attribute imposes a recurring burden to maintain and test?

> Perhaps if someone already has an off-the-shelf script that is using
> ftrace to monitor livepatched code, it could be donated to
> Documentation/livepatch/?  I can ask our QE folks if they have =
something
> like this.

My intention to introduce this attitude to sysfs is that user who what =
to see if this function is called can just need to show this function =
attribute in the livepatch sysfs interface.

User who have no experience of using ftrace will have problems to get =
the calling state of the patched function. After all, ftrace is a =
professional kernel tracing tools.

Adding this attribute will be more easier for us to show if this patched =
function is called. Actually, I have never try to use ftrace to trace a =
patched function. Is it OK of using ftrace for a livepatched function?

Regards,
Wardenjohn




