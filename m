Return-Path: <live-patching+bounces-2734-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aM7iDgwT+mlRJAMAu9opvQ
	(envelope-from <live-patching+bounces-2734-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 17:55:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A854D0B54
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 17:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F3FD30AE066
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 15:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E222048A2D2;
	Tue,  5 May 2026 15:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H5how65a"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1432117A31E;
	Tue,  5 May 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996396; cv=none; b=njJGYDXucW/v+2+Ehg0tzHzZ8UncLyjgY8WCF00Xdjk4zWLDSvVKk1U2jcG5790UuiPYROLUa9xjYkkkKTRq1hxKAH4cjpaAkB0s6ICPHsHtSAQBQSKb/D48FHXVw3PPlc3dsj3snOm5R0saUOmzBdli+jYCvL1MKa1+O5snAe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996396; c=relaxed/simple;
	bh=ry3nOAMdyX0J5PlkVzMMmBRSCCtUysaxwoNl+k5rNIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1Wb/Es206FjPdjrJv4EEwxeP71cdP8aBPNt3LHblJCIIgQ8vn75/SxlYy2dAmpDtAvv0o+J17cTvX+f7xxK3LVOP7WqJ+BJjTAg2/9KLmVL7bmS4+4wRjRHs9CceCWbHMWNbB71tvtdO2WS0O0UhxUYNj2Inf7OcrUJQU1evQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H5how65a; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6456eQg72210426;
	Tue, 5 May 2026 15:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qTPucf
	f1OcRaH8p41wtQtL2nNN1l29mt+O6lmygoJuk=; b=H5how65atbtsGExrTj3K1i
	RbC2x43JcDDWGVxgUkZ05z7fBtMSU1v+rTbYHH/j4Tkc2B9Xy7b1EEokcWPMCAOM
	guP5gkYPaS/vadB9LxwB8i6Ls7TCmUNXKAyjJZAVO37RMbsL8CQhVrIYR7guVBH4
	z1MbkCtHjz8C4GJh8brq79hafuYIgoczFZNo2llW7WRK2sTI/RWsP+aI+/KIUmyl
	upKDpIRDNey6oLcRrVClw759whFFbvQHtH31UPwLOFss1WCUaefC7ziZdVWMuw0r
	lrOcDRxJ7BmliSG7i/Rwmgmw4/sDUnhjKKfZKHuO1n0p4gJgnW9INTwj5islcY1Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1cgym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 15:52:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645FdYpe000621;
	Tue, 5 May 2026 15:52:09 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjt9hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 15:52:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645Fq7sT40632690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 15:52:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 429442004D;
	Tue,  5 May 2026 15:52:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C35A02004B;
	Tue,  5 May 2026 15:52:06 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 15:52:06 +0000 (GMT)
Message-ID: <0467ad27-597d-4a9b-8760-3d833db9e909@linux.ibm.com>
Date: Tue, 5 May 2026 17:52:06 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
To: Mark Rutland <mark.rutland@arm.com>, Indu Bhagat <ibhagatgnu@gmail.com>
Cc: Dylan Hatch <dylanbhatch@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
 <bc3fb59b-9d80-4957-af51-20db38e3487e@linux.ibm.com>
 <afnGhsCYEUG0LXR5@J2N7QTR9R3>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <afnGhsCYEUG0LXR5@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: btys5mnl4WfVy2UMJxK1PIM1GiIYR5im
X-Proofpoint-GUID: c0T6Pe8IjgKKI8tpEppxq_E65t8BWFSW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDE1MCBTYWx0ZWRfXzXBmdvq523EX
 y6pe7v6MnoWerMoZ/O7PqQyKRCH8zvWbQd/mSIUuAXv5volySdOzk3Ues3OxjnbUnZDvcYR2E09
 AFFFmVrc6+Ubg9LSK1Khl0dNYDm873cW3G/QwIaz36UHy07KtB61Oo08GBSPVB/A91B7lx/vMWt
 pCF3u8fabwuY4/JONbrqsCuJY3k69ZPLzQmVIcqU4o8CX1QT/zeZ3BljwJD469lAY8Pl8AYMs8m
 G/uB39/fRED8W/Qa5DZh/LnfBde7ZNca5MNmRQyrJWphaZ1rrL277ef92kMswDNgsXkj4qpqiZF
 ovY5vL5WB55anyIXwgr8io8YTw+WtLWXiSfDW2WCR5EsMl9BvCj5jckoE0WAgE39MSYFUg6PR0w
 RJY39rref+UKBGRgIPDeyqRuCPP0OnRhNrNGqekVMrjwFT1V2eIm9Dn0Dom7bgT/Nu+4OwJp7Hh
 5M1GXGS5YOEGGbLhGZQ==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fa122a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=CCpqsmhAAAAA:8
 a=nZ40scU-AAAA:20 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=9h9s3HjQZqLWgSDt43oA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ul9cdbp4aOFLsgKbc677:22
 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050150
X-Rspamd-Queue-Id: 85A854D0B54
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2734-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[arm.com,gmail.com];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sourceware.org:url];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]

On 5/5/2026 12:29 PM, Mark Rutland wrote:
> On Mon, May 04, 2026 at 10:47:26AM +0200, Jens Remus wrote:
>> On 5/1/2026 6:46 PM, Mark Rutland wrote:

>>> Thanks for putting this together. I think this is looking pretty good.
>>> However, there are some things that aren't quite right and need some
>>> work, which I've commented on below.
>>
>>> (2) To make unwinding generally possible, we'll need to annotate some
>>>     assembly functions as unwindable. We'll need to do that for string
>>>     routines under lib/, and probably some crypto code, but we don't
>>>     need to do that for most code in head.S, entry.S, etc.
>>>
>>>     The vast majority of relevant assembly functions are leaf functions
>>>     (where the return address is never moved out of the LR), so we can
>>>     probably get away with a simple annotation for those that avoids the
>>>     need for open-coded CFI directives everywhere.
>>
>> Wrapping them in .cfi_startproc ... .cfi_endproc should do.  For instance
>> by extending SYM_FUNC_START() and SYM_FUNC_END() or introducing flavors
>> that do.  Or where you thinking of something else?
> 
> I was expecting we'd do something like that, either with distinct
> versions, or some entirely separate annotation.
> 
> We can't override SYM_FUNC_START() or SYM_FUNC_END() since those are
> also used for non-leaf functions. The bulk of the work is going to be
> making sure we only annotate leaf functions specifically, which will
> require some human analysis.

Makes sense.

>>> On Tue, Apr 28, 2026 at 06:36:43PM +0000, Dylan Hatch wrote:
>>>> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
>>
>>>> @@ -21,6 +21,8 @@ struct stack_info {
>>>>   *
>>>>   * @fp:          The fp value in the frame record (or the real fp)
>>>>   * @pc:          The lr value in the frame record (or the real lr)
>>>> + * @sp:          The sp value at the call site of the current function.
>>>> + * @unreliable:  Stacktrace is unreliable.
>>>>   *
>>>>   * @stack:       The stack currently being unwound.
>>>>   * @stacks:      An array of stacks which can be unwound.
>>>> @@ -29,7 +31,11 @@ struct stack_info {
>>>>  struct unwind_state {
>>>>  	unsigned long fp;
>>>>  	unsigned long pc;
>>>> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
>>>> +	unsigned long sp;
>>>> +#endif
>>>
>>> As this is only used by the kernel unwinder (and not the hyp unwinder),
>>> this should live in struct kunwind_state in stacktrace.c.
>>>
>>> That said, for unwinding across exception boundaries we should not need
>>> this, as the SP value will be in the pt_regs. If we only use SFrame for
>>> the exception boundary case, we can remove this entirely. I would
>>> strongly prefer that we do that.
> 
>>>> +	/* Get the Canonical Frame Address (CFA) */
>>>> +	switch (frame.cfa.rule) {
>>>> +	case UNWIND_CFA_RULE_SP_OFFSET:
>>>> +		cfa = state->common.sp;
>>
>> IIUC you suggest this to be changed as follows?
>>
>> 		cfa = regs->regs[31];
> 
> I was suggesting:
> 
> 		cfa = regs->sp;
> 
> Note: arm64's struct pt_regs has:
> 
> 	union {
> 		struct user_pt_regs user_regs;
> 		struct {
> 			u64 regs[31];
> 			u64 sp;
> 			u64 pc;
> 			u64 pstate;
> 		};
> 	};	
> 
> ... so regs->regs[31] would be an out-of-bounds array access.

Aww, my bad!  Of course!

> 
> [...]
> 
>>>> +	case UNWIND_CFA_RULE_REG_OFFSET:
>>>> +	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
>>>> +		/* regs only available in topmost/interrupt frame */
>>>> +		if (!regs || frame.cfa.regnum > 30)
>>>> +			return -EINVAL;
>>>> +		cfa = regs->regs[frame.cfa.regnum];
>>>> +		break;
>>>
>>> Do we ever expect to see UNWIND_CFA_RULE_REG_OFFSET or
>>> UNWIND_CFA_RULE_REG_OFFSET_DEREF in practice for kernel code?
>>
>> No.  Those can only occur with SFrame V3 flexible FDE, which are
>> currently not generated by GNU assembler for arm64/aarch64, and thus
>> could be omitted in the arm64-specific kernel sframe unwinder:
>>
>> https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=gas/config/tc-aarch64.h;hb=binutils-2_46#l342
> 
> Ok.
> 
> Do we know whether there are currently cases on aarch64 that cannot be
> encoded in SFrame (without flexible FDE), or whether SFrame without
> flexible FDE is sufficient for arm64 as-is? ... or do we have
> counter-examples today?

Not that I am aware of.  IIUC this is why Indu, the SFrame maintainer,
did not enable SFrame V3 flexible FDE for arm64/aarch64 in the GNU
assembler.

> Looking at:
> 
>   https://sourceware.org/binutils/docs/sframe-spec.html#Flexible-FDE-Type-Interpretation-1
> 
> For arm64 I'm not sure whether we'd encounter the DRAP or stack
> realignment cases within the kernel (perhaps with SVE?), nor whether the
> Register-based RA/FP Locations cases would apply if we assume that we
> continue to use frame records.

@Indu:  Can you provide more insight?

> [... ]
> 
>> I must admit that while reviewing I thought it would be future-proof to
>> have support for rules that can only be represented with SFrame V3
>> flexible FDE, even if they are currently not used on arm64.  Ideally
>> kunwind_next_sframe() could be made common, if another architecture
>> would implement kernel unwinding using sframe.
> 
> While I understand that principle, I think that for now it would be
> better to keep this arch-specific and minimal:
> 
> * We have arch-specific concerns (e.g. the FRAME_META_TYPE_FINAL
>   frames), and factoring that into generic code is going to be painful
>   to adapt (which we're likely to need to do in the near future), and to
>   maintain going forwards. Keeping that arch-specific for now will make
>   it easier/quicker to get to a stable state.
> 
> * Code which isn't used is liable to be wrong or made wrong by accident.
>   For example, with all the SP cases I mentioned in my initial reply.
> 
> We can certainly look at making that more generic in future, but for now
> I'd prefer to omit the code that cannot be used (and have some sort of
> build or boot/module-load time check that SFrame only has elements that
> we expect), and make sure that we thoroughly test the cases that do
> exist in practice.

Makes sense.

> Do we expect SFrame V3 flexible FDE to be generated by toolchains in the
> near future?

There is work in progress to implement SFrame V3 generation in LLVM.
Their implementation could be less restrictive regarding to which
SFrame V3 feature to enable on arm64/aarch64.  But even then for
SFrame V3 flexible FDE to be generated there must be DWARF CFI patterns
that can only be represented using those.  So if those do not exist
(see your previous question above), then they should not be generated.

@Indu:  What are your thoughts on this?

> [...]
> 
>>>> +	/* CFA alignment 8 bytes */
>>>> +	if (cfa & 0x7)
>>>> +		return -EINVAL;
>>>
>>> If the CFA is the SP upon entry to the function, then per AAPCS64 rules
>>> it should be aligned to 16 bytes. Otherwise, where has this 8 byte
>>> alignment requirement come from? Does SFrame mandate that?
>>
>> That originates from the common unwind user logic (see
>> kernel/unwind/user.c, unwind_user_next_common()), which currently
>> assumes 8-byte/4-byte SP alignment for all 64-bit/32-bit architectures.
>>
>> So checking for 16-byte alignment here would make sense.
> 
> Just to confirm, am I correct to understand that the SFrame definition
> of CFA is intended to be the same as the DWARF definition of CFA, and so

Correct.

> for arm64 the CFA is the SP when the function is called?

Correct.

> 
> That's the case for DWARF on arm64:
> 
>   https://github.com/ARM-software/abi-aa/releases/download/2025Q4/aadwarf64.pdf
>   https://github.com/ARM-software/abi-aa/blob/daa7a94ca55973736c0e434a67a6e4bbcd35d7fa/aadwarf64/aadwarf64.rst
> 
> | The CFA is the value of the stack pointer (sp) at the call site in the
> | previous frame.
> 
> I couldn't find an explciit statement to that effect in:
> 
>   https://sourceware.org/binutils/docs/sframe-spec.html
> 
> ... but I guess that is implied, given the other bits inherited from
> DWARF.

I assume so.

> 
> I see that the documented behaviour for CFA on AMD64 and s390x are
> consistent with their DWARF behaviour.

Yes.

> 
>>>> +
>>>> +	/* Get the Return Address (RA) */
>>>> +	switch (frame.ra.rule) {
>>>> +	case UNWIND_RULE_RETAIN:
>>>> +		/* regs only available in topmost/interrupt frame */
>>>> +		if (!regs)
>>>> +			return -EINVAL;
>>>> +		ra = regs->regs[30];
>>>> +		source = KUNWIND_SOURCE_REGS_LR;
>>>> +		break;
>>>> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
>>
>> Nit: s/UNWIND_USER_RULE_CFA_OFFSET/UNWIND_RULE_CFA_OFFSET/
>>
>>>
>>> It would be better for the comment to say *why* that's not implemented.
>>>
>>> I assume that's because UNWIND_USER_RULE_CFA_OFFSET would mean that the return
>>> address is a stack address, and that's obviously not legitimate.
>>
>> That and SFrame V3 currently cannot represent FP/RA as CFA + offset
>> (i.e. UNWIND_RULE_CFA_OFFSET; .cfi_val_offset FP/RA).
>>
>> The comment originates from the common unwind user logic (see
>> kernel/unwind/user.c).  I am open to improve that.  What about:
>>
>> 	/*
>> 	 * UNWIND_RULE_CFA_OFFSET not implemented on purpose, as a stack
>> 	 * address cannot be a legitimate return address value.  It is
>> 	 * also not used (e.g. not represented in sframe).
>> 	 */
> 
> I'd go with something simpler, e.g.
> 
> 	/*
> 	 * UNWIND_RULE_CFA_OFFSET doesn't make sense for RA.
> 	 * The return address cannot legitimately be a stack addres.
> 	 */

Thanks!  I have updated the comments accordingly in my latest unwind
user sframe patch series sent today:

[PATCH v14 14/19] unwind_user: Flexible FP/RA recovery rules
https://lore.kernel.org/all/20260505121718.3572346-15-jremus@linux.ibm.com/

[...]

>>>> +	default:
>>>> +		WARN_ON_ONCE(1);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	/* Get the Frame Pointer (FP) */
>>>> +	switch (frame.fp.rule) {
>>>> +	case UNWIND_RULE_RETAIN:
>>>> +		fp = state->common.fp;
>>>> +		break;
>>>> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
>>>
>>> As for RA, the comment should explain why that's not implemented.
>>
>> I am open to improve the comment in the the common unwind user logic.
>> What about:
>>
>> 	/*
>> 	 * UNWIND_RULE_CFA_OFFSET not implemented on purpose, as it is
>> 	 * not used (e.g. not represented in sframe).
>> 	 */
> 
> For me, this wording raises more questions, e.g.
> 
> * Does 'not used' mean that toolchains don't use that, or that the spec
>   doesn't permit that?

unwind user currently only supports frame pointer, with SFrame to be
hopefully added soon.  Out of these only SFrame requires ("uses") these
elaborated rules.

> 
> * Does 'not represented' mean that this is not represntable, or that
>   toolchains currently don't generate SFrame with the appropriate
>   elements.

In DWARF CFI it is representable using .cfi_val_offset <FP>, <offset>.
But SFrame V3 currently cannot represent this:

"Note that, using a value of 0 as padding data word, does mean that
currently, e.g., for RA [JR: FP likewise], the rule RA = CFA + 0 cannot
be encoded.  NB: RA = CFA + 0 is distinct from RA = *(CFA + 0)."

https://sourceware.org/binutils/docs/sframe-spec.html#Flexible-FDE-Type-Interpretation-1

> 
> IIUC you're saying that this *is* representable with flexible FDE, but
> current toolchains don't generate that.

Thanks for the feedback!  I changed it as follows to clarify:

	/*
	 * UNWIND_USER_RULE_CFA_OFFSET is currently not used for FP
	 * (e.g. SFrame cannot represent this rule).
	 */

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


