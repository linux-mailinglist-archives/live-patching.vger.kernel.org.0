Return-Path: <live-patching+bounces-1915-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMdbNCaQcGkaYgAAu9opvQ
	(envelope-from <live-patching+bounces-1915-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 09:36:54 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 89CA353AAB
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 09:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7FBA17E5A8B
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 08:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F7C44CF27;
	Wed, 21 Jan 2026 08:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ny8Qiv1y"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3763AE6F3
	for <live-patching@vger.kernel.org>; Wed, 21 Jan 2026 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984163; cv=none; b=hgY3fFrVGrW1T1GIrh5lwqI7kDFKIdeM6vYyjoD79TreaecfyEEL5GqxJcGuFv2oyoF5TCF1i0Y8FgLUowF+zlqtzkmIUEojix9W7uMsDG9n/ejKwxM8m+xhUQU8Yioi01EyeyPQrCfWXcm+qyyJ78lmSspDTNMk4mfs8qGWjfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984163; c=relaxed/simple;
	bh=tf2r0DbF4We3sVnIZiZOAFzXpYYSfLGiXXDWTAoLYpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7OIj+hoQh4Fg1Q2s2qepswDUtJvSmPIbehHBCrPsxFeADiG1k8IUEAvjD/PmJYK1bwgSTm/52HcZjlzGUrp9nXNYMrKNDY72zSECyEBD9QMhvjK/dpfcHrhgrtD2cEOws67xkbq+9C3Hi56Ab+8zVJuVqey1HmP/oZw+GghnBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ny8Qiv1y; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so58269105e9.1
        for <live-patching@vger.kernel.org>; Wed, 21 Jan 2026 00:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768984159; x=1769588959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vxOZHcSBD1fpQdkK38syRA+6nyfkbQXy3R8wbjNKlg=;
        b=Ny8Qiv1ydkinzp/mRVJAD8Q3d0d1kXAI6CLUeB+zGmWZ8tFO5hMe0XNvijab+4cIb8
         MbhuEoEY059NqrhH/bIAauh8YY/bcGSu1ywqy1Dq2dyRqYqO6s5NGEE5KDKKbS9g/vwc
         hMGVL/DX4U8SQJqnHpwTYL+BmTqjw0Jd7ZIjMya4tXaJiy0xqEzfBgvBcIY3j/BhhLut
         W3wT2gTRFaetQ6LiAgFaHWZcv2dfB++XK9SVOZAOqU+MF3mAOULuwbaxFzy3I3HcUeDP
         uq7EizhB+n6e/yHIZQrNOETn2t1QsDo1FCbOghkPU9hASSe7kjIQ39rWQhGU1/HbbXOE
         ZXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768984159; x=1769588959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7vxOZHcSBD1fpQdkK38syRA+6nyfkbQXy3R8wbjNKlg=;
        b=bkjL7QA8zpi6f9RsOEWirTV/fteLjecGNtZUWcnoZbbKPeU7k8DYyYp8YAAIPkQ+z+
         giLD7ZN1m4vroxqWHVmeTR7WOl/znbMwRbH5mrwVATBFajzKYHbG9bpE/Jg9XwAPbnRT
         TICa1/MO8TRZGXUbaNLE9xKqn2gYciSVEvE1vDHYeBRHU5lq/fL9w6+wwIj+e3HVrCWV
         GUhKQQf2OVtJq+oHL3MkLdk51+rraJo1SCL4U65nexxDudQFISLEy8r+OV60oBaF8YYn
         JmSd/cCnC7gi1xjaVzpudBCAwL8WbRxKb5FI1jPpPd280O0r+L3idwYfR+QkTd84bylx
         YtGA==
X-Forwarded-Encrypted: i=1; AJvYcCXTIcaA3YjID4GXCMvZv0KaWR87oZc+py/96Frp6cfiCml0YUigK4rU+uRiCNVq86rPvh9lQtRlx12LVIx8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6+5dEd0tIU9luiFYw+fZ6yQYkEVe3wr4Y/j0ojNnkGkbA8Ps7
	y59YriOuh2WzkBoiie0YefzZ0LQq3abN0jGRykGlf/ya2e9vvi23TrIyrBE8eUgX8l8=
X-Gm-Gg: AZuq6aJdCykophYTbjOvHW2nnz9XvL45ly5YQUU+vy2Iyyc8/tMI8tML3xAkRSDMXtu
	ger0njYGWbgaPI3JUSISJqhtP3pUvHHNfrXC//Q/w5CuPFTFGDI24MLstu/ZWdEasN2nSXgxeeZ
	kDnIPPUyheecjCl+O9kycHcZVMIys0uCU5BvYf/Kq5I0HvotTxhAdzEUtTCzyZ7O7zIQ8nALATT
	88cP6rwLesPbZTpWI/vAb0opCLHLJZnv7hh4Zrm1lqVhgQhxRw9I9owv1Ftqvz2ijFf2RgGrhrO
	dasLqKBN+6beZIvrGmU9QTE1g9rvyN+TOMnZLf11BwCDMCzzPCt4ngk1TVuRtiSohFFSBuRZpU+
	iXyFYXPDTqV0nw3kxMOEA9Lu8AockpNQEGP91S2kRcxa13Fh6sczAa5zjQXqc7rDHZNJtDWmdPy
	cm98MN8hxZ0DFyxPZKgmykGd3dP6aJxh0=
X-Received: by 2002:a05:600c:6990:b0:47e:c562:a41f with SMTP id 5b1f17b1804b1-4801e334361mr221506345e9.18.1768984158802;
        Wed, 21 Jan 2026 00:29:18 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b2755absm441635355e9.15.2026.01.21.00.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 00:29:18 -0800 (PST)
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
Subject: [PATCH v2 2/2] livepatch: Free klp_{object,func}_ext data after initialization
Date: Wed, 21 Jan 2026 09:28:17 +0100
Message-ID: <20260121082842.3050453-3-petr.pavlu@suse.com>
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
	TAGGED_FROM(0.00)[bounces-1915-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 89CA353AAB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The klp_object_ext and klp_func_ext data, which are stored in the
__klp_objects and __klp_funcs sections, respectively, are not needed
after they are used to create the actual klp_object and klp_func
instances. This operation is implemented by the init function in
scripts/livepatch/init.c.

Prefix the two sections with ".init" so they are freed after the module
is initializated.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/init.c            |  2 +-
 scripts/module.lds.S                |  4 ++--
 tools/objtool/check.c               |  2 +-
 tools/objtool/include/objtool/klp.h | 10 +++++-----
 tools/objtool/klp-diff.c            |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index a02252e1de03..3e658db5dfe8 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -18,7 +18,7 @@ static int __init livepatch_mod_init(void)
 	unsigned int nr_objs;
 	int ret;
 
-	obj_exts = klp_locate_section_objs(THIS_MODULE, "__klp_objects",
+	obj_exts = klp_locate_section_objs(THIS_MODULE, ".init.klp_objects",
 					   sizeof(*obj_exts), &nr_objs);
 	if (!nr_objs) {
 		pr_err("nothing to patch!\n");
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 383d19beffb4..054ef99e8288 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -34,8 +34,8 @@ SECTIONS {
 
 	__patchable_function_entries : { *(__patchable_function_entries) }
 
-	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
-	__klp_objects		0: ALIGN(8) { KEEP(*(__klp_objects)) }
+	.init.klp_funcs		0 : ALIGN(8) { KEEP(*(.init.klp_funcs)) }
+	.init.klp_objects	0 : ALIGN(8) { KEEP(*(.init.klp_objects)) }
 
 #ifdef CONFIG_ARCH_USES_CFI_TRAPS
 	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3f7999317f4d..933868ee3beb 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4761,7 +4761,7 @@ static int validate_ibt(struct objtool_file *file)
 		    !strcmp(sec->name, "__bug_table")			||
 		    !strcmp(sec->name, "__ex_table")			||
 		    !strcmp(sec->name, "__jump_table")			||
-		    !strcmp(sec->name, "__klp_funcs")			||
+		    !strcmp(sec->name, ".init.klp_funcs")		||
 		    !strcmp(sec->name, "__mcount_loc")			||
 		    !strcmp(sec->name, ".llvm.call-graph-profile")	||
 		    !strcmp(sec->name, ".llvm_bb_addr_map")		||
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index ad830a7ce55b..e32e5e8bc631 100644
--- a/tools/objtool/include/objtool/klp.h
+++ b/tools/objtool/include/objtool/klp.h
@@ -6,12 +6,12 @@
 #define SHN_LIVEPATCH		0xff20
 
 /*
- * __klp_objects and __klp_funcs are created by klp diff and used by the patch
- * module init code to build the klp_patch, klp_object and klp_func structs
- * needed by the livepatch API.
+ * .init.klp_objects and .init.klp_funcs are created by klp diff and used by the
+ * patch module init code to build the klp_patch, klp_object and klp_func
+ * structs needed by the livepatch API.
  */
-#define KLP_OBJECTS_SEC	"__klp_objects"
-#define KLP_FUNCS_SEC	"__klp_funcs"
+#define KLP_OBJECTS_SEC	".init.klp_objects"
+#define KLP_FUNCS_SEC	".init.klp_funcs"
 
 /*
  * __klp_relocs is an intermediate section which are created by klp diff and
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 4d1f9e9977eb..fd64d5e3c3b6 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1439,7 +1439,7 @@ static int clone_special_sections(struct elfs *e)
 }
 
 /*
- * Create __klp_objects and __klp_funcs sections which are intermediate
+ * Create .init.klp_objects and .init.klp_funcs sections which are intermediate
  * sections provided as input to the patch module's init code for building the
  * klp_patch, klp_object and klp_func structs for the livepatch API.
  */
-- 
2.52.0


