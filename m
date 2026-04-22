Return-Path: <live-patching+bounces-2421-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDDtLCfX6GlJQwIAu9opvQ
	(envelope-from <live-patching+bounces-2421-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:11:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BE64471C3
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 16:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C1548305BDED
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 14:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235643ED101;
	Wed, 22 Apr 2026 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kaiJub8S"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817113ECBE3;
	Wed, 22 Apr 2026 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776866971; cv=none; b=dTt5miGBFhjAJ4bz61Hisfxtm+A8Z6Z8Ag9BzJG0no/jHtCtdoYaqeTcsWJjWWlFLthATwH26zAll7L24tec/SGecpL9+Yabi6xnfF+eTamE4Xz7jC1qu08zHyOE5DYUKy3uiBgsW2HEynSjcYRX0nXbqgsgxYvZUU3R497PziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776866971; c=relaxed/simple;
	bh=RvR5pB72UTB9uMBsQAnKoGXjLx83YoU8K/rtSFaie9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ts4RGlciv8eEvZsrL58dQoVLOLTyC518FRmScK6SaH4Xe315e5JZP2b8VjyTHVYmcPqt1206dGwCRXXwgTnLIQU3CJ9HXJDLxFDuATRvvkwRSB0LaqZFetmUiTbrMRYPYvDShiwE3NW1vGsEfn+Mzk3IV22ujnavnQOHWUKpiV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kaiJub8S; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MBPfgo679447;
	Wed, 22 Apr 2026 14:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IpwArf
	At6owGvRSmXXKC+18aMlrb+HlpWuKCj3PzYU4=; b=kaiJub8SgRBaiwIwMCHEgY
	PaLawJdSAhq6bGbfAw83jiUtsWVcTLwqmLQE5eoF8nwyJPac4+EXUs4K3gbzh2tr
	jWgNdPzInRScQ7+lhlNdFoElGpxKOcpkEPFAuhfl0hAbgEm/vZay3TL1uSOkafsO
	gAuAPcBAJaXLQ5+oTokql1+m3QE8YDBm2CR1I2d8Ui26dBDW032UZPNadl+h7MKB
	QyfvhKf9AD+1BpXSujtSRE6lnI/sqhNaPqLOTOb2JCq+BMIqe+4WzvUUHhrgFkeb
	0eKsTMTo42rSHkiFU1WXY6EyB87acdWHSzERzUjYLNPqj4p7C/VVK09ds1+L+3Aw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu7kjtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:08:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63ME5JdI028009;
	Wed, 22 Apr 2026 14:08:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjkyaguf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 14:08:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63ME8Xwp32899518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 14:08:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B60F22004B;
	Wed, 22 Apr 2026 14:08:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57A9E20043;
	Wed, 22 Apr 2026 14:08:33 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Apr 2026 14:08:33 +0000 (GMT)
Message-ID: <38c9d976-6205-409c-8874-4c9757b25fd6@linux.ibm.com>
Date: Wed, 22 Apr 2026 16:08:31 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/8] sframe: Allow kernelspace sframe sections
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
 <20260421225200.1198447-2-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260421225200.1198447-2-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: ju_xPmlZrKECD1mWQAnpuQqhrI7gn0Vw
X-Authority-Analysis: v=2.4 cv=Ksp9H2WN c=1 sm=1 tr=0 ts=69e8d665 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=6YHA6aIrzi84IHmqq2oA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: X2MbWGnSNjB8_Ghi5YZA71_Owz9SJaK2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzMyBTYWx0ZWRfX9GNtKYksw2GW
 UXNVn4ooUaEa2f9J0UGK4juKIct3HUxF4hF9fllJphnFqxr3yEWHf+fglkhkeyffsPpyMNghoDE
 iCPqpOC+f47Uz02CKPpu5IHENdQ972bNeU7701jIiSApTNZl4lErELNz7BnBuP1BEs2rCtr2FqF
 AIHEK7e3tjFm6zcO1Wj8x8N4PtnnmQ6HCcBjeXvCJRsch1z/26Kiuyo/UWjevN13P8ZlQmgeTp5
 1r/d+R/+lXRlImyqpOMZs5XKEOsSgLbDtRwLh9vtaotdXPI5aLBHEqpeekFgKOfH7v8VpXs3VuV
 Z3E1/igZPHpdsvDH0XEg0vgzRs0dkDsL5wAi3lSjjOlQYxp5KVTvCRoojZ4J4HObdQvr2tHh3Ke
 WAnS65mtVQy4P6ukLXf48zvChaAtGwtJHNdWwmuJUZInbf+OChVWzt+XQFL5p/2VqqRZqFepB0Z
 hFbF4kNlpISj/Vdg8hw==
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com];
	TAGGED_FROM(0.00)[bounces-2421-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MAILSPIKE_FAIL(0.00)[2600:3c04:e001:36c::12fc:5321:query timed out];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 37BE64471C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/2026 12:51 AM, Dylan Hatch wrote:
> Generalize the sframe lookup code to support kernelspace sections. This
> is done by defining a SFRAME_LOOKUP option that can be activated
> separate from HAVE_UNWIND_USER_SFRAME, as there will be other client to
> this library than just userspace unwind.
> 
> Sframe section location is now tracked in a separate sec_type field to
> determine whether user-access functions are necessary to read the sframe
> data. Relevant type delarations are moved and renamed to reflect the
> non-user sframe support.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>

With return -EFAULT changed to goto label in DATA_COPY() and DATA_GET():

Reviewed-by: Jens Remus <jremus@linux.ibm.com>

> ---
>  MAINTAINERS                                   |   2 +-
>  arch/Kconfig                                  |   4 +
>  .../{unwind_user_sframe.h => unwind_sframe.h} |   6 +-
>  arch/x86/include/asm/unwind_user.h            |  12 +-
>  include/linux/sframe.h                        |  48 ++--
>  include/linux/unwind_types.h                  |  46 +++
>  include/linux/unwind_user_types.h             |  41 ---
>  kernel/unwind/Makefile                        |   2 +-
>  kernel/unwind/sframe.c                        | 270 ++++++++++++------
>  kernel/unwind/user.c                          |  41 +--
>  10 files changed, 293 insertions(+), 179 deletions(-)
>  rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
>  create mode 100644 include/linux/unwind_types.h

> diff --git a/include/linux/sframe.h b/include/linux/sframe.h

> +enum sframe_sec_type {
> +	SFRAME_KERNEL,
> +	SFRAME_USER,
> +};

>  struct sframe_section {
> -	struct rcu_head	rcu;
> +	struct rcu_head  rcu;
>  #ifdef CONFIG_DYNAMIC_DEBUG
> -	const char	*filename;
> +	const char		*filename;
>  #endif
> -	unsigned long	sframe_start;
> -	unsigned long	sframe_end;
> -	unsigned long	text_start;
> -	unsigned long	text_end;
> -
> -	unsigned long	fdes_start;
> -	unsigned long	fres_start;
> -	unsigned long	fres_end;
> -	unsigned int	num_fdes;
> -
> -	signed char	ra_off;
> -	signed char	fp_off;
> +	enum sframe_sec_type	sec_type;
> +	unsigned long		sframe_start;
> +	unsigned long		sframe_end;
> +	unsigned long		text_start;
> +	unsigned long		text_end;
> +
> +	unsigned long		fdes_start;
> +	unsigned long		fres_start;
> +	unsigned long		fres_end;
> +	unsigned int		num_fdes;
> +
> +	signed char		ra_off;
> +	signed char		fp_off;
>  };

> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c

> +#define DATA_COPY(sec, to, from, size, label)			\
> +({								\
> +	switch (sec->sec_type) {				\
> +	case SFRAME_KERNEL:					\
> +		KERNEL_COPY(to, from, size, label);		\
> +		break;						\
> +	case SFRAME_USER:					\
> +		UNSAFE_USER_COPY(to, from, size, label);	\
> +		break;						\

I wonder whether it would be worthwhile to come up with an approach
where this would get evaluated at compile time instead at run time?
Or is this overengineering?  Of course such improvement could be
made later on, so no need to solve that now.

Options that came into my mind:
A) Introduce and pass through a "bool user" parameter, whose value is
   specified in sframe_find_user() and sframe_find_kernel().  Due to
   inlining I would expect that to get any conditions based on that
   to get evaluated at compile time.  See below.  Downside is the
   ugly additional parameter.

B) Introduce lightweight .c wrappers, e.g. sframe_kernel.c and
   sframe_user.c, that define DATA_GET() and DATA_COPY() and include
   sframe.c.  All HAVE_UNWIND_KERNEL_SFRAME code would be moved into
   sframe_kernel.c and likewise all HAVE_UNWIND_USER_SFRAME code into
   sframe_user.c.

> +	default:						\
> +		return -EFAULT;					\

		goto label;					\

Users of DATA_COPY() do expect the macro to branch to the label in case
of an error and therefore do not evaluate any return value.  The
wrapping then needs also be changed from "({ .. })" to
"do { ... } while (0)".

> +	}							\
> +})
> +
> +#define DATA_GET(sec, to, from, type, label)			\
> +({								\
> +	switch (sec->sec_type) {				\
> +	case SFRAME_KERNEL:					\
> +		KERNEL_GET(to, from, type, label);		\
> +		break;						\
> +	case SFRAME_USER:					\
> +		UNSAFE_USER_GET(to, from, type, label);		\
> +		break;						\
> +	default:						\
> +		return -EFAULT;					\

Likewise.

> +	}							\
> +})

> +#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
> +
> +int sframe_find_user(unsigned long ip, struct unwind_frame *frame)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct sframe_section *sec;
> +	int ret;
> +
> +	if (!mm)
> +		return -EINVAL;
> +
> +	guard(srcu)(&sframe_srcu);
> +
> +	sec = mtree_load(&mm->sframe_mt, ip);
> +	if (!sec)
> +		return -EINVAL;
> +
> +	if (!user_read_access_begin((void __user *)sec->sframe_start,
> +				    sec->sframe_end - sec->sframe_start))
> +		return -EFAULT;
> +
> +	ret = __sframe_find(sec, ip, frame);

In sframe_find_user() sec->sec_type must be SFRAME_USER.  Likewise in
sframe_find_kernel() it must be SFRAME_KERNEL.  So instead of
introducing sec_type, we could add a parameter
__sframe_find(..., bool user) and do:

	ret = __sframe_find(sec, ip, frame, true);

The downside is that this then requires to pass that flag through
everywhere... (see below).

> +
> +	user_read_access_end();
> +
> +	if (ret == -EFAULT) {
> +		dbg_sec("removing bad .sframe section\n");
> +		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
> +	}
> +
> +	return ret;
> +}
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


