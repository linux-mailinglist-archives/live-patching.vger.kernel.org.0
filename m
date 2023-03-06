Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB06AC2BF
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCFOOB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCFONp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:13:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8628F34F7D
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678111713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z74+MVPVrIYUn/gpDGp216mCCa9lSsexpc614qbTsSg=;
        b=AEiGbLfiuZIEO6+wTa+yHrEcKdRe1HLGhkzZ/LqwNOsoahonX4b7O3axHuXvoKkBvqoZOX
        Nf8mD3VczeaqagQzgpamKGBL0faJQMARgJ0S1JPCl1rtemXOHAIw1La4pVaG8TqbEWr4/z
        HkHx/dq8D3k/OAni/g/2MSeQEpxN5mw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-veemvvR3Mwaabnm8_S_q8g-1; Mon, 06 Mar 2023 09:08:29 -0500
X-MC-Unique: veemvvR3Mwaabnm8_S_q8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B15323810B0E;
        Mon,  6 Mar 2023 14:08:28 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63B0840C945A;
        Mon,  6 Mar 2023 14:08:28 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 05/10] documentation: Update on livepatch elf format
Date:   Mon,  6 Mar 2023 09:08:19 -0500
Message-Id: <20230306140824.3858543-6-joe.lawrence@redhat.com>
In-Reply-To: <20230306140824.3858543-1-joe.lawrence@redhat.com>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a section to Documentation/livepatch/module-elf-format.rst
describing how klp-convert works for fixing relocations.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 Documentation/livepatch/livepatch.rst         |  3 ++
 Documentation/livepatch/module-elf-format.rst | 42 +++++++++++++++++--
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index 68e3651e8af9..6b317a57c276 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -261,6 +261,9 @@ into three levels:
     absolute position in the database, but rather the order it has been found
     only for a particular object ( vmlinux or a kernel module ). Note that
     kallsyms allows for searching symbols according to the object name.
+    Uniquely named symbols may use a symbol position of 0.  Non-unique
+    symbols need to specify their object / kallsyms position, starting
+    at position 1.
 
   - struct klp_object defines an array of patched functions (struct
     klp_func) in the same object. Where the object is either vmlinux
diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index 7347638895a0..72a072514581 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -2,7 +2,8 @@
 Livepatch module Elf format
 ===========================
 
-This document outlines the Elf format requirements that livepatch modules must follow.
+This document outlines the Elf format requirements that livepatch modules must
+follow.
 
 
 .. Table of Contents
@@ -259,7 +260,8 @@ Livepatch symbol names must conform to the following format::
   The position of the symbol in the object (as according to kallsyms)
   This is used to differentiate duplicate symbols within the same
   object. The symbol position is expressed numerically (0, 1, 2...).
-  The symbol position of a unique symbol is 0.
+  The symbol position of a unique symbol is 0.  The symbol position of
+  the first non-unique symbol is 1, the second is 2, etc.
 
 Examples:
 ---------
@@ -291,7 +293,41 @@ Examples:
   Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
   "OS" means OS-specific.
 
-5. Symbol table and Elf section access
+5. Automatic conversion of unresolved relocations
+=================================================
+Sometimes livepatches may operate on symbols which are not self-contained nor
+exported. When this happens, these symbols remain unresolved in the elf object
+and will trigger an error during the livepatch instantiation.
+
+Whenever possible, the kernel building infrastructure solves this problem
+automatically. First, a symbol database containing information on all compiled
+objects is built. Second, this database - a file named symbols.klp, placed in
+the kernel source root directory - is used to identify targets for unresolved
+relocations, converting them in the livepatch elf accordingly to the
+specifications above-described. While the first stage is fully handled by the
+building system, the second is done by a tool called klp-convert, which can be
+found in "scripts/livepatch".
+
+When an unresolved relocation has as target a symbol whose name is also used by
+different symbols throughout the kernel, the relocation cannot be resolved
+automatically. In these cases, the livepatch developer must add annotations to
+the livepatch, making it possible for the system to identify which is the
+correct target amongst multiple homonymous symbols. Such annotations must be
+done through a data structure as follows:::
+
+	struct KLP_MODULE_RELOC(object) data_structure_name[] = {
+		KLP_SYMPOS(symbol, pos)
+	};
+
+In the above example, object refers to the object file which contains the
+symbol, being vmlinux or a module; symbol refers to the symbol name that will
+be relocated and pos is its position in the object.
+
+When a data structure like this is added to the livepatch, the resulting elf
+will hold symbols that will be identified by klp-convert and used to solve name
+ambiguities.
+
+6. Symbol table and Elf section access
 ======================================
 A livepatch module's symbol table is accessible through module->symtab.
 
-- 
2.39.2

