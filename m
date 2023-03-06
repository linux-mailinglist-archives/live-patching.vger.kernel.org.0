Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218DE6AC37C
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCFOid (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCFOib (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:38:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80381B44E
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678113378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N39Vv+8TCHrc/Ox+DgFlhKDRuuA99SD8HiFkls7VY0M=;
        b=GrRu6WLtmLz2dQZLAtuUEm4WLBAjz0NU80VwgRa9uVSwAIxkGGjlgmZ1dJhrQXVyzeBPHY
        Y+SdgkbFpfDITHNYH2R9WsWXNew9uiS0M5g/7fxVQtSUW6YH8GOAWBnspXflL2IEmR6O05
        5BR2jo5a75q9eTBjkyRLhez1MoPEv/E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-oGB7oEgdMLyrk5Qx8Dq7_g-1; Mon, 06 Mar 2023 09:08:28 -0500
X-MC-Unique: oGB7oEgdMLyrk5Qx8Dq7_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86B5D800B23;
        Mon,  6 Mar 2023 14:08:27 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F6C2408573E;
        Mon,  6 Mar 2023 14:08:27 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 02/10] livepatch: Add klp-convert tool
Date:   Mon,  6 Mar 2023 09:08:16 -0500
Message-Id: <20230306140824.3858543-3-joe.lawrence@redhat.com>
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

Livepatches may use symbols which are not contained in its own scope,
and, because of that, may end up compiled with relocations that will
only be resolved during module load. Yet, when the referenced symbols
are not exported, solving this relocation requires information on the
object that holds the symbol (either vmlinux or modules) and its
position inside the object, as an object may contain multiple symbols
with the same name. Providing such information must be done accordingly
to what is specified in Documentation/livepatch/module-elf-format.txt.

Currently, there is no trivial way to embed the required information as
requested in the final livepatch elf object. klp-convert solves this
problem in two different forms: (i) by relying on symbols.klp, which is
built during kernel compilation, to automatically infer the relocation
targeted symbol, and, when such inference is not possible (ii) by using
annotations in the elf object to convert the relocation accordingly to
the specification, enabling it to be handled by the livepatch loader.

Given the above, create scripts/livepatch to hold tools developed for
livepatches and add source files for klp-convert there.

The core file of klp-convert is scripts/livepatch/klp-convert.c, which
implements the heuristics used to solve the relocations and the
conversion of unresolved symbols into the expected format, as defined in
[1].

klp-convert receives as arguments the symbols.klp file, an input
livepatch module to be converted and the output name for the converted
livepatch. When it starts running, klp-convert parses symbols.klp and
builds two internal lists of symbols, one containing the exported and
another containing the non-exported symbols. Then, by parsing the rela
sections in the elf object, klp-convert identifies which symbols must be
converted, which are those unresolved and that do not have a
corresponding exported symbol, and attempts to convert them accordingly
to the specification.

By using symbols.klp, klp-convert identifies which symbols have names
that only appear in a single kernel object, thus being capable of
resolving these cases without the intervention of the developer. When
various homonymous symbols exist through kernel objects, it is not
possible to infer the right one, thus klp-convert falls back into using
developer annotations. If these were not provided, then the tool will
print a list with all acceptable targets for the symbol being processed.

Annotations in the context of klp-convert are accessible as struct
klp_module_reloc entries in sections named .klp.module_relocs.<objname>.
These entries are pairs of symbol references and positions which are to
be resolved against definitions in <objname>.

Define the structure klp_module_reloc in include/linux/uapi/livepatch.h
allowing developers to annotate the livepatch source code with it.

klp-convert relies on libelf and on a list implementation. Add files
scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
interfacing layer and scripts/livepatch/list.h, which is a list
implementation.

Update Makefiles to correctly support the compilation of the new tool,
update MAINTAINERS file and add a .gitignore file.

[1] - Documentation/livepatch/module-elf-format.txt

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 MAINTAINERS                     |   1 +
 include/linux/livepatch.h       |  12 +
 include/uapi/linux/livepatch.h  |  10 +
 scripts/Makefile                |   1 +
 scripts/livepatch/.gitignore    |   1 +
 scripts/livepatch/Makefile      |   5 +
 scripts/livepatch/elf.c         | 817 +++++++++++++++++++++++++++++
 scripts/livepatch/elf.h         |  74 +++
 scripts/livepatch/klp-convert.c | 893 ++++++++++++++++++++++++++++++++
 scripts/livepatch/klp-convert.h |  47 ++
 scripts/livepatch/list.h        | 391 ++++++++++++++
 11 files changed, 2252 insertions(+)
 create mode 100644 scripts/livepatch/.gitignore
 create mode 100644 scripts/livepatch/Makefile
 create mode 100644 scripts/livepatch/elf.c
 create mode 100644 scripts/livepatch/elf.h
 create mode 100644 scripts/livepatch/klp-convert.c
 create mode 100644 scripts/livepatch/klp-convert.h
 create mode 100644 scripts/livepatch/list.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5bdf333fb1f3..c68f4c1ac1ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12074,6 +12074,7 @@ F:	kernel/livepatch/
 F:	kernel/module/livepatch.c
 F:	lib/livepatch/
 F:	samples/livepatch/
+F:	scripts/livepatch/
 F:	tools/testing/selftests/livepatch/
 
 LLC (802.2)
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 46da4c0df6c1..cd5809010bca 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -235,6 +235,18 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 			     unsigned int symindex, unsigned int secindex,
 			     const char *objname);
 
+/* Used to annotate symbol relocations in livepatches */
+#define KLP_MODULE_RELOC(obj)						\
+	struct klp_module_reloc						\
+	__section(".klp.module_relocs." #obj)				\
+	__aligned(4)
+
+#define KLP_SYMPOS(symbol, pos)						\
+	{								\
+		.sym = &symbol,						\
+		.sympos = pos,						\
+	}
+
 #else /* !CONFIG_LIVEPATCH */
 
 static inline int klp_module_coming(struct module *mod) { return 0; }
diff --git a/include/uapi/linux/livepatch.h b/include/uapi/linux/livepatch.h
index e19430918a07..2ee98e985c2a 100644
--- a/include/uapi/linux/livepatch.h
+++ b/include/uapi/linux/livepatch.h
@@ -9,7 +9,17 @@
 #ifndef _UAPI_LIVEPATCH_H
 #define _UAPI_LIVEPATCH_H
 
+#include <linux/types.h>
+
 #define KLP_RELA_PREFIX		".klp.rela."
 #define KLP_SYM_PREFIX		".klp.sym."
 
+struct klp_module_reloc {
+	union {
+		void *sym;
+		__u64 sym64;	/* Force 64-bit width */
+	};
+	__u32 sympos;
+} __packed;
+
 #endif /* _UAPI_LIVEPATCH_H */
diff --git a/scripts/Makefile b/scripts/Makefile
index 1575af84d557..46a249ff6815 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -41,6 +41,7 @@ targets += module.lds
 subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
+subdir-$(CONFIG_LIVEPATCH)   += livepatch
 
 # Let clean descend into subdirs
 subdir-	+= basic dtc gdb kconfig mod
diff --git a/scripts/livepatch/.gitignore b/scripts/livepatch/.gitignore
new file mode 100644
index 000000000000..dc22fe4b6a5b
--- /dev/null
+++ b/scripts/livepatch/.gitignore
@@ -0,0 +1 @@
+klp-convert
diff --git a/scripts/livepatch/Makefile b/scripts/livepatch/Makefile
new file mode 100644
index 000000000000..71dce0f3e893
--- /dev/null
+++ b/scripts/livepatch/Makefile
@@ -0,0 +1,5 @@
+hostprogs-always-y		:= klp-convert
+
+klp-convert-objs		:= klp-convert.o elf.o
+
+HOSTLDLIBS_klp-convert		:= -lelf
diff --git a/scripts/livepatch/elf.c b/scripts/livepatch/elf.c
new file mode 100644
index 000000000000..c649268a4a55
--- /dev/null
+++ b/scripts/livepatch/elf.c
@@ -0,0 +1,817 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * elf.c - ELF access library
+ *
+ * Adapted from kpatch (https://github.com/dynup/kpatch):
+ * Copyright (C) 2013-2016 Josh Poimboeuf <jpoimboe@redhat.com>
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "elf.h"
+
+#define WARN(format, ...) \
+	fprintf(stderr, "%s: " format "\n", elf->name, ##__VA_ARGS__)
+
+/*
+ * Fallback for systems without this "read, mmaping if possible" cmd.
+ */
+#ifndef ELF_C_READ_MMAP
+#define ELF_C_READ_MMAP ELF_C_READ
+#endif
+
+bool is_rela_section(struct section *sec)
+{
+	return (sec->sh.sh_type == SHT_RELA);
+}
+
+struct section *find_section_by_name(struct elf *elf, const char *name)
+{
+	struct section *sec;
+
+	list_for_each_entry(sec, &elf->sections, list)
+		if (!strcmp(sec->name, name))
+			return sec;
+
+	return NULL;
+}
+
+static struct section *find_section_by_index(struct elf *elf,
+					     int idx)
+{
+	struct section *sec;
+
+	list_for_each_entry(sec, &elf->sections, list)
+		if (sec->idx == idx)
+			return sec;
+
+	return NULL;
+}
+
+static struct symbol *find_symbol_by_index(struct elf *elf, unsigned int idx)
+{
+	struct symbol *sym;
+
+	list_for_each_entry(sym, &elf->symbols, list)
+		if (sym->idx == idx)
+			return sym;
+
+	return NULL;
+}
+
+static int read_sections(struct elf *elf)
+{
+	Elf_Scn *s = NULL;
+	struct section *sec;
+	size_t shstrndx, sections_nr;
+	size_t i;
+
+	if (elf_getshdrnum(elf->elf, &sections_nr)) {
+		perror("elf_getshdrnum");
+		return -1;
+	}
+
+	if (elf_getshdrstrndx(elf->elf, &shstrndx)) {
+		perror("elf_getshdrstrndx");
+		return -1;
+	}
+
+	for (i = 0; i < sections_nr; i++) {
+		sec = calloc(1, sizeof(*sec));
+		if (!sec) {
+			perror("calloc");
+			return -1;
+		}
+
+		INIT_LIST_HEAD(&sec->relas);
+
+		list_add_tail(&sec->list, &elf->sections);
+
+		s = elf_getscn(elf->elf, i);
+		if (!s) {
+			perror("elf_getscn");
+			return -1;
+		}
+
+		sec->idx = elf_ndxscn(s);
+
+		if (!gelf_getshdr(s, &sec->sh)) {
+			perror("gelf_getshdr");
+			return -1;
+		}
+
+		sec->name = elf_strptr(elf->elf, shstrndx, sec->sh.sh_name);
+		if (!sec->name) {
+			perror("elf_strptr");
+			return -1;
+		}
+
+		sec->elf_data = elf_getdata(s, NULL);
+		if (!sec->elf_data) {
+			perror("elf_getdata");
+			return -1;
+		}
+
+		if (sec->elf_data->d_off != 0 ||
+		    sec->elf_data->d_size != sec->sh.sh_size) {
+			WARN("unexpected data attributes for %s", sec->name);
+			return -1;
+		}
+
+		sec->data = sec->elf_data->d_buf;
+		sec->size = sec->elf_data->d_size;
+	}
+
+	/* sanity check, one more call to elf_nextscn() should return NULL */
+	if (elf_nextscn(elf->elf, s)) {
+		WARN("section entry mismatch");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int read_symbols(struct elf *elf)
+{
+	struct section *symtab;
+	struct symbol *sym;
+	int symbols_nr, i;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab) {
+		WARN("missing symbol table");
+		return -1;
+	}
+
+	symbols_nr = symtab->sh.sh_size / symtab->sh.sh_entsize;
+
+	for (i = 0; i < symbols_nr; i++) {
+		sym = calloc(1, sizeof(*sym));
+		if (!sym) {
+			perror("calloc");
+			return -1;
+		}
+
+		sym->idx = i;
+
+		if (!gelf_getsym(symtab->elf_data, i, &sym->sym)) {
+			perror("gelf_getsym");
+			goto err;
+		}
+
+		sym->name = elf_strptr(elf->elf, symtab->sh.sh_link,
+				       sym->sym.st_name);
+		if (!sym->name) {
+			perror("elf_strptr");
+			goto err;
+		}
+
+		sym->type = GELF_ST_TYPE(sym->sym.st_info);
+		sym->bind = GELF_ST_BIND(sym->sym.st_info);
+
+		if (sym->sym.st_shndx > SHN_UNDEF &&
+		    sym->sym.st_shndx < SHN_LORESERVE) {
+			sym->sec = find_section_by_index(elf,
+							 sym->sym.st_shndx);
+			if (!sym->sec) {
+				WARN("couldn't find section for symbol %s",
+				     sym->name);
+				goto err;
+			}
+			if (sym->type == STT_SECTION) {
+				sym->name = sym->sec->name;
+				sym->sec->sym = sym;
+			}
+		}
+
+		sym->offset = sym->sym.st_value;
+		sym->size = sym->sym.st_size;
+
+		list_add_tail(&sym->list, &elf->symbols);
+	}
+
+	return 0;
+
+err:
+	free(sym);
+	return -1;
+}
+
+static int read_relas(struct elf *elf)
+{
+	struct section *sec;
+	struct rela *rela;
+	int relas_nr, i;
+	unsigned int symndx;
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (sec->sh.sh_type != SHT_RELA)
+			continue;
+
+		sec->base = find_section_by_name(elf, sec->name + 5);
+		if (!sec->base) {
+			WARN("can't find base section for rela section %s",
+			     sec->name);
+			return -1;
+		}
+
+		sec->base->rela = sec;
+
+		relas_nr = sec->sh.sh_size / sec->sh.sh_entsize;
+		for (i = 0; i < relas_nr; i++) {
+			rela = calloc(1, sizeof(*rela));
+			if (!rela) {
+				perror("calloc");
+				return -1;
+			}
+
+			if (!gelf_getrela(sec->elf_data, i, &rela->rela)) {
+				perror("gelf_getrela");
+				return -1;
+			}
+
+			rela->type = GELF_R_TYPE(rela->rela.r_info);
+			rela->addend = rela->rela.r_addend;
+			rela->offset = rela->rela.r_offset;
+			symndx = GELF_R_SYM(rela->rela.r_info);
+			rela->sym = find_symbol_by_index(elf, symndx);
+			if (!rela->sym) {
+				WARN("can't find rela entry symbol %u for %s",
+				     symndx, sec->name);
+				return -1;
+			}
+
+			list_add_tail(&rela->list, &sec->relas);
+		}
+	}
+
+	return 0;
+}
+
+struct section *create_rela_section(struct elf *elf, const char *name,
+				    struct section *base)
+{
+	struct section *sec;
+
+	sec = calloc(1, sizeof(*sec));
+	if (!sec) {
+		WARN("calloc failed");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&sec->relas);
+
+	sec->base = base;
+	sec->name = strdup(name);
+	if (!sec->name) {
+		WARN("strdup failed");
+		return NULL;
+	}
+	sec->sh.sh_name = ~0;
+	sec->sh.sh_type = SHT_RELA;
+
+	if (elf->elf_class == ELFCLASS32) {
+		sec->sh.sh_entsize = sizeof(Elf32_Rela);
+		sec->sh.sh_addralign = 4;
+	} else {
+		sec->sh.sh_entsize = sizeof(Elf64_Rela);
+		sec->sh.sh_addralign = 8;
+	}
+	sec->sh.sh_flags = SHF_ALLOC;
+
+	sec->elf_data = calloc(1, sizeof(*sec->elf_data));
+	if (!sec->elf_data) {
+		WARN("calloc failed");
+		return NULL;
+	}
+	sec->elf_data->d_type = ELF_T_RELA;
+
+	list_add_tail(&sec->list, &elf->sections);
+
+	return sec;
+}
+
+static int update_shstrtab(struct elf *elf)
+{
+	struct section *shstrtab, *sec;
+	size_t orig_size, new_size = 0, offset, len;
+	char *buf;
+
+	shstrtab = find_section_by_name(elf, ".shstrtab");
+	if (!shstrtab) {
+		WARN("can't find .shstrtab");
+		return -1;
+	}
+
+	orig_size = new_size = shstrtab->size;
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (sec->sh.sh_name != ~0U)
+			continue;
+		new_size += strlen(sec->name) + 1;
+	}
+
+	if (new_size == orig_size)
+		return 0;
+
+	buf = malloc(new_size);
+	if (!buf) {
+		WARN("malloc failed");
+		return -1;
+	}
+	memcpy(buf, (void *)shstrtab->data, orig_size);
+
+	offset = orig_size;
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (sec->sh.sh_name != ~0U)
+			continue;
+		sec->sh.sh_name = offset;
+		len = strlen(sec->name) + 1;
+		memcpy(buf + offset, sec->name, len);
+		offset += len;
+	}
+
+	shstrtab->elf_data->d_buf = shstrtab->data = buf;
+	shstrtab->elf_data->d_size = shstrtab->size = new_size;
+	shstrtab->sh.sh_size = new_size;
+
+	return 1;
+}
+
+static void free_shstrtab(struct elf *elf)
+{
+	struct section *shstrtab;
+
+	shstrtab = find_section_by_name(elf, ".shstrtab");
+	if (!shstrtab)
+		return;
+
+	free(shstrtab->elf_data->d_buf);
+}
+
+static int update_strtab(struct elf *elf)
+{
+	struct section *strtab;
+	struct symbol *sym;
+	size_t orig_size, new_size = 0, offset, len;
+	char *buf;
+
+	strtab = find_section_by_name(elf, ".strtab");
+	if (!strtab) {
+		WARN("can't find .strtab");
+		return -1;
+	}
+
+	orig_size = new_size = strtab->size;
+
+	list_for_each_entry(sym, &elf->symbols, list) {
+		if (sym->sym.st_name != ~0U)
+			continue;
+		new_size += strlen(sym->name) + 1;
+	}
+
+	if (new_size == orig_size)
+		return 0;
+
+	buf = malloc(new_size);
+	if (!buf) {
+		WARN("malloc failed");
+		return -1;
+	}
+	memcpy(buf, (void *)strtab->data, orig_size);
+
+	offset = orig_size;
+	list_for_each_entry(sym, &elf->symbols, list) {
+		if (sym->sym.st_name != ~0U)
+			continue;
+		sym->sym.st_name = offset;
+		len = strlen(sym->name) + 1;
+		memcpy(buf + offset, sym->name, len);
+		offset += len;
+	}
+
+	strtab->elf_data->d_buf = strtab->data = buf;
+	strtab->elf_data->d_size = strtab->size = new_size;
+	strtab->sh.sh_size = new_size;
+
+	return 1;
+}
+
+static void free_strtab(struct elf *elf)
+{
+	struct section *strtab;
+
+	strtab = find_section_by_name(elf, ".strtab");
+	if (!strtab)
+		return;
+
+	if (strtab->elf_data)
+		free(strtab->elf_data->d_buf);
+}
+
+static int update_symtab(struct elf *elf)
+{
+	struct section *symtab, *sec;
+	struct symbol *sym;
+	char *buf;
+	size_t size;
+	int offset = 0, nr_locals = 0, idx, nr_syms;
+
+	idx = 0;
+	list_for_each_entry(sec, &elf->sections, list)
+		sec->idx = idx++;
+
+	idx = 0;
+	list_for_each_entry(sym, &elf->symbols, list) {
+		sym->idx = idx++;
+		if (sym->sec)
+			sym->sym.st_shndx = sym->sec->idx;
+	}
+	nr_syms = idx;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab) {
+		WARN("can't find symtab");
+		return -1;
+	}
+
+	symtab->sh.sh_link = find_section_by_name(elf, ".strtab")->idx;
+
+	/* create new symtab buffer */
+	if (elf->elf_class == ELFCLASS32)
+		size = nr_syms * sizeof(Elf32_Sym);
+	else
+		size = nr_syms * sizeof(Elf64_Sym);
+	buf = calloc(1, size);
+	if (!buf) {
+		WARN("calloc failed");
+		return -1;
+	}
+
+	offset = 0;
+	list_for_each_entry(sym, &elf->symbols, list) {
+
+		if (elf->elf_class == ELFCLASS32) {
+			/* Manually convert to 32-bit Elf32_Sym */
+			Elf32_Sym sym32;
+
+			sym32.st_name  = sym->sym.st_name;
+			sym32.st_info  = sym->sym.st_info;
+			sym32.st_other = sym->sym.st_other;
+			sym32.st_shndx = sym->sym.st_shndx;
+			sym32.st_value = sym->sym.st_value;
+			sym32.st_size  = sym->sym.st_size;
+			memcpy(buf + offset, &sym32, sizeof(Elf32_Sym));
+		} else {
+			/* Existing 64-bit GElf_Syms are fine */
+			memcpy(buf + offset, &sym->sym, sizeof(Elf64_Sym));
+		}
+
+		offset += symtab->sh.sh_entsize;
+
+		if (sym->bind == STB_LOCAL)
+			nr_locals++;
+	}
+
+	symtab->elf_data->d_buf = symtab->data = buf;
+	symtab->elf_data->d_size = symtab->size = size;
+	symtab->sh.sh_size = size;
+
+	/* update symtab section header */
+	symtab->sh.sh_info = nr_locals;
+
+	return 1;
+}
+
+static void free_symtab(struct elf *elf)
+{
+	struct section *symtab;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab)
+		return;
+
+	free(symtab->elf_data->d_buf);
+}
+
+static int update_relas(struct elf *elf)
+{
+	struct section *sec, *symtab;
+	struct rela *rela;
+	int nr_relas, idx, size;
+	void *relas;
+
+	symtab = find_section_by_name(elf, ".symtab");
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (!is_rela_section(sec))
+			continue;
+
+		sec->sh.sh_link = symtab->idx;
+		if (sec->base)
+			sec->sh.sh_info = sec->base->idx;
+
+		nr_relas = 0;
+		list_for_each_entry(rela, &sec->relas, list)
+			nr_relas++;
+
+		if (elf->elf_class == ELFCLASS32)
+			size = nr_relas * sizeof(Elf32_Rela);
+		else
+			size = nr_relas * sizeof(Elf64_Rela);
+
+		relas = malloc(size);
+		if (!relas) {
+			WARN("malloc failed");
+			return -1;
+		}
+
+		sec->elf_data->d_buf = sec->data = relas;
+		sec->elf_data->d_size = sec->size = size;
+		sec->sh.sh_size = size;
+
+		idx = 0;
+		list_for_each_entry(rela, &sec->relas, list) {
+			if (elf->elf_class == ELFCLASS32) {
+				Elf32_Rela *relas32 = relas;
+
+				relas32[idx].r_offset = rela->offset;
+				relas32[idx].r_addend = rela->addend;
+				relas32[idx].r_info = ELF32_R_INFO(rela->sym->idx,
+								   rela->type);
+			} else {
+				Elf64_Rela *relas64 = relas;
+
+				relas64[idx].r_offset = rela->offset;
+				relas64[idx].r_addend = rela->addend;
+				relas64[idx].r_info = ELF64_R_INFO(rela->sym->idx,
+								   rela->type);
+			}
+			idx++;
+		}
+	}
+
+	return 1;
+}
+
+static void update_groups(struct elf *elf)
+{
+	struct section *sec, *symtab;
+
+	symtab = find_section_by_name(elf, ".symtab");
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (sec->sh.sh_type == SHT_GROUP)
+			sec->sh.sh_link = symtab->idx;
+	}
+}
+
+static void free_relas(struct elf *elf)
+{
+	struct section *sec, *symtab;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab)
+		return;
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (!is_rela_section(sec))
+			continue;
+
+		free(sec->elf_data->d_buf);
+	}
+}
+
+static int write_file(struct elf *elf, const char *file)
+{
+	int fd;
+	Elf *e;
+	GElf_Ehdr eh, ehout;
+	Elf_Scn *scn;
+	Elf_Data *data;
+	GElf_Shdr sh;
+	struct section *sec;
+
+	fd = creat(file, 0664);
+	if (fd == -1) {
+		WARN("couldn't create %s", file);
+		return -1;
+	}
+
+	e = elf_begin(fd, ELF_C_WRITE, NULL);
+	if (!e) {
+		WARN("elf_begin failed");
+		return -1;
+	}
+
+	if (!gelf_newehdr(e, gelf_getclass(elf->elf))) {
+		WARN("gelf_newehdr failed");
+		return -1;
+	}
+
+	if (!gelf_getehdr(e, &ehout)) {
+		WARN("gelf_getehdr failed");
+		return -1;
+	}
+
+	if (!gelf_getehdr(elf->elf, &eh)) {
+		WARN("gelf_getehdr failed");
+		return -1;
+	}
+
+	memset(&ehout, 0, sizeof(ehout));
+	ehout.e_ident[EI_DATA] = eh.e_ident[EI_DATA];
+	ehout.e_machine = eh.e_machine;
+	ehout.e_flags = eh.e_flags;
+	ehout.e_type = eh.e_type;
+	ehout.e_version = EV_CURRENT;
+	ehout.e_shstrndx = find_section_by_name(elf, ".shstrtab")->idx;
+
+	list_for_each_entry(sec, &elf->sections, list) {
+		if (!sec->idx)
+			continue;
+		scn = elf_newscn(e);
+		if (!scn) {
+			WARN("elf_newscn failed");
+			return -1;
+		}
+
+		data = elf_newdata(scn);
+		if (!data) {
+			WARN("elf_newdata failed");
+			return -1;
+		}
+
+		if (!elf_flagdata(data, ELF_C_SET, ELF_F_DIRTY)) {
+			WARN("elf_flagdata failed");
+			return -1;
+		}
+
+		data->d_type = sec->elf_data->d_type;
+		data->d_buf = sec->elf_data->d_buf;
+		data->d_size = sec->elf_data->d_size;
+
+		if (!gelf_getshdr(scn, &sh)) {
+			WARN("gelf_getshdr failed");
+			return -1;
+		}
+
+		sh = sec->sh;
+
+		if (!gelf_update_shdr(scn, &sh)) {
+			WARN("gelf_update_shdr failed");
+			return -1;
+		}
+	}
+
+	if (!gelf_update_ehdr(e, &ehout)) {
+		WARN("gelf_update_ehdr failed");
+		return -1;
+	}
+
+	if (elf_update(e, ELF_C_WRITE) < 0) {
+		fprintf(stderr, "%s\n", elf_errmsg(-1));
+		WARN("elf_update failed");
+		return -1;
+	}
+
+	elf_end(e);
+
+	return 0;
+}
+
+int elf_write_file(struct elf *elf, const char *file)
+{
+	int ret_shstrtab = 0;
+	int ret_strtab = 0;
+	int ret_symtab = 0;
+	int ret_relas = 0;
+	int ret;
+
+	ret_shstrtab = update_shstrtab(elf);
+	if (ret_shstrtab < 0) {
+		ret = ret_shstrtab;
+		goto out;
+	}
+
+	ret_strtab = update_strtab(elf);
+	if (ret_strtab < 0) {
+		ret = ret_strtab;
+		goto out;
+	}
+
+	ret_symtab = update_symtab(elf);
+	if (ret_symtab < 0) {
+		ret = ret_symtab;
+		goto out;
+	}
+
+	ret_relas = update_relas(elf);
+	if (ret_relas < 0) {
+		ret = ret_relas;
+		goto out;
+	}
+
+	update_groups(elf);
+
+	ret = write_file(elf, file);
+	if (ret)
+		return ret;
+
+out:
+	if (ret_relas > 0)
+		free_relas(elf);
+	if (ret_symtab > 0)
+		free_symtab(elf);
+	if (ret_strtab > 0)
+		free_strtab(elf);
+	if (ret_shstrtab > 0)
+		free_shstrtab(elf);
+
+	return ret;
+}
+
+struct elf *elf_open(const char *name)
+{
+	struct elf *elf;
+
+	elf_version(EV_CURRENT);
+
+	elf = calloc(1, sizeof(*elf));
+	if (!elf) {
+		perror("calloc");
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&elf->sections);
+	INIT_LIST_HEAD(&elf->symbols);
+
+	elf->fd = open(name, O_RDONLY);
+	if (elf->fd == -1) {
+		perror("open");
+		goto err;
+	}
+
+	elf->elf = elf_begin(elf->fd, ELF_C_READ_MMAP, NULL);
+	if (!elf->elf) {
+		perror("elf_begin");
+		goto err;
+	}
+
+	if (!gelf_getehdr(elf->elf, &elf->ehdr)) {
+		perror("gelf_getehdr");
+		goto err;
+	}
+
+	elf->elf_class = gelf_getclass(elf->elf);
+	if ((elf->elf_class != ELFCLASS32) && (elf->elf_class != ELFCLASS64)) {
+		WARN("invalid elf class");
+		goto err;
+	}
+
+	if (read_sections(elf))
+		goto err;
+
+	if (read_symbols(elf))
+		goto err;
+
+	if (read_relas(elf))
+		goto err;
+
+	return elf;
+
+err:
+	elf_close(elf);
+	return NULL;
+}
+
+void elf_close(struct elf *elf)
+{
+	struct section *sec, *tmpsec;
+	struct symbol *sym, *tmpsym;
+	struct rela *rela, *tmprela;
+
+	list_for_each_entry_safe(sym, tmpsym, &elf->symbols, list) {
+		list_del(&sym->list);
+		free(sym);
+	}
+	list_for_each_entry_safe(sec, tmpsec, &elf->sections, list) {
+		list_for_each_entry_safe(rela, tmprela, &sec->relas, list) {
+			list_del(&rela->list);
+			free(rela);
+		}
+		list_del(&sec->list);
+		free(sec);
+	}
+	if (elf->fd > 0)
+		close(elf->fd);
+	if (elf->elf)
+		elf_end(elf->elf);
+	free(elf);
+}
diff --git a/scripts/livepatch/elf.h b/scripts/livepatch/elf.h
new file mode 100644
index 000000000000..a5969ae6a0be
--- /dev/null
+++ b/scripts/livepatch/elf.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2015-2016 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#ifndef _KLP_POST_ELF_H
+#define _KLP_POST_ELF_H
+
+#include <stdio.h>
+#include <stdbool.h>
+#include <gelf.h>
+#include "list.h"
+
+#ifdef LIBELF_USE_DEPRECATED
+# define elf_getshdrnum    elf_getshnum
+# define elf_getshdrstrndx elf_getshstrndx
+#endif
+
+struct section {
+	struct list_head list;
+	GElf_Shdr sh;
+	struct section *base, *rela;
+	struct list_head relas;
+	struct symbol *sym;
+	Elf_Data *elf_data;
+	char *name;
+	int idx;
+	void *data;
+	unsigned int size;
+};
+
+struct symbol {
+	struct list_head list;
+	GElf_Sym sym;
+	struct section *sec;
+	char *name;
+	unsigned int idx;
+	unsigned char bind, type;
+	unsigned long offset;
+	unsigned int size;
+};
+
+struct rela {
+	struct list_head list;
+	GElf_Rela rela;
+	struct symbol *sym;
+	struct section *klp_rela_sec;
+	unsigned int type;
+	unsigned long offset;
+	int addend;
+};
+
+struct elf {
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	int fd;
+	char *name;
+	int elf_class;
+	struct list_head sections;
+	struct list_head symbols;
+};
+
+
+struct elf *elf_open(const char *name);
+bool is_rela_section(struct section *sec);
+struct section *find_section_by_name(struct elf *elf, const char *name);
+struct section *create_rela_section(struct elf *elf, const char *name,
+				    struct section *base);
+
+void elf_close(struct elf *elf);
+int elf_write_file(struct elf *elf, const char *file);
+
+
+#endif /* _KLP_POST_ELF_H */
diff --git a/scripts/livepatch/klp-convert.c b/scripts/livepatch/klp-convert.c
new file mode 100644
index 000000000000..f5d126b96922
--- /dev/null
+++ b/scripts/livepatch/klp-convert.c
@@ -0,0 +1,893 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
+ * Copyright (C) 2017 Joao Moreira   <jmoreira@suse.de>
+ */
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include "elf.h"
+#include "list.h"
+#include "klp-convert.h"
+
+/*
+ * Symbols parsed from symbols.klp are kept in two lists:
+ * - symbols: keeps non-exported symbols
+ * - exp_symbols: keeps exported symbols (__ksymtab_prefixed)
+ */
+static LIST_HEAD(symbols);
+static LIST_HEAD(exp_symbols);
+
+/* In-livepatch user-provided symbol positions are kept in list usr_symbols */
+static LIST_HEAD(usr_symbols);
+
+/* Converted symbols and their struct symbol -> struct sympos association */
+static LIST_HEAD(converted_symbols);
+
+struct converted_sym {
+	struct list_head list;
+	struct symbol *symbol;
+	struct sympos sympos;
+};
+
+#define safe_snprintf(var, size, format, args...)			\
+	({								\
+		size_t __size = size;					\
+		int __ret;						\
+									\
+		__ret = snprintf(var, size, format, ##args);		\
+		__ret < 0 || (size_t)__ret >= __size;			\
+	})
+
+static void free_syms_lists(void)
+{
+	struct symbol_entry *entry, *aux;
+	struct sympos *sp, *sp_aux;
+
+	list_for_each_entry_safe(entry, aux, &symbols, list) {
+		free(entry->object_name);
+		free(entry->symbol_name);
+		list_del(&entry->list);
+		free(entry);
+	}
+
+	list_for_each_entry_safe(entry, aux, &exp_symbols, list) {
+		free(entry->object_name);
+		free(entry->symbol_name);
+		list_del(&entry->list);
+		free(entry);
+	}
+
+	list_for_each_entry_safe(sp, sp_aux, &usr_symbols, list) {
+		free(sp->object_name);
+		free(sp->symbol_name);
+		list_del(&sp->list);
+		free(sp);
+	}
+}
+
+/* Parses file and fill symbols and exp_symbols list */
+static bool load_syms_lists(const char *symbols_list)
+{
+	FILE *fsyms;
+	size_t len = 0;
+	ssize_t n;
+	char *obj = NULL, *sym = NULL;
+	bool ret = false;
+
+	fsyms = fopen(symbols_list, "r");
+	if (!fsyms) {
+		WARN("Unable to open Symbol list: %s", symbols_list);
+		return false;
+	}
+
+	/* read file format version */
+	n = getline(&sym, &len, fsyms);
+	if (n <= 0) {
+		WARN("Unable to read Symbol list: %s", symbols_list);
+		goto done;
+	}
+
+	if (strncmp(sym, "klp-convert-symbol-data.0.1", 27) != 0) {
+		WARN("Symbol list is in unknown format.");
+		goto done;
+	}
+
+	len = 0;
+	free(sym);
+	sym = NULL;
+
+	/* read file */
+	n = getline(&sym, &len, fsyms);
+	while (n > 0) {
+		if (sym[n-1] == '\n')
+			sym[n-1] = '\0';
+
+		/* Objects in symbols.klp are flagged with '*' */
+		if (sym[0] == '*') {
+			free(obj);
+			obj = strdup(sym+1);
+			if (!obj) {
+				WARN("Unable to allocate object name\n");
+				goto done;
+			}
+			free(sym);
+		} else {
+			struct symbol_entry *entry;
+
+			if (!obj) {
+				WARN("File format error\n");
+				goto done;
+			}
+
+			entry = calloc(1, sizeof(struct symbol_entry));
+			if (!entry) {
+				WARN("Unable to allocate Symbol entry\n");
+				goto done;
+			}
+
+			entry->object_name = strdup(obj);
+			if (!entry->object_name) {
+				WARN("Unable to allocate entry object name\n");
+				free(entry);
+				goto done;
+			}
+
+			entry->symbol_name = sym;
+			if (strncmp(entry->symbol_name, "__ksymtab_", 10) == 0)
+				list_add(&entry->list, &exp_symbols);
+			else
+				list_add(&entry->list, &symbols);
+		}
+		len = 0;
+		sym = NULL;
+		n = getline(&sym, &len, fsyms);
+	}
+	ret = true;
+
+done:
+	free(sym);
+	free(obj);
+	fclose(fsyms);
+	return ret;
+}
+
+/* Searches for sympos of specific symbol in usr_symbols list */
+static bool get_usr_sympos(struct symbol *s, struct sympos *sp)
+{
+	struct sympos *aux;
+
+	list_for_each_entry(aux, &usr_symbols, list) {
+		if (strcmp(aux->symbol_name, s->name) == 0) {
+			sp->symbol_name = aux->symbol_name;
+			sp->object_name = aux->object_name;
+			sp->pos = aux->pos;
+			return true;
+		}
+	}
+	return false;
+}
+
+/* Removes symbols used for sympos annotation from livepatch elf object */
+static void clear_sympos_symbols(struct section *annotation_sec,
+		struct elf *klp_elf)
+{
+	struct symbol *sym, *aux;
+
+	list_for_each_entry_safe(sym, aux, &klp_elf->symbols, list) {
+		if (sym->sec == annotation_sec) {
+
+			struct section *sec;
+			struct rela *rela, *tmprela;
+
+			list_for_each_entry(sec, &klp_elf->sections, list) {
+				list_for_each_entry_safe(rela, tmprela, &sec->relas, list) {
+					if (rela->sym == sym) {
+						list_del(&rela->list);
+						free(rela);
+					}
+				}
+			}
+
+			list_del(&sym->list);
+			free(sym);
+		}
+	}
+}
+
+/* Removes annotation from livepatch elf object */
+static void clear_sympos_annontations(struct elf *klp_elf)
+{
+	struct section *sec, *aux;
+
+	list_for_each_entry_safe(sec, aux, &klp_elf->sections, list) {
+		if (strncmp(sec->name, ".klp.module_relocs.", 19) == 0) {
+			clear_sympos_symbols(sec, klp_elf);
+			list_del(&sec->list);
+			free(sec);
+			continue;
+		}
+		if (strncmp(sec->name, ".rela.klp.module_relocs.", 24) == 0) {
+
+			struct rela *rela, *tmprela;
+
+			list_for_each_entry_safe(rela, tmprela, &sec->relas, list) {
+				list_del(&rela->list);
+				free(rela);
+			}
+			list_del(&sec->list);
+			free(sec);
+			continue;
+		}
+	}
+}
+
+/*
+ * User provided sympos annotation checks:
+ * - do two or more elements in usr_symbols have the same object and
+ *   name, but different symbol position
+ * - are there any usr_symbols without a rela?
+ */
+static bool sympos_sanity_check(struct elf *klp_elf)
+{
+	bool sane = true;
+	struct sympos *sp, *aux;
+	struct section *sec;
+	struct rela *rela;
+
+	list_for_each_entry(sp, &usr_symbols, list) {
+		bool found_rela = false;
+
+		aux = list_next_entry(sp, list);
+		list_for_each_entry_from(aux, &usr_symbols, list) {
+			if (sp->pos != aux->pos &&
+			    strcmp(sp->object_name, aux->object_name) == 0 &&
+			    strcmp(sp->symbol_name, aux->symbol_name) == 0) {
+				WARN("Conflicting KLP_SYMPOS definition: %s.%s %d vs. %d.",
+				sp->object_name, sp->symbol_name, sp->pos, aux->pos);
+				sane = false;
+			}
+		}
+
+		list_for_each_entry(sec, &klp_elf->sections, list) {
+			list_for_each_entry(rela, &sec->relas, list) {
+				if (!strcmp(sp->symbol_name, rela->sym->name)) {
+					found_rela = true;
+					break;
+				}
+			}
+		}
+		if (!found_rela) {
+			sane = false;
+			WARN("Couldn't find rela for annotated symbol: %s",
+				sp->symbol_name);
+		}
+	}
+
+	return sane;
+}
+
+/* Parses the livepatch elf object and fills usr_symbols */
+static bool load_usr_symbols(struct elf *klp_elf)
+{
+	char objname[MODULE_NAME_LEN];
+	struct sympos *sp;
+	struct section *sec, *relasec;
+	struct rela *rela;
+	Elf_Data converted_data;
+	struct klp_module_reloc *reloc;
+	int i, nr_entries;
+
+	list_for_each_entry(sec, &klp_elf->sections, list) {
+		if (sscanf(sec->name, ".klp.module_relocs.%55s", objname) != 1)
+			continue;
+
+		/*
+		 * SYMPOS annotations are saved into arrays in
+		 * .klp.module_relocs.* sections of type PROGBITS, so we
+		 * need to manually translate the .sympos endianness in
+		 * case we may be cross-compiling.
+		 */
+		sec->elf_data->d_type = ELF_T_WORD;
+		converted_data.d_buf = sec->elf_data->d_buf;
+		converted_data.d_size = sec->elf_data->d_size;
+		converted_data.d_version = sec->elf_data->d_version;
+		gelf_xlatetom(klp_elf->elf, &converted_data, sec->elf_data,
+			      elf_getident(klp_elf->elf, NULL)[EI_DATA]);
+
+		reloc = converted_data.d_buf;
+		relasec = sec->rela;
+
+		i = 0;
+		nr_entries = sec->size / sizeof(*reloc);
+		list_for_each_entry(rela, &relasec->relas, list) {
+			if (i >= nr_entries) {
+				WARN("section %s length beyond nr_entries\n",
+						relasec->name);
+				return false;
+			}
+			sp = calloc(1, sizeof(struct sympos));
+			if (!sp) {
+				WARN("Unable to allocate sympos memory\n");
+				return false;
+			}
+			sp->object_name = strdup(objname);
+			if (!sp->object_name) {
+				WARN("Unable to allocate object name\n");
+				free(sp);
+				return false;
+			}
+			sp->symbol_name = strdup(rela->sym->name);
+			if (!sp->symbol_name) {
+				WARN("Unable to allocate symbol name\n");
+				free(sp);
+				return false;
+			}
+			sp->pos = reloc[i].sympos;
+			list_add(&sp->list, &usr_symbols);
+			i++;
+		}
+		if (i != nr_entries) {
+			WARN("nr_entries mismatch (%d != %d) for %s\n",
+					i, nr_entries, relasec->name);
+			return false;
+		}
+	}
+	clear_sympos_annontations(klp_elf);
+	return sympos_sanity_check(klp_elf);
+}
+
+/* prints list of valid sympos for symbol with provided name */
+static void print_valid_module_relocs(char *name)
+{
+	struct symbol_entry *e;
+	char *cur_obj = "";
+	int counter = 0;
+	bool first = true;
+
+	/* Symbols from the same object are locally gathered in the list */
+	list_for_each_entry(e, &symbols, list) {
+		if (strcmp(e->object_name, cur_obj) != 0) {
+			cur_obj = e->object_name;
+			counter = 0;
+		}
+		if (strcmp(e->symbol_name, name) == 0) {
+			if (counter == 0) {
+				if (first) {
+					fprintf(stderr, "Valid KLP_SYMPOS for symbol %s:\n", name);
+					fprintf(stderr, "-------------------------------------------------\n");
+				} else {
+					fprintf(stderr, "}\n");
+				}
+
+				fprintf(stderr, "KLP_MODULE_RELOC(%s){\n",
+						cur_obj);
+				first = false;
+			}
+			fprintf(stderr, "\tKLP_SYMPOS(%s,%d)\n", name, counter);
+			counter++;
+		}
+	}
+	if (!first) {
+		fprintf(stderr, "}\n");
+		fprintf(stderr, "-------------------------------------------------\n");
+	}
+}
+
+/*
+ * Searches for symbol in symbols list and returns its sympos if it is unique,
+ * otherwise prints a list with all considered valid sympos
+ */
+static struct symbol_entry *find_sym_entry_by_name(char *name)
+{
+	struct symbol_entry *found = NULL;
+	struct symbol_entry *e;
+
+	list_for_each_entry(e, &symbols, list) {
+		if (strcmp(e->symbol_name, name) == 0) {
+
+			/*
+			 * If there exist multiple symbols with the same
+			 * name then user-provided sympos is required
+			 */
+			if (found) {
+				WARN("Define KLP_SYMPOS for the symbol: %s",
+						e->symbol_name);
+
+				print_valid_module_relocs(name);
+				return NULL;
+			}
+			found = e;
+		}
+	}
+
+	return found;
+}
+
+/* Checks if sympos is valid, otherwise prints valid sympos list */
+static bool valid_sympos(struct sympos *sp)
+{
+	struct symbol_entry *e;
+
+	if (sp->pos == 0) {
+
+		/*
+		 * sympos of 0 is reserved for uniquely named obj:sym,
+		 * verify that this is the case
+		 */
+		int counter = 0;
+
+		list_for_each_entry(e, &symbols, list) {
+			if ((strcmp(e->symbol_name, sp->symbol_name) == 0) &&
+			    (strcmp(e->object_name, sp->object_name) == 0)) {
+				counter++;
+			}
+		}
+		if (counter == 1)
+			return true;
+
+		WARN("Provided KLP_SYMPOS of 0, but found %d symbols matching: %s.%s,%d",
+				counter, sp->object_name, sp->symbol_name,
+				sp->pos);
+
+	} else {
+
+		/*
+		 * sympos > 0 indicates a specific commonly-named obj:sym,
+		 * indexing starts with 1
+		 */
+		int index = 1;
+
+		list_for_each_entry(e, &symbols, list) {
+			if ((strcmp(e->symbol_name, sp->symbol_name) == 0) &&
+			    (strcmp(e->object_name, sp->object_name) == 0)) {
+				if (index == sp->pos)
+					return true;
+				index++;
+			}
+		}
+
+		WARN("Provided KLP_SYMPOS does not match a symbol: %s.%s,%d",
+				sp->object_name, sp->symbol_name, sp->pos);
+	}
+
+	print_valid_module_relocs(sp->symbol_name);
+
+	return false;
+}
+
+/*
+ * Add this symbol to the converted_symbols list to cache its sympos and
+ * for later renaming.
+ */
+static bool remember_sympos(struct symbol *s, struct sympos *sp)
+{
+	struct converted_sym *cs;
+
+	cs = calloc(1, sizeof(*cs));
+	if (!cs) {
+		WARN("Unable to allocate converted_symbol entry");
+		return false;
+	}
+
+	cs->symbol = s;
+	cs->sympos = *sp;
+	list_add(&cs->list, &converted_symbols);
+
+	return true;
+}
+
+/* Returns the right sympos respective to a symbol to be relocated */
+static bool find_sympos(struct symbol *s, struct sympos *sp)
+{
+	struct symbol_entry *entry;
+	struct converted_sym *cs;
+
+	/* did we already convert this symbol? */
+	list_for_each_entry(cs, &converted_symbols, list) {
+		if (cs->symbol == s) {
+			*sp = cs->sympos;
+			return true;
+		}
+	}
+
+	/* did the user specified via annotation? */
+	if (get_usr_sympos(s, sp)) {
+		if (valid_sympos(sp)) {
+			remember_sympos(s, sp);
+			return true;
+		}
+		return false;
+	}
+
+	/*
+	 * user didn't specify, so search the symbols list. A pos of 0
+	 * indicates this should be a unique symbol.
+	 */
+	entry = find_sym_entry_by_name(s->name);
+	if (entry) {
+		sp->symbol_name = entry->symbol_name;
+		sp->object_name = entry->object_name;
+		sp->pos = 0;
+		remember_sympos(s, sp);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Finds or creates a klp rela section based on another given section (@oldsec)
+ * and sympos (@*sp), then returns it
+ */
+static struct section *get_or_create_klp_rela_section(struct section *oldsec,
+		struct sympos *sp, struct elf *klp_elf)
+{
+	char *name;
+	struct section *sec;
+	unsigned int length;
+
+	length = strlen(KLP_RELA_PREFIX) + strlen(sp->object_name)
+		 + strlen(oldsec->base->name) + 2;
+
+	name = calloc(1, length);
+	if (!name) {
+		WARN("Memory allocation failed (%s%s.%s)\n", KLP_RELA_PREFIX,
+				sp->object_name, oldsec->base->name);
+		return NULL;
+	}
+
+	if (safe_snprintf(name, length, KLP_RELA_PREFIX "%s.%s",
+			  sp->object_name, oldsec->base->name)) {
+		WARN("Length error (%s)", name);
+		free(name);
+		return NULL;
+	}
+
+	sec = find_section_by_name(klp_elf, name);
+	if (!sec)
+		sec = create_rela_section(klp_elf, name, oldsec->base);
+
+	if (sec)
+		sec->sh.sh_flags |= SHF_RELA_LIVEPATCH;
+
+	free(name);
+	return sec;
+}
+
+/* Converts rela symbol names */
+static bool convert_symbol(struct symbol *s, struct sympos *sp)
+{
+	char *name;
+	char pos[4];	/* assume that pos will never be > 999 */
+	unsigned int length;
+
+	if (safe_snprintf(pos, sizeof(pos), "%d", sp->pos)) {
+		WARN("Insufficient buffer for expanding sympos (%s.%s,%d)\n",
+				sp->object_name, sp->symbol_name, sp->pos);
+		return false;
+	}
+
+	length = strlen(KLP_SYM_PREFIX) + strlen(sp->object_name)
+		 + strlen(sp->symbol_name) + sizeof(pos) + 3;
+
+	name = calloc(1, length);
+	if (!name) {
+		WARN("Memory allocation failed (%s%s.%s,%s)\n", KLP_SYM_PREFIX,
+				sp->object_name, sp->symbol_name, pos);
+		return false;
+	}
+
+	if (safe_snprintf(name, length, KLP_SYM_PREFIX "%s.%s,%s",
+			  sp->object_name, sp->symbol_name, pos)) {
+
+		WARN("Length error (%s%s.%s,%s)", KLP_SYM_PREFIX,
+				sp->object_name, sp->symbol_name, pos);
+		free(name);
+		return false;
+	}
+
+	/*
+	 * Despite the memory waste, we don't mind freeing the original symbol
+	 * name memory chunk. Keeping it there is harmless and, since removing
+	 * bytes from the string section is non-trivial, it is unworthy.
+	 */
+	s->name = name;
+	s->sec = NULL;
+	s->sym.st_name = -1;
+	s->sym.st_shndx = SHN_LIVEPATCH;
+
+	return true;
+}
+
+/* Checks if a rela was converted */
+static bool is_converted_rela(struct rela *rela)
+{
+	return !!rela->klp_rela_sec;
+}
+
+/*
+ * Convert rela that cannot be resolved by the classic module loader
+ * to the special klp rela one.
+ */
+static bool convert_rela(struct section *oldsec, struct rela *rela,
+		struct sympos *sp, struct elf *klp_elf)
+{
+	struct section *sec;
+
+	sec = get_or_create_klp_rela_section(oldsec, sp, klp_elf);
+	if (!sec) {
+		WARN("Can't create or access klp.rela section (%s.%s)\n",
+				sp->object_name, sp->symbol_name);
+		return false;
+	}
+
+	rela->klp_rela_sec = sec;
+
+	return true;
+}
+
+static void move_rela(struct rela *r)
+{
+	/* Move the converted rela to klp rela section */
+	list_del(&r->list);
+	list_add_tail(&r->list, &r->klp_rela_sec->relas);
+}
+
+/* Checks if given symbol name matches a symbol in exp_symbols */
+static bool is_exported(char *sname)
+{
+	struct symbol_entry *e;
+
+	/*
+	 * exp_symbols itens are prefixed with __ksymtab_ - comparisons must
+	 * skip prefix and check if both are properly null-terminated
+	 */
+	list_for_each_entry(e, &exp_symbols, list) {
+		if (strcmp(e->symbol_name + 10, sname) == 0)
+			return true;
+	}
+	return false;
+}
+
+/* Checks if symbol should be skipped */
+static bool skip_symbol(struct symbol *sym)
+{
+	/* already resolved? */
+	if (sym->sec)
+		return true;
+
+	/* skip symbol with index 0 */
+	if (!sym->idx)
+		return true;
+
+	/* we should not touch .TOC. on ppc64le */
+	if (strcmp(sym->name, ".TOC.") == 0)
+		return true;
+
+	if (is_exported(sym->name))
+		return true;
+
+	return false;
+}
+
+/* Checks if a section is a klp rela section */
+static bool is_klp_rela_section(char *sname)
+{
+	int len = strlen(KLP_RELA_PREFIX);
+
+	if (strncmp(sname, KLP_RELA_PREFIX, len) == 0)
+		return true;
+	return false;
+}
+
+/*
+ * Frees the list, new names and rela sections as created by
+ * remember_sympos(), convert_rela(), and convert_symbol()
+ */
+static void free_converted_resources(struct elf *klp_elf)
+{
+	struct converted_sym *cs, *cs_aux;
+	struct section *sec;
+
+	list_for_each_entry_safe(cs, cs_aux, &converted_symbols, list) {
+		free(cs->symbol->name);
+		free(cs);
+	}
+
+	list_for_each_entry(sec, &klp_elf->sections, list) {
+		if (is_klp_rela_section(sec->name)) {
+			free(sec->elf_data);
+			free(sec->name);
+		}
+	}
+}
+
+/*
+ * Checks if section may be skipped (conditions)
+ */
+static bool skip_section(struct section *sec)
+{
+	if (!is_rela_section(sec))
+		return true;
+
+	if (is_klp_rela_section(sec->name))
+		return true;
+
+	return false;
+}
+
+/*
+ * Checks if rela conversion is supported in given section
+ */
+static bool supported_section(struct section *sec, char *object_name)
+{
+#if 0
+	/*
+	 * klp-relocations forbidden in sections that otherwise would
+	 * match in allowed_prefixes[]
+	 */
+	static const char * const not_allowed[] = {
+		".rela.data.rel.ro",
+		".rela.data.rel.ro.local",
+		".rela.data..ro_after_init",
+		NULL
+	};
+#endif
+
+	/* klp-relocations allowed in sections only for vmlinux */
+	static const char * const allowed_vmlinux[] = {
+		".rela__jump_table",
+		NULL
+	};
+
+	/* klp-relocations allowed in sections with prefixes */
+	static const char * const allowed_prefixes[] = {
+		".rela.data",
+		".rela.rodata",	// supported ???
+		".rela.sdata",
+		".rela.text",
+		".rela.toc",
+		NULL
+	};
+
+	const char * const *name;
+
+#if 0
+	for (name = not_allowed; *name; name++)
+		if (strcmp(sec->name, *name) == 0)
+			return false;
+#endif
+
+	if (strcmp(object_name, "vmlinux") == 0) {
+		for (name = allowed_vmlinux; *name; name++)
+			if (strcmp(sec->name, *name) == 0)
+				return true;
+	}
+
+	for (name = allowed_prefixes; *name; name++)
+		if (strncmp(sec->name, *name, strlen(*name)) == 0)
+			return true;
+
+	return false;
+}
+
+int main(int argc, const char **argv)
+{
+	const char *klp_in_module, *klp_out_module, *symbols_list;
+	struct rela *rela, *tmprela;
+	struct section *sec;
+	struct sympos sp;
+	struct elf *klp_elf;
+	struct converted_sym *cs;
+	int errors = 0;
+
+	if (argc != 4) {
+		WARN("Usage: %s <symbols.klp> <input.ko> <output.ko>", argv[0]);
+		return -1;
+	}
+
+	symbols_list = argv[1];
+	klp_in_module = argv[2];
+	klp_out_module = argv[3];
+
+	klp_elf = elf_open(klp_in_module);
+	if (!klp_elf) {
+		WARN("Unable to read elf file %s\n", klp_in_module);
+		return -1;
+	}
+
+	if (!load_syms_lists(symbols_list))
+		return -1;
+
+	if (!load_usr_symbols(klp_elf)) {
+		WARN("Unable to load user-provided sympos");
+		return -1;
+	}
+
+	list_for_each_entry(sec, &klp_elf->sections, list) {
+		if (skip_section(sec))
+			continue;
+
+		list_for_each_entry(rela, &sec->relas, list) {
+			if (skip_symbol(rela->sym))
+				continue;
+
+			/* rela needs to be converted */
+
+			if (!find_sympos(rela->sym, &sp)) {
+				WARN("Unable to find missing symbol: %s",
+						rela->sym->name);
+				errors++;
+				continue;
+			}
+			if (!supported_section(sec, sp.object_name)) {
+				WARN("Conversion not supported for symbol: %s section: %s object: %s",
+						rela->sym->name, sec->name,
+						sp.object_name);
+				errors++;
+				continue;
+			}
+			if (!convert_rela(sec, rela, &sp, klp_elf)) {
+				WARN("Unable to convert relocation: %s",
+						rela->sym->name);
+				return -1;
+			}
+		}
+
+		if (errors)
+			return -1;
+
+		/* Now move all converted relas in list-safe manner */
+		list_for_each_entry_safe(rela, tmprela, &sec->relas, list) {
+			if (is_converted_rela(rela))
+				move_rela(rela);
+		}
+	}
+
+	/* Rename the converted symbols */
+	list_for_each_entry(cs, &converted_symbols, list) {
+		if (!convert_symbol(cs->symbol, &cs->sympos)) {
+			WARN("Unable to convert symbol name (%s)\n",
+					cs->symbol->name);
+			return -1;
+		}
+	}
+
+	free_syms_lists();
+	if (elf_write_file(klp_elf, klp_out_module))
+		return -1;
+
+	free_converted_resources(klp_elf);
+	elf_close(klp_elf);
+
+	return 0;
+}
+
+/* Functions kept commented since they might be useful for future debugging */
+
+/* Dumps sympos list (useful for debugging purposes)
+ * static void dump_sympos(void)
+ * {
+ *	struct sympos *sp;
+ *
+ *	fprintf(stderr, "BEGIN OF SYMPOS DUMP\n");
+ *	list_for_each_entry(sp, &usr_symbols, list) {
+ *		fprintf(stderr, "%s %s %d\n", sp->symbol_name, sp->object_name,
+ *				sp->pos);
+ *	}
+ *	fprintf(stderr, "END OF SYMPOS DUMP\n");
+ * }
+ *
+ *
+ * / Dump symbols list for debugging purposes /
+ * static void dump_symbols(void)
+ * {
+ *	struct symbol_entry *entry;
+ *
+ *	fprintf(stderr, "BEGIN OF SYMBOLS DUMP\n");
+ *	list_for_each_entry(entry, &symbols, list)
+ *		printf("%s %s\n", entry->object_name, entry->symbol_name);
+ *	fprintf(stderr, "END OF SYMBOLS DUMP\n");
+ * }
+ */
diff --git a/scripts/livepatch/klp-convert.h b/scripts/livepatch/klp-convert.h
new file mode 100644
index 000000000000..35b9dc4e32c4
--- /dev/null
+++ b/scripts/livepatch/klp-convert.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
+ * Copyright (C) 2017 Joao Moreira   <jmoreira@suse.de>
+ *
+ */
+
+#define SHN_LIVEPATCH		0xff20
+#define SHF_RELA_LIVEPATCH	0x00100000
+#define MODULE_NAME_LEN		(64 - sizeof(GElf_Addr))
+#define WARN(format, ...) \
+	fprintf(stderr, "klp-convert: " format "\n", ##__VA_ARGS__)
+
+struct symbol_entry {
+	struct list_head list;
+	char *symbol_name;
+	char *object_name;
+};
+
+struct sympos {
+	struct list_head list;
+	char *symbol_name;
+	char *object_name;
+	int pos;
+};
+
+/*
+ * klp-convert uses macros and structures defined in the linux sources
+ * package (see include/uapi/linux/livepatch.h). To prevent the
+ * dependency when building locally, they are defined below. Also notice
+ * that these should match the definitions from the targeted kernel.
+ */
+
+#define KLP_RELA_PREFIX		".klp.rela."
+#define KLP_SYM_PREFIX		".klp.sym."
+
+#ifndef __packed
+#define __packed        __attribute__((packed))
+#endif
+
+struct klp_module_reloc {
+	union {
+		void *sym;
+		uint64_t sym64;	/* Force 64-bit width */
+	};
+	uint32_t sympos;
+} __packed;
diff --git a/scripts/livepatch/list.h b/scripts/livepatch/list.h
new file mode 100644
index 000000000000..4d429120fabf
--- /dev/null
+++ b/scripts/livepatch/list.h
@@ -0,0 +1,391 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_LIST_H
+#define _LINUX_LIST_H
+
+/*
+ * Simple doubly linked list implementation.
+ *
+ * Some of the internal functions ("__xxx") are useful when
+ * manipulating whole lists rather than single entries, as
+ * sometimes we already know the next/prev entries and we can
+ * generate better code by using them directly rather than
+ * using the generic single-entry routines.
+ */
+
+#define WRITE_ONCE(a, b) (a = b)
+#define READ_ONCE(a) a
+
+#undef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:        the pointer to the member.
+ * @type:       the type of the container struct this is embedded in.
+ * @member:     the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+static inline void INIT_LIST_HEAD(struct list_head *list)
+{
+	WRITE_ONCE(list->next, list);
+	list->prev = list;
+}
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	WRITE_ONCE(prev->next, new);
+}
+
+/**
+ * list_add - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ */
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head, head->next);
+}
+
+
+/**
+ * list_add_tail - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ */
+static inline void list_add_tail(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head->prev, head);
+}
+
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head *prev, struct list_head *next)
+{
+	next->prev = prev;
+	WRITE_ONCE(prev->next, next);
+}
+
+/**
+ * list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * Note: list_empty() on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void __list_del_entry(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
+/**
+ * list_is_last - tests whether @list is the last entry in list @head
+ * @list: the entry to test
+ * @head: the head of the list
+ */
+static inline int list_is_last(const struct list_head *list,
+				const struct list_head *head)
+{
+	return list->next == head;
+}
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline int list_empty(const struct list_head *head)
+{
+	return READ_ONCE(head->next) == head;
+}
+
+/**
+ * list_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/**
+ * list_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+/**
+ * list_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+
+/**
+ * list_first_entry_or_null - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_first_entry_or_null(ptr, type, member) \
+	(!list_empty(ptr) ? list_first_entry(ptr, type, member) : NULL)
+
+/**
+ * list_next_entry - get the next element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_next_entry(pos, member) \
+	list_entry((pos)->member.next, typeof(*(pos)), member)
+
+/**
+ * list_prev_entry - get the prev element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_prev_entry(pos, member) \
+	list_entry((pos)->member.prev, typeof(*(pos)), member)
+
+/**
+ * list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+/**
+ * list_for_each_prev	-	iterate over a list backwards
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev(pos, head) \
+	for (pos = (head)->prev; pos != (head); pos = pos->prev)
+
+/**
+ * list_for_each_safe - iterate over a list safe against removal of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+/**
+ * list_for_each_prev_safe - iterate over a list backwards safe against removal
+   of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev_safe(pos, n, head) \
+	for (pos = (head)->prev, n = pos->prev; \
+	     pos != (head); \
+	     pos = n, n = pos->prev)
+
+/**
+ * list_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry(pos, head, member)				\
+	for (pos = list_first_entry(head, typeof(*pos), member);	\
+	     &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
+
+/**
+ * list_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_last_entry(head, typeof(*pos), member);		\
+	     &pos->member != (head);					\
+	     pos = list_prev_entry(pos, member))
+
+/**
+ * list_prepare_entry - prepare a pos entry for use in
+   list_for_each_entry_continue()
+ * @pos:	the type * to use as a start point
+ * @head:	the head of the list
+ * @member:	the name of the list_head within the struct.
+ *
+ * Prepares a pos entry for use as a start point in
+   list_for_each_entry_continue().
+ */
+#define list_prepare_entry(pos, head, member) \
+	((pos) ? : list_entry(head, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_continue - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue(pos, head, member)			\
+	for (pos = list_next_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
+
+/**
+ * list_for_each_entry_continue_reverse - iterate backwards from the given point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Start to iterate over list of given type backwards, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue_reverse(pos, head, member)		\
+	for (pos = list_prev_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = list_prev_entry(pos, member))
+
+/**
+ * list_for_each_entry_from - iterate over list of given type from the current
+   point
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing from current position.
+ */
+#define list_for_each_entry_from(pos, head, member)			\
+	for (; &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
+
+/**
+ * list_for_each_entry_safe - iterate over list of given type safe against
+   removal of list entry
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_first_entry(head, typeof(*pos), member),	\
+		n = list_next_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = n, n = list_next_entry(n, member))
+
+/**
+ * list_for_each_entry_safe_continue - continue list iteration safe against
+ * removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_for_each_entry_safe_continue(pos, n, head, member)		\
+	for (pos = list_next_entry(pos, member),			\
+		n = list_next_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = n, n = list_next_entry(n, member))
+
+/**
+ * list_for_each_entry_safe_from - iterate over list from current point safe
+ * against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_for_each_entry_safe_from(pos, n, head, member)		\
+	for (n = list_next_entry(pos, member);				\
+	     &pos->member != (head);					\
+	     pos = n, n = list_next_entry(n, member))
+
+/**
+ * list_for_each_entry_safe_reverse - iterate backwards over list safe against
+ * removal
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
+	for (pos = list_last_entry(head, typeof(*pos), member),		\
+		n = list_prev_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = n, n = list_prev_entry(n, member))
+
+/**
+ * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
+ * @pos:	the loop cursor used in the list_for_each_entry_safe loop
+ * @n:		temporary storage used in list_for_each_entry_safe
+ * @member:	the name of the list_head within the struct.
+ *
+ * list_safe_reset_next is not safe to use in general if the list may be
+ * modified concurrently (eg. the lock is dropped in the loop body). An
+ * exception to this is if the cursor element (pos) is pinned in the list,
+ * and list_safe_reset_next is called after re-taking the lock and before
+ * completing the current iteration of the loop body.
+ */
+#define list_safe_reset_next(pos, n, member)				\
+	(n = list_next_entry(pos, member))
+
+#endif
-- 
2.39.2

