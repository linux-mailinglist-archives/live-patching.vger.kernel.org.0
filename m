Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A4E67D1B9
	for <lists+live-patching@lfdr.de>; Thu, 26 Jan 2023 17:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjAZQfs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Jan 2023 11:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjAZQfs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Jan 2023 11:35:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965DB41082;
        Thu, 26 Jan 2023 08:35:46 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 437341FEB3;
        Thu, 26 Jan 2023 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674750945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RDQClYmQWGhbNhn01Rr0Ba1gAfiluAsdWB1wrEmAwRs=;
        b=Qozq5uXo4LVuIOydH/JLliDj0TaozfWk+7tbAHhWiWyQQBdzJ/Okx4kW6KKd4lCaKffSD2
        6+uQCKIePRpRnifHS8LggoPBB0WkBmOJB6j9EUi34whp91FVN2qJEHPmr9Jzi3dnUKRUJl
        zr0eGANup+rYlFHlfsM3AOWWc2jRGMg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 217142C141;
        Thu, 26 Jan 2023 16:35:45 +0000 (UTC)
Date:   Thu, 26 Jan 2023 17:35:42 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.de>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 0/4] livepatch: Add garbage collection for shadow
 variables
Message-ID: <Y9Kr3vb2s3m0MbEQ@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <Y2D4ZgWqB0E9viPy@alley>
 <20230123173331.2rvelrrbkaitw56r@daedalus>
 <Y8/+bGqjHsi8LEfI@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8/+bGqjHsi8LEfI@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-01-24 16:51:08, Petr Mladek wrote:
> On Mon 2023-01-23 14:33:31, Marcos Paulo de Souza wrote:
> > On Tue, Nov 01, 2022 at 11:43:50AM +0100, Petr Mladek wrote:
> > > On Wed 2022-10-26 16:41:18, Marcos Paulo de Souza wrote:
> > > > Hello,
> > > > 
> > > > This is the v2 of the livepatch shadow GC patches. The changes are minor since
> > > > nobody asked for for big code changes.
> > > > 
> > > > Changes from v1:
> > > > * Reworked commit messages (Petr)
> > > > * Added my SoB which was missing in some patches, or the ordering was wrong. (Josh)
> > > > * Change __klp_shadow_get_or_use to __klp_shadow_get_or_add_locked and add a comment (Petr)
> > > > * Add lockdep_assert_held on __klp_shadow_get_or_add_locked (Petr)
> > > >   about it's meaning (Petr)
> > > > * CCing LKML (Josh)
> > > > 
> > > > Some observations:
> > > > * Petr has reviewed some of the patches that we created. I kept the Reviewed-by
> > > >   tags since he wrote the patches some time ago and now he reviewed them again
> > > >   on the ML.
> > > > * There were questions about possible problems about using klp_shadow_types
> > > >   instead of using ids, but Petr already explained that internally it still uses
> > > >   the id to find the correct livepatch.
> > > > * Regarding the possibility of multiple patches use the same ID, the problem
> > > >   already existed before. Petr suggested using a "stringified" version using
> > > >   name and id, but nobody has commented yet. I can implement such feature in a
> > > >   v3 if necessary.
> > > > 
> > > > Marcos Paulo de Souza (2):
> > > >   livepatch/shadow: Introduce klp_shadow_type structure
> > > >   livepatch/shadow: Add garbage collection of shadow variables
> > > > 
> > > > Petr Mladek (2):
> > > >   livepatch/shadow: Separate code to get or use pre-allocated shadow
> > > >     variable
> > > >   livepatch/shadow: Separate code removing all shadow variables for a
> > > >     given id
> > > 
> > > From my POV, the patchset is ready for pushing upstream.
> > 
> > Petr, what do you think about merging the first two patches, since they just
> > cleanups and simplifications?
> 
> Sounds reasonable to me. I am going to push them by the end of the
> week if nobody complained in the meantime.

Josh accepted the idea in the end so we could actually push the entire
patchset. I am not sure if anyone else would like to review it
so I going to wait a bit longer.

Resume:

I am going to push the entire patchset the following week (Wednesday?)
unless anyone asks for more time or finds a problem.

Best Regards,
Petr
