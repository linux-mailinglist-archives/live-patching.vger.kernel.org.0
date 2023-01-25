Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274FF67B330
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 14:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbjAYNY4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 08:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAYNY4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 08:24:56 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584111423F;
        Wed, 25 Jan 2023 05:24:55 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 024FF21D53;
        Wed, 25 Jan 2023 13:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674653094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uzt5+rLRlm/axdJj2mIj/bMptJgE194uAOpesCCRc2Y=;
        b=RdGmIAkgn7YC1ScTgFAXzoBjhGhO5U9eFqcSmhz6cIVOojIvPVkwvWaVawl20nxZulqI6s
        KOvYTPBeSMILMXQiw6edGMU9jCLNKTCXiQN657ZBZ5zEN55aadDPGasxW4/l+6BNc9vyoV
        ltCGPYibnhhTMPKKETrzUpDQH2v3PsI=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7D54C2C141;
        Wed, 25 Jan 2023 13:24:52 +0000 (UTC)
Date:   Wed, 25 Jan 2023 14:24:50 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 1/2] powerpc/module_64: Improve restore_r2() return
 semantics
Message-ID: <Y9EtohjVnoJLqccx@alley>
References: <cover.1674617130.git.jpoimboe@kernel.org>
 <15baf76c271a0ae09f7b8556e50f2b4251e7049d.1674617130.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15baf76c271a0ae09f7b8556e50f2b4251e7049d.1674617130.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-01-24 19:38:04, Josh Poimboeuf wrote:
> restore_r2() returns 1 on success, which is surprising for a non-boolean
> function.  Change it to return 0 on success and -errno on error to match
> kernel coding convention.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Looks good:

Reviewed-by: Petr Mladek <pmladek@suse.com>

It is in the right direction. Just note that there are more functions
with the boolean semantic passed via int return value. But there
are also other functions already using the 0/-E* return values so
this is rather positive change.

Best Regards,
Petr
