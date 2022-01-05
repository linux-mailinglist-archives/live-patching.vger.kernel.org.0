Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B6C485CB8
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 00:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbiAEX7D (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jan 2022 18:59:03 -0500
Received: from linux.microsoft.com ([13.77.154.182]:35072 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239615AbiAEX7B (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jan 2022 18:59:01 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 15A6C20B7179;
        Wed,  5 Jan 2022 15:59:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 15A6C20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641427140;
        bh=isMsZ9PjYpeZF+DylXH2CoVWmE+GQLqJiZb61eOCKOE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ItwAkrsl4Etr04TzIlcPXDoiKY0ij+1jXREZcKRlvNXP3hgcZjpM0f3oVxlt/qc+u
         v1uZBCl9ySBPd/rddAtGKxFsYMhvK5e5j8ekfnjDPfSMJdJM2lbd0Xlx2sdy6dzUAk
         N7HeAAh56tc8u1/HX/lIzMpvB6aM5jl+ug3W5ZlE=
Subject: Re: [PATCH v12 07/10] arm64: Introduce stack trace reliability checks
 in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-8-madvenka@linux.microsoft.com>
 <YdXOQTXscVaVFMJ3@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <85156eb8-df63-29c0-cbfc-37bc0356d9e8@linux.microsoft.com>
Date:   Wed, 5 Jan 2022 17:58:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YdXOQTXscVaVFMJ3@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks for the review. Do you have any comments on:

[PATCH v12 04/10] arm64: Split unwind_init()
[PATCH v12 10/10] arm64: Select HAVE_RELIABLE_STACKTRACE

Madhavan

On 1/5/22 10:58 AM, Mark Brown wrote:
> On Mon, Jan 03, 2022 at 10:52:09AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> There are some kernel features and conditions that make a stack trace
>> unreliable. Callers may require the unwinder to detect these cases.
>> E.g., livepatch.
> 
> Reviwed-by: Mark Brown <broonie@kernel.org>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
