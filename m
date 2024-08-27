Return-Path: <live-patching+bounces-521-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 754CF960A5B
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A7FA1C22C9F
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD221BBBC8;
	Tue, 27 Aug 2024 12:31:05 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1A31BAED5;
	Tue, 27 Aug 2024 12:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761865; cv=none; b=SrATLnVvsgwo0oXDnY0daHazKgW71Owz2/5kcLtIR1fQGUMi/ORpZR6c4aJ94LKaKGpV6fkuVM/4BPu3QooJUgllDm7SMHTuezR0FgcVVdNW2g2zwXE5t6KRBfyUrYKAKxjQX8vd9zabWacm0z5EXjSSUT/OKymG/sLK0eDEI9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761865; c=relaxed/simple;
	bh=X9NRutIm8+4J/CZ3dI6niYacD/QnIyc8FLn4vlrePHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Py9mWORcTXQt+DZn5Jh5+JsO/PDqXNPXf/eUZk7Gy+eQN08hmbCVUTopvkV6kJYQs2HGCj9/h2IMPbylKnXrDpZzmWhla3ntCcoaaIg/A7iAf1x8byS0sLzboQHbgRe8BXxeI44vrIHXpn691jLHTAP3SCAWuHPL8DzX8LTcXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C5BAA21B19;
	Tue, 27 Aug 2024 12:31:01 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDC5113724;
	Tue, 27 Aug 2024 12:31:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SiBTLgXHzWa8YwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:31:01 +0000
From: Lukas Hruska <lhruska@suse.cz>
To: pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org
Cc: joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com,
	lhruska@suse.cz,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v3 3/6] kbuild/modpost: integrate klp-convert
Date: Tue, 27 Aug 2024 14:30:48 +0200
Message-ID: <20240827123052.9002-4-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240827123052.9002-1-lhruska@suse.cz>
References: <20240827123052.9002-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: C5BAA21B19
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

Call klp-convert for the livepatch modules after the final linking.

Also update the modpost tool so that it does not warn about unresolved
symbols matching the expected format which will be then resolved by
klp-convert.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Lukas Hruska <lhruska@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 .gitignore                |  1 +
 Makefile                  |  7 ++++---
 scripts/Makefile.modfinal | 15 +++++++++++++++
 scripts/Makefile.modpost  |  5 +++++
 scripts/mod/modpost.c     | 36 ++++++++++++++++++++++++++++++++++--
 scripts/mod/modpost.h     |  3 +++
 6 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7902adf4f7f1..2a66d0e66ad4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -70,6 +70,7 @@ modules.order
 /Module.markers
 /modules.builtin
 /modules.builtin.modinfo
+/modules.livepatch
 /modules.nsdeps
 
 #
diff --git a/Makefile b/Makefile
index 7b60eb103c5d..8cec35f3ef8c 100644
--- a/Makefile
+++ b/Makefile
@@ -1091,6 +1091,7 @@ PHONY += prepare0
 export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
 export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
+export MODULES_LIVEPATCH := $(extmod_prefix)modules.livepatch
 
 ifeq ($(KBUILD_EXTMOD),)
 
@@ -1458,8 +1459,8 @@ endif
 #
 
 # *.ko are usually independent of vmlinux, but CONFIG_DEBUG_INFO_BTF_MODULES
-# is an exception.
-ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+# and CONFIG_LIVEPATCH are exceptions.
+ifneq ($(or $(CONFIG_DEBUG_INFO_BTF_MODULES),$(CONFIG_LIVEPATCH)),)
 KBUILD_BUILTIN := 1
 modules: vmlinux
 endif
@@ -1482,7 +1483,7 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_FILES += vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json rust/test \
+	       modules.livepatch compile_commands.json rust/test \
 	       rust-project.json .vmlinux.objs .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 306a6bb86e4d..ace8e81c710d 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -14,6 +14,7 @@ include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
 modules := $(call read-file, $(MODORDER))
+modules-klp := $(call read-file, $(MODULES_LIVEPATCH))
 
 __modfinal: $(modules:%.o=%.ko)
 	@:
@@ -62,6 +63,20 @@ endif
 
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
 # Add FORCE to the prerequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 44936ebad161..b44a46aed274 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -48,6 +48,7 @@ modpost-args =										\
 	$(if $(KBUILD_MODPOST_WARN),-w)							\
 	$(if $(KBUILD_NSDEPS),-d $(MODULES_NSDEPS))					\
 	$(if $(CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS)$(KBUILD_NSDEPS),-N)	\
+	$(if $(CONFIG_LIVEPATCH),-l $(MODULES_LIVEPATCH))				\
 	$(if $(findstring 1, $(KBUILD_EXTRA_WARN)),-W)					\
 	-o $@
 
@@ -145,6 +146,10 @@ $(output-symdump): $(modpost-deps) FORCE
 	$(call if_changed,modpost)
 
 __modpost: $(output-symdump)
+ifndef CONFIG_LIVEPATCH
+	$(Q)rm -f $(MODULES_LIVEPATCH)
+	$(Q)touch $(MODULES_LIVEPATCH)
+endif
 PHONY += FORCE
 FORCE:
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index d16d0ace2775..ee2a51915bb1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1590,6 +1590,10 @@ static void read_symbols(const char *modname)
 			warn("missing MODULE_DESCRIPTION() in %s\n", modname);
 	}
 
+	/* Livepatch modules have unresolved symbols resolved by klp-convert */
+	if (get_modinfo(&info, "livepatch"))
+		mod->is_livepatch = true;
+
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
 		symname = remove_dot(info.strtab + sym->st_name);
 
@@ -1676,10 +1680,18 @@ static void check_exports(struct module *mod)
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
@@ -2112,6 +2124,20 @@ static void write_namespace_deps_files(const char *fname)
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
@@ -2123,11 +2149,12 @@ int main(int argc, char **argv)
 	char *missing_namespace_deps = NULL;
 	char *unused_exports_white_list = NULL;
 	char *dump_write = NULL, *files_source = NULL;
+	char *livepatch_modules = NULL;
 	int opt;
 	LIST_HEAD(dump_lists);
 	struct dump_list *dl, *dl2;
 
-	while ((opt = getopt(argc, argv, "ei:MmnT:to:au:WwENd:")) != -1) {
+	while ((opt = getopt(argc, argv, "ei:l:MmnT:to:au:WwENd:")) != -1) {
 		switch (opt) {
 		case 'e':
 			external_module = true;
@@ -2140,6 +2167,9 @@ int main(int argc, char **argv)
 		case 'M':
 			module_enabled = true;
 			break;
+		case 'l':
+			livepatch_modules = optarg;
+			break;
 		case 'm':
 			modversions = true;
 			break;
@@ -2219,6 +2249,8 @@ int main(int argc, char **argv)
 
 	if (dump_write)
 		write_dump(dump_write);
+	if (livepatch_modules)
+		write_livepatch_modules(livepatch_modules);
 	if (sec_mismatch_count && !sec_mismatch_warn_only)
 		error("Section mismatches detected.\n"
 		      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 58197b34a3c8..cb5bb2e76c53 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -76,6 +76,8 @@
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
+#define KLP_SYM_RELA ".klp.sym.rela."
+
 void *do_nofail(void *ptr, const char *expr);
 
 struct buffer {
@@ -97,6 +99,7 @@ struct module {
 	bool is_gpl_compatible;
 	bool from_dump;		/* true if module was loaded from *.symvers */
 	bool is_vmlinux;
+	bool is_livepatch;
 	bool seen;
 	bool has_init;
 	bool has_cleanup;
-- 
2.46.0


