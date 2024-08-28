Return-Path: <live-patching+bounces-531-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC3996305C
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 20:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86597282E56
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 18:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1D61AAE21;
	Wed, 28 Aug 2024 18:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="GVPmTszr"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437DE1A7AEE;
	Wed, 28 Aug 2024 18:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724870642; cv=none; b=hE8O/aweP3vK6P8K/B/QseEq1mAivcDzInBMPa8U7FJUbIc9VYHIX0HcbRQOElTfgAj85oQnRrAllvIW56Nh+uVCU1QyCgq3m+SO74xO8gr3nWaVwtsX/767t340osLMIbLQfSMKiuuMxPFyad9VkmRAdLdzgTV+wj4G3rlL/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724870642; c=relaxed/simple;
	bh=r/BrICmDFELTA0iCFHy5sz4nQYE3i4WA/SAGsfEpxJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=I6aEH8+6lboAn+0kpNyoEK7mAOdLS4XLuRWw+UJIyKUvCpcHWacYUmTLYJETRgKZrWbTidjaQdgR0kvXxKsXKW4PPyFobSl1dGWY/H4HABzd331z9baCtwcyed/ALMb1ymyBl+KEt7M2EJ4OrpCMIK+BNW9jDDFoOcDGCHhBTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=GVPmTszr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47SBIdFc015470;
	Wed, 28 Aug 2024 18:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XdUGSlSO0ly1lyg8uLNnUS841FU2DjOf4WvaGhEUIWI=; b=GVPmTszrfYFTlZqc
	HBT2jJ0OosQLpQkhfepb+jLQ+7npnuhBLpxf896A1QfkgUlR0pB2zzkOID91LR/a
	KIiy6UrnyPHTNApLveMpoGFsa5gFtdTLLk60RQ9rWqK0eA90OrmnP+gD+oGsw1k8
	qoD1tVYlaQ6hiBybOVNjBx3m6BWRyqamIpPxKcFP1H7e5fvS1TbLPAqM5/DutvHD
	z5RfDKP6Q5O1sR30lgEqaLqSn314wJW7LzggIJjO2X+OEVSqfY62YdjzTTLxAZcY
	w4Eejl0sWde5cFJGL2HLe4pzGMHEpjDWmA3WwfkZxWVrDMZj+L7vL6972MB8N16q
	cPgDVA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419puttt35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:43:52 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47SIhplW030635
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:43:51 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 28 Aug
 2024 11:43:51 -0700
Message-ID: <f46b7c79-b4ef-4bdf-a449-87b3b4ac7def@quicinc.com>
Date: Wed, 28 Aug 2024 11:43:51 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] livepatch: Add sample livepatch module
To: Lukas Hruska <lhruska@suse.cz>, <pmladek@suse.com>, <mbenes@suse.cz>,
        <jpoimboe@kernel.org>
CC: <joe.lawrence@redhat.com>, <live-patching@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <mpdesouza@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>
References: <20240827123052.9002-1-lhruska@suse.cz>
 <20240827123052.9002-5-lhruska@suse.cz>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Content-Language: en-US
In-Reply-To: <20240827123052.9002-5-lhruska@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 4u1nOjZ1_M1Y488hWtZj-8555EIbwuna
X-Proofpoint-GUID: 4u1nOjZ1_M1Y488hWtZj-8555EIbwuna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_08,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1011 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408280136

On 8/27/24 05:30, Lukas Hruska wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> 
> Add a new livepatch sample in samples/livepatch/ to make use of symbols
> that must be post-processed to enable load-time relocation resolution.
> As the new sample is to be used as an example, it is annotated with
> KLP_RELOC_SYMBOL macro.
> 
> The livepatch sample updates the function cmdline_proc_show to print the
> string referenced by the symbol saved_command_line appended by the
> string "livepatch=1".
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> ---
>  samples/livepatch/Makefile                  |  1 +
>  samples/livepatch/livepatch-extern-symbol.c | 84 +++++++++++++++++++++
>  2 files changed, 85 insertions(+)
>  create mode 100644 samples/livepatch/livepatch-extern-symbol.c
> 
> diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
> index 9f853eeb6140..5cc81d5db17c 100644
> --- a/samples/livepatch/Makefile
> +++ b/samples/livepatch/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
> +obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-extern-symbol.o
> diff --git a/samples/livepatch/livepatch-extern-symbol.c b/samples/livepatch/livepatch-extern-symbol.c
> new file mode 100644
> index 000000000000..276a43d157b4
> --- /dev/null
> +++ b/samples/livepatch/livepatch-extern-symbol.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> + */
> +
> +/*
> + * livepatch-extern-symbol.c - Kernel Live Patching Sample Module
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/livepatch.h>
> +
> +/*
> + * This (dumb) live patch overrides the function that prints the
> + * kernel boot cmdline when /proc/cmdline is read.
> + *
> + * This livepatch uses the symbol saved_command_line whose relocation
> + * must be resolved during load time. To enable that, this module
> + * must be post-processed by a tool called klp-convert, which embeds
> + * information to be used by the loader to solve the relocation.
> + *
> + * The module is annotated with KLP_RELOC_SYMBOL macros.
> + * These annotations are used by klp-convert to infer that the symbol
> + * saved_command_line is in the object vmlinux.
> + *
> + * Example:
> + *
> + * $ cat /proc/cmdline
> + * <your cmdline>
> + *
> + * $ insmod livepatch-sample.ko
> + * $ cat /proc/cmdline
> + * <your cmdline> livepatch=1
> + *
> + * $ echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
> + * $ cat /proc/cmdline
> + * <your cmdline>
> + */
> +
> +extern char *saved_command_line \
> +	       KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line);
> +
> +#include <linux/seq_file.h>
> +static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%s livepatch=1\n", saved_command_line);
> +	return 0;
> +}
> +
> +static struct klp_func funcs[] = {
> +	{
> +		.old_name = "cmdline_proc_show",
> +		.new_func = livepatch_cmdline_proc_show,
> +	}, { }
> +};
> +
> +static struct klp_object objs[] = {
> +	{
> +		/* name being NULL means vmlinux */
> +		.funcs = funcs,
> +	}, { }
> +};
> +
> +static struct klp_patch patch = {
> +	.mod = THIS_MODULE,
> +	.objs = objs,
> +};
> +
> +static int livepatch_init(void)
> +{
> +	return klp_enable_patch(&patch);
> +}
> +
> +static void livepatch_exit(void)
> +{
> +}
> +
> +module_init(livepatch_init);
> +module_exit(livepatch_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");

Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
description is missing"), a module without a MODULE_DESCRIPTION() will
result in a warning when built with make W=1. Recently, multiple
developers have been eradicating these warnings treewide, and very few
are left, so please update your sample to include one as well.

/jeff


