Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CEC1BE293
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgD2PZZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60775 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727789AbgD2PZT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KM+CEqDp0Iw7Y56yc9iAAs3cMDMSLmle79heGPkkOEM=;
        b=J2rwkF419+oCz5GldoX+Dk99rL9RpttYdZ5ljoV1TKCrDdY7IOFuytVBPJwc+0A2xdEfd/
        7hmaDtExG4i71kC2OwwrRHOoUJD1d1COCeK2Bagntp5AK+2liAKJ18vI3EHggn1QK2d6lY
        NL/IZdBwMoStMfx4MX4tRGJiMtaAd+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-1zyvK3m9PhC_PElfwN_-TQ-1; Wed, 29 Apr 2020 11:25:12 -0400
X-MC-Unique: 1zyvK3m9PhC_PElfwN_-TQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87906100A47D;
        Wed, 29 Apr 2020 15:25:04 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CD905114B;
        Wed, 29 Apr 2020 15:25:03 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 03/11] livepatch: Remove .klp.arch
Date:   Wed, 29 Apr 2020 10:24:45 -0500
Message-Id: <8c792544caddef7d2cabf29ff98129a76e3a56de.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

After the previous patch, vmlinux-specific KLP relocations are now
applied early during KLP module load.  This means that .klp.arch
sections are no longer needed for *vmlinux-specific* KLP relocations.

One might think they're still needed for *module-specific* KLP
relocations.  If a to-be-patched module is loaded *after* its
corresponding KLP module is loaded, any corresponding KLP relocations
will be delayed until the to-be-patched module is loaded.  If any
special sections (.parainstructions, for example) rely on those
relocations, their initializations (apply_paravirt) need to be done
afterwards.  Thus the apparent need for arch_klp_init_object_loaded()
and its corresponding .klp.arch sections -- it allows some of the
special section initializations to be done at a later time.

But... if you look closer, that dependency between the special sections
and the module-specific KLP relocations doesn't actually exist in
reality.  Looking at the contents of the .altinstructions and
.parainstructions sections, there's not a realistic scenario in which a
KLP module's .altinstructions or .parainstructions section needs to
access a symbol in a to-be-patched module.  It might need to access a
local symbol or even a vmlinux symbol; but not another module's symbol.
When a special section needs to reference a local or vmlinux symbol, a
normal rela can be used instead of a KLP rela.

Since the special section initializations don't actually have any real
dependency on module-specific KLP relocations, .klp.arch and
arch_klp_init_object_loaded() no longer have a reason to exist.  So
remove them.

As Peter said much more succinctly:

  So the reason for .klp.arch was that .klp.rela.* stuff would overwrite
  paravirt instructions. If that happens you're doing it wrong. Those
  RELAs are core kernel, not module, and thus should've happened in
  .rela.* sections at patch-module loading time.

  Reverting this removes the two apply_{paravirt,alternatives}() calls
  from the late patching path, and means we don't have to worry about
  them when removing module_disable_ro().

[ jpoimboe: Rewrote patch description.  Tweaked klp_init_object_loaded()
	    error path. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 Documentation/livepatch/module-elf-format.rst | 15 +-----
 arch/x86/kernel/Makefile                      |  1 -
 arch/x86/kernel/livepatch.c                   | 53 -------------------
 include/linux/livepatch.h                     |  3 --
 kernel/livepatch/core.c                       | 27 ++++------
 5 files changed, 11 insertions(+), 88 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentatio=
n/livepatch/module-elf-format.rst
index 2a591e6f8e6c..8c6b894c4661 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -14,8 +14,7 @@ This document outlines the Elf format requirements that=
 livepatch modules must f
    4. Livepatch symbols
       4.1 A livepatch module's symbol table
       4.2 Livepatch symbol format
-   5. Architecture-specific sections
-   6. Symbol table and Elf section access
+   5. Symbol table and Elf section access
=20
 1. Background and motivation
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
@@ -298,17 +297,7 @@ Examples:
   Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH=
 (0xff20).
   "OS" means OS-specific.
=20
-5. Architecture-specific sections
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
-Architectures may override arch_klp_init_object_loaded() to perform
-additional arch-specific tasks when a target module loads, such as apply=
ing
-arch-specific sections. On x86 for example, we must apply per-object
-.altinstructions and .parainstructions sections when a target module loa=
ds.
-These sections must be prefixed with ".klp.arch.$objname." so that they =
can
-be easily identified when iterating through a patch module's Elf section=
s
-(See arch/x86/kernel/livepatch.c for a complete example).
-
-6. Symbol table and Elf section access
+5. Symbol table and Elf section access
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 A livepatch module's symbol table is accessible through module->symtab.
=20
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 92e1261ec4ec..e77261db2391 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -94,7 +94,6 @@ obj-$(CONFIG_X86_MPPARSE)	+=3D mpparse.o
 obj-y				+=3D apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+=3D reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+=3D ftrace.o
-obj-$(CONFIG_LIVEPATCH)	+=3D livepatch.o
 obj-$(CONFIG_FUNCTION_TRACER)	+=3D ftrace_$(BITS).o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) +=3D ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+=3D ftrace.o
diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
deleted file mode 100644
index 6a68e41206e7..000000000000
--- a/arch/x86/kernel/livepatch.c
+++ /dev/null
@@ -1,53 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * livepatch.c - x86-specific Kernel Live Patching Core
- */
-
-#include <linux/module.h>
-#include <linux/kallsyms.h>
-#include <linux/livepatch.h>
-#include <asm/text-patching.h>
-
-/* Apply per-object alternatives. Based on x86 module_finalize() */
-void arch_klp_init_object_loaded(struct klp_patch *patch,
-				 struct klp_object *obj)
-{
-	int cnt;
-	struct klp_modinfo *info;
-	Elf_Shdr *s, *alt =3D NULL, *para =3D NULL;
-	void *aseg, *pseg;
-	const char *objname;
-	char sec_objname[MODULE_NAME_LEN];
-	char secname[KSYM_NAME_LEN];
-
-	info =3D patch->mod->klp_info;
-	objname =3D obj->name ? obj->name : "vmlinux";
-
-	/* See livepatch core code for BUILD_BUG_ON() explanation */
-	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN !=3D 128);
-
-	for (s =3D info->sechdrs; s < info->sechdrs + info->hdr.e_shnum; s++) {
-		/* Apply per-object .klp.arch sections */
-		cnt =3D sscanf(info->secstrings + s->sh_name,
-			     ".klp.arch.%55[^.].%127s",
-			     sec_objname, secname);
-		if (cnt !=3D 2)
-			continue;
-		if (strcmp(sec_objname, objname))
-			continue;
-		if (!strcmp(".altinstructions", secname))
-			alt =3D s;
-		if (!strcmp(".parainstructions", secname))
-			para =3D s;
-	}
-
-	if (alt) {
-		aseg =3D (void *) alt->sh_addr;
-		apply_alternatives(aseg, aseg + alt->sh_size);
-	}
-
-	if (para) {
-		pseg =3D (void *) para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-}
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index c4302e9a5905..2614247a9781 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -195,9 +195,6 @@ struct klp_patch {
=20
 int klp_enable_patch(struct klp_patch *);
=20
-void arch_klp_init_object_loaded(struct klp_patch *patch,
-				 struct klp_object *obj);
-
 /* Called from the module loader during module coming/going states */
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c02791e5c75b..16632e75112a 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -729,12 +729,6 @@ static int klp_init_func(struct klp_object *obj, str=
uct klp_func *func)
 			   func->old_sympos ? func->old_sympos : 1);
 }
=20
-/* Arches may override this to finish any remaining arch-specific tasks =
*/
-void __weak arch_klp_init_object_loaded(struct klp_patch *patch,
-					struct klp_object *obj)
-{
-}
-
 int klp_apply_object_relocs(struct klp_patch *patch, struct klp_object *=
obj)
 {
 	int i, ret;
@@ -764,10 +758,11 @@ static int klp_init_object_loaded(struct klp_patch =
*patch,
 	struct klp_func *func;
 	int ret;
=20
-	mutex_lock(&text_mutex);
-	module_disable_ro(patch->mod);
-
 	if (klp_is_module(obj)) {
+
+		mutex_lock(&text_mutex);
+		module_disable_ro(patch->mod);
+
 		/*
 		 * Only write module-specific relocations here
 		 * (.klp.rela.{module}.*).  vmlinux-specific relocations were
@@ -775,17 +770,13 @@ static int klp_init_object_loaded(struct klp_patch =
*patch,
 		 * itself.
 		 */
 		ret =3D klp_apply_object_relocs(patch, obj);
-		if (ret) {
-			module_enable_ro(patch->mod, true);
-			mutex_unlock(&text_mutex);
-			return ret;
-		}
-	}
=20
-	arch_klp_init_object_loaded(patch, obj);
+		module_enable_ro(patch->mod, true);
+		mutex_unlock(&text_mutex);
=20
-	module_enable_ro(patch->mod, true);
-	mutex_unlock(&text_mutex);
+		if (ret)
+			return ret;
+	}
=20
 	klp_for_each_func(obj, func) {
 		ret =3D klp_find_object_symbol(obj->name, func->old_name,
--=20
2.21.1

