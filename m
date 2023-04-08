Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973106DB8A1
	for <lists+live-patching@lfdr.de>; Sat,  8 Apr 2023 05:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDHDlo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Apr 2023 23:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDHDln (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Apr 2023 23:41:43 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D82E8F4;
        Fri,  7 Apr 2023 20:41:42 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id 221E1213B635;
        Fri,  7 Apr 2023 20:41:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 221E1213B635
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680925302;
        bh=GDCnssCJSi5ZzpxOgDYvEE6c5OxHsAcZTC6GaGuaaYQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CXtTBbcdVZ7cuMqkv2b0z/mNgLenvkvqfYv/FCyJJhgPx67ncX81u9QDD+j5i94bs
         p77doHIbx4kyN3r8SHmch0iEbMgEJe3tV8u3udHOeV5ywjjc2otw5A6TqeQot1OWXj
         rvj8d4IOgMUTd+j0NshfTRtzIutdikxcKbx4MMXY=
Message-ID: <26149caf-af5f-01b0-1356-09dcf7c74cf0@linux.microsoft.com>
Date:   Fri, 7 Apr 2023 22:41:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Content-Language: en-US
To:     Dylan Hatch <dylanbhatch@google.com>, misono.tomohiro@fujitsu.com
Cc:     broonie@kernel.org, catalin.marinas@arm.com,
        chenzhongjin@huawei.com, jamorris@linux.microsoft.com,
        jpoimboe@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mark.rutland@arm.com, nobuta.keiya@fujitsu.com,
        peterz@infradead.org, pmladek@suse.com, sjitindarsingh@gmail.com,
        will@kernel.org
References: <CADBMgpxQ+oM_TrtKRiREcZoZSk=AfenV_bqOk_Vt-Ov5FPHMvw@mail.gmail.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <CADBMgpxQ+oM_TrtKRiREcZoZSk=AfenV_bqOk_Vt-Ov5FPHMvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Sorry for the delay. Someone else also pointed out the same thing. I just have not
had the chance to look at this. I plan to soon.

Thanks.

Madhavan

On 4/3/23 17:26, Dylan Hatch wrote:
>> Then, I noticed that invoke_syscall generates instructions to add random offset
>> in sp when RANDOMIZE_KSTACK_OFFSET=y, which is true in the above case.
> 
> I'm also seeing this behavior when compiling with
> RANDOMIZE_KSTACK_OFFSET=y. I wonder if a special hint type
> could/should be added to allow for skipping the reliability check for
> stack frames with this randomized offset? Forgive me if this is a
> naive suggestion.
> 
> Thanks,
> Dylan
