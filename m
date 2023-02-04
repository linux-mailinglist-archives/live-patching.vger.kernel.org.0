Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4882F68ABA1
	for <lists+live-patching@lfdr.de>; Sat,  4 Feb 2023 18:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjBDRYB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 4 Feb 2023 12:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBDRYA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 4 Feb 2023 12:24:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF514EA4;
        Sat,  4 Feb 2023 09:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8822A6068B;
        Sat,  4 Feb 2023 17:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A210FC433EF;
        Sat,  4 Feb 2023 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675531438;
        bh=xoP36gqi80AuKb0iU262xHwR0IsQZSUZsS39JGNb7Go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PcJ4qVdn++W9CS19948iWUAjJx/IpZx3dZ2bNUvQHJCImAdOU4OA2r8EzQdC7Pezt
         vs9+3474aqcqN84VYl3fH+nwV+rmn2UUUSJxRKrIoqduknUS5KwFw6KCq8pnOTSx8D
         OdPsJUgKfBozx9tZNgygeFuD+vwY76ZxgtwimPHPsAxKwXtPAy3JSOTBKjq1r5bBjH
         UdSpPYZucT2TPKyeq9lzo9Ql1muyLPTZC3i9ERAAu3NNPk9f8WIxV/WG9i3xAT5Og8
         AZhbHjggeOa2Eu5jYuNaZ1qvKaVP55FZad4AQ1XdL52VPX+dy9jmdcIv5l+hbdK4/N
         1CQRWWXkxq7dQ==
Date:   Sat, 4 Feb 2023 09:23:57 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 0/2] powerpc: Fix livepatch module re-patching issue
Message-ID: <20230204172357.mbudvbtv7tc7vhf3@treble>
References: <cover.1674617130.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1674617130.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 24, 2023 at 07:38:03PM -0800, Josh Poimboeuf wrote:
> Fix a livepatch bug seen when reloading a patched module.
> 
> This is the powerpc counterpart to Song Liu's fix for a similar issue on
> x86:
> 
>   https://lkml.kernel.org/lkml/20230121004945.697003-2-song@kernel.org
> 
> Josh Poimboeuf (2):
>   powerpc/module_64: Improve restore_r2() return semantics
>   powerpc/module_64: Fix "expected nop" error on module re-patching
> 
>  arch/powerpc/kernel/module_64.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)

Hi Michael,

Ping?  Any objections to this?

The x86 counterpart to this is queued for 6.3, it would be nice if this
also landed.  We could take it through the livepatch tree if needed.

-- 
Josh
