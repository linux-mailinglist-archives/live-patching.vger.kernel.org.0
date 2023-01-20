Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB30675EF1
	for <lists+live-patching@lfdr.de>; Fri, 20 Jan 2023 21:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjATUdB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 20 Jan 2023 15:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjATUdB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 20 Jan 2023 15:33:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967EB8A0F8;
        Fri, 20 Jan 2023 12:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BF08B82A59;
        Fri, 20 Jan 2023 20:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEABC433D2;
        Fri, 20 Jan 2023 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674246775;
        bh=Mpd3ggMAesKvNDM2J5TjcadboGsqRMW6xSnwxTQzs9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/2YTssoLBjjzLSBf54MtKOiJn2xOGzgzBiDMuZYAA+cYBNvfT2kZfrIwQk+makKA
         DBiADCIkkzpVrrbTdTON2aMMIHNjVvji6xB4w4j0vcNqrscNqhRC+a7rV1323TLN3O
         jY7YwMuK25eZrsJv2k9kmZeC9o/pfJRNa0X4c3D0OfOL0MHzWfIS6OV6/7m9D/6iCS
         E8PlUu/ztkOjzpjBAD9d7y8EbKMQtvjxwuxDiaSi8Cit+6y9XAfMAe2mbI9eox5dgv
         QR4zjGRMd0RZ3roPzIXG3k99ph4S45ZAUwMqHYvO9QV8GQ65ObE9rI0LC5jPTiF1mh
         jZPrE6AzyXK0w==
Date:   Fri, 20 Jan 2023 12:32:53 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20230120203253.5r7dkge6x4vsx5ov@treble>
References: <20230118204728.1876249-1-song@kernel.org>
 <20230120191642.7bmqt6t4qngisqep@treble>
 <CAPhsuW436=wRKLixWNtE9Rx=6A0gKrOCR8EUOdwTrPw5W6gddg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW436=wRKLixWNtE9Rx=6A0gKrOCR8EUOdwTrPw5W6gddg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 20, 2023 at 11:41:02AM -0800, Song Liu wrote:
> > >   The livepatch module has a relocation which references a symbol
> > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > >   tries to replace the old relocation with a new one, it sees that
> > >   the previous one is nonzero and it errors out.
> >
> > Should we add a selftest to make sure this problem doesn't come back?
> 
> IIRC, a selftest for this issue is not easy without Joe's klp-convert work.
> At the moment I use kpatch-build for testing.

Ah right, I remember that now.

> How about:
> 
> Signed-off-by: Song Liu <song@kernel.org>
> Originally-by: Miroslav Benes <mbenes@suse.cz>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>

Yes, but the ordering looks off, I think it should be more like:

Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
Originally-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Miroslav Benes <mbenes@suse.cz>

And then make sure 'From:' is you.

BTW, this patch affects both livepatch and x86, so the subject prefix
should have "x86" added, something like:

  livepatch,x86: Clear relocations on module removal

> > This code really needs to be removed anyway, it's been dead for at least
> > 15 years.
> 
> Shall we remove it now? Within the same patch? Or with a preparation
> patch?
> 

A preparatory patch sounds good.

> > > +                                    (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> > > +                             return -ENOEXEC;
> > > +                     }
> > > +                     write(loc, &val, write_size);
> > > +             } else {
> > > +                     if (memcmp(loc, &val, write_size)) {
> > > +                             pr_warn("x86/modules: Clearing invalid relocation target, existing value does not match expected value for type %d, loc %p, val %Lx\n",
> > > +                                     (int)ELF64_R_TYPE(rel[i].r_info), loc, val);
> > > +                     }
> > > +                     write(loc, &zero, write_size);
> >
> > If the value doesn't match then something has gone badly wrong.  Why go
> > ahead with the clearing in that case?
> 
> We can pr_err() then return -ENOEXEC (?). But I guess we need to
> handle the error case in:
>   klp_cleanup_module_patches_limited()
>   klp_module_coming()
>   klp_module_going()
> and all the functions that call klp_module_going().
> 
> This seems a big overkill to me...
> 
> Or do you mean we just skip the write()?

At the very least, skip the write.

But I really think it should just break out of the loop and return an
error, there's no point in trying to continue clearing the rest of the
relocations if one of them failed.

It's probably fine for the callers to ignore the error, the module's
going to get unloaded regardless.

-- 
Josh
