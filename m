Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B76E1086
	for <lists+live-patching@lfdr.de>; Thu, 13 Apr 2023 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjDMO7e (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Apr 2023 10:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDMO7e (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Apr 2023 10:59:34 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C7966A42;
        Thu, 13 Apr 2023 07:59:33 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id E1B9B2179255;
        Thu, 13 Apr 2023 07:59:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E1B9B2179255
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681397972;
        bh=9dCYOGSbIYbfYYbmLvUJ5TG/nk29LN5wquzmrRZ81Uc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bA/8X41O3YYQ46GMlQH62h1w4H8PuSCT37utR845/hQjryig4kFiPnGIW159LT26B
         HrpaV3RQ6IMpRJZMO6SnESlK1cfJU4GmT4+Bp+p2ur6l+JBifq6qTfv4+alQUyv+S3
         NnIm9HRzeB+GKC4v2iOg5JvPiJLd4ayY2Jw6276s=
Message-ID: <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
Date:   Thu, 13 Apr 2023 09:59:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N> <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
 <20230412155221.2l2mqsyothseymeq@treble>
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20230412155221.2l2mqsyothseymeq@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/12/23 10:52, Josh Poimboeuf wrote:
> On Wed, Apr 12, 2023 at 09:50:23AM -0500, Madhavan T. Venkataraman wrote:
>>>> I read through the SFrame spec file briefly. It looks like I can easily adapt my
>>>> version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
>>>> folks agree to properly support and maintain SFrame, then I could send the next version
>>>> of the patchset based on SFrame.
>>>>
>>>> But I kinda need a clear path forward before I implement anything. I request the arm64
>>>> folks to comment on the above approach. Would it be useful to initiate an email discussion
>>>> with the compiler folks on what they plan to do to support SFrame? Or, should this all
>>>> happen face to face in some forum like LPC?
>>>
>>> SFrame is basically a simplified version of DWARF unwind, using it as an
>>> input to objtool is going to have the same issues I mentioned below (and
>>> as was discussed with your v1).
>>>
>>
>> Yes. It is a much simplified version of DWARF. So, I am hoping that the compiler folks
>> can provide the feature with a reliability guarantee. DWARF is too complex.
> 
> I don't see what the complexity (or lack thereof) of the unwinding data
> format has to do with it.  The unreliability comes from the underlying
> data source, not the formatting of the data.
> 

What I meant is - if SFrame is implemented by simply extracting unwind info from
DWARF data and placing it in a separate section (as it is probably implemented now),
then what you say is totally true. But if the compiler folks agree to make SFrame reliable,
then either they have to make DWARF reliable. Or, they have to implement SFrame as a
separate feature and make it reliable. The former is tough to do as DWARF has a lot of complexity.
The latter is a lot easier to do.

Sorry if that was not clear.

Madhavan
