Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CE36BB3A4
	for <lists+live-patching@lfdr.de>; Wed, 15 Mar 2023 13:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjCOMxP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Mar 2023 08:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbjCOMxK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Mar 2023 08:53:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CFA99268;
        Wed, 15 Mar 2023 05:53:03 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso1015224wmr.3;
        Wed, 15 Mar 2023 05:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678884782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OmyRdtH3qiSO5QWPBLWz/8v2lIwyybKSmrlaokl//yI=;
        b=IKjEROzVMXRIH2jmXhG0/7c8b2IOHgUL6F+2j+hWDlKOJt/JE1CMxqsmVUaTSZ/ZII
         dKxHynYor0Co5ohMyb3jBPd3zTrvQxj0esnBH5bKxoki7lGTb2Pkw+/vx901t66bJvUM
         loxVftu+i7vhzZJi4xrspTeYOoe1S1Fms95gRioUAdgmxAhGxEFQQ3t2kw3Lox6vAFSR
         NL9aWBYFpdcq5c/DpZbhv6wECLhIiyxvF0A1juR88OjXaQAM2DEcGIudZwH3c1pLWPCj
         pTpj9gmfbneGj4wRu8aPNV6Kr5SIcTiI87VPALaqWD3/U818FxvX8qsZnfVBC/hs2hAE
         AeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678884782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmyRdtH3qiSO5QWPBLWz/8v2lIwyybKSmrlaokl//yI=;
        b=OT9O4AoJDAw6T4/8u3SUE1c4+2zBH+nKpe+rjF1mW6akYwdaz79C0b6bnohF1Xy0IM
         xudEcl3F+KFroX60sGj33QPjz7xP+kL5ctLt+by+RwAnEvM0X+8bc559bbCfDua4/m7r
         yHnxSGwTDWv3yW1/cKVCBTuPaJjJ+4pzK5IVVyZcvtCVTAz+kqx/ly6nyuhCFinJWQDI
         153S8vgbqMpDi+6Y4T8xvMfKRfj9MyMzvwPsCVI4rdCUKkfbcr8lPROYHuWGDJZcaALM
         +eE1BarMK+iMhjFX/6mNNF6MfOvRyaSNbsBaG3Qw0wYtVdtNi3hyPh9Bv/Gfk4DxXiCL
         UF+w==
X-Gm-Message-State: AO0yUKUTeho28MfYGct6VJW+II/SPGr0fmo/rcN6W4z7pSO6Gtz/sxz3
        Jqt72ro58rSK4v6dReSQQXY=
X-Google-Smtp-Source: AK7set99tKxZBFxqdMlw/6z3DNaJbvpo8WlRdBy5s/IULVxadkVRlZINUgSsb6joz/S+1AnBv0uW2g==
X-Received: by 2002:a05:600c:198f:b0:3ea:f6c4:5f26 with SMTP id t15-20020a05600c198f00b003eaf6c45f26mr17240294wmq.17.1678884782269;
        Wed, 15 Mar 2023 05:53:02 -0700 (PDT)
Received: from localhost.localdomain (host-79-35-102-94.retail.telecomitalia.it. [79.35.102.94])
        by smtp.gmail.com with ESMTPSA id k26-20020a7bc31a000000b003eb596cbc54sm1936761wmj.0.2023.03.15.05.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 05:53:01 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Nick Terrell <terrelln@fb.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        live-patching@vger.kernel.org, bpf@vger.kernel.org,
        llvm@lists.linux.dev
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Piotr Gorski <piotrgorski@cachyos.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] module/decompress: Never use kunmap() for local un-mappings
Date:   Wed, 15 Mar 2023 13:52:56 +0100
Message-Id: <20230315125256.22772-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Use kunmap_local() to unmap pages locally mapped with kmap_local_page().

kunmap_local() must be called on the kernel virtual address returned by
kmap_local_page(), differently from how we use kunmap() which instead
expects the mapped page as its argument.

In module_zstd_decompress() we currently map with kmap_local_page() and
unmap with kunmap(). This breaks the code and so it should be fixed.

Cc: Piotr Gorski <piotrgorski@cachyos.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Fixes: 169a58ad824d ("module/decompress: Support zstd in-kernel decompression")
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 kernel/module/decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
index bb79ac1a6d8f..7ddc87bee274 100644
--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -267,7 +267,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
 		zstd_dec.size = PAGE_SIZE;
 
 		ret = zstd_decompress_stream(dstream, &zstd_dec, &zstd_buf);
-		kunmap(page);
+		kunmap_local(zstd_dec.dst);
 		retval = zstd_get_error_code(ret);
 		if (retval)
 			break;
-- 
2.39.2

