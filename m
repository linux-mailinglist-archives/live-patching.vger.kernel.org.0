Return-Path: <live-patching+bounces-2625-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HDyGcwn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2625-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C12AC4AA139
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 493A9303CA78
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE54D30C353;
	Fri,  1 May 2026 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J375LHWm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB08230B51A;
	Fri,  1 May 2026 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608533; cv=none; b=aBwBB3meOqXxllgvQPuGn4tbaZGsekqWiHYMCI+7ncDrdOzb/I4KY1CzmFZWlm97CpleGsuKfMnuLfr3D3MOO1YD+FM4NLvqFP6JJV/5ul346xqlSnwQ420iu92W4LlwcfiWsuwLQHsVy98KzV526szGflTuaGRkATiP/2lSuGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608533; c=relaxed/simple;
	bh=4uHNmNTMs6Cvsbo7XOnU9ntyLG2KD6N0hm/d06JUQYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReRHLcj6opmeEq1RvHNARjzRQ1JBgkdSmODaEchRBA/2I8n3SKU7o4NdFlN3qjlNHhOJ4o51Du4BRH5774wVv59tFiai6OLCW07nf3p0RIAAu/NSrdqspvwddq/GYwgcA47YbqK/7JXHoPnzts+lMbvlXXNY7BSbZNrSRDiRjpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J375LHWm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ECEC2BCC6;
	Fri,  1 May 2026 04:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608533;
	bh=4uHNmNTMs6Cvsbo7XOnU9ntyLG2KD6N0hm/d06JUQYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J375LHWmOz2F7UsxX8f8qx1fK5JLd0V5FFy7UJvRJxxlyVUYNEAEYqrn6o3JLUWon
	 IXHYigIqpz80uTw7QxWkL2YW41eZ+NdeL/929fVcOFiTYJQfuPqUuoVpELu2EBp5mE
	 H/T5Qq4RtVxm6Hb9bDqaeLPYjBaYM3jIh3y2lyUu4S8kBKNZGBTmJ7g+dillE5cW7i
	 5GXQOLFtKIqLn5ILUzT4BW5Dv01/0q+5GQS2mGxEw5TEm9Jig+rK3QY0kED/LioxSh
	 QLpz05YjLjReabM+Lgea2/iwFIFHrJbNJTZH65xZMVZc0BagqeM7Qyw+tqnrwO0b+7
	 cU44BUVEPVzNA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 07/53] objtool/klp: Improve local label check
Date: Thu, 30 Apr 2026 21:07:55 -0700
Message-ID: <54175a1446aae952ad4d886eec3f64fcbdbeb375.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: C12AC4AA139
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2625-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Clang emits various .L-prefixed local symbols beyond .Ltmp*, such as
.L__const.* for local constant data.  These are assembler-local labels
not present in kallsyms, so they can never be resolved at module load
time.

Broaden the check from .Ltmp* to all .L* symbols so they get cloned into
the patch module instead.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ccb16a45107e..c5d4c9ed8580 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -282,14 +282,14 @@ static bool is_uncorrelated_static_local(struct symbol *sym)
 }
 
 /*
- * Clang emits several useless .Ltmp_* code labels.
+ * .L symbols are assembler-local labels not present in kallsyms.  They must
+ * never become KLP relocations; instead their data is cloned into the patch
+ * module.  This covers .Ltmp* (Clang temp labels), .L__const.* (Clang local
+ * constants), and any other assembler-local pattern.
  */
-static bool is_clang_tmp_label(struct symbol *sym)
+static bool is_local_label(struct symbol *sym)
 {
-	return is_notype_sym(sym) &&
-	       is_text_sec(sym->sec) &&
-	       strstarts(sym->name, ".Ltmp") &&
-	       isdigit(sym->name[5]);
+	return strstarts(sym->name, ".L");
 }
 
 static bool is_special_section(struct section *sec)
@@ -388,7 +388,7 @@ static bool dont_correlate(struct symbol *sym)
 	       is_abs_sym(sym) ||
 	       is_prefix_func(sym) ||
 	       is_uncorrelated_static_local(sym) ||
-	       is_clang_tmp_label(sym) ||
+	       is_local_label(sym) ||
 	       is_string_sec(sym->sec) ||
 	       is_initcall_sym(sym) ||
 	       is_addressable_sym(sym) ||
-- 
2.53.0


