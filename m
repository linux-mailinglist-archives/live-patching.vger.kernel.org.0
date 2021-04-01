Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064F73519A3
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 20:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhDARzv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 13:55:51 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33930 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbhDARtA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 13:49:00 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id CF79820B5680;
        Thu,  1 Apr 2021 10:48:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CF79820B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617299340;
        bh=pggj6kgf28ysJ63Y+IBa5Ll76tHdSXg4Vs39joWWGIQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FRFn+2Soa89ADRECRu046rfoOhAI4l5N0maNljekL4EuSdDgPcYlW4u6tcKX8qgzr
         0xnhWrIGYrSnkHvSLeASKvSx2Ea3A6EHyjgc72dU7WeccAcurQ81rHtRdg1dmRnuUL
         utvKxMt1Q3mwUcRRGOjFkIxcXDqlI49fRWzJ2F4E=
Subject: Re: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the stack
 trace unreliable
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-4-madvenka@linux.microsoft.com>
 <20210401142759.GJ4758@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <fe69ec57-4798-3fcc-4e41-3d36957ee5f6@linux.microsoft.com>
Date:   Thu, 1 Apr 2021 12:48:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210401142759.GJ4758@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/1/21 9:27 AM, Mark Brown wrote:
> On Tue, Mar 30, 2021 at 02:09:54PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> +	 * FTRACE trampolines.
>> +	 */
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
>> +	{ (unsigned long) &ftrace_graph_call, 0 },
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +	{ (unsigned long) ftrace_graph_caller, 0 },
>> +	{ (unsigned long) return_to_handler, 0 },
>> +#endif
>> +#endif
> 
> It's weird that we take the address of ftrace_graph_call but not the
> other functions - we should be consistent or explain why.  It'd probably
> also look nicer to not nest the ifdefs, the dependencies in Kconfig will
> ensure we only get things when we should.
> 

Sorry. I forgot to respond to the nested ifdef comment. I will fix that.

Thanks!

Madhavan
