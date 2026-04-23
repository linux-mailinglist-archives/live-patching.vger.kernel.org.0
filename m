Return-Path: <live-patching+bounces-2440-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qM+sA9Ca6Wm0egIAu9opvQ
	(envelope-from <live-patching+bounces-2440-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:06:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A601244CB29
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 86762301E00E
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0EE3D47B3;
	Thu, 23 Apr 2026 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Opm85S3x"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9ED3D47AB;
	Thu, 23 Apr 2026 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917070; cv=none; b=BZ1/9zAF+GwErjLF7NoaVoJmRZZZ6XiVvnUkbo0RAw7+yzBF0JeaKf3g7MjGRtFWdIIJMmiqOmF/TZBIrDtsvYvSml++6+eTyijNIyuTfoD9R2oCtIXqa3kABLFVosi/Fi474XXpil0vrCM1tx/9ore5CYkWriNRDCOjQqgLHK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917070; c=relaxed/simple;
	bh=HBm3BUQmvyMpEmGdKmvIPMG0lJthm5R/bEW+RgXKsQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az1x0Bgshl88cjPvqENb0nKkuuzHxSY+m1TqTGBYXoZeNLJS3z3hpTgPB/AGEUbX/2inuw9te+HRCtafLSbouKWAR0FiIvCL4Isd3CNGhEAzaJET/k1+5o9Gt4Off2FOB4AQ4Dp31CosUI5PAthKo19G2cwEQo0Qd9RAEALqAa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Opm85S3x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D0FC2BCB9;
	Thu, 23 Apr 2026 04:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917070;
	bh=HBm3BUQmvyMpEmGdKmvIPMG0lJthm5R/bEW+RgXKsQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Opm85S3xGgAbExPKOaEG7DU0K0CYzHt5DwdMtnKR6AJ6gftBWns6VB1JmPHmbN1AJ
	 cZtUxhmoMk2BUSpt7Bk5yvzHQeveVh2SYYWNOZovfO0Ge2yakp1Om8GsTYh6wzOGLG
	 ZZzx/9nd76v85jxJP7W9sWuCDKI1bsuHfzx3i8F/sxNKxPoFBP4zyuUvyAs9VN6XXN
	 BekyLFlC8A3LnlocPQZwzIwatyX3uJ3DlcEPZil69S5YnW/onDwkluDrP2G9uw9tC0
	 1Oh7s/uR1p+4s4NK8qJGGgjdDVuuSZ60ct7Avatf0SMAXfn2WwoeDLUoTKJbBCwY90
	 8jIWaNooQZePA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 13/48] objtool/klp: Fix XXH3 state memory leak
Date: Wed, 22 Apr 2026 21:03:41 -0700
Message-ID: <b998db762616ed3c4972b64a3f64759d39bfe674.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2440-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A601244CB29
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The XXH3 state allocated in checksum_init() is never freed.  Free it in
checksum_finish().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/checksum.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index 7fe21608722a..0bd16fe9168b 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -26,6 +26,7 @@ static inline void checksum_finish(struct symbol *func)
 {
 	if (func && func->csum.state) {
 		func->csum.checksum = XXH3_64bits_digest(func->csum.state);
+		XXH3_freeState(func->csum.state);
 		func->csum.state = NULL;
 	}
 }
-- 
2.53.0


