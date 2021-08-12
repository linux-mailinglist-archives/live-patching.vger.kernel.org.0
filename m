Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792D43EA890
	for <lists+live-patching@lfdr.de>; Thu, 12 Aug 2021 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhHLQbI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Aug 2021 12:31:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38712 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhHLQbI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Aug 2021 12:31:08 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0D11A209C27F;
        Thu, 12 Aug 2021 09:30:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D11A209C27F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628785843;
        bh=XbkwddxOnXKOIWxSPdjEw6pV8uHuurpbRRZfVBwOPmM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=sXkUeg27ExLyw9ZPNJo/v1xnT+eiEbEX8HrsorSxkM394rNKtLDXOmsxXvBTcm66R
         otWP7lpIUBM4YP999xnNm7sCPfXuxOqQ3tyD++pvBi/XeVayVxNYMOvlQy6ljykJWu
         Onb3Yof6mzmlLOJ41g2CEy9pdvyWf1e3mOQow8n8=
Subject: Re: [RFC PATCH v7 1/4] arm64: Make all stack walking functions use
 arch_stack_walk()
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210812132435.6143-1-madvenka@linux.microsoft.com>
 <20210812132435.6143-2-madvenka@linux.microsoft.com>
 <20210812152331.GA4239@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <3c8b7882-047f-089d-a0e4-e62aedd6e045@linux.microsoft.com>
Date:   Thu, 12 Aug 2021 11:30:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812152331.GA4239@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 8/12/21 10:23 AM, Mark Brown wrote:
> On Thu, Aug 12, 2021 at 08:24:32AM -0500, madvenka@linux.microsoft.com wrote:
> 
>> Here is the list of functions:
>>
>> 	perf_callchain_kernel()
>> 	get_wchan()
>> 	return_address()
>> 	dump_backtrace()
>> 	profile_pc()
> 
> I've not actually gone through this properly yet but my first thought is
> that for clarity this should be split out into a patch per user plus one
> to delete the old interface  - I'd not worry about it unless it needs to
> get resubmitted though.
> 

OK. I will address it in the next version.

> It'll definitely be good to get this done!

Yes. Thanks!

Madhavan
