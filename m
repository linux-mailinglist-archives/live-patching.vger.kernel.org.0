Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52E6375736
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhEFPdb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:33:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39910 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbhEFPda (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:33:30 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6DC3B20B7178;
        Thu,  6 May 2021 08:32:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6DC3B20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620315152;
        bh=J7MaQ16/i/vdDMbMFnz19i3iHpZFSCik0FINQjchwQo=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=oXIuYDEK1mGkk3pngEhxkO0JowlBIeaup8lce0VRvzUO1qhNArg6x3ve39QOgF1qS
         Z7bPbD7lqECnhIaqBvVeiHH1BaXtQ+Sief2HDqpBHz4/KywJ+iIjcWjCPyhF+aNhH+
         L8pv9C7xb+OajMFSeOlIDTUZky1sHygf3HJ6CrPY=
Subject: Re: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in .text
 and .init.text
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
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
Message-ID: <cb2c47ee-97d7-15d8-05db-b8e3e260b782@linux.microsoft.com>
Date:   Thu, 6 May 2021 10:32:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8268fde8-5f3b-0781-971b-b29b5e0916cf@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/6/21 10:30 AM, Madhavan T. Venkataraman wrote:
>> I was thinking it'd be good to do this by modifying SYM_CODE_START() to
>> emit the section, that way nobody can forget to put any SYM_CODE into a
>> special section.  That does mean we'd have to first introduce a new
>> variant for specifying a section that lets us override things that need
>> to be in some specific section and convert everything that's in a
>> special section over to that first which is a bit annoying but feels
>> like it's worth it for the robustness.  It'd also put some of the don't
>> cares into .code.text but so long as they are actually don't cares that
>> should be fine!
>>
> OK. I could make the section an argument to SYM_CODE*() so that a developer
> will never miss that. Some documentation may be in order so the guidelines
> are clear. I will do the doc patch separately, if that is alright with
> you all.

There is just one problem with this. Sometimes, there is some data in the
same text section. That data will not get included when we do the SYM_CODE(section)
change.

Madhavan
