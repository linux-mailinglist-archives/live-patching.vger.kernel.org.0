Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7924383B3
	for <lists+live-patching@lfdr.de>; Sat, 23 Oct 2021 14:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhJWMvf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 23 Oct 2021 08:51:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55314 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhJWMvc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 23 Oct 2021 08:51:32 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id A0CEE2064891;
        Sat, 23 Oct 2021 05:49:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A0CEE2064891
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634993353;
        bh=xFXuz9rWSnTF5MnVRUBihVdw9KXSz2G2i8s+MV54MGs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MyYom8geXOg8HqEQJRagVh7NRn+nyAPArhhuQaY/De8NjNB2y0l9ZS65Kb0yJi+3J
         m/dLNcPFaiFEDL+OLyYWU57lThwPyNP/x4RcF23n8y3Q0rJKhFsCKDjWWejTi0ntM1
         kyHpKu3qL9Ucxc5YoduFkndzjlQiFdqggCnvYlyY=
Subject: Re: [PATCH v10 02/11] arm64: Make perf_callchain_kernel() use
 arch_stack_walk()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-3-madvenka@linux.microsoft.com>
 <20211022181154.GM86184@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <4de6800b-54fc-a74d-598f-80fc40924976@linux.microsoft.com>
Date:   Sat, 23 Oct 2021 07:49:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022181154.GM86184@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/22/21 1:11 PM, Mark Rutland wrote:
> On Thu, Oct 14, 2021 at 09:58:38PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, perf_callchain_kernel() in ARM64 code walks the stack using
>> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
>> instead. This makes maintenance easier.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> 
> This looks good to me; bailing out when perf_callchain_store() can't
> accept any more entries absolutely makes sense.
> 
> I gave this a spin with:
> 
> | #  perf record -g -c1 ls
> | #  perf report
> 
> ... and the recorded callchains look sane.
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> 

Thanks a lot!

> As mentioned on patch 1, I'd like to get this rebased atop Peter's
> untangling of ARCH_STACKWALK from STACKTRACE.
> 

Will do.

Thanks.

Madhavan
