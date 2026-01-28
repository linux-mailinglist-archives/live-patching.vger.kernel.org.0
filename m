Return-Path: <live-patching+bounces-1926-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8MxTHHpieWlhwwEAu9opvQ
	(envelope-from <live-patching+bounces-1926-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 28 Jan 2026 02:12:26 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAA59BD22
	for <lists+live-patching@lfdr.de>; Wed, 28 Jan 2026 02:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D073A30157D4
	for <lists+live-patching@lfdr.de>; Wed, 28 Jan 2026 01:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE1D21FF3B;
	Wed, 28 Jan 2026 01:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skFDH2fo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13D2AF1B;
	Wed, 28 Jan 2026 01:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769562743; cv=none; b=Uy+Vd/Smloco0Z1Y5n4bd3E147wItLyXJTPi2jtTlGj0lM3uf86BMfdPxGFovtFjFONG5e9At3Aoh69BpUn7pZ/wG5O1c6ZuyPGffJ6gbmphIudQAuArXWjUX+ligsY6wrGQlEn2g7EeRycGgN3cqLXN2qjyc65b3TJF2rS9eVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769562743; c=relaxed/simple;
	bh=UEJXIZMsH10Cg+xO60A3AVRA7J3r+cgOz9a+hlXOqnw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ppveHKukVwlie696isxkWFVhCb5LSgX9e9Y39VE4LoNv4R+6QMObFwybBsDoIWSUEj3E1j4nHy21aFoGfw4aBugexhEMbtEhtOHSZJk0HdHhXiRw0OLdHEMRAhnzYR3gMSxTTU9EoL2LuGTh7HFRZBhLxA5QMXHal0BeCi4oa6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skFDH2fo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C0DC116C6;
	Wed, 28 Jan 2026 01:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769562743;
	bh=UEJXIZMsH10Cg+xO60A3AVRA7J3r+cgOz9a+hlXOqnw=;
	h=From:To:Cc:Subject:Date:From;
	b=skFDH2fo2TAJ2bfu20lEP4/A6gd7jt+wdz8vnHaecc/GPB6GJrBli5wE3PullIP8M
	 DpOSVtJApa39av36iOwFpgi//856h48IlsnJe6bsJi3Z+xmw7uiJ6foB7KJm8cKJ9o
	 a5skNv9ZDi18Q0GjKFr4I7vCeJDZwKtHTdGu3XUgdL/LU+wXqrH+CvVuWXsu6vjoxK
	 EihXpQHVHadweD4J+l2WgvpVxmeCco0a3tdosDB5L56YNZotatcLOFfgY6Wt4v66jU
	 DEB9Ssv0M/3yKB1o6xZVAqRwA4yf/m5cGMJCGLZtjFuBhjKPggCEubuP0qwQbwaJgu
	 f91K6kdl//7iw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Breno Leitao <leitao@debian.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>
Subject: [PATCH] livepatch/klp-build: Require Clang assembler >= 20
Date: Tue, 27 Jan 2026 17:12:05 -0800
Message-ID: <957fd52e375d0e2cfa3ac729160da995084a7f5e.1769562556.git.jpoimboe@kernel.org>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1926-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: DBAA59BD22
X-Rspamd-Action: no action

Some special sections specify their ELF section entsize, for example:

  .pushsection section, "M", @progbits, 8

The entsize (8 in this example) is needed by objtool klp-diff for
extracting individual entries.

Clang assembler versions older than 20 silently ignore the above
construct and set entsize to 0, resulting in the following error:

  .discard.annotate_data: missing special section entsize or annotations

Add a klp-build check to prevent the use of Clang assembler versions
prior to 20.

Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for generating livepatch modules")
Reported-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
For tip/objtool/urgent.

 scripts/livepatch/klp-build | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index a73515a82272..809e198a561d 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -249,6 +249,10 @@ validate_config() {
 	[[ -v CONFIG_GCC_PLUGIN_RANDSTRUCT ]] &&	\
 		die "kernel option 'CONFIG_GCC_PLUGIN_RANDSTRUCT' not supported"
 
+	[[ -v CONFIG_AS_IS_LLVM ]] &&				\
+		[[ "$CONFIG_AS_VERSION" -lt 200000 ]] &&	\
+		die "Clang assembler version < 20 not supported"
+
 	return 0
 }
 
-- 
2.52.0


