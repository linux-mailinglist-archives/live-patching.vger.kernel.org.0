Return-Path: <live-patching+bounces-2772-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DgDGxLyA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2772-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:37:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B5552CD1F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D3E3830E8625
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEC83A758D;
	Wed, 13 May 2026 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTWc4f4x"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75FB3A71B3;
	Wed, 13 May 2026 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643283; cv=none; b=eGBv+f7qhxrlNgS+TgZ+lV08VMjuwqcgzQ/egtjvmlQR3acgSMBHxPA/p7f3kZa+Si8/dLs7yAq6yOmXp6b5yDxdbddvQJRO8bTEzShO0OoTX9SlyJQUjxKuSH9/pw9QrjL67b0MLDQLgr3oloDqQXAZlScQOpNTomtxxmbdENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643283; c=relaxed/simple;
	bh=YLQATZuaSnhkkzf9eNAaMViHdYeqnWtOoiB9QIjH1E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPn5LN3JN/o1WbqbZ3xHWMZupXICthkK5cKCdSi2QXiRUsmuJbHtO9W9zT/3svgYCRLeY3BejLwM5ghOh4RKgO6I+Hhef1FvnFhGwUVysWejX5mtf5/B9UGL+PpHvUQBzHKkz7jhUhQQ7dRZ+yxo2UCkPAhCh4AinLTzjju/Ca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTWc4f4x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02842C2BCFC;
	Wed, 13 May 2026 03:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643283;
	bh=YLQATZuaSnhkkzf9eNAaMViHdYeqnWtOoiB9QIjH1E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTWc4f4xlExzoEq65yIQKtV+ICaRbk2wTx/GfaqnnWlOQayhR49FihvTkMA/gPDLW
	 8S55+o1kmVbXMVuV7/JtZ4i2DnXpnEBHAuP9NAbqX7kI4ankoTrgmxwjlnlzYWbO5T
	 CTmG0fp4oml6/1T+KNbmNWrIu/UQWciXeyO39X3oEDZ54dk5GhhB3AEEM+ZQoG2yqa
	 4LJWPwvACu78sd3oCUH2Ogat4xozo9Jlci41wUZuZM+2wbYuy5yI8dCglfbOFRXzKo
	 Lh4yCeT5V4Cv+OOwGRxhSau6XQgU95Qii7FufQfJ/TbIHoump0sIfJ9vcgNP5Imqdb
	 WviVX4N9n+cbA==
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
Subject: [PATCH v3 21/21] klp-build: Add arm64 syscall patching macro
Date: Tue, 12 May 2026 20:33:55 -0700
Message-ID: <3bf3cee43039fc4da84e83d0891a92e25f40f00f.1778642121.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 02B5552CD1F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2772-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Add arm64 support for KLP_SYSCALL_DEFINEx(), mirroring the arm64
__SYSCALL_DEFINEx() pattern from arch/arm64/include/asm/syscall_wrapper.h.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/livepatch_helpers.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/livepatch_helpers.h b/include/linux/livepatch_helpers.h
index 99d68d0773fa8..4b647b83865f9 100644
--- a/include/linux/livepatch_helpers.h
+++ b/include/linux/livepatch_helpers.h
@@ -72,6 +72,25 @@
 	}								\
 	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
+#elif defined(CONFIG_ARM64)
+
+#define __KLP_SYSCALL_DEFINEx(x, name, ...)				\
+	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
+	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	asmlinkage long __arm64_sys##name(const struct pt_regs *regs);	\
+	asmlinkage long __arm64_sys##name(const struct pt_regs *regs)	\
+	{								\
+		return __se_sys##name(SC_ARM64_REGS_TO_ARGS(x,__VA_ARGS__));\
+	}								\
+	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
+	{								\
+		long ret = __klp_do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));\
+		__MAP(x,__SC_TEST,__VA_ARGS__);				\
+		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
+		return ret;						\
+	}								\
+	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
+
 #endif
 
 #endif /* _LINUX_LIVEPATCH_HELPERS_H */
-- 
2.53.0


