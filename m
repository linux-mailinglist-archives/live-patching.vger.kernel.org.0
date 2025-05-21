Return-Path: <live-patching+bounces-1446-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 106E1ABF275
	for <lists+live-patching@lfdr.de>; Wed, 21 May 2025 13:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54A631B60B2E
	for <lists+live-patching@lfdr.de>; Wed, 21 May 2025 11:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89ABE2609D0;
	Wed, 21 May 2025 11:10:15 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86FD259C8A;
	Wed, 21 May 2025 11:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825815; cv=none; b=tSpMvuv9OXr0/77l2Rzv/Dpsp3fhvD+mrq0qtIEyhgo+7Wb+V3cnCG+GMpiBKel+G8ntSKnI5ULP7fgTydC5ETacPn0xu0NMM3e/mhkOt0bjubslgcqIcHP9aO69zFOuRM7mVX+bBACWxlpPlYkwFLtnx7bysaNMdWAkRyXFM8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825815; c=relaxed/simple;
	bh=t84jY8EW1u1kcNlMu1EhGlrTtqNqZWOz4Kds5scKVDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ov7m0+KFojzd0ZsZdiOwc35Vw5YjwnKnv6CaUdlQaDz5znfCdPsIb1KHVPBH6dAA2kfxEkUXoc7dkvnW5JZL5Z/G+Mc5Ue9GtIeHPlyotEWifEs25yrdH6SOEiaRLsGl0Namae328yoL/TJMWY/34gZL4wg60kmMEo5W1WoelA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70C5725E4;
	Wed, 21 May 2025 04:09:59 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 294FC3F6A8;
	Wed, 21 May 2025 04:10:11 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: andrea.porta@suse.com,
	catalin.marinas@arm.com,
	jpoimboe@kernel.org,
	leitao@debian.org,
	linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org,
	mark.rutland@arm.com,
	mbenes@suse.cz,
	pmladek@suse.com,
	song@kernel.org,
	will@kernel.org
Subject: [PATCH 1/2] arm64: stacktrace: Check kretprobe_find_ret_addr() return value
Date: Wed, 21 May 2025 12:09:59 +0100
Message-Id: <20250521111000.2237470-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250521111000.2237470-1-mark.rutland@arm.com>
References: <20250521111000.2237470-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kretprobe_find_ret_addr() fails to find the original return address,
it returns 0. Check for this case so that a reliable stacktrace won't
silently ignore it.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrea della Porta <andrea.porta@suse.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1d9d51d7627fd..f6494c0942144 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -152,6 +152,8 @@ kunwind_recover_return_address(struct kunwind_state *state)
 		orig_pc = kretprobe_find_ret_addr(state->task,
 						  (void *)state->common.fp,
 						  &state->kr_cur);
+		if (!orig_pc)
+			return -EINVAL;
 		state->common.pc = orig_pc;
 		state->flags.kretprobe = 1;
 	}
-- 
2.30.2


