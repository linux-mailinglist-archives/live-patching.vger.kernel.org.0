Return-Path: <live-patching+bounces-2406-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yKyGCcof5mkMsAEAu9opvQ
	(envelope-from <live-patching+bounces-2406-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 14:44:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A97E42AE3D
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 14:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 779C3303309C
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 12:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA5A3195EA;
	Mon, 20 Apr 2026 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bhyxUwi3"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3BF2D5925;
	Mon, 20 Apr 2026 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776689081; cv=none; b=KH5hdE3VLSM6CID8JcFHYCn5JirZXQrgV/sRc7JhshjQV+XBlPM48eb3O1jcSZA9FyA3WIcLB/2YpxNvKnKHg0sHzfDnjzs7sWsE5irPUZw6fW+NrKms8HF3Gh3NMhMa+Tq+s0t6NzyQl0APuqtHo8Fygx7IPH/7SB1ltpvmYpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776689081; c=relaxed/simple;
	bh=0GVMQRCNk3IkQf+GLhw6VfSlavnCehkORUgy2J6I4eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phv8j2Fv0ov1Q5MsLQRLwdh/lFVk/BGw0k6mljJvxjhzThVbc2xYGjH/cjwHgTb889VjO8SywqBndc8O7jTCrnBXKTqHkyffiexOsaPDQOTvYHjXpgl6ahUeVAlQKePC4FhJFLi8Wg6pvAJmy/E0kvYbJv/2dIFp3JnHIEN8R60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bhyxUwi3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JLe1or3165898;
	Mon, 20 Apr 2026 12:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1tCcUW
	C6qU6uPWXsn+OVIrVIIYDS6Dmo/IclqbbHj8k=; b=bhyxUwi3mMc4MAzmrWfdc7
	kWuuGTKGxH8sxb5mnYZ+KNzbiyaDO8UiZdESopktQYgaF6DWoYD0LEgqUcULtLM+
	SAhPMTTWv0jNwwG7/yRM9MK3ypa21c7uYmdyZDo7CeiXOYildXIudifhhywP8pk0
	WoBYI0uuJaaFKf6THPSsp+FbUUQxhieI7WH1YBHER+JLSi2BbjtsKvTYHBf4rcok
	xUptjBcHZ9kcn2rO1P2rDgAIWT9KHiNglLKuWEWd2UpIEvI5IRx7YmtHBUJepVZY
	JdiJk+nedzFPE6M9s3K+xZW1Myt+fYf59SKtm2A0H8uZD71VostajtU+EyaAebwQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k4ys6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:44:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63KCZX6i019696;
	Mon, 20 Apr 2026 12:44:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmm9pvvym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:44:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63KCiEdD37093846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:44:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADF312004B;
	Mon, 20 Apr 2026 12:44:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F124920049;
	Mon, 20 Apr 2026 12:44:12 +0000 (GMT)
Received: from [9.111.165.155] (unknown [9.111.165.155])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 12:44:12 +0000 (GMT)
Message-ID: <b526aeae-4243-4dca-907c-1f90b57e9cb7@linux.ibm.com>
Date: Mon, 20 Apr 2026 14:44:12 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] arm64, unwind: build kernel with sframe V3 info
To: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
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
        Heiko Carstens <hca@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-3-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-3-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: sYb2gOO-Kty_hcHJ4lggRM0jGT1GRwgl
X-Proofpoint-ORIG-GUID: N0mT8Q_-HvWlkK3pou6GvGjoGn0eYW_j
X-Authority-Analysis: v=2.4 cv=VP7tWdPX c=1 sm=1 tr=0 ts=69e61fa1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=ArCyXBQMZrod6OsQSOkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDEyMSBTYWx0ZWRfX70pvcDTs/5Fc
 Z4vrNYCmOf8wb89We6H2dW95tzwZuREzf5DAE7Cc1ReDjcbpNu7Y1Aisap+RYg0pW/wfOcc1ezg
 AKypvWmbIoigyi81EtHGrMPZYB8po7uuSVWZnVR4gjEXjVcYeP7IX2+h949i/23Ji7TsrDWhoNW
 3Lra4fs3xUqvYvN+CJU7TYhn+fNPw0wczl9EQU+3om+5X5CZyrE2NceAUyZQw6TGRCAABZi6Eyd
 lvLJcdvNGErwYSzfGTGa+lF+UaEFZ0nXphNSkmZglegaZmN5/XfJtSrKakT+SdSjW+ShSreuCzQ
 9IxyMusxMfpapu6jjfe4v5qCIOICJZjtuUtOXhJKr+S0lFmeXX4a3aUK/NHKLZMAVndxa5ibbuS
 q0GmAXlwPvSJFStVr8czU1mbaj73r0G4h+t/zgVTcx0XSgdEWmF6peSv3Pt0+/Df4AS9wXUqFvd
 MZlHVt5uuzCBpgcgRLg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200121
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2406-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 7A97E42AE3D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> Build with -Wa,--gsframe-3 flags to generate a .sframe section. This
> will be used for in-kernel reliable stacktrace in cases where the frame
> pointer alone is insufficient.
> 
> Currently, the sframe format only supports arm64, x86_64 and s390x
> architectures.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

> diff --git a/arch/arm64/include/asm/unwind_sframe.h b/arch/arm64/include/asm/unwind_sframe.h

> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_UNWIND_SFRAME_H
> +#define _ASM_ARM64_UNWIND_SFRAME_H
> +
> +#ifdef CONFIG_ARM64

Nit: If I am not mistaken above guard for CONFIG_ARM64 is superfluous,
as this resides in arch/arm64/ anyway.

x86 needs to guard with CONFIG_X86_64, as only x86 64-bit supports
SFrame (and not x86 32-bit nor x86 X32).

> +
> +#define SFRAME_REG_SP	31
> +#define SFRAME_REG_FP	29
> +
> +#endif
> +
> +#endif /* _ASM_ARM64_UNWIND_SFRAME_H */
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


