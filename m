Return-Path: <live-patching+bounces-1922-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJ1vDyYCd2maaQEAu9opvQ
	(envelope-from <live-patching+bounces-1922-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 26 Jan 2026 06:56:54 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77565844F8
	for <lists+live-patching@lfdr.de>; Mon, 26 Jan 2026 06:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 36A833002D41
	for <lists+live-patching@lfdr.de>; Mon, 26 Jan 2026 05:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC10223336;
	Mon, 26 Jan 2026 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMcJsDKG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E3D21B191;
	Mon, 26 Jan 2026 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769407011; cv=none; b=MgKBw88NrCYVttMjzl+rh2vnhqkhlXGBBBGGnvd99FDJlFlhC0Ch155byZvD2fKzXcliTY9z3DJ2HYQZQaHcpQOVYxyh0HzZRr2Oym28aBiRSKB8d/sOw3W0STjld3i71FPspzk+jSUb4b6PFGMC208i6HKKvT3F+19p3UvduJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769407011; c=relaxed/simple;
	bh=A70Zeoq95+ePl38rR9pvQUMxQyeGOw7GCfIx+rzyUJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n+Eo9O3Opi3kagigWs7H4VMcTDHYRQz1a6O6h5mGOUNSgao5p4d7kdtCYUw0PCk8iPBll8SL6r7Ok9MWxAYMv8/yT3xY0jU9fo7LvScsRheKIsX7WC1lSS4gUnLePP9FTKFuBKAugaKt1c94ePajLd4Cp4173YhuQT9OCE9dRyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMcJsDKG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89A8C116C6;
	Mon, 26 Jan 2026 05:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769407011;
	bh=A70Zeoq95+ePl38rR9pvQUMxQyeGOw7GCfIx+rzyUJk=;
	h=From:To:Cc:Subject:Date:From;
	b=PMcJsDKGT4X1tUkDjRgmubwkGzCzjp5UKIolQtHzwOuiFgiffLqB2NnUqXUw8Koog
	 2cAZD6Hd2myyM6JaNqk+vrhi6CLRxbJDzJc5VMmCO66kTLynbo4pplWMFtm27MZ5QM
	 DRU0eQnlCQYT72375Q3Zgz3a1DkDbsbwXATkEqUkfzAvTWNGvK/757L7U66z14Hyzc
	 7UrMQxlKapqmWaGe8tw6oLgVoDzzgcmSE3roKWx6hihtoejXV3O5xd3WVteDkcmMOa
	 xSfCuY79UKMDrOsPi2US3Y4h5A65xQUlNhy6tiCTmqiw4BcUG6qPU0CBdnrnrkKa1+
	 J2rl4tZ6RKYjg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Breno Leitao <leitao@debian.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>
Subject: [PATCH] objtool/klp: Fix bug table handling for __WARN_printf()
Date: Sun, 25 Jan 2026 21:56:39 -0800
Message-ID: <a8e0a714b9da962858842b9aecd63b4900927c88.1769406850.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.52.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1922-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 77565844F8
X-Rspamd-Action: no action

Running objtool klp-diff on a changed function which uses WARN() can
fail with:

  vmlinux.o: error: objtool: md_run+0x866: failed to convert reloc sym '__bug_table' to its proper format

The problem is that since commit 5b472b6e5bd9 ("x86_64/bug: Implement
__WARN_printf()"), each __WARN_printf() call site now directly
references its bug table entry.  klp-diff errors out when it can't
convert such section-based references to object symbols (because bug
table entries don't have symbols).

Luckily, klp-diff already has code to create symbols for bug table
entries.  Move that code earlier, before function diffing.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Fixes: 5b472b6e5bd9 ("x86_64/bug: Implement __WARN_printf()")
Reported-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
For tip/objtool/urgent.

 tools/objtool/klp-diff.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index bb6b711d4e73..76aa77c26655 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1425,9 +1425,6 @@ static int clone_special_sections(struct elfs *e)
 {
 	struct section *patched_sec;
 
-	if (create_fake_symbols(e->patched))
-		return -1;
-
 	for_each_sec(e->patched, patched_sec) {
 		if (is_special_section(patched_sec)) {
 			if (clone_special_section(e, patched_sec))
@@ -1704,6 +1701,17 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (!e.out)
 		return -1;
 
+	/*
+	 * Special section fake symbols are needed so that individual special
+	 * section entries can be extracted by clone_special_sections().
+	 *
+	 * Note the fake symbols are also needed by clone_included_functions()
+	 * because __WARN_printf() call sites add references to bug table
+	 * entries in the calling functions.
+	 */
+	if (create_fake_symbols(e.patched))
+		return -1;
+
 	if (clone_included_functions(&e))
 		return -1;
 
-- 
2.52.0


