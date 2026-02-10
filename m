Return-Path: <live-patching+bounces-2003-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EgfLSyoi2kqYAAAu9opvQ
	(envelope-from <live-patching+bounces-2003-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:36 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3827F11F8B1
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D12313053CCB
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 21:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7EDA33971E;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amUSt5Tu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F2D33893D;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770760225; cv=none; b=D6xE4E+RutbJFd89GOa5cTb1FrTUv8P7GaZbF40R0NM1IxYUd2OZvtZzbaeV2Ktk4OXiqsXS368W/oxHSJ9CT6PbuxPRoelH7Oy4COicNilFyTXd9haVJJ4MjjjyNYaoMngVEnisYOGOLXDvUtFbvos1RM4I0TsJ8OLe7oygTHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770760225; c=relaxed/simple;
	bh=kCFGPObFBu8qXIKo6upQhx1VBMY7BjzgFVXVj1l9Ivs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNgRgN9bobTB4KwxnTwoSMdiUmXJzfB19ZjTehkcqRmFLuacAkD4+d13+pY4h+n+LyKS/Vy0NebgeYae+Z3qgZHktJ2bVuqNzDxLvUcIJnBklEvY+ef8IBoW4SpKUczSiJflidjz23eTUMS6wDjw+8VNKHAJGJDkkjLJfctMgqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amUSt5Tu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6743CC116C6;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770760225;
	bh=kCFGPObFBu8qXIKo6upQhx1VBMY7BjzgFVXVj1l9Ivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amUSt5Tun5UdJgct+4Zk2yiFrladdHVsJu0OPqKQN4byuwkdYOw/xf06rzpZ20JgG
	 95ZPeSTLnwBvIBuKb/2rXqztnIFnN22BOGGyUSSOcKQCnUIf4i6Nxjm9FFRU/DvFL7
	 P0HbsZx5RGdBrt54bRqz28apHANKJBwSDCHRYb4XRHl+lCh+MZZkpT3q+hpiT5gAxo
	 +wd4c3bd6z/WQFoV+y8CvrTjVIdrGNgKYpJZfcW3fNVfcmmv6GnzLB0/jCAkC4tw86
	 H9c5/4zPl+chlwW22Kofs7eb4CIk5EdomA23ptleuKv9NtViduvUgJckLPk4N15tH3
	 pCdq/8qQGU+lA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH 2/3] objtool/klp: Disable unsupported pr_debug() usage
Date: Tue, 10 Feb 2026 13:50:10 -0800
Message-ID: <3a7db3a5b7d4abf9b2534803a74e2e7231322738.1770759954.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2003-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 3827F11F8B1
X-Rspamd-Action: no action

Instead of erroring out on unsupported pr_debug() (e.g., when patching a
module), issue a warning and make it inert, similar to how unsupported
tracepoints are currently handled.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index d94632e80955..9ff65b01882b 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1334,18 +1334,18 @@ static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
  * be applied after static branch/call init, resulting in code corruption.
  *
  * Validate a special section entry to avoid that.  Note that an inert
- * tracepoint is harmless enough, in that case just skip the entry and print a
- * warning.  Otherwise, return an error.
+ * tracepoint or pr_debug() is harmless enough, in that case just skip the
+ * entry and print a warning.  Otherwise, return an error.
  *
- * This is only a temporary limitation which will be fixed when livepatch adds
- * support for submodules: fully self-contained modules which are embedded in
- * the top-level livepatch module's data and which can be loaded on demand when
- * their corresponding to-be-patched module gets loaded.  Then klp relocs can
- * be retired.
+ * TODO: This is only a temporary limitation which will be fixed when livepatch
+ * adds support for submodules: fully self-contained modules which are embedded
+ * in the top-level livepatch module's data and which can be loaded on demand
+ * when their corresponding to-be-patched module gets loaded.  Then klp relocs
+ * can be retired.
  *
  * Return:
  *   -1: error: validation failed
- *    1: warning: tracepoint skipped
+ *    1: warning: disabled tracepoint or pr_debug()
  *    0: success
  */
 static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym)
@@ -1403,6 +1403,13 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 				continue;
 			}
 
+			if (strstr(reloc->sym->name, "__UNIQUE_ID_ddebug_")) {
+				WARN("%s: disabling unsupported pr_debug()",
+				     code_sym->name);
+				ret = 1;
+				continue;
+			}
+
 			ERROR("%s+0x%lx: unsupported static branch key %s.  Use static_key_enabled() instead",
 			      code_sym->name, code_offset, reloc->sym->name);
 			return -1;
-- 
2.53.0


