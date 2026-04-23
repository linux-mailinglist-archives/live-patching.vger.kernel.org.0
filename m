Return-Path: <live-patching+bounces-2435-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AAqLLpOa6Wm0egIAu9opvQ
	(envelope-from <live-patching+bounces-2435-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:05:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8435C44CB0A
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3C694300D1EC
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBC73D171A;
	Thu, 23 Apr 2026 04:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBwdmJA3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD52B3D0930;
	Thu, 23 Apr 2026 04:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917067; cv=none; b=N5uUAxBeenX7veOeyXnnT8YNtbRjFa6ndFeWS54Pt9Z9l7+uMx4L2gwK0DLHrbyDKe5zIu61RoBPg/Zd/BhHRY/BM4epSPhyhgT9fDRtJNOwn0Zqo0jbN35Yb50W5UiwYz5dOq066sZC8Q8NUQL7MiEgQeGixuwYbyEBD2MrAW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917067; c=relaxed/simple;
	bh=GWjzH6dcqSwmIWvvOSKlsujsIsapPa8vd+VFv56LUmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDi+oBR7KL3yF0k5bMR4U3whsEuXkgDyaxeg9fNL/0AlmhO9eB/Z1llOzqxo2irv4ZU/wyWkwS7kGIIabJEMnzuzc9vdJrIkkdf0U6rhj/JNt46Z3YoZBMPHP5ENV+BnOXGHbRvvb7mfamOqDA0R2It5jbxRfQ1RvdTrQNeeLAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBwdmJA3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7DCC2BCB7;
	Thu, 23 Apr 2026 04:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917067;
	bh=GWjzH6dcqSwmIWvvOSKlsujsIsapPa8vd+VFv56LUmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBwdmJA3wEXVC7/pP1ySoBIClAjgySAOXE6DOLWEFKYl83d9dkBlk3ViRn3HdC5NQ
	 1EvrQWd7ref03C4Q5v+QgWQnKYL0OtTVB5sIytyRAb9emEUWrYNkw118ZBd3bK1K5a
	 7zNLeUWvNAHHJYbfXpyAmhaL9tGDeJk3yIUWRAKaoYpp+oR7WJ1uqWlYH5uCwQSECy
	 qB46pUzmVITr7lPApdYXzjwmVRxp9M65dlGUHrZHNjpJJHTdC1LPw33ZEs3ArRUp8V
	 KEPEC8Fqi/IAWSQQvbqRvUAtUYIZbBPhHX0l283xwNqKHC1GDtUweX9vzyn6JQVV1U
	 WcYtkOgs35k8A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 08/48] objtool/klp: Don't correlate __initstub__ symbols
Date: Wed, 22 Apr 2026 21:03:36 -0700
Message-ID: <b62dafa3c40576c8e82b062bc24116772c272b87.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2435-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8435C44CB0A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

With LTO, the initcall infrastructure generates __initstub__kmod_*
wrapper functions in .init.text.  These are the LTO equivalent of
__initcall__kmod_* data pointers, which are already excluded from
correlation.

These are __init functions whose memory is freed after boot, so there's
no reason to include or reference them in a livepatch module.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 05071d691b5f..022522cd9b6c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -370,6 +370,12 @@ static bool is_abs_sym(struct symbol *sym)
 	return sym->sym.st_shndx == SHN_ABS && !is_file_sym(sym);
 }
 
+static bool is_initcall_sym(struct symbol *sym)
+{
+	return strstarts(sym->name, "__initcall__") ||
+	       strstarts(sym->name, "__initstub__");
+}
+
 /*
  * These symbols should never be correlated, so their local patched versions
  * are used instead of linking to the originals.
@@ -385,10 +391,10 @@ static bool dont_correlate(struct symbol *sym)
 	       is_clang_tmp_label(sym) ||
 	       is_string_sec(sym->sec) ||
 	       is_rodata_sec(sym->sec) ||
+	       is_initcall_sym(sym) ||
 	       is_addressable_sym(sym) ||
 	       is_special_section(sym->sec) ||
-	       is_special_section_aux(sym->sec) ||
-	       strstarts(sym->name, "__initcall__");
+	       is_special_section_aux(sym->sec);
 }
 
 struct process_demangled_name_data {
-- 
2.53.0


