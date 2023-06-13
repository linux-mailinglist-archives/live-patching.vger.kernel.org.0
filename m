Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635EC72E6DE
	for <lists+live-patching@lfdr.de>; Tue, 13 Jun 2023 17:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbjFMPQe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Jun 2023 11:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240551AbjFMPQe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Jun 2023 11:16:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B0ECA
        for <live-patching@vger.kernel.org>; Tue, 13 Jun 2023 08:16:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 497F3224FA;
        Tue, 13 Jun 2023 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686669391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j5hjKhnwAC1+z4xgNDna7CgCF8Gb/bvtIofKj1U84eQ=;
        b=sH6Qsg3qjdQqUx3OgOifq+OdCCIK9VplMDqrjSWVMBmhvI5xrAjyH86uWR76LCg5wUFJEa
        ctsQtSKQghU71cNWCiRmsuyOMPsZBTPkl2jv5USJSq+BJUoZndpuw6tGVy89EPZuxw69j6
        /WG8m2nIlBdEPRpfnZOoJsQeqk5BzW8=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DB8AA2C141;
        Tue, 13 Jun 2023 15:16:30 +0000 (UTC)
Date:   Tue, 13 Jun 2023 17:16:30 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <songliubraving@meta.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH] livepatch: match symbols exactly in
 klp_find_object_symbol()
Message-ID: <ZIiITvTMOimZ-t1z@alley>
References: <20230602232401.3938285-1-song@kernel.org>
 <ZILQERU8CJQvn9ix@alley>
 <A4BB490E-42EE-4435-AAE7-2309E384C934@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A4BB490E-42EE-4435-AAE7-2309E384C934@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-06-09 16:35:16, Song Liu wrote:
> 
> 
> > On Jun 9, 2023, at 12:09 AM, Petr Mladek <pmladek@suse.com> wrote:
> > 
> > On Fri 2023-06-02 16:24:01, Song Liu wrote:
> >> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
> >> suffixes during comparison. This is problematic for livepatch, as
> >> kallsyms_on_each_match_symbol may find multiple matches for the same
> >> symbol, and fail with:
> >> 
> >>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> >> 
> >> Fix this by using kallsyms_on_each_symbol instead, and matching symbols
> >> exactly.
> >> 
> >> --- a/kernel/livepatch/core.c
> >> +++ b/kernel/livepatch/core.c
> >> @@ -166,7 +159,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
> >> if (objname)
> >> module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
> >> else
> >> - kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
> >> + kallsyms_on_each_symbol(klp_find_callback, &args);
> > 
> > AFAIK, you have put a lot of effort to optimize the search recently.
> > The speedup was amazing, see commit 4dc533e0f2c04174e1ae
> > ("kallsyms: Add helper kallsyms_on_each_match_symbol()").
> > 
> 
> That's not me. :) Or maybe you meant Josh?

Ah, I see. I am sorry, I am bad at names.

> > Do we really need to waste this effort completely?
> > 
> > What about creating variants:
> > 
> >  + kallsyms_on_each_match_exact_symbol()
> >    + kallsyms_lookup_exact_names()
> >      + compare_exact_symbol_name()
> > 
> > Where compare_exact_symbol_name() would not try comparing with
> > cleanup_symbol_name()?
> 
> The rationale is that livepatch symbol look up is not a hot path,
> and the changes (especially with kallsyms_lookup_exact_names) seem 
> an overkill.

I agree that it is a slow path.

Well, Zhen put a lot of effort into the optimization. I am not sure
what was the primary motivation. But it would be harsh to remove it
without asking.

Zhen, what was the motivation for the speedup of kallsyms, please?


> OTOH, this version is simpler and should work just as
> well.

Sure. But we should double check Zhen's motivation.

Anyway, iterating over all symbols costs a lot. See also
the commit f5bdb34bf0c9314548f2d ("livepatch: Avoid CPU hogging
with cond_resched").

Best Regards,
Petr
