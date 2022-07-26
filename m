Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E7B581C6B
	for <lists+live-patching@lfdr.de>; Wed, 27 Jul 2022 01:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiGZXdH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Jul 2022 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGZXdH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Jul 2022 19:33:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C3E286CB;
        Tue, 26 Jul 2022 16:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1A56170E;
        Tue, 26 Jul 2022 23:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE97C433C1;
        Tue, 26 Jul 2022 23:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658878385;
        bh=I/rSDH27s22aS09yPNSQ0IWerMS4lsIiHugHoIGthYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=msdF+gbfhutRiXqSjMj29VZXd6pPQvph7mflQ/fFoxio19nyEhvVFjvAx75z21xys
         qXdAdKaAnhZiMGXNnM6Tg1oRH6ux/Xzn0k7vFjJInlQ2fPE/bQfGADidF5iB4vrK13
         lxy1h2TjzrSeOTztNrwJwcutod+07eYLvfDiEsp4cULC3feNwC/D8LSASbsBH4kF4M
         QT3VRti+eQQITHiogxHUUP7ok/pVaBKQHovewSMl/OlIoMkJpWYdn+QQxzfslphKqQ
         RetvkjvczXXyZrHhZK8jfQW+AQRp2J8d9fHks8VQKxpPX9slYQGPhTaXl4ZMzAps7s
         mXatNHGKk69aw==
Date:   Tue, 26 Jul 2022 16:33:02 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        joe.lawrence@redhat.com, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20220726233302.zwloxsammnu7clu4@treble>
References: <20220721175147.214642-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721175147.214642-1-song@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
> From: Miroslav Benes <mbenes@suse.cz>
> 
> Josh reported a bug:
> 
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
> 
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
> 
>   On ppc64le, we have a similar issue:
> 
>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
> He also proposed three different solutions. We could remove the error
> check in apply_relocate_add() introduced by commit eda9cec4c9a1
> ("x86/module: Detect and skip invalid relocations"). However the check
> is useful for detecting corrupted modules.
> 
> We could also deny the patched modules to be removed. If it proved to be
> a major drawback for users, we could still implement a different
> approach. The solution would also complicate the existing code a lot.
> 
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.
> 
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> 
> ---
> 
> Changes from v2:
> 1. Rewrite x86 changes to match current code style.
> 2. Remove powerpc changes as there is no test coverage in v3.
> 3. Only keep 1/3 of v2.

1) All the copy/paste is ugly and IMO guaranteed to eventually introduce
   bugs when somebody forgets to update the copy.  Wouldn't it be more
   robust to reuse the existing apply_relocate_add() code by making it
   more generic somehow, like with a new 'clear' bool arg which sets
   'val' to zero?

2) We can't only fix x86, powerpc also needs a fix.

3) A selftest would be a good idea.

-- 
Josh
