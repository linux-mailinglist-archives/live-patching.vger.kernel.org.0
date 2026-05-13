Return-Path: <live-patching+bounces-2765-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ML+2LKnxA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2765-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:36:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B0252CCCC
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E84930C7535
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269DF3A5E66;
	Wed, 13 May 2026 03:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N69tE3GM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E8339AD32;
	Wed, 13 May 2026 03:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643281; cv=none; b=TBvJycGrwm4F+whgYxuiJonSPlb75/UMbw3F2jxCxQZubB8wypY3KpbWSngwSQCoTApoTAcNdmsGD3izhMAwT86smh/8KXqj9SWTh8+5V8dapvRUH9FoX1pbiQBs7E6NoCms1vY+/2n4gerSTObF4k+IBl/0bnc+2hQiUSjiZaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643281; c=relaxed/simple;
	bh=y8OlQ2u+RBKl5+g5VAi278HKoC71kQ9CG5Kwq0UXfOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM1jJzkX1Grc7EtuNU/uu9YAtKVYJD+Me5LGihwCaEZzjJDpmDT0LqDSZY8AMl0fDQutU4vslK3qiFKBgUryKpopuAyKI9pnHF6Uj1DcItQoU2lAddDgVEXJ+aC5TMO3dtX/Oj3xpPd0dkSCoozW0LsyFaAmnibYLlkvfeIxaU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N69tE3GM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCB0C2BCC9;
	Wed, 13 May 2026 03:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643280;
	bh=y8OlQ2u+RBKl5+g5VAi278HKoC71kQ9CG5Kwq0UXfOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N69tE3GMovJzMPOd8iBy8ZvldlfJ/pvSh5RBikos9xuV+s1/rJmWPtbsZV7vYKLGW
	 S/3TtZL+vGbmLWA29QlR+qE+6AUfz7zPJ5r1K0lnwZOlFSQtkjqnJQ/pqW0IoPpJZ1
	 guRw87L52HGk2leR7vcx0gJhwUtstnbmsfhJkeKnvdAkCHxZmihZ7yQ7IKgpyljnAA
	 bH0R/jby/qxP3AQUmphNILHNzLe5ySMMRwjPnFelNfp/rvmpIkpsnOCpiNY8eQqtTq
	 5jIE3oVuW+VN3IpLUvcTqjEy25JwF00zb/w/fg0I6e41t3yC6mnMxpW4guIe6LknJZ
	 8rvjlxh5EO7JQ==
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
Subject: [PATCH v3 17/21] objtool/klp: Don't correlate arm64 mapping symbols
Date: Tue, 12 May 2026 20:33:51 -0700
Message-ID: <48efc64058f667159d3dedf367c1d4cdedf84f1c.1778642120.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 50B0252CCCC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2765-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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

ARM64 ELF files contain mapping symbols ($d, $x, $a, etc.) which mark
transitions between code and data.  There are thousands of them per
object file, all sharing the same few names.

They aren't "real" symbols so there's no need to correlate them.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index eb21f3bf3120b..e1d4d94c9d77c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -501,6 +501,7 @@ static bool dont_correlate(struct symbol *sym)
 	       is_prefix_func(sym) ||
 	       is_uncorrelated_static_local(sym) ||
 	       is_local_label(sym) ||
+	       is_mapping_sym(sym) ||
 	       is_string_sec(sym->sec) ||
 	       is_anonymous_rodata(sym) ||
 	       is_initcall_sym(sym) ||
-- 
2.53.0


