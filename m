Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6F34621B
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 15:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhCWO6G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 10:58:06 -0400
Received: from foss.arm.com ([217.140.110.172]:47710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232402AbhCWO5i (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 10:57:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CC77D6E;
        Tue, 23 Mar 2021 07:57:38 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADC963F718;
        Tue, 23 Mar 2021 07:57:36 -0700 (PDT)
Date:   Tue, 23 Mar 2021 14:57:34 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a
 stack trace unreliable
Message-ID: <20210323145734.GD98545@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 09:15:36AM -0500, Madhavan T. Venkataraman wrote:
> Hi Mark,
> 
> I have a general question. When exceptions are nested, how does it work? Let us consider 2 cases:
> 
> 1. Exception in a page fault handler itself. In this case, I guess one more pt_regs will get
>    established in the task stack for the second exception.

Generally (ignoring SDEI and stack overflow exceptions) the regs will be
placed on the stack that was in use when the exception occurred, e.g.

  task -> task
  irq -> irq
  overflow -> overflow

For SDEI and stack overflow, we'll place the regs on the relevant SDEI
or overflow stack, e.g.

  task -> overflow
  irq -> overflow

  task -> sdei
  irq -> sdei

I tried to explain the nesting rules in:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kernel/stacktrace.c?h=v5.11#n59
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64/kernel/stacktrace.c?h=v5.11&id=592700f094be229b5c9cc1192d5cea46eb4c7afc

> 2. Exception in an interrupt handler. Here the interrupt handler is running on the IRQ stack.
>    Will the pt_regs get created on the IRQ stack?

For an interrupt the regs will be placed on the stack that was in use
when the interrupt was taken. The kernel switches to the IRQ stack
*after* stacking the registers. e.g.

  task -> task // subsequently switches to IRQ stack
  irq -> irq

> Also, is there a maximum nesting for exceptions?

In practice, yes, but the specific number isn't a constant, so in the
unwind code we have to act as if there is no limit other than stack
sizing.

We try to prevent cerain exceptions from nesting (e.g. debug exceptions
cannot nest), but there are still several level sof nesting, and some
exceptions which can be nested safely (like faults). For example, it's
possible to have a chain:

 syscall -> fault -> interrupt -> fault -> pNMI -> fault -> SError -> fault -> watchpoint -> fault -> overflow -> fault -> BRK

... and potentially longer than that.

The practical limit is the size of all the stacks, and the unwinder's 
stack monotonicity checks ensure that an unwind will terminate.

Thanks,
Mark.
