Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65F3757FF
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhEFP6J (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:58:09 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43362 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhEFP6J (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:58:09 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1933520B7178;
        Thu,  6 May 2021 08:57:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1933520B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620316630;
        bh=dIXZ2Vx8eJ4U/nLj80jA+pVfCm4eSJoSpqWG4S1035c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GEnwZEUPS+ReP3mwe/47tgqKXcVhymUwe0dsBXeVp6jFsvy2fu7SQmVl2hOGGBWnw
         +XT1TUFx2DDzfsU+Bl7MSV54XXDUxOQzjGv7tbDSeDIO5z5PmaI4XPRbGRF3Drq3Mb
         i7PDhCtXZmQWNOXTeYmdEIsmiKVvDs6WeRFamNKo=
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
 <20210506153756.GA3377@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <0ef047c5-d3fe-619e-749d-b10ef3571bcd@linux.microsoft.com>
Date:   Thu, 6 May 2021 10:57:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506153756.GA3377@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/6/21 10:37 AM, Mark Brown wrote:
> On Thu, May 06, 2021 at 10:30:21AM -0500, Madhavan T. Venkataraman wrote:
>> On 5/6/21 9:12 AM, Mark Brown wrote:
>>> On Mon, May 03, 2021 at 12:36:14PM -0500, madvenka@linux.microsoft.com wrote:
> 
>>> I was thinking it'd be good to do this by modifying SYM_CODE_START() to
>>> emit the section, that way nobody can forget to put any SYM_CODE into a
>>> special section.  That does mean we'd have to first introduce a new
> 
>> OK. I could make the section an argument to SYM_CODE*() so that a developer
>> will never miss that. Some documentation may be in order so the guidelines
>> are clear. I will do the doc patch separately, if that is alright with
>> you all.
> 
> I was thinking to have standard SYM_CODE default to a section then a
> variant for anything that cares (like how we have SYM_FUNC_PI and
> friends for the PI code for EFI).
> 

OK.

>>> We also have a bunch of things like __cpu_soft_restart which don't seem
>>> to be called out here but need to be in .idmap.text.
> 
>> It is already in .idmap.text.
> 
> Right, I meant that I was expecting to see things that need to be in a
> specific section other than .code.text called out separately here if
> we're enumerating them.  Though if the annotations are done separately
> then this patch wouldn't need to do that calling out at all, it'd be
> covered as part of fiddling around with the annotations.
> 

OK.

Madhavan
