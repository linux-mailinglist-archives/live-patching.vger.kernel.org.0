Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD00B5481A2
	for <lists+live-patching@lfdr.de>; Mon, 13 Jun 2022 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiFMIWU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Jun 2022 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiFMIWU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Jun 2022 04:22:20 -0400
Received: from condef-02.nifty.com (condef-02.nifty.com [202.248.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FBF102
        for <live-patching@vger.kernel.org>; Mon, 13 Jun 2022 01:22:18 -0700 (PDT)
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-02.nifty.com with ESMTP id 25D8JkOV004652
        for <live-patching@vger.kernel.org>; Mon, 13 Jun 2022 17:20:00 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 25D8Hqcs011074;
        Mon, 13 Jun 2022 17:17:52 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 25D8Hqcs011074
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1655108273;
        bh=CmhbukpBhZs7hao25rQlICLG+Ns0/87DXmi5jDvd2iE=;
        h=From:To:Cc:Subject:Date:From;
        b=hBKp+jS9P7HmrcT7zp7l6kQNJUNh88ugzYtEluVI0KDn7TlAkLIDc8ju3Mi1RuIeH
         N5S8Z6ThORDDGC/9XFYl+0Zod6QhGHMSD7Ds4vB+DnLevHTpIi8lZcB6NtoxMxRfbX
         bTCLu7klIZirLYKtICeNotC+RVxKTvmM+qAH2v7jrhz5zjVquH0z4tSbw+U510lBrN
         oh5JlCQJy7sMEamM1ncpm4+yIe8e/puiVt2+HU+ka2BNfHM9hZY2hio62Oy2Ir1vVO
         UwKckHWfho3ccbl9oir28ZefJYO1uSj4xgWcjC4wI3buDWwwhHoYScccyxw7eWa4K2
         IFrRwCAKfKCZg==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>, linux-modules@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alex Shi <alexs@kernel.org>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthias Maennich <maennich@google.com>,
        Yanteng Si <siyanteng@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] doc: module: update file references
Date:   Mon, 13 Jun 2022 17:17:40 +0900
Message-Id: <20220613081741.1699713-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Adjust documents to the file moves made by commit cfc1d277891e ("module:
Move all into module/").

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

I did not touch

  Documentation/translations/zh_CN/core-api/kernel-api.rst

because I cannot modify it.

 Documentation/core-api/kernel-api.rst                  |  2 +-
 Documentation/core-api/symbol-namespaces.rst           |  4 ++--
 Documentation/livepatch/module-elf-format.rst          | 10 +++++-----
 .../translations/it_IT/core-api/symbol-namespaces.rst  |  6 +++---
 .../translations/zh_CN/core-api/symbol-namespaces.rst  |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index d6b3f94b9f1f..0793c400d4b0 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -223,7 +223,7 @@ Module Loading
 Inter Module support
 --------------------
 
-Refer to the file kernel/module.c for more information.
+Refer to the files in kernel/module/ for more information.
 
 Hardware Interfaces
 ===================
diff --git a/Documentation/core-api/symbol-namespaces.rst b/Documentation/core-api/symbol-namespaces.rst
index 5ad9e0abe42c..12e4aecdae94 100644
--- a/Documentation/core-api/symbol-namespaces.rst
+++ b/Documentation/core-api/symbol-namespaces.rst
@@ -51,8 +51,8 @@ namespace ``USB_STORAGE``, use::
 The corresponding ksymtab entry struct ``kernel_symbol`` will have the member
 ``namespace`` set accordingly. A symbol that is exported without a namespace will
 refer to ``NULL``. There is no default namespace if none is defined. ``modpost``
-and kernel/module.c make use the namespace at build time or module load time,
-respectively.
+and kernel/module/main.c make use the namespace at build time or module load
+time, respectively.
 
 2.2 Using the DEFAULT_SYMBOL_NAMESPACE define
 =============================================
diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index dbe9b400e39f..7347638895a0 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -210,11 +210,11 @@ module->symtab.
 =====================================
 Normally, a stripped down copy of a module's symbol table (containing only
 "core" symbols) is made available through module->symtab (See layout_symtab()
-in kernel/module.c). For livepatch modules, the symbol table copied into memory
-on module load must be exactly the same as the symbol table produced when the
-patch module was compiled. This is because the relocations in each livepatch
-relocation section refer to their respective symbols with their symbol indices,
-and the original symbol indices (and thus the symtab ordering) must be
+in kernel/module/kallsyms.c). For livepatch modules, the symbol table copied
+into memory on module load must be exactly the same as the symbol table produced
+when the patch module was compiled. This is because the relocations in each
+livepatch relocation section refer to their respective symbols with their symbol
+indices, and the original symbol indices (and thus the symtab ordering) must be
 preserved in order for apply_relocate_add() to find the right symbol.
 
 For example, take this particular rela from a livepatch module:::
diff --git a/Documentation/translations/it_IT/core-api/symbol-namespaces.rst b/Documentation/translations/it_IT/core-api/symbol-namespaces.rst
index 42f5d04e38ec..0f6898860d6d 100644
--- a/Documentation/translations/it_IT/core-api/symbol-namespaces.rst
+++ b/Documentation/translations/it_IT/core-api/symbol-namespaces.rst
@@ -50,9 +50,9 @@ Di conseguenza, nella tabella dei simboli del kernel ci sarà una voce
 rappresentata dalla struttura ``kernel_symbol`` che avrà il campo
 ``namespace`` (spazio dei nomi) impostato. Un simbolo esportato senza uno spazio
 dei nomi avrà questo campo impostato a ``NULL``. Non esiste uno spazio dei nomi
-di base. Il programma ``modpost`` e il codice in kernel/module.c usano lo spazio
-dei nomi, rispettivamente, durante la compilazione e durante il caricamento
-di un modulo.
+di base. Il programma ``modpost`` e il codice in kernel/module/main.c usano lo
+spazio dei nomi, rispettivamente, durante la compilazione e durante il
+caricamento di un modulo.
 
 2.2 Usare il simbolo di preprocessore DEFAULT_SYMBOL_NAMESPACE
 ==============================================================
diff --git a/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst b/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst
index 6abf7ed534ca..bb16f0611046 100644
--- a/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst
+++ b/Documentation/translations/zh_CN/core-api/symbol-namespaces.rst
@@ -52,7 +52,7 @@
 
 相应的 ksymtab 条目结构体 ``kernel_symbol`` 将有相应的成员 ``命名空间`` 集。
 导出时未指明命名空间的符号将指向 ``NULL`` 。如果没有定义命名空间，则默认没有。
-``modpost`` 和kernel/module.c分别在构建时或模块加载时使用名称空间。
+``modpost`` 和kernel/module/main.c分别在构建时或模块加载时使用名称空间。
 
 2.2 使用DEFAULT_SYMBOL_NAMESPACE定义
 ====================================
-- 
2.32.0

