Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C1D49D079
	for <lists+live-patching@lfdr.de>; Wed, 26 Jan 2022 18:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243619AbiAZROQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jan 2022 12:14:16 -0500
Received: from linux.microsoft.com ([13.77.154.182]:42758 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243590AbiAZROM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jan 2022 12:14:12 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id D0EBA20B6C61;
        Wed, 26 Jan 2022 09:14:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D0EBA20B6C61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1643217251;
        bh=qjst+qeWYxaDU+MRKQkL6zF+4RSRzRgazary5tstvLY=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=XtrB4oV5zRlyA6UFpPm1uaOM2KvUJchClLB2PNDJMzq/z7dDHar0dbVIIQ78/SgcT
         Pz00QqrEL8silAQ/SwbN/N/8G0jAu+aKD8F0w+ySTEEdxPV1jgiaGl2MqvyP2w5V14
         xFCoG4XyjjRh129nmkTz041zpJ5zX/y8ZWRLu3cE=
Message-ID: <1a0e19db-a7f8-4c8e-0163-398fcd364d54@linux.microsoft.com>
Date:   Wed, 26 Jan 2022 11:14:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 11/11] arm64: Select HAVE_RELIABLE_STACKTRACE
Content-Language: en-US
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-12-madvenka@linux.microsoft.com>
 <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
 <825b8b72-c746-ba24-7142-3fff481e82d6@linux.microsoft.com>
 <TY2PR01MB5257BE671A481D81F1A40E0185209@TY2PR01MB5257.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <TY2PR01MB5257BE671A481D81F1A40E0185209@TY2PR01MB5257.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 1/26/22 04:20, nobuta.keiya@fujitsu.com wrote:
>> I have not seen any activity on that in a long time. IIRC, Julien quit RedHat.
>> I don't know if anyone else has taken over this work in RedHat.
>>
>> Sorry, I don't have any more information.
>>
>> Madhavan
> 
> Thanks for your information.
> 
> By the way, I'm considering test code for arch_stack_walk_reliable().
> Specifically, I apply Suraj's patch to enable livepatch, and added a function
> that sleeps between SYM_CODE_START and SYM_CODE_END, then livepatch
> checks if the task has an unreliable stack.
> For now my internal test code working correctly, but my Kconfig excludes
> STACK_VALIDATION dependency.
> 
> It seems that objtool will not be enabled yet, so I would like to test it easier.
> If you are already testing with this patch, could you tell me how to do it?
> 
> 

For now, I have an instrumented kernel that directly invokes arch_stack_walk_reliable()
from various places in the kernel (interrupt handlers, exception handlers, ftrace entry,
kprobe handler, etc). I also have a test driver to induce conditions like null pointer
dereference. I use this to test different cases where arch_stack_walk_reliable() should
return an error.

As for livepatch testing, I have enhanced objtool and the kernel so the frame pointer can
be validated dynamically rather than statically. I have tested various different livepatch
selftests successfully. I have also written my own livepatch tests to add to the selftests.
I am currently working on preparing an RFC patch series for review. Basically, this series
implements STACK_VALIDATION in a different way.

I plan to publish my work soon (hopefully Feb 2022). I was going to do in December. However,
my workload in Microsoft did not permit me to do that. I am also planning to set up a github
repo so people can try out my changes, if they are interested.

So, stay tuned.

Madhavan
