Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7254467E23A
	for <lists+live-patching@lfdr.de>; Fri, 27 Jan 2023 11:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjA0Kvk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Jan 2023 05:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjA0Kve (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Jan 2023 05:51:34 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DF376431;
        Fri, 27 Jan 2023 02:51:32 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1258220027;
        Fri, 27 Jan 2023 10:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674816691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNr/iYVEmEDcaWh/T3KWp76qU/wj2w40Cnr5ezD8SEA=;
        b=iopcJpl2Q3ulVMwwN90yxoQI86JVX/0VHnxd5Ed4g+VYgJP5wq1F/aoVaix+G00+WsuCWu
        jrxfedEvrNd3LY4zjAoazKJsQpFfUCnKXjTlr9s7fR+9dYZKgDOlRwM7447HEfnivPtfhA
        k8cwixM8ji8k9shq1rzkGDSBIPsHaME=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E3B8A2C142;
        Fri, 27 Jan 2023 10:51:30 +0000 (UTC)
Date:   Fri, 27 Jan 2023 11:51:28 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Marcos Paulo de Souza <mpdesouza@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com
Subject: Re: [PATCH v2 0/4] livepatch: Add garbage collection for shadow
 variables
Message-ID: <Y9OssHJ4yerHPifG@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <Y2D4ZgWqB0E9viPy@alley>
 <20230123173331.2rvelrrbkaitw56r@daedalus>
 <Y8/+bGqjHsi8LEfI@alley>
 <Y9Kr3vb2s3m0MbEQ@alley>
 <3e3f4bee-4fba-7ab7-b104-7c13d89db102@redhat.com>
 <20230126183005.u7j4wdjuiasc66za@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126183005.u7j4wdjuiasc66za@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-01-26 10:30:05, Josh Poimboeuf wrote:
> On Thu, Jan 26, 2023 at 12:05:02PM -0500, Joe Lawrence wrote:
> > On 1/26/23 11:35, Petr Mladek wrote:
> > > 
> > > Josh accepted the idea in the end so we could actually push the entire
> > > patchset. I am not sure if anyone else would like to review it
> > > so I going to wait a bit longer.
> > > 
> > > Resume:
> > > 
> > > I am going to push the entire patchset the following week (Wednesday?)
> > > unless anyone asks for more time or finds a problem.
> > > 
> > 
> > Hi Petr,
> > 
> > Re docs: patches (3) and (4) change the klp_shadow_* API.  There should
> > be updates (and possibly examples) to
> > Documentation/livepatch/shadow-vars.rst.
> 
> Agreed, a documentation update is definitely needed.
> 
> Also, as I mentioned, we need to document the motivation behind the
> change and the expected use cases.  Either in the commit log or the
> documentation, or even better, some combination.  There was some very
> useful background from Nicolai and some very helpful clarifications from
> Petr.  We should make sure all that doesn't get lost in depths of the
> mailing list.

Great point. I have completely forgot about it. And did not catch the
request when quickly scaning the older replies yesterday.

> And, while I did finally accept the idea, I still need to do a more
> in-depth review of the patches.  Patches 1-2 look fine, but please give
> me some time to properly review patches 3 & 4.

Sure. It is great that the code will get another review!

I am going to wait for v3 with updated documentation and review.

Best Regards,
Petr
