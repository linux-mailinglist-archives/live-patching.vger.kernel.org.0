Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BB4313873
	for <lists+live-patching@lfdr.de>; Mon,  8 Feb 2021 16:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhBHPsq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Feb 2021 10:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhBHPsM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Feb 2021 10:48:12 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49755C061788;
        Mon,  8 Feb 2021 07:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CrSWaJykWlogrwjWXAgw3unW07UIgYkSvgAmm3gGDH0=; b=RhG6xnkOd/2Vxhd/Q+09zua+6e
        YEnensgIq8t1el+30dhU+4Y0TSno4WV+jLwMP4bunKsgofSNZmE3i0zbClw0O9LA4vR+0ig6sfHnv
        /RMiLWxkne1snwBStxkRX7HWqrIf/RM/6rBjyuWov3N4WiVBgrINN0D03FHC92CduF4y/aur8oB+G
        1KaofsniSF/rIwTcOwvAaz1sqSF4m3cRIpzVVoDCqSoR4DN8ZJpuMS06rlPwH+54IDXQbyvtrUbsK
        RhmPPvFaNjh1OoqzFtzJKx76/eskTc5Ksi0pOVLLmMC7mC/ZRmEmEYPhUGVobP0rwm9awg9xKZz6f
        5yr8l9qg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l98ko-0004QF-8r; Mon, 08 Feb 2021 15:47:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26A163012DF;
        Mon,  8 Feb 2021 16:47:06 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E28C92BD561CD; Mon,  8 Feb 2021 16:47:05 +0100 (CET)
Date:   Mon, 8 Feb 2021 16:47:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
Message-ID: <YCFc+ewvwNWqrbY7@hirez.programming.kicks-ass.net>
References: <20210207104022.GA32127@zn.tnic>
 <CAHk-=widXSyJ8W3vRrqO-zNP12A+odxg2J2_-oOUskz33wtfqA@mail.gmail.com>
 <20210207175814.GF32127@zn.tnic>
 <CAHk-=wi5z9S7x94SKYNj6qSHBqz+OD76GW=MDzo-KN2Fzm-V4Q@mail.gmail.com>
 <20210207224540.ercf5657pftibyaw@treble>
 <20210208100206.3b74891e@gandalf.local.home>
 <20210208153300.m5skwcxxrdpo37iz@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208153300.m5skwcxxrdpo37iz@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Feb 08, 2021 at 09:33:00AM -0600, Josh Poimboeuf wrote:
> On Mon, Feb 08, 2021 at 10:02:06AM -0500, Steven Rostedt wrote:
> > On Sun, 7 Feb 2021 16:45:40 -0600
> > Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > > > I do suspect involved people should start thinking about how they want
> > > > to deal with functions starting with
> > > > 
> > > >         endbr64
> > > >         call __fentry__
> > > > 
> > > > instead of the call being at the very top of the function.  
> > > 
> > > FWIW, objtool's already fine with it (otherwise we would have discovered
> > > the need to disable fcf-protection much sooner).
> > 
> > And this doesn't really affect tracing (note, another user that might be
> > affected is live kernel patching).
> 
> Good point, livepatch is indeed affected.  Is there a better way to get
> the "call __fentry__" address for a given function?
> 
> 
> /*
>  * Convert a function address into the appropriate ftrace location.
>  *
>  * Usually this is just the address of the function, but on some architectures
>  * it's more complicated so allow them to provide a custom behaviour.
>  */
> #ifndef klp_get_ftrace_location
> static unsigned long klp_get_ftrace_location(unsigned long faddr)
> {
> 	return faddr;
> }
> #endif

I suppose the trivial fix is to see if it points to endbr64 and if so,
increment the addr by the length of that.
