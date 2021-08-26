Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85C53F90F8
	for <lists+live-patching@lfdr.de>; Fri, 27 Aug 2021 01:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243742AbhHZXcR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Aug 2021 19:32:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37308 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhHZXcQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Aug 2021 19:32:16 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5204320B8618;
        Thu, 26 Aug 2021 16:31:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5204320B8618
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1630020688;
        bh=8v9TbhpIJoMv6rGK5bzfoY2JnYeMp9qeCuyaeZeJfRQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pKyaAZvn1TecJCW+X412OG7vHpPkFDuUavVwfNG1/94nsn1jNsQVxnN9fxu5HqLE5
         Fr37WTsD4sXkCecqaNCnvPJqr2MKnwe/ip942OuyKk8zKblwgnCRGCUxCjaTdrYkpq
         cmJTLO4NJxbopAAvKZ6OhojUlYk01wHqY8buj3/8=
Subject: Re: [RFC PATCH v8 3/4] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-4-madvenka@linux.microsoft.com>
 <YSe50PuWM/mjNwAj@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <77c43173-95c9-6ce5-ad11-219d38a66e34@linux.microsoft.com>
Date:   Thu, 26 Aug 2021 18:31:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YSe50PuWM/mjNwAj@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 8/26/21 10:57 AM, Mark Brown wrote:
> On Thu, Aug 12, 2021 at 02:06:02PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> +	if (frame->need_reliable && !unwind_is_reliable(frame)) {
>> +		/* Cannot unwind to the next frame reliably. */
>> +		frame->failed = true;
>> +		return false;
>> +	}
> 
> This means we only collect reliability information in the case
> where we're specifically doing a reliable stacktrace.  For
> example when printing stack traces on the console it might be
> useful to print a ? or something if the frame is unreliable as a
> hint to the reader that the information might be misleading.
> Could we therefore change the flag here to a reliability one and
> our need_reliable check so that we always run
> unwind_is_reliable()?
> 
> I'm not sure if we need to abandon the trace on first error when
> doing a reliable trace but I can see it's a bit safer so perhaps
> better to do so.  If we don't abandon then we don't require the
> need_reliable check at all.
> 

I think that the caller should be able to specify that the stack trace
should be abandoned. Like Livepatch.

So, we could always do the reliability check. But keep need_reliable.

Thanks.

Madhavan
	
