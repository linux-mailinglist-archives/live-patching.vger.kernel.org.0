Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1101C35D184
	for <lists+live-patching@lfdr.de>; Mon, 12 Apr 2021 21:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbhDLTz4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Apr 2021 15:55:56 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48696 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbhDLTz4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Apr 2021 15:55:56 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id D9CC020B8000;
        Mon, 12 Apr 2021 12:55:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9CC020B8000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618257337;
        bh=h2gvJ5oqXftarQ16pvd9FutkrlcdXEhDOKLCNzGzJQ0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Qob3oXb5+R1rog4vksif5LZhrGvetrYNRzhrXhIBDtM0KVtPP51ISu5FlyThZA03t
         OnQ9oqE2cgFhgN5SZFrTTOoK/L/wNTTtiwSocCAswt0d9SmVCLPb96E8wWZyA6U4du
         3lj2SzQRCinCdoNr+PbXitPVpvRd8KzUeE+yny6o=
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
To:     Mark Brown <broonie@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <20210412173617.GE5379@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
Date:   Mon, 12 Apr 2021 14:55:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412173617.GE5379@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/12/21 12:36 PM, Mark Brown wrote:
> On Fri, Apr 09, 2021 at 04:37:41PM -0500, Josh Poimboeuf wrote:
>> On Fri, Apr 09, 2021 at 01:09:09PM +0100, Mark Rutland wrote:
> 
>>> Further, I believe all the special cases are assembly functions, and
>>> most of those are already in special sections to begin with. I reckon
>>> it'd be simpler and more robust to reject unwinding based on the
>>> section. If we need to unwind across specific functions in those
>>> sections, we could opt-in with some metadata. So e.g. we could reject
>>> all functions in ".entry.text", special casing the EL0 entry functions
>>> if necessary.
> 
>> Couldn't this also end up being somewhat fragile?  Saying "certain
>> sections are deemed unreliable" isn't necessarily obvious to somebody
>> who doesn't already know about it, and it could be overlooked or
>> forgotten over time.  And there's no way to enforce it stays that way.
> 
> Anything in this area is going to have some opportunity for fragility
> and missed assumptions somewhere.  I do find the idea of using the
> SYM_CODE annotations that we already have and use for other purposes to
> flag code that we don't expect to be suitable for reliable unwinding
> appealing from that point of view.  It's pretty clear at the points
> where they're used that they're needed, even with a pretty surface level
> review, and the bit actually pushing things into a section is going to
> be in a single place where the macro is defined.  That seems relatively
> robust as these things go, it seems no worse than our reliance on
> SYM_FUNC to create BTI annotations.  Missing those causes oopses when we
> try to branch to the function.
> 

OK. Just so I am clear on the whole picture, let me state my understanding so far.
Correct me if I am wrong.

1. We are hoping that we can convert a significant number of SYM_CODE functions to
   SYM_FUNC functions by providing them with a proper FP prolog and epilog so that
   we can get objtool coverage for them. These don't need any blacklisting.

2. If we can locate the pt_regs structures created on the stack cleanly for EL1
   exceptions, etc, then we can handle those cases in the unwinder without needing
   any black listing.

   I have a solution for this in version 3 that does it without encoding the FP or
   matching values on the stack. I have addressed all of the objections so far on
   that count. I will send the patch series out soon.

3. We are going to assume that the reliable unwinder is only for livepatch purposes
   and will only be invoked on a task that is not currently running. The task either
   voluntarily gave up the CPU or was pre-empted. We can safely ignore all SYM_CODE
   functions that will never voluntarily give up the CPU. They can only be pre-empted
   and pre-emption is already handled in (2). We don't need to blacklist any of these
   functions.

4. So, the only functions that will need blacklisting are the remaining SYM_CODE functions
   that might give up the CPU voluntarily. At this point, I am not even sure how
   many of these will exist. One hopes that all of these would have ended up as
   SYM_FUNC functions in (1).

So, IMHO, placing code in a black listed section should be the last step and not the first
one. This also satisfies Mark Rutland's requirement that no one muck with the entry text
while he is sorting out that code.

I suggest we do (3) first. Then, review the assembly functions to do (1). Then, review the
remaining ones to see which ones must be blacklisted, if any.

Do you agree?

Madhavan
