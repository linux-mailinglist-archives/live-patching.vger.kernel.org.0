Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FFD1BE2A2
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgD2PZ0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727846AbgD2PZZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n7MNVntR2hzdBos1b1qY3omx/9gteBl17M6iJffUlGU=;
        b=FjmroO5ATiHZs+BrvFXPonU19yDpKHuvHKlF7ZRvP0B2wXEeJ8YnCzrIfMD82Brd3OjlPl
        KaEId8aFYGXr8PppqQY9nRj/jrFnCRXoxfIWRXFm2aUVlOkcAIcG9YxxR2WzTSpjiFYCcG
        ypZKbV27QeQxFYbOxxqj+d2CpqvbRl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-4uGGnM5wOgOOSpEELuMYZw-1; Wed, 29 Apr 2020 11:25:22 -0400
X-MC-Unique: 4uGGnM5wOgOOSpEELuMYZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EF2B80BC52;
        Wed, 29 Apr 2020 15:25:14 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 516C163BBE;
        Wed, 29 Apr 2020 15:25:13 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 11/11] module: Make module_enable_ro() static again
Date:   Wed, 29 Apr 2020 10:24:53 -0500
Message-Id: <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Now that module_enable_ro() has no more external users, make it static
again.

Suggested-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 include/linux/module.h | 6 ------
 kernel/module.c        | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e4ef7b36feda..2c2e988bcf10 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -858,12 +858,6 @@ extern int module_sysfs_initialized;
=20
 #define __MODULE_STRING(x) __stringify(x)
=20
-#ifdef CONFIG_STRICT_MODULE_RWX
-extern void module_enable_ro(const struct module *mod, bool after_init);
-#else
-static inline void module_enable_ro(const struct module *mod, bool after=
_init) { }
-#endif
-
 #ifdef CONFIG_GENERIC_BUG
 void module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
 			 struct module *);
diff --git a/kernel/module.c b/kernel/module.c
index f0e414a01d91..572d626508d2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2016,7 +2016,7 @@ static void frob_writable_data(const struct module_=
layout *layout,
 		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
 }
=20
-void module_enable_ro(const struct module *mod, bool after_init)
+static void module_enable_ro(const struct module *mod, bool after_init)
 {
 	if (!rodata_enabled)
 		return;
@@ -2057,7 +2057,7 @@ static int module_enforce_rwx_sections(Elf_Ehdr *hd=
r, Elf_Shdr *sechdrs,
 }
=20
 #else /* !CONFIG_STRICT_MODULE_RWX */
-/* module_{enable,disable}_ro() stubs are in module.h */
+static void module_enable_ro(const struct module *mod, bool after_init) =
{}
 static void module_enable_nx(const struct module *mod) { }
 static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 				       char *secstrings, struct module *mod)
--=20
2.21.1

