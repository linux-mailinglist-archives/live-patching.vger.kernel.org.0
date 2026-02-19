Return-Path: <live-patching+bounces-2054-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOhoHz+Nl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2054-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:22:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B543F163202
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD9F33015893
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912C332ABD0;
	Thu, 19 Feb 2026 22:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5tBp0kH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D261325729
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539771; cv=none; b=Ti+gpXF6KF6wKEqMNd+n6SbvCuqxhKlTmaaKw1EaA6s9w2VCXcOeOXFDw7WSZehCMnF6iatv1F1CsM3K8SWPrzGkmbA+qOr8ISN8YxrJQR+W/aP+Q3dHh+1WkmccdivNudqTnz4QCJvbCP55WFeJh4yMG8jYH58uYkQq+XMKSL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539771; c=relaxed/simple;
	bh=NF985SuSmn9wmB4vLhm1ef1RmrUrWhw45OEe/IaMNFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfMpbOUwrMCDF6/EGpdt5WVhE+fq3Pnn1QlAV7U5q4EFFiMbmJlXzDhewJhSQoZg7F+U4N6CHjyIUK4QfRFWbPL9O3iSeXcQNdRlkzMmRLH5SQYJ4YflypP5RnTb42jYNJc45YAWhTyu7Sl8WILnDUWN5H5X2rCQatR2TVRBhpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5tBp0kH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01767C4CEF7;
	Thu, 19 Feb 2026 22:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539771;
	bh=NF985SuSmn9wmB4vLhm1ef1RmrUrWhw45OEe/IaMNFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5tBp0kHM+HLUIonxopO5pKAmGIv2XbxWY/N3Di45DynsPb4hdB8mduSUTqSGn3lf
	 mAFVz7ceOvdIt28bi3HPBTyPZwQ/q/NJC6UScDwuOOgGZ+cJ47VXVA0eMIYyLQPTsz
	 1HHq3v3eqB7w/flQGsYmkVLAob7p34qvvuwBq2/LOKYMtivxm7yvL97tOzhT9HH0Zm
	 4FtucRcDizPsx0BRaNG4xyelT+g4LPjykcchPBRprFOUeVXFYAIm2ZQ6hwh+eQeEu+
	 PUXzYe6Sz9eXkYcGHYKpABE3s0Ruep8ajyhzUmG2kJIqtHgQyY6O5Sh1Rb1pFCIrRz
	 GNtknEOyBxBZA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 1/8] objtool/klp: Remove redundent strcmp in correlate_symbols
Date: Thu, 19 Feb 2026 14:22:32 -0800
Message-ID: <20260219222239.3650400-2-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219222239.3650400-1-song@kernel.org>
References: <20260219222239.3650400-1-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2054-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B543F163202
X-Rspamd-Action: no action

find_global_symbol_by_name() already compares names of the two symbols,
so there is no need to compare them again.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/klp-diff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index a3198a63c2f0..57606bc3390a 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -454,7 +454,7 @@ static int correlate_symbols(struct elfs *e)
 
 		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
 
-		if (sym2 && !sym2->twin && !strcmp(sym1->name, sym2->name)) {
+		if (sym2 && !sym2->twin) {
 			sym1->twin = sym2;
 			sym2->twin = sym1;
 		}
-- 
2.47.3


