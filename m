Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DDB3DA9A8
	for <lists+live-patching@lfdr.de>; Thu, 29 Jul 2021 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhG2RH0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Jul 2021 13:07:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33692 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhG2RH0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Jul 2021 13:07:26 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id BE6402048040;
        Thu, 29 Jul 2021 10:07:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BE6402048040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1627578442;
        bh=aJLiwkasTUV5PUh0KySgk0D5vqXSl4aYUJoTZq0Sg3E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bBR4WzdTLGd4Mf67ZVBd0imDMLfOd4FCrRgsR8/I47S7CX6uWzxXBA9TodM4eud/o
         d26aBfqZtD37cP+RcBFQZLkmAR1knNuKTFTrbXAts/HX5V2SasWO5zu41kJSoUFlzD
         +cJRXWzIQlbhcYYRDfuA5W+0f78PMyG2xF0rmeKE=
Subject: Re: [RFC PATCH v6 3/3] arm64: Create a list of SYM_CODE functions,
 check return PC against list
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
 <20210630223356.58714-4-madvenka@linux.microsoft.com>
 <20210728172523.GB47345@C02TD0UTHF1T.local>
 <f9931a57-7a81-867b-fa2a-499d441c5acd@linux.microsoft.com>
 <20210729145210.GP4670@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <3bca2228-0a1a-c898-bbab-bb4925fddd8d@linux.microsoft.com>
Date:   Thu, 29 Jul 2021 12:07:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729145210.GP4670@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 7/29/21 9:52 AM, Mark Brown wrote:
> On Thu, Jul 29, 2021 at 09:06:26AM -0500, Madhavan T. Venkataraman wrote:
>> On 7/28/21 12:25 PM, Mark Rutland wrote:
>>> On Wed, Jun 30, 2021 at 05:33:56PM -0500, madvenka@linux.microsoft.com wrote:
> 
>>> Since some of the above is speculative (e.g. the bit about optprobes),
>>> and as code will change over time, I think we should have a much terser
>>> comment, e.g.
> 
>>> 	/*
>>> 	 * As SYM_CODE functions don't follow the usual calling
>>> 	 * conventions, we assume by default that any SYM_CODE function
>>> 	 * cannot be unwound reliably.
>>> 	 *
>>> 	 * Note that this includes exception entry/return sequences and
>>> 	 * trampoline for ftrace and kprobes.
>>> 	 */
> 
>> Just to confirm, are you suggesting that I remove the entire large comment
>> detailing the various cases and replace the whole thing with the terse comment?
>> I did the large comment because of Mark Brown's input that we must be verbose
>> about all the cases so that it is clear in the future what the different
>> cases are and how we handle them in this code. As the code evolves, the comments
>> would evolve.
> 
> I do agree with Mark that this has probably gone from one extreme to the
> other and could be cut back a lot - originally it didn't reference there
> being complicated cases like the trampoline at all IIRC so you needed
> external knowledge to figure out that those cases were handled.
> 

OK.

Madhavan
