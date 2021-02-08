Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F3313912
	for <lists+live-patching@lfdr.de>; Mon,  8 Feb 2021 17:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhBHQQy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Feb 2021 11:16:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234206AbhBHQQl (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Feb 2021 11:16:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87DC464E82;
        Mon,  8 Feb 2021 16:15:48 +0000 (UTC)
Date:   Mon, 8 Feb 2021 11:15:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
Message-ID: <20210208111546.5e01c3fb@gandalf.local.home>
In-Reply-To: <YCFc+ewvwNWqrbY7@hirez.programming.kicks-ass.net>
References: <20210207104022.GA32127@zn.tnic>
        <CAHk-=widXSyJ8W3vRrqO-zNP12A+odxg2J2_-oOUskz33wtfqA@mail.gmail.com>
        <20210207175814.GF32127@zn.tnic>
        <CAHk-=wi5z9S7x94SKYNj6qSHBqz+OD76GW=MDzo-KN2Fzm-V4Q@mail.gmail.com>
        <20210207224540.ercf5657pftibyaw@treble>
        <20210208100206.3b74891e@gandalf.local.home>
        <20210208153300.m5skwcxxrdpo37iz@treble>
        <YCFc+ewvwNWqrbY7@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 8 Feb 2021 16:47:05 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> > /*
> >  * Convert a function address into the appropriate ftrace location.
> >  *
> >  * Usually this is just the address of the function, but on some architectures
> >  * it's more complicated so allow them to provide a custom behaviour.
> >  */
> > #ifndef klp_get_ftrace_location
> > static unsigned long klp_get_ftrace_location(unsigned long faddr)
> > {
> > 	return faddr;
> > }
> > #endif  
> 
> I suppose the trivial fix is to see if it points to endbr64 and if so,
> increment the addr by the length of that.

I thought of that too. But one thing that may be possible, is to use
kallsym. I believe you can get the range of a function (start and end of
the function) from kallsyms. Then ask ftrace for the addr in that range
(there should only be one).

-- Steve
