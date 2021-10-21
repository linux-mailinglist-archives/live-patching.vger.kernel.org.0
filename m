Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F464361A6
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 14:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhJUMbG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 08:31:06 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49836 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhJUMbE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 08:31:04 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CFC5B20B7179;
        Thu, 21 Oct 2021 05:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CFC5B20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634819328;
        bh=DvHvI1eWTe/g+Ehqlznt9wtXs8WUeiscbm6lpSkMErM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YSvX7YSp4lwVxBlBM7o1zYZkCVrYuVhEO5iffMK7XhMMsFOtArvrvEjKUh+5fESNo
         ptiYAPdNHWleVi3nZ6fKVNDOMrm7hIzZHgZUfmnp4e6z1DTA407wINSW0a+ie7Ap9N
         UQU5dlSnzi/eWefqupMNyY/ubH+Ob5KgJbdV/K0Y=
Subject: Re: [PATCH v10 02/11] arm64: Make perf_callchain_kernel() use
 arch_stack_walk()
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-3-madvenka@linux.microsoft.com>
 <YXAu2aXqBU3rO5e+@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f528a0d2-3fc5-771d-4249-cc1a9685d4ae@linux.microsoft.com>
Date:   Thu, 21 Oct 2021 07:28:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXAu2aXqBU3rO5e+@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/20/21 9:59 AM, Mark Brown wrote:
> On Thu, Oct 14, 2021 at 09:58:38PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, perf_callchain_kernel() in ARM64 code walks the stack using
>> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
>> instead. This makes maintenance easier.
> 
>>  static bool callchain_trace(void *data, unsigned long pc)
>>  {
>>  	struct perf_callchain_entry_ctx *entry = data;
>> -	perf_callchain_store(entry, pc);
>> -	return true;
>> +	return perf_callchain_store(entry, pc) == 0;
>>  }
> 
> This changes us from unconditionally doing the whole walk to returning
> an error if perf_callchain_store() returns an error so it's not quite a
> straight transform, though since that seems like a useful improvement
> which most likely  on't have any practical impact that's fine.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

Thanks.

Madhavan
