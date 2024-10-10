Return-Path: <live-patching+bounces-727-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E3999860C
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2024 14:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8562F1F214C0
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2024 12:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293421C460F;
	Thu, 10 Oct 2024 12:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V5t0wMOz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E851C2457
	for <live-patching@vger.kernel.org>; Thu, 10 Oct 2024 12:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728563516; cv=none; b=nTWYuOE9pjEQy5Nq57FN7E9owoQkkQynX35Kz8dwG+Q8nU3DHMzG1LhcUy5rujTDE1DsVOVTi/K0wiaLB6F6/iX9uZp+r3TO6D+WtHQ5kiM9gMBKNbcfwnPF8mkQ+GvCH9pGk6YSAwiy9cr3HfRYwtSKQH9I8QJ4f1Q4JFlMG/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728563516; c=relaxed/simple;
	bh=c11A/XXP2WzoIPdE4HYgPE5p6Pl1DbotJKHSAN69Nxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sI/iBytoPLDPEWaDrt+QqVOkucs2HTlFejXDnM0VMp+8yhbePxfE6/F62PDjFp2KE/rkO26wGfRfHDXCQ4F+FtirBUjJ5JEdrfd1q8jh0TRAsNZiAdSXmBIyUJ9j2trQbfH0WbPu4qq/6Qj8uhfg7E593ky4c8IGIgNsfTicfKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V5t0wMOz; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c896b9b4e0so1112187a12.3
        for <live-patching@vger.kernel.org>; Thu, 10 Oct 2024 05:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728563512; x=1729168312; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i00+tlk4mfyWBRDoWPDZnWruZu2qaQ8UaM3uG2ALdoE=;
        b=V5t0wMOzgtUBrQdRIIFQD2/iMjZ2dZfqE1DN7sTi9mVFRRPe6RMrsedcLMtHKshPYH
         5dK6aPq53nYBX3ADZKuBEzISxJErxdiTBuGLjIlIFzPrkPMaoIjCTSY7zGYwgK10qB8W
         fS1hutUEsnZYI2qzUwwnLOCSClp+Y71cNawXy7EdXaWcExwCkf6KLZ5QZWDhyhDCo+5m
         8RMbHTVtt6tsyKBRQywqiKwlUcrfTS4Zsma7JGCcAuac0X80iYjb4kG+B31k3WZlc4SN
         1mQjSUGOgoYCzImvKhCDOmigfyWCyVtZkyXAZ+Mb+GWLrW6RYo0Rbx28T6GfJak2pHjt
         zYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728563512; x=1729168312;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i00+tlk4mfyWBRDoWPDZnWruZu2qaQ8UaM3uG2ALdoE=;
        b=Rw1Vj+y+M2A/OZM0I8XrZeuoQIVXeRwJTWQeobtA5njOGUhMc3+qzrTNGGMuWXswM0
         B3ccbF+Wg8U+Zy8xGDqAGCHGhDBSbuwAq3XPCsvkJnUKo9xDvgLjVdaqR2q2hrp88xI0
         xqcazccyAwGxwahOiijpkpFUYQb26zJHRtx60tBgWTlmTOmzdMDnMxKKkwYgB4XExxJZ
         IulVVZr1TN/tZVG5W4i1/Bv+eZwSmM3qWs/MkZyl8kjgHc3GViGZAncIdT5rOrvn3tN4
         kPXFgvoakAbUTpNre5gQQs9R+nLCCwh+bXQT5zIEt1b3iOeRh26MSZLILv3161LQyxCR
         B2IA==
X-Gm-Message-State: AOJu0YyS6MhfbrSg0mINv+WXKp4KF5TjLVsVMwE14KXvWfEMUYrtcF1M
	OlClH/LOKdzD0rbYtg+IQOFbve/PJzUHbCQiZNRROQSjFiaUtrsWZGvxsWLOxkc=
X-Google-Smtp-Source: AGHT+IGie4+Zg6o0Nh6mpie38stwtUpyzEbjyWMPC33p1QSWb8USkok26cll6pwexQdpvwTJTYjD5w==
X-Received: by 2002:a17:907:3e14:b0:a99:37f5:de59 with SMTP id a640c23a62f3a-a998d34ba62mr543881466b.53.1728563511855;
        Thu, 10 Oct 2024 05:31:51 -0700 (PDT)
Received: from [192.168.3.3] (151.36.160.45.gramnet.com.br. [45.160.36.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a7f5b0aasm83665366b.92.2024.10.10.05.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 05:31:51 -0700 (PDT)
Message-ID: <0d554ea7bd3f672d80a2566f9cbe15a151372c32.camel@suse.com>
Subject: Re: [PATCH 1/1] selftests: livepatch: add test cases of stack_order
 sysfs interface
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>, jpoimboe@kernel.org, mbenes@suse.cz,
 	jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Oct 2024 09:31:45 -0300
In-Reply-To: <20241008075203.36235-2-zhangwarden@gmail.com>
References: <20241008075203.36235-1-zhangwarden@gmail.com>
	 <20241008075203.36235-2-zhangwarden@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-10-08 at 15:52 +0800, Wardenjohn wrote:
> Add selftest test cases to sysfs attribute 'stack_order'.
>=20
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
> =C2=A0.../testing/selftests/livepatch/test-sysfs.sh | 71
> +++++++++++++++++++
> =C2=A0.../selftests/livepatch/test_modules/Makefile |=C2=A0 5 +-
> =C2=A0.../test_klp_livepatch_noreplace.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 53 ++++++++++++++
> =C2=A0.../test_klp_livepatch_noreplace2.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 53 ++++++++++++++
> =C2=A0.../test_klp_livepatch_noreplace3.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 53 ++++++++++++++
> =C2=A05 files changed, 234 insertions(+), 1 deletion(-)
> =C2=A0create mode 100644
> tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_nor
> eplace.c
> =C2=A0create mode 100644
> tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_nor
> eplace2.c
> =C2=A0create mode 100644
> tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_nor
> eplace3.c

IIUC, you only need to test the stack order by loading LP modules. In
this case you could use our currently existing LP testing module for
that, right? That's what we currently do when testing different sysfs
attributes.

>=20
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh
> b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 05a14f5a7bfb..a086b62fb488 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -5,6 +5,9 @@
> =C2=A0. $(dirname $0)/functions.sh
> =C2=A0
> =C2=A0MOD_LIVEPATCH=3Dtest_klp_livepatch
> +MOD_LIVEPATCH_NOREPLACE=3Dtest_klp_livepatch_noreplace
> +MOD_LIVEPATCH_NOREPLACE2=3Dtest_klp_livepatch_noreplace2
> +MOD_LIVEPATCH_NOREPLACE3=3Dtest_klp_livepatch_noreplace3
> =C2=A0
> =C2=A0setup_config
> =C2=A0
> @@ -131,4 +134,72 @@ livepatch: '$MOD_LIVEPATCH': completing
> unpatching transition
> =C2=A0livepatch: '$MOD_LIVEPATCH': unpatching complete
> =C2=A0% rmmod $MOD_LIVEPATCH"
> =C2=A0
> +start_test "sysfs test stack_order read"
> +
> +load_lp $MOD_LIVEPATCH_NOREPLACE
> +
> +check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "-r--r--
> r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "1"
> +
> +load_lp $MOD_LIVEPATCH_NOREPLACE2
> +
> +check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE2" "stack_order" "-r--r-
> -r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH_NOREPLACE2" "stack_order" "2"
> +
> +load_lp $MOD_LIVEPATCH_NOREPLACE3
> +
> +check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "-r--r-
> -r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "3"
> +
> +disable_lp $MOD_LIVEPATCH_NOREPLACE2
> +unload_lp $MOD_LIVEPATCH_NOREPLACE2
> +
> +check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "-r--r--
> r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "1"
> +check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "-r--r-
> -r--"
> +check_sysfs_value=C2=A0 "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "2"
> +
> +disable_lp $MOD_LIVEPATCH_NOREPLACE3
> +unload_lp $MOD_LIVEPATCH_NOREPLACE3
> +
> +disable_lp $MOD_LIVEPATCH_NOREPLACE
> +unload_lp $MOD_LIVEPATCH_NOREPLACE
> +
> +check_result "% insmod test_modules/$MOD_LIVEPATCH_NOREPLACE.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH_NOREPLACE'
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': initializing patching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': starting patching transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': completing patching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH_NOREPLACE2.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH_NOREPLACE2'
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': initializing patching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': starting patching transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': completing patching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH_NOREPLACE3.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH_NOREPLACE3'
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': initializing patching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': starting patching transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': completing patching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': patching complete
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH_NOREPLACE2/enabled
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': initializing unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': starting unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': completing unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE2': unpatching complete
> +% rmmod $MOD_LIVEPATCH_NOREPLACE2
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH_NOREPLACE3/enabled
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': initializing unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': starting unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': completing unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE3': unpatching complete
> +% rmmod $MOD_LIVEPATCH_NOREPLACE3
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH_NOREPLACE/enabled
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': initializing unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': starting unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': completing unpatching
> transition
> +livepatch: '$MOD_LIVEPATCH_NOREPLACE': unpatching complete
> +% rmmod $MOD_LIVEPATCH_NOREPLACE"
> +
> =C2=A0exit 0
> diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile
> b/tools/testing/selftests/livepatch/test_modules/Makefile
> index e6e638c4bcba..dad6ca00d3e6 100644
> --- a/tools/testing/selftests/livepatch/test_modules/Makefile
> +++ b/tools/testing/selftests/livepatch/test_modules/Makefile
> @@ -11,7 +11,10 @@ obj-m +=3D test_klp_atomic_replace.o \
> =C2=A0	test_klp_state2.o \
> =C2=A0	test_klp_state3.o \
> =C2=A0	test_klp_shadow_vars.o \
> -	test_klp_syscall.o
> +	test_klp_syscall.o \
> +	test_klp_livepatch_noreplace.o \
> +	test_klp_livepatch_noreplace2.o \
> +	test_klp_livepatch_noreplace3.o \
> =C2=A0
> =C2=A0# Ensure that KDIR exists, otherwise skip the compilation
> =C2=A0modules:
> diff --git
> a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace.c
> b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace.c
> new file mode 100644
> index 000000000000..ead609aeac67
> --- /dev/null
> +++
> b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/livepatch.h>
> +
> +#include <linux/seq_file.h>
> +static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
> +		=C2=A0=C2=A0 "this has been live patched with number 1");
> +	return 0;
> +}
> +
> +static struct klp_func funcs[] =3D {
> +	{
> +		.old_name =3D "cmdline_proc_show",
> +		.new_func =3D livepatch_cmdline_proc_show,
> +	}, { }
> +};
> +
> +static struct klp_object objs[] =3D {
> +	{
> +		/* name being NULL means vmlinux */
> +		.funcs =3D funcs,
> +	}, { }
> +};
> +
> +static struct klp_patch patch =3D {
> +	.mod =3D THIS_MODULE,
> +	.objs =3D objs,
> +	.replace =3D false,
> +};
> +
> +static int test_klp_livepatch_init(void)
> +{
> +	return klp_enable_patch(&patch);
> +}
> +
> +static void test_klp_livepatch_exit(void)
> +{
> +}
> +
> +module_init(test_klp_livepatch_init);
> +module_exit(test_klp_livepatch_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");
> +MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
> +MODULE_AUTHOR("Wardenjohn <zhangwarden@gmail.com>");
> +MODULE_DESCRIPTION("Livepatch test: livepatch module");
> diff --git
> a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace2.c
> b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace2.c
> new file mode 100644
> index 000000000000..8d54b0976be1
> --- /dev/null
> +++
> b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace2.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/livepatch.h>
> +
> +#include <linux/seq_file.h>
> +static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
> +		=C2=A0=C2=A0 "this has been live patched with number 2");
> +	return 0;
> +}
> +
> +static struct klp_func funcs[] =3D {
> +	{
> +		.old_name =3D "cmdline_proc_show",
> +		.new_func =3D livepatch_cmdline_proc_show,
> +	}, { }
> +};
> +
> +static struct klp_object objs[] =3D {
> +	{
> +		/* name being NULL means vmlinux */
> +		.funcs =3D funcs,
> +	}, { }
> +};
> +
> +static struct klp_patch patch =3D {
> +	.mod =3D THIS_MODULE,
> +	.objs =3D objs,
> +	.replace =3D false,
> +};
> +
> +static int test_klp_livepatch_init(void)
> +{
> +	return klp_enable_patch(&patch);
> +}
> +
> +static void test_klp_livepatch_exit(void)
> +{
> +}
> +
> +module_init(test_klp_livepatch_init);
> +module_exit(test_klp_livepatch_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");
> +MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
> +MODULE_AUTHOR("Wardenjohn <zhangwarden@gmail.com>");
> +MODULE_DESCRIPTION("Livepatch test: livepatch module");
> diff --git
> a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace3.c
> b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace3.c
> new file mode 100644
> index 000000000000..a267c58e07d4
> --- /dev/null
> +++
> b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_n
> oreplace3.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/livepatch.h>
> +
> +#include <linux/seq_file.h>
> +static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
> +		=C2=A0=C2=A0 "this has been live patched with number 3");
> +	return 0;
> +}
> +
> +static struct klp_func funcs[] =3D {
> +	{
> +		.old_name =3D "cmdline_proc_show",
> +		.new_func =3D livepatch_cmdline_proc_show,
> +	}, { }
> +};
> +
> +static struct klp_object objs[] =3D {
> +	{
> +		/* name being NULL means vmlinux */
> +		.funcs =3D funcs,
> +	}, { }
> +};
> +
> +static struct klp_patch patch =3D {
> +	.mod =3D THIS_MODULE,
> +	.objs =3D objs,
> +	.replace =3D false,
> +};
> +
> +static int test_klp_livepatch_init(void)
> +{
> +	return klp_enable_patch(&patch);
> +}
> +
> +static void test_klp_livepatch_exit(void)
> +{
> +}
> +
> +module_init(test_klp_livepatch_init);
> +module_exit(test_klp_livepatch_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");
> +MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
> +MODULE_AUTHOR("Wardenjohn <zhangwarden@gmail.com>");
> +MODULE_DESCRIPTION("Livepatch test: livepatch module");


