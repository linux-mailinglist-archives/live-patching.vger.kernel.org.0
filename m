Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B006467D42F
	for <lists+live-patching@lfdr.de>; Thu, 26 Jan 2023 19:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAZSaM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Jan 2023 13:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjAZSaK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Jan 2023 13:30:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0252733;
        Thu, 26 Jan 2023 10:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7619B81C5E;
        Thu, 26 Jan 2023 18:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34415C433D2;
        Thu, 26 Jan 2023 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674757807;
        bh=t1pvPQiEE12UN7eDyTpHjhJkPp6HbJgBMIssEtoq+nE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPZhfZ9cWhiz3dop72KmdJC60XNjwZXjCBV7hYtulOqeE7uqcOKcWQ4qSKkYCnvOs
         8HEilsAqcWdAlTfxU85Lyx2mYn+XkEBPqEWhYv8+aeE8xIfIXYah5+xeVLLxBBSreh
         wHZhRzx7A4IuJ6cg8UQYQQxtQJv5nyi1XHHFVgliSSNnGXqKnV5joCXYDDjE/f4ugz
         0ZYN72GKQUxk31jMaFWO2YlYtYeuKHEs+DbGUKIBUzZqCZU5I58C0RKpmQUqiBIMPR
         pr4FYpknYIGABI3zecegLa+8H/CoY3Kb5Vgx/8PU0mJSa4/zYQmBdapxBcGMHQTx4n
         0p1iA6tPpOW3g==
Date:   Thu, 26 Jan 2023 10:30:05 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com
Subject: Re: [PATCH v2 0/4] livepatch: Add garbage collection for shadow
 variables
Message-ID: <20230126183005.u7j4wdjuiasc66za@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <Y2D4ZgWqB0E9viPy@alley>
 <20230123173331.2rvelrrbkaitw56r@daedalus>
 <Y8/+bGqjHsi8LEfI@alley>
 <Y9Kr3vb2s3m0MbEQ@alley>
 <3e3f4bee-4fba-7ab7-b104-7c13d89db102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e3f4bee-4fba-7ab7-b104-7c13d89db102@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Agreed, a documentation update is definitely needed.

Also, as I mentioned, we need to document the motivation behind the
change and the expected use cases.  Either in the commit log or the
documentation, or even better, some combination.  There was some very
useful background from Nicolai and some very helpful clarifications from
Petr.  We should make sure all that doesn't get lost in depths of the
mailing list.

And, while I did finally accept the idea, I still need to do a more
in-depth review of the patches.  Patches 1-2 look fine, but please give
me some time to properly review patches 3 & 4.

-- 
Josh
