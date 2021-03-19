Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB33C3421D9
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhCSQ1q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 12:27:46 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56920 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCSQ1Q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 12:27:16 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 997D520B39C5;
        Fri, 19 Mar 2021 09:27:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 997D520B39C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616171236;
        bh=Wsdbg1M1cJRQ0/oeaxzGq2LeLW2IuQM+xw0EQ7ZsQjY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a3QuHKGJPWFyLqX6zl9nTAbnVB4AZxpBk+ci/qqImu+j0JkaLSUO2X5GgEyWI/ULw
         o0kjzwgV8o1Rf6HRQxj+jyN9eksyuYYd4Ytesu22m1786vx6QPZsnCN2XtlDgHbGoo
         okcBBEjge/cB60mlKO3Cx7HtwT7o59a9Cn+CxkcU=
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
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
 <eb0def39-efcf-52ac-ce46-5982e8555dc1@linux.microsoft.com>
 <20210319162031.GG5619@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f2cc4d67-8acc-1b80-edd7-23336beea4c1@linux.microsoft.com>
Date:   Fri, 19 Mar 2021 11:27:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210319162031.GG5619@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/19/21 11:20 AM, Mark Brown wrote:
> On Fri, Mar 19, 2021 at 10:02:52AM -0500, Madhavan T. Venkataraman wrote:
>> On 3/19/21 9:40 AM, Madhavan T. Venkataraman wrote:
> 
>>> Actually now I look again it's just not adding anything on EL2 entries
>>> at all, they use a separate set of macros which aren't updated - this
>>> will only update things for EL0 and EL1 entries so my comment above
>>> about this tracking EL2 as EL1 isn't accurate.
> 
>> So, do I need to do anything here?
> 
> Probably worth some note somewhere about other stack types existing and
> how they end up being handled, in the changelog at least.
> 
OK.

Madhavan
