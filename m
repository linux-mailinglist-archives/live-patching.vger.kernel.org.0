Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070F3342076
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhCSPDW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 11:03:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:46116 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhCSPCy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 11:02:54 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id BB0C520B3754;
        Fri, 19 Mar 2021 08:02:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BB0C520B3754
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616166174;
        bh=Zt/90atLLHUzYhfmjFjtxdJCiAuaf3iXLSZvdUpTUSU=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=JCKaCL6Cc0K17Rj0DZPEAImdGv8luXbG5TOtJ5OmZmUjPYu3hE/ycUh8b4PopBFZy
         0Z9ayWl2OLdVpi25bXnuNnXJ+vsnQOCIUwv64zmcpQtZKkRIfTVOJ5lNZlo1PndaKg
         QlMxLETG8XOjSUMMrq1RHMLKF1ZjvkizjuryVWts=
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-3-madvenka@linux.microsoft.com>
 <20210318174029.GM5469@sirena.org.uk>
 <6474b609-b624-f439-7bf7-61ce78ff7b83@linux.microsoft.com>
 <20210319132208.GD5619@sirena.org.uk>
 <e8d596c3-b1ec-77a6-f387-92ecd2ebfceb@linux.microsoft.com>
Message-ID: <eb0def39-efcf-52ac-ce46-5982e8555dc1@linux.microsoft.com>
Date:   Fri, 19 Mar 2021 10:02:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <e8d596c3-b1ec-77a6-f387-92ecd2ebfceb@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/19/21 9:40 AM, Madhavan T. Venkataraman wrote:
>> Are you referring to ARMv8.1 VHE extension where the kernel can run
>> at EL2? Could you elaborate? I thought that EL2 was basically for
>> Hypervisors.
> KVM is the main case, yes - IIRC otherwise it's mainly error handlers
> but I might be missing something.  We do recommend that the kernel is
> started at EL2 where possible.
> 
> Actually now I look again it's just not adding anything on EL2 entries
> at all, they use a separate set of macros which aren't updated - this
> will only update things for EL0 and EL1 entries so my comment above
> about this tracking EL2 as EL1 isn't accurate.

So, do I need to do anything here?

Madhavan
