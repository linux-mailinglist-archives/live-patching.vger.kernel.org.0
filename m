Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15BA18C15
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfEIOjK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfEIOjK (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:10 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 849658124B;
        Thu,  9 May 2019 14:39:09 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED1DC17AEA;
        Thu,  9 May 2019 14:39:08 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 02/10] kbuild: Support for Symbols.list creation
Date:   Thu,  9 May 2019 10:38:51 -0400
Message-Id: <20190509143859.9050-3-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 09 May 2019 14:39:09 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Joao Moreira <jmoreira@suse.de>

For automatic resolution of livepatch relocations, a file called
Symbols.list is used. This file maps symbols within every compiled
kernel object allowing the identification of symbols whose name is
unique, thus relocation can be automatically inferred, or providing
information that helps developers when code annotation is required for
solving the matter.

Add support for creating Symbols.list in the main Makefile. First,
ensure that built-in is compiled when CONFIG_LIVEPATCH is enabled (as
required to achieve a complete Symbols.list file). Define the command to
build Symbols.list (cmd_klp_map) and hook it in the modules rule.

As it is undesirable to have symbols from livepatch objects inside
Symbols.list, make livepatches discernible by modifying
scripts/Makefile.build to create a .livepatch file for each livepatch
in $(MODVERDIR). This file then used by cmd_klp_map to identify and
bypass livepatches.

For identifying livepatches during the build process, a flag variable
LIVEPATCH_$(basetarget).o is considered in scripts/Makefile.build. This
way, set this flag for the livepatch sample Makefile in
samples/livepatch/Makefile.

Finally, Add a clean rule to ensure that Symbols.list is removed during
clean.

Notes:

To achieve a correct Symbols.list file, all kernel objects must be
considered, thus, its construction require these objects to be priorly
built. On the other hand, invoking scripts/Makefile.modpost without
having a complete Symbols.list in place would occasionally lead to
in-tree livepatches being post-processed incorrectly. To prevent this
from becoming a circular dependency, the construction of Symbols.list
uses non-post-processed kernel objects and such does not cause harm as
the symbols normally referenced from within livepatches are visible at
this stage. Also due to these requirements, the spot in-between modules
compilation and the invocation of scripts/Makefile.modpost was picked
for hooking cmd_klp_map.

The approach based on .livepatch files was proposed as an alternative
to using MODULE_INFO statements. This approach was originally
proposed by Miroslav Benes as a workaround for identifying livepathes
without depending on modinfo during the modpost stage. It was moved to
this patch as the approach also shown to be useful while building
Symbols.list.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 .gitignore                 |  1 +
 Makefile                   | 30 ++++++++++++++++++++++++++----
 lib/livepatch/Makefile     |  5 +++++
 samples/livepatch/Makefile |  4 ++++
 scripts/Makefile.build     |  7 +++++++
 5 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index a20ac26aa2f5..5cd5758f5ffe 100644
--- a/.gitignore
+++ b/.gitignore
@@ -45,6 +45,7 @@
 *.xz
 Module.symvers
 modules.builtin
+Symbols.list
 
 #
 # Top-level generic files
diff --git a/Makefile b/Makefile
index abe13538a8c0..98089f9d44fe 100644
--- a/Makefile
+++ b/Makefile
@@ -574,10 +574,13 @@ KBUILD_BUILTIN := 1
 # If we have only "make modules", don't compile built-in objects.
 # When we're building modules with modversions, we need to consider
 # the built-in objects during the descend as well, in order to
-# make sure the checksums are up to date before we record them.
+# make sure the checksums are up to date before we record them. The
+# same applies for building livepatches, as built-in objects may hold
+# symbols which are referenced from livepatches and are required by
+# klp-convert post-processing tool for resolving these cases.
 
 ifeq ($(MAKECMDGOALS),modules)
-  KBUILD_BUILTIN := $(if $(CONFIG_MODVERSIONS),1)
+  KBUILD_BUILTIN := $(if $(or $(CONFIG_MODVERSIONS), $(CONFIG_LIVEPATCH)),1)
 endif
 
 # If we have "make <whatever> modules", compile modules
@@ -1261,9 +1264,25 @@ all: modules
 # duplicate lines in modules.order files.  Those are removed
 # using awk while concatenating to the final file.
 
+quiet_cmd_klp_map = KLP     Symbols.list
+SLIST = $(objtree)/Symbols.list
+
+define cmd_klp_map
+	$(shell echo "klp-convert-symbol-data.0.1" > $(SLIST))				\
+	$(shell echo "*vmlinux" >> $(SLIST))						\
+	$(shell nm -f posix $(objtree)/vmlinux | cut -d\  -f1 >> $(SLIST))		\
+	$(foreach m, $(wildcard $(MODVERDIR)/*.mod),					\
+		$(eval mod = $(patsubst %.ko,%.o,$(shell head -n1 $(m))))		\
+		$(if $(wildcard $(MODVERDIR)/$(shell basename -s .o $(mod)).livepatch),,\
+			$(eval fmod = $(subst $(quote),_,$(subst -,_,$(mod))))		\
+			$(shell echo "*$(shell basename -s .o $(fmod))" >> $(SLIST))	\
+			$(shell nm -f posix $(mod) | cut -d\  -f1 >> $(SLIST))))
+endef
+
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
+	$(if $(CONFIG_LIVEPATCH), $(call cmd,klp_map))
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
@@ -1350,7 +1369,7 @@ clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
 clean-dirs      := $(addprefix _clean_, . $(vmlinux-alldirs) Documentation samples)
 
-PHONY += $(clean-dirs) clean archclean vmlinuxclean
+PHONY += $(clean-dirs) clean archclean vmlinuxclean klpclean
 $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
@@ -1358,7 +1377,10 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean
+klpclean:
+	$(Q) rm -f $(SLIST)
+
+clean: archclean vmlinuxclean klpclean
 
 # mrproper - Delete all generated files, including .config
 #
diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index 26900ddaef82..513d200b7942 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -2,6 +2,11 @@
 #
 # Makefile for livepatch test code.
 
+LIVEPATCH_test_klp_atomic_replace := y
+LIVEPATCH_test_klp_callbacks_demo := y
+LIVEPATCH_test_klp_callbacks_demo2 := y
+LIVEPATCH_test_klp_livepatch := y
+
 obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_demo.o \
 				test_klp_callbacks_demo2.o \
diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 2472ce39a18d..514c8156f979 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -1,3 +1,7 @@
+LIVEPATCH_livepatch-sample := y
+LIVEPATCH_livepatch-shadow-fix1 := y
+LIVEPATCH_livepatch-shadow-fix2 := y
+LIVEPATCH_livepatch-callbacks-demo := y
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-sample.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix1.o
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 76ca30cc4791..2d8adefd12a5 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -246,6 +246,11 @@ cmd_gen_ksymdeps = \
 	$(CONFIG_SHELL) $(srctree)/scripts/gen_ksymdeps.sh $@ >> $(dot-target).cmd
 endif
 
+ifdef CONFIG_LIVEPATCH
+cmd_livepatch = $(if $(LIVEPATCH_$(basetarget)),		\
+	$(shell touch $(MODVERDIR)/$(basetarget).livepatch))
+endif
+
 define rule_cc_o_c
 	$(call cmd,checksrc)
 	$(call cmd_and_fixdep,cc_o_c)
@@ -280,6 +285,7 @@ $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
 $(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,livepatch)
 	@{ echo $(@:.o=.ko); echo $@; \
 	   $(cmd_undef_syms); } > $(MODVERDIR)/$(@F:.o=.mod)
 
@@ -456,6 +462,7 @@ cmd_link_multi-m = $(LD) $(ld_flags) -r -o $@ $(filter %.o,$^) $(cmd_secanalysis
 
 $(multi-used-m): FORCE
 	$(call if_changed,link_multi-m)
+	$(call cmd,livepatch)
 	@{ echo $(@:.o=.ko); echo $(filter %.o,$^); \
 	   $(cmd_undef_syms); } > $(MODVERDIR)/$(@F:.o=.mod)
 $(call multi_depend, $(multi-used-m), .o, -objs -y -m)
-- 
2.20.1

