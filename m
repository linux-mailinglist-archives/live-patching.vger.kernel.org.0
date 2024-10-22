Return-Path: <live-patching+bounces-745-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D0A9A9D44
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2024 10:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D65691F2488B
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2024 08:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D661417B436;
	Tue, 22 Oct 2024 08:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfYjDcdq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441381714BA;
	Tue, 22 Oct 2024 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729586625; cv=none; b=cNEs9UWtFjNAduQ5ew+ijhZzrS/du6K9tLz4BG8nmxHNKMbRi7caKhz2mypKkJ0f1BvtpUdUJtV2Hr5klEAcwI1ttyhTIdeqvZXIoD3aghYjfzfbdpYOKA7UajkKKOLG1SB+xVOjR7ZtHHgZYmCErqC9wxmI/tfqno31Tlcqgzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729586625; c=relaxed/simple;
	bh=i/3loB0UpaOwH/DiiLpG2avm0YtvJp+AB7gwdlPzx3Y=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=vBcBjdjcp3Nyx21O4buISha9OidGIGIs6ry0hRiJwZxLo2XqIB1XGkQ9EC+NqVOhfhE8Fz1ubt0riv8TgaZB7/exgbTMdAAWNEk+1chVUxgUSERGGcT61r9+L8qar6jRSb+ojVFkvjFsWQI3OxU+Bo3DfUVAHp6mBvJWgq+OSoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfYjDcdq; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2887abeefbdso2708990fac.0;
        Tue, 22 Oct 2024 01:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729586623; x=1730191423; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkvtSZ6iSFB/Xscs8hqajHGBFxNCLbsQ5pIyyc8o5Es=;
        b=CfYjDcdqrZLrViDIFbM6YH7htZLLIGL/yHxJWSj1bAoK2MClzI/VlnlQCo0IVXFpWy
         OwFSAUEYlazQJQDo65GGHtZ5Tw0of0D5LuhfP7FQ1LbBIYaMqh3BImu0FzccaAoQAMVY
         8YCr0fSsKAPk43oVXODjIGVbPKw2AFyVGl7Dqj3jORKeIq98Af2A4GThEqUo7Bjjgw6Z
         jiSBM7iu7/Dvwj922aJRxY794CGicdgNkZNDaeFiV8fbyM88v+mDx0cZ8jEhW4qEFGLu
         zLpDHgyyvit4Tx80m1R5r2yu+rFVxLz4rBEffFJJuFOpTzutL8GifBUMU2en5MF31Iwl
         5oSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729586623; x=1730191423;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkvtSZ6iSFB/Xscs8hqajHGBFxNCLbsQ5pIyyc8o5Es=;
        b=ay2mwDrsYswibBhrTfa91DWQgZWx6B1JtABx9puiuUFLLm30rsaJE8IJi9U/Eun/cv
         PE05jWq1m91larJcNqSEfarOmoPLuoL33sxOrPWcltLsXiIkG3D/234pPczUkC+sTclj
         8gDItl7/2qVzIuvg0ENgJtmb9p5ZmSsg/ooWRV1/JUlUeo4MnHbfcBaw5go0X6EfCVV/
         mSinx7E/YsK2+rBZ2Nosgq/7gDmB5i404/6AhqUOgdEfJVgMa8HT+0GrkqXBkME73evU
         4+YBUX+o+lrqGf2gyuVtAAIew/get+99PbHxj8NcOBRmlU+JKpShMUhyx0mozXLqJLvd
         H01A==
X-Forwarded-Encrypted: i=1; AJvYcCXsE7e5ExQVdOgE/vHnBT3GtGwuY/88XZSaHPiDs4cPRXi3AsE+XaOfjAFTbpR3VRHVvpYB5JCO9iMardg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd8Lm53RcBhW8j39Y6CuZ1OoY+e550LPw8wmPhgS31/1bSFGX6
	DP1BDbrKiGSlsuXj4sExksPWDmnAavKwmXF6UcyfmwC3OresO35Y
X-Google-Smtp-Source: AGHT+IGPx34CGVqUhQtFiTx8fd/ldtXMG6nAdpJjtzaf+xX5yH/N8BO5cC0X1CmgWHAiJ2W/1VjPCw==
X-Received: by 2002:a05:6870:418e:b0:277:f301:40d5 with SMTP id 586e51a60fabf-2892c4f161emr11273688fac.31.1729586623287;
        Tue, 22 Oct 2024 01:43:43 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec13ea284sm4356386b3a.146.2024.10.22.01.43.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2024 01:43:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] selftests: livepatch: add test cases of stack_order sysfs
 interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20241011151151.67869-2-zhangwarden@gmail.com>
Date: Tue, 22 Oct 2024 16:43:24 +0800
Cc: live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EDEF6A38-5EDD-49C3-B8B5-158116957C47@gmail.com>
References: <20241011151151.67869-1-zhangwarden@gmail.com>
 <20241011151151.67869-2-zhangwarden@gmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Oct 11, 2024, at 23:11, Wardenjohn <zhangwarden@gmail.com> wrote:
>=20
> Add selftest test cases to sysfs attribute 'stack_order'.
>=20
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
> .../testing/selftests/livepatch/test-sysfs.sh | 74 +++++++++++++++++++
> 1 file changed, 74 insertions(+)
>=20
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh =
b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 05a14f5a7bfb..71a2e95636b1 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -5,6 +5,8 @@
> . $(dirname $0)/functions.sh
>=20
> MOD_LIVEPATCH=3Dtest_klp_livepatch
> +MOD_LIVEPATCH2=3Dtest_klp_callbacks_demo
> +MOD_LIVEPATCH3=3Dtest_klp_syscall
>=20
> setup_config
>=20
> @@ -131,4 +133,76 @@ livepatch: '$MOD_LIVEPATCH': completing =
unpatching transition
> livepatch: '$MOD_LIVEPATCH': unpatching complete
> % rmmod $MOD_LIVEPATCH"
>=20
> +start_test "sysfs test stack_order read"
> +
> +load_lp $MOD_LIVEPATCH
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> +
> +load_lp $MOD_LIVEPATCH2
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
> +
> +load_lp $MOD_LIVEPATCH3
> +
> +check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
> +
> +disable_lp $MOD_LIVEPATCH2
> +unload_lp $MOD_LIVEPATCH2
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> +check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
> +
> +disable_lp $MOD_LIVEPATCH3
> +unload_lp $MOD_LIVEPATCH3
> +
> +disable_lp $MOD_LIVEPATCH
> +unload_lp $MOD_LIVEPATCH
> +
> +check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH'
> +livepatch: '$MOD_LIVEPATCH': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH': starting patching transition
> +livepatch: '$MOD_LIVEPATCH': completing patching transition
> +livepatch: '$MOD_LIVEPATCH': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH2.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH2'
> +livepatch: '$MOD_LIVEPATCH2': initializing patching transition
> +$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': starting patching transition
> +livepatch: '$MOD_LIVEPATCH2': completing patching transition
> +$MOD_LIVEPATCH2: post_patch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH3.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH3'
> +livepatch: '$MOD_LIVEPATCH3': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH3': starting patching transition
> +livepatch: '$MOD_LIVEPATCH3': completing patching transition
> +livepatch: '$MOD_LIVEPATCH3': patching complete
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
> +livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
> +$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
> +$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': unpatching complete
> +% rmmod $MOD_LIVEPATCH2
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH3/enabled
> +livepatch: '$MOD_LIVEPATCH3': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH3': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH3': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH3': unpatching complete
> +% rmmod $MOD_LIVEPATCH3
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> +livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': unpatching complete
> +% rmmod $MOD_LIVEPATCH"
> +
> exit 0
> --=20
> 2.43.5
>=20

Hi, maintainers.

Any suggestions of this selftest case?

Regards.
Wardenjohn=

