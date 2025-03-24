Return-Path: <live-patching+bounces-1319-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CABA7A6E109
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 18:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9863C1892FB6
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 17:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31AF266F0A;
	Mon, 24 Mar 2025 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTLmt0U0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE82266F01;
	Mon, 24 Mar 2025 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837590; cv=none; b=c1vRnO051NTBUxyru4cco7QfQ0vXjerm0ojkPxCg4URZW9nSg1iSyl7vcBTlsmqNaWpNwPfYoGezRkLoqH0C2XA2/SdhRMQu6Jt9zgv5ImAWRltFs3hz9zslVDFo7w3dQ4Qaj7uJaLO+dM87cEd0BfeSalk6KS09eq+veL/ESO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837590; c=relaxed/simple;
	bh=6z1jVV/yKXBtpI1jJEON4mBcVHyI6frM0d76FlbA/Cc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iPvkWdYZmedSlKljKtscit7VkqrGVns9WDhP/pbTx0R7hZwq4ovl+dannSa95Eat88VI27koedLoClZuf/SUOExkoy3SLPiIjngziPYucGgFQRyJO1lTOXDfrp9kjrYCxJ0/ed1pqyEJf1AnRvCtJrPkFZGHHZubxCsO5Nbh0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTLmt0U0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3094EC4CEED;
	Mon, 24 Mar 2025 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742837590;
	bh=6z1jVV/yKXBtpI1jJEON4mBcVHyI6frM0d76FlbA/Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTLmt0U0lb/WjNY3npIyMTIsK0uZkYSq5v4j3ttcma+yWik+b8gfSyRnC0SudDq1c
	 lleOlzWq4F814O3jZPPFKDz9Guw8uzqcYKThypwFesTCb9NX9TJ+gxECoA9JDx6mBn
	 m57z8frYgyQv0rLXGwagCrbZo4JcPGK5EA9L5hbrpYJ45TX+THcOmoXIIiChrcFF62
	 /Pr9wXdZbYfZcGliCKARwh4ycVJtUOTz1BPu8E8wI8dMTQm+AVlsLnLasBiC8Diq39
	 fF4MV1ew7is8TOnR+Yod+WNklpqmS9YWh7lvrch5zKMavSn5YavlOEENonT8End3vs
	 FdLiawokJYNvg==
From: Arnd Bergmann <arnd@kernel.org>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] samples/livepatch: add module descriptions
Date: Mon, 24 Mar 2025 18:32:28 +0100
Message-Id: <20250324173242.1501003-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250324173242.1501003-1-arnd@kernel.org>
References: <20250324173242.1501003-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Every module should have a description, so add one for each of these modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 samples/livepatch/livepatch-callbacks-busymod.c | 1 +
 samples/livepatch/livepatch-callbacks-demo.c    | 1 +
 samples/livepatch/livepatch-callbacks-mod.c     | 1 +
 samples/livepatch/livepatch-sample.c            | 1 +
 samples/livepatch/livepatch-shadow-fix1.c       | 1 +
 samples/livepatch/livepatch-shadow-fix2.c       | 1 +
 6 files changed, 6 insertions(+)

diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
index 69105596e72e..4d6030739fcb 100644
--- a/samples/livepatch/livepatch-callbacks-busymod.c
+++ b/samples/livepatch/livepatch-callbacks-busymod.c
@@ -56,4 +56,5 @@ static void livepatch_callbacks_mod_exit(void)
 
 module_init(livepatch_callbacks_mod_init);
 module_exit(livepatch_callbacks_mod_exit);
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
 MODULE_LICENSE("GPL");
diff --git a/samples/livepatch/livepatch-callbacks-demo.c b/samples/livepatch/livepatch-callbacks-demo.c
index 11c3f4357812..9e69d9caed25 100644
--- a/samples/livepatch/livepatch-callbacks-demo.c
+++ b/samples/livepatch/livepatch-callbacks-demo.c
@@ -192,5 +192,6 @@ static void livepatch_callbacks_demo_exit(void)
 
 module_init(livepatch_callbacks_demo_init);
 module_exit(livepatch_callbacks_demo_exit);
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-callbacks-mod.c b/samples/livepatch/livepatch-callbacks-mod.c
index 2a074f422a51..d1851b471ad9 100644
--- a/samples/livepatch/livepatch-callbacks-mod.c
+++ b/samples/livepatch/livepatch-callbacks-mod.c
@@ -38,4 +38,5 @@ static void livepatch_callbacks_mod_exit(void)
 
 module_init(livepatch_callbacks_mod_init);
 module_exit(livepatch_callbacks_mod_exit);
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");
 MODULE_LICENSE("GPL");
diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index cd76d7ebe598..5263a2f31c48 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -66,5 +66,6 @@ static void livepatch_exit(void)
 
 module_init(livepatch_init);
 module_exit(livepatch_exit);
+MODULE_DESCRIPTION("Kernel Live Patching Sample Module");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index f3f153895d6c..cbf68ca40097 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -168,5 +168,6 @@ static void livepatch_shadow_fix1_exit(void)
 
 module_init(livepatch_shadow_fix1_init);
 module_exit(livepatch_shadow_fix1_exit);
+MODULE_DESCRIPTION("Live patching demo for shadow variables");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 361046a4f10c..b99122cb221f 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -128,5 +128,6 @@ static void livepatch_shadow_fix2_exit(void)
 
 module_init(livepatch_shadow_fix2_init);
 module_exit(livepatch_shadow_fix2_exit);
+MODULE_DESCRIPTION("Live patching demo for shadow variables");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
-- 
2.39.5


