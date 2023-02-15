Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42BF697958
	for <lists+live-patching@lfdr.de>; Wed, 15 Feb 2023 10:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBOJ5M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Feb 2023 04:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjBOJ5F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Feb 2023 04:57:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E251E1E8;
        Wed, 15 Feb 2023 01:57:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E83F4204B9;
        Wed, 15 Feb 2023 09:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676455022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d+HwcuhFsgx+sD75HVVV9xfW4SXgRKhvh/BUKAa+rXU=;
        b=YcaXRa9i1tsmj36ymBetzYuuXR1Ib5fYdy1RV8p+a39GBBZ3R8GtwQ95chjiPgaC0cv3as
        fVSgkHFLQYwtGiV8j6z+nfDb0OAwLtJYY/2y7HU3rnE477Xlpr9TVatJsDEz9Oq5UKpgYS
        5tYI+BLp203f9bvZc0WNrlQsL8fIZ6M=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8A3AD2C141;
        Wed, 15 Feb 2023 09:57:02 +0000 (UTC)
Date:   Wed, 15 Feb 2023 10:56:58 +0100
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
Subject: Re: [PATCH 1/3] livepatch: Skip task_call_func() for current task
Message-ID: <Y+ysamkjezbZr/Tr@alley>
References: <cover.1675969869.git.jpoimboe@kernel.org>
 <fe4deb491717279f6db8c58bfaf923d964b4a2ed.1675969869.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4deb491717279f6db8c58bfaf923d964b4a2ed.1675969869.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-02-09 11:17:47, Josh Poimboeuf wrote:
> The current task doesn't need the scheduler's protection to unwind its
> own stack.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

I do not see any problem with it:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
