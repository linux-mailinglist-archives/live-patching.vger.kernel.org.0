Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A323145447
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 13:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgAVMPz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 07:15:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:33218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgAVMPx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 07:15:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 550A8B259;
        Wed, 22 Jan 2020 12:15:51 +0000 (UTC)
Date:   Wed, 22 Jan 2020 13:15:49 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20200121161045.dhihqibnpyrk2lsu@treble>
Message-ID: <alpine.LSU.2.21.2001221312030.15957@pobox.suse.cz>
References: <20191015135634.GK2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home> <20191016074217.GL2328@hirez.programming.kicks-ass.net> <20191021150549.bitgqifqk2tbd3aj@treble> <20200120165039.6hohicj5o52gdghu@treble> <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 21 Jan 2020, Josh Poimboeuf wrote:

> On Tue, Jan 21, 2020 at 09:35:28AM +0100, Miroslav Benes wrote:
> > On Mon, 20 Jan 2020, Josh Poimboeuf wrote:
> > 
> > > On Mon, Oct 21, 2019 at 10:05:49AM -0500, Josh Poimboeuf wrote:
> > > > On Wed, Oct 16, 2019 at 09:42:17AM +0200, Peter Zijlstra wrote:
> > > > > > which are not compatible with livepatching. GCC upstream now has
> > > > > > -flive-patching option, which disables all those interfering optimizations.
> > > > > 
> > > > > Which, IIRC, has a significant performance impact and should thus really
> > > > > not be used...
> > > > > 
> > > > > If distros ship that crap, I'm going to laugh at them the next time they
> > > > > want a single digit performance improvement because *important*.
> > > > 
> > > > I have a crazy plan to try to use objtool to detect function changes at
> > > > a binary level, which would hopefully allow us to drop this flag.
> > > > 
> > > > But regardless, I wonder if we enabled this flag prematurely.  We still
> > > > don't have a reasonable way to use it for creating source-based live
> > > > patches upstream, and it should really be optional for CONFIG_LIVEPATCH,
> > > > since kpatch-build doesn't need it.
> > > 
> > > I also just discovered that -flive-patching is responsible for all those
> > > "unreachable instruction" objtool warnings which Randy has been
> > > dutifully bugging me about over the last several months.  For some
> > > reason it subtly breaks GCC implicit noreturn detection for local
> > > functions.
> > 
> > Ugh, that is unfortunate. Have you reported it?
> 
> Not yet (but I plan to).

My findings so far...

I bisected through GCC options which -flive-patching disables and 
-fno-ipa-pure-const is the culprit. I got no warnings without the option 
with my config.

Then I found out allmodconfig was ok even with -flive-patching. 
CONFIG_GCOV is the difference. CONFIG_GCOV=y seems to make the warnings go 
away here.

/me goes staring
