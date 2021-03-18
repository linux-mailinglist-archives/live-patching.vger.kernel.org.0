Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C23340F12
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 21:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhCRU3f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 16:29:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:46606 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhCRU3U (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 16:29:20 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id D6CA420B39C5;
        Thu, 18 Mar 2021 13:29:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D6CA420B39C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616099360;
        bh=NYashDADQj5U4guXBYGYNqz58yYoc5xd3wmlNGCFhJ4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WvyUdTts2mfk1Bx6gUPgrA0HI+h5qR0lj4zP6ln5NPlgKiOTvJ0IDP/b4qceWrr30
         mnVWKgo6OAeSIZ5XaFS7CO5iNxLoZrbGY0l+N7k/A1CwAGZTFFaB6/KHrePgTSP2Ol
         WIGUdney3aQu7Sy585CzEDMgc/7tqk1W3eUuLlUQ=
Subject: Re: [RFC PATCH v2 3/8] arm64: Terminate the stack trace at TASK_FRAME
 and EL0_FRAME
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-4-madvenka@linux.microsoft.com>
 <20210318182607.GO5469@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <fd5763e4-b649-683b-3038-7f221eed68a9@linux.microsoft.com>
Date:   Thu, 18 Mar 2021 15:29:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210318182607.GO5469@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/18/21 1:26 PM, Mark Brown wrote:
> On Mon, Mar 15, 2021 at 11:57:55AM -0500, madvenka@linux.microsoft.com wrote:
> 
>> +	/* Terminal record, nothing to unwind */
>> +	if (fp == (unsigned long) regs->stackframe) {
>> +		if (regs->frame_type == TASK_FRAME ||
>> +		    regs->frame_type == EL0_FRAME)
>> +			return -ENOENT;
>>  		return -EINVAL;
>> +	}
> 
> This is conflating the reliable stacktrace checks (which your series
> will later flag up with frame->reliable) with verifying that we found
> the bottom of the stack by looking for this terminal stack frame record.
> For the purposes of determining if the unwinder got to the bottom of the
> stack we don't care what stack type we're looking at, we just care if it
> managed to walk to this defined final record.  
> 
> At the minute nothing except reliable stack trace has any intention of
> checking the specific return code but it's clearer to be consistent.
> 

So, you are saying that the type check is redundant. OK. I will remove it
and just return -ENOENT on reaching the final record.

Madhavan

