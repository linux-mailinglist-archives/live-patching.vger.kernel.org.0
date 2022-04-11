Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62DC4FC336
	for <lists+live-patching@lfdr.de>; Mon, 11 Apr 2022 19:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348854AbiDKR3P (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 Apr 2022 13:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245656AbiDKR3O (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 Apr 2022 13:29:14 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0ECF2982C;
        Mon, 11 Apr 2022 10:26:59 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id CD55E205657E;
        Mon, 11 Apr 2022 10:26:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD55E205657E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649698019;
        bh=Mei3s3yDUS+9zxe+0qZt8C43Ggn9lmrQW4qcJGZZlwA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JMYBm4uzf6bjPUV0Wi4hm+EKCJrhuhaL5dyYD/N6YhK6MOEYtBosuhVNagbXZ+BZM
         AS70BGPNl1j5OgkYdtvWPte0hjC9ISqXL1i8iM+kg1KgRGurJYzCuhYUZKmLUIKFzF
         s9i6QyH0SlNLKjUIW3nSLlnaOysfCboCKLHO8FQM=
Message-ID: <ad2bf0c6-e3e4-097b-4d4f-39cfe4c3a580@linux.microsoft.com>
Date:   Mon, 11 Apr 2022 12:26:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenzhongjin@huawei.com
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
 <20220408114133.GP2731@worktop.programming.kicks-ass.net>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20220408114133.GP2731@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/8/22 06:41, Peter Zijlstra wrote:
> 
> Right; so not having seen the patches due to Madhaven's email being
> broken, I can perhaps less appreciated the crazy involved.
> 

Crazy like a fox.

> On Thu, Apr 07, 2022 at 05:21:51PM -0700, Josh Poimboeuf wrote:
>> 2)
>>
>> If I understand correctly, objtool is converting parts of DWARF to a new
>> format which can then be read by the kernel.  In that case, please don't
>> call it DWARF as that will cause a lot of confusion.
>>
>> There are actually several similarities between your new format and ORC,
>> which is also an objtool-created DWARF alternative.  It would be
>> interesting to see if they could be combined somehow.
> 
> What Josh said; please use/extend ORC.
> 

Yes. I am looking into it.

> I really don't understand where all this crazy is coming from; why does
> objtool need to do something radically weird for ARM64?
> 
> There are existing ARM64 patches for objtool; in fact they have recently
> been re-posted:
> 
>  https://lkml.kernel.org/r/20220407120141.43801-1-chenzhongjin@huawei.com
> 
> The only tricky bit seems to be the whole jump-table issue. Using DWARF
> as input to deal with jump-tables should be possible -- exceedingly
> overkill, but possible I suppose. Mandating DWARF sucks though, compile
> times are so much worse with DWARVES on :/
> 
> Once objtool can properly follow/validate ARM64 code, it should be
> fairly straight forward to have it generate ORC data just like it does
> on x86_64.
> 

My reasons for attempting the DWARF based implementation:

- My implementation is largely architecture independent. There are a couple of
  minor pieces that are architecture-specific, but they are minor in nature.
  So, if an architecture wanted to support the livepatch feature but did not
  want to do a heavy weight objtool implementation, then it has an option.
  There has been some debate about whether static analysis should be mandated
  for livepatch. My patch series is an attempt to provide an option.

- To get an objtool static analysis implementation working for an architecture
  as reliably as X64 and getting it reviewed and upstreamed can take years. It took
  years for X64, am I right? I mean, it has been quite a while since the original
  patch series for arm64 was posted. There have been only one or two minor comments
  so far. I am sure arm64 linux users would very much want to have livepatch available
  ASAP to be able to install security fixes without downtime. This is an immediate need.

- No software is bug free. So, even if static analysis is implemented for an architecture,
  it would be good to have another method of verifying the unwind rules generated from
  the static analysis. DWARF can provide that additional verification.

Madhavan
