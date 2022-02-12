Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF904B351D
	for <lists+live-patching@lfdr.de>; Sat, 12 Feb 2022 14:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiBLNFQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 12 Feb 2022 08:05:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbiBLNFQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 12 Feb 2022 08:05:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2887526AD9;
        Sat, 12 Feb 2022 05:05:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB87660E95;
        Sat, 12 Feb 2022 13:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447EDC340EB;
        Sat, 12 Feb 2022 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644671112;
        bh=yiz4DbQ/9AlF3A85iP89O9KMYTiZPJew/nsawP2NfBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjgQqZcTVs54Odi7AbrrQ61E0tsUMGzcvI9iA9Gfj1wgYbGtDuu40qzG44M33l6SV
         kDi+/m48YYmrISM29v1qsKWDqOP/lfvaeWTQK8tDZDuFy6+UfBQ3mW0u93ngzaRd54
         O7jBU1Fbc0Acxa6GspCq6AR/YIitL2b2/quJyL3nWg+mwZFxfDUSuuU1UcwpvePFjx
         YaKT4XW/l9cK5ytmFeWNhuSdiWU2FPoDOASMQ/efz5eAyE5lmK4qlU5bSc7F95V7Ib
         7Y/MOYDW6+QniE8ubRnNJMCsLXMT4+pFtSz3BEQ7hkl93HSbeA15NeBl5Ef+YoCOUt
         c36T/9jBfi6Bg==
From:   Miguel Ojeda <ojeda@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        live-patching@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH v4 02/20] kallsyms: increase maximum kernel symbol length to 512
Date:   Sat, 12 Feb 2022 14:03:28 +0100
Message-Id: <20220212130410.6901-3-ojeda@kernel.org>
In-Reply-To: <20220212130410.6901-1-ojeda@kernel.org>
References: <20220212130410.6901-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Rust symbols can become quite long due to namespacing introduced
by modules, types, traits, generics, etc. For instance,
the following code:

    pub mod my_module {
        pub struct MyType;
        pub struct MyGenericType<T>(T);

        pub trait MyTrait {
            fn my_method() -> u32;
        }

        impl MyTrait for MyGenericType<MyType> {
            fn my_method() -> u32 {
                42
            }
        }
    }

generates a symbol of length 96 when using the upcoming v0 mangling scheme:

    _RNvXNtCshGpAVYOtgW1_7example9my_moduleINtB2_13MyGenericTypeNtB2_6MyTypeENtB2_7MyTrait9my_method

At the moment, Rust symbols may reach up to 300 in length.
Setting 512 as the maximum seems like a reasonable choice to
keep some headroom.

Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
Co-developed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Gary Guo <gary@garyguo.net>
Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/kallsyms.h            | 2 +-
 kernel/livepatch/core.c             | 4 ++--
 scripts/kallsyms.c                  | 2 +-
 tools/include/linux/kallsyms.h      | 2 +-
 tools/lib/perf/include/perf/event.h | 2 +-
 tools/lib/symbol/kallsyms.h         | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 4176c7eca7b5..5fb17dd4b6fa 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -15,7 +15,7 @@
 
 #include <asm/sections.h>
 
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 512
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s %s]") + \
 			(KSYM_NAME_LEN - 1) + \
 			2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + \
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 585494ec464f..01bfab7fe7c0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -213,7 +213,7 @@ static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
 	 * we use the smallest/strictest upper bound possible (56, based on
 	 * the current definition of MODULE_NAME_LEN) to prevent overflows.
 	 */
-	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
+	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 512);
 
 	relas = (Elf_Rela *) relasec->sh_addr;
 	/* For each rela in this klp relocation section */
@@ -227,7 +227,7 @@ static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
 
 		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%127[^,],%lu",
+			     ".klp.sym.%55[^.].%511[^,],%lu",
 			     sym_objname, sym_name, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 79b11bb7f07d..72ba0fe4e43b 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,7 +27,7 @@
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
-#define KSYM_NAME_LEN		128
+#define KSYM_NAME_LEN		512
 
 struct sym_entry {
 	unsigned long long addr;
diff --git a/tools/include/linux/kallsyms.h b/tools/include/linux/kallsyms.h
index efb6c3f5f2a9..5a37ccbec54f 100644
--- a/tools/include/linux/kallsyms.h
+++ b/tools/include/linux/kallsyms.h
@@ -6,7 +6,7 @@
 #include <stdio.h>
 #include <unistd.h>
 
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 512
 
 struct module;
 
diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 75ee385fb078..acc4fa065ec7 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -95,7 +95,7 @@ struct perf_record_throttle {
 };
 
 #ifndef KSYM_NAME_LEN
-#define KSYM_NAME_LEN 256
+#define KSYM_NAME_LEN 512
 #endif
 
 struct perf_record_ksymbol {
diff --git a/tools/lib/symbol/kallsyms.h b/tools/lib/symbol/kallsyms.h
index 72ab9870454b..542f9b059c3b 100644
--- a/tools/lib/symbol/kallsyms.h
+++ b/tools/lib/symbol/kallsyms.h
@@ -7,7 +7,7 @@
 #include <linux/types.h>
 
 #ifndef KSYM_NAME_LEN
-#define KSYM_NAME_LEN 256
+#define KSYM_NAME_LEN 512
 #endif
 
 static inline u8 kallsyms2elf_binding(char type)
-- 
2.35.1

