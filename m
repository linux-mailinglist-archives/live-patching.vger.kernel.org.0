Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE187569958
	for <lists+live-patching@lfdr.de>; Thu,  7 Jul 2022 06:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiGGEp2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Jul 2022 00:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiGGEpT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Jul 2022 00:45:19 -0400
Received: from mail.tkos.co.il (golan.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A44B2F39F;
        Wed,  6 Jul 2022 21:45:18 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 2C552440A8D;
        Thu,  7 Jul 2022 07:45:04 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1657169104;
        bh=FGK7QmnEhBmCrN37IDaIYfnjxN45wAQlIljVzSBB5hU=;
        h=From:To:Cc:Subject:Date:From;
        b=XB8KQuBDeJYkVZU2hdGcr4RJ2jCICGkl22cEQ0N3dxoz8Lekc/95N0or9DobcNn/h
         t5zAktu2YqquUGhJ+WahoME2zgkYIo7LxRPvOTZkteRF5bKZ5eReVNhL3TyuiRhKNH
         TziZwKLgy8xWqSuTjTGLFb2VR/R7QdvjyVaCA+xQ/5A5ZLLf3enMlVce/WC1ZRTgna
         vKcxQ6QdHarOtoE+tvFeM/uPeHuRO6sZFGh76uBTTh3KBjJOpiuN4A7tja0I+fX/2N
         kcWwDFHsLuB6ShahEsXBGUQjG99yQhSjdWASLQnVzrgpU4Y4QTdwP+ab1qprE/6FMU
         0gqOtGTlciGCA==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] init/Kconfig: update KALLSYMS_ALL help text
Date:   Thu,  7 Jul 2022 07:43:29 +0300
Message-Id: <1de95f0bf3abc9f6f9ebd96814fab2dae042f410.1657169009.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

CONFIG_KALLSYMS_ALL is required for kernel live patching which is a
common use case that is enabled in some major distros. Update the
Kconfig help text to reflect that.

While at it, s/e.g./i.e./ to match the text intention.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 init/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c7900e8975f1..20ef72dd6f44 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1722,16 +1722,17 @@ config KALLSYMS_ALL
 	help
 	  Normally kallsyms only contains the symbols of functions for nicer
 	  OOPS messages and backtraces (i.e., symbols from the text and inittext
-	  sections). This is sufficient for most cases. And only in very rare
-	  cases (e.g., when a debugger is used) all symbols are required (e.g.,
-	  names of variables from the data sections, etc).
+	  sections). This is sufficient for most cases. And only if you want to
+	  enable kernel live patching, or other less common use cases (e.g.,
+	  when a debugger is used) all symbols are required (i.e., names of
+	  variables from the data sections, etc).
 
 	  This option makes sure that all symbols are loaded into the kernel
 	  image (i.e., symbols from all sections) in cost of increased kernel
 	  size (depending on the kernel configuration, it may be 300KiB or
 	  something like this).
 
-	  Say N unless you really need all symbols.
+	  Say N unless you really need all symbols, or kernel live patching.
 
 config KALLSYMS_ABSOLUTE_PERCPU
 	bool
-- 
2.35.1

