Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB2C359053
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 01:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhDHXag (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Apr 2021 19:30:36 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56694 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDHXaf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Apr 2021 19:30:35 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5D01120B5680;
        Thu,  8 Apr 2021 16:30:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D01120B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617924623;
        bh=rtX0nhS8f8A+Scs1O/M+oFYTu3Ey1F1VPqr0kIGuauo=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=s7Fj9Oh/qTR3tDYtSlFsbfbuzjpBXCHTp0H+Qe/7TzrQDT0lwxfy/8k85nDza/hyG
         0AwiTOIAKOUpUr0vAWduwMbcn7oXKOnjQ18iTrWHnIo0kbhdVQECjk3QDpS83etQbR
         WlztKMgU0sqU0F26wL38rykVg628AMmiJoAuzNNs=
Subject: Re: [RFC PATCH v2 1/4] arm64: Implement infrastructure for stack
 trace reliability checks
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-2-madvenka@linux.microsoft.com>
 <20210408171715.GQ4516@sirena.org.uk>
 <69b6924b-88f6-6c40-7b18-8cdf15d92bd1@linux.microsoft.com>
Message-ID: <eb905f70-a963-6257-c597-89e008675539@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 18:30:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <69b6924b-88f6-6c40-7b18-8cdf15d92bd1@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/8/21 2:30 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 4/8/21 12:17 PM, Mark Brown wrote:
>> On Mon, Apr 05, 2021 at 03:43:10PM -0500, madvenka@linux.microsoft.com wrote:
>>
>>> These checks will involve checking the return PC to see if it falls inside
>>> any special functions where the stack trace is considered unreliable.
>>> Implement the infrastructure needed for this.
>>
>> Following up again based on an off-list discussion with Mark Rutland:
>> while I think this is a reasonable implementation for specifically
>> listing functions that cause problems we could make life easier for
>> ourselves by instead using annotations at the call sites to put things
>> into sections which indicate that they're unsafe for unwinding, we can
>> then check for any address in one of those sections (or possibly do the
>> reverse and check for any address in a section we specifically know is
>> safe) rather than having to enumerate problematic functions in the
>> unwinder.  This also has the advantage of not having a list that's
>> separate to the functions themselves so it's less likely that the
>> unwinder will get out of sync with the rest of the code as things evolve.
>>
>> We already have SYM_CODE_START() annotations in the code for assembly
>> functions that aren't using the standard calling convention which should
>> help a lot here, we could add a variant of that for things that we know
>> are safe on stacks (like those we expect to find at the bottom of
>> stacks).
>>
> 
> As I already mentioned before, I like the idea of sections. The only reason that I did
> not try it was that I have to address FTRACE trampolines and the kretprobe_trampoline
> (and optprobes in the future).
> 
> I have the following options:
> 
> 1. Create a common section (I will have to come up with an appropriate name) and put
>    all such functions in that one section.
> 
> 2. Create one section for each logical type (exception section, ftrace section and
>    kprobe section) or some such.
> 

For now, I will start with idea 2. I will create a special section for each class of
functions (EL1 exception handlers, FTRACE trampolines, KPROBE trampolines). Instead of a
special functions array, I will implement a special_sections array. The rest of the code
should just fall into place.

Let me know if you prefer something different.

Thanks.

Madhavan

> 3. Use the section idea only for the el1 exceptions. For the others use the current
>    special_functions[] approach.
> 
> Which one do you and Mark Rutland prefer? Or, is there another choice?
> 
> Madhavan
> 
