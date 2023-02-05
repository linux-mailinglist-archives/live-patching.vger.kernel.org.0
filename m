Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E34368ADAC
	for <lists+live-patching@lfdr.de>; Sun,  5 Feb 2023 01:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjBEArb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 4 Feb 2023 19:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjBEAra (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 4 Feb 2023 19:47:30 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1D52529F;
        Sat,  4 Feb 2023 16:47:28 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P8W264VTwz4xxJ;
        Sun,  5 Feb 2023 11:47:26 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>
In-Reply-To: <cover.1674617130.git.jpoimboe@kernel.org>
References: <cover.1674617130.git.jpoimboe@kernel.org>
Subject: Re: [PATCH 0/2] powerpc: Fix livepatch module re-patching issue
Message-Id: <167555801712.1621279.10804935395824436485.b4-ty@ellerman.id.au>
Date:   Sun, 05 Feb 2023 11:46:57 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 24 Jan 2023 19:38:03 -0800, Josh Poimboeuf wrote:
> Fix a livepatch bug seen when reloading a patched module.
> 
> This is the powerpc counterpart to Song Liu's fix for a similar issue on
> x86:
> 
>   https://lkml.kernel.org/lkml/20230121004945.697003-2-song@kernel.org
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc/module_64: Improve restore_r2() return semantics
      https://git.kernel.org/powerpc/c/bc2c6f5695ffa05c838b8b6fc5cd581a672151a1
[2/2] powerpc/module_64: Fix "expected nop" error on module re-patching
      https://git.kernel.org/powerpc/c/37251c7114e1b743b077ca74b93557c1ad92a97e

cheers
