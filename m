Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099BC436198
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 14:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJUMaX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 08:30:23 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49734 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhJUMaX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 08:30:23 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id A70CF20B7179;
        Thu, 21 Oct 2021 05:28:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A70CF20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634819287;
        bh=cQoSoP4nqlIQsd4lxcn16MlsKtUqK9NckHum6+5tTZg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RZ2KM3t5LyEIv0lOBRc4vF3BIhOrAZBXifAMG0015HCC6jbQoGXgsBxEWyTS6S2DC
         fz58pGh4Q7EareHvxeZqLAwb8NGpaeH/DGTLO616e1Bbk+HCKk2MtBMgOpJvPQWiM7
         mJoKJu8a9zBmiZaX4ExrvyvZ5memAWANPE579518=
Subject: Re: [PATCH v10 01/11] arm64: Select STACKTRACE in arch/arm64/Kconfig
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-2-madvenka@linux.microsoft.com>
 <YWnIPU4dRmJHTkXZ@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a807a2bf-1418-6758-0ec0-dc50f32d5ab2@linux.microsoft.com>
Date:   Thu, 21 Oct 2021 07:28:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YWnIPU4dRmJHTkXZ@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/15/21 1:28 PM, Mark Brown wrote:
> On Thu, Oct 14, 2021 at 09:58:37PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, there are multiple functions in ARM64 code that walk the
>> stack using start_backtrace() and unwind_frame() or start_backtrace()
>> and walk_stackframe(). They should all be converted to use
>> arch_stack_walk(). This makes maintenance easier.
> 
> Reviwed-by: Mark Brown <broonie@kernel.org>
> 
> Arguably this should be squashed in with the first user but that's
> getting bikesheddy and could make hassle merging things in so meh.
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

Thanks.

Madhavan
