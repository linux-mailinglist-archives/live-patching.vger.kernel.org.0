Return-Path: <live-patching+bounces-2366-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YO0UB6/u4Gl4ngAAu9opvQ
	(envelope-from <live-patching+bounces-2366-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:14:07 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77AA940F6E9
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFE683094D22
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 14:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEDC3DFC86;
	Thu, 16 Apr 2026 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RgjVHinU"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB383DEACC;
	Thu, 16 Apr 2026 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776348621; cv=none; b=nAOiCg1qPzka9ok4OuIW4353ZEvne6rInvd7o/U2tTcRum4WYTKf2mlsRjziw7lFCKNQIdfy3jBCwJhN+PUJ/rns9D0gsgCDA7CByFcl85982fYZJMRN94kFQzaIOoo7UNZTnqf3znzq3a47je8PADd9xDuOqpJH1F6AvDLBxos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776348621; c=relaxed/simple;
	bh=PgoJMWFZZMDoRZiPpe8F2cyTVnVgYg0UpumfvnWJoL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Doc2GBKFT4OgGeGKaqQpkTfP6lABqV8d7tINOT051eDtpUAQ/sYwM1jaVJTdhYgrMCpVqo2Cz12mwQ1CQiYAV1dpjcn9qnnMpLrsRyTuJGYvhmfE42rxxsfgMdi5d2VDhimY1GsCzdjpDP1MzEXoi4QL/ZhcpMrSA0Mwp34dGqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RgjVHinU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G9n7TV1833223;
	Thu, 16 Apr 2026 14:09:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5bZFO/
	ATD56HUcWaef/684HTeBS057i0wylAFAirXVc=; b=RgjVHinU04ToUnjOesbBne
	lYE3sPOTg06LlBCJNZqTr/FnchZKKavVwKUTG2G3LnCSL0nz2WE4BOUEcO3gBAXB
	vWiHN/Tq0djeztB1M4eyGdV7j0I9q7F6tw0WRu4nKFGzMqRgNvynkSimtV3ATiFc
	PNpj1/iA4SPgmNW0Y2e5dFBkSHKWGNgO1QnxkNSvbqMJtUA8e+TXmYMyd6+HUgvR
	g3AJper26ANO0klMGM9Qfy6Q8IefdhnMxG3Z7xXgXZlPRIzURfMuEEs29vY/eSLU
	cmJSYzEjIrov7p9Bx3hyiMh6qDZPQwb+YvtSGXtkKrxYpDXCasGRK7jKcMohbYjQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89rnu06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 14:09:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63GAqLum015164;
	Thu, 16 Apr 2026 14:09:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0msuceh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 14:09:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63GE9pV550921886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 14:09:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88B1B2004B;
	Thu, 16 Apr 2026 14:09:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A95020040;
	Thu, 16 Apr 2026 14:09:50 +0000 (GMT)
Received: from [9.111.199.83] (unknown [9.111.199.83])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 14:09:50 +0000 (GMT)
Message-ID: <2891ad39-20c2-4c21-8a74-4a09032421e2@linux.ibm.com>
Date: Thu, 16 Apr 2026 16:09:48 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] arm64: entry: add unwind info for various kernel
 entries
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
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-4-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-4-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEzMiBTYWx0ZWRfX7wUwuGzmgzsP
 /KEso6kqsNQqn+I8+hB9aNbbXGrrh/Nv9K9VjMnSfROHSDUWFPIwqvZfeHbtkl0zJVBeAwBuVvA
 15doAB5Y4qG+chKjxZP91ej3OVavcK/0A97+c+SmKDMK8n0VYbw+fIWA0i8QqKVMcTitXOVlFoa
 d/zp0Ws54vAyjl674t9SwDjw5pkTyGItFP84ZPjyaKe2nABPqM/aHc4H15YhKO2QWQ8iwdw2mBO
 AvoyDcx/bf4TGoyFpjHyU0wo2tQSz8MkwEDXG6naCqbQ+dmCawB9KTgGPdMPhxO4pFuOS23CJ25
 B7eZbi77c42hXgeOPmQKlfcWNH0RdonWBTda3FmQv+/O2W/ad9ldoi7Z268SIwq5TSaKzdhcefA
 4DSAV48asEkdp0LF83SYvM9yABibP0opNgS4RQstmE/4KTCMDqWYVVHQurFxAsFF+ttisSaXSXP
 Lf/PV1MNYJe3CryMi7A==
X-Proofpoint-ORIG-GUID: 4Gha3kbwBkiKeqQfF-mKgAuzYTE4yDcp
X-Proofpoint-GUID: Y3Vo8Hhn1UhIuSvCotDIhk7Si54VAtsB
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69e0edb4 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=bLnNlr2ELYzO25Cx3yEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160132
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2366-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 77AA940F6E9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Dylan and Weinan!

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> From: Weinan Liu <wnliu@google.com>
> 
> DWARF CFI (Call Frame Information) specifies how to recover the return
> address and callee-saved registers at each PC in a given function.
> Compilers are able to generate the CFI annotations when they compile
> the code to assembly language. For handcrafted assembly, we need to
> annotate them by hand.
> 
> Annotate CFI unwind info for assembly for interrupt and exception
> handlers.

It took me a while to figure, why CFI annotations are uncommonly only
added to selected instruction (ranges) and not the whole functions.  I
guess you only want to enable stacktracing using SFrame through
el1*_64_*() (from el1*_64_*_handler()) and call_on_irq_stack(), that is
why the added CFI annotations start after the bl/blr instructions, so
that whenever an unwound return address points after those bl/blr
SFrame can recover the stack pointer, frame pointer, and return address.

Wouldn't that be worth to be documented in the commit message?

> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S

> @@ -575,7 +575,12 @@ SYM_CODE_START_LOCAL(el\el\ht\()_\regsize\()_\label)
>  	.if \el == 0
>  	b	ret_to_user
>  	.else

	/* Minimal DWARF CFI for unwinding across call above. */

> +	.cfi_startproc
> +	.cfi_def_cfa_offset PT_REGS_SIZE
> +	.cfi_offset 29, S_FP - PT_REGS_SIZE
> +	.cfi_offset 30, S_LR - PT_REGS_SIZE
>  	b	ret_to_kernel
> +	.cfi_endproc
>  	.endif
>  SYM_CODE_END(el\el\ht\()_\regsize\()_\label)
>  	.endm

> @@ -889,6 +894,10 @@ SYM_FUNC_START(call_on_irq_stack)
>  	add	sp, x16, #IRQ_STACK_SIZE
>  	restore_irq x9
>  	blr	x1

	/* Minimal DWARF CFI for unwinding across indirect call above. */

> +	.cfi_startproc
> +	.cfi_def_cfa 29, 16
> +	.cfi_offset 29, -16
> +	.cfi_offset 30, -8
>  
>  	save_and_disable_daif x9
>  	/*
> @@ -900,6 +909,7 @@ SYM_FUNC_START(call_on_irq_stack)
>  	scs_load_current
>  	restore_irq x9
>  	ret
> +	.cfi_endproc
>  SYM_FUNC_END(call_on_irq_stack)
>  NOKPROBE(call_on_irq_stack)

While above minimal DWARF CFI works for your use case, the following
minor issue should probably be better corrected (excerpt from
call_on_irq_stack with your patch applied):

	blr	x1
	.cfi_startproc
	.cfi_def_cfa 29, 16   <-- CFA is defined as FP + 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8

	save_and_disable_daif x9
	/*
	 * Restore the SP from the FP, and restore the FP and LR from the frame
	 * record.
	 */
	mov	sp, x29
	ldp	x29, x30, [sp], #16   <-- FP is restored, so that the CFA definition is no longer valid
[CORRECTION]
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa 31, 0
[/CORRECTION]
	scs_load_current
	restore_irq x9
	ret
	.cfi_endproc
SYM_FUNC_END(call_on_irq_stack)


Would it alternatively make sense to add complete DWARF CFI annotations
to call_on_irq_stack()?  I think the following would do:

SYM_FUNC_START(call_on_irq_stack)
	.cfi_startproc
...
	/* Create a frame record to save our LR and SP (implicit in FP) */
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	.cfi_def_cfa 29, 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
...
	/*
	 * Restore the SP from the FP, and restore the FP and LR from the frame
	 * record.
	 */
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa 31, 0
...
	ret
	.cfi_endproc
SYM_FUNC_END(call_on_irq_stack)

Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


