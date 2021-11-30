Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4500463C9D
	for <lists+live-patching@lfdr.de>; Tue, 30 Nov 2021 18:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhK3RTX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Nov 2021 12:19:23 -0500
Received: from linux.microsoft.com ([13.77.154.182]:33650 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhK3RTJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Nov 2021 12:19:09 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id B6BEE20DED70;
        Tue, 30 Nov 2021 09:15:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B6BEE20DED70
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638292550;
        bh=wkVF+KmAVekeXtq/dNGof3Ieis7OrebbdJMsotX+cZk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aasZm6vaAMLTEgy2AGEe2jZz+44yK5Yq02mlMPB7eRz0nV/7XKkw0s0clfE2Ewgzq
         otF5scQwOM33aunAPk2iHfMVJNFfMIhTtFWFxl7/TG34ekHnY1s3MWmwJppbtT41wf
         PwABVKJo/G9Glrt0abJOpSmz0xAeBFjeASGvDUoI=
Subject: Re: [PATCH v11 2/5] arm64: Rename unwinder functions
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-3-madvenka@linux.microsoft.com>
 <YaY+gMPSQMx1M5Pj@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bcc2105a-000e-5782-c71f-734dc28c3fbd@linux.microsoft.com>
Date:   Tue, 30 Nov 2021 11:15:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YaY+gMPSQMx1M5Pj@FVFF77S0Q05N>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 11/30/21 9:08 AM, Mark Rutland wrote:
> On Tue, Nov 23, 2021 at 01:37:20PM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Rename unwinder functions for consistency and better naming.
>>
>> 	- Rename start_backtrace() to unwind_start().
>> 	- Rename unwind_frame() to unwind_next().
>> 	- Rename walk_stackframe() to unwind().
> 
> Super trivial, but could we s/unwind_start/unwind_init/ ? That makes it
> slightly clearer that it's not performing an unwind step.
> 
> Otherwise, this looks good to me.
> 

Will do.

> For the rename:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> It's be nice if we could also clean up 'struct stackframe' into 'struct
> unwind_state', but that can be a follow-up, and this is fine as it is, modulo
> the super trivial comment above.
> 

I could do this rename as well in the next version if you want. Might as well
get all the renaming done in one shot.

Thanks,

Madhavan
