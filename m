Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7C55DBDD
	for <lists+live-patching@lfdr.de>; Tue, 28 Jun 2022 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiF0Fxr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jun 2022 01:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiF0Fxr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jun 2022 01:53:47 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D57AF2AF7;
        Sun, 26 Jun 2022 22:53:44 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id B588120CD148;
        Sun, 26 Jun 2022 22:53:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B588120CD148
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656309224;
        bh=2G49cShhAolevVu8WMXvOpG1Mrf19q/QEnAA5fF6zKw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=M2QTmBtLQdaD8mBvjWyhywM2I/e4ndS5HBPLSBSnpn5EJinQ5HXXX9Jeqdi8xYovw
         kBq1Lf68Ew1OgNotx0OvrxrKJ6iw+BzIp4yV05WHbeBRzzaJD5Wc5xamODfIip0BjV
         pp91nkD/8Msu4ztJSg5vFD+CxcDCMheTNBa0w514=
Message-ID: <17aa8390-fe27-94fe-0098-c9c76dffafa5@linux.microsoft.com>
Date:   Mon, 27 Jun 2022 00:53:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v15 6/6] arm64: Introduce arch_stack_walk_reliable()
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-7-madvenka@linux.microsoft.com>
 <YrgflcfxP7pYtob7@FVFF77S0Q05N>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YrgflcfxP7pYtob7@FVFF77S0Q05N>
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



On 6/26/22 03:57, Mark Rutland wrote:
> On Fri, Jun 17, 2022 at 04:07:17PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Introduce arch_stack_walk_reliable() for ARM64. This works like
>> arch_stack_walk() except that it returns -EINVAL if the stack trace is not
>> reliable.
>>
>> Until all the reliability checks are in place, arch_stack_walk_reliable()
>> may not be used by livepatch. But it may be used by debug and test code.
> 
> For the moment I would strongly perfer *not* to add this until we have the
> missing bits and pieces sorted out.
> 

Yes. I am removing this from the patch series.

> Until then, I'd like to ensure that any infrastructure we add is immediately
> useful and tested. One way to do that would be to enhance the stack dumping
> code (i.e. dump_backtrace()) to log some metadata.
> 
> As an end-goal, I'd like to get to a point where we can do:
> 
> * Explicit logging when trace terminate at the final frame, e.g.
> 
>   stacktrace:
>     function_c+offset/total
>     function_b+offset/total
>     function_a+offset/total
>     <unwind successful>
> 
> * Explicit logging of early termination, e.g.
> 
>   stacktrace:
>     function_c+offset/total
>     <unwind terminated early (bad FP)>
> 
> * Unreliability on individual elements, e.g.
> 
>   stacktrace:
>     function_c+offset/total
>     function_b+offset/total (?)
>     function_a+offset/total
> 
> * Annotations for special unwinding, e.g.
> 
>   stacktrace:
>     function_c+offset/total (K) // kretprobes trampoline
>     function_b+offset/total (F) // ftrace trampoline
>     function_a+offset/total (FK) // ftrace and kretprobes
>     other_function+offset/total (P) // from pt_regs::pc
>     another_function+offset/total (L?) // from pt_regs::lr, unreliable
>     something_else+offset/total
> 
>   Note: the comments here are just to explain the idea, I don't expect those in
>   the actual output.
> 
> That'll justify some of the infrastructure we need for reliable unwinding, and
> ensure that it is tested, well before we actually enable reliable stacktracing.
> 

In the current code structure, the annotations are a problem.

The printing of the entry along with the annotations and metadata cannot be done in
the unwind functions themselves as the caller may not even want anything printed.
The printing has to be done in consume_entry() if the caller wants to do it. But
consume_entry() only gets the PC as the argument (apart from the cookie passed by
the caller). It currently has no way of figuring out where the PC was obtained from
(ftrace, kretprobe, pt_regs, etc) or if the PC is reliable.

We need to replace the PC argument with a pointer to a structure that contains the
PC as well as other information about the PC. unwind_init() and unwind_next() need
to update that for each frame.

If this approach is acceptable, I will submit a patch series for that. Please let
me know.

Thanks.

Madhavan
