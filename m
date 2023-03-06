Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C696AC369
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjCFOgG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCFOgE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:36:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD421FFA
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678113189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xFwo9eu0+wzRP94yzjuS6fZW2p5PlKsRc74jpEcNlVY=;
        b=diPizha6S8lQsi2EcmoP/d4GZcbHCpI+F/oR7VSxx3jGgCR5/vcRamvpqSYCq0bpebrJmh
        Fvx38kzkCbo0xvUMe93RDotNi58gpa5YzBJTg5H2v2EjtxNASNWjk5s0LEGhJon34kUHv8
        wvHoSjUA+bpZ7aOchWZLd4HO4CJgXiY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-pjhnYvaMOLms5hSBEqgyCA-1; Mon, 06 Mar 2023 09:08:30 -0500
X-MC-Unique: pjhnYvaMOLms5hSBEqgyCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F270E3C0255E;
        Mon,  6 Mar 2023 14:08:29 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95B7C40C10FA;
        Mon,  6 Mar 2023 14:08:29 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 08/10] livepatch/selftests: add __asm__ symbol renaming examples
Date:   Mon,  6 Mar 2023 09:08:22 -0500
Message-Id: <20230306140824.3858543-9-joe.lawrence@redhat.com>
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

GCC can rename symbols like static data and optimized functions, adding
a suffix that includes illegal C characters.  Extend the klp-convert
examples to demonstrate how to use __asm__ renaming from C code to
create klp-relocations to such renamed symbols.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 lib/livepatch/test_klp_convert.h                    | 2 ++
 lib/livepatch/test_klp_convert1.c                   | 8 ++++++++
 lib/livepatch/test_klp_convert_mod_a.c              | 6 ++++++
 lib/livepatch/test_klp_convert_mod_b.c              | 6 ++++++
 tools/testing/selftests/livepatch/test-livepatch.sh | 4 ++++
 5 files changed, 26 insertions(+)

diff --git a/lib/livepatch/test_klp_convert.h b/lib/livepatch/test_klp_convert.h
index 5d97bc546d6e..42befbfd63cb 100644
--- a/lib/livepatch/test_klp_convert.h
+++ b/lib/livepatch/test_klp_convert.h
@@ -10,5 +10,7 @@ extern char driver_name[];
 extern char homonym_string[];
 extern const char *get_homonym_string(void);
 extern const char *test_klp_get_driver_name(void);
+extern char klp_string_a[] __asm__("klp_string.12345");
+extern char klp_string_b[] __asm__("klp_string.67890");
 
 #endif
diff --git a/lib/livepatch/test_klp_convert1.c b/lib/livepatch/test_klp_convert1.c
index d4e1163c01cc..9541f40d70a8 100644
--- a/lib/livepatch/test_klp_convert1.c
+++ b/lib/livepatch/test_klp_convert1.c
@@ -25,6 +25,12 @@ static noinline void print_homonym_string(void)
 	pr_info("get_homonym_string(), 1: %s\n", get_homonym_string());
 }
 
+static noinline void print_static_strings(void)
+{
+	pr_info("klp_string.12345 = %s\n", klp_string_a);
+	pr_info("klp_string.67890 = %s\n", klp_string_b);
+}
+
 /* provide a sysfs handle to invoke debug functions */
 static int print_debug;
 static int print_debug_set(const char *val, const struct kernel_param *kp)
@@ -32,6 +38,7 @@ static int print_debug_set(const char *val, const struct kernel_param *kp)
 	print_saved_command_line();
 	print_driver_name();
 	print_homonym_string();
+	print_static_strings();
 
 	return 0;
 }
@@ -67,6 +74,7 @@ KLP_MODULE_RELOC(test_klp_convert_mod) test_klp_convert_mod_relocs_a[] = {
 	KLP_SYMPOS(homonym_string, 1),
 	KLP_SYMPOS(get_homonym_string, 1),
 	KLP_SYMPOS(test_klp_get_driver_name, 0),
+	KLP_SYMPOS(klp_string_b, 1),
 };
 
 static struct klp_func funcs[] = {
diff --git a/lib/livepatch/test_klp_convert_mod_a.c b/lib/livepatch/test_klp_convert_mod_a.c
index ae5e911fbb9b..9af0fcab0c8d 100644
--- a/lib/livepatch/test_klp_convert_mod_a.c
+++ b/lib/livepatch/test_klp_convert_mod_a.c
@@ -20,6 +20,12 @@ __used static const char *get_homonym_string(void)
 	return homonym_string;
 }
 
+__used static void static_string_function(void)
+{
+	__used static char klp_string[] __asm__("klp_string.12345") =
+		__FILE__ " static string";
+}
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
 MODULE_DESCRIPTION("Livepatch test: klp-convert module");
diff --git a/lib/livepatch/test_klp_convert_mod_b.c b/lib/livepatch/test_klp_convert_mod_b.c
index 5eca8a4cae38..0a68e898fe03 100644
--- a/lib/livepatch/test_klp_convert_mod_b.c
+++ b/lib/livepatch/test_klp_convert_mod_b.c
@@ -11,3 +11,9 @@ __used static const char *get_homonym_string(void)
 {
 	return homonym_string;
 }
+
+__used static void static_string_function(void)
+{
+	__used static char klp_string[] __asm__("klp_string.67890") =
+		__FILE__ " static string";
+}
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index bcb8b468b80a..ec3b6c919b01 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -200,6 +200,8 @@ $MOD_KLP_CONVERT1: driver_name, 0: $MOD_KLP_CONVERT_MOD
 $MOD_KLP_CONVERT1: test_klp_get_driver_name(), 0: $MOD_KLP_CONVERT_MOD
 $MOD_KLP_CONVERT1: homonym_string, 1: homonym string A
 $MOD_KLP_CONVERT1: get_homonym_string(), 1: homonym string A
+test_klp_convert1: klp_string.12345 = lib/livepatch/test_klp_convert_mod_a.c static string
+test_klp_convert1: klp_string.67890 = lib/livepatch/test_klp_convert_mod_b.c static string
 % echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT1/enabled
 livepatch: '$MOD_KLP_CONVERT1': initializing unpatching transition
 livepatch: '$MOD_KLP_CONVERT1': starting unpatching transition
@@ -265,6 +267,8 @@ $MOD_KLP_CONVERT1: driver_name, 0: $MOD_KLP_CONVERT_MOD
 $MOD_KLP_CONVERT1: test_klp_get_driver_name(), 0: $MOD_KLP_CONVERT_MOD
 $MOD_KLP_CONVERT1: homonym_string, 1: homonym string A
 $MOD_KLP_CONVERT1: get_homonym_string(), 1: homonym string A
+test_klp_convert1: klp_string.12345 = lib/livepatch/test_klp_convert_mod_a.c static string
+test_klp_convert1: klp_string.67890 = lib/livepatch/test_klp_convert_mod_b.c static string
 % echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT1/enabled
 livepatch: '$MOD_KLP_CONVERT1': initializing unpatching transition
 livepatch: '$MOD_KLP_CONVERT1': starting unpatching transition
-- 
2.39.2

