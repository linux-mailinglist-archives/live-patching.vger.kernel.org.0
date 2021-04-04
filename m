Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2123536B4
	for <lists+live-patching@lfdr.de>; Sun,  4 Apr 2021 06:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhDDEk5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 4 Apr 2021 00:40:57 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45828 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhDDEk5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 4 Apr 2021 00:40:57 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8B49220B5680;
        Sat,  3 Apr 2021 21:40:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8B49220B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617511253;
        bh=fCDUNY4RnNwMr8Xnv+6+5QOYhCKjx6Ej87nkMtaPNcI=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=qqKB0cyZSgUYk7HOv+KJkS5rhlZ0iNPmm5LXaVnNmBodZu5B23jedf/4AEo1HXcep
         ss9uBWRVyijOZ+A0zoJfUBwbrY+F/sGeWA9qkCbhOdNgfns6c10HBlK516049kqCQd
         wxldRpbrujAk9Ku35HvfkhJYrJj98L8wajD5h2DY=
Subject: Re: [RFC PATCH v2 1/1] arm64: Implement stack trace termination
 record
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
 <20210402032404.47239-2-madvenka@linux.microsoft.com>
 <20210403155948.ubbgtwmlsdyar7yp@treble>
 <171fef08-17d3-2c2e-dad8-6caf4c0c7f15@linux.microsoft.com>
Message-ID: <49790505-f611-b4a2-c804-b779060601a9@linux.microsoft.com>
Date:   Sat, 3 Apr 2021 23:40:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <171fef08-17d3-2c2e-dad8-6caf4c0c7f15@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/3/21 10:46 PM, Madhavan T. Venkataraman wrote:
>> I'm somewhat arm-ignorant, so take the following comments with a grain
>> of salt.
>>
>>
>> I don't think changing these to 'bl' is necessary, unless you wanted
>> __primary_switched() and __secondary_switched() to show up in the
>> stacktrace for some reason?  If so, that seems like a separate patch.
>>
> The problem is with __secondary_switched. If you trace the code back to where
> a secondary CPU is started, I don't see any calls anywhere. There are only
> branches if I am not mistaken. So, the return address register never gets
> set up with a proper address. The stack trace shows some hexadecimal value
> instead of a symbol name.
> 

Actually, I take that back. There are calls in that code path. But I did only
see some hexadecimal value instead of a proper address in the stack trace.
Sorry about that confusion.

My reason to convert the branches to calls is this - the value of the return
address register at that point is the return PC of the previous branch and link
instruction wherever that happens to be. I think that is a little arbitrary.

Instead, if I call start_kernel() and secondary_start_kernel(), the return address
gets set up to the next instruction which, IMHO, is better.

But I am open to other suggestions.

Madhavan
