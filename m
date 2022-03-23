Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BD44E55AC
	for <lists+live-patching@lfdr.de>; Wed, 23 Mar 2022 16:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiCWPym (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Mar 2022 11:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiCWPyl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Mar 2022 11:54:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9280212A95;
        Wed, 23 Mar 2022 08:53:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 05F09210F3;
        Wed, 23 Mar 2022 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648050790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yi+NBj+fiR2T/7qvGEUjUcsgNiIZjTQLMSbnc3SdRBU=;
        b=pYBHymC0Kj0AgtNOT7wy6G26/sKL8L0tu3iZ5/KgjkiEhUqin13jAF1bucxYpsvXggXi72
        uD2kOMYslWlBaMxR38+EBu+nYI/gDSxMOXvhFKwjJT/RrIVDhYZZH12P/vBlDdgIHsxFdR
        im9Ia5o7aFUVuXF+hzxusMOfsoBg0PU=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D044EA3B83;
        Wed, 23 Mar 2022 15:53:09 +0000 (UTC)
Date:   Wed, 23 Mar 2022 16:53:07 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     trix@redhat.com
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2] livepatch: Reorder to use before freeing a pointer
Message-ID: <YjtCY1QaA6GI3b+7@alley>
References: <20220320015143.2208591-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220320015143.2208591-1-trix@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2022-03-19 18:51:43, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this issue
> livepatch-shadow-fix1.c:113:2: warning: Use of
>   memory after it is freed
>   pr_info("%s: dummy @ %p, prevented leak @ %p\n",
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The pointer is freed in the previous statement.
> Reorder the pr_info to report before the free.
> 
> Similar issue in livepatch-shadow-fix2.c

I have added the following paragraph:

<snip>
Note that it is a false positive. pr_info() just prints the address.
The freed memory is not accessed. Well, the static analyzer could not
know this easily.
</snip>

> Signed-off-by: Tom Rix <trix@redhat.com>

and pushed the patch into livepatching/livepatching.git,
branch for-5.18/selftests-fixes.

IMHO, the patch is so trivial and can be added even in this merge
window. There is no need to create more dances around it ;-)

Let me know if you disagree. I am going to send the pull request
on Friday or Monday.

Best Regards,
Petr
