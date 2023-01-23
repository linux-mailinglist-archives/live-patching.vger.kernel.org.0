Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3E678354
	for <lists+live-patching@lfdr.de>; Mon, 23 Jan 2023 18:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjAWRfL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 Jan 2023 12:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbjAWRe5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 Jan 2023 12:34:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A4A2FCE3;
        Mon, 23 Jan 2023 09:34:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5D8F62184F;
        Mon, 23 Jan 2023 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674495216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ro2DBmNZbamdtWM6haiWhuRN1QfFV7RGG2FGjrIg8aM=;
        b=B0E16fqLvDIZc49JKXgQL1KMe/ZMdDf1geh0eLDSJpgE3iehTOteBtRWNmQXNHlzAd9Mp5
        upoZmIC2c+wQl86xCM15+ELwNdr4p39JB8fTf0UH+u+0ld2rb68Kv0tGEZydJ5HDT2JmG3
        WQuLYBaDSDbr21G8huC3rX1XK8dR6fQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674495216;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ro2DBmNZbamdtWM6haiWhuRN1QfFV7RGG2FGjrIg8aM=;
        b=PCa+aAoeZfChR2FcxE8ZZmBB5qnvAlp26qjdtNHRr9bOHwHSWj3OrG3oOKdfw82sq9yTBL
        mSeAqIzzTwEe47CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5845A1357F;
        Mon, 23 Jan 2023 17:33:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qJNYB+7EzmOYHgAAMHmgww
        (envelope-from <mpdesouza@suse.de>); Mon, 23 Jan 2023 17:33:34 +0000
Date:   Mon, 23 Jan 2023 14:33:31 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 0/4] livepatch: Add garbage collection for shadow
 variables
Message-ID: <20230123173331.2rvelrrbkaitw56r@daedalus>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <Y2D4ZgWqB0E9viPy@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2D4ZgWqB0E9viPy@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 01, 2022 at 11:43:50AM +0100, Petr Mladek wrote:
> On Wed 2022-10-26 16:41:18, Marcos Paulo de Souza wrote:
> > Hello,
> > 
> > This is the v2 of the livepatch shadow GC patches. The changes are minor since
> > nobody asked for for big code changes.
> > 
> > Changes from v1:
> > * Reworked commit messages (Petr)
> > * Added my SoB which was missing in some patches, or the ordering was wrong. (Josh)
> > * Change __klp_shadow_get_or_use to __klp_shadow_get_or_add_locked and add a comment (Petr)
> > * Add lockdep_assert_held on __klp_shadow_get_or_add_locked (Petr)
> >   about it's meaning (Petr)
> > * CCing LKML (Josh)
> > 
> > Some observations:
> > * Petr has reviewed some of the patches that we created. I kept the Reviewed-by
> >   tags since he wrote the patches some time ago and now he reviewed them again
> >   on the ML.
> > * There were questions about possible problems about using klp_shadow_types
> >   instead of using ids, but Petr already explained that internally it still uses
> >   the id to find the correct livepatch.
> > * Regarding the possibility of multiple patches use the same ID, the problem
> >   already existed before. Petr suggested using a "stringified" version using
> >   name and id, but nobody has commented yet. I can implement such feature in a
> >   v3 if necessary.
> > 
> > Marcos Paulo de Souza (2):
> >   livepatch/shadow: Introduce klp_shadow_type structure
> >   livepatch/shadow: Add garbage collection of shadow variables
> > 
> > Petr Mladek (2):
> >   livepatch/shadow: Separate code to get or use pre-allocated shadow
> >     variable
> >   livepatch/shadow: Separate code removing all shadow variables for a
> >     given id
> 
> From my POV, the patchset is ready for pushing upstream.

Petr, what do you think about merging the first two patches, since they just
cleanups and simplifications?

> 
> Well, we need to get approval from kpatch-build users. Joe described
> possible problems in replay for v3, see
> https://lore.kernel.org/r/b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com
> 
> Best Regards,
> Petr
