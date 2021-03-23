Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D931B3465A2
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 17:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCWQsP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 12:48:15 -0400
Received: from foss.arm.com ([217.140.110.172]:49154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhCWQsH (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 12:48:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1B27D6E;
        Tue, 23 Mar 2021 09:48:06 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B7063F718;
        Tue, 23 Mar 2021 09:48:04 -0700 (PDT)
Date:   Tue, 23 Mar 2021 16:48:01 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a
 stack trace unreliable
Message-ID: <20210323164801.GE98545@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 10:26:50AM -0500, Madhavan T. Venkataraman wrote:
> On 3/23/21 9:57 AM, Mark Rutland wrote:
> Thanks for explaining the nesting. It is now clear to me.

No problem!

> So, my next question is - can we define a practical limit for the
> nesting so that any nesting beyond that is fatal? The reason I ask is
> - if there is a max, then we can allocate an array of stack frames out
> of band for the special frames so they are not part of the stack and
> will not likely get corrupted.

I suspect we can't define such a fatal limit without introducing a local
DoS vector on some otherwise legitimate workload, and I fear this will
further complicate the entry/exit logic, so I'd prefer to avoid
introducing a new limit.

What exactly do you mean by a "special frame", and why do those need
additional protection over regular frame records?

> Also, we don't have to do any special detection. If the number of out
> of band frames used is one or more then we have exceptions and the
> stack trace is unreliable.

What is expected to protect against?

Thanks,
Mark.
