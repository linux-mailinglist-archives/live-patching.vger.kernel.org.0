Return-Path: <live-patching+bounces-2789-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPwlHjTzA2qrBAIAu9opvQ
	(envelope-from <live-patching+bounces-2789-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:42:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4EE52CE6A
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E6254307809F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5D93B0AD0;
	Wed, 13 May 2026 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwaaG1Fw"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2693A8736;
	Wed, 13 May 2026 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643296; cv=none; b=KAsY4NT4TvdjINGwWXEzzGLb6D/L282QfaEQPCfIFvv1g0PmVK0tWEAVffJ46WoEvg2MSprX+4y7ZkcDnIMkWbhtH2lYxx2L3U2DcSE14tPSX0/OQTPCbipnwmmXHWq8cNwkcAEdmrowm4ZLpQCaeAsJO6bunDJcDAI60SQctlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643296; c=relaxed/simple;
	bh=y8OlQ2u+RBKl5+g5VAi278HKoC71kQ9CG5Kwq0UXfOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2dfnWY6WI7aXE19oxizSDpMwQ9kRmE0j+sYjIcNnm823sXVHUj9T1oOj9Zoa4fkA8RwHOX/kOB0PiiGbxqJXtfMQEeI3q8VTwCFbh29J0LK0nV7W7X/H0WTFPuOeAXpom7suTlLYXi2hV0ymf9h91CDGvLENP+9Bjj47L1L2Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwaaG1Fw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE57CC2BCFB;
	Wed, 13 May 2026 03:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643296;
	bh=y8OlQ2u+RBKl5+g5VAi278HKoC71kQ9CG5Kwq0UXfOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwaaG1FwksSjtDGCqBBb30zlrP/Lef2E9lzbretHPg3Z7pj2aog6WKYOLLmBsLzKD
	 1RPlSv93beMtMc4YALNhn/nDaxftFgw27pnB7QpPBonygYQr5XqMoshADSOXoNdVSX
	 8cWdSSDV/0OIJeQVInQMPLrgdQxys0/h5U2vCW0uGz+QYfzYPEmjV4b2vUKImyJVEs
	 vIbVk61qcKWrogRX+NOMgmE+Xvj+ypo+kb6IrcK5igDjuNvKobRFDkn9XmUwoHdh+o
	 nvooKYJaq4fYolQAx1bHfX1JA05hAGrwO/X0g9ywfafSI3cXL6SRa+FMhtqE5j2JlB
	 vIPcIzkI5dbtw==
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
Date: Tue, 12 May 2026 20:34:13 -0700
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
X-Rspamd-Queue-Id: BA4EE52CE6A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2789-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
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


