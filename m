Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CB7345C09
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 11:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhCWKhY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 06:37:24 -0400
Received: from foss.arm.com ([217.140.110.172]:43670 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhCWKgu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 06:36:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E25D81042;
        Tue, 23 Mar 2021 03:36:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8EE63F719;
        Tue, 23 Mar 2021 03:36:47 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:36:44 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Brown <broonie@kernel.org>, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/8] arm64: Terminate the stack trace at
 TASK_FRAME and EL0_FRAME
Message-ID: <20210323103644.GC95840@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-4-madvenka@linux.microsoft.com>
 <20210318182607.GO5469@sirena.org.uk>
 <fd5763e4-b649-683b-3038-7f221eed68a9@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd5763e4-b649-683b-3038-7f221eed68a9@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Mar 18, 2021 at 03:29:19PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 3/18/21 1:26 PM, Mark Brown wrote:
> > On Mon, Mar 15, 2021 at 11:57:55AM -0500, madvenka@linux.microsoft.com wrote:
> > 
> >> +	/* Terminal record, nothing to unwind */
> >> +	if (fp == (unsigned long) regs->stackframe) {
> >> +		if (regs->frame_type == TASK_FRAME ||
> >> +		    regs->frame_type == EL0_FRAME)
> >> +			return -ENOENT;
> >>  		return -EINVAL;
> >> +	}
> > 
> > This is conflating the reliable stacktrace checks (which your series
> > will later flag up with frame->reliable) with verifying that we found
> > the bottom of the stack by looking for this terminal stack frame record.
> > For the purposes of determining if the unwinder got to the bottom of the
> > stack we don't care what stack type we're looking at, we just care if it
> > managed to walk to this defined final record.  
> > 
> > At the minute nothing except reliable stack trace has any intention of
> > checking the specific return code but it's clearer to be consistent.
> > 
> 
> So, you are saying that the type check is redundant. OK. I will remove it
> and just return -ENOENT on reaching the final record.

Yes please; and please fold that into the same patch that adds the final
records.

Thanks,
Mark.
