Return-Path: <live-patching+bounces-1574-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 672FAAEAB5E
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F3FF6A15C1
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA66288523;
	Thu, 26 Jun 2025 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aenYQXsQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794852877CD;
	Thu, 26 Jun 2025 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982202; cv=none; b=E6GXM3i2ZRcZV17vfd/WvJFxanKvoWJfsjia8uA2uAPB12vK30HiYXGHcmuhcLKtnyXm/cTx5WIRZjYR9FNeidJ+SrtOo3zQOXJXxDllNlPqPoQgbLgtsilv9Y58NS+c4xbMysh9GSWBkUO5H+EGPt8c6X89eQp0VtVrTYWG8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982202; c=relaxed/simple;
	bh=BWC/EK45R71tNPx18yWCdlmWvFn5ZQ50LPVV0EIh96c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEDbqx9kNowODIbqnfTNSXmq0Rper2+w/5KQy9Jq3J+f7rEqLaKF2xwFPBy9dtdBbxgpivHmmIslvzDxjht0UYopVX1Tc81n6I4SVxXNligs4MUB1/r/rMujkBX5kx+eK+asS82jzglIcLwldYkwSEdLcwxzxhcavB3XVefMDG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aenYQXsQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB65FC4CEEF;
	Thu, 26 Jun 2025 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982202;
	bh=BWC/EK45R71tNPx18yWCdlmWvFn5ZQ50LPVV0EIh96c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aenYQXsQGpTSXBi3k7fY7/qqaGYMod0vuBudCPJyb87jxC8jkqZWLiqmZzyR/Q9te
	 LStbP+ql5FMRCgIro2s5o5658hSMqcrMmIHHMgJXkd5q3+sAHFYvr2hNgwSU4KIvg/
	 Me1NBX5MoNuOMZTN7nylJi8/sJZV8gDkxF9rl0pWnJeB1TaSQSQJ2Md0//SAKgmXx8
	 D/ysCsPZ3kFZO/e536Ne/UhDG0Q5bxpK2IuL5EQMHzE1KFMRdVSInFgRCuKij7lt10
	 TWZb0PaHIu71k6HogLoA61LOZIChliUIdJgvkpOXDxGypDJBCtun/YyQitM5aNHavF
	 R9PBgrtqgMUwg==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 44/64] x86/jump_label: Define ELF section entry size for jump labels
Date: Thu, 26 Jun 2025 16:55:31 -0700
Message-ID: <7217634a8158e56703dfe22199f1b9c08c501ae3.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the objtool klp diff subcommand, define the entry
size for the __jump_table section in its ELF header.  This will allow
tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/jump_label.h | 17 +++++++++++------
 kernel/bounds.c                   |  4 ++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index cd21554b3675..7a6b0e5d85c1 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -12,12 +12,17 @@
 #include <linux/stringify.h>
 #include <linux/types.h>
 
-#define JUMP_TABLE_ENTRY(key, label)			\
-	".pushsection __jump_table,  \"a\"\n\t"		\
-	_ASM_ALIGN "\n\t"				\
-	".long 1b - . \n\t"				\
-	".long " label " - . \n\t"			\
-	_ASM_PTR " " key " - . \n\t"			\
+#ifndef COMPILE_OFFSETS
+#include <generated/bounds.h>
+#endif
+
+#define JUMP_TABLE_ENTRY(key, label)				\
+	".pushsection __jump_table,  \"aM\", @progbits, "	\
+	__stringify(JUMP_ENTRY_SIZE) "\n\t"			\
+	_ASM_ALIGN "\n\t"					\
+	".long 1b - . \n\t"					\
+	".long " label " - . \n\t"				\
+	_ASM_PTR " " key " - . \n\t"				\
 	".popsection \n\t"
 
 /* This macro is also expanded on the Rust side. */
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 02b619eb6106..e4c7ded3dc48 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -13,6 +13,7 @@
 #include <linux/kbuild.h>
 #include <linux/log2.h>
 #include <linux/spinlock_types.h>
+#include <linux/jump_label.h>
 
 int main(void)
 {
@@ -29,6 +30,9 @@ int main(void)
 #else
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
+#endif
+#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)
+	DEFINE(JUMP_ENTRY_SIZE, sizeof(struct jump_entry));
 #endif
 	/* End of constants */
 
-- 
2.49.0


