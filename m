Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5616ACC2B
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjCFSNw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 13:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjCFSNd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 13:13:33 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BEBE55A2;
        Mon,  6 Mar 2023 10:12:55 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.187.203.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id 985FA205749B;
        Mon,  6 Mar 2023 08:57:01 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 985FA205749B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678121822;
        bh=i6l9g1ghHiwdY5t9KntYL9655PJdj/oTf5R90V8m63k=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=nPVOWCj+I7dKE2js3uhg45Vt7ZVHUntccn8shQ0DZg2Gq9JbtCZYAJhKppUNX5thC
         rCbTc2DWMWDW42tnS56iErm35CnJqfGBR2dCjrUNX5+ZhY74r86M/DdDWqDJiPrQYK
         Z/MuQ5PyBo2S1V5CyHxFS5ArMCZX9+sLmP8ZFKfk=
Message-ID: <c2e5fa3a-6d5c-17a1-0245-876aa5182a70@linux.microsoft.com>
Date:   Mon, 6 Mar 2023 10:57:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Content-Language: en-US
To:     "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "chenzhongjin@huawei.com" <chenzhongjin@huawei.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "Keiya Nobuta (Fujitsu)" <nobuta.keiya@fujitsu.com>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <TYCPR01MB69938E7E2E14697FCF166155E5AD9@TYCPR01MB6993.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <TYCPR01MB69938E7E2E14697FCF166155E5AD9@TYCPR01MB6993.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/28/23 21:12, Tomohiro Misono (Fujitsu) wrote:
> <snip>
>> Testing
>> =======
>>
>> - I have run all of the livepatch selftests successfully. I have written a
>>   couple of extra selftests myself which I will be posting separately
> Hi,
> 
> What test configuration/environment you are using for test?
> When I tried kselftest with fedora based config on VM, I got errors
> because livepatch transition won't finish until signal is sent
> (i.e. it takes 15s for every transition).
> 

Sorry for not responding earlier. I was out sick.

I tested on a bare metal system (thunderx) running Ubuntu. I will try to reproduce
the error you are seeing on a VM running fedora.

Madhavan

> [excerpt from test result]
>   ```
>   $ sudo ./test-livepatch.sh
>   TEST: basic function patching ... not ok
>   
>   --- expected
>   +++ result
>   @@ -2,11 +2,13 @@
>    livepatch: enabling patch 'test_klp_livepatch'
>    livepatch: 'test_klp_livepatch': initializing patching transition
>    livepatch: 'test_klp_livepatch': starting patching transition
>   +livepatch: signaling remaining tasks
>    livepatch: 'test_klp_livepatch': completing patching transition
>   ```
> 
> Thanks,
> Tomohiro
> 
>>
>> - I have a test driver to induce a NULL pointer exception to make sure
>>   that unwinding through exception handlers is reliable.
>>
>> - I use the test driver to create a timer to make sure that unwinding through
>>   the timer IRQ is reliable.
>>
>> - I call the unwinder from different places during boot to make sure that
>>   the unwinding in each of those cases is reliable.
>>
