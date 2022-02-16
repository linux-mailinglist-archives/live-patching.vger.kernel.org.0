Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B6F4B8E2B
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiBPQj7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:39:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbiBPQj7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:39:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C51FE25BD6B
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645029586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fep8h/a2rBAjVkyzxF4UU9KV97g8HyQ2x+dsEyK6TzU=;
        b=HpkZEOZSLLTcs25YIzpaMokc0tII2Ho8EnXoIE2KwRuO+WoWlecocsIP49qvqFUolAOi59
        VpBgxw17VzW2n0BRuekSbfHMkchEvLBBzshCYVKMV/zxgVjf9UPiQJyiQXWPtpxYgqxIB0
        3F5BhxHS/XmsdlMCyDjEE4D9XhV4/I0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-skYrovt2PWq2U_YM3oV2cg-1; Wed, 16 Feb 2022 11:39:44 -0500
X-MC-Unique: skYrovt2PWq2U_YM3oV2cg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F19E80D690;
        Wed, 16 Feb 2022 16:39:43 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C68C753D3;
        Wed, 16 Feb 2022 16:39:43 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [RFC PATCH v6 02/12] kbuild: Support for symbols.klp creation
Date:   Wed, 16 Feb 2022 11:39:30 -0500
Message-Id: <20220216163940.228309-3-joe.lawrence@redhat.com>
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Joao Moreira <jmoreira@suse.de>

For automatic resolution of livepatch relocations, a file called
symbols.klp is used. This file maps symbols within every compiled kernel
object allowing the identification of symbols whose name is unique, thus
relocation can be automatically inferred, or providing information that
helps developers when code annotation is required for solving the
matter.

Add support for creating symbols.klp in the main Makefile. First, ensure
that built-in is compiled when CONFIG_LIVEPATCH is enabled (as required
to achieve a complete symbols.klp file). Define the command to build
symbols.klp (cmd_klp_map) and hook it in the modules rule.

As it is undesirable to have symbols from livepatch objects inside
symbols.klp, make livepatches discernible by modifying
scripts/Makefile.build to create a .livepatch file for each livepatch in
$(MODVERDIR). This file then used by cmd_klp_map to identify and bypass
livepatches.

For identifying livepatches during the build process, a flag variable
LIVEPATCH_$(basetarget).o is considered in scripts/Makefile.build. This
way, set this flag for the livepatch sample Makefile in
samples/livepatch/Makefile.

Finally, Add a clean rule to ensure that symbols.klp is removed during
clean.

Notes:

To achieve a correct symbols.klp file, all kernel objects must be
considered, thus, its construction require these objects to be priorly
built. On the other hand, invoking scripts/Makefile.modpost without
having a complete symbols.klp in place would occasionally lead to
in-tree livepatches being post-processed incorrectly. To prevent this
from becoming a circular dependency, the construction of symbols.klp
uses non-post-processed kernel objects and such does not cause harm as
the symbols normally referenced from within livepatches are visible at
this stage. Also due to these requirements, the spot in-between modules
compilation and the invocation of scripts/Makefile.modpost was picked
for hooking cmd_klp_map.

The approach based on .livepatch files was proposed as an alternative to
using MODULE_INFO statements. This approach was originally proposed by
Miroslav Benes as a workaround for identifying livepathes without
depending on modinfo during the modpost stage. It was moved to this
patch as the approach also shown to be useful while building
symbols.klp.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 .gitignore             |  1 +
 Documentation/dontdiff |  1 +
 Makefile               | 24 ++++++++++++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7afd412dadd2..50638a15a527 100644
--- a/.gitignore
+++ b/.gitignore
@@ -61,6 +61,7 @@ modules.order
 /vmlinux.symvers
 /vmlinux-gdb.py
 /vmlinuz
+/symbols.klp
 /System.map
 /Module.markers
 /modules.builtin
diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 910b30a2a7d9..25c656fdd99f 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -76,6 +76,7 @@ Module.markers
 Module.symvers
 PENDING
 SCCS
+symbols.klp
 System.map*
 TAGS
 aconf
diff --git a/Makefile b/Makefile
index 0fb4f94a6885..64ec4bc8172c 100644
--- a/Makefile
+++ b/Makefile
@@ -639,8 +639,13 @@ KBUILD_MODULES :=
 KBUILD_BUILTIN := 1
 
 # If we have only "make modules", don't compile built-in objects.
+# When we're building livepatch modules, we need to consider the
+# built-in objects during the descend as well, as built-in objects may
+# hold symbols which are referenced from livepatches and are required by
+# klp-convert post-processing tool for resolving these cases.
+
 ifeq ($(MAKECMDGOALS),modules)
-  KBUILD_BUILTIN :=
+  KBUILD_BUILTIN := $(if $(CONFIG_LIVEPATCH),1)
 endif
 
 # If we have "make <whatever> modules", compile modules
@@ -1487,7 +1492,7 @@ MRPROPER_FILES += include/config include/generated          \
 		  arch/$(SRCARCH)/include/generated .tmp_objdiff \
 		  debian snap tar-install \
 		  .config .config.old .version \
-		  Module.symvers \
+		  Module.symvers symbols.klp \
 		  certs/signing_key.pem \
 		  certs/x509.genkey \
 		  vmlinux-gdb.py \
@@ -1742,7 +1747,22 @@ PHONY += modules modules_install
 
 ifdef CONFIG_MODULES
 
+quiet_cmd_klp_map = KLP     symbols.klp
+
+define cmd_klp_map
+	$(shell echo "klp-convert-symbol-data.0.1" > $(objtree)/symbols.klp)				\
+	$(shell echo "*vmlinux" >> $(objtree)/symbols.klp)						\
+	$(shell nm -f posix $(objtree)/vmlinux | cut -d\  -f1 >> $(objtree)/symbols.klp)		\
+	$(foreach ko, $(sort $(shell cat modules.order)),						\
+		$(eval mod = $(patsubst %.ko,%.mod,$(ko)))						\
+		$(eval obj = $(patsubst %.ko,%.o,$(ko)))						\
+		$(if $(shell grep -o LIVEPATCH $(mod)),,						\
+			$(shell echo "*$(shell basename -s .ko $(ko))" >> $(objtree)/symbols.klp)	\
+			$(shell nm -f posix $(obj) | cut -d\  -f1 >> $(objtree)/symbols.klp)))
+endef
+
 modules: modules_check
+	$(if $(CONFIG_LIVEPATCH), $(call cmd,klp_map))
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
 PHONY += modules_check
-- 
2.26.3

