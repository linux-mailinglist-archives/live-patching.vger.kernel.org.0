Return-Path: <live-patching+bounces-539-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89EF4969272
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33D671F235B5
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FA71CEAA8;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbrlWp1T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08221CE715;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336031; cv=none; b=fzf/grGLr3VDQKc+GRSiTJFyUNyhHHIW35l31wLXRHlYVAUiIU/ZGj9xeMii14B8Unje6bhvxR8CofOJx3zBsOlsgc0aIPd0zCFEWd5YE+7d0/F50mBTuA0HIZfWOebvJAcfIuMqPyaeWShX/2V3MGpApZ099EHfUGYvIJDHCew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336031; c=relaxed/simple;
	bh=q2M88CS52CpmfIl0QNGMiagRm1TTYcO/UMxEQqGVUOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYnH/YhuItZKdok6O1jigq82nUUaotjhvXP3eS+/7Y3z8utT5mnmkXlmpRE5WEvaiy1+VAWw4PTxbZalNlK+/2T5VI3PCtfynuIQpu98gS2Px3wx0QfZX3pH8dlmG8G5boFG7msC7TEixAd3V2SscP1gWHqyNbEgIvBQJGXDZpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbrlWp1T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAD8C4CECD;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336031;
	bh=q2M88CS52CpmfIl0QNGMiagRm1TTYcO/UMxEQqGVUOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbrlWp1TIJRiFfNFQbeCJ0wH21WhFV2v9bMa/lVC0IV4PutiC8o6MFSy+VmF6zV3r
	 nUtGET+Incg0B141jBW7RFW0tVvZZhLU/LOd/qil5KbrZQ918v5tXsP1tKOo6+PcKD
	 CROZwCaQ5nzqAOZ8RJF7go9GGddUKlE+5pko0k5NIevXwz7MHnocXGNh36piMdij8f
	 IQteoBOdA3Gn/9HG9Joon4YxRsvy/RV9xqBq32ry9djAapUBRQHPpDD1qgYv7rafr4
	 t4C/99AS3slIfqWz6M1be2Mn9y7kMethXnH/5esB5yOofkMGFdLSGu4I8xH1qWraX3
	 8CzhHf9UsEujg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 05/31] x86/compiler: Tweak __UNIQUE_ID naming
Date: Mon,  2 Sep 2024 20:59:48 -0700
Message-ID: <d8d876dcd1d76c667a4449f4673104669480c08d.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an underscore between the "name" and the counter so tooling can
distinguish between the non-unique and unique portions of the symbol
name.

This will come in handy for "objtool klp diff".

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/compiler.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8c252e073bd8..d3f100821d45 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -186,7 +186,11 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	__asm__ ("" : "=r" (var) : "0" (var))
 #endif
 
-#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+/* Format: __UNIQUE_ID_<name>_<__COUNTER__> */
+#define __UNIQUE_ID(name)					\
+	__PASTE(__UNIQUE_ID_,					\
+	__PASTE(name,						\
+	__PASTE(_, __COUNTER__)))
 
 /**
  * data_race - mark an expression as containing intentional data races
@@ -218,7 +222,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
  */
 #define ___ADDRESSABLE(sym, __attrs) \
 	static void * __used __attrs \
-	__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)(uintptr_t)&sym;
+	__UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
 
-- 
2.45.2


