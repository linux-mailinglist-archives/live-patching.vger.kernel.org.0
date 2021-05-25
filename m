Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15096390BC0
	for <lists+live-patching@lfdr.de>; Tue, 25 May 2021 23:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhEYVqQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 May 2021 17:46:16 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33798 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhEYVqP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 May 2021 17:46:15 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id E49AC20B7178;
        Tue, 25 May 2021 14:44:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E49AC20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621979085;
        bh=xNF+N2LJWV8nwWOJm1bYsEtpnJX3GGsqwoncmJEKa0E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Uqo5qnXPyulwX2at001SEAKO9KxFLXfTtq/SlfdCOzqZfnYtByBcJ/yxxwyX488hi
         Nz6n8J9n/Km5blOVu+oseJsqCdWr4NgVOuHCWF1DPe3aKVSSubajbvqX0HAAtCwuMx
         NaSlCpCrZf6Cs4Ble18bydy9gxnNG5q4IaWzHckM=
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
 <20210521175318.GF5825@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <7f9366bd-1973-bc07-5314-45792f256dc1@linux.microsoft.com>
Date:   Tue, 25 May 2021 16:44:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521175318.GF5825@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/21/21 12:53 PM, Mark Brown wrote:
> On Fri, May 21, 2021 at 12:47:13PM -0500, Madhavan T. Venkataraman wrote:
>> On 5/21/21 12:42 PM, Mark Brown wrote:
> 
>>> Like I say we may come up with some use for the flag in error cases in
>>> future so I'm not opposed to keeping the accounting there.
> 
>> So, should I leave it the way it is now? Or should I not set reliable = false
>> for errors? Which one do you prefer?
> 
>> Josh,
> 
>> Are you OK with not flagging reliable = false for errors in unwind_frame()?
> 
> I think it's fine to leave it as it is.
> 

OK. I will address the comments so far and send out v5.

Thanks.

Madhavan
