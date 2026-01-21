Return-Path: <live-patching+bounces-1914-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMS/JweQcGkaYgAAu9opvQ
	(envelope-from <live-patching+bounces-1914-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 09:36:23 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0816F53A8E
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 09:36:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DD8CD7C192D
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 08:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE443E8C6A;
	Wed, 21 Jan 2026 08:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TXp0kn4v"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5B31D367
	for <live-patching@vger.kernel.org>; Wed, 21 Jan 2026 08:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984161; cv=none; b=LfVIK5u63WYHYN4DsT0bBwpkBnvWLZhqbTg9MQBBn4/BqkuNCKtKU9Vf21poQfyFO0icttNGVfy6+KMuT6rS/otYO8yPYVtU6k66vBkVaYVzJpXF+rfBxFNfZGi6FIeS/9fZWPEO144DNCQAfx/dbQaxwDZJin0b9ppjLQ/JtmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984161; c=relaxed/simple;
	bh=dd/WKZVS93Pv/daREo/YFKKQFMVLmCyrRG74D11PrBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNjUs27ujxFhSXDOUboTP71ylURTxTGJBtTDFfKgkUReibTXWceF/sAuvWOxD35ut4reE20TCCDTOjvMvl/tmbG7slCIFa4bQGJIrMUOPsE9ARAWycsd9efEwKA/D08JZ1xgJnw+/eKHDZg0TlDGPIwciEA/I0HgrTsrHMgILYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TXp0kn4v; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so5227145e9.0
        for <live-patching@vger.kernel.org>; Wed, 21 Jan 2026 00:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768984157; x=1769588957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rW3/x5WQoTtIgiq7ocBHZ7S4nlaqCE+GJd2t8Whluqo=;
        b=TXp0kn4vcV/hhanSKMBnkKUKjyfEF0oAbIzRKtyK1bFOtlKSjVEkXyR1Vm3Qy7V0OF
         EJFHRBv/tFsqAc4DP90pbxcLnty00UInPu67yYGL/ynEHyS0M+ii+IDwqgBtQdXjztxW
         KdKBTsx3NT6MoO6PrA/gZoJkHAfewWjyGMdgXdLhWx+3jy3nQ7ZUTXFxkpwvt+IDSbC1
         bBIuju+X0u1wTT+WxTvSJBY52mzvQEHIbwYykpYlKNzn0AcYW0QO7Ad/ZoJmB3retevJ
         7IZ28ziyCyDDo0d7fswhlQpgqUBdci8suOmPog7Ep7bRtrGNLVNeWxkKLafJlfeDU/11
         a19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768984157; x=1769588957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rW3/x5WQoTtIgiq7ocBHZ7S4nlaqCE+GJd2t8Whluqo=;
        b=mMeSWxgw/IKxD4ZHsO2BOihJr5f6QYB8IqDzcIxBF6LdEKu3ddKByjaP3wY3MFS8Fm
         23Iaf+p6ZuefDA/jDnJA6Pd80bv39C3DrIEEXL/jjdlvva8+9CVj1xFx7i5EVcyJC+bm
         2c92PqDqsMts3X/ypxoa4jt4FLZPEieIhcOAzVgNgZsitlRs/H6MwOZft/BbT00UKiT9
         1ILoAidumyA9qeoCAowrpBiM8FAR5xIYpPpPOT8WYyhKCxWrz+rneDTyEuQf+XJCIlOX
         /M6VJdD+dKkkNBF6dZCEUP9VVXHm1OlKe5Diqq2YBV6xwErWxBlLvb8OPrBgIfV98otQ
         pP7w==
X-Forwarded-Encrypted: i=1; AJvYcCVORS9VR+/Uca0suHU9cDKVzCt6bo62OVgxeS36r9wTegEGD2HZlV54yFyKqlc6HIK2ao01FpFNivGo4T87@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd3KLVNHABNvLo/0I11VTMDg6MVz8wZkP9dDJ/YiC8vvmpg4uc
	lfQmgfRCDw3BXXd3oqKeHcv6a6wJ1ZWuA4MGXCytTI8oI8B/8OeJb8RNXZ9vZ/pq7Rc=
X-Gm-Gg: AZuq6aIzDhe70uaMGCbHSTY/Z/Eim0ddVyzfRqhA33RIbr9jGJdgeJKkD1O7rUxA8he
	NNTWfJtzFLGEo1+2PFUsnaebLmrbneVcfzoMYKwNj4+mezpUGeXfSuZRIw/mOdGfOFDR/p1D1Yc
	CuMlCad5N/+3n9P/yFNv+Mmp7H6ioQ8y++TbI6V5QWyJgvFJokslGOEqXOIeZbT8pd5bLL3iaJP
	td4W0ds0Tp6nlYS08pTeunDcJ/PW3FdnOSGtOW9eYur8nDgm8+JG8pUoOzTfKTSO4CiALCZcTri
	R9caYLy3rV3kc1VlDadV/lmEAsX3jMmdmDK9juhCDs6G2sMFfr7XI+IVZEvCd7BJ07zcqyC23Zr
	wpT0xs3VTsB/SOx4oj9edfKuA1Bovbr5D86BAVb569Xgafx5+8IcZ5S8S9dqvoKCzrjRuz0Irfl
	E6IdJPEbs05IZ0VgcWhCYJc8Bsa2nr+RwCksaZt5f0UA==
X-Received: by 2002:a05:600c:524f:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-4801e685697mr200477065e9.16.1768984157202;
        Wed, 21 Jan 2026 00:29:17 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b2755absm441635355e9.15.2026.01.21.00.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 00:29:16 -0800 (PST)
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
Subject: [PATCH v2 1/2] livepatch: Fix having __klp_objects relics in non-livepatch modules
Date: Wed, 21 Jan 2026 09:28:16 +0100
Message-ID: <20260121082842.3050453-2-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121082842.3050453-1-petr.pavlu@suse.com>
References: <20260121082842.3050453-1-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DMARC_POLICY_ALLOW(0.00)[suse.com,quarantine];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1914-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 0816F53A8E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
 kernel/livepatch/core.c   | 20 ++++++++++++++++++++
 scripts/livepatch/init.c  | 18 +++++++-----------
 scripts/module.lds.S      |  7 +------
 4 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 772919e8096a..0a663e5911f4 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -175,6 +175,9 @@ int klp_enable_patch(struct klp_patch *);
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
+void *klp_locate_section_objs(const struct module *mod, const char *name,
+			      size_t object_size, unsigned int *nr_objs);
+
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 9917756dae46..85925abfca0f 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1356,6 +1356,26 @@ void klp_module_going(struct module *mod)
 	mutex_unlock(&klp_mutex);
 }
 
+void *klp_locate_section_objs(const struct module *mod, const char *name,
+			      size_t object_size, unsigned int *nr_objs)
+{
+	struct klp_modinfo *info = mod->klp_info;
+
+	for (int i = 1; i < info->hdr.e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+
+		if (strcmp(info->secstrings + shdr->sh_name, name))
+			continue;
+
+		*nr_objs = shdr->sh_size / object_size;
+		return (void *)shdr->sh_addr;
+	}
+
+	*nr_objs = 0;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(klp_locate_section_objs);
+
 static int __init klp_init(void)
 {
 	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index 2274d8f5a482..a02252e1de03 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -9,19 +9,17 @@
 #include <linux/slab.h>
 #include <linux/livepatch.h>
 
-extern struct klp_object_ext __start_klp_objects[];
-extern struct klp_object_ext __stop_klp_objects[];
-
 static struct klp_patch *patch;
 
 static int __init livepatch_mod_init(void)
 {
+	struct klp_object_ext *obj_exts;
 	struct klp_object *objs;
 	unsigned int nr_objs;
 	int ret;
 
-	nr_objs = __stop_klp_objects - __start_klp_objects;
-
+	obj_exts = klp_locate_section_objs(THIS_MODULE, "__klp_objects",
+					   sizeof(*obj_exts), &nr_objs);
 	if (!nr_objs) {
 		pr_err("nothing to patch!\n");
 		ret = -EINVAL;
@@ -41,7 +39,7 @@ static int __init livepatch_mod_init(void)
 	}
 
 	for (int i = 0; i < nr_objs; i++) {
-		struct klp_object_ext *obj_ext = __start_klp_objects + i;
+		struct klp_object_ext *obj_ext = obj_exts + i;
 		struct klp_func_ext *funcs_ext = obj_ext->funcs;
 		unsigned int nr_funcs = obj_ext->nr_funcs;
 		struct klp_func *funcs = objs[i].funcs;
@@ -90,12 +88,10 @@ static int __init livepatch_mod_init(void)
 
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


