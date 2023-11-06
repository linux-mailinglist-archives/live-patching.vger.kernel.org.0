Return-Path: <live-patching+bounces-19-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B267E29B2
	for <lists+live-patching@lfdr.de>; Mon,  6 Nov 2023 17:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EDCEB20C0A
	for <lists+live-patching@lfdr.de>; Mon,  6 Nov 2023 16:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A0A29411;
	Mon,  6 Nov 2023 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BYCt7Zol";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RgKteR/X"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A8529406
	for <live-patching@vger.kernel.org>; Mon,  6 Nov 2023 16:26:29 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41035D61;
	Mon,  6 Nov 2023 08:26:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 02E7B21FB4;
	Mon,  6 Nov 2023 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1699287986; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qQC+yT0ezcHJorVXO9EJ8y5donvmxPtq16gVI5ymBI=;
	b=BYCt7ZolC1tP9hx/35SOKU7RNXv6l0AvSscbssdHROp0m0KSHmXRXs99ScidnRoGwZbqSw
	lsv3BQDqDb4rxBKo1Av74h1JJJhnGgCm1mIRoRok21vWjjKl6EwKruXEE/SpL9mCRcW0XT
	ExiEhvfW2Zkw8rzJ0KRjCdhOoK/Yvr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1699287986;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qQC+yT0ezcHJorVXO9EJ8y5donvmxPtq16gVI5ymBI=;
	b=RgKteR/XYKc342oPjcmGCRhYPzNSo4YovBsozgLlHiGsYlHwR0ODL7kSidDjLtR8q9bBWF
	N2y62RenmJ6o5fDQ==
Received: from localhost.cz (lhruska.udp.ovpn2.prg.suse.de [10.100.204.118])
	by relay2.suse.de (Postfix) with ESMTP id 964F82D119;
	Mon,  6 Nov 2023 16:26:25 +0000 (UTC)
From: Lukas Hruska <lhruska@suse.cz>
To: Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Lukas Hruska <lhruska@suse.cz>
Subject: [PATCH v1 3/5] kbuild/modpost: integrate klp-convert
Date: Mon,  6 Nov 2023 17:25:11 +0100
Message-ID: <20231106162513.17556-4-lhruska@suse.cz>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106162513.17556-1-lhruska@suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@redhat.com>

Update the modpost program so that it does not warn about unresolved
symbols matching the expected format which will be then resolved by
klp-convert.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Lukas Hruska <lhruska@suse.cz>
---
 .gitignore                |  1 +
 Makefile                  | 10 ++++++----
 scripts/Makefile.modfinal | 15 +++++++++++++++
 scripts/Makefile.modpost  |  5 +++++
 scripts/mod/modpost.c     | 36 ++++++++++++++++++++++++++++++++++--
 scripts/mod/modpost.h     |  3 +++
 6 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index 9fd4c9533b3d..628caf76b617 100644
--- a/.gitignore
+++ b/.gitignore
@@ -69,6 +69,7 @@ modules.order
 /Module.markers
 /modules.builtin
 /modules.builtin.modinfo
+/modules.livepatch
 /modules.nsdeps
 
 #
diff --git a/Makefile b/Makefile
index 2fdd8b40b7e0..459b9c9fe0a8 100644
--- a/Makefile
+++ b/Makefile
@@ -1185,6 +1185,7 @@ PHONY += prepare0
 export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
 export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
+export MODULES_LIVEPATCH := $(extmod-prefix)modules.livepatch
 
 ifeq ($(KBUILD_EXTMOD),)
 
@@ -1535,8 +1536,8 @@ endif
 #
 
 # *.ko are usually independent of vmlinux, but CONFIG_DEBUG_INFO_BTF_MODULES
-# is an exception.
-ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+# and CONFIG_LIVEPATCH are exceptions.
+ifneq ($(or $(CONFIG_DEBUG_INFO_BTF_MODULES),$(CONFIG_LIVEPATCH)),)
 KBUILD_BUILTIN := 1
 modules: vmlinux
 endif
@@ -1595,8 +1596,9 @@ endif
 # Directories & files removed with 'make clean'
 CLEAN_FILES += include/ksym vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json .thinlto-cache rust/test rust/doc \
-	       rust-project.json .vmlinux.objs .vmlinux.export.c
+	       modules.livepatch compile_commands.json .thinlto-cache \
+	       rust/test rust/doc rust-project.json .vmlinux.objs \
+	       .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index fc19f67039bd..155d07476a2c 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -14,6 +14,7 @@ include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
 modules := $(call read-file, $(MODORDER))
+modules-klp := $(call read-file, $(MODULES_LIVEPATCH))
 
 __modfinal: $(modules:%.o=%.ko)
 	@:
@@ -65,6 +66,20 @@ endif
 
 targets += $(modules:%.o=%.ko) $(modules:%.o=%.mod.o)
 
+# Livepatch
+# ---------------------------------------------------------------------------
+
+%.tmp.ko: %.o %.mod.o FORCE
+	+$(call if_changed,ld_ko_o)
+
+quiet_cmd_klp_convert = KLP     $@
+      cmd_klp_convert = scripts/livepatch/klp-convert $< $@
+
+$(modules-klp:%.o=%.ko): %.ko: %.tmp.ko FORCE
+	$(call if_changed,klp_convert)
+
+targets += $(modules-klp:.ko=.tmp.ko)
+
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 39472e834b63..c757f5eddc3e 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -47,6 +47,7 @@ modpost-args =										\
 	$(if $(KBUILD_MODPOST_WARN),-w)							\
 	$(if $(KBUILD_NSDEPS),-d $(MODULES_NSDEPS))					\
 	$(if $(CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS)$(KBUILD_NSDEPS),-N)	\
+	$(if $(CONFIG_LIVEPATCH),-l $(MODULES_LIVEPATCH))				\
 	$(if $(findstring 1, $(KBUILD_EXTRA_WARN)),-W)					\
 	-o $@
 
@@ -144,6 +145,10 @@ $(output-symdump): $(modpost-deps) FORCE
 	$(call if_changed,modpost)
 
 __modpost: $(output-symdump)
+ifndef CONFIG_LIVEPATCH
+	$(Q)rm -f $(MODULES_LIVEPATCH)
+	$(Q)touch $(MODULES_LIVEPATCH)
+endif
 PHONY += FORCE
 FORCE:
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b29b29707f10..f6afa2e10601 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1733,6 +1733,10 @@ static void read_symbols(const char *modname)
 		}
 	}
 
+	/* Livepatch modules have unresolved symbols resolved by klp-convert */
+	if (get_modinfo(&info, "livepatch"))
+		mod->is_livepatch = true;
+
 	if (extra_warn && !get_modinfo(&info, "description"))
 		warn("missing MODULE_DESCRIPTION() in %s\n", modname);
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
@@ -1821,10 +1825,18 @@ static void check_exports(struct module *mod)
 		const char *basename;
 		exp = find_symbol(s->name);
 		if (!exp) {
-			if (!s->weak && nr_unresolved++ < MAX_UNRESOLVED_REPORTS)
+			if (!s->weak && nr_unresolved++ < MAX_UNRESOLVED_REPORTS) {
+				/*
+				 * In case of livepatch module we allow
+				 * unresolved symbol with a specific format
+				 */
+				if (mod->is_livepatch &&
+				    strncmp(s->name, KLP_SYM_RELA, strlen(KLP_SYM_RELA)) == 0)
+					break;
 				modpost_log(warn_unresolved ? LOG_WARN : LOG_ERROR,
 					    "\"%s\" [%s.ko] undefined!\n",
 					    s->name, mod->name);
+			}
 			continue;
 		}
 		if (exp->module == mod) {
@@ -2257,6 +2269,20 @@ static void write_namespace_deps_files(const char *fname)
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
@@ -2268,11 +2294,12 @@ int main(int argc, char **argv)
 	char *missing_namespace_deps = NULL;
 	char *unused_exports_white_list = NULL;
 	char *dump_write = NULL, *files_source = NULL;
+	char *livepatch_modules = NULL;
 	int opt;
 	LIST_HEAD(dump_lists);
 	struct dump_list *dl, *dl2;
 
-	while ((opt = getopt(argc, argv, "ei:mnT:to:au:WwENd:")) != -1) {
+	while ((opt = getopt(argc, argv, "ei:l:mnT:to:au:WwENd:")) != -1) {
 		switch (opt) {
 		case 'e':
 			external_module = true;
@@ -2282,6 +2309,9 @@ int main(int argc, char **argv)
 			dl->file = optarg;
 			list_add_tail(&dl->list, &dump_lists);
 			break;
+		case 'l':
+			livepatch_modules = optarg;
+			break;
 		case 'm':
 			modversions = true;
 			break;
@@ -2361,6 +2391,8 @@ int main(int argc, char **argv)
 
 	if (dump_write)
 		write_dump(dump_write);
+	if (livepatch_modules)
+		write_livepatch_modules(livepatch_modules);
 	if (sec_mismatch_count && !sec_mismatch_warn_only)
 		error("Section mismatches detected.\n"
 		      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index dfdb9484e325..7cb8d604d739 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -98,6 +98,8 @@ static inline void __endian(const void *src, void *dest, unsigned int size)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
+#define KLP_SYM_RELA ".klp.sym.rela."
+
 void *do_nofail(void *ptr, const char *expr);
 
 struct buffer {
@@ -119,6 +121,7 @@ struct module {
 	bool is_gpl_compatible;
 	bool from_dump;		/* true if module was loaded from *.symvers */
 	bool is_vmlinux;
+	bool is_livepatch;
 	bool seen;
 	bool has_init;
 	bool has_cleanup;
-- 
2.42.0


