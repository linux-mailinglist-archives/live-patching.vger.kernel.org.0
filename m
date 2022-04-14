Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EEE500A00
	for <lists+live-patching@lfdr.de>; Thu, 14 Apr 2022 11:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241862AbiDNJiJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Apr 2022 05:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241846AbiDNJiI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Apr 2022 05:38:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245FB21833;
        Thu, 14 Apr 2022 02:35:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CEAB221618;
        Thu, 14 Apr 2022 09:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649928942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qDVaL2jPaWpmlSthq0L6C2U2xFcML4OEXNxlcThRDk=;
        b=qISJ71ttkLKnBPgGjDPSWPE9eMdsa/ryOsdMWsGEtJd+WYe86gyK9G4PP47b3VNRD6k6jM
        sSW95joWe4gnys3VAIaBc/1ofE1qze1O5zan16gAKEur4kqwkXq1E+HoQaCVjNOo3oZfkD
        85UXosrtmIf2LgeOrq4Oh4jBIsBzLns=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id ACA28A3B82;
        Thu, 14 Apr 2022 09:35:42 +0000 (UTC)
Date:   Thu, 14 Apr 2022 11:35:42 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 02/12] kbuild: Support for symbols.klp creation
Message-ID: <Ylfq7t0uOP7gCPEO@alley>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-3-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-3-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-16 11:39:30, Joe Lawrence wrote:
> From: Joao Moreira <jmoreira@suse.de>
> 
> For automatic resolution of livepatch relocations, a file called
> symbols.klp is used. This file maps symbols within every compiled kernel
> object allowing the identification of symbols whose name is unique, thus
> relocation can be automatically inferred, or providing information that
> helps developers when code annotation is required for solving the
> matter.
> 
> Add support for creating symbols.klp in the main Makefile. First, ensure
> that built-in is compiled when CONFIG_LIVEPATCH is enabled (as required
> to achieve a complete symbols.klp file). Define the command to build
> symbols.klp (cmd_klp_map) and hook it in the modules rule.
> 
> As it is undesirable to have symbols from livepatch objects inside
> symbols.klp, make livepatches discernible by modifying
> scripts/Makefile.build to create a .livepatch file for each livepatch in
> $(MODVERDIR). This file then used by cmd_klp_map to identify and bypass
> livepatches.
>
> For identifying livepatches during the build process, a flag variable
> LIVEPATCH_$(basetarget).o is considered in scripts/Makefile.build. This
> way, set this flag for the livepatch sample Makefile in
> samples/livepatch/Makefile.

I do not see the related code in scripts/Makefile.build.

> Finally, Add a clean rule to ensure that symbols.klp is removed during
> clean.
> 
> Notes:
> 
> To achieve a correct symbols.klp file, all kernel objects must be
> considered, thus, its construction require these objects to be priorly
> built. On the other hand, invoking scripts/Makefile.modpost without
> having a complete symbols.klp in place would occasionally lead to
> in-tree livepatches being post-processed incorrectly.

Honestly, I do not understand what it exactly means that "in-tree
livepatches would occasionally be post-processed incorrectly".

Is it the problem that modpost is not able to handle the unresolved
symbols that have to be updated by klp-convert?

> To prevent this
> from becoming a circular dependency, the construction of symbols.klp
> uses non-post-processed kernel objects and such does not cause harm as
> the symbols normally referenced from within livepatches are visible at
> this stage. Also due to these requirements, the spot in-between modules
> compilation and the invocation of scripts/Makefile.modpost was picked
> for hooking cmd_klp_map.
> 
> The approach based on .livepatch files was proposed as an alternative to
> using MODULE_INFO statements. This approach was originally proposed by
> Miroslav Benes as a workaround for identifying livepathes without
> depending on modinfo during the modpost stage. It was moved to this
> patch as the approach also shown to be useful while building
> symbols.klp.

All the tricky code is removed in the 5th patch. My understanding is
that the problem causing the cyclic dependency is solved by modifying
modpost.

It looks like this patch is outdated and mostly obsoleted. On the
other hand, the commit message in 5th patch is too short.

What about merging the two patches and updating the commit message?

Best Regards,
Petr
