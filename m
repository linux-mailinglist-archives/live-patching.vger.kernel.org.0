Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA338CCA2
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhEURu2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:50:28 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33412 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238628AbhEURt6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:49:58 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id A2F2A20B7188;
        Fri, 21 May 2021 10:48:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2F2A20B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621619315;
        bh=vU/JTuWi3C5fB8RNIolLlnI9ipYsWSFq874acAyf40w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VbNgyb8BxOjzNrhqJ1+kLXKgpAdDz0/s4fsSb5gh6kosis6ztaDaiL82PhCuKiRPP
         48ZhbmMBBUPNIZi8+/Cr6rsLxZ7cibrDZSGtL0OAMObMfxaF3d9NrUkBLg17VGZ7Pz
         oRpzGr3BjYbst42wOW9ZN1L+zKbLHhowyOPtQIJI=
Subject: Re: [RFC PATCH v4 0/2] arm64: Stack trace reliability checks in the
 unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210521171808.GC5825@sirena.org.uk>
 <654dde25-e6a2-a1e7-c2d7-e2692bc11528@linux.microsoft.com>
 <20210521174702.GE5825@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <1feec2ba-538b-e28d-1e03-ac9c1af43842@linux.microsoft.com>
Date:   Fri, 21 May 2021 12:48:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521174702.GE5825@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/21/21 12:47 PM, Mark Brown wrote:
> On Fri, May 21, 2021 at 12:32:52PM -0500, Madhavan T. Venkataraman wrote:
> 
>> I have followed the example in the Kprobe deny list. I place the section
>> in initdata so it can be unloaded during boot. This means that I need to
>> copy the information before that in early_initcall().
> 
>> If the initialization must be performed on first use, I probably have to
>> move SYM_CODE_FUNCTIONS from initdata to some other place where it will
>> be retained.
> 
>> If you prefer this, I could do it this way.
> 
> No, I think if people are fine with this for kprobes they should be fine
> with it here too and if not we can always incrementally improve
> performance - let's just keep things simple and easy to understand for
> now.
> 

OK.

Madhavan
