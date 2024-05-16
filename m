Return-Path: <live-patching+bounces-268-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6178C77A3
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 15:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F25E1C22623
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 13:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5153914B959;
	Thu, 16 May 2024 13:30:30 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D1A1494DA;
	Thu, 16 May 2024 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866230; cv=none; b=Mk/7kGIv0IvIn4HiNOl1VQvbvTJa0RrjC82smefENnx7106CFH/x/itl6M0mfj/N2sJuLMyxJw22yXXxXFziT4ICew5LGzag0M+S7sqrR2XrD5OWzhrGef6NvHMXwFqKVK/obfjNV36kkYMHmH96RlReXHs2ZX0F2oywsAv+SEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866230; c=relaxed/simple;
	bh=INqPEhsY1z2kbYZru6c0mYMdy3a4bE740P9mz200ItU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWKmw4eEbfqqMHAmfst85TZYx/5gCHknwrswhICtINnNhVATB3XlvXf6O/xmh0UIKDvjIJjtMkjjKPt6pcx4AXU9S0kP4oa2KT4vQIJXK7XlfSj0mEdQyYY/7tnfFRpCD5E9+hz8q1YkyxtW1lGc/EXCHWceMBoolvn71tnEOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A349F5C442;
	Thu, 16 May 2024 13:30:26 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9714313991;
	Thu, 16 May 2024 13:30:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /1pcJHIKRmbsCAAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 16 May 2024 13:30:26 +0000
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
Subject: [PATCH v2 3/6] kbuild/modpost: integrate klp-convert
Date: Thu, 16 May 2024 15:30:06 +0200
Message-ID: <20240516133009.20224-4-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240516133009.20224-1-lhruska@suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: A349F5C442

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
 Makefile                  | 10 ++++++----
 scripts/Makefile.modfinal | 15 +++++++++++++++
 scripts/Makefile.modpost  |  5 +++++
 scripts/mod/modpost.c     | 36 ++++++++++++++++++++++++++++++++++--
 scripts/mod/modpost.h     |  3 +++
 6 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index c59dc60ba62e..9b7d492cac99 100644
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
index 967e97878ecd..db06e5db21af 100644
--- a/Makefile
+++ b/Makefile
@@ -1095,6 +1095,7 @@ PHONY += prepare0
 export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
 export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
+export MODULES_LIVEPATCH := $(extmod_prefix)modules.livepatch
 
 ifeq ($(KBUILD_EXTMOD),)
 
@@ -1453,8 +1454,8 @@ endif
 #
 
 # *.ko are usually independent of vmlinux, but CONFIG_DEBUG_INFO_BTF_MODULES
-# is an exception.
-ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+# and CONFIG_LIVEPATCH are exceptions.
+ifneq ($(or $(CONFIG_DEBUG_INFO_BTF_MODULES),$(CONFIG_LIVEPATCH)),)
 KBUILD_BUILTIN := 1
 modules: vmlinux
 endif
@@ -1477,8 +1478,9 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_FILES += vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json .thinlto-cache rust/test \
-	       rust-project.json .vmlinux.objs .vmlinux.export.c
+           modules.livepatch compile_commands.json .thinlto-cache \
+           rust/test rust-project.json .vmlinux.objs \
+           .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 79fcf2731686..a2a162d204f6 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -14,6 +14,7 @@ include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
 modules := $(call read-file, $(MODORDER))
+modules-klp := $(call read-file, $(MODULES_LIVEPATCH))
 
 __modfinal: $(modules:%.o=%.ko)
 	@:
@@ -60,6 +61,20 @@ endif
 
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
index 739402f45509..3c765c568e34 100644
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
index 2f5b91da5afa..15d7d2de653e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1654,6 +1654,10 @@ static void read_symbols(const char *modname)
 		}
 	}
 
+	/* Livepatch modules have unresolved symbols resolved by klp-convert */
+	if (get_modinfo(&info, "livepatch"))
+		mod->is_livepatch = true;
+
 	if (extra_warn && !get_modinfo(&info, "description"))
 		warn("missing MODULE_DESCRIPTION() in %s\n", modname);
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
@@ -1742,10 +1746,18 @@ static void check_exports(struct module *mod)
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
@@ -2178,6 +2190,20 @@ static void write_namespace_deps_files(const char *fname)
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
@@ -2189,11 +2215,12 @@ int main(int argc, char **argv)
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
@@ -2206,6 +2233,9 @@ int main(int argc, char **argv)
 		case 'M':
 			module_enabled = true;
 			break;
+		case 'l':
+			livepatch_modules = optarg;
+			break;
 		case 'm':
 			modversions = true;
 			break;
@@ -2285,6 +2315,8 @@ int main(int argc, char **argv)
 
 	if (dump_write)
 		write_dump(dump_write);
+	if (livepatch_modules)
+		write_livepatch_modules(livepatch_modules);
 	if (sec_mismatch_count && !sec_mismatch_warn_only)
 		error("Section mismatches detected.\n"
 		      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index ee43c7950636..7a82460cc4d6 100644
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
2.45.0


