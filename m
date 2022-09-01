Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3435A9B4B
	for <lists+live-patching@lfdr.de>; Thu,  1 Sep 2022 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiIAPKM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Sep 2022 11:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiIAPKK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Sep 2022 11:10:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C41262D;
        Thu,  1 Sep 2022 08:10:07 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 388AB224DF;
        Thu,  1 Sep 2022 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662045006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dUKqF4WFMLbnhGWVoEtADqWmwSRbbb9QvEBtc3R+Zg0=;
        b=U9HPKwCIb5JAZTFpZN5DXWhfcwxNOhOQFYiiNhh+Q69fT08o6r5vrhy/sVFYx9hXrPt9S7
        GRpaRRpKlWKn4aU6oF8JCK9OqwvOZQ96oITArc1VJXiWoUr2mi6RSrxFosIcjxxuzjaKbn
        fGhJiSbNBthJJz+YF5OZIp7Gnapk0Us=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1A5EE2C141;
        Thu,  1 Sep 2022 15:10:05 +0000 (UTC)
Date:   Thu, 1 Sep 2022 17:10:05 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Add a missing newline character in
 klp_module_coming()
Message-ID: <YxDLTbbsqER7yrvj@alley>
References: <20220830112855.749-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830112855.749-1-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-08-30 19:28:55, Zhen Lei wrote:
> The error message is not printed immediately because it does not end with
> a newline character.
> 
> Before:
> root@localhost:~# insmod vmlinux.ko
> insmod: ERROR: could not insert module vmlinux.ko: Invalid parameters
> 
> After:
> root@localhost:~# insmod vmlinux.ko
> [   43.982558] livepatch: vmlinux.ko: invalid module name
> insmod: ERROR: could not insert module vmlinux.ko: Invalid parameters
> 
> Fixes: dcf550e52f56 ("livepatch: Disallow vmlinux.ko")
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Great catch! The message is not pushed to the console because
the line is not finished and might be eventually extended by pr_cont().

Reviewed-by: Petr Mladek <pmladek@suse.com>

The fix is trivial. I have pushed it into livepatching/livepatching.git,
branch for-6.1/fixes.

Best Regards,
Petr
