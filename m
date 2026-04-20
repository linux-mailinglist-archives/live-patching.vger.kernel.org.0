Return-Path: <live-patching+bounces-2405-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kN6IITsd5mlurwEAu9opvQ
	(envelope-from <live-patching+bounces-2405-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 14:34:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB5542AC86
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 14:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 632B8301BDA3
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 12:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED0819E992;
	Mon, 20 Apr 2026 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rMNDtetx"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B56A3A8F7;
	Mon, 20 Apr 2026 12:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776688288; cv=none; b=hnL8QAGb3z7eLwxiVq3Rggsu2YCm0qbdec91Ahuboj5iLqHhjZ3pauAGX1OumVG2gX6CJD7rddl9AN7IvTeyqPpFhHFiv8fIM6ggryfrlVAFXxXtoLvxVUWxb73/eHjuCI43SkW4NjAHhPWT7aNfwyNYmZWAXvSaZmcNu37SPCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776688288; c=relaxed/simple;
	bh=Hd76fdCy+lIO378xzbjX8I8tq9eweoRaEgSD9nPCNvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AybE0x5fM3gzaOBJayjcfMGAp5vyoN4o+4s5zRPDE0qislmcsArCgIUkeAtoZCjPiqw+htWm0znKb/gh/GIw6gxvwOYMNa5TLu37N1j37njjipWq8skUYByGBgIfk47DEtLUQcEZcYt4pA3HNm6kwyhzG4GktP7fZ5YJHEzIHn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rMNDtetx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K84N7B1315637;
	Mon, 20 Apr 2026 12:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=v0oh8O
	bVVCeBTHGmr5CI1H7l8TfoFStEIpFsXDmc3YA=; b=rMNDtetxSZpBAIDxkZ8Mxx
	kidVcGRyS4b2nP51sOQ0v01xOCcY/P0AcoaX4X1f4mMCkJE8Bsuplf0fPppkk++I
	u1hzCug6wRwz2OPxymQfuM5buyd0pwXTlcKOgjDLSyQ7p3uPrHQLnVY9swX3jnVv
	Ro6WxraGn1II9/jRrq3Umw/8Ina5pZ7Qt0k339BiRGInArG68fXZfxZn62FNj5kj
	shSU1j9Tl3iQ9M5JQiYIGeeduLkIMwg0xwI+2gI8UifKPlCr7Sa7F5XE9VSbE5mf
	z07Am3Mwg55PiqSQXZTZ2GY8ZYKiW6H7M9C/gCpK0605mxGuQTrRlEpbAgSGzM+Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k6f2r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:30:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63KCKKlD023663;
	Mon, 20 Apr 2026 12:30:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmpyxvg0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:30:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63KCUtao48890174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:30:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5D8E20049;
	Mon, 20 Apr 2026 12:30:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3A5320040;
	Mon, 20 Apr 2026 12:30:54 +0000 (GMT)
Received: from [9.111.165.155] (unknown [9.111.165.155])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 12:30:54 +0000 (GMT)
Message-ID: <dde1daa9-724c-4186-aaf6-caff6b47c5a9@linux.ibm.com>
Date: Mon, 20 Apr 2026 14:30:54 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION.
To: Dylan Hatch <dylanbhatch@google.com>, Indu Bhagat <ibhagatgnu@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
        Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Heiko Carstens <hca@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-8-dylanbhatch@google.com>
 <de7bd273-3650-4378-8fd8-a51217e7284b@linux.ibm.com>
 <CADBMgpzbEGTm-sZ71a5hvFOHbu5VgSR406F3NsMLF1+oDWbO6A@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpzbEGTm-sZ71a5hvFOHbu5VgSR406F3NsMLF1+oDWbO6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=L78theT8 c=1 sm=1 tr=0 ts=69e61c83 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=ey2SWGRYxIHPRPJathMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDEyMSBTYWx0ZWRfXyqB1aAGJ4E5U
 fBeYcJnCFz+KY+gDJ1Cv+qgW/fGLGqqXAsxvXJrsEbYdncMs//rNYMIQLwxmkiKrax5kFeX9lPc
 GgXO1FbRS/A2G0bnLez1rBYmm0nUrFKq3ZwdSYHvYwNFOHC3bUGwvyTXPPh7eifFJOCjD4OCNE3
 KXRxHfJfoCzrs1PmdA/+EjMFoiU8CY78/oWuF3k/SUOP7YAUuprJVMvaIjKddlw5Uig9UqPRJSW
 WvTVfq2umhBwK3ChJ9xIJf9Lu9KoaFeZ/3Bx8rpH/VnA/tbVsHBZ3T9/t1qX4i+omLF94U31xMz
 TKmPDW6vSCnZkGuWWIrufkwPFKiDbbnic39Jd7N3+qvwgo9aAtX6NFOXiwbcAkNvKw2MqekkXlb
 cAu1mLadEbWVx05NtL6sfvezTPZOwLG0pCGGBb5cq0joJhrNeN+H6Tzde+k5P6kG11zVf3mHPi1
 Bk2ao/aO0VucuR3Reiw==
X-Proofpoint-GUID: fAdiLJEaC4RUIfPJcrzitXNXiwHaXtJ-
X-Proofpoint-ORIG-GUID: gJkjqQ6DY8q37d5ZU6XKT_G0uVg3okQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200121
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
	TAGGED_FROM(0.00)[bounces-2405-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[google.com,gmail.com];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.ibm.com:mid];
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
X-Rspamd-Queue-Id: 9AB5542AC86
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/20/2026 7:02 AM, Dylan Hatch wrote:
> On Thu, Apr 16, 2026 at 8:04 AM Jens Remus <jremus@linux.ibm.com> wrote:
>> On 4/6/2026 8:49 PM, Dylan Hatch wrote:

>>> Generalize the __safe* helpers to support a non-user-access code path.
>>> Allow for kernel FDE read failures due to the presence of .rodata.text.
>>> This section contains code that can't be executed by the kernel
>>> direclty, and thus lies ouside the normal kernel-text bounds.
>>
>> Nits: s/direclty/directly/ s/ouside/outside/
>>
>> Could you please explain the issue?  How/why does .sframe for
>> .rodata.text pose an issue for .sframe verification?
> 
> __read_fde checks that the fde_addr it extracts is within the bounds
> of sec->text_start and sec->text_end. In the case of the vmlinux

Looking at the existing check in __read_fde(), do you agree that it is
wrong, as sec->text_end IIUC points behind .text and thus the check
should be:

	if (func_addr < sec->text_start || func_addr >= sec->text_end)
        	return -EINVAL;

> .sframe section, this is _stext and _etext. However on arm64, there is
> an .rodata.text section that lies outside this range. From
> arch/arm64/kernel/vmlinux.lds.S:
> 
>         /* code sections that are never executed via the kernel mapping */
>         .rodata.text : {
>                 TRAMP_TEXT
>                 HIBERNATE_TEXT
>                 KEXEC_TEXT
>                 IDMAP_TEXT
>                 . = ALIGN(PAGE_SIZE);
>         }
> 
> So __read_fde fails for functions in this section. Under normal SFrame
> usage for unwinding, we should never need to look up a PC value in
> these functions because they will never be executed by the kernel.
> However, we still hit this error when validating all FDEs.

Thanks for the explanation!  Could you please improve the commit
message, for instance as follows:

__read_fde() checks that the extracted FDE function start address is
within the bounds of the .text section start and end.  In case of
vmlinux this is _stext and _etext.  However on arm64, .rodata.text
resides outside this range, causing __read_fde() to fail.

> I think ideally we might prevent sframe data from being generated for
> this code (maybe from the linker script somehow?), but I don't know of
> a simple way to do this.

I dont't know of any way to exclude a single function or a whole section
from .sframe generation.  The GNU linker would discard SFrame FDEs and
its FREs for discarded functions.  But in this case the function itself
is not discarded.  As .sframe is not generated separately per section it
is also not possible to discard e.g. .sframe.rodata.

> Alternatively, we can check for FDEs located
> in .rodata.text during validation, but this seems to only be present
> in arm64, so maybe we would need an arch-specific hook to do this? I'm
> open to suggestions.

Maybe that is better than ignoring __read_fde() failures?  I first
thought this would get nasty, but maybe it would not be too bad.
Following is what I came up with (note tabs replaced by spaces due to
copy&paste from terminal):

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
@@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char _srodatatext[], _erodatatext[];

 static inline size_t entry_tramp_text_size(void)
 {
diff --git a/arch/arm64/include/asm/unwind_sframe.h b/arch/arm64/include/asm/unwind_sframe.h
@@ -2,11 +2,28 @@
 #ifndef _ASM_ARM64_UNWIND_SFRAME_H
 #define _ASM_ARM64_UNWIND_SFRAME_H

+#include <linux/sframe.h>
+
 #ifdef CONFIG_ARM64

 #define SFRAME_REG_SP  31
 #define SFRAME_REG_FP  29

+static inline bool sframe_func_start_addr_valid(struct sframe_section *sec,
+                                               unsigned long func_addr)
+{
+       return (sec->text_start >= func_addr && func_addr < sec->text_end) ||
+              (sec->rodatatext_start >= func_addr && func_addr < sec->rodatatext_end);
+}
+#define sframe_func_start_addr_valid sframe_func_start_addr_valid
+
+static void arch_init_sframe_table(struct sframe_section *kernel_sfsec)
+{
+       kernel_sfsec->rodatatext_start  = (unsigned long)_srodatatext;
+       kernel_sfsec->rodatatext_end    = (unsigned long)_erodatatext;
+}
+#define arch_init_sframe_table arch_init_sframe_table
+
 #endif

 #endif /* _ASM_ARM64_UNWIND_SFRAME_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
@@ -213,12 +213,14 @@ SECTIONS

        /* code sections that are never executed via the kernel mapping */
        .rodata.text : {
+               _srodatatext = .;
                TRAMP_TEXT
                HIBERNATE_TEXT
                KEXEC_TEXT
                IDMAP_TEXT
                . = ALIGN(PAGE_SIZE);
        }
+       _erodatatext = .;

        idmap_pg_dir = .;
        . += PAGE_SIZE;
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
@@ -63,6 +63,10 @@ struct sframe_section {
        unsigned long           sframe_end;
        unsigned long           text_start;
        unsigned long           text_end;
+#if defined(CONFIG_SFRAME_UNWINDER) && defined(CONFIG_ARM64)
+       unsigned long           rodatatext_start;
+       unsigned long           rodatatext_end;
+#endif

        bool                    fdes_sorted;
        unsigned long           fdes_start;
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
@@ -20,11 +20,23 @@
 #include "sframe.h"
 #include "sframe_debug.h"

+#ifndef sframe_func_start_addr_valid
+static inline bool sframe_func_start_addr_valid(struct sframe_section *sec,
+                                                unsigned long func_addr)
+{
+       return (sec->text_start <= func_addr && func_addr < sec->text_end);
+}
+#endif
+
 #ifdef CONFIG_SFRAME_UNWINDER

 static bool sframe_init __ro_after_init;
 static struct sframe_section kernel_sfsec __ro_after_init;

+#ifndef arch_init_sframe_table
+static void arch_init_sframe_table(struct sframe_section *kernel_sfsec) {}
+#endif
+
 #endif /* CONFIG_SFRAME_UNWINDER */

 struct sframe_fde_internal {
@@ -152,7 +164,7 @@ static __always_inline int __read_fde(struct sframe_section *sec,
                  sizeof(struct sframe_fde_v3), Efault);

        func_addr = fde_addr + _fde.func_start_off;
-       if (func_addr < sec->text_start || func_addr > sec->text_end)
+       if (!sframe_func_start_addr_valid(sec, func_addr))
                return -EINVAL;

        fda_addr = sec->fres_start + _fde.fres_off;
@@ -696,13 +708,6 @@ static int sframe_validate_section(struct sframe_section *sec)
                int ret;

                ret = safe_read_fde(sec, i, &fde);
-               /*
-                * Code in .rodata.text is not considered part of normal kernel
-                * text, but there is no easy way to prevent sframe data from
-                * being generated for it.
-                */
-               if (ret && sec->sec_type == SFRAME_KERNEL)
-                       continue;
                if (ret)
                        return ret;

@@ -1031,6 +1036,8 @@ void __init init_sframe_table(void)
        if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
                return;

+       arch_init_sframe_table(&kernel_sfsec);
+
        sframe_init = true;
 }

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


