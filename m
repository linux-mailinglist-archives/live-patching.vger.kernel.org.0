Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C83D8FC5
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 13:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfJPLnG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 07:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfJPLnF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 07:43:05 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CC221848;
        Wed, 16 Oct 2019 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571226185;
        bh=PmYKqxbOOvz8BV7rulnSKvx5ub0QO0AeeOamne1eykg=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=i1w1YZlGDYWLysQYdPGSEO8ia3QEop5kFW1QZeyZiycshs41S1t8NKKBqUzCxCeUh
         RFXrccRyr7r/WmYMKN7k2gMXNJyd2Jn6n4Z6b8zYbd3lnr/IqfAuSP7p0H7Lt4DIds
         lul6X0aPFKBqKJXEydY3BFN5TalV6VZM4AltHPTU=
Date:   Wed, 16 Oct 2019 13:42:59 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
cc:     Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Torsten Duwe <duwe@lst.de>,
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
In-Reply-To: <20190724161500.GG2624@lakrids.cambridge.arm.com>
Message-ID: <nycvar.YFH.7.76.1910161341520.13160@cbobk.fhfr.pm>
References: <20190208150826.44EBC68DD2@newverein.lst.de> <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com> <20190311114945.GA5625@lst.de> <20190408153628.GL6139@lakrids.cambridge.arm.com> <20190409175238.GE9255@fuggles.cambridge.arm.com>
 <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com> <20190724161500.GG2624@lakrids.cambridge.arm.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 24 Jul 2019, Mark Rutland wrote:

> > > > > So what's the status now? Besides debatable minor style
> > > > > issues there were no more objections to v8. Would this
> > > > > go through the ARM repo or via the ftrace repo?
> > > >
> > > > Sorry agains for the delay on this. I'm now back in the office and in
> > > > front of a computer daily, so I can spend a bit more time on this.
> > > >
> > > > Regardless of anything else, I think that we should queue the first
> > > > three patches now. I've poked the relevant maintainers for their acks so
> > > > that those can be taken via the arm64 tree.
> > > >
> > > > I'm happy to do the trivial cleanups on the last couple of patches (e.g.
> > > > s/lr/x30), and I'm actively looking at the API rework I requested.
> > >
> > > Ok, I've picked up patches 1-3 and I'll wait for you to spin updates to the
> > > last two.
> > 
> > Ok, I see that patches 1-3 are picked up and are already present in recent
> > kernels.
> > 
> > Is there any progress on remaining two patches?
> 
> I'm afraid that I've been distracted on other fronts, so I haven't made
> progress there.
> 
> > Any help required?
> 
> If you'd be happy to look at the cleanup I previously suggested for the
> core, that would be great. When I last looked, it was simple to rework
> things so that arch code doesn't have to define MCOUNT_ADDR, but I
> hadn't figured out exactly how to split the core mcount assumptions from
> the important state machine bits.
> 
> I'll take another look and see if I can provide more detail. :)

Hi Mark,

has any progress been made on any front? Feels like this got stuck a bit.

Thanks,

-- 
Jiri Kosina
SUSE Labs

