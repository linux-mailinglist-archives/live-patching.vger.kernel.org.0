Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F816DB717
	for <lists+live-patching@lfdr.de>; Sat,  8 Apr 2023 01:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDGXVY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Apr 2023 19:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDGXVX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Apr 2023 19:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF3B7ED0;
        Fri,  7 Apr 2023 16:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB36564A2C;
        Fri,  7 Apr 2023 23:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92007C433EF;
        Fri,  7 Apr 2023 23:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680909681;
        bh=GR8ZHhZhrWLr8Jm6fEQrZIKxqS1sTyT0Tzdp4I7epEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEwtIYaw7cjDKNLJtyxb1V9S9w87KlRmoLbJbhzd4IPYOed2hd2iLyrfoRJ04cRUy
         q3Q1xDiGjPyThljSwASVEoEVXPX9HtejY+xkJqWPc8sDGAz0A/JcaQ2rRtJtEguYmF
         ACvFFegwTDPN9APkiMH8vPTOwhF2Q+j7YjGwbTWW484mjBAnu3Kjh8SzmKID8FaIyb
         GfBUL99QphgLyOUe6Ed6j39SLR3FX1pdhlm/GiPrb69vfNwwfj6AJQDQQvWS+qusAM
         QCYBbUVHQvwAFcZnqi8M2RSNZ2qv8RH/IMCqSDg0vxA5qdDdDWM5Mxld4hHRYsbxXp
         vat39tzq4gaJw==
Date:   Fri, 7 Apr 2023 16:21:18 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     mcgrof@kernel.org, masahiroy@kernel.org,
        linux-modules@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH modules-next v10 00/13] kallsyms: reliable
 symbol->address lookup with /proc/kallmodsyms
Message-ID: <20230407232118.o2x5lakfgyzy56gz@treble>
References: <20221205163157.269335-1-nick.alcock@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221205163157.269335-1-nick.alcock@oracle.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Dec 05, 2022 at 04:31:44PM +0000, Nick Alcock wrote:
> The whole point of symbols is that their names are unique: you can look up a
> symbol and get back a unique address, and vice versa.  Alas, because
> /proc/kallsyms (rightly) reports all symbols, even hidden ones, it does not
> really satisfy this requirement.  Large numbers of symbols are duplicated
> many times (just search for __list_del_entry!), and while usually these are
> just out-of-lined things defined in header files and thus all have the same
> implementation, it does make it needlessly hard to figure out which one is
> which in stack dumps, when tracing, and such things.  Some configuration
> options make things much worse: my test make allyesconfig runs introduced
> thousands of text symbols named _sub_I_65535_1, one per compiler-generated
> object file, and it was fairly easy to make them appear in ftrace output.
> 
> Right now the kernel has no way at all to tell such symbols apart, and nor
> has the user: their address differs and that's all.  Which module did they
> come from?  Which object file?  We don't know.  Figuring out which is which
> when tracing needs a combination of guesswork and luck, and if there are
> thousands of them that's not a pleasant prospect.  In discussions at LPC it
> became clear that this is not just annoying me but Steve Rostedt and others,
> so it's probably desirable to fix this.
> 
> It turns out that the linker, and the kernel build system, can be made to
> give us everything we need to resolve this once and for all.  This series
> provides a new /proc/kallmodsyms which is like /proc/kallsyms except that it
> annotates every (textual) symbol which comes from a built-in kernel module
> with the module's name, in square brackets: if a symbol is used by multiple
> modules, it gets [multiple] [names]; if a symbol is still ambiguous it gets
> a cut-down {object file name}; the combination of symbol, [module] [names]
> and {object file name} is unique (with one minor exception: the arm64 nvhe
> module is pre-linked with ld -r, causing all symbols in it to appear to come
> from the same object file: if it was reworked to use thin archives this
> problem would go away).

Hi Nick,

Sorry for jumping in late on an old patch set.  I just saw the LWN
article about the MODULE_LICENSE() patches and I have some comments
about duplicate symbols and a question about the motivation for this
patch set.

For livepatch we have a solution for disambiguating duplicate local
symbols called "sympos".  It works (for now) but there are some cases
(like LTO) where it falls apart and it may not be the best long term
solution.

The function granularity KASLR (fgkaslr) patches proposed a potentially
better option: use the GNU linker -zunique_symbols flag which renames
all duplicates to have unique names across the entire linked object.

There are other components which also struggle with duplicate symbols:
ftrace, kprobes, BPF, etc.  It would be good to come up with a kallsyms
solution that works for everybody.

Anyway, I was nodding along with the above cover letter until I got to
the third paragraph.

A "built-in kernel module" is not actually a module, as it's built in to
vmlinux.  I suspect the point is that if you rebuild with a different
config, it might become a module.  But many other changes could also
occur with a changed config, including changed inlining decisions and
GCC IPA optimization function renaming, in which case the symbol might
no longer exist with the new config.

Also I'm confused what it means for a symbol to be "used by multiple
modules".  If the same TU or inline symbol is linked into two modules,
it will be loaded twice at two different addresses, and the
implementations could even differ.

It sounds like there are two problems being conflated:

  1) how to uniquely identify symbols in the current kernel

     For this, all we really need is file+sym.

     Or, enable -zunique-symbols in the linker.

  2) how to uniquely identify symbols across multiple kernels/configs

     This seems much trickier, as much can change across kernels and
     configs, including compiler inlining and naming decisions, not to
     mention actual code changes.

The problems are related, but distinct.

#2 seems significantly harder to implement properly.

Would solving #1 give you most of what you need?

Based on the difficulty of #2, it really needs a proper justification.
I didn't see that in either of the patch sets.

Can you share more details about what specific problem needs solved and
why?  And how this would be used?  Examples would be helpful.

The article linked to this brief explanation [1], but that doesn't
clarify why "distinct notation used by users for things in named
modules" would be important.

Is there a reason the user can't just use whatever notation is
appropriate for their specific kernel?  Or, once we have #1, couldn't
tooling do an intermediate translation?

[1] https://lwn.net/ml/linux-kernel/87h6z5wqlk.fsf@esperi.org.uk/

-- 
Josh
