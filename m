Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C756AC2C1
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCFOOO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCFONx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:13:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD893252A
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678111713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aTfeyHCszsMv9gyl7yv5PA648Uf9sQDoAl7w9f2+5CI=;
        b=eKdWm2kA2iirgMw6nSYRfI4WurUZgNT+ivK2TwOIJRQSqQK19YW0KLBSdV2+eTn4m7Oerk
        fptLlVRGRA0/MFIMk+zVtIAm1KdNRHbsmYUMqDLpY9XJ4pJ/sqPaUnMjqkiOE/At9lAawf
        LSf1G/WNgbYLcouzTtWcB22EscIjZXw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-oAIwZ54WPPO-lO6noN_p_Q-1; Mon, 06 Mar 2023 09:08:28 -0500
X-MC-Unique: oAIwZ54WPPO-lO6noN_p_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E81DB3810B0C;
        Mon,  6 Mar 2023 14:08:27 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A0E40C10FA;
        Mon,  6 Mar 2023 14:08:27 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 03/10] kbuild/modpost: create symbols.klp and integrate klp-convert
Date:   Mon,  6 Mar 2023 09:08:17 -0500
Message-Id: <20230306140824.3858543-4-joe.lawrence@redhat.com>
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

For automatic resolution of livepatch relocations, a file called
symbols.klp is used. This file maps symbols within every compiled kernel
object allowing the identification of symbols whose name is unique, thus
relocation can be automatically inferred, or providing information that
helps developers when code annotation is required for solving the
matter.

Add support for creating symbols.klp in the main Makefile. First, ensure
that built-in is compiled when CONFIG_LIVEPATCH is enabled (as required
to achieve a complete symbols.klp file). Define the command to build
symbols.klp (filechk_klp_map) and hook it in the modules rule. Save the
list of livepatch modules in $(MODULES_LIVEPATCH).

As it is undesirable to have symbols from livepatch objects inside
symbols.klp, filechk_klp_map filters out modules.livepatch from
modules.order: `sort $(MODORDER) $(MODULES_LIVEPATCH) | uniq -u`.

The "clean" Makefile target may remove the modules.livepatch file,
however, symbols.klp may be needed for building external modules, so
defer its cleanup to the "mrproper" target.

Finally, update the modpost program so that it does not warn about
unresolved symbols resolved by klp-convert.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 .gitignore                |  2 ++
 Documentation/dontdiff    |  1 +
 Makefile                  | 16 +++++++++++-----
 scripts/Makefile.modfinal | 33 +++++++++++++++++++++++++++++++++
 scripts/Makefile.modpost  |  5 +++++
 scripts/mod/modpost.c     | 28 ++++++++++++++++++++++++++--
 scripts/mod/modpost.h     |  1 +
 7 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/.gitignore b/.gitignore
index 20dce5c3b9e0..fc9b2f13b049 100644
--- a/.gitignore
+++ b/.gitignore
@@ -53,6 +53,7 @@
 *.xz
 *.zst
 Module.symvers
+modules.livepatch
 modules.order
 
 #
@@ -66,6 +67,7 @@ modules.order
 /vmlinux.symvers
 /vmlinux-gdb.py
 /vmlinuz
+/symbols.klp
 /System.map
 /Module.markers
 /modules.builtin
diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 352ff53a2306..23c2a89fb791 100644
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
index 3f6628780eb2..dd5d6c258906 100644
--- a/Makefile
+++ b/Makefile
@@ -730,8 +730,13 @@ KBUILD_MODULES :=
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
@@ -1183,6 +1188,7 @@ PHONY += prepare0
 export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
 export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
+export MODULES_LIVEPATCH := $(extmod-prefix)modules.livepatch
 
 ifeq ($(KBUILD_EXTMOD),)
 
@@ -1543,8 +1549,8 @@ endif
 #
 
 # *.ko are usually independent of vmlinux, but CONFIG_DEBUG_INFOBTF_MODULES
-# is an exception.
-ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+# and CONFIG_LIVEPATCH are exceptions.
+ifneq ($(or $(CONFIG_DEBUG_INFO_BTF_MODULES),$(CONFIG_LIVEPATCH)),)
 KBUILD_BUILTIN := 1
 modules: vmlinux
 endif
@@ -1602,14 +1608,14 @@ endif # CONFIG_MODULES
 CLEAN_FILES += include/ksym vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
 	       compile_commands.json .thinlto-cache rust/test rust/doc \
-	       .vmlinux.objs .vmlinux.export.c
+	       modules.livepatch .vmlinux.objs .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \
 		  arch/$(SRCARCH)/include/generated .objdiff \
 		  debian snap tar-install \
 		  .config .config.old .version \
-		  Module.symvers \
+		  Module.symvers symbols.klp \
 		  certs/signing_key.pem \
 		  certs/x509.genkey \
 		  vmlinux-gdb.py \
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index a30d5b08eee9..a8901e4e98c5 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -14,6 +14,7 @@ include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
 modules := $(call read-file, $(MODORDER))
+modules-klp := $(call read-file, $(MODULES_LIVEPATCH))
 
 __modfinal: $(modules:%.o=%.ko)
 	@:
@@ -65,6 +66,38 @@ endif
 
 targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o)
 
+# Livepatch
+# ---------------------------------------------------------------------------
+
+%.tmp.ko: %.o %.mod.o symbols.klp FORCE
+	+$(call if_changed,ld_ko_o)
+
+quiet_cmd_klp_convert = KLP     $@
+      cmd_klp_convert = scripts/livepatch/klp-convert symbols.klp $< $@
+
+$(modules-klp:%.o=%.ko): %.ko: %.tmp.ko FORCE
+	$(call if_changed,klp_convert)
+
+targets += $(modules-klp:.ko=.tmp.ko)
+
+ifeq ($(KBUILD_EXTMOD),)
+filechk_klp_map = \
+	echo "klp-convert-symbol-data.0.1";		\
+	echo "*vmlinux";				\
+	$(NM) -f posix vmlinux | cut -d\  -f1;		\
+	sort $(MODORDER) $(MODULES_LIVEPATCH) |		\
+	uniq -u |					\
+	sed 's/\.o$$//' |    			  	\
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
index 43343e13c542..02f1354d4cff 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -47,6 +47,7 @@ modpost-args =										\
 	$(if $(KBUILD_MODPOST_WARN),-w)							\
 	$(if $(KBUILD_NSDEPS),-d $(MODULES_NSDEPS))					\
 	$(if $(CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS)$(KBUILD_NSDEPS),-N)	\
+	$(if $(CONFIG_LIVEPATCH),-l $(MODULES_LIVEPATCH))				\
 	-o $@
 
 modpost-deps := $(MODPOST)
@@ -138,6 +139,10 @@ $(output-symdump): $(modpost-deps) FORCE
 	$(call if_changed,modpost)
 
 __modpost: $(output-symdump)
+ifndef CONFIG_LIVEPATCH
+	$(Q)rm -f $(MODULES_LIVEPATCH)
+	$(Q)touch $(MODULES_LIVEPATCH)
+endif
 PHONY += FORCE
 FORCE:
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index efff8078e395..0a8f0ce75761 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1831,6 +1831,10 @@ static void read_symbols(const char *modname)
 		handle_moddevtable(mod, &info, sym, symname);
 	}
 
+	/* Livepatch modules have unresolved symbols resolved by klp-convert */
+	if (get_modinfo(&info, "livepatch"))
+		mod->is_livepatch = true;
+
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
 		symname = remove_dot(info.strtab + sym->st_name);
 
@@ -1919,7 +1923,7 @@ static void check_exports(struct module *mod)
 		const char *basename;
 		exp = find_symbol(s->name);
 		if (!exp) {
-			if (!s->weak && nr_unresolved++ < MAX_UNRESOLVED_REPORTS)
+			if (!s->weak && !mod->is_livepatch && nr_unresolved++ < MAX_UNRESOLVED_REPORTS)
 				modpost_log(warn_unresolved ? LOG_WARN : LOG_ERROR,
 					    "\"%s\" [%s.ko] undefined!\n",
 					    s->name, mod->name);
@@ -2320,6 +2324,20 @@ static void write_namespace_deps_files(const char *fname)
 	free(ns_deps_buf.p);
 }
 
+static void write_livepatch_modules(const char *fname)
+{
+	struct buffer buf = { };
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->is_livepatch)
+			buf_printf(&buf, "%s.o\n", mod->name);
+	}
+
+	write_if_changed(&buf, fname);
+	free(buf.p);
+}
+
 struct dump_list {
 	struct list_head list;
 	const char *file;
@@ -2330,11 +2348,12 @@ int main(int argc, char **argv)
 	struct module *mod;
 	char *missing_namespace_deps = NULL;
 	char *dump_write = NULL, *files_source = NULL;
+	char *livepatch_modules = NULL;
 	int opt;
 	LIST_HEAD(dump_lists);
 	struct dump_list *dl, *dl2;
 
-	while ((opt = getopt(argc, argv, "ei:mnT:o:awENd:")) != -1) {
+	while ((opt = getopt(argc, argv, "ei:l:mnT:o:awENd:")) != -1) {
 		switch (opt) {
 		case 'e':
 			external_module = true;
@@ -2344,6 +2363,9 @@ int main(int argc, char **argv)
 			dl->file = optarg;
 			list_add_tail(&dl->list, &dump_lists);
 			break;
+		case 'l':
+			livepatch_modules = optarg;
+			break;
 		case 'm':
 			modversions = true;
 			break;
@@ -2403,6 +2425,8 @@ int main(int argc, char **argv)
 
 	if (dump_write)
 		write_dump(dump_write);
+	if (livepatch_modules)
+		write_livepatch_modules(livepatch_modules);
 	if (sec_mismatch_count && !sec_mismatch_warn_only)
 		error("Section mismatches detected.\n"
 		      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 1178f40a73f3..9be9bf6fb7da 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -119,6 +119,7 @@ struct module {
 	bool is_gpl_compatible;
 	bool from_dump;		/* true if module was loaded from *.symvers */
 	bool is_vmlinux;
+	bool is_livepatch;
 	bool seen;
 	bool has_init;
 	bool has_cleanup;
-- 
2.39.2

