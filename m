Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A802D3F6853
	for <lists+live-patching@lfdr.de>; Tue, 24 Aug 2021 19:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhHXRnj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 13:43:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38450 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbhHXRlk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 13:41:40 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id ACBD920B85E3;
        Tue, 24 Aug 2021 10:40:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ACBD920B85E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629826855;
        bh=iEH5ZkCYlu4MLwDsXaWAUZTZ3u76InpKPQIAJ+tahCQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ULQYwR/HDrdutfZuWoBYjv9J+K9Ajv4mdI+RS8hF1D0bPirfKKirW3dyTu0hkjIDy
         w1brU4AdqF15GjIRR592ogXMq412yRkEUK2wwErTLABjjlQzJUQHIa1om4SgSnEUB3
         h5ZnMjbHcDGnNq/F1uUzywYcsWGj0+GEz5P5703k=
Subject: Re: [RFC PATCH v8 1/4] arm64: Make all stack walking functions use
 arch_stack_walk()
To:     Mark Brown <broonie@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-2-madvenka@linux.microsoft.com>
 <20210824131344.GE96738@C02TD0UTHF1T.local>
 <da2bb980-09c3-5a39-73cd-ca4de4c38d51@linux.microsoft.com>
 <20210824173850.GN4393@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f906ab5f-cfa8-17b5-843f-77869cf48586@linux.microsoft.com>
Date:   Tue, 24 Aug 2021 12:40:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824173850.GN4393@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 8/24/21 12:38 PM, Mark Brown wrote:
> On Tue, Aug 24, 2021 at 12:21:28PM -0500, Madhavan T. Venkataraman wrote:
>> On 8/24/21 8:13 AM, Mark Rutland wrote:
>>> On Thu, Aug 12, 2021 at 02:06:00PM -0500, madvenka@linux.microsoft.com wrote:
> 
>>> Note that arch_stack_walk() depends on CONFIG_STACKTRACE (which is not in
>>> defconfig), so we'll need to reorganise things such that it's always defined,
>>> or factor out the core of that function and add a wrapper such that we
>>> can always use it.
> 
>> I will include CONFIG_STACKTRACE in defconfig, if that is OK with you and
>> Mark Brown.
> 
> That might be separately useful but it doesn't address the issue, if
> something is optional we need to handle the case where that option is
> disabled.  It'll need to be one of the two options Mark Rutland
> mentioned above.
> 

OK. I will do it so it is always defined.

Thanks.

Madhavan
