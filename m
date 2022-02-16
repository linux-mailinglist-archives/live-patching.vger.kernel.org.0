Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71AE4B8E36
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbiBPQkH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:40:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiBPQkG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:40:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AB0B25D259
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645029590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TKJ0p6wUHLeEpT+OPHGiZq/Luk+QYBrrNwkFch9ANdQ=;
        b=Pp++ldWOeQTM2l9vtJ8AO9teinBeKifjRoSKTBXiUJoGrkZ4CmjRJpaS+4D353tir0Bi0u
        sFvO5w460JcEWTwMv617NWlRct+2ORLwACMC1lJYEFt/6bO5NT7cMrpxx7cjxRcJWCdlvE
        hBVjccWqclrXPVWMjl/GdX58htPrMO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-24erS44XMJKgxa43zlJSXA-1; Wed, 16 Feb 2022 11:39:46 -0500
X-MC-Unique: 24erS44XMJKgxa43zlJSXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C70331800D50;
        Wed, 16 Feb 2022 16:39:45 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54FAB753D3;
        Wed, 16 Feb 2022 16:39:45 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [RFC PATCH v6 05/12] modpost: Integrate klp-convert
Date:   Wed, 16 Feb 2022 11:39:33 -0500
Message-Id: <20220216163940.228309-6-joe.lawrence@redhat.com>
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
 .gitignore                |  1 +
 Makefile                  | 18 ++----------------
 scripts/Makefile.modfinal | 38 +++++++++++++++++++++++++++++++++++++-
 scripts/Makefile.modpost  |  5 +++++
 scripts/mod/modpost.c     | 28 ++++++++++++++++++++++++++--
 scripts/mod/modpost.h     |  1 +
 6 files changed, 72 insertions(+), 19 deletions(-)

diff --git a/.gitignore b/.gitignore
index 50638a15a527..eb0179d00260 100644
--- a/.gitignore
+++ b/.gitignore
@@ -48,6 +48,7 @@
 *.xz
 *.zst
 Module.symvers
+modules.livepatch
 modules.order
 
 #
diff --git a/Makefile b/Makefile
index 64ec4bc8172c..31d5b6f608d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1089,6 +1089,7 @@ PHONY += prepare0
 export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
 export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
+export MODULES_LIVEPATCH := $(extmod-prefix)modules.livepatch
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y			+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/
@@ -1485,7 +1486,7 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_FILES += include/ksym vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json .thinlto-cache
+	       compile_commands.json .thinlto-cache modules.livepatch
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \
@@ -1747,22 +1748,7 @@ PHONY += modules modules_install
 
 ifdef CONFIG_MODULES
 
-quiet_cmd_klp_map = KLP     symbols.klp
-
-define cmd_klp_map
-	$(shell echo "klp-convert-symbol-data.0.1" > $(objtree)/symbols.klp)				\
-	$(shell echo "*vmlinux" >> $(objtree)/symbols.klp)						\
-	$(shell nm -f posix $(objtree)/vmlinux | cut -d\  -f1 >> $(objtree)/symbols.klp)		\
-	$(foreach ko, $(sort $(shell cat modules.order)),						\
-		$(eval mod = $(patsubst %.ko,%.mod,$(ko)))						\
-		$(eval obj = $(patsubst %.ko,%.o,$(ko)))						\
-		$(if $(shell grep -o LIVEPATCH $(mod)),,						\
-			$(shell echo "*$(shell basename -s .ko $(ko))" >> $(objtree)/symbols.klp)	\
-			$(shell nm -f posix $(obj) | cut -d\  -f1 >> $(objtree)/symbols.klp)))
-endef
-
 modules: modules_check
-	$(if $(CONFIG_LIVEPATCH), $(call cmd,klp_map))
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
 PHONY += modules_check
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 7f39599e9fae..cb31262436ba 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -14,6 +14,8 @@ include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
 modules := $(sort $(shell cat $(MODORDER)))
+modules-klp := $(sort $(shell cat $(MODULES_LIVEPATCH)))
+modules-no-klp := $(filter-out $(modules-klp), $(modules))
 
 __modfinal: $(modules)
 	@:
@@ -56,7 +58,7 @@ if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
 
 
 # Re-generate module BTFs if either module's .ko or vmlinux changed
-$(modules): %.ko: %$(mod-prelink-ext).o %.mod.o scripts/module.lds $(if $(KBUILD_BUILTIN),vmlinux) FORCE
+$(modules-no-klp): %.ko: %$(mod-prelink-ext).o %.mod.o scripts/module.lds $(if $(KBUILD_BUILTIN),vmlinux) FORCE
 	+$(call if_changed_except,ld_ko_o,vmlinux)
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	+$(if $(newer-prereqs),$(call cmd,btf_ko))
@@ -64,6 +66,40 @@ endif
 
 targets += $(modules) $(modules:.ko=.mod.o)
 
+# Live Patch
+# ---------------------------------------------------------------------------
+
+%.tmp.ko: %.o %.mod.o symbols.klp FORCE
+	+$(call if_changed,ld_ko_o)
+
+quiet_cmd_klp_convert = KLP     $@
+      cmd_klp_convert = scripts/livepatch/klp-convert symbols.klp $< $@
+
+$(modules-klp): %.ko: %.tmp.ko FORCE
+	$(call if_changed,klp_convert)
+
+targets += $(modules-klp:.ko=.tmp.ko)
+
+ifeq ($(KBUILD_EXTMOD),)
+# Read out modules.{order,livepatch} instead of expanding $(modules-no-klp).
+# Otherwise, allmodconfig would fail with "Argument list too long".
+filechk_klp_map = \
+	echo "klp-convert-symbol-data.0.1";		\
+	echo "*vmlinux";				\
+	$(NM) -f posix vmlinux | cut -d\  -f1;		\
+	sort $(MODORDER) $(MODULES_LIVEPATCH) |		\
+	uniq -u |					\
+	sed 's/\.ko$$//' |    			  	\
+	while read o;					\
+	do						\
+		echo "*$$(basename $$o)";		\
+		$(NM) -f posix $$o.o | cut -d\  -f1;	\
+	done
+
+symbols.klp: FORCE
+	$(call filechk,klp_map)
+endif
+
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 48585c4d04ad..c5df629de7b2 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -48,6 +48,7 @@ MODPOST = scripts/mod/modpost								\
 	$(if $(CONFIG_MODVERSIONS),-m)							\
 	$(if $(CONFIG_MODULE_SRCVERSION_ALL),-a)					\
 	$(if $(CONFIG_SECTION_MISMATCH_WARN_ONLY),,-E)					\
+	$(if $(CONFIG_LIVEPATCH),-l $(MODULES_LIVEPATCH))				\
 	-o $@
 
 ifdef MODPOST_VMLINUX
@@ -136,6 +137,10 @@ $(output-symdump): $(MODORDER) $(input-symdump) $(modules:.ko=$(mod-prelink-ext)
 targets += $(output-symdump)
 
 __modpost: $(output-symdump)
+ifndef CONFIG_LIVEPATCH
+	$(Q)rm -f $(MODULES_LIVEPATCH)
+	$(Q)touch $(MODULES_LIVEPATCH)
+endif
 ifneq ($(KBUILD_MODPOST_NOFINAL),1)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal
 endif
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6bfa33217914..1034b673c95c 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2051,6 +2051,10 @@ static void read_symbols(const char *modname)
 		handle_moddevtable(mod, &info, sym, symname);
 	}
 
+	/* Livepatch modules have unresolved symbols resolved by klp-convert */
+	if (get_modinfo(&info, "livepatch"))
+		mod->livepatch = 1;
+
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
 		symname = remove_dot(info.strtab + sym->st_name);
 
@@ -2170,7 +2174,7 @@ static void check_exports(struct module *mod)
 		const char *basename;
 		exp = find_symbol(s->name);
 		if (!exp || exp->module == mod) {
-			if (!s->weak && nr_unresolved++ < MAX_UNRESOLVED_REPORTS)
+			if (!s->weak && !mod->livepatch && nr_unresolved++ < MAX_UNRESOLVED_REPORTS)
 				modpost_log(warn_unresolved ? LOG_WARN : LOG_ERROR,
 					    "\"%s\" [%s.ko] undefined!\n",
 					    s->name, mod->name);
@@ -2502,6 +2506,20 @@ static void write_namespace_deps_files(const char *fname)
 	free(ns_deps_buf.p);
 }
 
+static void write_livepatch_modules(const char *fname)
+{
+	struct buffer buf = { };
+	struct module *mod;
+
+	for (mod = modules; mod; mod = mod->next) {
+		if (mod->livepatch)
+			buf_printf(&buf, "%s.ko\n", mod->name);
+	}
+
+	write_if_changed(&buf, fname);
+	free(buf.p);
+}
+
 struct dump_list {
 	struct dump_list *next;
 	const char *file;
@@ -2513,12 +2531,13 @@ int main(int argc, char **argv)
 	struct buffer buf = { };
 	char *missing_namespace_deps = NULL;
 	char *dump_write = NULL, *files_source = NULL;
+	char *livepatch_modules = NULL;
 	int opt;
 	int n;
 	struct dump_list *dump_read_start = NULL;
 	struct dump_list **dump_read_iter = &dump_read_start;
 
-	while ((opt = getopt(argc, argv, "ei:mnT:o:awENd:")) != -1) {
+	while ((opt = getopt(argc, argv, "ei:l:mnT:o:awENd:")) != -1) {
 		switch (opt) {
 		case 'e':
 			external_module = 1;
@@ -2529,6 +2548,9 @@ int main(int argc, char **argv)
 			(*dump_read_iter)->file = optarg;
 			dump_read_iter = &(*dump_read_iter)->next;
 			break;
+		case 'l':
+			livepatch_modules = optarg;
+			break;
 		case 'm':
 			modversions = 1;
 			break;
@@ -2605,6 +2627,8 @@ int main(int argc, char **argv)
 
 	if (dump_write)
 		write_dump(dump_write);
+	if (livepatch_modules)
+		write_livepatch_modules(livepatch_modules);
 	if (sec_mismatch_count && !sec_mismatch_warn_only)
 		error("Section mismatches detected.\n"
 		      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0c47ff95c0e2..8c7e7e546158 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -123,6 +123,7 @@ struct module {
 	int seen;
 	int has_init;
 	int has_cleanup;
+	int livepatch;
 	struct buffer dev_table_buf;
 	char	     srcversion[25];
 	// Missing namespace dependencies
-- 
2.26.3

