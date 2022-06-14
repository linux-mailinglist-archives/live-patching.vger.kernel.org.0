Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EDC54BCDC
	for <lists+live-patching@lfdr.de>; Tue, 14 Jun 2022 23:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiFNVgb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jun 2022 17:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiFNVga (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jun 2022 17:36:30 -0400
Received: from conuserg-08.nifty.com (conuserg-08.nifty.com [210.131.2.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25245515BA;
        Tue, 14 Jun 2022 14:36:27 -0700 (PDT)
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 25ELXIHV019651;
        Wed, 15 Jun 2022 06:33:18 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 25ELXIHV019651
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1655242400;
        bh=5+O/WET8/MvFr5QgfQja8FukZMFl5uO2WE+7ouj7R5A=;
        h=From:To:Cc:Subject:Date:From;
        b=rO0iCtvYLyc50iRSUlYdV5zCwWJEQvikyZLqAZ2QI6i4HfB2kuxsnmJ+keZs3/XP3
         9CkSJ8v6rJKSmQYdKl+LGVPhlAkTvjzNeX9Oip4haALg3epKPBSo+e/HnR3kwy4XAS
         H3beByBQ/xUYeZTKErQaWbnmmHeU2NcgXkb6m6I1dl/yyPs81DP4ZaeMAxmzIvuwtJ
         dRxgQIHQqtIMoPb+JdAwspye5SyXIcDNr4eRZponj6TZBrG7wraeaHEzaKpo9M6SZX
         ZD/1rAgRZuQ4PXWgVay7LRQmWTm7Lg8pHwYFX1zAt4zA+B+saiuxP+Ge5U5ZvT4ayB
         H/sEatkTLHhCw==
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
        Yanteng Si <siyanteng@loongson.cn>,
        Alex Shi <alexs@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Jens Axboe <axboe@kernel.dk>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Matthias Maennich <maennich@google.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] doc: module: update file references
Date:   Wed, 15 Jun 2022 06:33:03 +0900
Message-Id: <20220614213303.1944104-1-masahiroy@kernel.org>
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

Thanks to Yanteng Si for helping me to update
Documentation/translations/zh_CN/core-api/kernel-api.rst

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Yanteng Si <siyanteng@loongson.cn>
---

Changes in v2:
  - Update Documentation/translations/zh_CN/core-api/kernel-api.rst

 Documentation/core-api/kernel-api.rst                  |  2 +-
 Documentation/core-api/symbol-namespaces.rst           |  4 ++--
 Documentation/livepatch/module-elf-format.rst          | 10 +++++-----
 .../translations/it_IT/core-api/symbol-namespaces.rst  |  6 +++---
 .../translations/zh_CN/core-api/kernel-api.rst         |  2 +-
 .../translations/zh_CN/core-api/symbol-namespaces.rst  |  2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

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
diff --git a/Documentation/translations/zh_CN/core-api/kernel-api.rst b/Documentation/translations/zh_CN/core-api/kernel-api.rst
index e45fe80d1cd8..962d31d019d7 100644
--- a/Documentation/translations/zh_CN/core-api/kernel-api.rst
+++ b/Documentation/translations/zh_CN/core-api/kernel-api.rst
@@ -224,7 +224,7 @@ kernel/kmod.c
 模块接口支持
 ------------
 
-更多信息请参考文件kernel/module.c。
+更多信息请参阅kernel/module/目录下的文件。
 
 硬件接口
 ========
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

