Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18B718C17
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfEIOjl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfEIOjM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:12 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C68C3B718;
        Thu,  9 May 2019 14:39:12 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A612E5E7A6;
        Thu,  9 May 2019 14:39:11 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 05/10] modpost: Integrate klp-convert
Date:   Thu,  9 May 2019 10:38:54 -0400
Message-Id: <20190509143859.9050-6-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 09 May 2019 14:39:12 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

Create cmd_klp_convert and hook it into scripts/Makefile.modpost.
cmd_klp_convert invokes klp-convert with the right arguments for the
conversion of unresolved symbols inside a livepatch.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/Kbuild.include   |  4 +++-
 scripts/Makefile.modpost | 16 +++++++++++++++-
 scripts/mod/modpost.c    |  6 +++++-
 scripts/mod/modpost.h    |  1 +
 4 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 7484b9d8272f..f8b7d12e44c9 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -236,6 +236,8 @@ endif
 # (needed for the shell)
 make-cmd = $(call escsq,$(subst $(pound),$$(pound),$(subst $$,$$$$,$(cmd_$(1)))))
 
+save-cmd = printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd
+
 # Find any prerequisites that is newer than target or that does not exist.
 # PHONY targets skipped in both cases.
 any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
@@ -243,7 +245,7 @@ any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 # Execute command if command has changed or prerequisite(s) are updated.
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
 	$(cmd);                                                              \
-	printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
+	$(save-cmd), @:)
 
 # Execute the command and also postprocess generated .d dependencies file.
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),$(cmd_and_fixdep),@:)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 6b7f354f189a..1bef611f99b6 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -124,8 +124,22 @@ quiet_cmd_ld_ko_o = LD [M]  $@
                  -o $@ $(real-prereqs) ;                                \
 	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
 
+SLIST = $(objtree)/Symbols.list
+KLP_CONVERT = scripts/livepatch/klp-convert
+quiet_cmd_klp_convert = KLP     $@
+      cmd_klp_convert = mv $@ $(@:.ko=.klp.o);				\
+			$(KLP_CONVERT) $(SLIST) $(@:.ko=.klp.o) $@
+
+define rule_ld_ko_o
+	$(Q)$(call echo-cmd,ld_ko_o) $(cmd_ld_ko_o) ;			\
+	$(call save-cmd,ld_ko_o) ;					\
+	$(if $(CONFIG_LIVEPATCH),					\
+	  $(if $(wildcard $(MODVERDIR)/$(basetarget).livepatch),	\
+	    $(call echo-cmd,klp_convert) $(cmd_klp_convert) ))
+endef
+
 $(modules): %.ko :%.o %.mod.o FORCE
-	+$(call if_changed,ld_ko_o)
+	+$(call if_changed_rule,ld_ko_o)
 
 targets += $(modules)
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f277e116e0eb..374b22c76ec5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1974,6 +1974,10 @@ static void read_symbols(const char *modname)
 		license = get_next_modinfo(&info, "license", license);
 	}
 
+	/* Livepatch modules have unresolved symbols resolved by klp-convert */
+	if (get_modinfo(&info, "livepatch"))
+		mod->livepatch = 1;
+
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
 		symname = remove_dot(info.strtab + sym->st_name);
 
@@ -2101,7 +2105,7 @@ static int check_exports(struct module *mod)
 		const char *basename;
 		exp = find_symbol(s->name);
 		if (!exp || exp->module == mod) {
-			if (have_vmlinux && !s->weak) {
+			if (have_vmlinux && !s->weak && !mod->livepatch) {
 				if (warn_unresolved) {
 					warn("\"%s\" [%s.ko] undefined!\n",
 					     s->name, mod->name);
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 8453d6ac2f77..2acfaae064ec 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -118,6 +118,7 @@ struct module {
 	int skip;
 	int has_init;
 	int has_cleanup;
+	int livepatch;
 	struct buffer dev_table_buf;
 	char	     srcversion[25];
 	int is_dot_o;
-- 
2.20.1

