Return-Path: <live-patching+bounces-1920-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UIC+OWpNc2lDugAAu9opvQ
	(envelope-from <live-patching+bounces-1920-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 11:28:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A93DA7453B
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 11:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86D7D301DC3A
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 10:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8A237AA74;
	Fri, 23 Jan 2026 10:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fFcxQwta"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF49936656F
	for <live-patching@vger.kernel.org>; Fri, 23 Jan 2026 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769164127; cv=none; b=doHUQfMXwUZnOpVvmpbgDTNZzujzLRET45ATWcK0UfQYCz5vJBS057+e7eZgSbYReul8Muo2mz73VoKW2XvCPd4T8ZnTNhDePZpPXoFmUqaNT+u/7x/HJyuttq3ZCHHb0tFu0AN7q4d48Zmk7LrKdS5SFyK8KYOhNyD8USchuJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769164127; c=relaxed/simple;
	bh=DtOADswTq9t7oM1NSkiyrF+jafF+Tp/877w6zEpUQhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdue8VDzeDylkOT9NsGT0JMjVTyAMqim1nGGgPEDfiHtMNC+c3XEgEki0dFzYS4R9CzaolH7cPlJjqVUhoRnKhjILUSZapvB9id5fl5xk0RXEefrQml2XcUn5Vgmz41ZqfjpgZ1ZrF1Hkbatk9TdbviVyINHthNaUxDmi0F6e5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fFcxQwta; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so15197515e9.1
        for <live-patching@vger.kernel.org>; Fri, 23 Jan 2026 02:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769164124; x=1769768924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxfRVP7W+3lq5s1e+n6bpoYt/Dv/ToAFRdoKHsTj1cI=;
        b=fFcxQwtaDCazpAceKn6XtsiQQztngTZvmNRaK0nF+1JeAPAatfdkhiNkOYR1RaE7M1
         IlmkgeaXWIGP5X2YAyca3HUIiwVqwox7mnkNfJrH7sHAOlHsbMeP8EyJcGE3t8YgWjpQ
         R3WjtlkNCDpxhvMDZucoIP1hzikr/5KyjvfkfmJDUQW0Sky3LsFYq3Oq32qFLvPZrlLi
         iEpNA6YKjgt/RGMjPTMdvuSi2jEhHF34tpSHy/32LlgeijvjzgiqlIDLsvKrBGODY5j8
         JPOjf9/qiV5Avbtx7snuiw9y3ayVG7ZBxzKRx4zcQIaN/pMaHOqucc5zBHRyxe85z0kJ
         QDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769164124; x=1769768924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZxfRVP7W+3lq5s1e+n6bpoYt/Dv/ToAFRdoKHsTj1cI=;
        b=RvNdCjbSjnWHX7veM6Hsge/c6NS9bVbpWO1zInkaZNxyKlvs/brM6jZ8+dC1bcGzYX
         U+rBr4qjUpQ+4HnJHvF3xv8Ko8+wiNbH2Msh1vKp+3CHAVYqkUKCchdV86Zdqk975iJi
         Epze35S8txrJgUqCzZo+RgfxEQFv3bIdNmg+vJzKtrhmfLAs88bnHSc0hmIBd4PeNj9n
         4/zQ2oBDG3+lmJ+WV3Pd2HjDIkgg52j4H9iqdaezlbEe5SrIbn3BJTvV3ovxe3HPNJ/5
         pT4yAvLzJr6/Q/7N+wFMJ5NiOpgy+S1B4Ki29f+Z+F8g/vN36LnDiqjptQCXtNtFrYJj
         fd3A==
X-Forwarded-Encrypted: i=1; AJvYcCV/cLtO6N00Lszi/xw3wPs4NgVmRKAwz0Ga7qM0Y508JA25sqNDQ7GMWnay65yD21eqrsm++WnN49QOgsUm@vger.kernel.org
X-Gm-Message-State: AOJu0YwhUPmXNwF4GkKU2yHh1jEHu6AKdkuqOmXJNE31RhCYWZq2PGm+
	qsD4ubnQ0NR5DDEYToRfYovHCdLobXWK/VZyTLLeJEZDe7mPuZ7F407AL1Dx2b7PWO4=
X-Gm-Gg: AZuq6aL1iD/al+6cqesEZOjeSFwehjRlQojk9jciUwnx8QbfCX3zmAcRCpDSE0Rjg+7
	h95Ue3R+kzlW+EykXOkDm/eyb5FN3GMYD6N1+4V+1cmc2oujfQYbk1Z75Bs6wNAZ4VefmlBOHHG
	tYQrC2+kVuicimW1frrxtTP77D+6xomLByr/wHf83x+I/e1uKuGeJ8nrkVQDYiFRDvU2no1OeDT
	ROD8lV9gLR8lcd8Z0r4tAqqgqhpm0hQZ9yqQMzSvJ80nrDUScQS1u0gl2YV093i50Wq9AwPTp1x
	i4ZQDDBCs0m7A1YJakSvYOad8o0p2pjxLebKs5EkbpjiUBI3ExLImafHWCqYDWvCMtQ7IYLgFqp
	Eq2JlcgEKigk/7HWmUyT9RJwo4sk5L5bvRdvR8xdQWICFr/pr42GQnndkrrnLxz8KonTwMoBKq7
	5dL1kpZw/UuXm4RT+j1XNczjc/V7RqB7s=
X-Received: by 2002:a05:600c:6814:b0:477:54cd:200e with SMTP id 5b1f17b1804b1-4804c947d18mr42348725e9.1.1769164124202;
        Fri, 23 Jan 2026 02:28:44 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-480470474cbsm128920065e9.8.2026.01.23.02.28.43
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
Subject: [PATCH v3 2/2] livepatch: Free klp_{object,func}_ext data after initialization
Date: Fri, 23 Jan 2026 11:26:57 +0100
Message-ID: <20260123102825.3521961-3-petr.pavlu@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1920-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A93DA7453B
X-Rspamd-Action: no action

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
index 9e315fc857bd..638c95cffe76 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -19,7 +19,7 @@ static int __init livepatch_mod_init(void)
 	unsigned int nr_objs;
 	int ret;
 
-	obj_exts = klp_find_section_by_name(THIS_MODULE, "__klp_objects",
+	obj_exts = klp_find_section_by_name(THIS_MODULE, ".init.klp_objects",
 					    &obj_exts_sec_size);
 	nr_objs = obj_exts_sec_size / sizeof(*obj_exts);
 	if (!nr_objs) {
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


