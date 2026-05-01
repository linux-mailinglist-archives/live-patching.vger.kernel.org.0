Return-Path: <live-patching+bounces-2666-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPYkDIcp9GlA+wEAu9opvQ
	(envelope-from <live-patching+bounces-2666-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:18:15 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 983414AA364
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C3D5C3073611
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724D33793D2;
	Fri,  1 May 2026 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/nYocX6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0B531D74B;
	Fri,  1 May 2026 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608554; cv=none; b=aD4hzFLE1732Q+ybY1YMjK5zUWKzO+0RQHnC7CEDuMoDHmI8sBkElZymXEB7PhkF8lvFnI1eGo1IxrCHASsdKG9gCHnXGGdHCJfPvgjPjToLBASol28DFjgX+ViT9oTl3yz0CtVjLV6jQrhg/P+EaMUCvMXYQoAZNY50u/o3Nzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608554; c=relaxed/simple;
	bh=4sZ9od17f5P1PS5M6howR79GuYi+ntpQw6uTUlGfUxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz9bPjZps6tT3t8R1fNT53FV2qMxr5RgTFrmwFDedXygh1mA4Yqf40FFJd+yqFBvklm2omMxV/KUKmmg1n8jEKAqyI7byLcb8/JCg9BgSoDoRfwDJkwsccbeXnPRBiPjLhD6CEJl7UJkmETkegEB0aD4Q67Hvl4vzMSReruSgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/nYocX6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86033C2BCC6;
	Fri,  1 May 2026 04:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608554;
	bh=4sZ9od17f5P1PS5M6howR79GuYi+ntpQw6uTUlGfUxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/nYocX6YDEhopf51+IO3sYh/KAEBEWPikCnugtF/Mw3BIDfBGp60xnScOG7aZ6iX
	 dZtEa1PmxHXXjjnYs2PbZYNj/xw5FI5wu/TqitxWg8HWkNJm9DxEaPFl+U/945yNfn
	 uZvD6ew6UiF3eFDbsh1XMOYEk9sifOZGFhAx1Lz7Giue/jUgPlcIcWCg6920e0XgV6
	 38wftTWzl63kpLE5AjxDJ7LW+Rt4pNh21mmEWQH5grfJCAf0QwINVoxXuO+jOQt2ns
	 oET+4vkpDpJ95RcNxE/+lHaKn2icqwFF8tMrFesFUbfuJx/p03YwBv9ly70j2YXNDE
	 pNpBFH4eWHnoA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 49/53] objtool/klp: Fix position-dependent checksums for non-relocated jumps/calls
Date: Thu, 30 Apr 2026 21:08:37 -0700
Message-ID: <b9fe30f891bddaff919e48bc2f620f7f66fa98ca.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 983414AA364
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2666-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

When computing klp checksums, instructions with non-relocated jump/call
destination offsets are problematic because the offset values can change
when surrounding code has moved, causing the function to be incorrectly
marked as changed.

Specifically, that includes jumps from alternatives to the end of the
alternative, which from objtool's perspective are jumps to the end of
the alternative instruction block in the original function.

Note that 'jump_dest' jumps don't include sibling calls (those use
call_dest), nor do they include jumps to/from .cold sub functions (those
are cross-section and need a reloc).

Fix it by hashing the opcode bytes (excluding the immediate operand)
along with a position-independent representation of the destination.
For calls, use the function name, and for jumps, use the destination's
offset within its function.

[Note the "9 bit hole" comment was wrong: it has been 8 bits since
commit 70589843b36f ("objtool: Add option to trace function validation")
added the 'trace' field.  Adding the 4-bit 'immediate_len' field now
leaves a 4-bit hole.]

Fixes: 0d83da43b1e1 ("objtool/klp: Add --checksum option to generate per-function checksums")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/decode.c       | 17 ++++++++-
 tools/objtool/include/objtool/arch.h  |  3 ++
 tools/objtool/include/objtool/check.h |  3 +-
 tools/objtool/klp-checksum.c          | 53 ++++++++++++++++++++++++---
 4 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 350b8ee6e776..1b387d5a195b 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -805,14 +805,27 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 		break;
 	}
 
-	if (ins.immediate.nbytes)
+	if (ins.immediate.nbytes) {
 		insn->immediate = ins.immediate.value;
-	else if (ins.displacement.nbytes)
+		insn->immediate_len = ins.immediate.nbytes;
+	} else if (ins.displacement.nbytes) {
 		insn->immediate = ins.displacement.value;
+		insn->immediate_len = ins.displacement.nbytes;
+	}
 
 	return 0;
 }
 
+size_t arch_jump_opcode_bytes(struct objtool_file *file, struct instruction *insn,
+			      unsigned char *buf)
+{
+	size_t len;
+
+	len = insn->len - insn->immediate_len;
+	memcpy(buf, insn->sec->data->d_buf + insn->offset, len);
+	return len;
+}
+
 void arch_initial_func_cfi_state(struct cfi_init_state *state)
 {
 	int i;
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 8866158975fc..96d828a8401f 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -79,6 +79,9 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 			    unsigned long offset, unsigned int maxlen,
 			    struct instruction *insn);
 
+size_t arch_jump_opcode_bytes(struct objtool_file *file, struct instruction *insn,
+			      unsigned char *buf);
+
 bool arch_callee_saved_reg(unsigned char reg);
 
 unsigned long arch_jump_destination(struct instruction *insn);
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index fe08205d8eb1..063f5985fecd 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -68,6 +68,7 @@ struct instruction {
 	s8 instr;
 
 	u32 idx			: INSN_CHUNK_BITS,
+	    immediate_len	: 4,
 	    dead_end		: 1,
 	    ignore_alts		: 1,
 	    hint		: 1,
@@ -81,7 +82,7 @@ struct instruction {
 	    hole		: 1,
 	    fake		: 1,
 	    trace		: 1;
-		/* 9 bit hole */
+		/* 4 bit hole */
 
 	struct alt_group *alt_group;
 	struct instruction *jump_dest;
diff --git a/tools/objtool/klp-checksum.c b/tools/objtool/klp-checksum.c
index 19653dbe109d..b8e47f28997e 100644
--- a/tools/objtool/klp-checksum.c
+++ b/tools/objtool/klp-checksum.c
@@ -66,17 +66,58 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 	if (insn->fake)
 		return;
 
-	__checksum_update_insn(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
-
 	if (!reloc) {
 		struct symbol *call_dest = insn_call_dest(insn);
+		struct instruction *jump_dest = insn->jump_dest;
 
-		if (call_dest)
-			__checksum_update_insn(func, insn, call_dest->demangled_name,
-					       strlen(call_dest->demangled_name));
-		goto alts;
+		/*
+		 * For a jump/call non-relocated dest offset embedded in the
+		 * instruction, the offset may vary due to changes in
+		 * surrounding code.  Just hash the opcode and a
+		 * position-independent representation of the destination.
+		 */
+
+		if (call_dest || jump_dest) {
+			unsigned char buf[16];
+			size_t len;
+
+			len = arch_jump_opcode_bytes(file, insn, buf);
+			__checksum_update_insn(func, insn, buf, len);
+
+			if (call_dest) {
+				__checksum_update_insn(func, insn, call_dest->demangled_name,
+						       strlen(call_dest->demangled_name));
+
+			} else if (jump_dest) {
+				struct symbol *dest_sym;
+				unsigned long offset;
+
+				/*
+				 * use insn->_sym instead of insn_sym() here.
+				 * For alternative replacements, the latter
+				 * would give the function of the code being
+				 * replaced.
+				 */
+				dest_sym = jump_dest->_sym;
+				if (!dest_sym)
+					goto alts;
+
+				__checksum_update_insn(func, insn, dest_sym->demangled_name,
+						       strlen(dest_sym->demangled_name));
+
+				offset = jump_dest->offset - dest_sym->offset;
+				__checksum_update_insn(func, insn, &offset, sizeof(offset));
+			}
+
+			goto alts;
+		}
 	}
 
+	__checksum_update_insn(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+
+	if (!reloc)
+		goto alts;
+
 	sym = reloc->sym;
 	offset = arch_insn_adjusted_addend(insn, reloc);
 
-- 
2.53.0


