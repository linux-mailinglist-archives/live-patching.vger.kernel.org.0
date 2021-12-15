Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D89475FB6
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 18:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbhLORsH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 12:48:07 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:33558 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbhLORsH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 12:48:07 -0500
Received: by mail-qt1-f173.google.com with SMTP id n15so22687075qta.0;
        Wed, 15 Dec 2021 09:48:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPWFiRughlj0qb1f5SfsJbJyzZlG3rBdu9sEjzdKYH8=;
        b=jEbi6y6iVmMOiro5q29/vnfrhSqlgx0arg362PiHBZxPDzO2Od2ydc3tryrX01xwnA
         bop3IE8ap7ntGJRwPW0UDvp3s7aoesrB0G9fARhoU9lGdE+T2HOgtD1xUU2y/PSRt7un
         JWL6pPIQVModZPdz9jQypSpZndMACU/21rvwVOEmxZ+F7A+MvHrL3/4OI+OwbiZsaqnd
         Np4fPf0mdsVbuJ6xPITS/8b7tSGXZPy931K8i+ANGYWI4iA8+E6yZWy2wFMS2mOBU1yf
         np08JD7pGatR/02Vz+QPxpulgUM/jRk8v6VSGvb5Skcm35KkqnCzvKQnYGJ+46oSNBWr
         WEGg==
X-Gm-Message-State: AOAM531cmYT+ddqXTPhItEa3j59J7BuLCA0Lq3/wd5i6GCSwpZMEVJ6I
        pn5VfQ1t1iZ4NP9njGPbrznVYT3JQBNzYA==
X-Google-Smtp-Source: ABdhPJyy/4QQQiy2zyPGB3HlzE9c4ZpEtAmdqAqe2e8Y9JX9tkGpv2B46q7inezn0coSPNEH1DTJ0w==
X-Received: by 2002:ac8:5cce:: with SMTP id s14mr13127346qta.349.1639590485900;
        Wed, 15 Dec 2021 09:48:05 -0800 (PST)
Received: from localhost (fwdproxy-ash-119.fbsv.net. [2a03:2880:20ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id y18sm2076066qtx.19.2021.12.15.09.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 09:48:05 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     pmladek@suse.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com
Subject: [PATCH v2] Documentation: livepatch: Add livepatch API page
Date:   Wed, 15 Dec 2021 09:47:00 -0800
Message-Id: <20211215174659.2332589-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch subsystem has several exported functions and objects with
kerneldoc comments. Though the livepatch documentation contains
handwritten descriptions of all of these exported functions, they are
currently not pulled into the docs build using the kernel-doc directive.

In order to allow readers of the documentation to see the full kerneldoc
comments in the generated documentation files, this change adds a new
Documentation/livepatch/api.rst page which contains kernel-doc
directives to link the kerneldoc comments directly in the documentation.
With this, all of the hand-written descriptions of the APIs now
cross-reference the kerneldoc comments on the new Livepatching APIs
page, and running ./scripts/find-unused-docs.sh on kernel/livepatch no
longer shows any files as missing documentation.

Note that all of the handwritten API descriptions were left alone with
the exception of Documentation/livepatch/system-state.rst, which was
updated to allow the cross-referencing to work correctly. The file now
follows the cross-referencing formatting guidance specified in
Documentation/doc-guide/kernel-doc.rst. Furthermore, some comments
around klp_shadow_free_all() were updated to say <obj, id> rather than
<*, id> to match the rest of the file, and to prevent the docs build
from emitting an "Inline emphasis start-string without end string"
error.

Signed-off-by: David Vernet <void@manifault.com>
---
v2:
  - Updated patch description to not use markdown, and to use imperative
    language.
  - Added a new API page that exports all of the public livepatch functions and
    types.
  - Fixed klp_shadow_free_all() documentation to match the rest of the file and
    avoid an rst error.
  - Updated system-state.rst to properly cross-reference functions.

 Documentation/livepatch/api.rst          | 28 ++++++++++++++++++++++++
 Documentation/livepatch/index.rst        |  1 +
 Documentation/livepatch/system-state.rst |  4 ++--
 kernel/livepatch/shadow.c                |  6 ++---
 4 files changed, 34 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/livepatch/api.rst

diff --git a/Documentation/livepatch/api.rst b/Documentation/livepatch/api.rst
new file mode 100644
index 000000000000..8c71b5bd73e8
--- /dev/null
+++ b/Documentation/livepatch/api.rst
@@ -0,0 +1,28 @@
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
index e5c9fb295ba9..4c6617aadf87 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -272,12 +272,12 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 EXPORT_SYMBOL_GPL(klp_shadow_free);
 
 /**
- * klp_shadow_free_all() - detach and free all <*, id> shadow variables
+ * klp_shadow_free_all() - detach and free all <obj, id> shadow variables
  * @id:		data identifier
  * @dtor:	custom callback that can be used to unregister the variable
  *		and/or free data that the shadow variable points to (optional)
  *
- * This function releases the memory for all <*, id> shadow variable
+ * This function releases the memory for all <obj, id> shadow variable
  * instances, callers should stop referencing them accordingly.
  */
 void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
@@ -288,7 +288,7 @@ void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 
 	spin_lock_irqsave(&klp_shadow_lock, flags);
 
-	/* Delete all <*, id> from hash */
+	/* Delete all <obj, id> from hash */
 	hash_for_each(klp_shadow_hash, i, shadow, node) {
 		if (klp_shadow_match(shadow, shadow->obj, id))
 			klp_shadow_free_struct(shadow, dtor);
-- 
2.30.2

