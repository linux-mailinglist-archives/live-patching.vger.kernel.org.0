Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991704D23C2
	for <lists+live-patching@lfdr.de>; Tue,  8 Mar 2022 23:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiCHWBf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Mar 2022 17:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiCHWBe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Mar 2022 17:01:34 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 743FD289BA;
        Tue,  8 Mar 2022 14:00:37 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5F17C20B7178;
        Tue,  8 Mar 2022 14:00:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F17C20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646776837;
        bh=6aGA5zF6jU5zH7UbdaZnmMkVSuozYHUjOEcPB4bdYIM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=svryphXe56GxH3wIuzgftWULHzQSof0sq6j9xgRGizLEfetBH1iw9N8TcDC+1q8H4
         nosAMecuDL0jjxqe/Pg4Yp9855PAje7MevjtTI/7/wuk0sYLH16KSld6/LlEGQSfOU
         u/gWY8CGNOdLUg8ciaTqx87ftEXwodHcasEH9rEk=
Message-ID: <c494fa10-e973-c137-b637-66bde327611c@linux.microsoft.com>
Date:   Tue, 8 Mar 2022 16:00:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
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
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YiY6hecX0pVWowQ7@sirena.org.uk>
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



On 3/7/22 11:01, Mark Brown wrote:
> On Mon, Mar 07, 2022 at 10:51:38AM -0600, Madhavan T. Venkataraman wrote:
>> Hey Mark Rutland, Mark Brown,
>>
>> Could you please review the rest of the patches in the series when you can?
>>
> 
> Please don't send content free pings.  As far as I remember I'd reviewed
> or was expecting changes based on review or dependent patches for
> everything that you'd sent.
> 

Indeed you did! Many thanks!

It is just that patch 11 that defines "select HAVE_RELIABLE_STACKTRACE" did not receive any comments from you (unless I missed a comment that came from you. That is entirely possible. If I missed it, my bad). Since you suggested that change, I just wanted to make sure that that patch looks OK to you.

>> Also, many of the patches have received a Reviewed-By from you both. So, after I send the next version out, can we upstream those ones?
> 
> That's more a question for Catalin and Will.  If myself and Mark have
> reviewed patches then we're saying we think those patches are good to
> go.

Got it!

Thanks!

Madhavan
