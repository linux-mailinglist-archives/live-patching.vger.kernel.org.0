Return-Path: <live-patching+bounces-2471-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eA3wIHKd6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2471-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:17:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 790E044CDF2
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 44FB13021C16
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995093DE44B;
	Thu, 23 Apr 2026 04:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUGNA1vS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F02E3DE43B;
	Thu, 23 Apr 2026 04:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917087; cv=none; b=mj4jC1Yjl2X6sufs6NnY5c73RWmv78Tw8xepVlzWq+9cjEdKjkGKnwggzNeadTTVZ4fEokWnBSOmh2fqXHLccYTtjp5ySOtq+JY8oQdviR3A40Zyrne1ZCSqw1gmCAXk2DvA78TS/g8JAVTWconKtKfjdDi6LtsOjDIqSJNuaCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917087; c=relaxed/simple;
	bh=k0wkC3ZtERLufbrxciB55SYGNx4LscQb4oK+lu00MeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2SvA4z8GAXJP0fpBZDaKZY4TQ20sr9kOZ4/TjFgB3kvBlianS/Po90dTzE0cvyANXvIlrCFvR7E9rNxEko0hUgVJbk0DNFBYge0Xm8qNdpDhb+93MUD1iFwVsLomI2ka0X2GR/amgXLPz2aXNbrqyf+mR5rqNQOGnxDjlQh560=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUGNA1vS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2117C2BCB5;
	Thu, 23 Apr 2026 04:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917087;
	bh=k0wkC3ZtERLufbrxciB55SYGNx4LscQb4oK+lu00MeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUGNA1vSr+2XrVwdGReq9tkvDWmxVLnO6PNpjLATZrLlH8WAFhsPyx7lVi1MZPdvm
	 L06g0DJD80u82J4ErJ2770XDxXWla6lQ3ml0URKm3XefjjscPRrqDO+4/HcwMr6vtg
	 ev0YteGnzasN78tvibh7xcoba0I0M36AbVEO/JILtQgeEZ0Zwv8lE+VSO2jvdeuBxF
	 ZgFT/PK1oCNlteW3FBKyC9Nb0vUdtnojlT38sBktsFQREmW8931NdPx1PPJPddPF9z
	 YVgnxf0qEXIuWmV0nD1Z1SUZNR/ZK0hu7FkIi86Z3QbshPSPcJ1AVaIdXNagdltSZ0
	 wJkKhw3pvrZ9A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 44/48] objtool/klp: Fix position-dependent checksums for non-relocated jumps/calls
Date: Wed, 22 Apr 2026 21:04:12 -0700
Message-ID: <ad68e53660e4b032506cbf77f8c922099c9cbdd7.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
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
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2471-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 790E044CDF2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index 0c53476528a8..bc99355e66e9 100644
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
index adfd02447a45..4100b4dfba86 100644
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


