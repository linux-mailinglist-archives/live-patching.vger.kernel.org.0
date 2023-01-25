Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDB967A950
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 04:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbjAYDic (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 22:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjAYDia (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 22:38:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4665C3EC59;
        Tue, 24 Jan 2023 19:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC62AB81893;
        Wed, 25 Jan 2023 03:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392C0C433D2;
        Wed, 25 Jan 2023 03:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674617891;
        bh=4uS3feTw0NdsdG5j9CW0iXk86qPLpoPkIfhS+7MuwBk=;
        h=From:To:Cc:Subject:Date:From;
        b=FWTczkGqad6vrR5MnA61pukJK9ZQgmfUzqn5fhAfJ51yNdytxxJIXelAc7/0gt+Qz
         P99aPLtECpEUIzZx5fKUhbF7sGzfIHEOeuW/dQWtgCZhMIheuOnq1BssJcaT6Abexo
         cGeLvrBQIWls+CMQWfJ9XeRrgjIAZvr1vpYsXZ3lK2iXvrRgKJ/NptPayW0ORTKQVr
         y9+F6n5AVq/ZPwD5m/fc/Q+cRhQ4kzw8aku3ESEB2uypkwdAMJz7x/B01ELedgrRV/
         bBnipkAZn9ewYYG9tsZqJ0esbtKApmZlFEGfE0Hgx1qo8AGN+yqr2Ajf+SJMsn5XDd
         rKmnRNNWwIcMg==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: [PATCH 0/2] powerpc: Fix livepatch module re-patching issue
Date:   Tue, 24 Jan 2023 19:38:03 -0800
Message-Id: <cover.1674617130.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Fix a livepatch bug seen when reloading a patched module.

This is the powerpc counterpart to Song Liu's fix for a similar issue on
x86:

  https://lkml.kernel.org/lkml/20230121004945.697003-2-song@kernel.org

Josh Poimboeuf (2):
  powerpc/module_64: Improve restore_r2() return semantics
  powerpc/module_64: Fix "expected nop" error on module re-patching

 arch/powerpc/kernel/module_64.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

-- 
2.39.0

