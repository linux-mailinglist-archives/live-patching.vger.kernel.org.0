Return-Path: <live-patching+bounces-2864-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YAEiJ5BKDGrjdQUAu9opvQ
	(envelope-from <live-patching+bounces-2864-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 13:33:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 108E957DB30
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 13:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 16B1730ACAC0
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 11:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C5C480339;
	Tue, 19 May 2026 11:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GiIMYvgy"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EF93DD503;
	Tue, 19 May 2026 11:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779188766; cv=none; b=bUU2tdnr6a+mwfOipZeePgX2zweiFJnGGqVUT58wrNoHb6PEIUyGHUTsFOOnyd9Rz7s8KNNWiOv5megy6gizxR5FVup5A6xABXgsiNqXVwMZHJZNu+98PJuepCCE4Ga5mrMwLhtam3QnVYxN09NZ83mY4fwT7cOf4LFsMAWwPck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779188766; c=relaxed/simple;
	bh=NI/h//rtMvyHndBcVgWHP87GSBuc4qNJssmnF3fBPRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=apGOiRuTkxSnHR5IydTNrkgT9Chaak87CCxSbSV1py9ZmNJvQH9vBs2bVfJrcboN+E6yxSAvwgN5i4Gy6q0dTXBghhs4qnMByqzhmxuQbQpnemFu+ON6FsaeuHAL0Nt7XnC0rU1BWaNte4vuklIcoBpIgglyGgaMhiEoajHr8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GiIMYvgy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JB34J73464297;
	Tue, 19 May 2026 11:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ecz0b6
	bkTM2p7VEn/MpGtmMDhbNkBc+vtuAgUH6ZR4w=; b=GiIMYvgyhFpjDjuVLBYEK+
	VFfJCj9AZ/SipTuEMiOt5TgDa5XFwfJ2wGO254jR4nlBXRDHdC18LkWyMRJvMHsq
	SvZd3P0MFV6Y75O3e9NFh2uWjWGuNhkwMpFqfzku2TVmf6mrKw/zWXLDtUkVL44h
	4tkFJRNpokLtY5Zjm3SMiN0lmgTkYEf7+Sx44BeWvCo9N13kNjBMASoqleqzd6Tf
	tgX/k2pekoOQiS3ftcmqV5RChMTL3vbS9YxBizFD3ON8QO/3hl/0khFhaoSh92Ax
	rkmekvyP8GxZvgvAPNDwBV10ZMraNBWIN1caMAOAnUDub3GNw3qMpts/lpm5h9ng
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h74vjpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 11:05:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64JAs6S8005997;
	Tue, 19 May 2026 11:05:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wk28ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 11:05:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JB5O1u51577158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 11:05:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1060F20043;
	Tue, 19 May 2026 11:05:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 952802004E;
	Tue, 19 May 2026 11:05:23 +0000 (GMT)
Received: from [9.52.200.195] (unknown [9.52.200.195])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 May 2026 11:05:23 +0000 (GMT)
Message-ID: <4f429a50-df5d-411f-b40e-048d3cad5133@linux.ibm.com>
Date: Tue, 19 May 2026 13:05:23 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] unwind, arm64: add sframe unwinder for kernel
To: Dylan Hatch <dylanbhatch@google.com>, Mostafa Saleh <smostafa@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
        Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <agcEMEl-QR0g6DgF@google.com>
 <CADBMgpx38SUUuYYCm612STqh01jqv817WnJeeXYTD7Uc1r-fug@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpx38SUUuYYCm612STqh01jqv817WnJeeXYTD7Uc1r-fug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a0c43f7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=vi3vIZuo0_P7K9Gr5dYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FzCaTIywfcKYwO9lGZWeoSmYEglQVNGg
X-Proofpoint-GUID: KSjACJnZ7ULtZHp3LO8CcHya4AwIp6NF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEwNCBTYWx0ZWRfX3o6f60r+0H0z
 WCwAd+kx3qqdh+yG03cQdB8RPl+5woVIM0plZkhVj5tIXXYLi5CeNvE92eP1fzNfd7Oy/202N1O
 MdAD7c1uhVpLJsR+b084HRAmFBzzgsoOVrruXAEdoLVBLK8WlBpzcGZOVIzZA8Wt7tXgtK7O3sh
 O+YhlX8iWMNqMevbfYx861/E8MY2Qfc62jFA8GPbbdmqQvq8nley8HKWPTTZp2Dm+QYGn2+qtW6
 xIlvDKtf1C0JmzehN6LR2yOyY/A7cV//6kTftU/06XT09PUIR7oFcGdGEUFsIF2QMpvzaaIMxH2
 1feVFB8YUtgFr70PlYz3Z6bpRPuXBBc0vYEEzXJFVp1Yjiu7NSDbiD6Zy8dz9rfHJ9oVMWiiqpP
 +05TNX94AJFB4124JPwhSAEuhWM5p0Vn96sL7kfnePQfyvtMQakZT7ksk0lq2BCyuCju9IggX9w
 as7ag1RxqoQ+UzrF40g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190104
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	TAGGED_FROM(0.00)[bounces-2864-lists,live-patching=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.ibm.com:mid];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jremus@linux.ibm.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 108E957DB30
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Dylan and Mostafa!

On 5/18/2026 7:55 PM, Dylan Hatch wrote:
> On Fri, May 15, 2026 at 4:32 AM Mostafa Saleh <smostafa@google.com> wrote:
>> On Tue, Apr 28, 2026 at 06:36:35PM +0000, Dylan Hatch wrote:
>>> Implement a generic kernel sframe-based [1] unwinder. The main goal is
>>> to improve reliable stacktrace on arm64 by unwinding across exception
>>> boundaries.
>>>
>>> On x86, the ORC unwinder provides reliable stacktrace through similar
>>> methodology, but arm64 lacks the necessary support from objtool to
>>> create ORC unwind tables.
>>>
>>> Currently, there's already a sframe unwinder proposed for userspace: [2].
>>> To maintain common definitions and algorithms for sframe lookup, a
>>> substantial portion of this patch series aims to refactor the sframe
>>> lookup code to support both kernel and userspace sframe sections.
>>>
>>> Currently, only GNU Binutils support sframe. This series relies on the
>>> Sframe V3 format, which is supported in binutils 2.46.
>>>
>>> These patches are based on Steven Rostedt's sframe/core branch [3],
>>> which is and aggregation of existing work done for x86 sframe userspace
>>> unwind, and contains [2]. This branch is, in turn, based on Linux
>>> v7.0-rc3. This full series (applied to the sframe/core branch) is
>>> available on github: [4].
>>>
>>
>> Not sure if related, but after updating my toolchain
>> (aarch64-linux-gnu-gcc (Debian 15.2.0-4) 15.2.0), I hit link errors:
>> ld.lld: error: arch/arm64/kernel/vdso/vgettimeofday.o:(.sframe) is being placed in '.sframe'
>> ld.lld: error: arch/arm64/kernel/vdso/vgetrandom.o:(.sframe) is being placed in '.sframe`
> 
> Previously when developing against the SFrame V2 format, I had fixed
> these warnings with the VDSO Makefile change currently in this series:
> 
> diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> index 7dec05dd33b7..c60ef921956f 100644
> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -38,7 +38,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
>  CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
>                         $(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
>                         $(GCC_PLUGINS_CFLAGS) \
> -                       $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
> +                       $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(CC_FLAGS_SFRAME) \
>                         -Wmissing-prototypes -Wmissing-declarations
> 
>  CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
> 
> But the warnings seem to have returned after upgrading my toolchain,
> possibly due to SFrame V3 or some confounding change in GCC. The
> --gsframe in the assembler should be set to 'no' by default, so
> perhaps GCC is providing an override --gsframe internally?

Could it be that your build of binutils was configured with
--enable-default-sframe, so that the GNU assembler defaults to generate
.sframe?  AFAIK this configure option was meant for distributors and
package maintainers.

You can check as follows whether --gsframe defaults to "no" or "yes":

$ as --help | grep -A1 gsframe
  --gsframe[={no|yes}]    whether to generate SFrame stack trace information
                          (default: no)
...

> 
>>
>> I applied this series hoping that fix it, but it doesn't, so far I
>> have this hack :
>> diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
>> index 52314be29191..53bdf757ee44 100644
>> --- a/arch/arm64/kernel/vdso/vdso.lds.S
>> +++ b/arch/arm64/kernel/vdso/vdso.lds.S
>> @@ -77,7 +77,7 @@ SECTIONS
>>         /DISCARD/       : {
>>                 *(.data .data.* .gnu.linkonce.d.* .sdata*)
>>                 *(.bss .sbss .dynbss .dynsbss)
>> -               *(.eh_frame .eh_frame_hdr)
>> +               *(.eh_frame .eh_frame_hdr .sframe)
>>         }
>>  }
>>
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> index 60c8c22fd3e4..759903acd6fc 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -1064,6 +1064,7 @@
>>         /* ld.bfd warns about .gnu.version* even when not emitted */    \
>>         *(.gnu.version*)                                                \
>>         *(__tracepoint_check)                                           \
>> +       *(.sframe)                                                      \
>>
>>  #define DISCARDS                                                       \
>>         /DISCARD/ : {                                                   \
> 
> Since this series only handles kernel stacktrace, I believe it's
> better to omit the .sframe section entirely in the case where only
> ARCH_SUPPORTS_UNWIND_KERNEL_SFRAME is enabled. I think this hack may
> work better for this purpose:
> 
> diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> index c60ef921956f..29f802bfedb1 100644
> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -41,7 +41,7 @@ CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os
> $(CC_FLAGS_SCS) \
>                         $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(CC_FLAGS_SFRAME) \
>                         -Wmissing-prototypes -Wmissing-declarations
> 
> -CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
> +CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
> -Wa,--gsframe=no
> 
>  CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_REMOVE_VDSO)
>  CFLAGS_REMOVE_vgetrandom.o = $(CC_FLAGS_REMOVE_VDSO)
> 
> Though, I don't understand why it is necessary to provide --gsframe=no
> explicitly. If this approach seems ok to other folks/maintainers, I
> can fold this into my series.

Maybe build the VDSO separately with V=1 to see what assembler/compiler
options are effectively used (e.g. for vgettimeofday.o and vgetrandom.o
mentioned in the linker error message above)?

$ make mrproper
$ make defconfig
$ ./scripts/config --enable HAVE_UNWIND_KERNEL_SFRAME   # enable kernel sframe unwinder
$ make arch/arm64/kernel/vdso/ V=1

> 
> On the topic of SFrame for VDSO, Jens has a patch adding support for
> this as part of a series to support userspace SFrame unwinding for
> arm64:
> 
> https://lore.kernel.org/lkml/20260417150827.1183376-4-jremus@linux.ibm.com/

Any feedback is very welcome. :-)

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


