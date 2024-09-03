Return-Path: <live-patching+bounces-552-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4108296928D
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2888283B7D
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4BDD1D47DB;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s05wWCXK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CE71D47C4;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336038; cv=none; b=hVWZ2evQEiFn5jLDcUcn+4wszHez3Zkagtl8E2+e6T3B8kpROcMnQ8Xb85SGeq4N4vv0Hl7NRBPV+ji0O6pnfM0GBNkKQ3P54hMOAn9RhgjJVJDLOvwGw9LgBOvYnwTzn25CCLwxL8y+fSRFT+ST1NC6zuTW8Ou2PnBxnVb0a8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336038; c=relaxed/simple;
	bh=R7lpTxC5zGA9gCmdCP81GjnhFXtOMx9okauDMWA62HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6lTU26kpn/ySnO+vy3yDXepwc85yurdSt8j6iHV1EspIM07+3LocO0q83k2N7oLZI8qf1smk0Go1SFMieMl/jFpu5AbrnhkpsG036doMIiz+OziL9ScaClfc3iN590mg4qRGU/WXGLsQOsn874eFBbkO08+juUtvyCEzAskWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s05wWCXK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2EDC4CED4;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336038;
	bh=R7lpTxC5zGA9gCmdCP81GjnhFXtOMx9okauDMWA62HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s05wWCXKjhfihSR7WWAMeTdm/B/Jn9c76wduABCrAd9bF13ETnEUwbdFk4VkO9cLc
	 JOXU/FcFF60DfP18JGZDLloSnbpxWd3+BKy4FS3tkgOxZ0vLDCnHhXq4QUvKjhUVvy
	 LtbD9Sh7g9c8rOiR7JnTAkQZzOJYWwjEsHeHypRP3kItYk5glP1Zp3s7jnVtFtVlwl
	 1xAs/UvZrfQ5fWDLfum//TJ/A52WOh9R4ACzEukUHV0O4n6bDGeDHBpYRTxNmak0hU
	 fZ2m4D/IyMabxJqoixjz14dMQIoahGMVcEdrESKe906TRJkFF7VAPV49bh6lJtLgTo
	 gQ63GLR4tbF0w==
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
Subject: [RFC 18/31] objtool: Disallow duplicate prefix symbols
Date: Mon,  2 Sep 2024 21:00:01 -0700
Message-ID: <569ad57b4b74af51f806e624dea25b4c912533c8.1725334260.git.jpoimboe@kernel.org>
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

Error out if a duplicate prefix symbol is attempted.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 5 ++++-
 tools/objtool/elf.c                 | 9 +++++++++
 tools/objtool/include/objtool/elf.h | 3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index af945854dd72..236dc7871f01 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3866,6 +3866,7 @@ static void add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	for (prev = prev_insn_same_sec(file, insn);
 	     prev;
 	     prev = prev_insn_same_sec(file, prev)) {
+		struct symbol *sym_pfx;
 		u64 offset;
 
 		if (prev->type != INSN_NOP)
@@ -3879,7 +3880,9 @@ static void add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 		if (offset < opts.prefix)
 			continue;
 
-		elf_create_prefix_symbol(file->elf, func, opts.prefix);
+		sym_pfx = elf_create_prefix_symbol(file->elf, func, opts.prefix);
+		if (!sym_pfx)
+			ERROR("duplicate prefix symbol for %s\n", func->name);
 
 		break;
 	}
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 0c95d7cdf0f5..748c170b931a 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -767,11 +767,20 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
 	size_t namelen = strlen(orig->name) + sizeof("__pfx_");
 	char name[SYM_NAME_LEN];
 	unsigned long offset;
+	struct symbol *sym;
 
 	snprintf(name, namelen, "__pfx_%s", orig->name);
 
+	sym = orig;
 	offset = orig->sym.st_value - size;
 
+	sec_for_each_sym_continue_reverse(orig->sec, sym) {
+		if (sym->offset < offset)
+			break;
+		if (sym->offset == offset && !strcmp(sym->name, name))
+			return NULL;
+	}
+
 	return elf_create_symbol(elf, name, orig->sec,
 				 GELF_ST_BIND(orig->sym.st_info),
 				 GELF_ST_TYPE(orig->sym.st_info),
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index e91bbe7f07bf..5ac5e7cdddee 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -399,6 +399,9 @@ static inline void set_reloc_type(struct elf *elf, struct reloc *reloc, unsigned
 #define sec_for_each_sym(sec, sym)					\
 	list_for_each_entry(sym, &sec->symbol_list, list)
 
+#define sec_for_each_sym_continue_reverse(sec, sym)			\
+	list_for_each_entry_continue_reverse(sym, &sec->symbol_list, list)
+
 #define for_each_sym(elf, sym)						\
 	for (struct section *__sec, *__fake = (struct section *)1;	\
 	     __fake; __fake = NULL)					\
-- 
2.45.2


