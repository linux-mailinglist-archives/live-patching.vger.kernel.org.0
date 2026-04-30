Return-Path: <live-patching+bounces-2613-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OB48Ezws82mwxgEAu9opvQ
	(envelope-from <live-patching+bounces-2613-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 12:17:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F53C4A0A96
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 12:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 566DC3054339
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 10:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF183FFAC8;
	Thu, 30 Apr 2026 10:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ou4JTHKr"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5F23D8138;
	Thu, 30 Apr 2026 10:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777543485; cv=none; b=UMC0X0Y0fYqeJCRNjDe5sjBRyG9bFqz+G/dblKSsJl/wBH+ABm6X/fObZ5cFtpjzYTw+XqTABh1Yf3mmDBmCV3UUr/QLvwiqd5WYF+nuQssuW+gaW7QwRHyIBGyMcc0akov4COvr+haCtsw3SxhTLjCTouV4HYpTe2pzrScU6gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777543485; c=relaxed/simple;
	bh=dtd9Z7q9x2z/v/66l2rxBWjvIFOCdt5Uck/g785ZbMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oH5LJpFeK+mNSvUZ+BY8gBkhVOtlAWKjqWPv5L4SgYVMzv8ttm9CzuUABwGTSSZ8jQz9Op9jKlL/R8mMFFYaQY9Flngnpy7ArNGOGaajPGKKCc1UflM0Sf1ScdO2MUobWQGOywd8JfBCycjOBVr/fj0+W+TWVn7EjXzMk+e5lSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ou4JTHKr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63TIf3P81559961;
	Thu, 30 Apr 2026 10:04:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Of6v3t
	ddymZAopVSSZLx/BjESEwtJ6OYNXD95nkNQ9I=; b=ou4JTHKrALqEFtr/K9miwl
	lwLm3i56asVr1ieQXl0n5FH0eeXuXRHkrhf+BpJdy7ImRuYlgntKoM66am9do+u2
	kKcpI935UwEx9zTU1F9CJNseBfVesQ7WOeGK+kxqKKFH6b4rXwjK2bVAQhucseCX
	WMYYHISVBeq59iJk8mpHRKXaUb0NBCNhDb0aK1GfZMMZdgH99vT0sgy+aiYfzIvy
	zEQvZap/X49LHDtlDvVWJLgvvPwTuVXBRXQ1P/9UrUzgGM6KxOk3xrVdJJQqCT6S
	JbHiGzAVJr0SDgsJ6zoSXQCysTw8O5WL0XLGuPtldkV5VhttcYXSfg29pACgAQdA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn8vnb10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 10:04:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63U9ro7N032701;
	Thu, 30 Apr 2026 10:04:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8aw2g4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 10:04:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63UA414P60031378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 10:04:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 497E420049;
	Thu, 30 Apr 2026 10:04:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B617620040;
	Thu, 30 Apr 2026 10:04:00 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Apr 2026 10:04:00 +0000 (GMT)
Message-ID: <6fb474e6-7e54-408b-a3d9-9e13c674740c@linux.ibm.com>
Date: Thu, 30 Apr 2026 12:04:00 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION
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
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-8-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260428183643.3796063-8-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=CIIamxrD c=1 sm=1 tr=0 ts=69f32914 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=QMc7QGPnP32PvtbJ_1wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: zHdENj8pe7xhfjKzYXLQilF2gKUQgWlz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5OCBTYWx0ZWRfX+ZhHMSaiAJEV
 +IMEZ9ZaeHhmTO1z96r4nMyBUjbCGqpkK+elMrlooeOITudnP+3qyu4rfwWTQmJHg6cqmKx5LXz
 tLTrswQUCofSfBHO/b/xVxmrvuxl1rUce9O+4Zt/+x8NPZwyyP3pObnYmD8Jyrq4WWkQ+MM0D+b
 OOP+vCN4TtrI8Yc7I3aWuXnc9SJwFfYvm2Zp/ov1EpNlb1YLhnyvK8vngtAc4LmbIdjLFNYJLRI
 BGvR9xboPeRXIURQtGs8arHUx5ZryX1A8nTCVWBjaK4z/EfyuMp5J7nXaT1l0ZjD05CqKgoxQF3
 avgVXvSypr72i/nh/F8m4XCsfivhAP4JCpLLTJWnVT50kBOW83zv0U93X3tLktpT0S5XAWc3Bt9
 Mgmxl8AK7hSMY/Mbg1Qae+BQPqDoh9ySTwMO4uC/JYk2sqqACb6xkmhlLGULBS2JsY2iMncak8E
 9aeHepxYFdxzLeV3nsw==
X-Proofpoint-GUID: eMVam4ZfEteGXrjhGDO56EdCBNpTPVoi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_03,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604300098
X-Rspamd-Queue-Id: 4F53C4A0A96
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2613-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]

On 4/28/2026 8:36 PM, Dylan Hatch wrote:
> Generalize the __safe* helpers to support a non-user-access code path.
> 
> This requires arch-specific function address validation. This is because
> arm64 vmlinux keeps .exit.text (normally discarded), and .rodata.text
> sections both of which lie outside the bounds of the normal .text.
> .rodata.text contains code that is never executed by the kernel mapping,
> but for which the toolchain nonetheless generates sframe data, and needs
> to be considered valid for a PC lookup.
> 
> Additionally .init.text lies outside .text for all arches and must be
> accounted for as well.

> diff --git a/arch/arm64/include/asm/unwind_sframe.h b/arch/arm64/include/asm/unwind_sframe.h

> @@ -2,7 +2,54 @@
>  #ifndef _ASM_ARM64_UNWIND_SFRAME_H
>  #define _ASM_ARM64_UNWIND_SFRAME_H
>  
> +#include <linux/module.h>
> +#include <linux/sframe.h>
> +#include <asm/sections.h>
> +
>  #define SFRAME_REG_SP	31
>  #define SFRAME_REG_FP	29
>  
> +static inline bool sframe_func_start_addr_valid(struct sframe_section *sec,
> +						unsigned long func_addr)
> +{
> +	/* Common case for unwinding */
> +	if (sec->text_start <= func_addr && func_addr < sec->text_end)
> +		return true;
> +
> +	if (sec->sec_type != SFRAME_KERNEL)
> +		return false;
> +
> +	/*
> +	 * Account for vmlinux and module code outside the normal .text section.
> +	 * The toolchain still generates sframe data for these functions, so
> +	 * sframe lookups on them should be allowed.
> +	 */
> +	if (sec == &kernel_sfsec) {
> +		if (is_kernel_inittext(func_addr))
> +			return true;
> +
> +		/* .exit.text is retained in vmlinux on arm64. */
> +		if (func_addr >= (unsigned long)__exittext_begin &&
> +		    func_addr < (unsigned long)__exittext_end)
> +			return true;
> +
> +

Nit: Superfluous empty line (2 instead of 1).

> +		/*
> +		 * .rodata.text is never executed from the kernel mapping, but
> +		 * still has sframe data
> +		 */
> +		if (func_addr >= (unsigned long)_srodatatext &&
> +		    func_addr < (unsigned long)_erodatatext)
> +			return true;
> +	} else {
> +		struct module *mod = container_of(sec, struct module,
> +						  arch.sframe_sec);

This currently does not work properly when sframe_validate_section() is
called from sframe_module_init(), which operates on a temporary struct
sframe_section section, that is not (yet) the one in struct module.  See
my feedback to the respective patch for how to resolve.

> +		if (within_module_mem_type(func_addr, mod, MOD_INIT_TEXT))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +#define sframe_func_start_addr_valid sframe_func_start_addr_valid
> +
>  #endif /* _ASM_ARM64_UNWIND_SFRAME_H */
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


