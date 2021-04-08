Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF7C358D6E
	for <lists+live-patching@lfdr.de>; Thu,  8 Apr 2021 21:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhDHTXx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Apr 2021 15:23:53 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54056 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhDHTXw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Apr 2021 15:23:52 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 77D1220B476F;
        Thu,  8 Apr 2021 12:23:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 77D1220B476F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617909821;
        bh=1ucpOVaj4G33S2W7MxZ0QwESYvIN0DIXzPkvhz27OVg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=L6SzZ58MCWNh1V5W5EzLM2R7xn5e2c9TRu6Q6CRINI5FgpsVBWzfRWQdI56btO5PK
         nqPt/9ylFdfzYXwKuIZxe+Xe1F3H3d8nOAZGhGp4OK/Q4hgeLTzwjEzIvuzKLqpuY3
         HqT/myyRqFcs9Mn73NMenjE28bW3C3aeK2jogkxM=
Subject: Re: [RFC PATCH v2 3/4] arm64: Detect FTRACE cases that make the stack
 trace unreliable
To:     Mark Brown <broonie@kernel.org>, mark.rutland@arm.com
Cc:     jpoimboe@redhat.com, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-4-madvenka@linux.microsoft.com>
 <20210408165825.GP4516@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <eacc6098-a15f-c07a-2730-cb16cb8e1982@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 14:23:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210408165825.GP4516@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/8/21 11:58 AM, Mark Brown wrote:
> On Mon, Apr 05, 2021 at 03:43:12PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled and tracing is activated
>> for a function, the ftrace infrastructure is called for the function at
>> the very beginning. Ftrace creates two frames:
> 
> This looks good to me however I'd really like someone who has a firmer
> understanding of what ftrace is doing to double check as it is entirely
> likely that I am missing cases here, it seems likely that if I am
> missing stuff it's extra stuff that needs to be added and we're not
> actually making use of the reliability information yet.
> 

OK. So, do you have some specific reviewer(s) in mind? Apart from yourself, Mark Rutland and
Josh Poimboeuf, these are some reviewers I can think of (in alphabetical order):

AKASHI Takahiro <takahiro.akashi@linaro.org>
Ard Biesheuvel <ard.biesheuvel@linaro.org>
Catalin Marinas <catalin.marinas@arm.com>
Josh Poimboeuf <jpoimboe@redhat.com>
Steven Rostedt (VMware) <rostedt@goodmis.org>
Torsten Duwe <duwe@suse.de>
Will Deacon <will@kernel.org>

Sorry if I missed out any of the other experts.

Thanks.

Madhavan                                                 
