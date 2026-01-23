Return-Path: <live-patching+bounces-1919-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGIALWJNc2lDugAAu9opvQ
	(envelope-from <live-patching+bounces-1919-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 11:28:50 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0E47450D
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 11:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A5C2730065D9
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 10:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70980367F4B;
	Fri, 23 Jan 2026 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IQn045fj"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D650A330B0B
	for <live-patching@vger.kernel.org>; Fri, 23 Jan 2026 10:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769164126; cv=none; b=tIUjZQdhXXOCRmxVChHWhlej2TFOqZrjId7G2yjk2qTBV8+p95EpyEtuZeMviK/bvalfXwSvTRPIuVOQR5awDSvjuxp66GKUrHN+GdLZ6YrddeJ9LWZ7WMYE0P6bFArKvOUe80ihuxRN0Bjyk4ddFV0fgAi59dDJbhdKwBH0pJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769164126; c=relaxed/simple;
	bh=Tpz05bjoELPQv2eF0UefMJbC3tfLCQg5SYsCoLtcvBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnMrGMYL9QVGc8C7vnUB0gguPT8h7cpeAI9fj/qLqG/sS7fag/XtVZtZis4BdyxW1q1T23v2s4GZ2gSvPZu7DGV8DSr4t/ffuE7IvPFQU8G6xWQqt+0lWlkMbPxJswlZGmeROQjKhgK86q0lRmzmgxSz2uqITxktXUXf3VErijk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IQn045fj; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47edffe5540so23685955e9.0
        for <live-patching@vger.kernel.org>; Fri, 23 Jan 2026 02:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769164123; x=1769768923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wm5L+uQsZ1ST72VLcpgjOsjeSabHaJSKng460K2rBVU=;
        b=IQn045fjz883uup81a0GLt6RtZKdoh+E8YqPkUL1p4erQwZlNExejScl5ylLqT1LxG
         SokFPXth1VRTZIrN1ZAE/+H7BVoxc932/2mPnaA0vN6+hNMvkLyms15QV75TV3Xm2e0P
         LAJjR0y0yceJ/jWTLcoUjyCgUDbEqYkgu9e0BW/N26WQfQcINyiGI4LZhiL2HF1UMgoe
         iSfmTRF4eNywK7hSoBGo/cB09y1ZBOVq1yO4ymOlZ+dEvjZ/Zj7//PjLcAH5jn24liS/
         /LA4gAkCR9LkIwoPz2auxzlFogucOzEcWcb9mMSQM+7gtsOxOWNvnCoUWbKXS2OthdnL
         35rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769164123; x=1769768923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wm5L+uQsZ1ST72VLcpgjOsjeSabHaJSKng460K2rBVU=;
        b=n8Id3OZKsYmWD1vRAXWVJ/C7i6GHc08J0WXiY0xLNBJU53RWYL2glfdQeZCLYl9O56
         1voxFNv2lN8O43I34EsTMfqXef9FGmDNCR7fY+L5wUmoXRthUdzu5Pr3pmAoKpUGnMS+
         ir2peCNuc2QQtw0SU9ebH7Eqav+n+IuRkIvPaGmIDLQNMoGXoSILNIS5dW2TvIMug5dk
         dz78AUpkIF8VKZRJmALhM5vZuHonpaKqmN5ptnld+2OOMv9cGycRmJuUNaUwMu5AVder
         KwLm4XsVtp9QTzp2li9wA6K2yxKcc4IsDBXc6XSqmM5+7iNsV83W13JfBfze+1Zmoh3L
         4nKA==
X-Forwarded-Encrypted: i=1; AJvYcCUNNzNSHRpHw3RkdoCronKIqVDmN0DUjL6ncXf5OJ4I1S1HXyl44EGLWe+2anMcrVfo+TVDdsj8urBFg3ih@vger.kernel.org
X-Gm-Message-State: AOJu0YyHrwHgqjvG/7NONPdLkhPqsbtXrGh2ggTafe50UF35xaPk84Fn
	f3Nb9e2g6hrQS57aIiNCroJtMEuaS1LenynoyoaRpm4l3jZx09xbxYKQdXJZygJKO58=
X-Gm-Gg: AZuq6aLJuQTXWo+XfvVK2wCgchxwh7Bjzc+ZuU92y00h+deuRVB1W+ebg8/FRDRRI4Y
	I9QKR174wL8TR63n7UnI6RujK4zW85hnetyKP3pwCzkimsZSX0oEAOp6AQ/In6Hixqibd0QjonZ
	wAVYfFQwr8qKH4+U4rIO09ZeYy8XwdbufqvK70eAF4CyVdC43/lSQlMfb9uAlOO4mUnzkfcs7iB
	OEfCRR76UiYKFO7Tihd1AI6m/1CuOivCoRYugn+hSXjYGjcjL0o/AU1MvkstwU0YzYW5oSlRDrh
	i1+90Zx76VptZRvnsq/LwjROSxOgdoeqUWJh8vSHjQ29Npx65EvRncabtxBnsb3sqB7slOE7PZB
	T0gdXFhBPiyia65GpKbhJLRfIt74qE2dk5qthljVoS7o8ygSupXy30kQMd8xfm8qWj0VsyzPbBv
	Wk6GW7NALpM2MmsyfEitFWQVvIEdc23mA=
X-Received: by 2002:a05:600c:a00d:b0:477:a246:8398 with SMTP id 5b1f17b1804b1-4804c947d28mr43761945e9.2.1769164123303;
        Fri, 23 Jan 2026 02:28:43 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-480470474cbsm128920065e9.8.2026.01.23.02.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 02:28:43 -0800 (PST)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] livepatch: Fix having __klp_objects relics in non-livepatch modules
Date: Fri, 23 Jan 2026 11:26:56 +0100
Message-ID: <20260123102825.3521961-2-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260123102825.3521961-1-petr.pavlu@suse.com>
References: <20260123102825.3521961-1-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1919-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 3F0E47450D
X-Rspamd-Action: no action

The linker script scripts/module.lds.S specifies that all input
__klp_objects sections should be consolidated into an output section of
the same name, and start/stop symbols should be created to enable
scripts/livepatch/init.c to locate this data.

This start/stop pattern is not ideal for modules because the symbols are
created even if no __klp_objects input sections are present.
Consequently, a dummy __klp_objects section also appears in the
resulting module. This unnecessarily pollutes non-livepatch modules.

Instead, since modules are relocatable files, the usual method for
locating consolidated data in a module is to read its section table.
This approach avoids the aforementioned problem.

The klp_modinfo already stores a copy of the entire section table with
the final addresses. Introduce a helper function that
scripts/livepatch/init.c can call to obtain the location of the
__klp_objects section from this data.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 include/linux/livepatch.h |  3 +++
 kernel/livepatch/core.c   | 19 +++++++++++++++++++
 scripts/livepatch/init.c  | 20 +++++++++-----------
 scripts/module.lds.S      |  7 +------
 4 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 772919e8096a..ba9e3988c07c 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -175,6 +175,9 @@ int klp_enable_patch(struct klp_patch *);
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
+void *klp_find_section_by_name(const struct module *mod, const char *name,
+			       size_t *sec_size);
+
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 9917756dae46..1acbad2dbfdf 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1356,6 +1356,25 @@ void klp_module_going(struct module *mod)
 	mutex_unlock(&klp_mutex);
 }
 
+void *klp_find_section_by_name(const struct module *mod, const char *name,
+			       size_t *sec_size)
+{
+	struct klp_modinfo *info = mod->klp_info;
+
+	for (int i = 1; i < info->hdr.e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+
+		if (!strcmp(info->secstrings + shdr->sh_name, name)) {
+			*sec_size = shdr->sh_size;
+			return (void *)shdr->sh_addr;
+		}
+	}
+
+	*sec_size = 0;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(klp_find_section_by_name);
+
 static int __init klp_init(void)
 {
 	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index 2274d8f5a482..9e315fc857bd 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -9,19 +9,19 @@
 #include <linux/slab.h>
 #include <linux/livepatch.h>
 
-extern struct klp_object_ext __start_klp_objects[];
-extern struct klp_object_ext __stop_klp_objects[];
-
 static struct klp_patch *patch;
 
 static int __init livepatch_mod_init(void)
 {
+	struct klp_object_ext *obj_exts;
+	size_t obj_exts_sec_size;
 	struct klp_object *objs;
 	unsigned int nr_objs;
 	int ret;
 
-	nr_objs = __stop_klp_objects - __start_klp_objects;
-
+	obj_exts = klp_find_section_by_name(THIS_MODULE, "__klp_objects",
+					    &obj_exts_sec_size);
+	nr_objs = obj_exts_sec_size / sizeof(*obj_exts);
 	if (!nr_objs) {
 		pr_err("nothing to patch!\n");
 		ret = -EINVAL;
@@ -41,7 +41,7 @@ static int __init livepatch_mod_init(void)
 	}
 
 	for (int i = 0; i < nr_objs; i++) {
-		struct klp_object_ext *obj_ext = __start_klp_objects + i;
+		struct klp_object_ext *obj_ext = obj_exts + i;
 		struct klp_func_ext *funcs_ext = obj_ext->funcs;
 		unsigned int nr_funcs = obj_ext->nr_funcs;
 		struct klp_func *funcs = objs[i].funcs;
@@ -90,12 +90,10 @@ static int __init livepatch_mod_init(void)
 
 static void __exit livepatch_mod_exit(void)
 {
-	unsigned int nr_objs;
-
-	nr_objs = __stop_klp_objects - __start_klp_objects;
+	struct klp_object *obj;
 
-	for (int i = 0; i < nr_objs; i++)
-		kfree(patch->objs[i].funcs);
+	klp_for_each_object_static(patch, obj)
+		kfree(obj->funcs);
 
 	kfree(patch->objs);
 	kfree(patch);
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 3037d5e5527c..383d19beffb4 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -35,12 +35,7 @@ SECTIONS {
 	__patchable_function_entries : { *(__patchable_function_entries) }
 
 	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
-
-	__klp_objects		0: ALIGN(8) {
-		__start_klp_objects = .;
-		KEEP(*(__klp_objects))
-		__stop_klp_objects = .;
-	}
+	__klp_objects		0: ALIGN(8) { KEEP(*(__klp_objects)) }
 
 #ifdef CONFIG_ARCH_USES_CFI_TRAPS
 	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
-- 
2.52.0


