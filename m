Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055546EDBB
	for <lists+live-patching@lfdr.de>; Thu,  9 Dec 2021 17:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbhLIQ47 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Dec 2021 11:56:59 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]:39481 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbhLIQ47 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Dec 2021 11:56:59 -0500
Received: by mail-qt1-f182.google.com with SMTP id l8so5876967qtk.6;
        Thu, 09 Dec 2021 08:53:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xua9FHoyafGK1l4XcL9rDy0MCg6s5c26WJGz0jWxjoI=;
        b=crY2OQLFxDwgDnhlayLQwP3XM/Kh6UqJX1oBQFPBDvG1asFPHAL2Gf6Cgk0VwZB+6u
         5epVrqHsKfJ9Zb5HMB/JjaAMB4cXDBiD1Sa7gRppWyZzljjmIZYlDJKq2TX6chJ4w/TI
         HVt6i/ANuPNlObMzk98FYW9W9k8WSqNGZV8zPidQBKH1bi7FTMRiDv+aOHTmQtxkZzBe
         mMiDBTQJvLtdJG0XzaBWok3wMm/vF4XegcxZc2mJjTrgXyF07EsoNRx/G/gMSs7k3i8N
         BND+IU4FKplVtnW6cqWc8pBq+Er0RKnwkYNiOfPPvtIZoG96WyFiHOAaparbwj42sV3I
         nBMA==
X-Gm-Message-State: AOAM530qg8UYmB0w5nINjcGJgYkGkvj7AuqNBCpFowUVjXzotTgtuehN
        CeBLVOwAyvgjcAMDG5WV1Gu2Cuc4lmaSkQ==
X-Google-Smtp-Source: ABdhPJyK76sgjYi4jWQfWi6KVux6xOTLi0q51aKrt2yRWwHtyA6RgVPxO+x8698a8G3KBMI0ynsJTw==
X-Received: by 2002:ac8:5712:: with SMTP id 18mr19235704qtw.624.1639068805190;
        Thu, 09 Dec 2021 08:53:25 -0800 (PST)
Received: from localhost (fwdproxy-ash-021.fbsv.net. [2a03:2880:20ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id l15sm261050qtx.77.2021.12.09.08.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:53:24 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     pmladek@suse.com, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com, yhs@fb.com, songliubraving@fb.com
Subject: [PATCH] Documentation: livepatch: Add kernel-doc link to klp_enable_patch
Date:   Thu,  9 Dec 2021 08:53:04 -0800
Message-Id: <20211209165303.3205464-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The `klp_enable_patch()` function is the main entrypoint to the livepatch
subsystem, and is invoked by a KLP module from the module_init callback
when it is ready to be enabled.  The livepatch documentation specifies that
`klp_enable_patch()` should be invoked from the `module_init()` callback,
but does not actually link the user to the function's kerneldoc comment.

This simple change therefore adds a kernel-doc directive to link the
`klp_enable_patch()` function's kerneldoc comment in the livepatch
documentation page. With this, kernel/livepatch/core.c no longer comes up
as a file containing an unused doc with
`scripts/find-unused-docs.sh kernel/livepatch`

Signed-off-by: David Vernet <void@manifault.com>
---
 Documentation/livepatch/livepatch.rst | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index 68e3651e8af9..4fa9e4ebcc3a 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -312,8 +312,15 @@ the patch cannot get enabled.
 -------------
 
 The livepatch gets enabled by calling klp_enable_patch() from
-the module_init() callback. The system will start using the new
-implementation of the patched functions at this stage.
+the module_init() callback:
+
+.. kernel-doc:: kernel/livepatch/core.c
+   :functions: klp_enable_patch
+
+----
+
+The system will start using the new implementation of the patched functions at
+this stage.
 
 First, the addresses of the patched functions are found according to their
 names. The special relocations, mentioned in the section "New functions",
-- 
2.30.2

