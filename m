Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692BC35A492
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 19:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDIRYC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 13:24:02 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52840 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDIRYC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 13:24:02 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2863C20B491D;
        Fri,  9 Apr 2021 10:23:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2863C20B491D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617989028;
        bh=qvStcHhWNQyPu4lxLei70jzOhwMqE5A023taZCYpoDo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=T4ImmqdXLAGJIvFYxTu6SgsdlwBWas9eh+eh3cLJxK21QXqL/KbwsO5vwym7fg+FF
         Ws95uagmaWDAPdWI2ljUAGgx1vmeWWoSOgCBwK3fSRGXJEmfBmGruOmpNqf8ohL+CM
         RWNNgL9fBV9bvzRuRlmRcZuSJf9I+JGpYtr5TMLw=
Subject: Re: [RFC PATCH v2 3/4] arm64: Detect FTRACE cases that make the stack
 trace unreliable
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-4-madvenka@linux.microsoft.com>
 <20210409122701.GB51636@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <c57de436-7943-175f-29b2-ed7ebcdc0837@linux.microsoft.com>
Date:   Fri, 9 Apr 2021 12:23:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409122701.GB51636@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


>> Also, the Function Graph Tracer modifies the return address of a traced
>> function to a return trampoline to gather tracing data on function return.
>> Stack traces taken from that trampoline and functions it calls are
>> unreliable as the original return address may not be available in
>> that context. Mark the stack trace unreliable accordingly.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/entry-ftrace.S | 12 +++++++
>>  arch/arm64/kernel/stacktrace.c   | 61 ++++++++++++++++++++++++++++++++
>>  2 files changed, 73 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
>> index b3e4f9a088b1..1f0714a50c71 100644
>> --- a/arch/arm64/kernel/entry-ftrace.S
>> +++ b/arch/arm64/kernel/entry-ftrace.S
>> @@ -86,6 +86,18 @@ SYM_CODE_START(ftrace_caller)
>>  	b	ftrace_common
>>  SYM_CODE_END(ftrace_caller)
>>  
>> +/*
>> + * A stack trace taken from anywhere in the FTRACE trampoline code should be
>> + * considered unreliable as a tracer function (patched at ftrace_call) could
>> + * potentially set pt_regs->pc and redirect execution to a function different
>> + * than the traced function. E.g., livepatch.
> 
> IIUC the issue here that we have two copies of the pc: one in the regs,
> and one in a frame record, and so after the update to the regs, the
> frame record is stale.
> 
> This is something that we could fix by having
> ftrace_instruction_pointer_set() set both.
> 

Yes. I will look at this.

> However, as noted elsewhere there are other issues which mean we'd still
> need special unwinding code for this.
> 

The only other cases we have discussed are EL1 exceptions in the ftrace code
and the return trampoline for function graph tracing. Is there any other case?

Thanks.

Madhavan
