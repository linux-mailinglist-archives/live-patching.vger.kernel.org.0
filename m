Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4684C3757FC
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhEFP5d (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:57:33 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43248 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhEFP5b (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:57:31 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4CE4120B7178;
        Thu,  6 May 2021 08:56:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4CE4120B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620316592;
        bh=GIfCoV9KFWohoBxPazrWBAeAPjccvuUsv3Ddnomlpaw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ObphGfDCiPUN6Uqd2LI5zwRgrMDWHee5gSUO/gDYosOVrYKrj6UIGHs+mLkEmImov
         aIwo4KKCWNQnAXyB4EGvGMlDTyAqAWXlSP3B74Oa6I59d0rpZ4aPrBWIjL8oEzDMMU
         1BqbJIcnB/SiClMcS7Jk9X5WBR05nNrypXJ1+wLw=
Subject: Re: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in .text
 and .init.text
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-4-madvenka@linux.microsoft.com>
 <20210506141211.GE4642@sirena.org.uk>
 <8268fde8-5f3b-0781-971b-b29b5e0916cf@linux.microsoft.com>
 <cb2c47ee-97d7-15d8-05db-b8e3e260b782@linux.microsoft.com>
 <20210506154449.GB3377@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <71e2f293-2bd4-173e-163c-694a80390f6c@linux.microsoft.com>
Date:   Thu, 6 May 2021 10:56:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506154449.GB3377@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/6/21 10:44 AM, Mark Brown wrote:
> On Thu, May 06, 2021 at 10:32:30AM -0500, Madhavan T. Venkataraman wrote:
>> On 5/6/21 10:30 AM, Madhavan T. Venkataraman wrote:
> 
>>> OK. I could make the section an argument to SYM_CODE*() so that a developer
>>> will never miss that. Some documentation may be in order so the guidelines
>>> are clear. I will do the doc patch separately, if that is alright with
>>> you all.
> 
>> There is just one problem with this. Sometimes, there is some data in the
>> same text section. That data will not get included when we do the SYM_CODE(section)
>> change.
> 
> Yes, data would need to be handled separately still.  That doesn't seem
> insurmountable though?
> 

I will think of something.

Madhavan
