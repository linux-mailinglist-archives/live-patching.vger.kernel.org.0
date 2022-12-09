Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBA564829D
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 13:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLIMz2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 07:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLIMz2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 07:55:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7143C6BC81;
        Fri,  9 Dec 2022 04:55:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1FAE51FDD8;
        Fri,  9 Dec 2022 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670590526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Mpi4kBflHyGnl2RYaOzIsTMrflHCQdsxBAJVfeYlOE=;
        b=I8sTQjXmWsNBWqXVIJsQ9SEgYBSgsuxLEI1rsa4kaBi4yWEGORroOqUtwCSj+pGxNiZP5o
        78r15DO2cmQJF1ENzkpRIIzzTutseiaIwwkSw5UY7YoDSYEPJPg8pCmDPYerPCDUap0MSv
        tXcPR5NBpKiRRLY7/FC+8zDogwUmiJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670590526;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Mpi4kBflHyGnl2RYaOzIsTMrflHCQdsxBAJVfeYlOE=;
        b=rF95JOp4MpBM+t0tqqyK4lWJ8XLCYkCMrEMPhfFSsx7ap4MkID2vBHuK/q9WmpevUExUkm
        jqp/AtY7E0m+oFCQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E3F5B2C141;
        Fri,  9 Dec 2022 12:55:25 +0000 (UTC)
Date:   Fri, 9 Dec 2022 13:55:29 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Song Liu <song@kernel.org>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20220901171252.2148348-1-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2212091352370.18933@pobox.suse.cz>
References: <20220901171252.2148348-1-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

first thank you for taking over and I also appologize for not replying 
much sooner.

On Thu, 1 Sep 2022, Song Liu wrote:

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

Petr has commented on the code aspects. I will just add that s390x was not 
dealt with at the time because there was no live patching support for 
s390x back then if I remember correctly and my notes do not lie. The same 
applies to powerpc32. I think that both should be fixed as well with this 
patch. It might also help to clean up the ifdeffery in the patch a bit.

Miroslav
