Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065B13465B4
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhCWQxi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 12:53:38 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55348 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhCWQxG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 12:53:06 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3C43E20B5680;
        Tue, 23 Mar 2021 09:53:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3C43E20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616518385;
        bh=bsWnf5PwIqc8V0tuB6C6T1DpJkJTvse0YHx93Jrj8Xg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Bkm0j+9ZRXt0B8Tn2aSIRanJbDitVzQx4He1n2vaiw/cjk+mhWR23xruB+O7BjPYw
         Swcynk9xosQ+mND+C0Az/N1ay2W54jPgIfK0XAYxmHRfYK6XvuU/GKFWZ+FdHYQgEC
         uoC8Bo5zulY5pM92BSr5N3ZxKFIP1ad8riDSJdiM=
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a stack
 trace unreliable
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <20210323164801.GE98545@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bfc4dbbd-f69b-1a41-c16a-0c5cd0080f90@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 11:53:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210323164801.GE98545@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 11:48 AM, Mark Rutland wrote:
> On Tue, Mar 23, 2021 at 10:26:50AM -0500, Madhavan T. Venkataraman wrote:
>> On 3/23/21 9:57 AM, Mark Rutland wrote:
>> Thanks for explaining the nesting. It is now clear to me.
> 
> No problem!
> 
>> So, my next question is - can we define a practical limit for the
>> nesting so that any nesting beyond that is fatal? The reason I ask is
>> - if there is a max, then we can allocate an array of stack frames out
>> of band for the special frames so they are not part of the stack and
>> will not likely get corrupted.
> 
> I suspect we can't define such a fatal limit without introducing a local
> DoS vector on some otherwise legitimate workload, and I fear this will
> further complicate the entry/exit logic, so I'd prefer to avoid
> introducing a new limit.
> 

I suspected as much. But I thought I will ask anyway.

> What exactly do you mean by a "special frame", and why do those need
> additional protection over regular frame records?
> 

Special frame just means pt_regs->stackframe that is used for exceptions.
No additional protection is needed. I just meant that since they are
out of band, we can reliably tell that there are exceptions without
examining the stack. That is all.

>> Also, we don't have to do any special detection. If the number of out
>> of band frames used is one or more then we have exceptions and the
>> stack trace is unreliable.
> 
> What is expected to protect against?
> 

It is not a protection thing. I just wanted a reliable way to tell that there
is an exception without having to unwind the stack up to the exception frame.
That is all.

Thanks.

Madhavan
