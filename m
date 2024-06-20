Return-Path: <live-patching+bounces-354-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45BD390FBB6
	for <lists+live-patching@lfdr.de>; Thu, 20 Jun 2024 05:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DDEA2832CC
	for <lists+live-patching@lfdr.de>; Thu, 20 Jun 2024 03:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C708A200C3;
	Thu, 20 Jun 2024 03:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/wlDPSr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686EA1D52C;
	Thu, 20 Jun 2024 03:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718854795; cv=none; b=O7zvERVI1/7nMQfWLPvxRmD5EmkfwsTueM3LfIMV8FYP1+z667bOddYzpTSDVo88mZv3LsOZdTzQgOxRVPqQYUaEp2ei9MNFnkbk0sCSNrLuoU4F3KLVKJcjFFYMVUE/oAxzI+Rhf5x+VzkA/tuSd7+4WTfasTRQ4bCROkKYdPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718854795; c=relaxed/simple;
	bh=Z9vrmQPcxaJWxiJw6vWOK0gXAUtCdkmcGCIFur9g8s8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BhHzhHsHOMYMbyBvmAc7D+iDryMI/d1z3dtVk27lul703aZ+q9lIneNSR80A1ZBIOUQZzGikdip+3HWcXTFMW9pDDoEJy97O+x3z7GSjfXos73f/FFe6I557CyfzxEkzcYzXEIDN7RyacyoGkeVmMwu+qIFsqfaY4HjFVH/kol4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/wlDPSr; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70633f0812dso428047b3a.0;
        Wed, 19 Jun 2024 20:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718854793; x=1719459593; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9vrmQPcxaJWxiJw6vWOK0gXAUtCdkmcGCIFur9g8s8=;
        b=k/wlDPSr0KsaT/qMKl4yFKvCtvS5LwlIOwnrCslXaa6oyblLTguEgoHBbKV1ni3AmX
         VcUIu2/72RDELHKcFR/5TKEwEDDTFcbKKZZEUOneh63ASpLm8lkNVaoPIK87687Nzd62
         unaBys3uMFGRVuvUJeqPUW2OVH3reOzW1z+NgUzYTpXfKF73NspBGZV6aFmglfUS7Efc
         rzYHLvJ86JtSAzlaEYrjCFBOki8Cynv8lQICtw2qZkwe7XlpmH+THhVd8/lXi4bvcvgc
         5dJBI10ZRrvdBtivsTEr9oUa80ZJjHLUl0h30Xg6DuSMBdODOUX4u9MzVNofnGJx2Ony
         Sitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718854793; x=1719459593;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9vrmQPcxaJWxiJw6vWOK0gXAUtCdkmcGCIFur9g8s8=;
        b=JMzCmE6MOWCkEUKvjitUSnNOovAzsDEhBPpC0DQqEAZZM8J7O2OmqK6OLjS0xBKYMD
         6vH0FCw0x1/AfXXyiaCKbSaiN7xu2mdiU+kQiJCmjdoi2tAFhskD8B5R0kwMWrWJ4g66
         2n7gGFZzk4ZCQxps25xccCsdJ/2G79sp587Usi+X5QfTchKjXOFCCAsQB6bdgcaFu7yp
         Sgx1nyMJjSoTeatsQT1wdoRZU7avLOLYtwjOm/4mrlU9qB5swtPC+w+hQkireQh4he78
         KwVQ7WE787KAPnOxyhVvVSV5pL7+nnH2T4zzWaok2W+yHE7+bl0QchRQcuzTfA5vt9D/
         WRNg==
X-Forwarded-Encrypted: i=1; AJvYcCXhrhFNRn556KyWk6Q3av1U/njGsuUxv3dOAH7s2xLKKpccjXjtb0Ww0zS7Yeebt9BeEnb0ic4kP2fYp+oKX4GDZiXZL0v1FN1lY3Z+TpGciiO5YeTpJHXlc9hKKC8bvxLqXoAqBCXd2Mf2lg==
X-Gm-Message-State: AOJu0Yy2cfucjCe7G8emLHded7KzhgITNs2x+oXadxa9JqYgH1SPQCXd
	76M/y1ec+YYlj0AUs2PKbFukRgdzfLKdZZzGUPzsPI3LIG71Zlmr
X-Google-Smtp-Source: AGHT+IH8E3zhOadHjijktRjCIkt9GVpjzzB1OciH0Bu7m1LD+pd5id84ZKnBYx5ikvRd4xwag5CfFQ==
X-Received: by 2002:a05:6a21:3389:b0:1b5:44eb:2eda with SMTP id adf61e73a8af0-1bcbb386a8cmr4994570637.5.1718854793466;
        Wed, 19 Jun 2024 20:39:53 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.125])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f497a1sm125202575ad.283.2024.06.19.20.39.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2024 20:39:53 -0700 (PDT)
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
In-Reply-To: <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz>
Date: Thu, 20 Jun 2024 11:39:38 +0800
Cc: Song Liu <song@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <17FDEE20-A187-4493-BFA6-F09555B1EF6F@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <CAPhsuW7bjyLvfQ-ysKE+S8x26Zv5b7jbJoyW8UiBaUfaRncKfg@mail.gmail.com>
 <alpine.LSU.2.21.2406071102420.29080@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Jun 7, 2024, at 17:07, Miroslav Benes <mbenes@suse.cz> wrote:
>=20
> It would be better than this patch but given what was mentioned in the=20=

> thread I wonder if it is possible to use ftrace even for this. See=20
> /sys/kernel/tracing/trace_stat/function*. It already gathers the =
number of=20
> hits.
>=20

Hi, Miroslav

Can ftrace able to trace the function which I added into kernel by =
livepatching?

Regard
Wardenjohn=

