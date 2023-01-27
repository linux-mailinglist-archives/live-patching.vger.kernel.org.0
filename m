Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA08467E2B6
	for <lists+live-patching@lfdr.de>; Fri, 27 Jan 2023 12:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjA0LI4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Jan 2023 06:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA0LIz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Jan 2023 06:08:55 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9150196A8;
        Fri, 27 Jan 2023 03:08:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B4301F37F;
        Fri, 27 Jan 2023 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674817733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Mep4Rr8Z+5U+3JRsFi1JIw1zbHgf4EPZQO7IpTGgxY=;
        b=PHUw/J6AuTSxGf5Fs2Who4NcFT968FFEhDBlDQNZxJFxMlXLJ2auTdqVjijlPiUZtRp2XI
        bVTJW+eZqfkcRu5zizv156NMk1Ve7HuLW5E5AualvtFVxNzymsV4ZrBnHbJnpUil/Kvt6G
        cIYRfuPu3xS/vPv4jc9rKPO3JAJNR6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674817733;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Mep4Rr8Z+5U+3JRsFi1JIw1zbHgf4EPZQO7IpTGgxY=;
        b=8DMR8dUEnWWbgh22/A8phPvacxOJg1GM69DSZdc3MxNqp0Eh92cGcg3rpREZztbsYNg1Z7
        vhe+AZeQ/nR0GXBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A533B1336F;
        Fri, 27 Jan 2023 11:08:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rdPJGsOw02OGUgAAMHmgww
        (envelope-from <mpdesouza@suse.de>); Fri, 27 Jan 2023 11:08:51 +0000
Date:   Fri, 27 Jan 2023 08:08:48 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com
Subject: Re: [PATCH v2 0/4] livepatch: Add garbage collection for shadow
 variables
Message-ID: <20230127110848.rgjvzh3cqc5fepyj@daedalus>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <Y2D4ZgWqB0E9viPy@alley>
 <20230123173331.2rvelrrbkaitw56r@daedalus>
 <Y8/+bGqjHsi8LEfI@alley>
 <Y9Kr3vb2s3m0MbEQ@alley>
 <3e3f4bee-4fba-7ab7-b104-7c13d89db102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3f4bee-4fba-7ab7-b104-7c13d89db102@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 26, 2023 at 12:05:02PM -0500, Joe Lawrence wrote:
> On 1/26/23 11:35, Petr Mladek wrote:
> > 
> > Josh accepted the idea in the end so we could actually push the entire
> > patchset. I am not sure if anyone else would like to review it
> > so I going to wait a bit longer.
> > 
> > Resume:
> > 
> > I am going to push the entire patchset the following week (Wednesday?)
> > unless anyone asks for more time or finds a problem.
> > 
> 
> Hi Petr,
> 
> Re docs: patches (3) and (4) change the klp_shadow_* API.  There should
> be updates (and possibly examples) to
> Documentation/livepatch/shadow-vars.rst.

I forgot about shadow-vars.rst! This will be added on v3.

> 
> Having this for v1/v2 would have made review a lot easier, though I
> understand not wanting to waste cycles on documenting dead ends.

That's true. Next time I'll take care of the docs when the API changes. Thanks
for the reviews so far!

> 
> -- 
> Joe
> 
