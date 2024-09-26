Return-Path: <live-patching+bounces-685-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3029872C0
	for <lists+live-patching@lfdr.de>; Thu, 26 Sep 2024 13:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 792931F25845
	for <lists+live-patching@lfdr.de>; Thu, 26 Sep 2024 11:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FF618BC23;
	Thu, 26 Sep 2024 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bj74r4UU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1B18C002;
	Thu, 26 Sep 2024 11:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727349841; cv=none; b=TzSbkw7MChVgLPQ613ZLfA5j3pmVSWJAAVlzm/H01M+S+P3TeIB2oTfZz5rMfttUASimCIZ7FPGdot55pIEowP5EsCWO33/t/CGqvzS2GAaGNB3S4CiEfgDjwS3OyckOLnoKouNZgYrzUTZwnc+rK/mz/Vjtc0DTywZjb0k8YuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727349841; c=relaxed/simple;
	bh=Qh6BKA0klmtViryPhizQMHA5VvaCtxlmVNmS6TUntoA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MjWnF/UvSx9nV/EU16z9HNEKVkIIdZowbN9nUpZc4PY7fyU+vt8lTqIsVhYchqodsrayyhrpvfTM1wylIfdCJCpnnWlMBAbMl9otIkdi34/ALAGlEqn/HEftOAd6p9GMA/othm+ObRgyNNVftiMKZeauqJtshDF4RcpOSeSYh28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bj74r4UU; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-718e2855479so626934b3a.1;
        Thu, 26 Sep 2024 04:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727349839; x=1727954639; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qh6BKA0klmtViryPhizQMHA5VvaCtxlmVNmS6TUntoA=;
        b=bj74r4UUE5LPAbnJ6JuXEaTj5DOZCSYBL95NKgUgSAl4rMUnSQFH4dfwQyRQcdjEJZ
         lpKfsZjNBBCLer9vt49idN1qugVYTWAYHrs1MC4JotFfZnIn263JY8yWci6E4Ip2KMw8
         PjZZ5EElkm6TxrLInKCFEyDyStg+eoxashxQUCpNADo7Ure+kiARZSb7eSv1xcCOfcv0
         LvX5BIfpLx7YivANk3cq8hX2yzU+DoYvn4hOnj6KCelZCqPeLXr9FLBedNMQQxDKMbX5
         Al05RVCh5tZsOG6YlB71CM95p06BAIvPrzacDigM+4w4U40oq4toU5au/FjJfZ6D8nml
         DqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727349839; x=1727954639;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qh6BKA0klmtViryPhizQMHA5VvaCtxlmVNmS6TUntoA=;
        b=jtARh+V6VHtqzswH5BgDw7yozBBNW/7H1mNjNbKrVUN4XH/y5wOVhD0HP7f8uPIvx7
         S4tMb3kcxf/N+70q/hXpl/rZpwJZUzopA7OtTsU3RX3D9Zq8Ny6USInsqdTeVrM5hKxw
         yN+rW/Yfiw79iGjlyZwXKcG8c1QY0KPlKOxw4AOjrpFx4VSloqbcLWT50lzBNjyjaukG
         HxvcbPEYMkktCLWVjHlJ8CJOVub6o0xE5h0zlK8gnhnkl2t/2OrPDBAH+okZ3CX1c0BE
         0zQalG9sRjWvRkve0l+qguz9D8x/dF2N5wF2UjaniC4cMKQUn/FdeIiWRfujUKXGA+wk
         uulw==
X-Forwarded-Encrypted: i=1; AJvYcCUZN3Pnjz/N4Gt5X06L2yS8pKKOB+IBOkYTQfRj0QVENnsemosgFSs3XBB94mzLIHi/W92+04+FJKvMrHza3A==@vger.kernel.org, AJvYcCXzW0N5c/3SLmfi3gHLeDo+/ZC2Pas0diQ1pK0oTNplDuTWKnWUmNxKP2kgf0+dtwvS4JofQ4eG28rDprY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWMeOq60wHbwfD8sMkIrW76GXXIryS4EFiJrtHaRg8eqfZQgso
	FwW2l0X7bsJT1/xhYtJxlWaV8iOasykDj/3VTTu8e5sZny/3lBk8
X-Google-Smtp-Source: AGHT+IESqjCJ3V69qqI/L3vFmeBNqhPpBAt80MIcXE8Vc2JIV6xIYQktZwJ2SiMRLJ0z42frHG76yA==
X-Received: by 2002:a05:6a21:3941:b0:1c6:a65f:299 with SMTP id adf61e73a8af0-1d4d4ac640emr7966777637.21.1727349839055;
        Thu, 26 Sep 2024 04:23:59 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc92c9c1sm4157565b3a.114.2024.09.26.04.23.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2024 04:23:58 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH 0/2] livepatch: introduce 'stack_order' sysfs interface to
 klp_patch
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <0fe8f8d36fb5fc78c645b26c20b5ae365bb59991.camel@suse.com>
Date: Thu, 26 Sep 2024 19:23:44 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A6A3E71-DB43-4305-95FC-202D20B5EC16@gmail.com>
References: <20240925064047.95503-1-zhangwarden@gmail.com>
 <0fe8f8d36fb5fc78c645b26c20b5ae365bb59991.camel@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> On Sep 25, 2024, at 21:08, Marcos Paulo de Souza <mpdesouza@suse.com> =
wrote:
>=20
> On Wed, 2024-09-25 at 14:40 +0800, Wardenjohn wrote:
>> As previous discussion, maintainers think that patch-level sysfs
>> interface is the
>> only acceptable way to maintain the information of the order that
>> klp_patch is=20
>> applied to the system.
>>=20
>> However, the previous patch introduce klp_ops into klp_func is a
>> optimization=20
>> methods of the patch introducing 'using' feature to klp_func.
>>=20
>> But now, we don't support 'using' feature to klp_func and make
>> 'klp_ops' patch
>> not necessary.
>>=20
>> Therefore, this new version is only introduce the sysfs feature of
>> klp_patch=20
>> 'stack_order'.
>=20
> The approach seems ok to me, but I would like to see selftests for =
this
> new attribute. We have been trying to add more and more selftests for
> existing known behavior, so IMO adding a new attribute should contain =
a
> new test to exercise the correct behavior.
>=20
> Other than that, for the series:
>=20
> Acked-by: Marcos Paulo de Souza <mpdesouza@suse.com>
>=20

Hi, Macros!

Thanks a lot.

I will add selftest case for it as soon as possible.

Regards.
Wardenjohn.

(This email is resent because it seemed not sent to LKML...)=

