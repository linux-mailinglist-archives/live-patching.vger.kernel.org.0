Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC50687695
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjBBHmz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjBBHmv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:51 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3C688495D;
        Wed,  1 Feb 2023 23:42:36 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id A79A520B96E8;
        Wed,  1 Feb 2023 23:42:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A79A520B96E8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323756;
        bh=3qU35kR6nm9/qdtMkBRKO5MFQ8eSw6OI7xVYMG8qPdU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hONvI3e0GsW7hJPLcxlcDOCGFQv9nEsAM58s8vmj+SktxBGS71H6LsGwW6rFfpKPF
         sxZ3btYfSM9XR2NeR07R7+VEqWKQsP10HiBErjXRDWnlujUAvocDiERW3Oi5K9fKc/
         BmaFGuQS65bH+qQz9rwbDoYyISLXSIniZW+kuIg0=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 11/22] objtool: arm64: Invoke the decoder
Date:   Thu,  2 Feb 2023 01:40:25 -0600
Message-Id: <20230202074036.507249-12-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Invoke decode_instructions() from check(). For Dynamic Validation of
the frame pointer, we only need the "-s" option for objtool.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/dcheck.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/dcheck.c b/tools/objtool/dcheck.c
index e2098c9ad282..cd2700153408 100644
--- a/tools/objtool/dcheck.c
+++ b/tools/objtool/dcheck.c
@@ -9,8 +9,13 @@
 #include <sys/mman.h>
 
 #include <objtool/objtool.h>
+#include <objtool/builtin.h>
+#include <objtool/insn.h>
 
 int check(struct objtool_file *file)
 {
-	return 0;
+	if (!opts.stackval)
+		return 1;
+
+	return decode_instructions(file);
 }
-- 
2.25.1

