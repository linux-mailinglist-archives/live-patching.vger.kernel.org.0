Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1636039C16F
	for <lists+live-patching@lfdr.de>; Fri,  4 Jun 2021 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDUkj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 16:40:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43114 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFDUkj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 16:40:39 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 804C320B7178;
        Fri,  4 Jun 2021 13:38:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 804C320B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622839132;
        bh=/45hWiDZcsHWctcr5hRZBQDWDhCLQeyVYjjw+Z2h/ao=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SOCXYevWE8GoQHgMS+3odsSucYuupPTeMrZQ3CPj2riFz+5QZ3Kla+sx5bOFcjDvR
         xQUrOnf+PaeR9D1GheUMoWk0//YkB6TQZAbCBpNS4ghgjHk5IvJDBpt9wuCDUkWGX9
         M8JNMo4Cg8f/VoC+ib2xNR0kSPLQwvlUcJ/rsp5w=
Subject: Re: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210526214917.20099-3-madvenka@linux.microsoft.com>
 <20210604162415.GF4045@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <903c61d7-5717-c9df-29c5-4f162f84e84c@linux.microsoft.com>
Date:   Fri, 4 Jun 2021 15:38:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210604162415.GF4045@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/4/21 11:24 AM, Mark Brown wrote:
> On Wed, May 26, 2021 at 04:49:17PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> The unwinder should check if the return PC falls in any function that
>> is considered unreliable from an unwinding perspective. If it does,
>> mark the stack trace unreliable.
> 
> Reviwed-by: Mark Brown <broonie@kernel.org>
> 

Thanks.

> However it'd be good for someone else to double check this as it's
> entirely possible that I've missed some case here.
> 

I will request Mark Rutland to review this as well.

>> + * Some special cases covered by sym_code_functions[] deserve a mention here:
> 
>> + *	- All EL1 interrupt and exception stack traces will be considered
>> + *	  unreliable. This is the correct behavior as interrupts and exceptions
>> + *	  can happen on any instruction including ones in the frame pointer
>> + *	  prolog and epilog. Unless stack metadata is available so the unwinder
>> + *	  can unwind through these special cases, such stack traces will be
>> + *	  considered unreliable.
>> + *
> 
> If you're respinning this it's probably also worth noting that we only
> ever perform reliable stack trace on either blocked tasks or the current
> task which should if my reasoning is correct mean that the fact that
> the exclusions here mean that we avoid having to worry about so many
> race conditions when entering and leaving functions.  If we got
> preempted at the wrong moment for one of them then we should observe the
> preemption and mark the trace as unreliable due to that which means that
> any confusion the race causes is a non-issue.
> 

I will add a comment that "livepatch only looks at tasks that are currently
not on any CPU (except for the current task). Such tasks either blocked
on something and gave up the CPU voluntarily. Or, they were preempted.
The above comment applies to the latter case".

Madhavan
