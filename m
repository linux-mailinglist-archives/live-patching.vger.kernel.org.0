Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09703519A2
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhDARzv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 13:55:51 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33344 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236438AbhDARoy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 13:44:54 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3ED6F20B5681;
        Thu,  1 Apr 2021 10:44:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3ED6F20B5681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617299094;
        bh=tj4All66YvRaz0uEaJH4fLorSz5QIaGO2BKEoSy8t1w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QhRPhOZITHB+GM/lRF9u00GgTQ5EDonsgz6Kg4SxH+WEOc5fNboP2tmwARdYXXJo9
         zGFgGKHXD5XCDkYIhrjFCJ3Z+oxP7JVCRXzVQfTXXjIOldg9jg17BHtcVjXceVUADx
         PqrfhF+YSd2z/gxIMMJk+Z4JUfNMBJZp0+BfufOE=
Subject: Re: [RFC PATCH v1 1/4] arm64: Implement infrastructure for stack
 trace reliability checks
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-2-madvenka@linux.microsoft.com>
 <20210401152741.GK4758@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <ecdca67a-223f-40de-ebfa-89183e15a2a8@linux.microsoft.com>
Date:   Thu, 1 Apr 2021 12:44:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210401152741.GK4758@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/1/21 10:27 AM, Mark Brown wrote:
> On Tue, Mar 30, 2021 at 02:09:52PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Implement a check_reliability() function that will contain checks for the
>> presence of various features and conditions that can render the stack trace
>> unreliable.
> 
> This looks good to me with one minor stylistic thing:
> 
>> +/*
>> + * Special functions where the stack trace is unreliable.
>> + */
>> +static struct function_range	special_functions[] = {
>> +	{ 0, 0 }
>> +};
> 
> Might be good to put a comment here saying that this is terminating the
> list rather than detecting a NULL function pointer:
> 
> 	{ /* sentinel */ }
> 
> is a common idiom for that.
> 
> Given that it's a fixed array we could also...
> 
>> +	for (func = special_functions; func->start; func++) {
>> +		if (pc >= func->start && pc < func->end)
> 
> ...do these as
> 
> 	for (i = 0; i < ARRAY_SIZE(special_functions); i++) 
> 
> so you don't need something like that, though that gets awkward when you
> have to write out special_functions[i].field a lot.
> 
> So many different potential colours for the bikeshed!
I will make the above changes.

Thanks!

Madhavan
