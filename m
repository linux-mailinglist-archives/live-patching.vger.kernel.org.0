Return-Path: <live-patching+bounces-2784-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WK7dIInzA2rKBAIAu9opvQ
	(envelope-from <live-patching+bounces-2784-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:44:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D4D52CEDA
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68A18313C57D
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F713ACF13;
	Wed, 13 May 2026 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMiWyLW6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AED3ACEE6;
	Wed, 13 May 2026 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643292; cv=none; b=KUVOsBTKOuGqaFI5Py3iL6n0dfYmOAMkeOdZORwl1+eCRe07h0qSdIjRcqiD7i65X2isKdEL5EzgoztbODXeFgQnGmLV4D/7sHbadDvtyAJNQlx5hhM/ZkEquXGeiAxgrnIdbXWHgftIwsZ+9cP+vAAiWJs7NTeOMEdQ2pp4kNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643292; c=relaxed/simple;
	bh=ODGizz8YbR/8nDzbjCn/eHHTqaD5XRXQRwu11kVeY3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4VOohZPeV0bEloJPim2mFlluxcjN5sruqPu/mOUvjfYlUuCn91bEUa2+3a+u6RzpPPHfbxrsvzfq9w6zt+exfa6VkLSZFlyCcwn2HUmvP6UspfjW2a1V8XyvpiqlPK8rXIBmE2txXJFTjnCocGql2LBZyV4h1fxkFhwgs8R2Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMiWyLW6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E053C4AF0D;
	Wed, 13 May 2026 03:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643292;
	bh=ODGizz8YbR/8nDzbjCn/eHHTqaD5XRXQRwu11kVeY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMiWyLW60yMaQJRFMpFsG2x/tYVDBFTC+RFGW45F8KIzNe2h+qEU9EgK47Hgoa3Fw
	 MfVnKXDYigAxRRB2T/b5/2dHIOwhc6wvf4gl2kPaBX7RUfnCUC+zTOOc24muOOYSIN
	 NL4BK7F6laycDe1cjhVmqVINhc38hYamVZCmJ6Hr1evmtXLCQ0h7rJ0aK6jMuOyF6T
	 5VIz0vmzb/3Zx9X8/spdwfZCvzZOktZPjURrYf/1caKVzIvNmz7t1arPN9hNrq6YA1
	 9lTZjIDLbtoSMnz1wpzu388doH28MFD37/AqGU28ooyHktzTHMlw00tDUvZ518eWdl
	 SEESt7o85No6Q==
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
Subject: [PATCH v3 11/21] objtool: Allow empty alternatives
Date: Tue, 12 May 2026 20:34:07 -0700
Message-ID: <3c474673ec5ddc9f27fbf5ddb1fd0f66ef6a779f.1778642120.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 23D4D52CEDA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2784-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

arm64 can have empty alternatives, which are effectively no-ops.  Ignore
them.  While at it, fix a memory leak.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 73451aef68029..e05dc7a93dc1e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1953,6 +1953,9 @@ static int add_special_section_alts(struct objtool_file *file)
 
 	list_for_each_entry_safe(special_alt, tmp, &special_alts, list) {
 
+		if (special_alt->group && !special_alt->orig_len)
+			goto next;
+
 		orig_insn = find_insn(file, special_alt->orig_sec,
 				      special_alt->orig_off);
 		if (!orig_insn) {
@@ -1973,10 +1976,6 @@ static int add_special_section_alts(struct objtool_file *file)
 		}
 
 		if (special_alt->group) {
-			if (!special_alt->orig_len) {
-				ERROR_INSN(orig_insn, "empty alternative entry");
-				continue;
-			}
 
 			if (handle_group_alt(file, special_alt, orig_insn, &new_insn))
 				return -1;
@@ -2014,6 +2013,7 @@ static int add_special_section_alts(struct objtool_file *file)
 			a->next = alt;
 		}
 
+next:
 		list_del(&special_alt->list);
 		free(special_alt);
 	}
-- 
2.53.0


