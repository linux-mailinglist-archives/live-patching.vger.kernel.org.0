Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8D818C08
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfEIOjO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfEIOjN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 392ED81243;
        Thu,  9 May 2019 14:39:13 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 667A35E7A6;
        Thu,  9 May 2019 14:39:12 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
Date:   Thu,  9 May 2019 10:38:55 -0400
Message-Id: <20190509143859.9050-7-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 09 May 2019 14:39:13 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

Currently, livepatch infrastructure in the kernel relies on
MODULE_INFO(livepatch, "Y") statement in a livepatch module. Then the
kernel module loader knows a module is indeed livepatch module and can
behave accordingly.

klp-convert, on the other hand relies on LIVEPATCH_* statement in the
module's Makefile for exactly the same reason.

Remove dependency on modinfo and generate MODULE_INFO flag
automatically in modpost when LIVEPATCH_* is defined in the module's
Makefile. Generate a list of all built livepatch modules based on
the .livepatch file and store it in (MODVERDIR)/livepatchmods. Give
this list as an argument for modpost which will use it to identify
livepatch modules.

As MODULE_INFO is no longer needed, remove it.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 lib/livepatch/test_klp_atomic_replace.c      |  1 -
 lib/livepatch/test_klp_callbacks_demo.c      |  1 -
 lib/livepatch/test_klp_callbacks_demo2.c     |  1 -
 lib/livepatch/test_klp_livepatch.c           |  1 -
 samples/livepatch/livepatch-callbacks-demo.c |  1 -
 samples/livepatch/livepatch-sample.c         |  1 -
 samples/livepatch/livepatch-shadow-fix1.c    |  1 -
 samples/livepatch/livepatch-shadow-fix2.c    |  1 -
 scripts/Makefile.modpost                     |  8 +-
 scripts/mod/modpost.c                        | 84 ++++++++++++++++++--
 10 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/lib/livepatch/test_klp_atomic_replace.c b/lib/livepatch/test_klp_atomic_replace.c
index 5af7093ca00c..3bf08a1b7b12 100644
--- a/lib/livepatch/test_klp_atomic_replace.c
+++ b/lib/livepatch/test_klp_atomic_replace.c
@@ -52,6 +52,5 @@ static void test_klp_atomic_replace_exit(void)
 module_init(test_klp_atomic_replace_init);
 module_exit(test_klp_atomic_replace_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
 MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
 MODULE_DESCRIPTION("Livepatch test: atomic replace");
diff --git a/lib/livepatch/test_klp_callbacks_demo.c b/lib/livepatch/test_klp_callbacks_demo.c
index 3fd8fe1cd1cc..76e2f51a6771 100644
--- a/lib/livepatch/test_klp_callbacks_demo.c
+++ b/lib/livepatch/test_klp_callbacks_demo.c
@@ -116,6 +116,5 @@ static void test_klp_callbacks_demo_exit(void)
 module_init(test_klp_callbacks_demo_init);
 module_exit(test_klp_callbacks_demo_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
 MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
 MODULE_DESCRIPTION("Livepatch test: livepatch demo");
diff --git a/lib/livepatch/test_klp_callbacks_demo2.c b/lib/livepatch/test_klp_callbacks_demo2.c
index 5417573e80af..76db98fc3071 100644
--- a/lib/livepatch/test_klp_callbacks_demo2.c
+++ b/lib/livepatch/test_klp_callbacks_demo2.c
@@ -88,6 +88,5 @@ static void test_klp_callbacks_demo2_exit(void)
 module_init(test_klp_callbacks_demo2_init);
 module_exit(test_klp_callbacks_demo2_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
 MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
 MODULE_DESCRIPTION("Livepatch test: livepatch demo2");
diff --git a/lib/livepatch/test_klp_livepatch.c b/lib/livepatch/test_klp_livepatch.c
index aff08199de71..d94d0ae232db 100644
--- a/lib/livepatch/test_klp_livepatch.c
+++ b/lib/livepatch/test_klp_livepatch.c
@@ -46,6 +46,5 @@ static void test_klp_livepatch_exit(void)
 module_init(test_klp_livepatch_init);
 module_exit(test_klp_livepatch_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
 MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
 MODULE_DESCRIPTION("Livepatch test: livepatch module");
diff --git a/samples/livepatch/livepatch-callbacks-demo.c b/samples/livepatch/livepatch-callbacks-demo.c
index 62d97953ad02..e78249d4bff8 100644
--- a/samples/livepatch/livepatch-callbacks-demo.c
+++ b/samples/livepatch/livepatch-callbacks-demo.c
@@ -205,4 +205,3 @@ static void livepatch_callbacks_demo_exit(void)
 module_init(livepatch_callbacks_demo_init);
 module_exit(livepatch_callbacks_demo_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index 01c9cf003ca2..8900a175046b 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -79,4 +79,3 @@ static void livepatch_exit(void)
 module_init(livepatch_init);
 module_exit(livepatch_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index 67a73e5e986e..c5bae813aaab 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -169,4 +169,3 @@ static void livepatch_shadow_fix1_exit(void)
 module_init(livepatch_shadow_fix1_init);
 module_exit(livepatch_shadow_fix1_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 91c21d52cfea..7cc3c3dc9509 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -141,4 +141,3 @@ static void livepatch_shadow_fix2_exit(void)
 module_init(livepatch_shadow_fix2_init);
 module_exit(livepatch_shadow_fix2_exit);
 MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 1bef611f99b6..f2aee6b8dcfd 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -65,6 +65,11 @@ MODLISTCMD := find $(MODVERDIR) -name '*.mod' | xargs -r grep -h '\.ko$$' | sort
 __modules := $(shell $(MODLISTCMD))
 modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
 
+# find all .livepatch files listed in $(MODVERDIR)/
+ifdef CONFIG_LIVEPATCH
+$(shell find $(MODVERDIR) -name '*.livepatch' | xargs -r -I{} basename {} .livepatch > $(MODVERDIR)/livepatchmods)
+endif
+
 # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
 _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
@@ -78,7 +83,8 @@ modpost = scripts/mod/modpost                    \
  $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_SECTION_MISMATCH_WARN_ONLY),,-E)  \
- $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
+ $(if $(CONFIG_LIVEPATCH),-l $(MODVERDIR)/livepatchmods)
 
 MODPOST_OPT=$(subst -i,-n,$(filter -i,$(MAKEFLAGS)))
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 374b22c76ec5..b3ab17d9d834 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1974,10 +1974,6 @@ static void read_symbols(const char *modname)
 		license = get_next_modinfo(&info, "license", license);
 	}
 
-	/* Livepatch modules have unresolved symbols resolved by klp-convert */
-	if (get_modinfo(&info, "livepatch"))
-		mod->livepatch = 1;
-
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
 		symname = remove_dot(info.strtab + sym->st_name);
 
@@ -2416,6 +2412,76 @@ static void write_dump(const char *fname)
 	free(buf.p);
 }
 
+struct livepatch_mod_list {
+	struct livepatch_mod_list *next;
+	char *livepatch_mod;
+};
+
+static struct livepatch_mod_list *load_livepatch_mods(const char *fname)
+{
+	struct livepatch_mod_list *list_iter, *list_start = NULL;
+	unsigned long size, pos = 0;
+	void *file = grab_file(fname, &size);
+	char *line;
+
+	if (!file)
+		return NULL;
+
+	while ((line = get_next_line(&pos, file, size))) {
+		list_iter = NOFAIL(malloc(sizeof(*list_iter)));
+		list_iter->next = list_start;
+		list_iter->livepatch_mod = NOFAIL(strdup(line));
+		list_start = list_iter;
+	}
+	release_file(file, size);
+
+	return list_start;
+}
+
+static void free_livepatch_mods(struct livepatch_mod_list *list_start)
+{
+	struct livepatch_mod_list *list_iter;
+
+	while (list_start) {
+		list_iter = list_start->next;
+		free(list_start->livepatch_mod);
+		free(list_start);
+		list_start = list_iter;
+	}
+}
+
+static int is_livepatch_mod(const char *modname,
+		struct livepatch_mod_list *list)
+{
+	const char *myname;
+
+	if (!list)
+		return 0;
+
+	myname = strrchr(modname, '/');
+	if (myname)
+		myname++;
+	else
+		myname = modname;
+
+	while (list) {
+		if (!strcmp(myname, list->livepatch_mod))
+			return 1;
+		list = list->next;
+	}
+	return 0;
+}
+
+static void add_livepatch_flag(struct buffer *b, struct module *mod,
+		struct livepatch_mod_list *list)
+{
+	if (is_livepatch_mod(mod->name, list)) {
+		buf_printf(b, "\nMODULE_INFO(livepatch, \"Y\");\n");
+		mod->livepatch = 1;
+	}
+}
+
+
 struct ext_sym_list {
 	struct ext_sym_list *next;
 	const char *file;
@@ -2431,8 +2497,9 @@ int main(int argc, char **argv)
 	int err;
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
+	struct livepatch_mod_list *livepatch_mods = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:mnsT:o:awE")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:l:mnsT:o:awE")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2449,6 +2516,9 @@ int main(int argc, char **argv)
 			extsym_iter->file = optarg;
 			extsym_start = extsym_iter;
 			break;
+		case 'l':
+			livepatch_mods = load_livepatch_mods(optarg);
+			break;
 		case 'm':
 			modversions = 1;
 			break;
@@ -2506,15 +2576,16 @@ int main(int argc, char **argv)
 		buf.pos = 0;
 
 		err |= check_modname_len(mod);
-		err |= check_exports(mod);
 		add_header(&buf, mod);
 		add_intree_flag(&buf, !external_module);
 		add_retpoline(&buf);
 		add_staging_flag(&buf, mod->name);
+		add_livepatch_flag(&buf, mod, livepatch_mods);
 		err |= add_versions(&buf, mod);
 		add_depends(&buf, mod);
 		add_moddevtable(&buf, mod);
 		add_srcversion(&buf, mod);
+		err |= check_exports(mod);
 
 		sprintf(fname, "%s.mod.c", mod->name);
 		write_if_changed(&buf, fname);
@@ -2524,6 +2595,7 @@ int main(int argc, char **argv)
 	if (sec_mismatch_count && sec_mismatch_fatal)
 		fatal("modpost: Section mismatches detected.\n"
 		      "Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.\n");
+	free_livepatch_mods(livepatch_mods);
 	free(buf.p);
 
 	return err;
-- 
2.20.1

