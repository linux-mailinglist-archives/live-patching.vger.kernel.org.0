Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB74B8E42
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbiBPQkJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:40:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiBPQkH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:40:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2138A25DA54
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645029593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bg4c13PG3YFA4cx/URObt9BCO2JrLpJ9gS9DNhRWcCM=;
        b=Pa3e9fu2Eohaq464t10HvXPhwgDTwZ7rTXvqoSmpKqjiKo08FwzZeU2i6LtLKI/Y+o7zm7
        Fu35GWNGoaHglnD/MDbI87uCFi3yfpH6Ep8WZCdP9WdzrAMhwsJ24L4ak8s7DeQe1xAVu7
        hO0lj8GhLY6jZfmupmpesMwPvZpZ76M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-ONL6tvcJN0mMHq0_Z0wugg-1; Wed, 16 Feb 2022 11:39:50 -0500
X-MC-Unique: ONL6tvcJN0mMHq0_Z0wugg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE486814243;
        Wed, 16 Feb 2022 16:39:48 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C619753CD;
        Wed, 16 Feb 2022 16:39:48 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [RFC PATCH v6 10/12] livepatch/selftests: add __asm__ symbol renaming examples
Date:   Wed, 16 Feb 2022 11:39:38 -0500
Message-Id: <20220216163940.228309-11-joe.lawrence@redhat.com>
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index cd2d3c638258..06926cf1c609 100644
--- a/lib/livepatch/test_klp_convert1.c
+++ b/lib/livepatch/test_klp_convert1.c
@@ -25,6 +25,12 @@ void print_homonym_string(void)
 	pr_info("get_homonym_string(), 1: %s\n", get_homonym_string());
 }
 
+void print_static_strings(void)
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
2.26.3

