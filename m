Return-Path: <live-patching+bounces-1944-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIQrJfwWfWkGQQIAu9opvQ
	(envelope-from <live-patching+bounces-1944-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:39:24 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B18FCBE763
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4060E3008C97
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177F432B99F;
	Fri, 30 Jan 2026 20:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idO4R9cH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B0824EF8C
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769805558; cv=none; b=bMKxolUftQGNPhVm4hO5raPjBsSx7Wnv4LoVpEPu8gM+0AzpCrKStlQyb7w4RfeqnQvDkrgzwbDNkueFuPTiKbNLGckbBAR+JtbVwWZKcBbph+OwRHd351T76nJ1J3KByq6ejzQVIcUjSNu/C6DCg1dAChOdHkIojnDVyKx3/vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769805558; c=relaxed/simple;
	bh=Nf/1w0loMR/2i7P2iarm/D5U6PoOsOHXAnwxA1Bcq+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qSeDAQhZ8U5KnoMsWj+1Nqzn6uqTwmiiYJwYfP8jSLnUsfSeV6iYeTvJaX2Qb34Qtx2ENqCcMJuoVNglQH5GP8T/nGWN9wDcJIQLG8rXfthl2aUgjVMMSkQ0xZQth+rgu/TYUWCmwq8wSPiighb7FCZb+B5XpOLr4xrjYr3udtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idO4R9cH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF92DC4CEF7;
	Fri, 30 Jan 2026 20:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769805557;
	bh=Nf/1w0loMR/2i7P2iarm/D5U6PoOsOHXAnwxA1Bcq+o=;
	h=From:To:Cc:Subject:Date:From;
	b=idO4R9cHRTmoOFAI6bPhW2v7LDXMRFKpn7sJaK+L1nK1fH/7JRLYQ80Je9UGPZPDj
	 hykVftZQWyspim38AXLo1a6SVOIcklOdzCgtXW1EV/R0fDHvq+aVusgYyaQFGPcheO
	 5XVKih6uLcuqbTk1sPxhICdI7vOOq4C9W+vtLJ4FquNBniwkiI6Ikghqw0o0lRSNcE
	 GK6k+ONT6tYzwJ4OLGe+e89Cl8hvT8mRQ4/cRpq1SIrTcMmqHshNozdTrRAc2I0YQp
	 0wtG3ammqz2B+CggiHNLhqOHKCrPT7YJPBPVoLaeBVHPTvHALIZvBp+yFy0E1dLzYb
	 qiJHVcOlCA1Ew==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	kernel-team@meta.com,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] klp-build: Do not warn "no correlation" for __irf_[start|end]
Date: Fri, 30 Jan 2026 12:39:12 -0800
Message-ID: <20260130203912.2494181-1-song@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-1944-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
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
X-Rspamd-Queue-Id: B18FCBE763
X-Rspamd-Action: no action

When compiling with CONFIG_LTO_CLANG_THIN, vmlinux.o has
__irf_[start|end] before the first FILE entry:

$ readelf -sW vmlinux.o
Symbol table '.symtab' contains 597706 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   18 __irf_start
     2: 0000000000000200     0 NOTYPE  LOCAL  DEFAULT   18 __irf_end
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT   17 .text
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT   18 .init.ramfs

This causes klp-build throwing warnings like:

vmlinux.o: warning: objtool: no correlation: __irf_start
vmlinux.o: warning: objtool: no correlation: __irf_end

Fix this by not warn for no correlation before seeing the first FILE
entry.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/klp-diff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index d94531e3f64e..370e5c79ae66 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -363,6 +363,7 @@ static int correlate_symbols(struct elfs *e)
 {
 	struct symbol *file1_sym, *file2_sym;
 	struct symbol *sym1, *sym2;
+	bool found_first_file = false;
 
 	/* Correlate locals */
 	for (file1_sym = first_file_symbol(e->orig),
@@ -432,9 +433,12 @@ static int correlate_symbols(struct elfs *e)
 	}
 
 	for_each_sym(e->orig, sym1) {
+		if (!found_first_file && is_file_sym(sym1))
+			found_first_file = true;
 		if (sym1->twin || dont_correlate(sym1))
 			continue;
-		WARN("no correlation: %s", sym1->name);
+		if (found_first_file)
+			WARN("no correlation: %s", sym1->name);
 	}
 
 	return 0;
-- 
2.47.3


