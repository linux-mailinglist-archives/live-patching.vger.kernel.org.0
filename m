Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99F2660439
	for <lists+live-patching@lfdr.de>; Fri,  6 Jan 2023 17:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjAFQ0q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Jan 2023 11:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbjAFQ0o (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Jan 2023 11:26:44 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9302AFA
        for <live-patching@vger.kernel.org>; Fri,  6 Jan 2023 08:26:41 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 40BB1270E2;
        Fri,  6 Jan 2023 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673022399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=njMxukJQlcbOakHFjG1kqLQCjRXVD5xldiJUzPjGk4U=;
        b=koaAEX5nwyabPmIWOWlMpVmQwsg0Z5GI44gnZeX2m24KlD8E5a17m99qp6R4qInheiM/gg
        AJatzo9Ei5tYnBlF89soiLynsJHffAaPyXhqZUGQzwpZXMEPepnMGRJYpS8Q648sIvrzD2
        PzDuuX5Rd4t/ohxuc3TY41nTzABOXZo=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 181AF2C142;
        Fri,  6 Jan 2023 16:26:39 +0000 (UTC)
Date:   Fri, 6 Jan 2023 17:26:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
        live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y7hLvpHqgY0oJ4GY@alley>
References: <20221214174035.1012183-1-song@kernel.org>
 <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
 <Y7YH7SwveCyNPxWC@redhat.com>
 <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
 <bf670f87-e2a1-ff42-a88f-70eab78b4cd1@redhat.com>
 <alpine.LSU.2.21.2301061352050.6386@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2301061352050.6386@pobox.suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-01-06 14:02:27, Miroslav Benes wrote:
> Hi
> 
> On Thu, 5 Jan 2023, Joe Lawrence wrote:
> 
> > On 1/5/23 00:59, Song Liu wrote:
> > > On Wed, Jan 4, 2023 at 3:12 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > >>
> > >>
> > >> Stepping back, this feature is definitely foot-gun capable.
> > >> Kpatch-build would expect that klp-relocations would only ever be needed
> > >> in code that will patch the very same module that provides the
> > >> relocation destination -- that is, it was never intended to reference
> > >> through one of these klp-relocations unless it resolved to a live
> > >> module.
> > >>
> > >> On the other hand, when writing the selftests, verifying against NULL
> > >> [1] provided 1) a quick sanity check that something was "cleared" and 2)
> > >> protected the machine against said foot-gun.
> > >>
> > >> [1] https://github.com/joe-lawrence/klp-convert-tree/commit/643acbb8f4c0240030b45b64a542d126370d3e6c
> > > 
> > > I don't quite follow the foot-gun here. What's the failure mode?
> > > 
> > 
> > Kpatch-build, for better or worse, hides the potential problem.  A
> > typical kpatch scenario would be:
> > 
> > 1. A patch modifies module foo's function bar(), which references
> > symbols local to module foo
> > 
> > 2. Kpatch-build creates a livepatch .ko with klp-relocations in the
> > modified bar() to foo's symbols
> > 
> > 3. When loaded, modified bar() code that references through its
> > klp-relocations to module foo will only ever be active when foo is
> > loaded, i.e. when the original bar() redirects to the livepatch version.
> > 
> > However, writing source-based livepatches (like the kselftests) offers a
> > lot more freedom.  There is no implicit guarantee from (3) that the
> > module is loaded.  One could reference klp-relocations from anywhere in
> > the livepatch module.
> 
> Yes, on the other hand the approach you describe above seems to be the 
> only reasonable one in my opinion. The rest might be considered a bug. 
> Foot-gun as you say. I am not sure if we can do anything about it.

I agree that using an address from a module when the module is not
loaded is a bug. The kernel might still crash even when we clear
the addresses. But at least it can't be used to read information
from an "arbitrary" address.

It means that clearing the relocations is nice to have.

BTW: I originally understood the "foot-gun" in a more generic way.
     Modyfying "elf" sections feels like a surgery. As such, it has
     to be done carefully.

> > > [...]
> > > 
> > >>> These approaches don't look better to me. But I am ok
> > >>> with any of them. Please just let me know which one is
> > >>> most preferable:
> > >>>
> > >>> a. current version;
> > >>> b. clear_ undo everything of apply_ (the sample code
> > >>>    above)
> > >>> c. clear_ undo R_PPC_REL24, but _redo_ everything
> > >>>    of apply_ for other ELF64_R_TYPEs. (should be
> > >>>   clearer code than option b).
> > >>>
> > >>
> > >> This was my attempt at combining and slightly refactoring the power64
> > >> version.  There is so much going on here I was tempted to split off it
> > >> into separate value assignment and write functions.  Some changes I
> > >> liked, but I wasn't all too happy with the result.  Also, as you
> > >> mention, completely undoing R_PPC_REL24 is less than trivial... for this
> > >> arch, there are basically three major tasks:
> > >>
> > >>   1) calculate the new value, including range checking
> > >>   2) special constructs created by restore_r2 / create_stub
> > >>   3) writing out the value
> > >>
> > >> and many cases are similar, but subtly different enough to avoid easy
> > >> code consolidation.
> > > 
> > > Thanks for exploring this direction. I guess this part won't be perfect
> > > anyway.
> > > 
> > > PS: While we discuss a solution for ppc64, how about we ship the
> > > fix for other archs first? I think there are only a few small things to
> > > be addressed.
> > > 
> > 
> > Yeah, the x86_64 version looks a lot simpler and closer to being done.
> > Though I believe that Petr would prefer a complete solution, but I'll
> > let him speak to that.
> 
> I cannot speak for Petr, but I think it might be easier to split it given 
> the situation. Then we can involve arch maintainers for ppc64le because 
> they might have a preference with respect to a, b, c options above.
> 
> Petr, what do you think?

I am fine with solving each architecture in a separate patch or
patchset. It would make it easier, especially, for arch maintainers.

Best Regards,
Petr
