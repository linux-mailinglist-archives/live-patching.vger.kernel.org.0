Return-Path: <live-patching+bounces-2081-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKEiB9mZn2mucwQAu9opvQ
	(envelope-from <live-patching+bounces-2081-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:54:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F4819FA51
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:54:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1C31C302DA9E
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 00:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A861F12E9;
	Thu, 26 Feb 2026 00:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsOsiZdI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C067081F
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772067287; cv=none; b=TXcc+8oNQtEOAeXD/MftzkmS84fLEeOycdCcTDda0xwr5CjpPKicKU7MDqIQOCgpSwLxxXKkc+WnpVQe1kUxHAYZQ5GxsVX+vFoP4GWvJzs33bM7bTn4oIan4oDTWTAfcv1CzzQaaGt/4upzcBrwJXiGaOAKF4g/zBFbzkM/YT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772067287; c=relaxed/simple;
	bh=NF985SuSmn9wmB4vLhm1ef1RmrUrWhw45OEe/IaMNFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eICLEGvn19Jnh48/O0Dn5k79TyZGyQ4a8NDiEHg00ircAiNJ9D9tbMX2PBcLehBPhTYKFhCElxvsIPOnCBeJYN3TTtEqYf0edaihi3pWstPATbNBhELU/Sta+em2QFNln9wAObS5GU6lFlM9sbiz8DkSX4dfkITcIH2wOkHL7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsOsiZdI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C858C116D0;
	Thu, 26 Feb 2026 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067286;
	bh=NF985SuSmn9wmB4vLhm1ef1RmrUrWhw45OEe/IaMNFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsOsiZdIIwQekM53lAHNcojR//8VEi3957zQeRRk7epwtTwBwZAnPctaqB8J2uYj8
	 iJVzdWtqlIzcQ7z9eLlw/t/u1hexP+Ia3WQj4m2oweTq06Nj2CyFap0rzK1ZdUl8Tl
	 Xm/H8CxeeVbeQ+0+8ftJs3Yzd2yByC/Kjqh5VXKKhCnK12GxwMAwa3+2WpGab+oSup
	 CoKTZcV4EigE9rqAfbqoqdxHsYmK75WT3G4RQifbTklIrIm3z+gXsjcUuJdLOceMes
	 zaESATDj0IbOzMkL+ALHDLxSGfd10jmOqp7Zgkr8mgWe6wObvOUTe6RmW4mZeZHoPb
	 oH00VXFjusOcw==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v3 1/8] objtool/klp: Remove redundent strcmp in correlate_symbols
Date: Wed, 25 Feb 2026 16:54:29 -0800
Message-ID: <20260226005436.379303-2-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226005436.379303-1-song@kernel.org>
References: <20260226005436.379303-1-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2081-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B0F4819FA51
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


