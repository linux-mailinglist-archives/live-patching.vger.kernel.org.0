Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF551B6ED4
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2020 09:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgDXHUm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Apr 2020 03:20:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726317AbgDXHUm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Apr 2020 03:20:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O73JMn032705;
        Fri, 24 Apr 2020 03:20:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5t5dfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 03:20:30 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03O7H2r5072224;
        Fri, 24 Apr 2020 03:20:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5t5df1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 03:20:29 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03O7KLYY030948;
        Fri, 24 Apr 2020 07:20:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30fs658rkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 07:20:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03O7KPA450790596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 07:20:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 457615205A;
        Fri, 24 Apr 2020 07:20:25 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.14.129])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AC3FD5204E;
        Fri, 24 Apr 2020 07:20:24 +0000 (GMT)
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, Vasily Gorbik <gor@linux.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad> <20200422172126.743908f5@thinkpad>
 <20200422194605.n77t2wtx5fomxpyd@treble> <20200423141834.234ed0bc@thinkpad>
 <alpine.LSU.2.21.2004231513250.6520@pobox.suse.cz>
 <20200423141228.sjvnxwdqlzoyqdwg@treble>
 <20200423181030.b5mircvgc7zmqacr@treble>
 <20200423232657.7minzcsysnhp474w@treble>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <eb464a0b-922b-1dbd-81e6-1161a5157acb@de.ibm.com>
Date:   Fri, 24 Apr 2020 09:20:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423232657.7minzcsysnhp474w@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 suspectscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240052
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


On 24.04.20 01:26, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2020 at 01:10:30PM -0500, Josh Poimboeuf wrote:
>> On Thu, Apr 23, 2020 at 09:12:28AM -0500, Josh Poimboeuf wrote:
>>>>> this is strange. While I would have expected an exception similar to
>>>>> this, it really should have happened on the "sturg" instruction which
>>>>> does the DAT-off store in s390_kernel_write(), and certainly not with
>>>>> an ID of 0004 (protection). However, in your case, it happens on a
>>>>> normal store instruction, with 0004 indicating a protection exception.
>>>>>
>>>>> This is more like what I would expect e.g. in the case where you do
>>>>> _not_ use the s390_kernel_write() function for RO module text patching,
>>>>> but rather normal memory access. So I am pretty sure that this is not
>>>>> related to the s390_kernel_write(), but some other issue, maybe some
>>>>> place left where you still use normal memory access?
>>>>
>>>> The call trace above also suggests that it is not a late relocation, no? 
>>>> The path is from KLP module init function through klp_enable_patch. It should 
>>>> mean that the to-be-patched object is loaded (it must be a module thanks 
>>>> to a check klp_init_object_loaded(), vmlinux relocations were processed 
>>>> earlier in apply_relocations()).
>>>>
>>>> However, the KLP module state here must be COMING, so s390_kernel_write() 
>>>> should be used. What are we missing?
>>>
>>> I'm also scratching my head.  It _should_ be using s390_kernel_write()
>>> based on the module state, but I don't see that on the stack trace.
>>>
>>> This trace (and Gerald's comment) seem to imply it's using
>>> __builtin_memcpy(), which might expected for UNFORMED state.
>>>
>>> Weird...
>>
>> Mystery solved:
>>
>>   $ CROSS_COMPILE=s390x-linux-gnu- scripts/faddr2line vmlinux apply_rela+0x16a/0x520
>>   apply_rela+0x16a/0x520:
>>   apply_rela at arch/s390/kernel/module.c:336
>>
>> which corresponds to the following code in apply_rela():
>>
>>
>> 	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
>> 		if (info->plt_initialized == 0) {
>> 			unsigned int *ip;
>> 			ip = me->core_layout.base + me->arch.plt_offset +
>> 				info->plt_offset;
>> 			ip[0] = 0x0d10e310;	/* basr 1,0  */
>> 			ip[1] = 0x100a0004;	/* lg	1,10(1) */
>>
>>
>> Notice how it's writing directly to text... oops.
> 
> Here's a fix, using write() for the PLT and the GOT.

Are you going to provide a proper patch?

> 
> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> index 2798329ebb74..fe446f42818f 100644
> --- a/arch/s390/kernel/module.c
> +++ b/arch/s390/kernel/module.c
> @@ -297,7 +297,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  
>  			gotent = me->core_layout.base + me->arch.got_offset +
>  				info->got_offset;
> -			*gotent = val;
> +			write(gotent, &val, sizeof(*gotent));
>  			info->got_initialized = 1;
>  		}
>  		val = info->got_offset + rela->r_addend;
> @@ -330,25 +330,29 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
>  	case R_390_PLTOFF32:	/* 32 bit offset from GOT to PLT. */
>  	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
>  		if (info->plt_initialized == 0) {
> -			unsigned int *ip;
> +			unsigned int *ip, insn[5];
> +
>  			ip = me->core_layout.base + me->arch.plt_offset +
>  				info->plt_offset;
> -			ip[0] = 0x0d10e310;	/* basr 1,0  */
> -			ip[1] = 0x100a0004;	/* lg	1,10(1) */
> +
> +			insn[0] = 0x0d10e310;	/* basr 1,0  */
> +			insn[1] = 0x100a0004;	/* lg	1,10(1) */
>  			if (IS_ENABLED(CONFIG_EXPOLINE) && !nospec_disable) {
>  				unsigned int *ij;
>  				ij = me->core_layout.base +
>  					me->arch.plt_offset +
>  					me->arch.plt_size - PLT_ENTRY_SIZE;
> -				ip[2] = 0xa7f40000 +	/* j __jump_r1 */
> +				insn[2] = 0xa7f40000 +	/* j __jump_r1 */
>  					(unsigned int)(u16)
>  					(((unsigned long) ij - 8 -
>  					  (unsigned long) ip) / 2);
>  			} else {
> -				ip[2] = 0x07f10000;	/* br %r1 */
> +				insn[2] = 0x07f10000;	/* br %r1 */
>  			}
> -			ip[3] = (unsigned int) (val >> 32);
> -			ip[4] = (unsigned int) val;
> +			insn[3] = (unsigned int) (val >> 32);
> +			insn[4] = (unsigned int) val;
> +
> +			write(ip, insn, sizeof(insn));
>  			info->plt_initialized = 1;
>  		}
>  		if (r_type == R_390_PLTOFF16 ||
> 
