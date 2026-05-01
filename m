Return-Path: <live-patching+bounces-2638-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLBiIg0o9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2638-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:11:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 888814AA181
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2B7383024638
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769E033A014;
	Fri,  1 May 2026 04:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NiY6eSOJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38243346A0;
	Fri,  1 May 2026 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608540; cv=none; b=raLE0uZQN4fjv/NVthiAHT+p5VWENw13yymC/UAo7hIWwGF5o3IvQXbOby3M+nkL+ue2H1A1pod2qpvG6aJ3oltEzetmFcdDyuNhLfl0Pob66NigUmozZy+GvtHoe12G+4Oa/Q0kQmn7L7AMxlxFyk0WHjurEVP5GVCjOscvdcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608540; c=relaxed/simple;
	bh=FIQZUcy2Hey8nvAFi1fgSV7gr9AZynhgSHpifcQ9pQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYIx2R9BP/C+AFMCeAFBJjdVdnSH0FILP9esrzvSWW5R/YVSigmGCGkoh7d4n9pg2haij32aNk9eWM+g6Ky1SZhvmTrJvHzRU+J/tWN0O2ExuG3TDoEIaylFiZzi2zDt3sNXzaoxmJ6uv76IpSH9IErDwfNE1+tayjUIylKUwS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NiY6eSOJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C9BC2BCB9;
	Fri,  1 May 2026 04:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608539;
	bh=FIQZUcy2Hey8nvAFi1fgSV7gr9AZynhgSHpifcQ9pQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiY6eSOJuggPmeuLXETEDYfEfw12nxeCLpAXlCwmMLqQLXCCqSYdH3zw8CjIR3TUa
	 3N/JdpP7i8mBHa4cqIOQzM2iY08ZuLsoooId57subT3daJLJQZjWePU90a6r/PWz7w
	 cdRLzJ2MqLViWM4I8q3AZO18+0SaYFFDrypAyji2fjsjU5xSRY7qq+/GRB+OsXO7T7
	 mhKkhNp9+1/MetP4qX8z4rVpBhjH9uLYxiIURn9HsgqGL1qw7hwfJCUw+0+y+LNcpx
	 0a0UqrH5PxBOrp1jMqznXSCA0Leet5lir7mD1Lp9Pvnmo7G2jqZWwjGpk99X6wXoGO
	 NcWz8C5ICR7Ow==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 20/53] objtool/klp: Don't correlate .rodata.cst* constant pool objects
Date: Thu, 30 Apr 2026 21:08:08 -0700
Message-ID: <80d6f8df4db610a6c9f68031dc0153f04814f2fa.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 888814AA181
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2638-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Clang aggregates UBSAN type descriptors into shared anonymous
.data..L__unnamed_* sections.  This data is used by UBSAN trap handlers.

When a changed function has an UBSAN bounds check, klp-diff clones the
entire UBSAN data section associated with the TU.  Relocations within
the cloned section that reference named rodata objects in .rodata.cst*
(like 'exponent', 'pirq_ali_set.irqmap') become KLP relocations because
those objects now get correlated.

That results in a .klp.rela.vmlinux..data section which can easily have
thousands of KLP relocs, most of which are completely superfluous, used
by functions which aren't cloned to the patch module.

The .rodata.cst* sections are SHF_MERGE constant pool sections
containing small fixed-size data (lookup tables, bitmasks) that is only
read by value.  Pointer identity is never relevant for these objects, so
correlating them is unnecessary.

Exclude .rodata.cst* objects from correlation so they get cloned as
local data instead of generating KLP relocations.

It might be possible to someday treat UBSAN data sections as special
sections, and only extract the few needed entries.  But this works for
now.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index bf37c652188b..ca87bcb9afa3 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -372,6 +372,21 @@ static bool is_initcall_sym(struct symbol *sym)
 	       strstarts(sym->name, "__initstub__");
 }
 
+/*
+ * Some .rodata is anonymous and can't be correlated due to there being no
+ * symbol names.
+ *
+ * The .rodata.cst* sections aren't technically anonymous, they're SHF_MERGE
+ * constant pool sections containing small fixed-size data (lookup tables,
+ * bitmasks) which are only read by value, so pointer equivalence isn't needed.
+ * They are typically referenced by UBSAN data sections.
+ */
+static bool is_anonymous_rodata(struct symbol *sym)
+{
+	return is_rodata_sec(sym->sec) &&
+	       (!is_object_sym(sym) || strstarts(sym->sec->name, ".rodata.cst"));
+}
+
 /*
  * These symbols should never be correlated, so their local patched versions
  * are used instead of linking to the originals.
@@ -386,7 +401,7 @@ static bool dont_correlate(struct symbol *sym)
 	       is_uncorrelated_static_local(sym) ||
 	       is_local_label(sym) ||
 	       is_string_sec(sym->sec) ||
-	       (is_rodata_sec(sym->sec) && !is_object_sym(sym)) ||
+	       is_anonymous_rodata(sym) ||
 	       is_initcall_sym(sym) ||
 	       is_addressable_sym(sym) ||
 	       is_special_section(sym->sec) ||
-- 
2.53.0


