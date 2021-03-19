Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A03341F5E
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 15:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCSO35 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 10:29:57 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41798 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhCSO3o (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 10:29:44 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id A57E320B26C5;
        Fri, 19 Mar 2021 07:29:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A57E320B26C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616164182;
        bh=d7X6BG6dgBHW50HiFFnXMNIdPdhi9fazR5Ll2qA3ZXE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=E4JsUHKdc0pqdDu1RrjizUosr5k2HHGGgzN1y9R5oI43BHIQISutFwEzyJ94GlRDq
         OiZSAsYQK1HEcQvIrQInxe5WEsk9U4nw0aoUJ0kEFpWcnc/kLJypcBDSVpmaCRDIkm
         ViPKxJ6+gPzRhX9ccUca58RX/DkKpiNaMqt/bxok=
Subject: Re: [RFC PATCH v2 1/8] arm64: Implement stack trace termination
 record
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-2-madvenka@linux.microsoft.com>
 <20210318150905.GL5469@sirena.org.uk>
 <8591e34a-c181-f3ff-e691-a6350225e5b4@linux.microsoft.com>
 <20210319123023.GC5619@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <5dbaf34f-b2fc-b9b8-3918-83356f2f752a@linux.microsoft.com>
Date:   Fri, 19 Mar 2021 09:29:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210319123023.GC5619@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/19/21 7:30 AM, Mark Brown wrote:
> On Thu, Mar 18, 2021 at 03:26:13PM -0500, Madhavan T. Venkataraman wrote:
>> On 3/18/21 10:09 AM, Mark Brown wrote:
> 
>>> If we are going to add the extra record there would probably be less
>>> potential for confusion if we pointed it at some sensibly named dummy
>>> function so anything or anyone that does see it on the stack doesn't get
>>> confused by a NULL.
> 
>> I agree. I will think about this some more. If no other solution presents
>> itself, I will add the dummy function.
> 
> After discussing this with Mark Rutland offlist he convinced me that so
> long as we ensure the kernel doesn't print the NULL record we're
> probably OK here, the effort setting the function pointer up correctly
> in all circumstances (especially when we're not in the normal memory
> map) is probably not worth it for the limited impact it's likely to have
> to see the NULL pointer (probably mainly a person working with some
> external debugger).  It should be noted in the changelog though, and/or
> merged in with the relevant change to the unwinder.
> 

OK. I will add a comment as well as note it in the changelog.

Thanks to both of you.

Madhavan
