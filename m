Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A46C67A00D
	for <lists+live-patching@lfdr.de>; Tue, 24 Jan 2023 18:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjAXRXY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 12:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbjAXRXX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 12:23:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED04402FD;
        Tue, 24 Jan 2023 09:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 667B4B81606;
        Tue, 24 Jan 2023 17:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1EEC433D2;
        Tue, 24 Jan 2023 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674580995;
        bh=CwhLGT4zPksCsBdo0pja2APkkSpmb/azhcS8qSQ8vdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mgZ64qwjYOgIyo091c6otHRso9I0WRRCRaZYano/+2BgYp9hSi2I5EQ0mKaZLW9wm
         KsTN2WKLW8bTf/hx+ETOD9EEHLX4MpDdMcX7TPnBBjnHcddDBlXKsWDGaAeeMDYQM3
         hEifjrjMXQyRtsbis3Mohq004Vt9vyvntuFWWh79t5xZ8fWV5QXyqT3bZk8fuXx0xR
         GFQwO9TtkdTwVLlNCE5DlZJTqSDNcs9gzbCQlGMRp1JaZvZt/0bQRVz7gs+KZaWQxc
         rw6kaBiW98asAaNiYd7/9xl8aSzZ2+VeevGllrglHOE+X4gdCN/tqjaUrUNrWpVb7l
         kOWPuvdO1wcAA==
Date:   Tue, 24 Jan 2023 09:23:13 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v10 2/2] livepatch,x86: Clear relocation targets on a
 module removal
Message-ID: <20230124172313.extovg6ig7dimpgb@treble>
References: <20230121004945.697003-1-song@kernel.org>
 <20230121004945.697003-2-song@kernel.org>
 <Y8/N7zMLUnMh259N@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8/N7zMLUnMh259N@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 24, 2023 at 01:24:15PM +0100, Petr Mladek wrote:
> On Fri 2023-01-20 16:49:45, Song Liu wrote:
> > Josh reported a bug:
> > 
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> > 
> >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > 
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> > 
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> > 
> > We could also deny the patched modules to be removed. If it proved to be
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> > 
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> > 
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Originally-by: Miroslav Benes <mbenes@suse.cz>
> > Signed-off-by: Song Liu <song@kernel.org>
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > 
> > --- a/arch/x86/kernel/module.c
> > +++ b/arch/x86/kernel/module.c
> > @@ -129,22 +129,27 @@ int apply_relocate(Elf32_Shdr *sechdrs,
> >  	return 0;
> >  }
> >  #else /*X86_64*/
> > -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> > +static int __write_relocate_add(Elf64_Shdr *sechdrs,
> >  		   const char *strtab,
> >  		   unsigned int symindex,
> >  		   unsigned int relsec,
> >  		   struct module *me,
> > -		   void *(*write)(void *dest, const void *src, size_t len))
> > +		   void *(*write)(void *dest, const void *src, size_t len),
> > +		   bool apply)
> >  {
> >  	unsigned int i;
> >  	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
> >  	Elf64_Sym *sym;
> >  	void *loc;
> >  	u64 val;
> > +	u64 zero = 0ULL;
> >  
> > -	DEBUGP("Applying relocate section %u to %u\n",
> > +	DEBUGP("%s relocate section %u to %u\n",
> > +	       apply ? "Applying" : "Clearing",
> >  	       relsec, sechdrs[relsec].sh_info);
> >  	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
> > +		int size = 0;
> 
> The value 0 should never be used. It is better to do not initialize
> it at all so that the compiler would warn when the variable might be
> used uninitialized.

Yes.  Also it can be unsigned, i.e. size_t.

-- 
Josh
