Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFDE315208
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 15:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhBIOuo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 09:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhBIOuh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 09:50:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE54B64DB2;
        Tue,  9 Feb 2021 14:49:54 +0000 (UTC)
Date:   Tue, 9 Feb 2021 09:49:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
Message-ID: <20210209094953.65d2f322@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.2102090927230.31501@pobox.suse.cz>
References: <20210207104022.GA32127@zn.tnic>
        <CAHk-=widXSyJ8W3vRrqO-zNP12A+odxg2J2_-oOUskz33wtfqA@mail.gmail.com>
        <20210207175814.GF32127@zn.tnic>
        <CAHk-=wi5z9S7x94SKYNj6qSHBqz+OD76GW=MDzo-KN2Fzm-V4Q@mail.gmail.com>
        <20210207224540.ercf5657pftibyaw@treble>
        <20210208100206.3b74891e@gandalf.local.home>
        <20210208153300.m5skwcxxrdpo37iz@treble>
        <YCFc+ewvwNWqrbY7@hirez.programming.kicks-ass.net>
        <20210208111546.5e01c3fb@gandalf.local.home>
        <alpine.LSU.2.21.2102090927230.31501@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 9 Feb 2021 09:32:34 +0100 (CET)
Miroslav Benes <mbenes@suse.cz> wrote:

> powerpc has this
> 
> static inline unsigned long klp_get_ftrace_location(unsigned long faddr)                                               
> {                                                                                                                      
>         /*                                                                                                             
>          * Live patch works only with -mprofile-kernel on PPC. In this case,                                           
>          * the ftrace location is always within the first 16 bytes.                                                    
>          */                                                                                                            
>         return ftrace_location_range(faddr, faddr + 16);                                                               
> }                                                                                                                      
> 
> > > I suppose the trivial fix is to see if it points to endbr64 and if so,
> > > increment the addr by the length of that.  
> > 
> > I thought of that too. But one thing that may be possible, is to use
> > kallsym. I believe you can get the range of a function (start and end of
> > the function) from kallsyms. Then ask ftrace for the addr in that range
> > (there should only be one).  
> 
> And we can do this if a hard-coded value live above is not welcome. If I 
> remember correctly, we used to have exactly this in the old versions of 
> kGraft. We walked through all ftrace records, called 
> kallsyms_lookup_size_offset() on every record's ip and if the offset+ip 
> matched faddr (in this case), we returned the ip.

Either way is fine. Question is, should we just wait till CET is
implemented for the kernel before making any of these changes? Just knowing
that we have a solution to handle it may be good enough for now.

-- Steve
