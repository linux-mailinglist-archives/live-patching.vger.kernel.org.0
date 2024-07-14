Return-Path: <live-patching+bounces-391-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C18C4930BEC
	for <lists+live-patching@lfdr.de>; Mon, 15 Jul 2024 00:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153011F211DF
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 22:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393AE3BB23;
	Sun, 14 Jul 2024 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Q+7b26gi"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8537E8495
	for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720994893; cv=none; b=uuhFrqWeGFXQsEX5nqJG+vVn2oahFBOKaiwkWWsWBN3VRt8nEAHDt6WmwPTZe5d4IxHv5VpD03ErpuTPF6njTzITfb+pb4XNTIHeZKNUSs/BwgV9wqXLXhFPhHP0sSeAMnXFIY2cK1PGkcDmgwS9NckhnQR9RrxRVLDmkYCMV4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720994893; c=relaxed/simple;
	bh=Ml4ZI3GPvXuiwW3loMihRPLZxwAx2NOdPiaHixZBFb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tycnxg95EhXjb5Z2ItnBryAnprBra2/MZL7VI3xobQcZuuDkdBlQ/Gh/FeMEw9mm2B8+riEoQArZvVp41odNFCdWYGPV6/LYItn6Mh7i0uoVe0ZT6CJGsACmMKbb3QRlKJgKVBjF80vFtJQuXhQrlv7cwb/R+zjZslFp9vQNGw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Q+7b26gi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46ELD0bO027179;
	Sun, 14 Jul 2024 22:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dpQmQ/jYrEU1Ju+XmTTJ9CPUCIaOX1IBtL9mcDpFpJU=; b=Q+7b26giWryWPhhh
	Lv3+KQPOzpSU3ABY84hwyi9iGtlcT13aaRj2ndu+NrSHhNHL/RoNuN+fXmN6MCpA
	UHOlD2fUpEhCfjvUJE/4z99L0yGgMdxFQXyqHkFkNob5XWhqYHzaUyTdJ8deUxwy
	1x89gix01jVFyDTVLVWGLuQcmYu7BKvY5jLjc1gE4QTve+dTQlbk1LxLKZw8vJEk
	/qgkwtdNgUSjLJL1hb/c3dwlPaoMUL+StXnelIsFN6TcEWJGWb98bb4BTIYF18Oh
	uJtEEVB6gX0jYZ/aAdpyk1WDXvFnpgB31wMs+9knABZlC6tnXpa+fhREL2ibukE4
	BSJozA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40bgwg2beq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 14 Jul 2024 22:07:55 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46EM7sGn022964
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 14 Jul 2024 22:07:54 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 14 Jul
 2024 15:07:53 -0700
Message-ID: <b1a173a1-de6c-4959-b735-8171975d0d38@quicinc.com>
Date: Sun, 14 Jul 2024 15:07:53 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] [PATCH] livepatch: support of modifying refcount_t
 without underflow after unpatch.
To: <raschupkin.ri@gmail.com>, <live-patching@vger.kernel.org>,
        <joe.lawrence@redhat.com>, <pmladek@suse.com>, <mbenes@suse.cz>,
        <jikos@kernel.org>, <jpoimboe@kernel.org>
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
 <20240714195958.692313-2-raschupkin.ri@gmail.com>
Content-Language: en-US
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240714195958.692313-2-raschupkin.ri@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _J1kofPoLpaJtMdiKyHMZ8Kr6YTQrT4s
X-Proofpoint-ORIG-GUID: _J1kofPoLpaJtMdiKyHMZ8Kr6YTQrT4s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-14_15,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1011 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407140176

On 7/14/24 12:59, raschupkin.ri@gmail.com wrote:
> From: Roman Rashchupkin <raschupkin.ri@gmail.com>
> 
> CVE fixes sometimes add refcount_inc/dec() pairs to the code with existing refcount_t.
> Two problems arise when applying live-patch in this case:
> 1) After refcount_t is being inc() during system is live-patched, after unpatch the counter value
> will not be valid, as corresponing dec() would never be called.
> 2) Underflows are possible in runtime in case dec() is called before
> corresponding inc() in the live-patched code.
> 
> Proposed kprefcount_t functions are using following approach to solve these two problems:
> 1) In addition to original refcount_t, temporary refcount_t is allocated, and after
> unpatch it is just removed. This way system is safe with correct refcounting while patch is applied,
> and no underflow would happend after unpatch.
> 2) For inc/dec() added by live-patch code, one bit in reference-holder structure is used
> (unsigned char *ref_holder, kprefholder_flag). In case dec() is called first, it is just ignored
> as ref_holder bit would still not be initialized.
> 
> Signed-off-by: Roman Rashchupkin <raschupkin.ri@gmail.com>
> ---
>   include/linux/livepatch_refcount.h | 19 +++++++
>   kernel/livepatch/Makefile          |  2 +-
>   kernel/livepatch/kprefcount.c      | 89 ++++++++++++++++++++++++++++++
>   3 files changed, 109 insertions(+), 1 deletion(-)
>   create mode 100644 include/linux/livepatch_refcount.h
>   create mode 100644 kernel/livepatch/kprefcount.c
> 
> diff --git a/include/linux/livepatch_refcount.h b/include/linux/livepatch_refcount.h
> new file mode 100644
> index 000000000000..02f9e7eeadb2
> --- /dev/null
> +++ b/include/linux/livepatch_refcount.h
> @@ -0,0 +1,19 @@
> +#ifndef __KP_REFCOUNT_T__
> +#define __KP_REFCOUNT_T__
> +
> +#include <linux/refcount.h>
> +
> +typedef struct kprefcount_struct {
> +	refcount_t *refcount;
> +	refcount_t kprefcount;
> +	spinlock_t lock;
> +} kprefcount_t;
> +
> +kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags);
> +void kprefcount_free(kprefcount_t *kp_ref);
> +int kprefcount_read(kprefcount_t *kp_ref);
> +void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
> +void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
> +bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
> +
> +#endif
> diff --git a/kernel/livepatch/Makefile b/kernel/livepatch/Makefile
> index cf03d4bdfc66..8ff0926372c2 100644
> --- a/kernel/livepatch/Makefile
> +++ b/kernel/livepatch/Makefile
> @@ -1,4 +1,4 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   obj-$(CONFIG_LIVEPATCH) += livepatch.o
>   
> -livepatch-objs := core.o patch.o shadow.o state.o transition.o
> +livepatch-objs := core.o patch.o shadow.o state.o transition.o kprefcount.o
> diff --git a/kernel/livepatch/kprefcount.c b/kernel/livepatch/kprefcount.c
> new file mode 100644
> index 000000000000..6878033c5ddc
> --- /dev/null
> +++ b/kernel/livepatch/kprefcount.c
> @@ -0,0 +1,89 @@
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/version.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/refcount.h>
> +#include <linux/livepatch_refcount.h>
> +
> +MODULE_LICENSE("GPL");
> +

Note that "make W=1" will generate a warning if a module doesn't have a 
MODULE_DESCRIPTION().

I've been fixing the existing warnings tree-wide and am hoping to 
prevent new instances from appearing.

One way I've been doing this is by searching lore for patches which add 
a MODULE_LICENSE() but which do not add a MODULE_DESCRIPTION() since 
that is a common sign of a missing description.

But in this specific case it seems the MODULE_LICENSE() may be the issue 
since I don't see how kprefcount.c could ever be built as a module. So 
in this specific case it seems as if the MODULE_LICENSE() should be removed.

Note that none of the other kernel/livepatch/*.c files have a 
MODULE_LICENSE(), and CONFIG_LIVEPATCH is a bool and hence does not 
support being built as a module.

/jeff

