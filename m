Return-Path: <live-patching+bounces-2623-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOFhHWkn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2623-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:09:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D4E4AA0C0
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:09:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4FB1F30131E7
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60423019A9;
	Fri,  1 May 2026 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSRvlsVs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F602FFF89;
	Fri,  1 May 2026 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608532; cv=none; b=jhD5C3UHVH71HjFFHAOOX1xfcIQzZfexdO9kXq9KVqYw6UYX2AZyLbDpZVj8vVD1zzp/+Ed4CIE7sPQW+JkdKXP7djq6BNkfuC6s76J9OMAC7E0a6EboeR76vP1KZwpGmvvgMUbaYKNis51N9pBnN5Jq+8jTCS/JMOHLRZdUUCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608532; c=relaxed/simple;
	bh=f4v9384o0P5MUr3FWq57o3ckMed62usQCso6ioufjoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekWvpIlUC1q5n2/7CBHwvgmGAuPbYCgOvhnc+BphOCa1sDziPlvITbNqAZyJJnq3qgCCDd5XkOqVlGPEiExYPEojlA973XHgZzHALFHKDZP7+SUrugrp1qXVD0DSZcBUYfzJoa+Oe1IKYasKG+aTZQRXhax4CVpzd9bSbdYb9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSRvlsVs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7DBC2BCB9;
	Fri,  1 May 2026 04:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608532;
	bh=f4v9384o0P5MUr3FWq57o3ckMed62usQCso6ioufjoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSRvlsVsSmQ+Hmnd2ozOqDYkIfkMBp81VHSqu92iLVo9MFOJc5+nk0Fi2JNNfPPJR
	 /WSwa2r+mRlbvW+1bGcTH8uwrZ4fc1uNRy94HPASicYoPU4YsGucde5sd7WHeCgFeL
	 A+lHQ3OfDVekhv4vhvVSxt6BZApHxHfldSviRTSV70dxByLF0H7UHADtSVvyosylfM
	 WR3w4v4VLe2bVKsiPZYhPwQ5KdZMUJaGlBX8HrFPcKeBXbTw/hWTvUluoSPqt7trsn
	 U9GJH9gMKqkHcbGTMQe5ZzPIK5SrysOS7SSvqOC9tzilX6pMZblc3QinRNnhhMcrxS
	 YY5QZDXLV2oug==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 05/53] objtool/klp: Don't correlate __initstub__ symbols
Date: Thu, 30 Apr 2026 21:07:53 -0700
Message-ID: <1fa5106be35420eae021835f4ff25ac535070dfb.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 82D4E4AA0C0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2623-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]

With LTO, the initcall infrastructure generates __initstub__kmod_*
wrapper functions in .init.text.  These are the LTO equivalent of
__initcall__kmod_* data pointers, which are already excluded from
correlation.

These are __init functions whose memory is freed after boot, so there's
no reason to include or reference them in a livepatch module.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 27ebe1b1f463..4f668117c45e 100644
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
@@ -384,10 +390,10 @@ static bool dont_correlate(struct symbol *sym)
 	       is_uncorrelated_static_local(sym) ||
 	       is_clang_tmp_label(sym) ||
 	       is_string_sec(sym->sec) ||
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


