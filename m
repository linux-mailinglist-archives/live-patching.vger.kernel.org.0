Return-Path: <live-patching+bounces-2404-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGQvDlcZ5mkprgEAu9opvQ
	(envelope-from <live-patching+bounces-2404-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 14:17:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2641142A915
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 14:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 29285300D569
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 12:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0250632B9B6;
	Mon, 20 Apr 2026 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hl+3ZTHD"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131A175A5;
	Mon, 20 Apr 2026 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776687441; cv=none; b=I+y6ybyjgh8TC83TnnGWx7l2WQSo5V+rf4tm7OI5XOds+zxUxlmaoTb+d1VU+o6rMRnz+ywVM3WSvhu85pb5ZSAjCc7cFpqf2ah805IUwukOT6nFn7MUvYXnkGA0htf5eFDtnqMNQLQ8pgpvctkGgFXvT6kQhztSmvWaAbeTpN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776687441; c=relaxed/simple;
	bh=mair1umxSzNaaklyjREASMU5e4VR/MIo6s3jzgP5Jow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATDlBRI/ez+Hv+1MomHq8Xq/hRCscDO2BCHHJGOm9mHK3sYvVXbJy/Y4B3c94Stut7wXUgwoWDG7/cmiQCxHW1c7h86eF32+cx2oDi90JZ9tFQulThx8GT6bPFSjtPoBiE/ESoXdXX8K+diq2Fer89i3Bcu2jM+3vmxEeB6m4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hl+3ZTHD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JNd0YU3666654;
	Mon, 20 Apr 2026 12:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RXH0Up
	f7zVLNuuEHV0T3dwEIIz7eft2/h4fNJlDKdEk=; b=Hl+3ZTHD0HOurun+prtqC0
	rX2te5dDnyC6ucdTE730EAoPH5fgdyv5W43ssqnneYbexzJ68QyUOb92UcQdkKvP
	BnIYeF6NeRYAcX6ogg4Gd6NQfXBfVcn4tWuUo0aSoeoVxc9y4FhaT0HKXD2X0VAp
	rI0sSgym0Xbn1OGHii4kHAoVWLLaC9eWBrnKCg0CLpk+DCBJcH6eHQz+mI/COACh
	y1dEedd0z829duT1Qr+DL4sKvMlOBHW+BbylR7TIKKYEL098Hmjkhh8NSCAjpxkI
	eknl7HGzrUroM2HAYQ8Cn9sK1/YT6d8QU7JxbcP2bSzw7KpivRFJWdiIvg3kMX8Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2neypvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:16:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63KC5LWq020401;
	Mon, 20 Apr 2026 12:16:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmmnvmsg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:16:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63KCGaXQ45613488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:16:36 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B83020049;
	Mon, 20 Apr 2026 12:16:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEB4120040;
	Mon, 20 Apr 2026 12:16:34 +0000 (GMT)
Received: from [9.111.165.155] (unknown [9.111.165.155])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 12:16:34 +0000 (GMT)
Message-ID: <0f218a5c-fc2d-44bf-ab58-a017bd3b17ad@linux.ibm.com>
Date: Mon, 20 Apr 2026 14:16:34 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] arm64, unwind: build kernel with sframe V3 info
To: Dylan Hatch <dylanbhatch@google.com>
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
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-3-dylanbhatch@google.com>
 <cc7f741c-41a0-4620-b5d5-3428aaa7648f@linux.ibm.com>
 <CADBMgpyFd=id0M0Q+nZouBt9Ph6T=0PfP9xWuKOFWoLQd7zvng@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpyFd=id0M0Q+nZouBt9Ph6T=0PfP9xWuKOFWoLQd7zvng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: RmTBNsl_wyT_odABVKRAgPvqqGLhDOKq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDExNSBTYWx0ZWRfX6tzoeFTE9z5J
 8gzrq8X8BRGbcGb9IiRJnzCPV85PjfA9gn2yappkmw1buZ9D+2d/Gf4ni+ipkcdeYSZ51k79TX1
 lWuGOM/mGP9oj4l/DVwsdXEyI6Jpa+22KyJoZZnAEn4AGQqv3Hnq++LCEhDrCAAFYICZO9QBz1f
 /HGCNKzo3Rm+97n3iPGZkaoxa567U2/vQCkuryFXeGrwwvdZMNqVf9uiC6EUEfM3ZnHXy7ICvGJ
 a1YaASDjKksDT275AOqDJW6jIdPkSQYYb2BwW5xt13N7/rtyxUwnBrGQwkIF1CMfZlMKR9r8KTD
 ofuX02V1rOg/VnvCgUogurpXiFnRhowyHfTA1YPOfxpniMoGxL+vvNtQv38tb96kAE1IPum6CIX
 N6AmY0+B9oTgYwK98srv4Xp35JyuY25WCeOAVyuJrl5cDCzE43I34Yn1QVT6iN+4MXCkgI9h41s
 EOL094WwWLbM0DQEH8g==
X-Proofpoint-GUID: DChZuLL4cZsuszRWfxpzW1C75P78z0rg
X-Authority-Analysis: v=2.4 cv=B7iJFutM c=1 sm=1 tr=0 ts=69e6192a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=UydLMesKbQ_UbqRXWMAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200115
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-2404-lists,live-patching=lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
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
X-Rspamd-Queue-Id: 2641142A915
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/18/2026 2:20 AM, Dylan Hatch wrote:
> On Tue, Apr 14, 2026 at 5:43 AM Jens Remus <jremus@linux.ibm.com> wrote:

>> You are introducing two new Kconfig options (SFRAME_UNWINDER and
>> ARCH_SUPPORTS_SFRAME_UNWINDER).  I wonder whether they could somehow be
>> combined into a single new option.  Although I am not sure how an option
>> can be both selectable and depending at the same time, so that the ARM64
>> config could select it, but it would also depend on the above.
> 
> I don't think this is recommended, since the behavior of 'select'
> appears to override a 'depends' requirement.
> 
> From Documentation/kbuild/kconfig-language.rst: "select should be used
> with care. select will force a symbol to a value without visiting the
> dependencies. By abusing select you are able to select a symbol FOO
> even if FOO depends on BAR that is not set. In general use select only
> for non-visible symbols (no prompts anywhere) and for symbols with no
> dependencies. That will limit the usefulness but on the other hand
> avoid the illegal configurations all over."

Thanks for the explanation!  So both options cannot be merged into one.
Maybe the option names can still be aligned, so that they have
UNWIND_KERNEL_SFRAME in common and the kernel and user space sframe
unwinder options have HAVE_UNWIND in common?

  SFRAME_UNWINDER -> HAVE_UNWIND_KERNEL_SFRAME
  ARCH_SUPPORTS_SFRAME_UNWINDER -> ARCH_SUPPORTS_UNWIND_KERNEL_SFRAME

That would then align nicely with the existing:

  HAVE_UNWIND_USER_SFRAME

The only downside is that the user variant would get selected via
HAVE_UNWIND_USER_SFRAME and the kernel variant via
ARCH_SUPPORTS_UNWIND_KERNEL_SFRAME.

>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>>
>>> @@ -491,6 +491,8 @@
>>>               *(.rodata1)                                             \
>>>       }                                                               \
>>>                                                                       \
>>> +     SFRAME                                                          \
>>> +                                                                     \
>>>       /* PCI quirks */                                                \
>>>       .pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {        \
>>>               BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_early,  __start, __end) \
>>> @@ -911,6 +913,19 @@
>>>  #define TRACEDATA
>>>  #endif
>>>
>>> +#ifdef CONFIG_SFRAME_UNWINDER
>>> +#define SFRAME                                                       \
>>> +     /* sframe */                                            \
>>> +     .sframe : AT(ADDR(.sframe) - LOAD_OFFSET) {             \
>>> +             __start_sframe_header = .;                      \
>>
>>                 __start_sframe[_section] = .;
>>
>>> +             KEEP(*(.sframe))                                \
>>> +             KEEP(*(.init.sframe))                           \
>>> +             __stop_sframe_header = .;                       \
>>
>>                 __stop_sframe[_section] = .;
>>
>> Unless I am missing something both are not the start/stop of the .sframe
>> header (in the .sframe section) but the .sframe section itself (see also
>> your subsequent "[PATCH v3 4/8] sframe: Provide PC lookup for vmlinux
>> .sframe section." where you assign both to kernel_sfsec.sframe_start
>> and kernel_sfsec.sframe_end.
>>
>>> +     }
>>> +#else
>>> +#define SFRAME
>>> +#endif
>>> +
>>>  #ifdef CONFIG_PRINTK_INDEX
>>>  #define PRINTK_INDEX                                                 \
>>>       .printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {         \

What about the following?  Note that I also aligned the indentation in
vmlinux.lds.h to the one in the blocks above/below.

diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
@@ -31,6 +31,7 @@
  *     __irqentry_text_start, __irqentry_text_end
  *     __softirqentry_text_start, __softirqentry_text_end
  *     __start_opd, __end_opd
+ *     __start_sframe, __end_sframe
  */
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
@@ -53,6 +54,9 @@ extern char __ctors_start[], __ctors_end[];
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];

+/* Stand end end of .sframe section - used for stack unwinding. */
+extern char __start_sframe[], __end_sframe[];
+
 /* Start and end of instrumentation protected text section */
 extern char __noinstr_text_start[], __noinstr_text_end[];

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
@@ -914,13 +914,13 @@
 #endif

 #ifdef CONFIG_SFRAME_UNWINDER
-#define SFRAME							\
-	/* sframe */						\
-	.sframe : AT(ADDR(.sframe) - LOAD_OFFSET) {		\
-		__start_sframe_header = .;			\
-		KEEP(*(.sframe))				\
-		KEEP(*(.init.sframe))				\
-		__stop_sframe_header = .;			\
+#define SFRAME								\
+	/* sframe */							\
+	.sframe : AT(ADDR(.sframe) - LOAD_OFFSET) {			\
+		__start_sframe = .;					\
+		KEEP(*(.sframe))					\
+		KEEP(*(.init.sframe))					\
+		__end_sframe = .;					\
        }
 #else
 #define SFRAME

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


