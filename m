Return-Path: <live-patching+bounces-1661-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0B3B80D43
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6539F7B1F88
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98C72F9D89;
	Wed, 17 Sep 2025 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umLEAOgv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8442F9C37;
	Wed, 17 Sep 2025 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125060; cv=none; b=ZotjaHqvS+YpUm25PmuWTzcYYrej7a/nzjsC47KI9JUy0DIjv4utZQn9Co+deH2ScD8qb4k4mImoNab7dNwwoTujH3zInnFiIf5f2LWVJqEWEZc2t2/+5OhdccSIWY3l5OrTa1VbczKSdpo7pZWajiFTg/pKr1ZboBDSu7LzeOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125060; c=relaxed/simple;
	bh=o1BDGEaFZhqOatmgUCrL7E7W4M4+Thr85scjOc3jDPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDh3gU3GrbIVfUld1Ew2h3h0nPb+mRYfiycE2tyNfwZD4hE/KnildeYk8J81+tWuiDx4M+OCeMvURVdSKPv+D9aF4yR8XxKAa+x6S7OIYt5OSzObw4KhHLEdPedVBYXS/pgqM0GG/BKKlu8X9rjPL7bJX0I/TuGxg6fGfTL0754=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umLEAOgv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B31C4CEE7;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125060;
	bh=o1BDGEaFZhqOatmgUCrL7E7W4M4+Thr85scjOc3jDPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umLEAOgvTnvVDy7DIRRt+pFaqGa+8O2ofykQPFjrHZwOpuqAMzs4qKuX32dXCoJDE
	 QP/wCxfcAXGibZHo+OMj2vaxhhx1YbbRX7jzB974g6CHt4ghDrDVghCh6aSzlehcPd
	 2huZoqQkSluTB6utnNeZrUBH2gtLH69tO5D4sABHTrv45LlWpOV94zYk4iwTF5RIRt
	 3QZdd2GQLKt2dKcbyKhGmEii9NXVz3HGOmfQJm2DErET9st14xN24dQAdmoJKhReYh
	 2GM2v2VC8g6run2rAhCwyOnve0sxji3Gx7qp404nMCGZooNu57SA7iv5eRskSH5C7j
	 ZeRdYOFXcuc+A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 06/63] compiler.h: Make addressable symbols less of an eyesore
Date: Wed, 17 Sep 2025 09:03:14 -0700
Message-ID: <adb8d082afa04d07607d38dfcc71c53412117835.1758067942.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid underscore overload by changing:

  __UNIQUE_ID___addressable_loops_per_jiffy_868

to the following:

  __UNIQUE_ID_addressable_loops_per_jiffy_868

This matches the format used by other __UNIQUE_ID()-generated symbols
and improves readability for those who stare at ELF symbol table dumps.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/compiler.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index db5796b8b0a71..9bc690be60675 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -287,7 +287,7 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define ___ADDRESSABLE(sym, __attrs)						\
 	static void * __used __attrs						\
-	__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)(uintptr_t)&sym;
+	__UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;
 
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
-- 
2.50.0


