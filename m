Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D69314A5C
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 09:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBIIdY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 03:33:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:49986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhBIIdU (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 03:33:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 760C3ACB7;
        Tue,  9 Feb 2021 08:32:35 +0000 (UTC)
Date:   Tue, 9 Feb 2021 09:32:34 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
In-Reply-To: <20210208111546.5e01c3fb@gandalf.local.home>
Message-ID: <alpine.LSU.2.21.2102090927230.31501@pobox.suse.cz>
References: <20210207104022.GA32127@zn.tnic>        <CAHk-=widXSyJ8W3vRrqO-zNP12A+odxg2J2_-oOUskz33wtfqA@mail.gmail.com>        <20210207175814.GF32127@zn.tnic>        <CAHk-=wi5z9S7x94SKYNj6qSHBqz+OD76GW=MDzo-KN2Fzm-V4Q@mail.gmail.com>       
 <20210207224540.ercf5657pftibyaw@treble>        <20210208100206.3b74891e@gandalf.local.home>        <20210208153300.m5skwcxxrdpo37iz@treble>        <YCFc+ewvwNWqrbY7@hirez.programming.kicks-ass.net> <20210208111546.5e01c3fb@gandalf.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 8 Feb 2021, Steven Rostedt wrote:

> On Mon, 8 Feb 2021 16:47:05 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > /*
> > >  * Convert a function address into the appropriate ftrace location.
> > >  *
> > >  * Usually this is just the address of the function, but on some architectures
> > >  * it's more complicated so allow them to provide a custom behaviour.
> > >  */
> > > #ifndef klp_get_ftrace_location
> > > static unsigned long klp_get_ftrace_location(unsigned long faddr)
> > > {
> > > 	return faddr;
> > > }
> > > #endif  

powerpc has this

static inline unsigned long klp_get_ftrace_location(unsigned long faddr)                                               
{                                                                                                                      
        /*                                                                                                             
         * Live patch works only with -mprofile-kernel on PPC. In this case,                                           
         * the ftrace location is always within the first 16 bytes.                                                    
         */                                                                                                            
        return ftrace_location_range(faddr, faddr + 16);                                                               
}                                                                                                                      

> > I suppose the trivial fix is to see if it points to endbr64 and if so,
> > increment the addr by the length of that.
> 
> I thought of that too. But one thing that may be possible, is to use
> kallsym. I believe you can get the range of a function (start and end of
> the function) from kallsyms. Then ask ftrace for the addr in that range
> (there should only be one).

And we can do this if a hard-coded value live above is not welcome. If I 
remember correctly, we used to have exactly this in the old versions of 
kGraft. We walked through all ftrace records, called 
kallsyms_lookup_size_offset() on every record's ip and if the offset+ip 
matched faddr (in this case), we returned the ip.

Miroslav
