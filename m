Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017CB346601
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 18:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCWRJs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 13:09:48 -0400
Received: from foss.arm.com ([217.140.110.172]:49400 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCWRJa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 13:09:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 228B51042;
        Tue, 23 Mar 2021 10:09:30 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 103A53F718;
        Tue, 23 Mar 2021 10:09:27 -0700 (PDT)
Date:   Tue, 23 Mar 2021 17:09:25 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a
 stack trace unreliable
Message-ID: <20210323170925.GG98545@C02TD0UTHF1T.local>
References: <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <20210323164801.GE98545@C02TD0UTHF1T.local>
 <bfc4dbbd-f69b-1a41-c16a-0c5cd0080f90@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfc4dbbd-f69b-1a41-c16a-0c5cd0080f90@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 11:53:04AM -0500, Madhavan T. Venkataraman wrote:
> On 3/23/21 11:48 AM, Mark Rutland wrote:
> > On Tue, Mar 23, 2021 at 10:26:50AM -0500, Madhavan T. Venkataraman wrote:
> >> So, my next question is - can we define a practical limit for the
> >> nesting so that any nesting beyond that is fatal? The reason I ask is
> >> - if there is a max, then we can allocate an array of stack frames out
> >> of band for the special frames so they are not part of the stack and
> >> will not likely get corrupted.

> >> Also, we don't have to do any special detection. If the number of out
> >> of band frames used is one or more then we have exceptions and the
> >> stack trace is unreliable.
> > 
> > What is expected to protect against?
> 
> It is not a protection thing. I just wanted a reliable way to tell that there
> is an exception without having to unwind the stack up to the exception frame.
> That is all.

I see.

Given that's an optimization, we can consider doing something like that
that after we have the functional bits in place, where we'll be in a
position to see whether this is even a measureable concern in practice.

I suspect that longer-term we'll end up trying to use metadata to unwind
across exception boundaries, since it's possible to get blocked within
those for long periods (e.g. for a uaccess fault), and the larger scale
optimization for patching is to not block the patch.

Thanks,
Mark.
