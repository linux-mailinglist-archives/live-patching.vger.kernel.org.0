Return-Path: <live-patching+bounces-2788-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIWNFBbzA2qrBAIAu9opvQ
	(envelope-from <live-patching+bounces-2788-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:42:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5250152CE37
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4F450307480F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F57F3AF662;
	Wed, 13 May 2026 03:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8LNs2H5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519603AF640;
	Wed, 13 May 2026 03:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643295; cv=none; b=ICuPZFmdVYflWnZtRHlBBH/0LhG5kJjCptD/DASrBpNs9CIxYVm3m+wwFST3VeBQI9dsjqB/62ErGENynstZsysa+29dgQJl0Cqzt4pPHrh1qCvAbd7OlB5r2cNVHWmdLJIPjgIf6Jqyw+RJs+ddDgvmLQ3f31FQywX7SL3YgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643295; c=relaxed/simple;
	bh=OGkHFIyLNKCb25myeDpCNSwUOYdeu6CUYnno4eQa9zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAjUdgg8RJY/eQlpicpD0tJjdhCfTpOOEBZUPGo1bBx/wc+ww1U+9hfUVmIoUexqeK/hvHWjEsYWb8EyA/M3MShKFY8H77ZonS400511ZLgn8I5VccoyW+5r/pnrhmvuusGLkZtjAbhKU8R+Awo5xreHZ1N/5h7AmAnfEMK/Qxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8LNs2H5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2C5C2BCFB;
	Wed, 13 May 2026 03:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643294;
	bh=OGkHFIyLNKCb25myeDpCNSwUOYdeu6CUYnno4eQa9zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8LNs2H5q9DoQh/gBLO6iq6c01v+CW3QYgvgdboI9yooOmjPi2YU3NBCqF8kwvloo
	 y0CMhWJGa3HpAv1i8h2v0lZVqzSvHfZ8cjBJKoXKwBdIE52TCwUEdCqqLfto038AaG
	 eY2b9PxciMUJ47Eke5ffmHvBIT366BLiHKG9n6QewEK8TvV3ZzctsGUFYp0LR6ntGN
	 XS6HF6wrHR2OwYUJASqwpBcjiIQZdNDhjsu+ySUQcybaLfB2NZJLFTp8mb0CCysk2q
	 nfkQomctMVj4q4vvFfVCEYDL1dy8mb73ukhMlq0xCS2Md76QV/miojoPcvuNRJMfzP
	 iMto8EcNZXEKA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 14/21] objtool: Prevent kCFI hashes from being decoded as instructions
Date: Tue, 12 May 2026 20:34:10 -0700
Message-ID: <b1d50c9fc9e6b9bca43833cc4ccbd88a31fed84b.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5250152CE37
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2788-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

On arm64 with CONFIG_CFI=y, Clang places a 4-byte kCFI type hash
immediately before each address-taken function entry.  Since these
hashes are in the text section, objtool tries to decode them, leading to
unpredictable results (e.g., "unannotated intra-function call").

arm64 uses mapping symbols to annotate where code ends and data begins
(and vice versa).  Use those to just mark such "instructions" as NOP so
objtool will ignore them.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 15 +++++++++++++++
 tools/objtool/include/objtool/elf.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e05dc7a93dc1e..2b03a2d6fc952 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/static_call_types.h>
 #include <linux/string.h>
+#include <linux/kconfig.h>
 
 static unsigned long nr_cfi, nr_cfi_reused, nr_cfi_cache;
 
@@ -428,6 +429,8 @@ static int decode_instructions(struct objtool_file *file)
 
 	for_each_sec(file->elf, sec) {
 		struct instruction *insns = NULL;
+		struct symbol *map_sym;
+		bool is_data = false;
 		u8 prev_len = 0;
 		u8 idx = 0;
 
@@ -454,6 +457,8 @@ static int decode_instructions(struct objtool_file *file)
 		if (!strcmp(sec->name, ".init.text") && !opts.module)
 			sec->init = true;
 
+		map_sym = list_first_entry(&sec->symbol_list, struct symbol, list);
+
 		for (offset = 0; offset < sec_size(sec); offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
 				insns = calloc(INSN_CHUNK_SIZE, sizeof(*insn));
@@ -478,6 +483,16 @@ static int decode_instructions(struct objtool_file *file)
 
 			prev_len = insn->len;
 
+			/* Use mapping symbols to skip data in text sections */
+			sec_for_each_sym_from(sec, map_sym) {
+				if (map_sym->offset > offset)
+					break;
+				if (is_mapping_sym(map_sym))
+					is_data = is_data_mapping_sym(map_sym);
+			}
+			if (is_data)
+				insn->type = INSN_NOP;
+
 			/*
 			 * By default, "ud2" is a dead end unless otherwise
 			 * annotated, because GCC 7 inserts it for certain
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index d895023674673..9d36b14f420e2 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -507,6 +507,9 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define sec_for_each_sym(sec, sym)					\
 	list_for_each_entry(sym, &sec->symbol_list, list)
 
+#define sec_for_each_sym_from(sec, sym)					\
+	list_for_each_entry_from(sym, &sec->symbol_list, list)
+
 #define sec_prev_sym(sym)						\
 	sym->sec && sym->list.prev != &sym->sec->symbol_list ?		\
 	list_prev_entry(sym, list) : NULL
-- 
2.53.0


