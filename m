Return-Path: <live-patching+bounces-2693-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DckGdVd+GnatQIAu9opvQ
	(envelope-from <live-patching+bounces-2693-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 10:50:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D64804BA888
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 10:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 67EF9303D540
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 08:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0DE345749;
	Mon,  4 May 2026 08:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dAE87kWT"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245D3451A9;
	Mon,  4 May 2026 08:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777884495; cv=none; b=Z1VljTXAJb7bXd/WQ6EAzyFWKIimnlXlV2onxIaSec/STgb0d9xALvh2/iJSOcOR9KmzAbPf9M/rW2iIesa6teycPvkRedUs91remvPbDZUadn3BdfJMnX1MsNphjdtzgy+2YPnxIv3dEIdGqLWYLSKgUc8cqh7rE3zhSdcHCSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777884495; c=relaxed/simple;
	bh=JJW6/WJB60PQm4WgK03TCQYx0BsKenR9I4z7lBaytD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bprzygI/IbOVpRVuQjup1nWhwyvIFscVKhXqvuUs/F8qvplpiqD8y4rpD4nJiR6lPuD/DncIUoczhVdoLbwVdRBHl10lDVAbWqUqL+Z6TuAPZkVL7hT2emmQEXFv7uqeWrdV9bUkuXw5jDCdXW7QlmoYP7edmLZHb0qA0ApLtqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dAE87kWT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643Mx6CY2725335;
	Mon, 4 May 2026 08:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wXFCpQ
	j+tDpD81rQ3cbXwz0JF/z2ToW/sY2Jm67Dc2g=; b=dAE87kWTu/dMORqCkeHx8G
	FmY0WDimAoo5aamQiYho+t4LAfm/W6BKcOhha0rJ5cAy2qrMQgzNtJyHzyZPvEYt
	i6cYEQWAHs/IYD79vMpSNeWmZMKyqqyzC/4Z7LAbm0K8RQQzTYtoPnLOAfcGVYm9
	7hxgInYk6xwMC674SjwsRGp6tS4N6wLvvLKBnlw+gR/T6vcgmiXKfqWJr88ydaoc
	jHKNn5d1KbZHHH0YVrHy3zy9pLyY0yet3ZHYBm0VHFbvEb42WseBdFVXY4/EM8MA
	7cQx8UZ5mT1GWnamk7uLG+/tItyzJr79G2VC7I5q7GxEg3HQ/C4HnKFF6rrAHaWA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y4e0fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:47:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448dbPD006212;
	Mon, 4 May 2026 08:47:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvvg32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:47:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448lS2333751328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:47:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2994B2004B;
	Mon,  4 May 2026 08:47:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3471A20040;
	Mon,  4 May 2026 08:47:27 +0000 (GMT)
Received: from [9.111.168.154] (unknown [9.111.168.154])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:47:27 +0000 (GMT)
Message-ID: <bc3fb59b-9d80-4957-af51-20db38e3487e@linux.ibm.com>
Date: Mon, 4 May 2026 10:47:26 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
To: Mark Rutland <mark.rutland@arm.com>, Dylan Hatch <dylanbhatch@google.com>
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
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <afTYzAF_x41pyilu@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA5MiBTYWx0ZWRfX0Qv4mg/ZyCV0
 Kz4k7POT7/u4xvrAKz+6I7V5aLc2eUlIaBYh+Nd1L6ar1EfVaCCRhgZibwn4hfhPQFBwKvGJSrO
 ZP+stJVZ4pvW3rrJv5bYQJ3gGA/8kPqnT1GeHiquj6I0Is94CWI4WwkS/8yTF13oo2Mq7zwOrSY
 LmS9B/EG0pj73YEjur/8fqgk+TF6+Z+FvWjUxcG7quchga/tpb0SbEQTt9huFbwMUeMdths1Ytm
 dX34imgluZ81/WMv1kEikhrQ2dRnlHOSYjGPof8H43/otVwqUEfqHIbAFFiWMGJjWzhC1ZJDA49
 4keNFtXeFa0yZsz1dZ5wRdIKmC6dslELOEDSSWts+Sss64FWRdC2ncwi+top1tV2XNsgVgQVAw2
 W8KjK0Q+jhf0VVxiVamtQDtt0P6AoIvylAmMJ575YszRo4VtmlT7oW63nYPfGhtZlzN1UHptF0c
 DkQT0I3oJkMdcGmIXag==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69f85d23 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=CCpqsmhAAAAA:8
 a=VnNF1IyMAAAA:8 a=DIEc2ppCuoNOjgjcGPkA:9 a=mEOxYIM7fCpmq0lQ:21
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-GUID: A8vLvKcL-m9ZiK52wbdcR4xVQgvV8Wsi
X-Proofpoint-ORIG-GUID: fYTOW5P0dtHLAAQU_sNzU3JOkUZPiIF5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040092
X-Rspamd-Queue-Id: D64804BA888
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	TAGGED_FROM(0.00)[bounces-2693-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sourceware.org:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]

Hello Mark,

I mostly have comments regarding your the SFrame related remarks.

On 5/1/2026 6:46 PM, Mark Rutland wrote:
> Thanks for putting this together. I think this is looking pretty good.
> However, there are some things that aren't quite right and need some
> work, which I've commented on below.

> (2) To make unwinding generally possible, we'll need to annotate some
>     assembly functions as unwindable. We'll need to do that for string
>     routines under lib/, and probably some crypto code, but we don't
>     need to do that for most code in head.S, entry.S, etc.
> 
>     The vast majority of relevant assembly functions are leaf functions
>     (where the return address is never moved out of the LR), so we can
>     probably get away with a simple annotation for those that avoids the
>     need for open-coded CFI directives everywhere.

Wrapping them in .cfi_startproc ... .cfi_endproc should do.  For instance
by extending SYM_FUNC_START() and SYM_FUNC_END() or introducing flavors
that do.  Or where you thinking of something else?

> On Tue, Apr 28, 2026 at 06:36:43PM +0000, Dylan Hatch wrote:

>> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h

>> @@ -21,6 +21,8 @@ struct stack_info {
>>   *
>>   * @fp:          The fp value in the frame record (or the real fp)
>>   * @pc:          The lr value in the frame record (or the real lr)
>> + * @sp:          The sp value at the call site of the current function.
>> + * @unreliable:  Stacktrace is unreliable.
>>   *
>>   * @stack:       The stack currently being unwound.
>>   * @stacks:      An array of stacks which can be unwound.
>> @@ -29,7 +31,11 @@ struct stack_info {
>>  struct unwind_state {
>>  	unsigned long fp;
>>  	unsigned long pc;
>> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
>> +	unsigned long sp;
>> +#endif
> 
> As this is only used by the kernel unwinder (and not the hyp unwinder),
> this should live in struct kunwind_state in stacktrace.c.
> 
> That said, for unwinding across exception boundaries we should not need
> this, as the SP value will be in the pt_regs. If we only use SFrame for
> the exception boundary case, we can remove this entirely. I would
> strongly prefer that we do that.

>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c

>> +/*
>> + * Unwind to the next frame according to sframe.
>> + */
>> +static __always_inline int
>> +unwind_next_frame_sframe(struct kunwind_state *state)
>> +{
>> +	struct unwind_frame frame;
>> +	unsigned long cfa, fp, ra;
>> +	enum kunwind_source source = KUNWIND_SOURCE_FRAME;
>> +	struct pt_regs *regs = state->regs;
>> +
>> +	int err;
> 
> As above, we should only use this for unwinding from the regs, after a
> KUNWIND_SOURCE_REGS_PC step.
> 
> With that in mind, it would be good to:
> 
> (1) Rename this to something like kunwind_next_regs_sframe(). Note
>     'kunwind' rather than 'unwind' for consistency with the rest of this
>     file.
> 
> (2) Add the following sanity checks:
> 
> 	if (WARN_ON_ONCE(state->source != KUNWIND_SOURCE_REGS_PC))
> 		return -EINVAL;
> 	if (WARN_ON_ONCE(!state->regs))
> 		return -EINVAL;
> 
>     ... which will also allow the code below to be simplified.
> 
>> +
>> +	/* FP/SP alignment 8 bytes */
>> +	if (state->common.fp & 0x7 || state->common.sp & 0x7)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Most/all outermost functions are not visible to sframe. So, check for
>> +	 * a meta frame record if the sframe lookup fails.
>> +	 */
>> +	err = sframe_find_kernel(state->common.pc, &frame);
>> +	if (err)
>> +		return kunwind_next_frame_record_meta(state);
>> +
>> +	if (frame.outermost)
>> +		return -ENOENT;
> 
> I don't think we ever expect an outermost frame within the kernel. We
> haven't added any annotations for that, and we expect to unwind all the
> way to a FRAME_META_TYPE_FINAL frame.
> 
> We cannot fall back to kunwind_next_frame_record_meta() here. We don't
> know that the next frame is a meta frame (and this results in a warning
> noted above), and we don't know the result is going to be reliable if we
> don't have SFrame data, so the right thing to do is return an error.
> 
> I think this should be:
> 
> 	/*
> 	 * A kernel unwind should always end at a FRAME_META_TYPE_FINAL
> 	 * frame. There should be no outermost frames within the kernel.
> 	 */
> 	if (frame.outermost)
> 		return -EINVAL;

Makes sense.

> 
> 	err = sframe_find_kernel(state->common.pc, &frame);
> 	if (err)
> 		return -EINVAL;
> 
>> +	/* Get the Canonical Frame Address (CFA) */
>> +	switch (frame.cfa.rule) {
>> +	case UNWIND_CFA_RULE_SP_OFFSET:
>> +		cfa = state->common.sp;

IIUC you suggest this to be changed as follows?

		cfa = regs->regs[31];

>> +		break;
>> +	case UNWIND_CFA_RULE_FP_OFFSET:
>> +		if (state->common.fp < state->common.sp)
>> +			return -EINVAL;
>> +		cfa = state->common.fp;
>> +		break;
>> +	case UNWIND_CFA_RULE_REG_OFFSET:
>> +	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
>> +		/* regs only available in topmost/interrupt frame */
>> +		if (!regs || frame.cfa.regnum > 30)
>> +			return -EINVAL;
>> +		cfa = regs->regs[frame.cfa.regnum];
>> +		break;
> 
> Do we ever expect to see UNWIND_CFA_RULE_REG_OFFSET or
> UNWIND_CFA_RULE_REG_OFFSET_DEREF in practice for kernel code?

No.  Those can only occur with SFrame V3 flexible FDE, which are
currently not generated by GNU assembler for arm64/aarch64, and thus
could be omitted in the arm64-specific kernel sframe unwinder:

https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=gas/config/tc-aarch64.h;hb=binutils-2_46#l342

I must admit that while reviewing I thought it would be future-proof to
have support for rules that can only be represented with SFrame V3
flexible FDE, even if they are currently not used on arm64.  Ideally
kunwind_next_sframe() could be made common, if another architecture
would implement kernel unwinding using sframe.

> 
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return -EINVAL;
>> +	}
>> +	cfa += frame.cfa.offset;
>> +
>> +	/*
>> +	 * CFA typically points to a higher address than RA or FP, so don't
>> +	 * consume from the stack when we read it.
>> +	 */
>> +	if (frame.cfa.rule & UNWIND_RULE_DEREF &&
>> +	    !get_word(&state->common, &cfa))
>> +		return -EINVAL;
> 
> Per the switch above, this could only be
> UNWIND_CFA_RULE_REG_OFFSET_DEREF. As above, do we ever expect to
> encounter that in practice for kernel code?

No.  See above.

> 
>> +
>> +	/* CFA alignment 8 bytes */
>> +	if (cfa & 0x7)
>> +		return -EINVAL;
> 
> If the CFA is the SP upon entry to the function, then per AAPCS64 rules
> it should be aligned to 16 bytes. Otherwise, where has this 8 byte
> alignment requirement come from? Does SFrame mandate that?

That originates from the common unwind user logic (see
kernel/unwind/user.c, unwind_user_next_common()), which currently
assumes 8-byte/4-byte SP alignment for all 64-bit/32-bit architectures.

So checking for 16-byte alignment here would make sense.

> 
>> +
>> +	/* Get the Return Address (RA) */
>> +	switch (frame.ra.rule) {
>> +	case UNWIND_RULE_RETAIN:
>> +		/* regs only available in topmost/interrupt frame */
>> +		if (!regs)
>> +			return -EINVAL;
>> +		ra = regs->regs[30];
>> +		source = KUNWIND_SOURCE_REGS_LR;
>> +		break;
>> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */

Nit: s/UNWIND_USER_RULE_CFA_OFFSET/UNWIND_RULE_CFA_OFFSET/

> 
> It would be better for the comment to say *why* that's not implemented.
> 
> I assume that's because UNWIND_USER_RULE_CFA_OFFSET would mean that the return
> address is a stack address, and that's obviously not legitimate.

That and SFrame V3 currently cannot represent FP/RA as CFA + offset
(i.e. UNWIND_RULE_CFA_OFFSET; .cfi_val_offset FP/RA).

The comment originates from the common unwind user logic (see
kernel/unwind/user.c).  I am open to improve that.  What about:

	/*
	 * UNWIND_RULE_CFA_OFFSET not implemented on purpose, as a stack
	 * address cannot be a legitimate return address value.  It is
	 * also not used (e.g. not represented in sframe).
	 */

> 
>> +	case UNWIND_RULE_CFA_OFFSET_DEREF:
>> +		ra = cfa + frame.ra.offset;
>> +		break;
>> +	case UNWIND_RULE_REG_OFFSET:
>> +	case UNWIND_RULE_REG_OFFSET_DEREF:
>> +		/* regs only available in topmost/interrupt frame */
>> +		if (!regs)
>> +			return -EINVAL;
>> +		ra = regs->regs[frame.cfa.regnum];
>> +		ra += frame.ra.offset;
>> +		break;
> 
> Do we ever expect UNWIND_RULE_REG_OFFSET or UNWIND_RULE_REG_OFFSET_DEREF
> in practice for kernel code?

No.  See above (SFrame V3 flexible FDE).

> 
> I don't think we expect UNWIND_RULE_REG_OFFSET unless that's sometimes used
> instead of UNWIND_RULE_RETAIN to express that the return address is in x30
> (with zero offset).

No.  Unless there would be nonsense .cfi_register 30, 30, which would
require SFrame V3 flexible FDE to be represented.

@Indu:  We may consider to treat .cfi_register <reg>, <reg> (for FP/RA)
like .cfi_restore <reg> in the GNU assembler?

> 
> Similarly, if the address is on the stack it should be in a frame
> record. Would we ever expect UNWIND_RULE_REG_OFFSET_DEREF rather than
> UNWIND_RULE_CFA_OFFSET_DEREF?

No.  See above (SFrame V3 flexible FDE).

> 
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Get the Frame Pointer (FP) */
>> +	switch (frame.fp.rule) {
>> +	case UNWIND_RULE_RETAIN:
>> +		fp = state->common.fp;
>> +		break;
>> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> 
> As for RA, the comment should explain why that's not implemented.

I am open to improve the comment in the the common unwind user logic.
What about:

	/*
	 * UNWIND_RULE_CFA_OFFSET not implemented on purpose, as it is
	 * not used (e.g. not represented in sframe).
	 */

> 
>> +	case UNWIND_RULE_CFA_OFFSET_DEREF:
>> +		fp = cfa + frame.fp.offset;
>> +		break;
>> +	case UNWIND_RULE_REG_OFFSET:
>> +	case UNWIND_RULE_REG_OFFSET_DEREF:
>> +		/* regs only available in topmost/interrupt frame */
>> +		if (!regs)
>> +			return -EINVAL;
>> +		fp = regs->regs[frame.fp.regnum];
>> +		fp += frame.fp.offset;
>> +		break;

Likewise neither UNWIND_RULE_REG_OFFSET nor UNWIND_RULE_REG_OFFSET_DEREF
can currently occur on arm64.  See above (SFrame V3 flexible FDE).

>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * Consume RA and FP from the stack. The frame record puts FP at a lower
>> +	 * address than RA, so we always read FP first.
>> +	 */
>> +	if (frame.fp.rule & UNWIND_RULE_DEREF &&
>> +	    !get_word(&state->common, &fp))
>> +		return -EINVAL;
> 
> Why is this get_word() rather than get_consume_word()?
> 
>> +
>> +	if (frame.ra.rule & UNWIND_RULE_DEREF &&
>> +	    get_consume_word(&state->common, &ra))
>> +		return -EINVAL;
>> +
>> +	state->common.pc = ra;
>> +	state->common.sp = cfa;
> 
> As above, the SP can be removed.
> 
>> +	state->common.fp = fp;
>> +
>> +	state->source = source;
>> +
>> +	return 0;
>> +}
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


