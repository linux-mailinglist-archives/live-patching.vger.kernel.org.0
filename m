Return-Path: <live-patching+bounces-546-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B4E969281
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A1831C21824
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A601D0DFB;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrpCr16X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4081D0DEB;
	Tue,  3 Sep 2024 04:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336036; cv=none; b=kDCKgBjnqT1E4QNNcMUk9nauDjWtfXGpSFmOzVjNo84H0YEZYh2R3yu02Zbe1DHvE5ODiZBDSUsLOLnuFDq6+s7l7w1A/jn+BDUw5QYQNMjHunYgL2VF00IUUsyAFq33+h5nAGPgb434P4VEHkA0SY7PVJR6epoy/KDLFozWdro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336036; c=relaxed/simple;
	bh=BtVquJSftqUBmhf9tSLjp9ytg/driSytPQ0zkeW/6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xug4MsNTbXaVLEc2XHsDtkOWIdUejrHiXQ7izogPFXAO/mI76uWD+ymhwecNWOlJw75om+6otcNE+j3xY+9Xir80MjeqEcHEATU/Hrz7FFDpI/QnCmh53t+VdBCarNcE6JlGZtI/XyTVrEC+sj4ijcQqBeE5UMzqxqS9iFtYaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrpCr16X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58240C4CECA;
	Tue,  3 Sep 2024 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336035;
	bh=BtVquJSftqUBmhf9tSLjp9ytg/driSytPQ0zkeW/6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrpCr16Xj6P6aLlmOxmk6PseYF3o+rZY2Xel1RmNF1tdcZZ7WlGTaGUDlfay1OKKk
	 tMF5zULr96XyhuZI2cazrsUjsJki4P/u2v/MugqDAEKVT9iReKyssYJ//wH+YDYD2+
	 MdFPfRM236AKilR79sg0tUoOi16a9wum7Pam7GUWO0EpUWdAkxdDLK20/7x+LSV71k
	 R8U8pp6ZUbAfP2COTzgY2MZktsfss4eUoIp3HMesBNOr6A4P1wSWdXZ9kmBCY9HEhJ
	 0Zb5RRNycz4h2Ay/QR4IcyttCm4LaAiGsEIrSRkOeVDDWG0WXfT9mg26qvhISy0FLg
	 Zc+zplU0gH0rw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 13/31] objtool: Support references to all symbol types in special sections
Date: Mon,  2 Sep 2024 20:59:56 -0700
Message-ID: <08657a8071475e802dd63e3392338a8f950b61bb.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the code simpler and more flexible.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 74 +++++++++----------------------------------
 1 file changed, 15 insertions(+), 59 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 92171ce458ec..9212b5edffc8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -595,15 +595,7 @@ static int add_dead_ends(struct objtool_file *file)
 		goto reachable;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type == STT_SECTION) {
-			offset = reloc_addend(reloc);
-		} else if (reloc->sym->local_label) {
-			offset = reloc->sym->offset;
-		} else {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
-
+		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (insn)
 			insn = prev_insn_same_sec(file, insn);
@@ -635,15 +627,7 @@ static int add_dead_ends(struct objtool_file *file)
 		return 0;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type == STT_SECTION) {
-			offset = reloc_addend(reloc);
-		} else if (reloc->sym->local_label) {
-			offset = reloc->sym->offset;
-		} else {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
-
+		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (insn)
 			insn = prev_insn_same_sec(file, insn);
@@ -1274,12 +1258,9 @@ static int add_ignore_alternatives(struct objtool_file *file)
 		return 0;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
+		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("bad .discard.ignore_alts entry");
 			return -1;
@@ -2255,15 +2236,7 @@ static int read_unwind_hints(struct objtool_file *file)
 			return -1;
 		}
 
-		if (reloc->sym->type == STT_SECTION) {
-			offset = reloc_addend(reloc);
-		} else if (reloc->sym->local_label) {
-			offset = reloc->sym->offset;
-		} else {
-			WARN("unexpected relocation symbol type in %s", sec->rsec->name);
-			return -1;
-		}
-
+		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("can't find insn for unwind_hints[%d]", i);
@@ -2356,12 +2329,9 @@ static int read_retpoline_hints(struct objtool_file *file)
 		return 0;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
+		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("bad .discard.retpoline_safe entry");
 			return -1;
@@ -2392,12 +2362,9 @@ static int read_instr_hints(struct objtool_file *file)
 		return 0;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
+		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("bad .discard.instr_end entry");
 			return -1;
@@ -2411,12 +2378,9 @@ static int read_instr_hints(struct objtool_file *file)
 		return 0;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
+		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("bad .discard.instr_begin entry");
 			return -1;
@@ -2439,12 +2403,9 @@ static int read_validate_unret_hints(struct objtool_file *file)
 		return 0;
 
 	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
+		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("bad .discard.instr_end entry");
 			return -1;
@@ -2468,14 +2429,9 @@ static int read_intra_function_calls(struct objtool_file *file)
 
 	for_each_reloc(rsec, reloc) {
 		unsigned long dest_off;
+		unsigned long offset = reloc->sym->offset + reloc_addend(reloc);
 
-		if (!is_section_symbol(reloc->sym)) {
-			WARN("unexpected relocation symbol type in %s",
-			     rsec->name);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
 			WARN("bad .discard.intra_function_call entry");
 			return -1;
-- 
2.45.2


