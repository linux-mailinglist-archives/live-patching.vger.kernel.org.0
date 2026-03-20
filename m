Return-Path: <live-patching+bounces-2250-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEmMAb2qvWk8AQMAu9opvQ
	(envelope-from <live-patching+bounces-2250-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 21:14:53 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD552E0C20
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 21:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7088C306B161
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 20:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66123CCFB3;
	Fri, 20 Mar 2026 20:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5s6rj1o";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0tREukZ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6BE3B9DBE
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 20:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774037660; cv=none; b=ZR6NMkcxA7Xu+e82sEf6wkY5oHn2Eo3hDb5h0enPIEdlTgRotcP06sogvSUpCEPQnYhtqepdvza72LTkh0BiKHoNVv6uyppxQLGEcYMEpFNBfwnOyunBN5lYNFIFge2HRn7nIIvtohBmKtkkERXbjX65x9IbTkX89TYXO3fQvbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774037660; c=relaxed/simple;
	bh=RMoWLRANM8/2/oMiqcxTksuxeQgvNQvDb9zxMCPcigY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tLNCs3ieTIp1pVT3x7a0AMFgpNGqopV4VhCowk5Gg48vL20JcrSfhYjeDpo2yJmIqOfT9qmALZf0hU69+dNgcboCrrpyMvxpr2AaBW2ESMD8nrkbyUHA4cGiyicokmWMDD5iAEaoiSO1UyFaBJfsdnZKhcNlqaqJ+YZH6kU2jqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A5s6rj1o; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H0tREukZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774037658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JPuumjF1Q/CxeVJhcu6LhrvdlVq1DqJdhZ9BrK6DHGc=;
	b=A5s6rj1oO85DKhQXxCbGvG1SK6bR/9SKRnHhLwjXtlOUB4Pgoe7bhW9MOnXhLL689FFg6e
	7y9/aoTHDvyzzW6Wr0re4UN7Emduj2i0znta6XKkNRhm1haW5DhGOoz9G9phPZdAaO0q5y
	V7vvREepENnJSfw2QeA1vhpa5WU49AQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-DavBuuXlOtua0KfD6Socdw-1; Fri, 20 Mar 2026 16:14:17 -0400
X-MC-Unique: DavBuuXlOtua0KfD6Socdw-1
X-Mimecast-MFC-AGG-ID: DavBuuXlOtua0KfD6Socdw_1774037656
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-790afc07667so49864147b3.0
        for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 13:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774037656; x=1774642456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JPuumjF1Q/CxeVJhcu6LhrvdlVq1DqJdhZ9BrK6DHGc=;
        b=H0tREukZAdHPYC+rdZQk6rJ9agWyIv6bnNUM1rEzxU6bZ7XbnNi7iq/CHdGFM4ndcQ
         /CzHqJNzIPpSgZ6GbrWMxh/RVPeTF+i4IfDh4q9+dtHCu37u9oV3weUltbRgj08x6umx
         zGTL/YOIGPP74fV0K0J7qubaqBPDwoX++73dd3R8YDIPHrpxkNaJ1h6g2KGOXhe/zJJs
         ZpjkazXomRhKuB2eMKR+p9V2OFFBTNlkSbC0r7jj2JwK7TYO4pN3mW467IRKQs+l5rAK
         m2JGDdJACWkqh2VA+FUweEn/lHSeQp3Fa6w/GRDvZNx9yLK7P4lUWUL1/1AhdbSyySsK
         Fkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774037656; x=1774642456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPuumjF1Q/CxeVJhcu6LhrvdlVq1DqJdhZ9BrK6DHGc=;
        b=aI7zD7YWDhd0DgMCsM8xIgLJBmYV9SjSJ3VIl2DT3VIzkVvIgwugMTD16mr8Ag84N9
         go9X1A1MsUrnEAbCnUlc/Gj33KNej0tlDwrkULIm9zOBxVZpVTRwrb5KuOmwtH7Ke9RE
         5slRvpS4j2m1YPtYw7Wdz3Hvf0v5TOEZ/J4AF4IqwoRBNWyC06jCTMDXo8NIb6014NN4
         J2qj4ehpTUNYqeM4uEeADWanJCNThfUOhfC+lyfOD9pKuhS7wlRRhVAZ4E73k7npEJVD
         3weMaL9NPhZ0XEhn2fLbOinH5VwG3EjWIzSMP9m/sYEwgwMKvJRImTvyxxec5Gy+Luso
         xh5w==
X-Gm-Message-State: AOJu0YzkJ1wuNUDF6+OhBB+ZqnlyuADk5zsoiULXpId04CTIrXbsnmJ6
	9w0VcLZZy38SuMOZK+4Dcy+Jf7NTDl2L4Ve+Xswh1iCXpOwI8Ga8XJmDQsXvYOtvREhtr8l7S7M
	y2GoIBGHSMfw18HUJAp3ftmnHMgVNae5GWxqI2ISyss6EhOAdmK6jq5V7emCPiPM/bFNb9VjdoT
	rioTc0Xj8i4+7Nn46S+qRM08Z4Jg/08c7W8zRIvmV6ey+JMzLqBlc=
X-Gm-Gg: ATEYQzw46KK0CGr38y+yTGYn4IjcN3WaaBDVgN0bMK6/LycofHljqtqCaz9fq2CAM2i
	umh/np9E5QwSRmpWDCBwxdjCP2C7/DGAFUsFYovO9juedV+5/RY6YrYWD56K8/CFV3K9FmkZjYL
	H5fSVEXbGbhDfKo1nXeIkhVMq985MndQJXlJwrtAl+qSrxzBx9xtMr+HZUUNmmhif73G0fRsRzp
	4Ppv6oJ4uRhwnsIpu1eW8+SuDwizzxz7URfdeKjjMHnsNczy6vVtiU1e+iPS+RIV7SEtzYiKz1y
	wpklg+q7kbkfDQMDHIlS0pHcOOguEFNdsQeaZGpRkQXeezyuiu1MQa+fLUoY7Um7hxFaWv9lxvi
	7cULxClt8rhLZ1EH/c4Nyby96V6b3
X-Received: by 2002:a05:690c:a04d:b0:79a:649e:265d with SMTP id 00721157ae682-79a90be905dmr33607997b3.49.1774037656198;
        Fri, 20 Mar 2026 13:14:16 -0700 (PDT)
X-Received: by 2002:a05:690c:a04d:b0:79a:649e:265d with SMTP id 00721157ae682-79a90be905dmr33607617b3.49.1774037655640;
        Fri, 20 Mar 2026 13:14:15 -0700 (PDT)
Received: from thiccpad.redhat.com ([179.99.166.70])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a903f4190sm21415977b3.15.2026.03.20.13.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 13:14:15 -0700 (PDT)
From: Pablo Hugen <phugen@redhat.com>
To: live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	shuah@kernel.org,
	Pablo Alessandro Santos Hugen <phugen@redhat.com>
Subject: [PATCH] selftests/livepatch: add test for module function patching
Date: Fri, 20 Mar 2026 17:11:17 -0300
Message-ID: <20260320201135.1203992-1-phugen@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2250-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[phugen@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5CD552E0C20
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Pablo Alessandro Santos Hugen <phugen@redhat.com>

Add a target module and livepatch pair that verify module function
patching via a proc entry. Two test cases cover both the
klp_enable_patch path (target loaded before livepatch) and the
klp_module_coming path (livepatch loaded before target).

Signed-off-by: Pablo Alessandro Santos Hugen <phugen@redhat.com>
---
 .../selftests/livepatch/test-livepatch.sh     | 100 ++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |   2 +
 .../test_modules/test_klp_mod_patch.c         |  53 ++++++++++
 .../test_modules/test_klp_mod_target.c        |  39 +++++++
 4 files changed, 194 insertions(+)
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c

diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index 6673023d2b66..c44c5341a2f1 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -8,6 +8,8 @@ MOD_LIVEPATCH1=test_klp_livepatch
 MOD_LIVEPATCH2=test_klp_syscall
 MOD_LIVEPATCH3=test_klp_callbacks_demo
 MOD_REPLACE=test_klp_atomic_replace
+MOD_TARGET=test_klp_mod_target
+MOD_TARGET_PATCH=test_klp_mod_patch
 
 setup_config
 
@@ -196,4 +198,102 @@ livepatch: '$MOD_REPLACE': unpatching complete
 % rmmod $MOD_REPLACE"
 
 
+# - load a target module that provides /proc/test_klp_mod_target with
+#   original output
+# - load a livepatch that patches the target module's show function
+# - verify the proc entry returns livepatched output
+# - disable and unload the livepatch
+# - verify the proc entry returns original output again
+# - unload the target module
+
+start_test "module function patching"
+
+load_mod $MOD_TARGET
+
+if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+load_lp $MOD_TARGET_PATCH
+
+if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+disable_lp $MOD_TARGET_PATCH
+unload_lp $MOD_TARGET_PATCH
+
+if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_TARGET.ko
+$MOD_TARGET: test_klp_mod_target_init
+% insmod test_modules/$MOD_TARGET_PATCH.ko
+livepatch: enabling patch '$MOD_TARGET_PATCH'
+livepatch: '$MOD_TARGET_PATCH': initializing patching transition
+livepatch: '$MOD_TARGET_PATCH': starting patching transition
+livepatch: '$MOD_TARGET_PATCH': completing patching transition
+livepatch: '$MOD_TARGET_PATCH': patching complete
+% echo 0 > $SYSFS_KLP_DIR/$MOD_TARGET_PATCH/enabled
+livepatch: '$MOD_TARGET_PATCH': initializing unpatching transition
+livepatch: '$MOD_TARGET_PATCH': starting unpatching transition
+livepatch: '$MOD_TARGET_PATCH': completing unpatching transition
+livepatch: '$MOD_TARGET_PATCH': unpatching complete
+% rmmod $MOD_TARGET_PATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: test_klp_mod_target_exit"
+
+
+# - load a livepatch that targets a not-yet-loaded module
+# - load the target module: klp_module_coming patches it immediately
+# - verify the proc entry returns livepatched output
+# - disable and unload the livepatch
+# - verify the proc entry returns original output again
+# - unload the target module
+
+start_test "module function patching (livepatch first)"
+
+load_lp $MOD_TARGET_PATCH
+load_mod $MOD_TARGET
+
+if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+disable_lp $MOD_TARGET_PATCH
+unload_lp $MOD_TARGET_PATCH
+
+if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_TARGET_PATCH.ko
+livepatch: enabling patch '$MOD_TARGET_PATCH'
+livepatch: '$MOD_TARGET_PATCH': initializing patching transition
+livepatch: '$MOD_TARGET_PATCH': starting patching transition
+livepatch: '$MOD_TARGET_PATCH': completing patching transition
+livepatch: '$MOD_TARGET_PATCH': patching complete
+% insmod test_modules/$MOD_TARGET.ko
+livepatch: applying patch '$MOD_TARGET_PATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: test_klp_mod_target_init
+% echo 0 > $SYSFS_KLP_DIR/$MOD_TARGET_PATCH/enabled
+livepatch: '$MOD_TARGET_PATCH': initializing unpatching transition
+livepatch: '$MOD_TARGET_PATCH': starting unpatching transition
+livepatch: '$MOD_TARGET_PATCH': completing unpatching transition
+livepatch: '$MOD_TARGET_PATCH': unpatching complete
+% rmmod $MOD_TARGET_PATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: test_klp_mod_target_exit"
+
+
 exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index 939230e571f5..a13d398585dc 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -8,6 +8,8 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_callbacks_mod.o \
 	test_klp_kprobe.o \
 	test_klp_livepatch.o \
+	test_klp_mod_patch.o \
+	test_klp_mod_target.o \
 	test_klp_shadow_vars.o \
 	test_klp_state.o \
 	test_klp_state2.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
new file mode 100644
index 000000000000..6725b4720365
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Pablo Hugen <phugen@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include <linux/seq_file.h>
+
+static int livepatch_mod_target_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
+		   "this has been live patched");
+	return 0;
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "test_klp_mod_target_show",
+		.new_func = livepatch_mod_target_show,
+	},
+	{},
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "test_klp_mod_target",
+		.funcs = funcs,
+	},
+	{},
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int test_klp_mod_patch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_mod_patch_exit(void)
+{
+}
+
+module_init(test_klp_mod_patch_init);
+module_exit(test_klp_mod_patch_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Pablo Hugen <phugen@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: patch for module-provided function");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
new file mode 100644
index 000000000000..9643984d2402
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Pablo Hugen <phugen@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+static struct proc_dir_entry *pde;
+
+static noinline int test_klp_mod_target_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s: %s\n", THIS_MODULE->name, "original output");
+	return 0;
+}
+
+static int test_klp_mod_target_init(void)
+{
+	pr_info("%s\n", __func__);
+	pde = proc_create_single("test_klp_mod_target", 0, NULL,
+				 test_klp_mod_target_show);
+	if (!pde)
+		return -ENOMEM;
+	return 0;
+}
+
+static void test_klp_mod_target_exit(void)
+{
+	pr_info("%s\n", __func__);
+	proc_remove(pde);
+}
+
+module_init(test_klp_mod_target_init);
+module_exit(test_klp_mod_target_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Hugen <phugen@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: target module with proc entry");
-- 
2.53.0


