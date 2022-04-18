Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4865F505DE9
	for <lists+live-patching@lfdr.de>; Mon, 18 Apr 2022 20:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbiDRSPP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Apr 2022 14:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiDRSPO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Apr 2022 14:15:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 941A32DD6F
        for <live-patching@vger.kernel.org>; Mon, 18 Apr 2022 11:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650305553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1X1P7TWjalEM123qZYEn+EVXAidMNPjn8TgJk2XbTmY=;
        b=G6O/qBrwP9dEKKsU7HsfIZBjc6zMR3mohydu4Lo9/Mw5CnGfinLqTk7fyVDUNxO8Tyh8ng
        SjQdw6Ve3rq4EP/gVib1cOsq95ufyChPCUxRbDhI3IHByFwPrPqdw8RsPKZY8j7kNN8t7A
        rMdHxn2IdNAp1f65Lv/vsy+10NoGVRk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-9tjdyVQgO8K919Vc6j2rHw-1; Mon, 18 Apr 2022 14:12:29 -0400
X-MC-Unique: 9tjdyVQgO8K919Vc6j2rHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6557C805F46;
        Mon, 18 Apr 2022 18:12:29 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2F07200D8EF;
        Mon, 18 Apr 2022 18:12:28 +0000 (UTC)
Date:   Mon, 18 Apr 2022 14:12:27 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Nicolas Schier <nicolas@fjasle.eu>
Cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 02/12] kbuild: Support for symbols.klp creation
Message-ID: <Yl2qC7p7NDq4i+9B@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-3-joe.lawrence@redhat.com>
 <Ylfq7t0uOP7gCPEO@alley>
 <YlhhHSQIWpLG0Cgn@fjasle.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlhhHSQIWpLG0Cgn@fjasle.eu>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 14, 2022 at 07:59:57PM +0200, Nicolas Schier wrote:
> On Thu, Apr 14, 2022 at 11:35:42AM +0200 Petr Mladek wrote:
> > On Wed 2022-02-16 11:39:30, Joe Lawrence wrote:
> > > From: Joao Moreira <jmoreira@suse.de>
> > > 
> > > For automatic resolution of livepatch relocations, a file called
> > > symbols.klp is used. This file maps symbols within every compiled kernel
> > > object allowing the identification of symbols whose name is unique, thus
> > > relocation can be automatically inferred, or providing information that
> > > helps developers when code annotation is required for solving the
> > > matter.
> > > 
> > > Add support for creating symbols.klp in the main Makefile. First, ensure
> > > that built-in is compiled when CONFIG_LIVEPATCH is enabled (as required
> > > to achieve a complete symbols.klp file). Define the command to build
> > > symbols.klp (cmd_klp_map) and hook it in the modules rule.
> > > 
> > > As it is undesirable to have symbols from livepatch objects inside
> > > symbols.klp, make livepatches discernible by modifying
> > > scripts/Makefile.build to create a .livepatch file for each livepatch in
> > > $(MODVERDIR). This file then used by cmd_klp_map to identify and bypass
> > > livepatches.
> > >
> > > For identifying livepatches during the build process, a flag variable
> > > LIVEPATCH_$(basetarget).o is considered in scripts/Makefile.build. This
> > > way, set this flag for the livepatch sample Makefile in
> > > samples/livepatch/Makefile.
> > 
> > I do not see the related code in scripts/Makefile.build.
> > 
> > > Finally, Add a clean rule to ensure that symbols.klp is removed during
> > > clean.
> > > 
> > > Notes:
> > > 
> > > To achieve a correct symbols.klp file, all kernel objects must be
> > > considered, thus, its construction require these objects to be priorly
> > > built. On the other hand, invoking scripts/Makefile.modpost without
> > > having a complete symbols.klp in place would occasionally lead to
> > > in-tree livepatches being post-processed incorrectly.
> > 
> > Honestly, I do not understand what it exactly means that "in-tree
> > livepatches would occasionally be post-processed incorrectly".
> > 
> > Is it the problem that modpost is not able to handle the unresolved
> > symbols that have to be updated by klp-convert?
> > 
> > > To prevent this
> > > from becoming a circular dependency, the construction of symbols.klp
> > > uses non-post-processed kernel objects and such does not cause harm as
> > > the symbols normally referenced from within livepatches are visible at
> > > this stage. Also due to these requirements, the spot in-between modules
> > > compilation and the invocation of scripts/Makefile.modpost was picked
> > > for hooking cmd_klp_map.
> > > 
> > > The approach based on .livepatch files was proposed as an alternative to
> > > using MODULE_INFO statements. This approach was originally proposed by
> > > Miroslav Benes as a workaround for identifying livepathes without
> > > depending on modinfo during the modpost stage. It was moved to this
> > > patch as the approach also shown to be useful while building
> > > symbols.klp.
> > 
> > All the tricky code is removed in the 5th patch. My understanding is
> > that the problem causing the cyclic dependency is solved by modifying
> > modpost.
> > 
> > It looks like this patch is outdated and mostly obsoleted. On the
> > other hand, the commit message in 5th patch is too short.
> > 
> > What about merging the two patches and updating the commit message?
> 
> +1
> 
> Yes, please merge those patches.  These '$(shell ...)' side-effect lines in the
> definition of 'cmd_klp_map' are quite confusing.
> 

Sure.  Admittedly the kbuild integration is most confusing to me, so I
leaned heavily on Joao's original notes and Masahiro's gracious tips and
refactored code.  I'll try cutting to the final version in later patches
rather than providing all the (confusing) code evolution along the way.

Thanks,
 
-- Joe

