Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFD56147DB
	for <lists+live-patching@lfdr.de>; Tue,  1 Nov 2022 11:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKAKny (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 1 Nov 2022 06:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAKnx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 1 Nov 2022 06:43:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B440E12614;
        Tue,  1 Nov 2022 03:43:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 558E922440;
        Tue,  1 Nov 2022 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667299431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8oJxxcmO28PQHt/0hxyUpAk79tFXJYnw+3OkYY0JtL4=;
        b=Ki40gG0Q5SYTkAmTCZDICNIxY49rfjjr0HFqtJClejPmWI80oUWSlv4FqSyLGRcgfJd55L
        l5jZYWM1rld+Px76vBwyJnC4I15R9ctmNF4gKNd66MRs3TexScjIjzCvaMxRIVAltWpt1k
        XeDHN2VtdH1hVnQEI6mU2CWJB3hppHc=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 349AB2C141;
        Tue,  1 Nov 2022 10:43:51 +0000 (UTC)
Date:   Tue, 1 Nov 2022 11:43:50 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 0/4] livepatch: Add garbage collection for shadow
 variables
Message-ID: <Y2D4ZgWqB0E9viPy@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-1-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-10-26 16:41:18, Marcos Paulo de Souza wrote:
> Hello,
> 
> This is the v2 of the livepatch shadow GC patches. The changes are minor since
> nobody asked for for big code changes.
> 
> Changes from v1:
> * Reworked commit messages (Petr)
> * Added my SoB which was missing in some patches, or the ordering was wrong. (Josh)
> * Change __klp_shadow_get_or_use to __klp_shadow_get_or_add_locked and add a comment (Petr)
> * Add lockdep_assert_held on __klp_shadow_get_or_add_locked (Petr)
>   about it's meaning (Petr)
> * CCing LKML (Josh)
> 
> Some observations:
> * Petr has reviewed some of the patches that we created. I kept the Reviewed-by
>   tags since he wrote the patches some time ago and now he reviewed them again
>   on the ML.
> * There were questions about possible problems about using klp_shadow_types
>   instead of using ids, but Petr already explained that internally it still uses
>   the id to find the correct livepatch.
> * Regarding the possibility of multiple patches use the same ID, the problem
>   already existed before. Petr suggested using a "stringified" version using
>   name and id, but nobody has commented yet. I can implement such feature in a
>   v3 if necessary.
> 
> Marcos Paulo de Souza (2):
>   livepatch/shadow: Introduce klp_shadow_type structure
>   livepatch/shadow: Add garbage collection of shadow variables
> 
> Petr Mladek (2):
>   livepatch/shadow: Separate code to get or use pre-allocated shadow
>     variable
>   livepatch/shadow: Separate code removing all shadow variables for a
>     given id

From my POV, the patchset is ready for pushing upstream.

Well, we need to get approval from kpatch-build users. Joe described
possible problems in replay for v3, see
https://lore.kernel.org/r/b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com

Best Regards,
Petr
