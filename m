Return-Path: <live-patching+bounces-2448-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oG4gOlOb6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2448-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:08:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A64AF44CB8B
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 70F6630418C2
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660E23D7D65;
	Thu, 23 Apr 2026 04:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2vMUoT/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429603D75D0;
	Thu, 23 Apr 2026 04:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917074; cv=none; b=AbR3Q49d82VKJYRwbN/gVxt/am6RV6gHHDDnj53XCtZrDw88+vmo460f3s4X4nyZCZhgZoukAEp9wD5eUoQ1PA7u3NRW+z7dd9e2moiL2ukrlzF1MpKK7Gali1jkALwuejy8wWWsoR/2E0D5bveJ25DNMatgkUXsThbUsB3Z/KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917074; c=relaxed/simple;
	bh=572VMYMokd1zIrU682srFN53tjx+p2xgs9meRhcLEfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3cs6Ay692S3Xv/ahw2kJHSc5ctdNuG+LGn5EwuVM6IFbrrZRymaNIheygU1DUcSA5CBqkNm1TrkzrBXpa8FToEUK0VBYLLGuTrM+FrH3w7m0LLEFYnx4Z1uCKsQkAFNE9+EcFSEqQZUnnzvEaOE7yGk6j6pb8ZV5ImsM6O0E0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2vMUoT/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF627C2BCC4;
	Thu, 23 Apr 2026 04:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917074;
	bh=572VMYMokd1zIrU682srFN53tjx+p2xgs9meRhcLEfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2vMUoT/ygHTZ1c0ydtEMX99VJrOSpukhi4oZJ/7OQBSTjrkL7VF8maOHCeClCm0r
	 oGM5AxWcakjgFkhNBT4hBjw1cPszcRMppWTbYxYaxggE4TWA1qdV60NnwAXsjDZjn1
	 kzgFIDCnNnwRGLGTN1gvG1ej/n4dnGMavFIoGXT1cAGOQ9FehJnR69VlK5KeQ8F6yZ
	 rFosBMSfhKtJuBECmU3Hxuha6FYbapf0DhZ7qJhVH5TQbZfCv0U8SXUQj3GUBAbRb1
	 W1MDkxjjCj4458guDByxMVzUEOiLFhwAycg7fQXYg2Snxm0eItcmCDbeHr/u43Lqav
	 pBzpmHqs9lOPA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 21/48] klp-build: Validate patch file existence
Date: Wed, 22 Apr 2026 21:03:49 -0700
Message-ID: <66e3edb75bf1924c650bce43835acc2053d1cf1a.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2448-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A64AF44CB8B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Make sure all patch files actually exist.  Otherwise there can be
confusing errors later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index e2f0eb8fdc7f..115f68db49c9 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -157,6 +157,7 @@ process_args() {
 	local short
 	local long
 	local args
+	local patch
 
 	short="hfj:o:vdS:T"
 	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
@@ -235,6 +236,10 @@ process_args() {
 
 	KEEP_TMP="$keep_tmp"
 	PATCHES=("$@")
+
+	for patch in "${PATCHES[@]}"; do
+		[[ -f "$patch" ]] || die "$patch doesn't exist"
+	done
 }
 
 # temporarily disable xtrace for especially verbose code
-- 
2.53.0


