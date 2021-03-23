Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EFE3465DD
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhCWRCv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 13:02:51 -0400
Received: from foss.arm.com ([217.140.110.172]:49276 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhCWRCm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 13:02:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD8771042;
        Tue, 23 Mar 2021 10:02:41 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F1013F718;
        Tue, 23 Mar 2021 10:02:39 -0700 (PDT)
Date:   Tue, 23 Mar 2021 17:02:36 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a
 stack trace unreliable
Message-ID: <20210323170236.GF98545@C02TD0UTHF1T.local>
References: <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 11:20:44AM -0500, Madhavan T. Venkataraman wrote:
> On 3/23/21 10:26 AM, Madhavan T. Venkataraman wrote:
> > On 3/23/21 9:57 AM, Mark Rutland wrote:
> >> On Tue, Mar 23, 2021 at 09:15:36AM -0500, Madhavan T. Venkataraman wrote:
> > So, my next question is - can we define a practical limit for the
> > nesting so that any nesting beyond that is fatal? The reason I ask
> > is - if there is a max, then we can allocate an array of stack
> > frames out of band for the special frames so they are not part of
> > the stack and will not likely get corrupted.
> > 
> > Also, we don't have to do any special detection. If the number of
> > out of band frames used is one or more then we have exceptions and
> > the stack trace is unreliable.
> 
> Alternatively, if we can just increment a counter in the task
> structure when an exception is entered and decrement it when an
> exception returns, that counter will tell us that the stack trace is
> unreliable.

As I noted earlier, we must treat *any* EL1 exception boundary needs to
be treated as unreliable for unwinding, and per my other comments w.r.t.
corrupting the call chain I don't think we need additional protection on
exception boundaries specifically.

> Is this feasible?
> 
> I think I have enough for v3 at this point. If you think that the
> counter idea is OK, I can implement it in v3. Once you confirm, I will
> start working on v3.

Currently, I don't see a compelling reason to need this, and would
prefer to avoid it.

More generally, could we please break this work into smaller steps? I
reckon we can break this down into the following chunks:

1. Add the explicit final frame and associated handling. I suspect that
   this is complicated enough on its own to be an independent series,
   and it's something that we can merge without all the bits and pieces
   necessary for truly reliable stacktracing.

2. Figure out how we must handle kprobes and ftrace. That probably means
   rejecting unwinds from specific places, but we might also want to
   adjust the trampolines if that makes this easier.

3. Figure out exception boundary handling. I'm currently working to
   simplify the entry assembly down to a uniform set of stubs, and I'd
   prefer to get that sorted before we teach the unwinder about
   exception boundaries, as it'll be significantly simpler to reason
   about and won't end up clashing with the rework.

Thanks,
Mark.
