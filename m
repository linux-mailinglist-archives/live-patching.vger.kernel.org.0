Return-Path: <live-patching+bounces-2346-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNr4AZ823mkRpQkAu9opvQ
	(envelope-from <live-patching+bounces-2346-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:44:15 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3063FA1AA
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0ABDE301221E
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 12:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C953A3E6398;
	Tue, 14 Apr 2026 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PC3OiC9H"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8483E5ECE;
	Tue, 14 Apr 2026 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776170652; cv=none; b=JlRlWLekuBDBzMhy3rxYXL2ldI/vQXfuvRzovpW0mHknDYLYE+NdfLz7d7XbKLY90GwaMOQlB/BFKKKqBjMyJXsiH+af82uD1sBvdklFgBO0Bl+WYyN+D/+Rm/rpwr1ShbWLwL9hic3AyTfJBw6KLVHvhHWnTxj7IJzkynMjNP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776170652; c=relaxed/simple;
	bh=JDjbbGd8vcy8VL492VqS1bMEvi8Rvwru/3YE3Wl+BJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LLaOX85XvjDlFkf1Nm25NBNOMR8XbdMKD2ynpQoGpbMwQScaala2/Pj1RZwyiuVYLWfvawgOSQWUpoJzL/1zHNcPEUbDuAF/kgLYbarFHTLJNZQAoLFoTw2A/+RkTgyCgPAI8O0QtJcDKNpQMPHj8Ghk6dwVCptNLj3IC1XS3s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PC3OiC9H; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLI8h21804487;
	Tue, 14 Apr 2026 12:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KkUG9q
	jjaISIJwix1JT1s6vqdVV0ZJRpqxMJmKUiFJY=; b=PC3OiC9H8rex2LIivHayYX
	AunNJsF/IJB+4T61p+DdJg0n9U9QASLXd5zz/W1bByv/0prck8GUhkdMkxdnrmUs
	MjUJ1rEvTHoc6QWrADC2vndDdEfy178VyNS2gzbn5AsOHgxwbnX5Y16ES3b6ZRBb
	GB7klPj3c+3Qg5uKvPmboXjUlXg5r9hF1kFKengTP40ATkvgnTyx+XBtkzGSNEm0
	Cot997Ce1FS0DVD7Zq/5s/Rr7l53rWMjWSHUIhIZ/285R7HMpG7ypkcA5Br2X8bA
	f1dY9JOhRJRHd6cJKbkIYszSJ4D3T7krCfpFWOIS3n1bX5qt+IGB37vU3vprQTlg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k2kfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 12:43:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63EAfjDo025862;
	Tue, 14 Apr 2026 12:43:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujh9hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 12:43:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EChj1h31523476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 12:43:45 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1DD7E2004F;
	Tue, 14 Apr 2026 12:43:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCC3720043;
	Tue, 14 Apr 2026 12:43:44 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 12:43:44 +0000 (GMT)
Message-ID: <cc7f741c-41a0-4620-b5d5-3428aaa7648f@linux.ibm.com>
Date: Tue, 14 Apr 2026 14:43:43 +0200
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
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
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
X-Proofpoint-GUID: OPx_h5AuopgC_45bjgFOv4gHcb5E5zwh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDExNSBTYWx0ZWRfX3WPH3xc7kxM/
 FcirnhlN5fpxnpfzld+uB+ChYqY1o4SrwIhpdIT5T2p4MyO+feYhBpPACs75SIWi4YhgFJ6Nr0a
 Bhf2Y+IrtTAsFd45D3TRdhnyer8iCigFoR7WIKK9SEiZZ2cKOftXRBR8zF5u1pFnBvqNFquoESy
 xa7+UTKw28sFrOwvoMkdr4oQWfYfbUGmMP0pKiskgAv/GM7j8wfHL4pSoaK+MqzpG98PLohFvpg
 pBXwmxbAXlHMxRE5CdPmRVSmZ5/rB3Sf+zuAexZW2qr97x0wNm+j/9g0feMih2fmiCVg57dPEhg
 HkJG+8nlIUTsZZIsanK0hVwSRFU0gQWlbr758bOJ8AGBVFEZpsaycL6aWy61JFrzg+X6YQF9pgu
 5gWSiEUhfh/UzDY3fajfghPGWgZGxMHJIt7D0yBS50t9Cl5CSK10QscWwYP/n3ukn4DO9DzzUG1
 ameHCzssHqJi+6Y2LQw==
X-Proofpoint-ORIG-GUID: 7kljJTJRPmMKqwqgm7SFJX_006Z7TXz3
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69de3686 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=xJod4J6tRyryzautBPYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140115
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2346-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 9B3063FA1AA
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
> diff --git a/MAINTAINERS b/MAINTAINERS

> @@ -27561,6 +27561,7 @@ STACK UNWINDING
>  M:	Josh Poimboeuf <jpoimboe@kernel.org>
>  M:	Steven Rostedt <rostedt@goodmis.org>
>  S:	Maintained
> +F:	arch/*/include/asm/unwind_sframe.h
>  F:	include/linux/sframe.h
>  F:	include/linux/unwind*.h
>  F:	kernel/unwind/

Good catch!  Should we rather add the following in the series you are
basing on, as there are already arch-specific unwind_user.h and
unwind_user_sframe.h?

F:	arch/*/include/asm/unwind*.h

On the other hand I wonder whether the arch-specific headers should
remain maintained by the respective arch maintainers?  How is that
handled in general?

> diff --git a/arch/Kconfig b/arch/Kconfig

> @@ -520,6 +520,13 @@ config SFRAME_VALIDATION
>  
>  	  If unsure, say N.
>  
> +config ARCH_SUPPORTS_SFRAME_UNWINDER
> +	bool
> +	help
> +	  An architecture can select this if it  enables the sframe (Simple
> +	  Frame) unwinder for unwinding kernel stack traces. It uses unwind
> +	  table that is directly generatedby toolchain based on DWARF CFI information.

Nit: s/sframe/SFrame/

> +
>  config HAVE_PERF_REGS
>  	bool
>  	help

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig

> @@ -112,6 +112,7 @@ config ARM64
>  	select ARCH_SUPPORTS_SCHED_SMT
>  	select ARCH_SUPPORTS_SCHED_CLUSTER
>  	select ARCH_SUPPORTS_SCHED_MC
> +	select ARCH_SUPPORTS_SFRAME_UNWINDER
>  	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
>  	select ARCH_WANT_DEFAULT_BPF_JIT

> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug

> @@ -20,4 +20,17 @@ config ARM64_RELOC_TEST
>  	depends on m
>  	tristate "Relocation testing module"
>  
> +config SFRAME_UNWINDER

Why do you introduce this for arm64 (and debug) only?  If s390 were to
add support (as replacement for s390 backchain), this would have to be
moved or duplicated.  It would not suffice to enable
ARCH_SUPPORTS_SFRAME_UNWINDER to also enable SFRAME_UNWINDER.

As mentioned in my feedback on the previous patch in this series:
Would it make sense to align the naming to the existing 
HAVE_UNWIND_USER_SFRAME, for instance:

  HAVE_UNWIND_KERNEL_SFRAME

> +	bool "Sframe unwinder"
> +	depends on AS_SFRAME3
> +	depends on 64BIT
> +	depends on ARCH_SUPPORTS_SFRAME_UNWINDER
> +	select SFRAME_LOOKUP
> +	help
> +	  This option enables the sframe (Simple Frame) unwinder for unwinding
> +	  kernel stack traces. It uses unwind table that is directly generated
> +	  by toolchain based on DWARF CFI information. In, practice this can
> +	  provide more reliable stacktrace results than unwinding with frame
> +	  pointers alone.

Nit: s/sframe/SFrame/

> +
>  source "drivers/hwtracing/coresight/Kconfig"

You are introducing two new Kconfig options (SFRAME_UNWINDER and
ARCH_SUPPORTS_SFRAME_UNWINDER).  I wonder whether they could somehow be
combined into a single new option.  Although I am not sure how an option
can be both selectable and depending at the same time, so that the ARM64
config could select it, but it would also depend on the above.

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h

> @@ -491,6 +491,8 @@
>  		*(.rodata1)						\
>  	}								\
>  									\
> +	SFRAME								\
> +									\
>  	/* PCI quirks */						\
>  	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
>  		BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_early,  __start, __end) \
> @@ -911,6 +913,19 @@
>  #define TRACEDATA
>  #endif
>  
> +#ifdef CONFIG_SFRAME_UNWINDER
> +#define SFRAME							\
> +	/* sframe */						\
> +	.sframe : AT(ADDR(.sframe) - LOAD_OFFSET) {		\
> +		__start_sframe_header = .;			\

		__start_sframe[_section] = .;

> +		KEEP(*(.sframe))				\
> +		KEEP(*(.init.sframe))				\
> +		__stop_sframe_header = .;			\

		__stop_sframe[_section] = .;

Unless I am missing something both are not the start/stop of the .sframe
header (in the .sframe section) but the .sframe section itself (see also
your subsequent "[PATCH v3 4/8] sframe: Provide PC lookup for vmlinux
.sframe section." where you assign both to kernel_sfsec.sframe_start
and kernel_sfsec.sframe_end.

> +	}
> +#else
> +#define SFRAME
> +#endif
> +
>  #ifdef CONFIG_PRINTK_INDEX
>  #define PRINTK_INDEX							\
>  	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


