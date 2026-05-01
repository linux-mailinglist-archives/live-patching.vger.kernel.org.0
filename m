Return-Path: <live-patching+bounces-2621-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cN5pJHcn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2621-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:09:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 354404AA0CE
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 495B23022956
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2025A2F6184;
	Fri,  1 May 2026 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgnM87Yl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CE12F4A16;
	Fri,  1 May 2026 04:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608532; cv=none; b=jLlH4fqKxZpoJQWJ9ojoDlgJvogVhMpV4oJkLMlXIfXPYQvvHV7QEXVQNty3o7qRNEigOQduhF8aZGITV11plhKK5rnWKKxCS9i8PHJVxuC4WG3Tdo9lGqhstbF0W4JZ7LvAGY1a8/w8sn0JDaNO/k9Texfps6M1/JfUfu7251o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608532; c=relaxed/simple;
	bh=+NM3TboCjx9zMokNZj1lQYyUCDXizYcds2lJrXgjfgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwPeaH0YCiW02dCWEtHo6H2/IYuM6byH/+8cGTu2jMFteBy2bX+hKhlnBiqyi6NnoiReogHFkVhu6PaD1NuNKtk/htR5TMy/LG+qqny3RtctKC9T1/veWuGs6P+6Jv7wZTAm8xrTiKMUtdV9YBkyT6Rwrb8ljAkH8o+TPjt0IFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgnM87Yl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E8EC2BCB7;
	Fri,  1 May 2026 04:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608531;
	bh=+NM3TboCjx9zMokNZj1lQYyUCDXizYcds2lJrXgjfgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgnM87YlXl6u+uSiby63QlCT85KpQZPEkzYWC/p0Fi7GP8mSB2kkoGY5SHfXbAV6T
	 lZCwjYmNG8zHqVP8p+RfiN7sAMiITbRFFGp8b6j35LTW33T+S82ZgRMO6c/PhY0oK2
	 jLxZbLNgebcNe44h1bp2LcdN0048DB7JM3lN4r4TUIfFkpwjz+t83/Fg3rfhbUofmy
	 8n49ss2pWAxUW0Zekt0U8F4xSG5I78hYD9vvIUu0YM/GcunyHlz0v44WEbifppCOaH
	 sQQZhcHYQa09IjtPXtZlTdL3w1WMuqRfMfqO5KSt7jjVu+zlTSHklLmNkc1shvMclO
	 Jn/6HTPRKYRuQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 03/53] objtool/klp: Don't correlate __ADDRESSABLE() symbols
Date: Thu, 30 Apr 2026 21:07:51 -0700
Message-ID: <8e69c287bd6c33cec1535228e2239b33f4602bc6.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 354404AA0CE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2621-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Symbols created by __ADDRESSABLE() are only used to convince the
toolchain not to optimize out the referenced symbol.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index cb26c1c92a74..36753eeba58c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -352,6 +352,15 @@ static bool is_special_section_aux(struct section *sec)
 	return false;
 }
 
+/*
+ * Symbols created by ___ADDRESSABLE() are only used to convince the toolchain
+ * not to optimize out the referenced symbol.
+ */
+static bool is_addressable_sym(struct symbol *sym)
+{
+	return !strcmp(sym->sec->name, ".discard.addressable");
+}
+
 /*
  * These symbols should never be correlated, so their local patched versions
  * are used instead of linking to the originals.
@@ -365,6 +374,7 @@ static bool dont_correlate(struct symbol *sym)
 	       is_uncorrelated_static_local(sym) ||
 	       is_clang_tmp_label(sym) ||
 	       is_string_sec(sym->sec) ||
+	       is_addressable_sym(sym) ||
 	       is_special_section(sym->sec) ||
 	       is_special_section_aux(sym->sec) ||
 	       strstarts(sym->name, "__initcall__");
-- 
2.53.0


