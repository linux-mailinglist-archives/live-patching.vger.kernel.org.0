Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62499222144
	for <lists+live-patching@lfdr.de>; Thu, 16 Jul 2020 13:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGPLUw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jul 2020 07:20:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:59204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgGPLUw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jul 2020 07:20:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C15ACACB8;
        Thu, 16 Jul 2020 11:20:54 +0000 (UTC)
Date:   Thu, 16 Jul 2020 13:20:50 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, Yannick Cote <ycote@redhat.com>
Subject: Re: linux-next: Tree for Jun 23 (objtool (2))
In-Reply-To: <20200715162457.mhoz2rgjbl4okx6d@treble>
Message-ID: <alpine.LSU.2.21.2007161315490.3958@pobox.suse.cz>
References: <20200623162820.3f45feae@canb.auug.org.au> <61df2e8f-75e8-d233-9c3c-5b4fa2b7fbdc@infradead.org> <20200702123555.bjioosahrs5vjovu@treble> <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz> <20200714135747.lcgysd5joguhssas@treble>
 <alpine.LSU.2.21.2007151250390.25290@pobox.suse.cz> <20200715121054.GH20226@alley> <20200715134155.GI20226@alley> <20200715162457.mhoz2rgjbl4okx6d@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 15 Jul 2020, Josh Poimboeuf wrote:

> On Wed, Jul 15, 2020 at 03:41:55PM +0200, Petr Mladek wrote:
> > On Wed 2020-07-15 14:10:54, Petr Mladek wrote:
> > > On Wed 2020-07-15 13:11:14, Miroslav Benes wrote:
> > > > Petr, would you agree to revert -flive-patching.
> > > 
> > > Yes, I agree.
> > 
> > Or better to say that I will not block it.
> > 
> > I see that it causes maintenance burden. There are questions about
> > reliability and performance impact. I do not have a magic solution
> > in the pocket.
> > 
> > Anyway, we need a solution to know what functions need to get livepatched.
> > I do not have experience with comparing the assembly, so I do not know
> > how it is complicated and reliable.
> 
> Thanks Petr/Miroslav.  I can do the revert patch.  It doesn't have to be
> a permanent revert.  I'd certainly be willing to ACK it again in the
> future if/when it becomes more ready.

Ok.

> Yannick has agreed to start looking at the objtool function diff
> feature.  It's purely theoretical at the moment, we'll see how it works
> in practice.  We already do something similar in kpatch-build -- it
> differs from the objtool model, but it at least shows that something
> similar is possible.

Great. I'm looking forward to seeing that.

Thanks
Miroslav
