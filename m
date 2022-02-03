Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8D34A7CEE
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 01:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiBCAeq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Feb 2022 19:34:46 -0500
Received: from linux.microsoft.com ([13.77.154.182]:45058 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348600AbiBCAep (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Feb 2022 19:34:45 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4FACC20B6C61;
        Wed,  2 Feb 2022 16:34:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4FACC20B6C61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1643848485;
        bh=TjbaCOX1e+7kp6KBiMIW8p0ZetHxMvPlcN36NQSGfd8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OG2cZ3FvG/7uQ//KPclVZf3jhyGwkIT5ljzlF1WNcH6aZbAg3BwMcPW2ABT0w+LSY
         FttKV2YwhAqg/erVC/bVzcWNjEN4xop5Pz5rZFgUjBNOUsM5erWh3K9Ya8/4IFn/90
         cxZIjo+GEM0Cc0wWvwTjs5lTeTdwdlIW8v1xf1vM=
Message-ID: <48b17c52-58d6-0df5-a50b-35a8ea408998@linux.microsoft.com>
Date:   Wed, 2 Feb 2022 18:34:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
 <YfrRoA63/UOXTJc0@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YfrRoA63/UOXTJc0@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/2/22 12:46, Mark Brown wrote:
> On Mon, Jan 17, 2022 at 08:56:03AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Rename the arguments to unwind() for better consistency. Also, use the
>> typedef stack_trace_consume_fn for the consume_entry function as it is
>> already defined in linux/stacktrace.h.
> 
> Consistency with...?  But otherwise:

Naming consistency. E.g., the name consume_entry is used in a lot of places.
This code used to use fn() instead of consume_entry(). arch_stack_walk()
names the argument to consume_entry as cookie. This code calls it data
instead of cookie. That is all. It is minor in nature. But I thought I might
as well make it conform while I am at it.

Madhavan
