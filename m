Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07930627CD6
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiKNLsp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 06:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbiKNLsE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 06:48:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735442252F;
        Mon, 14 Nov 2022 03:45:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10D0D61045;
        Mon, 14 Nov 2022 11:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2416DC433C1;
        Mon, 14 Nov 2022 11:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668426334;
        bh=E5uKKkSwNTVS2fkyiUTAmxhhGrPiE6X9sXCDPf3qXro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKwgXStSf5BKGYokF2vP5wwXHZ8kyH6GC/7CZR735e0tt2uwibnhyjRwidpNrhuRE
         7wuYoAIM8NIoLhYgNKKhSlEpLOC/wLxgTmxgY8cwmO7xq+/ybN6O7NLZPiuWVMnCQ8
         n4+5Kt1SqPDbdFIdpVt6Jo7l8QuHjozrEkB2L0nO5sylYBZasNhS4FMUoWA5OV687r
         7PENiN1LQelH6MSTfsfI+cV9z3s3l/tJn1FdHWODV5Ho42JMu8/L6I0LAn55fU2a/f
         PKdOKJM1aAPdAnxda4OdISiVeDjVBHrkOyOMeuiHuD661PbY2u5nzkadl/hRLPd3dM
         mVTEojYb5NrqQ==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Andi Kleen <andi@firstfloor.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Martin Liska <mliska@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 40/46] x86/livepatch, lto: Disable live patching with gcc LTO
Date:   Mon, 14 Nov 2022 12:43:38 +0100
Message-Id: <20221114114344.18650-41-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114114344.18650-1-jirislaby@kernel.org>
References: <20221114114344.18650-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

It is not supported by gcc 12 so far, so it causes compiler "sorry"
messages.

Other than the compiler support, there shouldn't be any barriers for
live patching LTOed kernels, although it might be more difficult to
create patches for larger functions.

Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Martin Liska <mliska@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/livepatch/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 53d51ed619a3..22699adc39a6 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -12,6 +12,7 @@ config LIVEPATCH
 	depends on KALLSYMS_ALL
 	depends on HAVE_LIVEPATCH
 	depends on !TRIM_UNUSED_KSYMS
+	depends on !LTO_GCC # not supported in gcc
 	help
 	  Say Y here if you want to support kernel live patching.
 	  This option has no runtime impact until a kernel "patch"
-- 
2.38.1

