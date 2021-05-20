Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53F389B19
	for <lists+live-patching@lfdr.de>; Thu, 20 May 2021 04:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhETCBi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 May 2021 22:01:38 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60098 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhETCBh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 May 2021 22:01:37 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 95B3A20B7178;
        Wed, 19 May 2021 19:00:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 95B3A20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621476017;
        bh=U8QEKQGFiRQOQLEHv8ObhS4iuMjm72aPIoLD5Z21rRg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NgTZCCwk+NyZJh/Q5+8WXfReGR4mxTpJnXOqpoNZOmnLZQ7bIO4nCxxUkvtVtptaF
         MyivxqYXEA+qoVEVQ7A43OSK60aAKmXZaGdi/NUZUwciCqMRdsGgbQCChSFczo9LPI
         9cwM+2aY2NnzBKrJA1lmL9Wn/mB+rQuUCTzlJ4Y0=
Subject: Re: [RFC PATCH v4 2/2] arm64: Create a list of SYM_CODE functions,
 blacklist them in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-3-madvenka@linux.microsoft.com>
 <20210519192730.GI4224@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <2067fb27-34ba-8b7e-e6ef-505796316970@linux.microsoft.com>
Date:   Wed, 19 May 2021 21:00:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519192730.GI4224@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks a lot!

Madhavan

On 5/19/21 2:27 PM, Mark Brown wrote:
> On Sat, May 15, 2021 at 11:00:18PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The unwinder should check if the return PC falls in any function that
>> is considered unreliable from an unwinding perspective. If it does,
>> mark the stack trace unreliable.
> 
> Other than the naming issue this makes sense to me, I'll try to go
> through the first patch properly in the next few days.
> 
