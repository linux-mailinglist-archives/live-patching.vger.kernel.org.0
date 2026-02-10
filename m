Return-Path: <live-patching+bounces-2004-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MhVMzaoi2kqYAAAu9opvQ
	(envelope-from <live-patching+bounces-2004-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:46 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD2411F8C0
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4C64630517DD
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 21:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565BB33A005;
	Tue, 10 Feb 2026 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qNZy+SBY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463D33987D;
	Tue, 10 Feb 2026 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770760226; cv=none; b=nYLT0vQRoipV7Z3cdB55KnOThkfrw92g5VF4AlBgDSM1AQtrPEU1372QwfGkMtbs9rJg4SJUqm9JstvpOuo+sc9L+1LKo/gUGDosTOUbLkFPLhM/oVRn8l35fGXwI/oXQoqFvOFaAfFcSG0/B3fcMX0MBUCtm9GB03sfSFZnzO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770760226; c=relaxed/simple;
	bh=9EOLe2PSxvdepkarQnhpJpYsJ/R0HZPuyMwQs1cmanM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC89moKolJdNrhOJYOlAzIFUt/lsnANWytW1JtCKuVPt34XgA4/GQJPY7c7SZhL1YFSZDKEAAhWJdvyTmyVNMqhjC1mBqFIRaWb+Lqwupnvw6zsBYMFtcn4IvJA6jevPZgCsKg1EdmV6JxypfXIh/MLO+yDnnSb+4bz2oaDaxzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qNZy+SBY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C685DC2BCB5;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770760226;
	bh=9EOLe2PSxvdepkarQnhpJpYsJ/R0HZPuyMwQs1cmanM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNZy+SBYiZA0PdZPDSuQCg7fHyTSPOc/VawZXC5YGYz8Vbd4bFS0yLa7IVAfd/zj3
	 ZaW+ZLpBpN+ISzBmDqBnivJtJZZu6cjXTBE7Aw1U6sRWT/ubv4jEvVR4JPFN1jzghR
	 eeOuWI5aqmjefZey1DS1/xzyQkE9fGuzm6SYdYeRZyToHR9T/VO4DdgySKizcvoJp0
	 KWo+6vArMJAT4Cd3JiBsDaX0cvq+NfC4IH+2lDxvMtWiprr17lDktmRXIlh5tuYHNc
	 sUcooMq+oWW9I5nfBY0EyEU0UKwCfqTUzbADsda2loke8ZDhYbJMRL7wx4bCBuxhlT
	 dmZMYBsp05nSg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH 3/3] objtool/klp: Avoid NULL pointer dereference when printing code symbol name
Date: Tue, 10 Feb 2026 13:50:11 -0800
Message-ID: <64116517bc93851a98fe366ea0a4d807f4c70aab.1770759954.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1770759954.git.jpoimboe@kernel.org>
References: <cover.1770759954.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2004-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6CD2411F8C0
X-Rspamd-Action: no action

Fix a hypothetical NULL pointer defereference of the 'code_sym'
variable.  In theory this should never happen.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 9ff65b01882b..a3198a63c2f0 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1352,7 +1352,7 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 {
 	bool static_branch = !strcmp(sym->sec->name, "__jump_table");
 	bool static_call   = !strcmp(sym->sec->name, ".static_call_sites");
-	struct symbol *code_sym = NULL;
+	const char *code_sym = NULL;
 	unsigned long code_offset = 0;
 	struct reloc *reloc;
 	int ret = 0;
@@ -1372,7 +1372,7 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 
 			/* Save code location which can be printed below */
 			if (reloc->sym->type == STT_FUNC && !code_sym) {
-				code_sym = reloc->sym;
+				code_sym = reloc->sym->name;
 				code_offset = reloc_addend(reloc);
 			}
 
@@ -1395,23 +1395,26 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 		if (!strcmp(sym_modname, "vmlinux"))
 			continue;
 
+		if (!code_sym)
+			code_sym = "<unknown>";
+
 		if (static_branch) {
 			if (strstarts(reloc->sym->name, "__tracepoint_")) {
 				WARN("%s: disabling unsupported tracepoint %s",
-				     code_sym->name, reloc->sym->name + 13);
+				     code_sym, reloc->sym->name + 13);
 				ret = 1;
 				continue;
 			}
 
 			if (strstr(reloc->sym->name, "__UNIQUE_ID_ddebug_")) {
 				WARN("%s: disabling unsupported pr_debug()",
-				     code_sym->name);
+				     code_sym);
 				ret = 1;
 				continue;
 			}
 
 			ERROR("%s+0x%lx: unsupported static branch key %s.  Use static_key_enabled() instead",
-			      code_sym->name, code_offset, reloc->sym->name);
+			      code_sym, code_offset, reloc->sym->name);
 			return -1;
 		}
 
@@ -1422,7 +1425,7 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 		}
 
 		ERROR("%s()+0x%lx: unsupported static call key %s.  Use KLP_STATIC_CALL() instead",
-		      code_sym->name, code_offset, reloc->sym->name);
+		      code_sym, code_offset, reloc->sym->name);
 		return -1;
 	}
 
-- 
2.53.0


