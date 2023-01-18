Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D189B671EC4
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 15:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjARODk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 Jan 2023 09:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjARODR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 Jan 2023 09:03:17 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE3C4521D
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 05:37:54 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 913BB5BEC6;
        Wed, 18 Jan 2023 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674049073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yW3W7QaxCQSihrrcKhJ/fP6gGucI02bqwgneL+euk/Q=;
        b=zrpTLQQPTrQ5xfZlowT8ucwNeIFFtU1P0D+SYLi5cwYL4SQ3i88mptyF9Csr/LZD2nvo0Q
        yU6LVFvUxjsckUIgBZ4KmIAaVYICypIJN73KkYqAnakbhyudnQYxm1OC035A/I0V43Dj9N
        zX+BNNp9i3I+SZMX1E+VkEgnJUnGmlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674049073;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yW3W7QaxCQSihrrcKhJ/fP6gGucI02bqwgneL+euk/Q=;
        b=o0Alaq93Fd6port7nZxOiNDdn1Z6of9NIsDkoOvYcNHvqaO4BGuu7BCU9yN5fzvoh9jt9I
        NA34jkQhWr2YlLCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 68F242C141;
        Wed, 18 Jan 2023 13:37:53 +0000 (UTC)
Date:   Wed, 18 Jan 2023 14:37:57 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Song Liu <song@kernel.org>, X86 ML <x86@kernel.org>,
        live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <Y8f1g62ouKsmjwpL@alley>
Message-ID: <alpine.LSU.2.21.2301181437110.13709@pobox.suse.cz>
References: <20230106200109.2546997-1-song@kernel.org> <alpine.LSU.2.21.2301131012110.1565@pobox.suse.cz> <CAPhsuW6JKSYjfPab9k_SCtoPQMGTX2ZXkSTMnZEOCMf-yo29rg@mail.gmail.com> <Y8f1g62ouKsmjwpL@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > >
> > > > +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > > > +                          const char *shstrtab, const char *strtab,
> > > > +                          unsigned int symndx, unsigned int secndx,
> > > > +                          const char *objname)
> > > > +{
> > > > +     return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> > > > +                                     secndx, objname, true);
> > > >  }
> 
> I think that I proposed this wrapper :-)
> 
> > > Is this redirection needed somewhere? You could just replace
> > > klp_apply_section_relocs() with klp_write_section_relocs() in
> > > include/linux/livepatch.h and kernel/module/main.c.
> > >
> > > It may be cleaned up later.
> > 
> > It might be a good practice to keep _write_ static in this file, and
> > only expose _apply_ (maybe also _clear_ in the future)?
> 
> And I think that this was the reason. Also it looks better in
> kernel/module/main.c in apply_relocations() that calls few more
> *_apply_*reloc*() functions.
> 
> The idea is that functions with the same naming pattern do
> the same operation. Also it is supposed to hide the true/false
> parameter and self-explain the meaning by the function name.
> 
> 
> > I don't have a strong preference either way.
> 
> I would prefer to keep the wrapper. But I do not resist on it :-)

Ok, fair enough. Let's keep it then.

Miroslav
