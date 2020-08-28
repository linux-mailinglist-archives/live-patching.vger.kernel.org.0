Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBDA25587C
	for <lists+live-patching@lfdr.de>; Fri, 28 Aug 2020 12:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgH1KWl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Aug 2020 06:22:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:55376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgH1KVQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Aug 2020 06:21:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C40A7B071;
        Fri, 28 Aug 2020 10:21:46 +0000 (UTC)
Date:   Fri, 28 Aug 2020 12:21:13 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>,
        joe.lawrence@redhat.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
In-Reply-To: <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2008281216031.29208@pobox.suse.cz>
References: <20200717170008.5949-1-kristen@linux.intel.com>  <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>  <202007220738.72F26D2480@keescook> <20200722160730.cfhcj4eisglnzolr@treble>  <202007221241.EBC2215A@keescook> 
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>  <20200722213313.aetl3h5rkub6ktmw@treble> <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Leaving Josh's proposals here for reference...

> > I'm not sure how LTO does it, but a few more (half-brained) ideas
> > that
> > could work:
> > 
> > 1) Add a field in kallsyms to keep track of a symbol's original
> > offset
> >    before randomization/re-sorting.  Livepatch could use that field
> > to
> >    determine the original sympos.
> > 
> > 2) In fgkaslr code, go through all the sections and mark the ones
> > which
> >    have duplicates (i.e. same name).  Then when shuffling the
> > sections,
> >    skip a shuffle if it involves a duplicate section.  That way all
> > the
> >    duplicates would retain their original sympos.
> > 
> > 3) Livepatch could uniquely identify symbols by some feature other
> > than
> >    sympos.  For example:
> > 
> >    Symbol/function size - obviously this would only work if
> > duplicately
> >    named symbols have different sizes.
> > 
> >    Checksum - as part of a separate feature we're also looking at
> > giving
> >    each function its own checksum, calculated based on its
> > instruction
> >    opcodes.  Though calculating checksums at runtime could be
> >    complicated by IP-relative addressing.
> > 
> > I'm thinking #1 or #2 wouldn't be too bad.  #3 might be harder.
> > 
> 
> Hi there! I was trying to find a super easy way to address this, so I
> thought the best thing would be if there were a compiler or linker
> switch to just eliminate any duplicate symbols at compile time for
> vmlinux. I filed this question on the binutils bugzilla looking to see
> if there were existing flags that might do this, but H.J. Lu went ahead
> and created a new one "-z unique", that seems to do what we would need
> it to do. 
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> 
> When I use this option, it renames any duplicate symbols with an
> extension - for example duplicatefunc.1 or duplicatefunc.2. You could
> either match on the full unique name of the specific binary you are
> trying to patch, or you match the base name and use the extension to
> determine original position. Do you think this solution would work?

Yes, I think so (thanks, Joe, for testing!).

It looks cleaner to me than the options above, but it may just be a matter 
of taste. Anyway, I'd go with full name matching, because -z unique-symbol 
would allow us to remove sympos altogether, which is appealing.

> If
> so, I can modify livepatch to refuse to patch on duplicated symbols if
> CONFIG_FG_KASLR and when this option is merged into the tool chain I
> can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
> should work in all cases. 

Ok.

Josh, Petr, would this work for you too?

Thanks
Miroslav

