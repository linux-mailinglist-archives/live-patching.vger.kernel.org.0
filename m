Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB43FE9C5
	for <lists+live-patching@lfdr.de>; Thu,  2 Sep 2021 09:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhIBHLC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Sep 2021 03:11:02 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41836 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242504AbhIBHLA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Sep 2021 03:11:00 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E8C3220B71D5;
        Thu,  2 Sep 2021 00:10:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E8C3220B71D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1630566602;
        bh=Gm7mDHFy4xsNam3X90cB6VLAwXc244muiywxwcxc5AM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AKZ78sIeyyFosHBcUapsnPcDOwYmBWVj5KPX0ePT2j71QU2tRfgXeU11TTrduE0mY
         bFScIuyDUGp5Qlw91QIlec1KFRVt/7i9VENeBcHFzUtOO48PPNooX6shHO6Xea1zia
         sBV+Sq/qdNlNpIL96hflImYaSJ1iLMP5feid79MI=
Subject: Re: [RFC PATCH v8 2/4] arm64: Reorganize the unwinder code for better
 consistency and maintenance
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-3-madvenka@linux.microsoft.com>
 <YSe3WogpFIu97i/7@sirena.org.uk>
 <ecf0e4d1-7c47-426e-1350-fe5dc8bd88a5@linux.microsoft.com>
 <20210901162005.GH5976@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <dbd7f035-ad4e-1b92-3f09-d4fddb21f5a3@linux.microsoft.com>
Date:   Thu, 2 Sep 2021 02:10:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901162005.GH5976@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 9/1/21 11:20 AM, Mark Brown wrote:
> On Thu, Aug 26, 2021 at 06:19:07PM -0500, Madhavan T. Venkataraman wrote:
> 
>> Mark Rutland,
> 
>> Do you also approve the idea of placing unreliable functions (from an unwind
>> perspective) in a special section and using that in the unwinder for
>> reliable stack trace?
> 
> Rutland is on vacation for a couple of weeks so he's unlikely to reply
> before the merge window is over I'm afraid.
> 

OK. I am pretty sure he is fine with the special sections idea. So, I will
send out version 8 with the changes you requested and without the "RFC".

Thanks.

Madhavan
