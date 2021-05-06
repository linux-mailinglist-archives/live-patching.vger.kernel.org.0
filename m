Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97D637566B
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhEFPVg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:21:36 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38232 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbhEFPVf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:21:35 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id BC3BD20B7178;
        Thu,  6 May 2021 08:20:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC3BD20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620314437;
        bh=38FJmBMm62FNJbAmIqdoifYxsyXAhfVcnNsSEdMBgD0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BbcudnTW8r91m0v0K6ZtId3NOAYF0iHC2oWz4Ak1nCNi51+ES7ZOm0nmyx40i5cXC
         ZTW07gTcvVC6MJwR0BfbC+UvozkBqY/AJs3xNtgokGh97WHq2mAOQos1TbbIz3GsMm
         QkbVo2oH0N9c/dD/sgmUgkooiru1wlGmlBWYwAms=
Subject: Re: [RFC PATCH v3 4/4] arm64: Handle funtion graph tracer better in
 the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-5-madvenka@linux.microsoft.com>
 <20210506144352.GF4642@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f6616a1a-1291-b9b1-17d6-aed40f4a2b55@linux.microsoft.com>
Date:   Thu, 6 May 2021 10:20:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506144352.GF4642@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/6/21 9:43 AM, Mark Brown wrote:
> On Mon, May 03, 2021 at 12:36:15PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The Function Graph Tracer modifies the return address of a traced function
>> to a return trampoline (return_to_handler()) to gather tracing data on
>> function return. When the unwinder encounters return_to_handler(), it calls
>> ftrace_graph_get_ret_stack() to lookup the original return address in the
>> return address stack.
> 
> This makes sense to me, I'll need to re-review properly with the changes
> earlier on in the series but should be fine.
> 

I will make changes based on the comments I have received so far and send
out version 4 so everything is current for the next round of review.

Thanks!

Madhavan
