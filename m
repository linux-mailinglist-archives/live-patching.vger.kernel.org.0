Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C7247C210
	for <lists+live-patching@lfdr.de>; Tue, 21 Dec 2021 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhLUO70 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Dec 2021 09:59:26 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:37568 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbhLUO7Z (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Dec 2021 09:59:25 -0500
Received: by mail-qt1-f170.google.com with SMTP id f9so1057486qtk.4;
        Tue, 21 Dec 2021 06:59:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2IPWxjjiSH3m03vEE8pLIENC0WRU8tftzSUIo1Dg3GE=;
        b=j1+sa5Y2RNUYYg04Y0ju4qQKptzGhj9K1rXrkoVAAn91KS7Mu+RHuafU1jwQ5KCAda
         uQzlfHKH02pxfHDCg4WgcO8pL3zsiJDr/bxMF4kAOtxdYmoJn0E7T24Jjx+51OLxgHrM
         g+hhBPLkxJW6fpehe86H6gnv2JPjR3laT7Xghbkrk3n9TYwRxXtUrVO/KdSiqTb8qWyd
         1GTq1PmwS2yiP5xDieEkpqCnttqg96tLTWqSSVKESqkfoP20chdKhhj893ap1iu5plGL
         IVRRuIg5guucZACxpbz0E6LGvDmwg4Te8yuV+svXh7NK2p3afsoVwvpZZkCvmwKtGyvp
         ZIXw==
X-Gm-Message-State: AOAM532u91AHhiXCIcmT/VqXe1QXFismxf3RviqJcBoVX5NJs9Fhezju
        Z2RBuqYVrz9HyjbcnbqlGqaxRKr+1/E=
X-Google-Smtp-Source: ABdhPJybOV5Cvzb6vjMwKkcKp5IV7W/bC/v1DTyzohybNs6Jj3QRaXfeZmsxu36cnDISWMXb6w+R+g==
X-Received: by 2002:a05:622a:1745:: with SMTP id l5mr1729243qtk.663.1640098764627;
        Tue, 21 Dec 2021 06:59:24 -0800 (PST)
Received: from localhost (fwdproxy-ash-117.fbsv.net. [2a03:2880:20ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id y12sm14153952qko.36.2021.12.21.06.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 06:59:24 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     pmladek@suse.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com
Subject: [PATCH v3] Documentation: livepatch: Add livepatch API page
Date:   Tue, 21 Dec 2021 06:57:45 -0800
Message-Id: <20211221145743.4098360-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch subsystem has several exported functions and objects with
kerneldoc comments. Though the livepatch documentation contains handwritten
descriptions of all of these exported functions, they are currently not
pulled into the docs build using the kernel-doc directive.

In order to allow readers of the documentation to see the full kerneldoc
comments in the generated documentation files, this change adds a new
Documentation/livepatch/api.rst page which contains kernel-doc directives
to link the kerneldoc comments directly in the documentation.  With this,
all of the hand-written descriptions of the APIs now cross-reference the
kerneldoc comments on the new Livepatching APIs page, and running
./scripts/find-unused-docs.sh on kernel/livepatch no longer shows any files
as missing documentation.

Note that all of the handwritten API descriptions were left alone with the
exception of Documentation/livepatch/system-state.rst, which was updated to
allow the cross-referencing to work correctly. The file now follows the
cross-referencing formatting guidance specified in
Documentation/doc-guide/kernel-doc.rst. Furthermore, some comments around
klp_shadow_free_all() were updated to say <_, id> rather than <*, id> to
match the rest of the file, and to prevent the docs build from emitting an
"Inline emphasis start-string without end string" error.

Signed-off-by: David Vernet <void@manifault.com>
---
v3:
  - Updated klp_shadow_free_all() comment updates to say <_, id> rather
    than <obj, id> (previously they were <*, id>, but this causes sphinx to
    either spit out an error during the docs build, or to incorrectly
    render text in italic).
  - Updated shadow-vars.rst to use <_, id> in its description of
    klp_shadow_free_all(), as sphinx was previously incorrectly rendering
    some text in italics when <*, id> was used.
  - Slightly updated the patch description to match the <_, id> change.
  - Added SPDX-License-Identifier tag to api.rst.

v2:
  - Updated patch description to not use markdown, and to use imperative
    language.
  - Added a new API page that exports all of the public livepatch functions
    and types.
  - Fixed klp_shadow_free_all() documentation to match the rest of the file
    and avoid an rst error.
  - Updated system-state.rst to properly cross-reference functions.

 Documentation/livepatch/api.rst          | 30 ++++++++++++++++++++++++
 Documentation/livepatch/index.rst        |  1 +
 Documentation/livepatch/shadow-vars.rst  |  4 ++--
 Documentation/livepatch/system-state.rst |  4 ++--
 kernel/livepatch/shadow.c                |  6 ++---
 5 files changed, 38 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/livepatch/api.rst

diff --git a/Documentation/livepatch/api.rst b/Documentation/livepatch/api.rst
new file mode 100644
index 000000000000..78944b63d74b
--- /dev/null
+++ b/Documentation/livepatch/api.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+Livepatching APIs
+=================
+
+Livepatch Enablement
+====================
+
+.. kernel-doc:: kernel/livepatch/core.c
+   :export:
+
+
+Shadow Variables
+================
+
+.. kernel-doc:: kernel/livepatch/shadow.c
+   :export:
+
+System State Changes
+====================
+
+.. kernel-doc:: kernel/livepatch/state.c
+   :export:
+
+Object Types
+============
+
+.. kernel-doc:: include/linux/livepatch.h
+   :identifiers: klp_patch klp_object klp_func klp_callbacks klp_state
diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index 43cce5fad705..cebf1c71d4a5 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -14,6 +14,7 @@ Kernel Livepatching
     shadow-vars
     system-state
     reliable-stacktrace
+    api
 
 .. only::  subproject and html
 
diff --git a/Documentation/livepatch/shadow-vars.rst b/Documentation/livepatch/shadow-vars.rst
index 6a7d43a8787d..7a7098bfb5c8 100644
--- a/Documentation/livepatch/shadow-vars.rst
+++ b/Documentation/livepatch/shadow-vars.rst
@@ -82,8 +82,8 @@ to do actions that can be done only once when a new variable is allocated.
       - call destructor function if defined
       - free shadow variable
 
-* klp_shadow_free_all() - detach and free all <*, id> shadow variables
-  - find and remove any <*, id> references from global hashtable
+* klp_shadow_free_all() - detach and free all <_, id> shadow variables
+  - find and remove any <_, id> references from global hashtable
 
     - if found
 
diff --git a/Documentation/livepatch/system-state.rst b/Documentation/livepatch/system-state.rst
index c6d127c2d9aa..7a3935fd812b 100644
--- a/Documentation/livepatch/system-state.rst
+++ b/Documentation/livepatch/system-state.rst
@@ -52,12 +52,12 @@ struct klp_state:
 
 The state can be manipulated using two functions:
 
-  - *klp_get_state(patch, id)*
+  - klp_get_state()
 
     - Get struct klp_state associated with the given livepatch
       and state id.
 
-  - *klp_get_prev_state(id)*
+  - klp_get_prev_state()
 
     - Get struct klp_state associated with the given feature id and
       already installed livepatches.
diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index e5c9fb295ba9..c2e724d97ddf 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -272,12 +272,12 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 EXPORT_SYMBOL_GPL(klp_shadow_free);
 
 /**
- * klp_shadow_free_all() - detach and free all <*, id> shadow variables
+ * klp_shadow_free_all() - detach and free all <_, id> shadow variables
  * @id:		data identifier
  * @dtor:	custom callback that can be used to unregister the variable
  *		and/or free data that the shadow variable points to (optional)
  *
- * This function releases the memory for all <*, id> shadow variable
+ * This function releases the memory for all <_, id> shadow variable
  * instances, callers should stop referencing them accordingly.
  */
 void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
@@ -288,7 +288,7 @@ void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 
 	spin_lock_irqsave(&klp_shadow_lock, flags);
 
-	/* Delete all <*, id> from hash */
+	/* Delete all <_, id> from hash */
 	hash_for_each(klp_shadow_hash, i, shadow, node) {
 		if (klp_shadow_match(shadow, shadow->obj, id))
 			klp_shadow_free_struct(shadow, dtor);
-- 
2.30.2

