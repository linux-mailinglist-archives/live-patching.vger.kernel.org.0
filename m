Return-Path: <live-patching+bounces-2002-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPkPDiioi2kqYAAAu9opvQ
	(envelope-from <live-patching+bounces-2002-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:32 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E5F11F8A3
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3858E305043E
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 21:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2C2336EC3;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9AS1rhl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660DC331A77;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770760225; cv=none; b=BZ/gAD5XOaT6raaOxc8m6MBLkm/EOY7pmXVDm182T84xQiGPKed2AutyeGXeMMGexXbiW5H6bIKUUG7bGqiHooZF33GPFhefOrV5QyDxC2h9KHutdNifM95tLbF6CqtqZ0d2asbNlBf6fpZ9DL3iUkFPwO1ArpQOaJMewTAYQzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770760225; c=relaxed/simple;
	bh=GCdZzB5jOwIigRKxnokYUOrUQZmwGrjeqH3KSVdeWcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJcIidNPR8IRfQAA2QFdztVhvAO5WCA6vjCV48Vrpg5M4x4OhXabHVhUHuWiKZjwlJv4U3llX7ou2VY9ZHR1ARqWMNr2Tq+vLzZZdfnNAAdFLZRJQ6EAAOO/NfCx3jp0GSR0O+y8YZWlsexYjVypqw7EJ9Gx8vwZpNIgpRWrIqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9AS1rhl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0993AC19424;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770760225;
	bh=GCdZzB5jOwIigRKxnokYUOrUQZmwGrjeqH3KSVdeWcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9AS1rhl7whcug+CpWtm08FxawKqCaY9jmu8G6doSUkfDiwgy6OWtGENj+foBNwwk
	 7hqXAFxwGu5UMxUAU9JjRJZN7HPjOuKmTf+VKK1xDKolE7x8kesAfuWItGceMpk6QF
	 GDk+yn5b/OatHsfDkWzlTgCnkCp52tSrR1A3L9A4JlKA7yb5a6rLJf7rt2itKqSzEx
	 148ZrA6NnhDpDkEJb/e7BYlRzPL1GnQ5cTWbfcqukJxs9SD1wsiDb0RtPQj/PmZExG
	 GC16g+WKtnxeG6Uk6WNNZFEd/J1G/D5MeibKCh8OaW737LnpVlc5xEcsED/b+3HNIS
	 HiFrL2qqmBfCw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH 1/3] objtool/klp: Fix detection of corrupt static branch/call entries
Date: Tue, 10 Feb 2026 13:50:09 -0800
Message-ID: <124ad747b751df0df1725eff89de8332e3fb26d6.1770759954.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2002-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: A2E5F11F8A3
X-Rspamd-Action: no action

Patching a function which references a static key living in a kernel
module is unsupported due to ordering issues inherent to late module
patching:

  1) Load a livepatch module which has a __jump_table entry which needs
     a klp reloc to reference static key K which lives in module M.

  2) The __jump_table klp reloc does *not* get resolved because module M
     is not yet loaded.

  3) jump_label_add_module() corrupts memory (or causes a panic) when
     dereferencing the uninitialized pointer to key K.

validate_special_section_klp_reloc() intends to prevent that from ever
happening by catching it at build time.  However, it incorrectly assumes
the special section entry's reloc symbol references have already been
converted from section symbols to object symbols, causing the validation
to miss corruption in extracted static branch/call table entries.

Make sure the references have been properly converted before doing the
validation.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Reported-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 9f1f4011eb9c..d94632e80955 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1364,6 +1364,9 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 		const char *sym_modname;
 		struct export *export;
 
+		if (convert_reloc_sym(e->patched, reloc))
+			continue;
+
 		/* Static branch/call keys are always STT_OBJECT */
 		if (reloc->sym->type != STT_OBJECT) {
 
-- 
2.53.0


