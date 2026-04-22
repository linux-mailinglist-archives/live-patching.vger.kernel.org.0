Return-Path: <live-patching+bounces-2423-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGzrMFLY6Gl7QwIAu9opvQ
	(envelope-from <live-patching+bounces-2423-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:16:50 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 65195447293
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66712301C6DA
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 14:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B733ED5AD;
	Wed, 22 Apr 2026 14:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UQnH8TnH"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7782248B4;
	Wed, 22 Apr 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776867399; cv=none; b=U7Bo3AEW/HRYYc/q2W7eyvCnqwdQ5J4g6s9g1usbtjKVCkwtbdrSJILWEZwwbi7IyQ109VCXgim5hI/fvysokH5SDVN77DUO4jzAj4fXRdNUf6fntq8xsIChF5KQcH6cPe7iFsY+05qM93i1qP4w0Bwm0vpI0e4VGHKRPiBxq/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776867399; c=relaxed/simple;
	bh=YWbdECaLD3osM6HAlfsvRdcAATz41/V7EDa65/0zrQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Olu2+IHrxAUBBe3hnhZ/uQgrkPKUaa79xpBGS/GxSDkiXt9eZiWbBLgCdyXMvf77m0yhNWUJ6uV57xiWnU6trdyI/shCBE93aq7pYtfXN6yAxodE0lB7n38JLDyorVHMlO4zwhmXi06pXNDp3QUz0qa4VeYwSzn8erX5U5KDXmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UQnH8TnH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MBbegn590250;
	Wed, 22 Apr 2026 14:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TkXQ3W
	G17jeGU1K9f8Q4tq4XPE8kzzOuHGgvanLQtL0=; b=UQnH8TnHV5rDUNjRhpNO/k
	TQGNYMeomednyIZv4vzuu7k3DIb5hYPCTf74v83WvYoh/BHRp5JiDXGmKzmQrxhX
	fJuCT/e0EFxfozkZ4uzqWDCpuiMml2U/rmRkWLgml6evYV8+MYvqkAntZTHwmvzP
	ZDYtEB3jYc1PBoE9ntreKQ3IOv/m0vNEd9JQn5eC1rHD5w2lzSFc1RAk2TkYlWYy
	XCRR72i1m53BrcDJuzlgzZIKZWtZ0OCcIVXtG7Fkc7EX4z91qp6UjSUiT6V5NTcA
	geX8Hw9tGivCNFD5UmBUzhYpCtXrWSfLc7193gXAInUVg6xu6/cpDsckruNFM9vg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu23vn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:15:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63ME5JRb028017;
	Wed, 22 Apr 2026 14:15:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjkyahk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:15:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63MEFcTJ15270392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 14:15:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6E5B20043;
	Wed, 22 Apr 2026 14:15:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C6FC20040;
	Wed, 22 Apr 2026 14:15:38 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Apr 2026 14:15:38 +0000 (GMT)
Message-ID: <75ca4b07-68d3-47e0-b506-e1ac3e0adc1b@linux.ibm.com>
Date: Wed, 22 Apr 2026 16:15:36 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/8] arm64, unwind: build kernel with sframe V3 info
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260421225200.1198447-1-dylanbhatch@google.com>
 <20260421225200.1198447-3-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260421225200.1198447-3-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: t3HRqGGK_i_Yl4LaWFOvINcxtVGH9_97
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzMyBTYWx0ZWRfX2Xkqdbrw1uv8
 YX+9kZPJJWcZAaVKAs9Zwf5tUipKKt3Juj03jSorDvZO4VOscI10+1W9J33dWC7SpDPMG6HvsbD
 VO1qyLAP3Jusm3KvT80XAFnn0GcOWvUaaXYTqjUm8icjp1gM5cZAYrB26Aq0EPNNQ7qpFibcKsR
 yX+PhB/q2wj5VeduleoFEfRATazFFgln2dH+8xvZo/k34J6BZNexMIkyipe8KNZRfaBeEbzZXdI
 pvvgvFi6hOzDS3DQp9sV+7E00MQVUxt/GF3xZOQN18W/M9LoLf9bCmijag3h3mpEVE/DbS/Tay1
 qNrBIKIuS0JyVVfllgeOWOB89AqV66GNVC+xr3FcS3N3hbqeZ33+NnBjAVqSbTM5vC2sWmk9A0v
 WB/5nE8+P5Rp/VYQr4uqkJeRxl6B6jEeNrYUCcOiDrP73CVYQpIwp69nEEApYDdhspFid/zX3vd
 revydFaQjvxXrtRtYDQ==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69e8d80e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=OkMzWxJWX9Yub-M4blUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xRYr_-EYw2zLm_vWkwdVBgRvd_nJ0I-8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604220133
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com];
	TAGGED_FROM(0.00)[bounces-2423-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MAILSPIKE_FAIL(0.00)[172.105.105.114:query timed out];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 65195447293
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/2026 12:51 AM, Dylan Hatch wrote:
> Build with -Wa,--gsframe-3 flags to generate a .sframe section. This
> will be used for in-kernel reliable stacktrace in cases where the frame
> pointer alone is insufficient.
> 
> Currently, the sframe format only supports arm64, x86_64 and s390x
> architectures.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> ---
>  MAINTAINERS                            |  1 +
>  Makefile                               |  8 ++++++++
>  arch/Kconfig                           | 21 +++++++++++++++++++++
>  arch/arm64/Kconfig                     |  1 +
>  arch/arm64/include/asm/unwind_sframe.h |  8 ++++++++
>  arch/arm64/kernel/vdso/Makefile        |  2 +-
>  include/asm-generic/sections.h         |  4 ++++
>  include/asm-generic/vmlinux.lds.h      | 15 +++++++++++++++
>  8 files changed, 59 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/unwind_sframe.h
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


