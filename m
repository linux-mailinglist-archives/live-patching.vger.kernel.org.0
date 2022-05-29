Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD02537184
	for <lists+live-patching@lfdr.de>; Sun, 29 May 2022 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiE2PaM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 29 May 2022 11:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiE2PaL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 29 May 2022 11:30:11 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD4CA3FBC4;
        Sun, 29 May 2022 08:30:10 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9F1F920BA5B8;
        Sun, 29 May 2022 08:30:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F1F920BA5B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653838210;
        bh=pdXpNwS5tSP0aX9qQcLAkwzcKjd/aClB5ao6pff2Q0I=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=YVWltzDq0xT0imdsQDszhe82aLx+DIJ9wUPZO0fPx/c5zvPMypEHnW+dssG+ibi8f
         qGNWYSYabf5K2UJUCYCe1xoq0woOn7HcRoGubaict2eIBavQLQeM8KfyvCzrY9VFSv
         wqygMdB/fvltIODqmhU58Be0YbwNfkt4BsYsn7l8=
Message-ID: <2b8d8fbe-e596-91bf-a63b-938c9ff4140a@linux.microsoft.com>
Date:   Sun, 29 May 2022 10:30:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 00/20] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Content-Language: en-US
To:     Chen Zhongjin <chenzhongjin@huawei.com>, jpoimboe@redhat.com,
        peterz@infradead.org, mark.rutland@arm.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <061a4299-114f-96e0-86a4-6ab255778498@huawei.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <061a4299-114f-96e0-86a4-6ab255778498@huawei.com>
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

Thanks for taking the time to review my patches.

On 5/24/22 09:24, Chen Zhongjin wrote:
> Hi Madvenka,
> 
> I have a brief look at your patch and the idea that using CFA metadata to
> validate FP is reasonable to me. And I found a problem when I used 'pv dump' to
> check the orc value and I replied your commit 11/20 for that.
> 

I have responded to that comment in another email. Please take a look.


> I think it's not necessary that you rewrite the arm64 decoder(there is already a
> decoder in my patch) and insn check(objtool check can just make it) by yourself.

> 

This is a fair point. I will think about this a little bit and respond to this in a separate email.

> For me it's also a trouble that objtool runs too much unnecessary work. I advise
> that we should move some check for x86 as arch specific and refactor the cmdline
> options, they doesn't turn off everything perfectly now.
> 

So, Josh has done what you have mentioned. He has reorganized all of that code.
I am working on syncing up to his changes. I will send out version 3.

> Other than that I have an advise: We only use orc for reliable stacktrace and
> normal FP unwind doesn't depends on it. Should we only load these data for
> livepatch (or other scenario needs reliable stacktrace)? It can save the memory
> and time consuming for kernel.
> 

Yes. For ARM64, that is what I am trying to do. STACK_VALIDATION is optional and it
is off by default. It needs to be turned on only if reliable stack trace is required.

> That's all. And if you don't mind, can I incorporate some commit into my set?
> Appreciate for it.
> 

Please feel free to use any and all of my code. I am also looking at merging our two
decoders so that there is only one decoder. I need to think about this a little bit.
So, stay tuned.

Thanks!

Madhavan
