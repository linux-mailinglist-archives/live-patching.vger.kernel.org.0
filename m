Return-Path: <live-patching+bounces-602-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E9396C997
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 23:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8E1D1C223CD
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 21:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C83914EC4E;
	Wed,  4 Sep 2024 21:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Hj8s6+If"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C4F148310;
	Wed,  4 Sep 2024 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725485910; cv=none; b=UlIsYi6IkhuzMxmezCEIpigx1ukU0TRE7C89rqJHJCNyiMXIcCxKHWSa+XPSHUgDzwvV9CfjvaSaSORJZ2WTYU66ucZsu5aP7RZpw3KpMcnKNZbgh3sb+Gxr0uEvJkAF+5zZ/RMlZn4qZASd1L0FqJFxqofj8BUzd68lNN2bYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725485910; c=relaxed/simple;
	bh=HKTpzy2GKueIMmNhB7YJg998UIcRr3hdbWG8yYlET+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=K81aI/gd3GwEmBDR1VssjKvtjF6IMeaj6K2EDQW43Lij/nie9sD52Xxm5U6UcF+MmdRgnF8voqbSafud8ODfxkWy5Dnq0iu15CKctjR+sFpBL0r2bptYND36jX0SBSf6/kQoO32W8xzhqQx4WxWZmqUOHHyChYmR7tBzP/GhFA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Hj8s6+If; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 484A25Vp014730;
	Wed, 4 Sep 2024 21:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HKTpzy2GKueIMmNhB7YJg998UIcRr3hdbWG8yYlET+Y=; b=Hj8s6+Ifbr0swFKZ
	AUZ+kGxq5s94Khg9Nt/ADaYWQsOsgNWF8YKUXqd6/xK3EL/7s+ijmGIwjDsOY8rR
	mJbAGyPlzOGIScSSXYv7bDt25i+cEaCLsRoSVU8DntoESb4lBPqwJyfmUXH4zYKZ
	svBRX5KVgpR18dDV6G4+QBplTGloY/rhYmiH3zaOhFSWEEn+lRu4Qzs/w6g+94d9
	pGHXx2KMu49RGCeC1T6nv1gBlXdzSVKtXmLBg3j2DQwYz8rIqaJwGHSr5BO2P3NO
	d5w03dMFCMSCZ2NOt3NL3QvYh+NMcWr8b2Sbontt+DDj0x5qNN0ct3b27IyXIkVa
	KyusaQ==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41btrxv1ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Sep 2024 21:38:17 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 484LcGib001444
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 21:38:16 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 4 Sep 2024
 14:38:15 -0700
Message-ID: <f23503e2-7c2d-40a3-be09-f6577b334fad@quicinc.com>
Date: Wed, 4 Sep 2024 14:38:14 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 31/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>, <live-patching@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Miroslav Benes
	<mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence
	<joe.lawrence@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Song Liu
	<song@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <9ceb13e03c3af0b4823ec53a97f2a2d82c0328b3.1725334260.git.jpoimboe@kernel.org>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Content-Language: en-US
In-Reply-To: <9ceb13e03c3af0b4823ec53a97f2a2d82c0328b3.1725334260.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 7yWLhjIFQ0bnw-tsKJB75QnTrLUNcdB_
X-Proofpoint-ORIG-GUID: 7yWLhjIFQ0bnw-tsKJB75QnTrLUNcdB_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-04_19,2024-09-04_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 suspectscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=942 spamscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2409040162

On 9/2/24 21:00, Josh Poimboeuf wrote:
...
> diff --git a/scripts/livepatch/module.c b/scripts/livepatch/module.c
> new file mode 100644
> index 000000000000..101cabf6b2f1
> --- /dev/null
> +++ b/scripts/livepatch/module.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Base module code for a livepatch kernel module
> + *
> + * Copyright (C) 2024 Josh Poimboeuf <jpoimboe@kernel.org>
> + */
...
> +module_init(livepatch_mod_init);
> +module_exit(livepatch_mod_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");

Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
description is missing"), a module without a MODULE_DESCRIPTION() will
result in a warning when built with make W=1. Recently, multiple
developers have been eradicating these warnings treewide, and very few
are left. Not sure if this would introduce a new one, so just want to
flag it so that you can check and fix if necessary.

/jeff


