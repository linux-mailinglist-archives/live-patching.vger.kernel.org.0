Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE538CC36
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhEUReS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:34:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59448 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbhEUReR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:34:17 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8C68120B7188;
        Fri, 21 May 2021 10:32:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8C68120B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621618374;
        bh=kx/ub+OL0PzoQ/hT2KpbKriy7vxNbuz0bztaoHmRMxA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pY1l80FOiOGwYYaK4/exjyN+IR65hI3sJUmLEcnLo+vTzCDtaGAdxamRYNs8HlR6F
         0lc0twNVrQJvOfgDoSx03OxrZ90ak643peCTp1xyrmDNHB2farqYT5Oaly2vFev1hH
         4gMM8lSxEOHmv1ITHi/rDmUXK9laQMDpP2W/K0Uo=
Subject: Re: [RFC PATCH v4 0/2] arm64: Stack trace reliability checks in the
 unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210521171808.GC5825@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <654dde25-e6a2-a1e7-c2d7-e2692bc11528@linux.microsoft.com>
Date:   Fri, 21 May 2021 12:32:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521171808.GC5825@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/21/21 12:18 PM, Mark Brown wrote:
> On Sat, May 15, 2021 at 11:00:16PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> Special cases
>> =============
>>
>> Some special cases need to be mentioned:
> 
> I think it'd be good if more of this cover letter, especially sections
> like this which cover the tricky bits, ended up in the code somehow -
> it's recorded here and will be in the list archive but that's not the
> most discoverable place so increases the maintainance burden.  It'd be
> great to be able to compare the code directly with the reliable
> stacktrace requirements document and see everything getting ticked off,
> actually going all the way there might be too much and loose the code in
> the comments but I think we can get closer to it than we are.  Given
> that a lot of this stuff rests on the denylist perhaps some comments
> just before it's called would be a good place to start?
> 

I will add more comments in the code to make it clear.

>> 	- EL1 interrupt and exception handlers end up in sym_code_ranges[].
>> 	  So, all EL1 interrupt and exception stack traces will be considered
>> 	  unreliable. This the correct behavior as interrupts and exceptions
> 
> This stuff about exceptions and preemption is a big one, rejecting any
> exceptions makes a whole host of things easier (eg, Mark Rutland raised
> interactions between non-AAPCS code and PLTs as being an issue but if
> we're able to reliably reject stacks featuring any kind of preemption
> anyway that should sidestep the issue).
> 

Yes. I will include this in the code comments.

>> Performance
>> ===========
> 
>> Currently, unwinder_blacklisted() does a linear search through
>> sym_code_functions[]. If reviewers prefer, I could sort the
>> sym_code_functions[] array and perform a binary search for better
>> performance. There are about 80 entries in the array.
> 
> If people are trying to live patch a very busy/big system then this
> could be an issue, equally there's probably more people focused on
> getting boot times as fast as possible than live patching.  Deferring
> the initialisation to first use would help boot times with or without
> sorting, without numbers I don't actually know that sorting is worth the
> effort or needs doing immediately - obvious correctness is also a
> benefit!  My instinct is that for now it's probably OK leaving it as a
> linear scan and then revisiting if it's not adequately performant, but
> I'd defer to actual users there.

I have followed the example in the Kprobe deny list. I place the section
in initdata so it can be unloaded during boot. This means that I need to
copy the information before that in early_initcall().

If the initialization must be performed on first use, I probably have to
move SYM_CODE_FUNCTIONS from initdata to some other place where it will
be retained.

If you prefer this, I could do it this way.

Thanks!

Madhavan
