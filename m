Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35564537169
	for <lists+live-patching@lfdr.de>; Sun, 29 May 2022 16:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiE2Ots (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 29 May 2022 10:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiE2Ots (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 29 May 2022 10:49:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AD3092D0E;
        Sun, 29 May 2022 07:49:46 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 478FB20BA5B8;
        Sun, 29 May 2022 07:49:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 478FB20BA5B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653835786;
        bh=jpLDxfgmIl9vB8rYvQvsBF0PJpChGqukD9RbvahNg14=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rGhw5agA51PCRmr2ztj3jR6qXAz+2eAqkrSCVGcs+CZV7s7wqYticx6MMqWDC7spt
         z9E2xsULr3smT76vAMMt2AZ/pOFM+3JQDsETTG9t6h0IzoPtiQMsvO8xoMN34qyPMy
         bIry/E6rve4EfEvKfMeabp1Um4dhqfn5aOSmIhac=
Message-ID: <ff58b576-efee-276a-bfb3-11f5d258d580@linux.microsoft.com>
Date:   Sun, 29 May 2022 09:49:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 09/20] objtool: arm64: Implement command to invoke
 the decoder
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220524001637.1707472-10-madvenka@linux.microsoft.com>
 <YoznLR30T+03Ea08@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YoznLR30T+03Ea08@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/24/22 09:09, Mark Brown wrote:
> On Mon, May 23, 2022 at 07:16:26PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Implement a built-in command called cmd_fpv() that can be invoked as
>> follows:
>>
>> 	objtool fpv generate file.o
>>
>> The built-in command invokes decode_instructions() to walk each function
>> and decode the instructions of the function.
> 
> In commit b51277eb9775ce91 ("objtool: Ditch subcommands") Josh removed
> subcommands so this interface is going to need a rethink.

Thanks for mentioning this. I will sync my patchset to the latest and send out version 3.

Thanks!

Madhavan
