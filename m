Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DF4B8E38
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiBPQkI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:40:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbiBPQkH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:40:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72FA025D27D
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645029591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y9oOSEJ5x2sTWWOBykqS0vc76o858L+uCeeYQfjYi5M=;
        b=fXcngqy+nBtIHhDXfavHmplzNVx6xzJv7iVS56QT3xSoT339Ftv3hGO0tB77AFAWqekaxL
        Se77LOGFYyiPu7zIPFl4kyxNtG5luB3KbiZBWNYNE2qmRVJoq09Vpzy6ihzAznlzROom4n
        rfboyRmf5lr7jfa+H1T1N1cZh4WmLOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-zgXjTCnKMK2TWhWUpkDjVg-1; Wed, 16 Feb 2022 11:39:48 -0500
X-MC-Unique: zgXjTCnKMK2TWhWUpkDjVg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1240814754;
        Wed, 16 Feb 2022 16:39:47 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 948BC753CD;
        Wed, 16 Feb 2022 16:39:46 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [RFC PATCH v6 07/12] documentation: Update on livepatch elf format
Date:   Wed, 16 Feb 2022 11:39:35 -0500
Message-Id: <20220216163940.228309-8-joe.lawrence@redhat.com>
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Joao Moreira <jmoreira@suse.de>

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
index dbe9b400e39f..38cf94dd35c2 100644
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
2.26.3

