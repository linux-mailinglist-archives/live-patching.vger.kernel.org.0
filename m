Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB7C4FAF4E
	for <lists+live-patching@lfdr.de>; Sun, 10 Apr 2022 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiDJRgD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 10 Apr 2022 13:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbiDJRgB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 10 Apr 2022 13:36:01 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 795033A5C9;
        Sun, 10 Apr 2022 10:33:50 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3668B2056574;
        Sun, 10 Apr 2022 10:33:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3668B2056574
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649612026;
        bh=YBLCoOWcsS22W+PjAnwcBoAKjlwUvIpcw4uQfCuKST8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GMi+BwWJM6vxiSLd6UV2NQMJ3hnRlo4hwRluhnH0eGYSihMl92+H0JMVqQ8/BG9he
         /CleOg3D9Zy4g7H0YMwhfKsL2MRw6AOEkh1XKAeylJOEZN4fgHj7lZfWAyGbDZHLOz
         O41BvhgrfBBSsq5gSwyuag2mKG/AaZdRiOFUXLmc=
Message-ID: <89175c40-5f12-d83f-a42b-60c6f353514e@linux.microsoft.com>
Date:   Sun, 10 Apr 2022 12:33:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
 <YgutJKqYe8ss8LLd@FVFF77S0Q05N>
 <845e4589-97d9-5371-3a0e-f6e05919f32d@linux.microsoft.com>
 <YlBKUtLN5+wpuyLi@lakrids>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YlBKUtLN5+wpuyLi@lakrids>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/8/22 09:44, Mark Rutland wrote:
> On Mon, Mar 07, 2022 at 10:51:38AM -0600, Madhavan T. Venkataraman wrote:
>> Hey Mark Rutland, Mark Brown,
>>
>> Could you please review the rest of the patches in the series when you can?
> 
> Sorry, I was expecting a new version with some of my comments
> addressed, in case that had effects on subsequent patches.
> 

Yes. I realized that. I am actually working on the next version addressing the
comments I have received.

>> Also, many of the patches have received a Reviewed-By from you both.
>> So, after I send the next version out, can we upstream those ones?
> 
> I would very much like to upstream the ones I have given a Reviewed-by.
> 
> Given those were conditional on some adjustments (e.g. actually filling
> out comments), do you mind if I pick those into a series now?
> 
> Then, once that's picked, you can rebase the rest atop, and we can
> review that.
> 

That would be great! Thanks!

Madhavan
