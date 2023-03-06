Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEFC6AC960
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 18:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjCFRJX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 12:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCFRJA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 12:09:00 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1545628855;
        Mon,  6 Mar 2023 09:08:05 -0800 (PST)
Received: from [192.168.254.32] (unknown [47.187.203.192])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1E820205749D;
        Mon,  6 Mar 2023 08:58:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1E820205749D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678121900;
        bh=kWkGguzIxCy4GS4idzAr3kaaQwhr8ad9JFP9cqeJZZc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=G2XiKL0F+8KRP/0/o0hhWc9kFtD3WkrxYBRVizWFIxE2QpwDQPyP9MAY57wd5nOHx
         63GWDVPQwsuJCkInTIadPfnIs+1UUulEj2LKbWvlmEWkvNeDbMckINcMyVfdWT7Enl
         Spo+yTLWQPMQQIHHs0rzSuLCb2gx0B07PQMW6Z3s=
Message-ID: <4d69eee8-5401-ea20-a063-79cf199fe1cc@linux.microsoft.com>
Date:   Mon, 6 Mar 2023 10:58:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>,
        "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
Cc:     "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
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
 <ZADNdp5U+lP10Oqo@alley>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <ZADNdp5U+lP10Oqo@alley>
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



On 3/2/23 10:23, Petr Mladek wrote:
> On Wed 2023-03-01 03:12:08, Tomohiro Misono (Fujitsu) wrote:
>> <snip>
>>> Testing
>>> =======
>>>
>>> - I have run all of the livepatch selftests successfully. I have written a
>>>   couple of extra selftests myself which I will be posting separately
>> Hi,
>>
>> What test configuration/environment you are using for test?
>> When I tried kselftest with fedora based config on VM, I got errors
>> because livepatch transition won't finish until signal is sent
>> (i.e. it takes 15s for every transition).
>>
>> [excerpt from test result]
>>   ```
>>   $ sudo ./test-livepatch.sh
>>   TEST: basic function patching ... not ok
>>   
>>   --- expected
>>   +++ result
>>   @@ -2,11 +2,13 @@
>>    livepatch: enabling patch 'test_klp_livepatch'
>>    livepatch: 'test_klp_livepatch': initializing patching transition
>>    livepatch: 'test_klp_livepatch': starting patching transition
>>   +livepatch: signaling remaining tasks
>>    livepatch: 'test_klp_livepatch': completing patching transition
>>   ```
> 
> It might be interesting to see what process is blocking the
> transition. The transition state is visible in
> /proc/<pid>/patch_state.
> 
> The transition is blocked when a process is in KLP_UNPATCHED state.
> It is defined in include/linux/livepatch.h:
> 
> #define KLP_UNPATCHED	 0
> 
> Well, the timing against the transition is important. The following
> might help to see the blocking processes:
> 
> $> modprobe livepatch-sample ; \
>    sleep 1; \
>    for proc_path in \
>        `grep "\-1"  /proc/*/patch_state | cut -d '/'  -f-3` ; \
>    do \
>        cat $proc_path/comm ; \
>        cat $proc_path/stack ; \
>        echo ===  ; \
>    done
> 
> After this the livepatch has to be manualy disabled and removed
> 
> $> echo 0 >/sys/kernel/livepatch/livepatch_sample/enabled
> $> rmmod livepatch_sample
> 
> Best Regards,
> Petr

Thanks for the suggestion. I will try to reproduce the problem and look at what process(es) are holding up
the livepatch.

Madhavan
