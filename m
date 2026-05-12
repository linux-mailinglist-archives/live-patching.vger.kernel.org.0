Return-Path: <live-patching+bounces-2742-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMSOH7HtAmryygEAu9opvQ
	(envelope-from <live-patching+bounces-2742-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 11:06:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 87BF151D457
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 11:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4D553306434D
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 08:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336883A5E8F;
	Tue, 12 May 2026 08:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jn0XbJgJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259939E6EB;
	Tue, 12 May 2026 08:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778576203; cv=none; b=q889chqTi/wo96d6dR30KHYbAPW7zV6uz+UNov6pdjthYNDDcoiCaGtI+BXX1u4ROOehM39iEMvlhe6r9fxndoo6fSHdnjavGcjp6x5nAX9QaYUncT52DKX3+Ss/cEtj/mGN+X1/BxY3S7OQH4qHrbBb7RIGaDAlGtZ3yucdICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778576203; c=relaxed/simple;
	bh=TMkJDM+gyKHYfpQ800Ppm76L+LrNH/drSmY0lb/WXjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuJXAlHivJ6eJ3m/ZdqEPKYRIcuC2UqYiCR5go/sjl0NKGProSvxhVxHbxpI6ZFvyxcM06/Wmc1vSmr1RNEojOS+A2w+JuGcogHk6mAQGSvKNGJ+5bnc4ZLhy4AOj8Dupmv667tweTKknzgYBgOh0gbxvPVc2915uKwKjPdlcN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jn0XbJgJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BK74IO3179453;
	Tue, 12 May 2026 08:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qG8oe8
	z9sxMMUyor2T7pysVRE2qkXzHzDQe0MhODf5I=; b=Jn0XbJgJMXIbZier46PZCD
	1Emzb7CkLbBHBzHez1MSnqwfcIcz959PdIhksNDc3cuXu9ukkA+sVrYyp9iAxQ9Y
	mZvuXOqDklUbdqaF4bDqYwdT3nqyGnctRec1Apx8L52IfDBd5tzV1pV7dFGYugGT
	OZSbrPXsN+tR7CJEEFOyPj5IPJlWK2Q5wIly6qPjATt60UM33PYstDXTmC4AIoyy
	BMQLD+0K9jRs6eZFEG5x7Vz3I739JrrIlJKe5wN/08/1qc26nXZz2sMoyaNEHpau
	iE9y1haORy6wrlaC5K5GbvhhoKv+yil3eq6esGFP24Xwg56Kw28Obo0N2UVsOO1w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e3nv6j3wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 08:55:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64C8sV9a024634;
	Tue, 12 May 2026 08:55:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e3nfgtdap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 08:55:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64C8tTpv25100836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 May 2026 08:55:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA5972004B;
	Tue, 12 May 2026 08:55:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F2FF20040;
	Tue, 12 May 2026 08:55:29 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 May 2026 08:55:29 +0000 (GMT)
Message-ID: <0542f042-14fb-4588-bc3a-5031249d9834@linux.ibm.com>
Date: Tue, 12 May 2026 10:55:28 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
To: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
        Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com>
 <afTYzAF_x41pyilu@J2N7QTR9R3>
 <CADBMgpx9YxNUO6wLP7mYKxWW8L78Hk9gPwHrMjXUwPyUmGEu9w@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpx9YxNUO6wLP7mYKxWW8L78Hk9gPwHrMjXUwPyUmGEu9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Us1T8ewB c=1 sm=1 tr=0 ts=6a02eb05 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=7CQSdrXTAAAA:8 a=pbiPq8VqF0LfWx_iDpQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: uaHr7nwzr83LXGrb9KDOQt7khmo6iJZR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA4NiBTYWx0ZWRfX6MHUaow91jQs
 Y3MxrcX7t4Mr1vZvD8FzelZHzDowUFqS9L3BLeQtklVqqiyO54C9bZLgId8VHGENrTMf5ZxjxRu
 iv6GmwcM3Hd9NSb87unpoNEzxJ1FHQ7NBBpTjRazCdj4Mjwu8vN4JYm+ilRnjyNJ+3WYsmdFBPJ
 SQpla5QHjgCq6CES9w/SCaunqWa0Sffh78Fc+mgqnfIlxPWkfgBFpJhnPJNXRZSVrCWN5JdUDpn
 wMEXPbHTRN8naneqSYgncazvqJRV/q6Sc937dTOXSgr69N64IKs4bDKMLvwHIXZ3ZvG1FISrOgA
 LvF9/sGmqj4np6S2xhjRRFvPXbpHxw6vMsTsV3Sdbrlcsy/uNgqH2iuVIPFCZ8JrBg0hH14e+49
 QT/hw1Hg7e9OAEAGLAAutNYGNeXD+lN1sKzoMlD2EauzEgFBiowsoU87aUyKlJJ/JizrkzF7J/3
 Qijeiq81p5MwfRUX0Zg==
X-Proofpoint-ORIG-GUID: HRl52iudk8zwHmSdjLV0b5-DZVW86Cil
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605120086
X-Rspamd-Queue-Id: 87BF151D457
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	TAGGED_FROM(0.00)[bounces-2742-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,arm.com:email,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Hello Dylan and Mark!

On 5/12/2026 5:00 AM, Dylan Hatch wrote:
> On Fri, May 1, 2026 at 9:46 AM Mark Rutland <mark.rutland@arm.com>
> wrote:

>> More generally, there are a few things that aren't addressed by
>> this series that we will also need to address. Importantly:
>> 
>> (1) For correctness, we'll need to address a latent issue with
>> unwinding across an fgraph return trampoline, where the return
>> address is transiently unrecoverable.
>> 
>> Before this series, that doesn't matter for livepatching because
>> the livepatching code isn't called synchronously within the fgraph 
>> handler, and unwinds which cross an exception boundary are marked
>> as unreliable.
>> 
>> After this series, that does matter as we can unwind across an 
>> exception boundary, and might happen to interrupt that transient 
>> window.
>> 
>> I think we can solve that with some restructuring of that code, 
>> restoring the original address *before* removing that from the 
>> fgraph return stack, and ensuring that the unwinder can find it.
> 
> If my understanding is correct, the issue arrises in
> return_to_handler as the return address is recovered:
> 
> mov x0, sp bl ftrace_return_to_handler // addr =
> ftrace_return_to_hander(fregs); mov x30, x0 // restore the original
> return address
> 
> Because ftrace_return_to_handler pops the return address from the 
> return stack before it can be restored into the LR, it cannot be 
> recovered.

Based on reliable-stacktrace.rst section "4.4 Rewriting of return
addresses" I wonder whether the following might work:

- If an unwound RA points at return_to_handler the actual RA needs to
  be obtained using ftrace_graph_ret_addr().  This might already be
  taken into account if ftrace_graph_ret_addr() is used unconditionally.

- If an unwound RA points into return_to_handler() mark the stack trace
  as unreliable.  This could be accomplished by marking LR in
  return_to_handler() as undefined (i.e. .cfi_undefined 30) to use
  SFrame's outermost frame indication to stop and mark the stack trace
  as unreliable:

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
@@ -329,8 +329,12 @@ SYM_FUNC_END(ftrace_stub_graph)
  * @fp is checked against the value passed by ftrace_graph_caller().
  */
 SYM_CODE_START(return_to_handler)
+       .cfi_startproc
+       /* Mark unwinding of LR as unreliable */
+       .cfi_undefined 30
        /* Make room for ftrace_regs */
        sub     sp, sp, #FREGS_SIZE
+       .cfi_adjust_cfa_offset -FREGS_SIZE

        /* Save return value regs */
        stp     x0, x1, [sp, #FREGS_X0]
@@ -344,6 +348,8 @@ SYM_CODE_START(return_to_handler)
        mov     x0, sp
        bl      ftrace_return_to_handler        // addr = ftrace_return_to_hander(fregs);
        mov     x30, x0                         // restore the original return address
+       /* Mark unwinding of LR as reliable */
+       .cfi_restore 30

        /* Restore return value regs */
        ldp     x0, x1, [sp, #FREGS_X0]
@@ -351,7 +357,9 @@ SYM_CODE_START(return_to_handler)
        ldp     x4, x5, [sp, #FREGS_X4]
        ldp     x6, x7, [sp, #FREGS_X6]
        add     sp, sp, #FREGS_SIZE
+       .cfi_adjust_cfa_offset FREGS_SIZE

        ret
+       .cfi_endproc
 SYM_CODE_END(return_to_handler)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */

Notes regarding above:
- return_to_handler() saves the caller's FP in ftrace_regs but never
  restores it.  I suppose this is because ftrace_regs is an input to
  ftrace_return_to_handler().  The DWARF CFI above assumes SP and FP
  can be restored at all times as SP=CFA and FP=FP.
- One might be tempted to add a .cfi_register 30, 0 after the call to
  ftrace_return_to_handler.  This would be wrong, because if unwinding
  comes from ftrace_return_to_handler() the unwound RA will point there
  and the unwinding logic would erroneously assume x0 to contain the RA.
- The DWARF CFI could be simplified as follows to just convey that
  unwinding through return_to_handler is impossible at all times:

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
@@ -329,6 +329,9 @@ SYM_FUNC_END(ftrace_stub_graph)
  * @fp is checked against the value passed by ftrace_graph_caller().
  */
 SYM_CODE_START(return_to_handler)
+       .cfi_startproc simple
+       /* Mark unwinding of LR as unreliable */
+       .cfi_undefined 30
        /* Make room for ftrace_regs */
        sub     sp, sp, #FREGS_SIZE

@@ -353,5 +356,6 @@ SYM_CODE_START(return_to_handler)
        add     sp, sp, #FREGS_SIZE

        ret
+       .cfi_endproc
 SYM_CODE_END(return_to_handler)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */

> 
> Based on this, I believe you are suggesting to restructure this code 
> path such that the return address is removed from the return stack 
> only after it has been restored to LR. But since kernel/trace/
> fgraph.c is core kernel code, will this end up requiring either (1)
> a similar restructuring of other arches supporting ftrace, or (2) an 
> arm64-specific implementation of this recovery logic?
> 
> It looks to me like there is essentially the same recovery pattern
> on other arches; is there a reason this transient unrecoverability
> isn't an issue for reliable unwind on other platforms?
> 
>> 
>> I'm not immediately sure whether kretprobes has a similar issue.

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


