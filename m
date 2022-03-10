Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437DF4D471A
	for <lists+live-patching@lfdr.de>; Thu, 10 Mar 2022 13:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242081AbiCJMhQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Mar 2022 07:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242041AbiCJMhL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Mar 2022 07:37:11 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A564148671;
        Thu, 10 Mar 2022 04:36:11 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id E7B1C20B7178;
        Thu, 10 Mar 2022 04:36:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E7B1C20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646915770;
        bh=OpLazLHgo7JUDorbgPvzn5XPP27hWdflyI7VUjRdwJM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oWQjaQXeK6bs8wAX1nWaVSxmsT0mTsCAm8ubndFXfYmqBoPy4pR1J2MCW8qgC70/+
         j2WyfH50ToQIyBVT6qVk00okQRSwfzpftPWUGJpJIetXHGVn07FRhKe+jFnwmYr7Nc
         1SSZjx6jwP186N8aTa+7k3/OrfLBHo5dpEQy22ho=
Message-ID: <574cbef1-89ce-3e43-cebb-5db1d8e854e5@linux.microsoft.com>
Date:   Thu, 10 Mar 2022 06:36:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Content-Language: en-US
To:     Miroslav Benes <mbenes@suse.cz>, Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
 <YgutJKqYe8ss8LLd@FVFF77S0Q05N>
 <845e4589-97d9-5371-3a0e-f6e05919f32d@linux.microsoft.com>
 <YiY6hecX0pVWowQ7@sirena.org.uk>
 <c494fa10-e973-c137-b637-66bde327611c@linux.microsoft.com>
 <YiiT2lFuxc3ob+Zq@sirena.org.uk>
 <alpine.LSU.2.21.2203100923470.16704@pobox.suse.cz>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <alpine.LSU.2.21.2203100923470.16704@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/10/22 02:33, Miroslav Benes wrote:
> On Wed, 9 Mar 2022, Mark Brown wrote:
> 
>> On Tue, Mar 08, 2022 at 04:00:35PM -0600, Madhavan T. Venkataraman wrote:
>>
>>> It is just that patch 11 that defines "select
>>> HAVE_RELIABLE_STACKTRACE" did not receive any comments from you
>>> (unless I missed a comment that came from you. That is entirely
>>> possible. If I missed it, my bad). Since you suggested that change, I
>>> just wanted to make sure that that patch looks OK to you.
>>
>> I think that's more a question for the livepatch people to be honest -
>> it's not entirely a technical one, there's a bunch of confidence level
>> stuff going on.  For example there was some suggestion that people might
>> insist on having objtool support, though there's also substantial
>> pushback on making objtool a requirement for anything from other
>> quarters.  I was hoping that posting that patch would provoke some
>> discussion about what exactly is needed but that's not happened thus
>> far.
> 
> I think everyone will be happy with HAVE_RELIABLE_STACKTRACE on arm64 as 
> long as there is a guarantee that stack traces are really reliable. My 
> understanding is that there is still some work to be done on arm64 arch 
> side (but I may have misunderstood what Mark R. said elsewhere). And yes, 
> then there is a question of objtool. It is one option but not the only 
> one. There have been proposals of implementing guarantees on a compiler 
> side and leaving objtool for x86_64 only (albeit objtool may bring more 
> features to the table... ORC, arch features checking).
> 
> Madhavan also mentioned that he enhanced objtool and he planned to submit 
> it eventually 
> (https://lore.kernel.org/all/1a0e19db-a7f8-4c8e-0163-398fcd364d54@linux.microsoft.com/T/#u), 
> so maybe arm64 maintainers could decide on a future direction based on 
> that?
> 

Yes. I am working on that right now. Hope to send it out soon.

Madhavan
