Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1C3697D6F
	for <lists+live-patching@lfdr.de>; Wed, 15 Feb 2023 14:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBONbv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Feb 2023 08:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBONbv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Feb 2023 08:31:51 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A1939B8D;
        Wed, 15 Feb 2023 05:31:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7C8B5337B1;
        Wed, 15 Feb 2023 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676467886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pG52jVnfc5A3+7T/+npJGdxsqxlzvkNwfHwSKvMmycA=;
        b=NKg8sDcWA9sKPk8OcHHxMTPXTfx6lUJLK/NU9AHZdk74JObN4vLZCxEiGpL/D2eZ4P5MKI
        pyypYFHbOwi1VKi0p+V/yhv7OcR3fPmD3+0oJLb1M0rgx4GN4eKROQ3eUjczoNDYkyLs+i
        g9t4eQ+w5hvl5DDr+LIQlXDvW2biEvo=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2938C2C141;
        Wed, 15 Feb 2023 13:31:26 +0000 (UTC)
Date:   Wed, 15 Feb 2023 14:31:25 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/3] vhost: Fix livepatch timeouts in vhost_worker()
Message-ID: <Y+zerZLu50B+QnUd@alley>
References: <cover.1675969869.git.jpoimboe@kernel.org>
 <76622971662bbd42abc9a1b25a73a8c3ac929ca3.1675969869.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76622971662bbd42abc9a1b25a73a8c3ac929ca3.1675969869.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-02-09 11:17:49, Josh Poimboeuf wrote:
> Livepatch timeouts were reported due to busy vhost_worker() kthreads.
> Now that cond_resched() can do livepatch task switching, use
> cond_resched() in vhost_worker().  That's the better way to
> conditionally call schedule() anyway.
> 
> Reported-by: Seth Forshee (DigitalOcean) <sforshee@digitalocean.com>
> Link: https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
