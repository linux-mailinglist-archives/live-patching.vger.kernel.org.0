Return-Path: <live-patching+bounces-1872-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2D9C6F7B9
	for <lists+live-patching@lfdr.de>; Wed, 19 Nov 2025 16:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 5B8542A633
	for <lists+live-patching@lfdr.de>; Wed, 19 Nov 2025 15:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDAA35C18B;
	Wed, 19 Nov 2025 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q6o9m3Ap"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E30A357A2B;
	Wed, 19 Nov 2025 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763564403; cv=none; b=d4RjRsGDbcZ43EKSIbbKKRIY15sR9Mc9/ydZfpo/sZXMESmF8f5f2W5zMmIpLFzF+u42BAt/zqgbRCXkBZf7Wl0zp8N1eLmxDWHW277AGrXNBMFMHtEzTa8OED54koxD+tfjCKKlNFx6bc/R91/waMFFE8+Fz+k6St90o9ufR9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763564403; c=relaxed/simple;
	bh=KA2dL/q7A9hFduaTxppRHXZLDijVJdFDYBBGSWaP+RI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UvNv8IxOlXvde03YvGMSxJLiq27zdOgGc06MYZmeIzptsVdviTBvIXGjj8WFIoVjBxlZLDA3iCQZCN70mkmXuJKwkRsKEmlC95VLXult7KJu+DnW8B07twGQ/qAWEo22SsBq4U58WhMKZsd4tdBQxeuF9dWHj6duCFCDwZDSEoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q6o9m3Ap; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7TLrI024093;
	Wed, 19 Nov 2025 14:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2+Iz75
	nRJcTDkal5Phb4GXtvfN/Ge0k+gpHovarzoOs=; b=Q6o9m3ApyYY1WvZJmkCzjD
	SGp/p1ZLAywBNFo8ZXk+mlnsDppYHORuysQXHUidwtL8wfLJLUsSISIqXLfWNuTe
	aWpRbpMpIWKPPfH3e84ZO0sMYXx+xBMUe9F1lX05VDqdf4qvrvobmOdznDRQNCbT
	I65FAbM9/X2Iz2swSOO7b7kP3uuWbcJ9szYr2LsZ14HDVnkjRiLwS/qnGU3fO72Q
	KOKA8PDBJzRGIi7IxMRTxxaUXWyloMYvmJYDR+wxPMyC4wpsRuMSwoWedlclSjFb
	iiEdfYDtrMYKCr/RH6N27gd56UI21SgkxXXNhd9wdShbb31nTGwAK1jFx8WieToQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka11as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 14:59:20 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJEvSJu015374;
	Wed, 19 Nov 2025 14:59:20 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka11ae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 14:59:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJCeBBj017318;
	Wed, 19 Nov 2025 14:59:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af6j1rxcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 14:59:18 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJExEIZ8847858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 14:59:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD0F020043;
	Wed, 19 Nov 2025 14:59:14 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A1E620040;
	Wed, 19 Nov 2025 14:59:14 +0000 (GMT)
Received: from [9.155.200.37] (unknown [9.155.200.37])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 14:59:14 +0000 (GMT)
Message-ID: <910e6b23-4637-4c95-8202-01212af2d59c@linux.ibm.com>
Date: Wed, 19 Nov 2025 15:59:13 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] unwind: build kernel with sframe info
To: Dylan Hatch <dylanbhatch@google.com>,
        Josh Poimboeuf
 <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
        Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-2-dylanbhatch@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20250904223850.884188-2-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NEdPukv-2rmKzllanEEmhPyb_jj2ddAt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX8a1N485PEj5y
 UcLfylynUtHgUK1q1h1QjhwFkQaxeuloMYjkc0SQtT8FG4yQfJCtJBSa9nj4cwke+3iPrdzdKl5
 5ULlVLaRRdbF09kEDIwp5Uxezd1/dk8bQcxUhwAkm93smsfMH6w4G1Dp81T7AfgiMX2VmzMYXw8
 ru2gsSoqTnRpf7LsXnXvdRrx6hoB+wB4PoEfrRq3hRwVUxUAhhpr41MIBSBDOtKWoTQ5JOO2hhp
 Z/dU7GSpbFYqhFyEScjVqFYFq4T2g1ui0asxAnEbdOln0ssAB8DePhTizo+yazB+0MYI61BHn2o
 PluTwLz8hmp3Dsz3twZ0rnIHO9GIVDzHHP0Daamf/hqnMz2i4fU4cAKCHqxmcP7xXAl6GrN8Kqv
 fnENiRYM3Rm0aEZRN/80chC/Marvxw==
X-Proofpoint-ORIG-GUID: FJ9z7NAljrLNQL8LudJtIC6IJKFAu6Ei
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691ddb48 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=9Xp0JMHa146bnEPpIwAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

Hello Dylan!

On 9/5/2025 12:38 AM, Dylan Hatch wrote:
> Use the -Wa,--gsframe flags to build the code, so GAS will generate
> a new .sframe section for the stack trace information.
> Currently, the sframe format only supports arm64 and x86_64
> architectures. Add this configuration on arm64 to enable sframe
> unwinder in the future.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

> diff --git a/arch/Kconfig b/arch/Kconfig

> @@ -1782,4 +1782,10 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
>  config ARCH_HAS_CPU_ATTACK_VECTORS
>  	bool
>  
> +config AS_SFRAME
> +	def_bool $(as-instr,.cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc)

As you will soon be requiring SFrame V2 with the new PC-relative FDE
function start address encoding you may want to extend this check as
follows:

config AS_SFRAME
	def_bool y
	depends on $(as-instr,.cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc)
	depends on $(success,printf "%b\n" ".cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o "$$TMP" - && $(OBJDUMP) --sframe "$$TMP" | grep -q "SFRAME_VERSION_2")
	depends on $(success,printf "%b\n" ".cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o "$$TMP" - && $(OBJDUMP) --sframe "$$TMP" | grep -q "SFRAME_F_FDE_FUNC_START_PCREL")


Or you could change it into multiple config options, which might be
overkill:

config AS_SFRAME
	def_bool $(as-instr,.cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc)

config AS_SFRAME_V2
	def_bool y
	depends on AS_SFRAME
	depends on $(success,printf "%b\n" ".cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o "$$TMP" - && $(OBJDUMP) --sframe "$$TMP" | grep -q "SFRAME_VERSION_2")

config AS_SFRAME_V2_PCREL_FDE
	def_bool y
	depends on AS_SFRAME_V2
	depends on $(success,printf "%b\n" ".cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o "$$TMP" - && $(OBJDUMP) --sframe "$$TMP" | grep -q "SFRAME_F_FDE_FUNC_START_PCREL")

> +
> +config SFRAME_UNWIND_TABLE
> +	bool
> +
>  endmenu
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
+49-7031-16-1128 Office
jremus@de.ibm.com

IBM

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Böblingen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


