Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054B473374
	for <lists+live-patching@lfdr.de>; Wed, 24 Jul 2019 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfGXQPF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Jul 2019 12:15:05 -0400
Received: from foss.arm.com ([217.140.110.172]:43186 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfGXQPF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Jul 2019 12:15:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94F4828;
        Wed, 24 Jul 2019 09:15:04 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD5DE3F71F;
        Wed, 24 Jul 2019 09:15:02 -0700 (PDT)
Date:   Wed, 24 Jul 2019 17:15:00 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Ruslan Bilovol <ruslan.bilovol@gmail.com>
Cc:     Will Deacon <will.deacon@arm.com>, Torsten Duwe <duwe@lst.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v8 0/5] arm64: ftrace with regs
Message-ID: <20190724161500.GG2624@lakrids.cambridge.arm.com>
References: <20190208150826.44EBC68DD2@newverein.lst.de>
 <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com>
 <20190311114945.GA5625@lst.de>
 <20190408153628.GL6139@lakrids.cambridge.arm.com>
 <20190409175238.GE9255@fuggles.cambridge.arm.com>
 <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Ruslan,

On Wed, Jul 10, 2019 at 03:27:58PM +0300, Ruslan Bilovol wrote:
> On Tue, Apr 9, 2019 at 8:52 PM Will Deacon <will.deacon@arm.com> wrote:
> >
> > On Mon, Apr 08, 2019 at 04:36:28PM +0100, Mark Rutland wrote:
> > > On Mon, Mar 11, 2019 at 12:49:46PM +0100, Torsten Duwe wrote:
> > > > On Wed, Feb 13, 2019 at 11:11:04AM +0000, Julien Thierry wrote:
> > > > > Hi Torsten,
> > > > >
> > > > > On 08/02/2019 15:08, Torsten Duwe wrote:
> > > > > > Patch series v8, as discussed.
> > > > > > The whole series applies cleanly on 5.0-rc5
> > > >
> > > > So what's the status now? Besides debatable minor style
> > > > issues there were no more objections to v8. Would this
> > > > go through the ARM repo or via the ftrace repo?
> > >
> > > Sorry agains for the delay on this. I'm now back in the office and in
> > > front of a computer daily, so I can spend a bit more time on this.
> > >
> > > Regardless of anything else, I think that we should queue the first
> > > three patches now. I've poked the relevant maintainers for their acks so
> > > that those can be taken via the arm64 tree.
> > >
> > > I'm happy to do the trivial cleanups on the last couple of patches (e.g.
> > > s/lr/x30), and I'm actively looking at the API rework I requested.
> >
> > Ok, I've picked up patches 1-3 and I'll wait for you to spin updates to the
> > last two.
> 
> Ok, I see that patches 1-3 are picked up and are already present in recent
> kernels.
> 
> Is there any progress on remaining two patches?

I'm afraid that I've been distracted on other fronts, so I haven't made
progress there.

> Any help required?

If you'd be happy to look at the cleanup I previously suggested for the
core, that would be great. When I last looked, it was simple to rework
things so that arch code doesn't have to define MCOUNT_ADDR, but I
hadn't figured out exactly how to split the core mcount assumptions from
the important state machine bits.

I'll take another look and see if I can provide more detail. :)

Thanks,
Mark.
