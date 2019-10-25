Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5CE45FB
	for <lists+live-patching@lfdr.de>; Fri, 25 Oct 2019 10:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408392AbfJYInN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Oct 2019 04:43:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408361AbfJYInN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Oct 2019 04:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/9XjHHhi9cmHqBCDafIhrq5RljTOrxtN4eiY5hNBvRw=; b=D8BWFPd3KhZg5ubJIgIjUHoO6
        7lbcZxfhDOuR8J8Ne1ba5PEghIoeC8Bq3rNF+b+jNOirqQx2WARbWho8w7sy+gPTIO+p5snNBPLh9
        +ASQb/C6jqvqsZzs1Vaf0bB7xzqbUxwTiPH24ze2HDrSN4+0xSLcdzX1H/opAcBt6Z9Sf9/5R7p3b
        dmNYaMTXq4uPTT6mgRHd4LrLoPiYFjkY8sSt4WP4jWDyu1pTITquH/+Ch/uFABr0QuVlJqtPxAROB
        arFPZQIfT1JXQAyhJ+TW+DYMM14fPcwZ+N7fE4ClKRf0rHBrPxntz089yDd5Q2DbE0u0PWgQhqBFT
        Z+bgFkw/w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNvBW-0004YE-JM; Fri, 25 Oct 2019 08:43:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 91DF9303DA1;
        Fri, 25 Oct 2019 10:42:01 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 64768201A660C; Fri, 25 Oct 2019 10:43:00 +0200 (CEST)
Date:   Fri, 25 Oct 2019 10:43:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191025084300.GG4131@hirez.programming.kicks-ass.net>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 08:44:56AM +0200, Petr Mladek wrote:
> On Thu 2019-10-24 15:16:34, Peter Zijlstra wrote:
> > On Wed, Oct 23, 2019 at 12:00:25PM -0500, Josh Poimboeuf wrote:
> > 
> > > > This then raises a number of questions:
> > > > 
> > > >  1) why is that RELA (that obviously does not depend on any module)
> > > >     applied so late?
> > > 
> > > Good question.  The 'pv_ops' symbol is exported by the core kernel, so I
> > > can't see any reason why we'd need to apply that rela late.  In theory,
> > > kpatch-build isn't supposed to convert that to a klp rela.  Maybe
> > > something went wrong in the patch creation code.
> > > 
> > > I'm also questioning why we even need to apply the parainstructions
> > > section late.  Maybe we can remove that apply_paravirt() call
> > > altogether, along with .klp.arch.parainstruction sections.
> 
> Hmm, the original bug report against livepatching was actually about
> paravirt ops, see below.

Yes, I found that.

> > > I'm not sure about alternatives, but maybe we can enforce such
> > > limitations with tooling and/or kernel checks.
> > 
> > Right, so on IRC you implied you might have some additional details on
> > how alternatives were affected; did you manage to dig that up?
> 
> I am not sure what Josh had in mind. But the problem with livepatches,
> paravort ops, and alternatives was described in the related patchset, see
> https://lkml.kernel.org/r/1471481911-5003-1-git-send-email-jeyu@redhat.com

Yes, and my complaint there is that that thread is void of useful
content.

> The original bug report is
> https://lkml.kernel.org/r/20160329120518.GA21252@canonical.com

I found the github (*groan*) link in the thread above.

From all that I could only make that the paravirt stuff is just doing it
wrong (see earlier emails, core-kernel RELAs really should be applied at
the time of patch-module load, there's no excuse for them to be delayed
to the .klp.rela. section) at which point paravirt will also magically
work.

But none of that explains why apply_alternatives() is also delayed.

So I'm very tempted to just revert that patchset for doing it all
wrong.
