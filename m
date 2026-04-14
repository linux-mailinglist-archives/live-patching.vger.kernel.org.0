Return-Path: <live-patching+bounces-2344-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QL9ONBgw3mnxogkAu9opvQ
	(envelope-from <live-patching+bounces-2344-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:16:24 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CEC73F9E7D
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C07B130D4666
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 12:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E953921E4;
	Tue, 14 Apr 2026 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tEbpv5Qk"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D7B3E5592;
	Tue, 14 Apr 2026 12:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776168627; cv=none; b=RayFKfLh3QZkKDsomehLlAQ6gaxvC9sedsB2YVrGPxVxzjQCH8Vgvvx2a0Jmw1gJNJqkYxOAR51GXyBFY+N1nvtGEJGPuKdY/GgseRnTtzwxDrIHpuQbii9kmr3L9M/EOWu5xdjcYELo3I2AgyEwDhOWRCYjvKlixaA247kk9C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776168627; c=relaxed/simple;
	bh=KjxmY5evGCgMMLQGolPBFmX2Ox+zlsJAxki6zO5bxkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9d/kiQLADTOtTKdAw+przB+OH9ahRwRNzBgKyrfSd3jOMF5YD09HVQ64whJPMniclDO5yVo40hgcnDbarAwcvni7nNWFYLpaNrL/jz2+tF25Zzaw4fR//YlUrIK0ZWUHwxsDGcktY+u3xg3VeDr/66YESc4TxBHYj1TBsC2XAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tEbpv5Qk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIUvd2130640;
	Tue, 14 Apr 2026 12:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AeWnSl
	gGKZBcyenb8mUUEqV0mdW31nwaGuQrp2ApXLk=; b=tEbpv5QkdxUtovtblXHfnl
	YNLlDu/7aGcHlB5OE8YAFYB0Bn2xP12uW9iG+j8y7eEBVztQfinRFDjoDef91me0
	vFfj3pjxJLjHrML8Jg103gwhMu3zfUE5SijDkV6RwI0FcDrUrD99vtwyN+IH91fM
	Ulg/gCzVhKPemhuVUoDxrf7caeFCTj2YdAorYi4wnGmY6rJbyRXAFBxfCST8r81J
	4/keMlRlu9TjpibrEL2TY9pXBUXYoT+YHwob16C0ro5Bv8al/4D14hhg6Bmnmepj
	rXx0GMiNLnXywpSFCJW0nFDlmn197LF8aPG+HGIuF3Rc+m0eOQYNJhABqSUNJIfg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89nakf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 12:09:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E9NLqg030721;
	Tue, 14 Apr 2026 12:09:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg10y9f77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 12:09:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EC9iQP28836298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 12:09:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B57320043;
	Tue, 14 Apr 2026 12:09:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F21820040;
	Tue, 14 Apr 2026 12:09:44 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 12:09:44 +0000 (GMT)
Message-ID: <e087a768-507d-4ac2-8875-ab7c522420bd@linux.ibm.com>
Date: Tue, 14 Apr 2026 14:09:42 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] sframe: Allow kernelspace sframe sections.
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
        linux-arm-kernel@lists.infradead.org
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-2-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260406185000.1378082-2-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 7s7cXi06g2xRhHmoKeqjlbPa6_VRgFW7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDExMCBTYWx0ZWRfX9/u2/WGDmdi7
 7VBm4jga7f++j/WVPnbbqm+2mLvlfxeJWr3YeGTscgsYBNJSTaUeZUx6PUe/BBQtwKDEmnK/I/u
 Zd9NFpl4M9cNL9B6Yjm6u0AEUTA3S4ej6exA1d7dOkFM17EtN6Qcx4eFizNZHvRu3V20oY4/RBC
 vUU9la7B3CdTW5r7MDYVk1Y81VNGSngddNnhVpzGILbqpuy98Lib4tqGHGOi4k/lQm/u9dnjLGe
 huzoCekBKesJNpd6ePZxBfmtraB7bV3t2c4I3AZrJZyTVHcy5hmF8zoDIGBccO4b36VI8w+/mtw
 FaPbhLXNBvcga2Jq/C/6zSau8PeTE98prOeIzMMwW0t4eV0YdDgHJ+nVvsS56403SEyYo9GI0D7
 j3+EMdz2cQeFBC2MgtAIDYvOvFoZhdFshuhTOpJX30oUxMBFHv/Nvhj6RuNAV3ite+oYlaP7mY8
 +mrH5AVdfnKmr8PqonQ==
X-Proofpoint-ORIG-GUID: kLj3cRsPjkPaXpmA957ELV5MyMQakV30
X-Authority-Analysis: v=2.4 cv=FY4HAp+6 c=1 sm=1 tr=0 ts=69de2e8c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=EcvllB-cgGEySGRCOTcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140110
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2344-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 2CEC73F9E7D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Dylan!

On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> Generalize the sframe lookup code to support kernelspace sections. This
> is done by defining a SFRAME_LOOKUP option that can be activated
> separate from UNWIND_USER_SFRAME, as there will be other clients to this
> library than just userspace unwind.

Nit: s/UNWIND_USER_SFRAME/HAVE_UNWIND_USER_SFRAME/

This actually uses the following two new Kconfig options (with
SFRAME_UNWINDER technically being introduced in the next patch):

  SFRAME_LOOKUP
  SFRAME_UNWINDER

IIUC SFRAME_UNWINDER is the kernel counterpart to the existing
HAVE_UNWIND_USER_SFRAME.  Would it therefore make sense to align the
naming as follows?

  HAVE_UNWIND_KERNEL_SFRAME (instead of SFRAME_UNWINDER)
  HAVE_UNWIND_USER_SFRAME

> Sframe section location is now tracked in a separate sec_type field to
> determine whether user-access functions are necessary to read the sframe
> data. Relevant type delarations are moved and renamed to reflect the
> non-user sframe support.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

> diff --git a/arch/Kconfig b/arch/Kconfig

> @@ -486,6 +486,9 @@ config AS_SFRAME3
>  	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,-Wa$(comma)--gsframe-3)
>  	select AS_SFRAME
>  
> +config SFRAME_LOOKUP
> +	bool
> +
>  config UNWIND_USER
>  	bool
>  
> @@ -496,6 +499,7 @@ config HAVE_UNWIND_USER_FP
>  config HAVE_UNWIND_USER_SFRAME
>  	bool
>  	select UNWIND_USER
> +	select SFRAME_LOOKUP
>  
>  config SFRAME_VALIDATION
>  	bool "Enable .sframe section debugging"

IIUC SFRAME_LOOKUP only exists to pull in the common (kernel and user)
sframe lookup code if SFRAME_UNWINDER and/or UNWIND_USER_SFRAME are
enabled.  Given there is currently no other use case than kernel/user
stacktrace unwinding, would it make sense to rename it as follows to
group all of the related options with the UNWIND prefix?

  UNWIND_SFRAME[_LOOKUP]

> diff --git a/include/linux/sframe.h b/include/linux/sframe.h

> @@ -4,36 +4,85 @@
>  
>  #include <linux/mm_types.h>
>  #include <linux/srcu.h>
> -#include <linux/unwind_user_types.h>
>  
> -#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
> +#define UNWIND_RULE_DEREF			BIT(31)
> +
> +enum unwind_cfa_rule {
> +	UNWIND_CFA_RULE_SP_OFFSET,		/* CFA = SP + offset */
> +	UNWIND_CFA_RULE_FP_OFFSET,		/* CFA = FP + offset */
> +	UNWIND_CFA_RULE_REG_OFFSET,	/* CFA = reg + offset */
> +	/* DEREF variants */
> +	UNWIND_CFA_RULE_REG_OFFSET_DEREF =	/* CFA = *(reg + offset) */
> +		UNWIND_CFA_RULE_REG_OFFSET | UNWIND_RULE_DEREF,
> +};
> +
> +struct unwind_cfa_rule_data {
> +	enum unwind_cfa_rule rule;
> +	s32 offset;
> +	unsigned int regnum;
> +};
> +
> +enum unwind_rule {
> +	UNWIND_RULE_RETAIN,		/* entity = entity */
> +	UNWIND_RULE_CFA_OFFSET,		/* entity = CFA + offset */
> +	UNWIND_RULE_REG_OFFSET,		/* entity = register + offset */
> +	/* DEREF variants */
> +	UNWIND_RULE_CFA_OFFSET_DEREF =	/* entity = *(CFA + offset) */
> +		UNWIND_RULE_CFA_OFFSET | UNWIND_RULE_DEREF,
> +	UNWIND_RULE_REG_OFFSET_DEREF =	/* entity = *(register + offset) */
> +		UNWIND_RULE_REG_OFFSET | UNWIND_RULE_DEREF,
> +};
> +
> +struct unwind_rule_data {
> +	enum unwind_rule rule;
> +	s32 offset;
> +	unsigned int regnum;
> +};
> +
> +struct unwind_frame {
> +	struct unwind_cfa_rule_data cfa;
> +	struct unwind_rule_data ra;
> +	struct unwind_rule_data fp;
> +	bool outermost;
> +};

You are moving (and renaming to generalize for kernel and user unwind
use) the above definitions from include/linux/unwind_user_types.h to
include/linux/sframe.h.  Given the definitions are used in
kernel/unwind/user.c for FP and SFRAME unwinding this seems wrong to
me.  The definitions should better be moved (and renamed as you did)
into a new include/linux/unwind_types.h (or the like).

> diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h

> @@ -27,47 +27,6 @@ struct unwind_stacktrace {
>  	unsigned long	*entries;
>  };
>  
> -#define UNWIND_USER_RULE_DEREF			BIT(31)
> -
> -enum unwind_user_cfa_rule {
> -	UNWIND_USER_CFA_RULE_SP_OFFSET,		/* CFA = SP + offset */
> -	UNWIND_USER_CFA_RULE_FP_OFFSET,		/* CFA = FP + offset */
> -	UNWIND_USER_CFA_RULE_REG_OFFSET,	/* CFA = reg + offset */
> -	/* DEREF variants */
> -	UNWIND_USER_CFA_RULE_REG_OFFSET_DEREF =	/* CFA = *(reg + offset) */
> -		UNWIND_USER_CFA_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
> -};
> -
> -struct unwind_user_cfa_rule_data {
> -	enum unwind_user_cfa_rule rule;
> -	s32 offset;
> -	unsigned int regnum;
> -};
> -
> -enum unwind_user_rule {
> -	UNWIND_USER_RULE_RETAIN,		/* entity = entity */
> -	UNWIND_USER_RULE_CFA_OFFSET,		/* entity = CFA + offset */
> -	UNWIND_USER_RULE_REG_OFFSET,		/* entity = register + offset */
> -	/* DEREF variants */
> -	UNWIND_USER_RULE_CFA_OFFSET_DEREF =	/* entity = *(CFA + offset) */
> -		UNWIND_USER_RULE_CFA_OFFSET | UNWIND_USER_RULE_DEREF,
> -	UNWIND_USER_RULE_REG_OFFSET_DEREF =	/* entity = *(register + offset) */
> -		UNWIND_USER_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
> -};
> -
> -struct unwind_user_rule_data {
> -	enum unwind_user_rule rule;
> -	s32 offset;
> -	unsigned int regnum;
> -};
> -
> -struct unwind_user_frame {
> -	struct unwind_user_cfa_rule_data cfa;
> -	struct unwind_user_rule_data ra;
> -	struct unwind_user_rule_data fp;
> -	bool outermost;
> -};
> -
>  struct unwind_user_state {
>  	unsigned long				ip;
>  	unsigned long				sp;

> diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile

> @@ -1,2 +1,2 @@
>   obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
> - obj-$(CONFIG_HAVE_UNWIND_USER_SFRAME)	+= sframe.o
> + obj-$(CONFIG_SFRAME_LOOKUP)	+= sframe.o

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> @@ -44,8 +43,6 @@ struct sframe_fre_internal {
>  	unsigned char	dw_size;
>  };
>  
> -DEFINE_STATIC_SRCU(sframe_srcu);
> -
>  static __always_inline unsigned char fre_type_to_size(unsigned char fre_type)
>  {
>  	if (fre_type > 2)
> @@ -60,6 +57,78 @@ static __always_inline unsigned char dataword_size_enum_to_size(unsigned char da
>  	return 1 << dataword_size;
>  }
>  
> +#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
> +
> +DEFINE_STATIC_SRCU(sframe_srcu);
> +
> +#define UNSAFE_USER_COPY(to, from, size, label)				\
> +	unsafe_copy_from_user(to, (void __user *)from, size, label)
> +
> +#define UNSAFE_USER_GET(to, from, type, label)				\
> +	unsafe_get_user(to, (type __user *)from, label)
> +
> +#else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
> +
> +#define UNSAFE_USER_COPY(to, from, size, label) do {			\
> +	(void)to; (void)from; (void)size;				\
> +	goto label;							\
> +} while (0)
> +
> +#define UNSAFE_USER_GET(to, from, type, label) do {			\
> +	(void)to; (void)from;						\
> +	goto label;							\
> +} while (0)
> +
> +#endif /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
> +
> +#ifdef CONFIG_SFRAME_UNWINDER
> +
> +#define KERNEL_COPY(to, from, size) memcpy(to, (void *)from, size)
> +#define KERNEL_GET(to, from, type) ({ (to) = *(type *)(from); })
> +
> +#else /* !CONFIG_SFRAME_UNWINDER */
> +
> +#define KERNEL_COPY(to, from, size) do {				\
> +	(void)(to); (void)(from); (void)size;				\
> +	return -EFAULT;							\
> +} while (0)
> +
> +#define KERNEL_GET(to, from, type) do {					\
> +	(void)(to); (void)(from);					\
> +	return -EFAULT;							\
> +} while (0)

The error return value in above dummy implementations is never used
(see DATA_COPY() and DATA_GET() below).  Maybe better define the KERNEL
flavors with the same interface as the UNSAFE_USER ones (with error
label) and have the dummy implementations goto that label?

> +
> +

Nit: Two instead of one empty line.

> +#endif /* !CONFIG_SFRAME_UNWINDER */
> +
> +#define DATA_COPY(sec, to, from, size, label)			\
> +({								\
> +	switch (sec->sec_type) {				\
> +	case SFRAME_KERNEL:					\
> +		KERNEL_COPY(to, from, size);			\
> +		break;						\
> +	case SFRAME_USER:					\
> +		UNSAFE_USER_COPY(to, from, size, label);	\
> +		break;						\
> +	default:						\
> +		return -EFAULT;					\
> +	}							\
> +})
> +
> +#define DATA_GET(sec, to, from, type, label)			\
> +({								\
> +	switch (sec->sec_type) {				\
> +	case SFRAME_KERNEL:					\
> +		KERNEL_GET(to, from, type);			\
> +		break;						\
> +	case SFRAME_USER:					\
> +		UNSAFE_USER_GET(to, from, type, label);		\
> +		break;						\
> +	default:						\
> +		return -EFAULT;					\
> +	}							\
> +})
> +
>  static __always_inline int __read_fde(struct sframe_section *sec,
>  				      unsigned int fde_num,
>  				      struct sframe_fde_internal *fde)

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


