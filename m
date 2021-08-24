Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D813F5DCC
	for <lists+live-patching@lfdr.de>; Tue, 24 Aug 2021 14:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbhHXMUj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 08:20:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57860 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhHXMUi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 08:20:38 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id B35BD20B85E0;
        Tue, 24 Aug 2021 05:19:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B35BD20B85E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629807594;
        bh=2E2BthqVOdbe3t0YwvDr36tRv3x3At3+Zrr/r40y7RI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mR9DYLTNg0m86G7ZUVWEjSBEaT74uQ6YJ1vdiQ515TrjZfPVisZI2DnrylKPs15Zh
         EwYxTrM1e/V8gSsMdp9oyPgX205r5zm9fzlC6y1NBiiHmKsAT9Z3KUVNvYlPs+KePY
         5AY08rQN8w5gYih+LZNJGU8NAcnDLh925So09CHE=
Subject: Re: [RFC PATCH v8 3/4] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
Cc:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
        "jthierry@redhat.com" <jthierry@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-4-madvenka@linux.microsoft.com>
 <TY2PR01MB5257EA835C6F28ABF457EB0B85C59@TY2PR01MB5257.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <62d8969d-8ba1-4554-16b4-1c0bd4f8d9e7@linux.microsoft.com>
Date:   Tue, 24 Aug 2021 07:19:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB5257EA835C6F28ABF457EB0B85C59@TY2PR01MB5257.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 8/24/21 12:55 AM, nobuta.keiya@fujitsu.com wrote:
> Hi Madhavan,
> 
>> @@ -245,7 +271,36 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>  		fp = thread_saved_fp(task);
>>  		pc = thread_saved_pc(task);
>>  	}
>> -	unwind(consume_entry, cookie, task, fp, pc);
>> +	unwind(consume_entry, cookie, task, fp, pc, false);
>> +}
>> +
>> +/*
>> + * arch_stack_walk_reliable() may not be used for livepatch until all of
>> + * the reliability checks are in place in unwind_consume(). However,
>> + * debug and test code can choose to use it even if all the checks are not
>> + * in place.
>> + */
> 
> I'm glad to see the long-awaited function :)
> 
> Does the above comment mean that this comment will be removed by
> another patch series that about live patch enablement, instead of [PATCH 4/4]?
> 
> It seems to take time... But I start thinking about test code.
> 

Yes. This comment will be removed when livepatch will be enabled eventually.
So, AFAICT, there are 4 pieces that are needed:

- Reliable stack trace in the kernel. I am trying to address that with my patch
  series.

- Mark Rutland's work for making patching safe on ARM64.

- Objtool (or alternative method) for stack validation.

- Suraj Jitindar Singh's patch for miscellaneous things needed to enable live patch.

Once all of these pieces are in place, livepatch can be enabled.

That said, arch_stack_walk_reliable() can be used for test and debug purposes anytime
once this patch series gets accepted.

Thanks.

Madhavan
