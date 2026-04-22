Return-Path: <live-patching+bounces-2422-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMgyKUvY6Gl7QwIAu9opvQ
	(envelope-from <live-patching+bounces-2422-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:16:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA0F44728C
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE7D33071C48
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 14:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24120282F3A;
	Wed, 22 Apr 2026 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M+L8bbl5"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4033ED10B;
	Wed, 22 Apr 2026 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776867141; cv=none; b=FDEL+svPn3l4WFsULg8PDJpSRBsBCcrLdKqvB0CTmAipCBu2QNonAlKgZCCP07mqyy4E2gvzF4NTiEpLg108MITYKRXATXhHfw+bJg6ocU9FLLzlSAykUUjc+jYhk7yRadToY/vSPbYp4+gj/cTba1+4k1JZPDBpRGzxPMzOOT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776867141; c=relaxed/simple;
	bh=qtA0cBvUUAnjRw6rKM7hV3R1h2KxhJJoXeyFBhvT6Rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qhsWQzRQ2i93KXrOJ/A58OLRTx9/UcNivIZw3toIqETSXPP4Jwu5PsSolWwED9+4amm0gO3pFJZ2e2Zkvmjx4J/d56qB4tD3pzUGd4tvXDICyP56kKvtEju9FIlvL+y+GhvVY8Qntb1TYhJT2Zi83dVZJWBNld4fO5u2UnqW4TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M+L8bbl5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MArv2H680898;
	Wed, 22 Apr 2026 14:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iBprrZ
	6eKIHk++rrBYzLzxOMt1w4ppVybUIbzLKqRoo=; b=M+L8bbl5WscNzV3a9zCWVt
	hCcckUkQEtLzdTxX0Fyy39b3b4K4+jy7E/2gPpKFtfsNfFt9nyhADBc49O7edGDY
	1CcHbGAG2fs8BfXGvu8a1RyEoyMRsXGcqFvqmU07qy4RdjqY0KTAy8yhfIof2r1o
	4P85GAQOWT4EwvWCeYit1IfcfP/zRnF4AIZUtIy060p4QLvUL0ZV3IZw7ULqzccm
	jJIred3iuBUOdxag93t7ggWNXfL+Pi5wGj7f94/29J3SHH4t5YYKhaxvBdxPbhfX
	i54PRoLYCbJbhECvV7NPCjXKE9kNX1N78eqII3Go6ItwCFXAEDeK7cEth1d9gb/A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu7kk54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:11:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63ME5VF6005991;
	Wed, 22 Apr 2026 14:11:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjky2hc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:11:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63MEBE3n40042832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 14:11:14 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BF8120043;
	Wed, 22 Apr 2026 14:11:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3870120040;
	Wed, 22 Apr 2026 14:11:14 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Apr 2026 14:11:14 +0000 (GMT)
Message-ID: <73e99161-c246-467d-96c2-46911ffc0bff@linux.ibm.com>
Date: Wed, 22 Apr 2026 16:11:12 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION
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
 <20260421225200.1198447-8-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260421225200.1198447-8-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: _DoY1WMJM1i2En8WsHPlxJrHiE4hUwJb
X-Authority-Analysis: v=2.4 cv=Ksp9H2WN c=1 sm=1 tr=0 ts=69e8d705 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=LFt20mCCc4CE-LtB3JUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: _cCGz1_An0ZbsNzmrmsx3c9mP0RHxaLs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzMyBTYWx0ZWRfX9VUwGJuKKCGO
 3sUXKccE06d4FjNT8OI3/VtERQCx5iEk/lZ9QpvrEAS+Mi05cxDG6jm+2acwz+TvIZOB1iVvGvX
 VbcHqlx1Sad3Dd9V4ffOEVv9qmtrVi5kh6Si+B1prPGlqoTDOzZHs3MfJLAwMp8vCuzxp1Xqn0F
 v224CtXwAlPNYtzflIyN9g8aFsxOTOfpSMQT7porCm7n3AShgx0B171k9FsEC42XbEsEVN5j5JZ
 FgRz4mpEaP/rgJVVIWUj7AecGD/gRxNZhf6cDyNcrkiisoivrYMFk6/BcekfXJgeQRpZGh3xPEK
 goMiTdgg7qORKINe7h7Vnlo+5/22hYwt0nclE84TFeqh2GiecbEMkHLfMPYU/ESEO9oPbPmNMAs
 gO2QlwkwuORCALStWcNjeHGg4bP5YRFo/zzt8HN9CCdld83FwJTiOk0j+C/QUA+HXOEz8oYXme+
 9PcZgNB7lkSpN+48Ghw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 adultscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220133
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com];
	TAGGED_FROM(0.00)[bounces-2422-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MAILSPIKE_FAIL(0.00)[2600:3c0a:e001:db::12fc:5321:query timed out];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 0CA0F44728C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/2026 12:51 AM, Dylan Hatch wrote:
> Generalize the __safe* helpers to support a non-user-access code path.
> 
> This requires arch-specific function address validation. This is because
> arm64 vmlinux has an .rodata.text section which lies outside the bounds
> of the normal .text. It contains code that is never executed by the
> kernel mapping, but for which the toolchain nonetheless generates sframe
> data, and needs to be considered valid for a PC lookup.
> 
> This arch-specific address validation logic is only necessary to support
> SFRAME_VALIDATION for the vmlinux .sframe, since these .rodata.text
> functions would never be encountered during normal unwinding.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Suggested-by: Jens Remus <jremus@linux.ibm.com>

With the minor nit below fixed:

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> ---
>  arch/Kconfig                           |  2 +-
>  arch/arm64/include/asm/sections.h      |  1 +
>  arch/arm64/include/asm/unwind_sframe.h | 21 +++++++++++++++++++++
>  arch/arm64/kernel/vmlinux.lds.S        |  2 ++
>  include/linux/sframe.h                 |  2 ++
>  kernel/unwind/sframe.c                 | 25 +++++++++++++++++++++++--
>  6 files changed, 50 insertions(+), 3 deletions(-)

> diff --git a/arch/Kconfig b/arch/Kconfig
> @@ -503,7 +503,7 @@ config HAVE_UNWIND_USER_SFRAME
>  
>  config SFRAME_VALIDATION
>  	bool "Enable .sframe section debugging"
> -	depends on HAVE_UNWIND_USER_SFRAME
> +	depends on SFRAME_LOOKUP

	depends on UNWIND_SFRAME__LOOKUP

>  	depends on DYNAMIC_DEBUG
>  	help
>  	  When adding an .sframe section for a task, validate the entire

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


