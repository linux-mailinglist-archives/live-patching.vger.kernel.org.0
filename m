Return-Path: <live-patching+bounces-2652-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QO3vCsIp9GlA+wEAu9opvQ
	(envelope-from <live-patching+bounces-2652-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:19:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7604AA392
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 245EE303AF3C
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2A635E949;
	Fri,  1 May 2026 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dysIFujc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9686C35CB73;
	Fri,  1 May 2026 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608546; cv=none; b=BiN/YRXZTCDx0fFdMlC3t3ZfHqygcaXQrtlHJkEJra8uYyAfUe8sXEfPW/Yc6bQxB5MHd7f07EE4TEcZZ1LjMaKha+whOU/ufXRh6els3dxvi1lCsng+7ZXSUYxDkfeap6TTMf2qI68YhG0jXMG14B8bHBkfTb1VGFbNlnJ9knY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608546; c=relaxed/simple;
	bh=C4H3QYns08OGG+5ZLV30DNEsVqONshg8FePcx0FJUVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o104QYmsiROg8cVtExiYyTYPC3dsFrgHs3WHmLZlOHLLd0z4E0qLGQCBe8HDXz2BHu6no10RpxkbBIj9f7Dkm3Z0Wv8bjQve3cEABTKL5LQEn9hIYVvDGq8+0r8Jmhzv7dLLRWUV29z3Amnr2mlE+Ky5c+cx3Vs2eNXjBJ4GcpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dysIFujc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6E1C2BCC9;
	Fri,  1 May 2026 04:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608544;
	bh=C4H3QYns08OGG+5ZLV30DNEsVqONshg8FePcx0FJUVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dysIFujctdwUPF/HClOO7A7XmGyr14pacL2NKWkeo33su8fDjZHxDmFTIOSsOPmXO
	 8jPZ48JNGj5X0eJDi3iPwMNKImDm/2C/oAOGOtCh5ANz0772gOOE2/fM/E9T0ozSKr
	 cG7qoP+UyPNeVcg2KFryQCd6Ef5443+OkxPnk62QxmWdG8cSO3o3zUtlFXHJz+pqED
	 qsDi2tIrupoy/XYBNet/Y3KvdBlFVclxPfmj4gFDZsp7o0tik9zHr6d/PlGaFOiIoU
	 fxsW8KJW2Zaio3lmigPiY7zI4P4WfWaRn+BQDL46adeStv7IIefblbrEZn7LCe7ZYT
	 bvv013aeLGl1A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 30/53] klp-build: Reject patches to realmode
Date: Thu, 30 Apr 2026 21:08:18 -0700
Message-ID: <aeab7294c81cafe98ff363220fc2815f44c4032b.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: CB7604AA392
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
	TAGGED_FROM(0.00)[bounces-2652-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Realmode code is compiled as a separate 16-bit binary and embedded into
the kernel image via rmpiggy.S.  It can't be livepatched.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index a70d48d98453..2bb35de5db75 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -357,7 +357,7 @@ check_unsupported_patches() {
 
 		for file in "${files[@]}"; do
 			case "$file" in
-				lib/*|*/vdso/*|*.S)
+				lib/*|*/vdso/*|*/realmode/rm/*|*.S)
 					die "${patch}: unsupported patch to $file"
 					;;
 			esac
-- 
2.53.0


