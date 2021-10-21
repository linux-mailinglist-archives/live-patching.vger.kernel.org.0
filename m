Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BD14361A8
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhJUMbf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 08:31:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49940 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJUMbf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 08:31:35 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 914CC20B7179;
        Thu, 21 Oct 2021 05:29:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 914CC20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634819359;
        bh=vnC52vGFMLBLl3prkclKdto+trnf1OP2GsHX/iOjU18=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dNicFdwSp0Ixk5DbjvSpgipfh2GsYA8xPXZ8PTPF9gjJntyDoxmuNF8tqjonpFuZs
         fQx6t9/IQrfTa6jOq7hSPTOPKLvgRZR+3fVvekqoncDvLAbwf013zC3RZvbcXaFy61
         Y27mVzSCMAuVWUFeGGc5zByyBFB+Y8yqy8mvCMvA=
Subject: Re: [PATCH v10 04/11] arm64: Make return_address() use
 arch_stack_walk()
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-5-madvenka@linux.microsoft.com>
 <YXAvuX7VCVa39eVm@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <eecf3545-420f-77cb-95f2-f5da90b5bd82@linux.microsoft.com>
Date:   Thu, 21 Oct 2021 07:29:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXAvuX7VCVa39eVm@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks.

On 10/20/21 10:03 AM, Mark Brown wrote:
> On Thu, Oct 14, 2021 at 09:58:40PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, return_address() in ARM64 code walks the stack using
>> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
>> instead. This makes maintenance easier.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
