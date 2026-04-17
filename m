Return-Path: <live-patching+bounces-2385-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mmliIg9X4mm25AAAu9opvQ
	(envelope-from <live-patching+bounces-2385-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:51:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE26141CCED
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4F69300F5D4
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 15:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83523290DB;
	Fri, 17 Apr 2026 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rMjm/3fv"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4831816FF37;
	Fri, 17 Apr 2026 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776440758; cv=none; b=NOiFAHkx0MFyiX0Wf6LcUmSqA4pYT7SGYpYJrlEo1kgFtKtA9OVFNQPcElUfD6qxdxk3He9+hDuUystpqRav9r4yoNA0BH5n7GRuiBeAeMvB/CnB5CmzW6czJYv8GldmwzYkfMm6jUaju3H/peubpA4NNnVHs3UpSSeV10gLsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776440758; c=relaxed/simple;
	bh=hRNlEmtwA5eEVI6T4QJ4+BoWQ9xXbV8SAu+bGFpswOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/2i+eAoHo0iEky1+XoZ6XR6GqC4x6a0vPLnYh3OpcNyiNg7IB5SSqCHrN1bqpja/hw+0rlEH5gcH1V6zt44kW3AdnljHCgCTo63HDpoVB7R85r4N4jH2Z33dQNfxiNx8KX0wXRCPihATJEY7o7LQhqbMT54tcnPyx10jEt87as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rMjm/3fv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HF9A9V2614144;
	Fri, 17 Apr 2026 15:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Osxna4
	FtHQotwv8pLUx2HpWt2BMJy2W8k3FN7VIJSWs=; b=rMjm/3fvPnSDN4nhV/W89X
	k5pduLyXcMB1QDFJVGL1QNN+RIxegSfZQovUJRWhEvSP/AHQdbvq9sO06qcBfANH
	0Xe2ggjJmekLUew3q7TxBbWpzFr2ePv6+k4p+zIeT74RDONzlTUHbHy9OcO2N6D4
	zywFjhSQUvmnHGlohOCZ5sPZjS+isd9aIZViWBUKEjzIAHDwX0LmpfjTbjhyVyCR
	KMCzD9chSmLoMche9tLSNNS61iyYqlclNd8qGvj8eDf8Kw8U5DeetZN9Ux4Rttot
	Vgmf4v5caf5jedmmugVBcwusmlcL7zoanP8hI+IumkprfQOnJctN75TbACHlefNw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89nuepd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 15:45:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63HBN97Z015666;
	Fri, 17 Apr 2026 15:45:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0mt014d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Apr 2026 15:45:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63HFjDJ731129898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 15:45:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D18B220040;
	Fri, 17 Apr 2026 15:45:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 185572004D;
	Fri, 17 Apr 2026 15:45:13 +0000 (GMT)
Received: from [9.111.133.81] (unknown [9.111.133.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Apr 2026 15:45:13 +0000 (GMT)
Message-ID: <95f9d11a-dd92-433e-a8db-cbebe94e1611@linux.ibm.com>
Date: Fri, 17 Apr 2026 17:45:10 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames.
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
 <20260406185000.1378082-9-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-9-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: GziO2qAoQXMAKU75LAHCq6QCKakEObnC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDE1NCBTYWx0ZWRfXwj4yVYlgPM5P
 9q0i5MbP3ABLecmm/eXE5Nv0YwynTtAdr5WsYuTOc27/Tupm5aIdOHRuXvi8LS++6OM+STqBN2F
 wNOtFCqqI7mlzPjB/VxuNuk6ZEW2OFbqeJ0W7ulO2ukXkXxmB3SUVnE3xyCuN697dNJXuxvmk9G
 0+wrv2PNapDr3+crortwjQS908yg8FaEhLV535Idoi0iTSE2bXPSdSZK3UaN0aLDwVfbGKyXcTF
 uAbNEslCSGAr8S73caMi3cpry2enYGjmLPQaKsxCNGayeU1CZan+mfCrSGwemjM1V1BmQkEmrRj
 yPrqYlRXnyfV5okgjBOCxzSAgTjfjoGN0UxkL7/o70wVIG8qKtaS+ohNptnW/2JClPyZWo3A4Yx
 HjvKmiFKe2MvKWryjnj0Bh9zFG9QtnRHdFAsBQt7QFL2ENrwYsWuh52PbpyrNxw0iqNUe5XMGfy
 Ee5IZ+525w1rYtpteBA==
X-Proofpoint-ORIG-GUID: mqaiSIGtoWLV696juffMrFiV03naceXz
X-Authority-Analysis: v=2.4 cv=FY4HAp+6 c=1 sm=1 tr=0 ts=69e2558d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=jKjX_6A9mCPruwacPsgA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170154
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2385-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
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
X-Rspamd-Queue-Id: CE26141CCED
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Dylan and Weinan!

On 4/6/2026 8:50 PM, Dylan Hatch wrote:
> Add unwind_next_frame_sframe() function to unwind by sframe info if
> present. Use this method at exception boundaries, falling back to
> frame-pointer unwind only on failure. In such failure cases, the
> stacktrace is considered unreliable.
> 
> During normal unwind, prefer frame pointer unwind (for better
> performance) with sframe as a backup.
> 
> This change restores the LR behavior originally introduced in commit
> c2c6b27b5aa14fa2 ("arm64: stacktrace: unwind exception boundaries"),
> But later removed in commit 32ed1205682e ("arm64: stacktrace: Skip
> reporting LR at exception boundaries")
> 
> This can be done because the sframe data can be used to determine
> whether the LR is current for the PC value recovered from pt_regs at the
> exception boundary.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c

> +/*
> + * Unwind to the next frame according to sframe.
> + */
> +static __always_inline int
> +unwind_next_frame_sframe(struct kunwind_state *state)
> +{
> +	struct unwind_frame frame;
> +	unsigned long cfa, fp, ra;
> +	enum kunwind_source source = KUNWIND_SOURCE_FRAME;
> +	struct pt_regs *regs = state->regs;
> +
> +	int err;
> +
> +	/* FP/SP alignment 8 bytes */
> +	if (state->common.fp & 0x7 || state->common.sp & 0x7)
> +		return -EINVAL;
> +
> +	/*
> +	 * Most/all outermost functions are not visible to sframe. So, check for
> +	 * a meta frame record if the sframe lookup fails.
> +	 */
> +	err = sframe_find_kernel(state->common.pc, &frame);
> +	if (err)
> +		return kunwind_next_frame_record_meta(state);
> +
> +	if (frame.outermost)
> +		return -ENOENT;
> +
> +	/* Get the Canonical Frame Address (CFA) */
> +	switch (frame.cfa.rule) {
> +	case UNWIND_CFA_RULE_SP_OFFSET:
> +		cfa = state->common.sp;
> +		break;
> +	case UNWIND_CFA_RULE_FP_OFFSET:
> +		if (state->common.fp < state->common.sp)
> +			return -EINVAL;

I wonder whether that check is valid in kernel?  Looking at
call_on_irq_stack() saving SP in FP and then loading SP with the IRQ SP.
Is that condition always true then?

> +		cfa = state->common.fp;
> +		break;
> +	case UNWIND_CFA_RULE_REG_OFFSET:
> +	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
> +		if (!regs)

		if (!regs || frame.cfa.regnum > 30)

> +			return -EINVAL;
> +		cfa = regs->regs[frame.cfa.regnum];

In unwind user this is guarded by a topmost frame check, as arbitrary
registers are otherwise not available.  Isn't this necessary in the
kernel case?

> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +	cfa += frame.cfa.offset;
> +
> +	/*
> +	 * CFA typically points to a higher address than RA or FP, so don't
> +	 * consume from the stack when we read it.
> +	 */
> +	if (frame.cfa.rule & UNWIND_RULE_DEREF &&
> +	    !get_word(&state->common, &cfa))
> +		return -EINVAL;
> +
> +	/* CFA alignment 8 bytes */
> +	if (cfa & 0x7)
> +		return -EINVAL;
> +
> +	/* Get the Return Address (RA) */
> +	switch (frame.ra.rule) {
> +	case UNWIND_RULE_RETAIN:
> +		if (!regs)
> +			return -EINVAL;
> +		ra = regs->regs[30];

Likewise: Topmost frame check not required to access arbitrary registers
(including RA/LR)?  Furthermore, provided don't have a thinko, LR may
only be in LR in the topmost frame.  In any other frame it must have
been saved.  Otherwise there would be an endless return loop.

> +		source = KUNWIND_SOURCE_REGS_LR;
> +		break;
> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> +	case UNWIND_RULE_CFA_OFFSET_DEREF:
> +		ra = cfa + frame.ra.offset;
> +		break;
> +	case UNWIND_RULE_REG_OFFSET:
> +	case UNWIND_RULE_REG_OFFSET_DEREF:
> +		if (!regs)

		if (!regs || frame.cfa.regnum > 30)

> +			return -EINVAL;
> +		ra = regs->regs[frame.cfa.regnum];

Likewise: Topmost frame check not required to access arbitrary registers?

> +		ra += frame.ra.offset;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +
> +	/* Get the Frame Pointer (FP) */
> +	switch (frame.fp.rule) {
> +	case UNWIND_RULE_RETAIN:
> +		fp = state->common.fp;
> +		break;
> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> +	case UNWIND_RULE_CFA_OFFSET_DEREF:
> +		fp = cfa + frame.fp.offset;
> +		break;
> +	case UNWIND_RULE_REG_OFFSET:
> +	case UNWIND_RULE_REG_OFFSET_DEREF:
> +		if (!regs)

		if (!regs || frame.cfa.regnum > 30)

> +			return -EINVAL;
> +		fp = regs->regs[frame.fp.regnum];

Likewise: Topmost frame check not required to access arbitrary registers?

> +		fp += frame.fp.offset;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Consume RA and FP from the stack. The frame record puts FP at a lower
> +	 * address than RA, so we always read FP first.
> +	 */
> +	if (frame.fp.rule & UNWIND_RULE_DEREF &&
> +	    !get_word(&state->common, &fp))
> +		return -EINVAL;
> +
> +	if (frame.ra.rule & UNWIND_RULE_DEREF &&
> +	    get_consume_word(&state->common, &ra))
> +		return -EINVAL;
> +
> +	state->common.pc = ra;
> +	state->common.sp = cfa;
> +	state->common.fp = fp;
> +
> +	state->source = source;
> +
> +	return 0;
> +}
Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


