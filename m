Return-Path: <live-patching+bounces-1633-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D79E3B4AC18
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 13:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A907C1B24ABF
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 11:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D163277AA;
	Tue,  9 Sep 2025 11:31:13 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C542332252E;
	Tue,  9 Sep 2025 11:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417473; cv=none; b=iidnC/O5mAGj4y1AiupjQppn/DBvBOaXB6cpkhS9nKR5YG2k7Mk09TDNpDjrD8zBBWxQRjvsuZoN9HWuJnVqhTgO3SknRJAriY2Zq2F4UXJp6z2St3ohmH/D2tDqJ3l/30BCxicjuabH3MyIVpSh+3L+/QoBLAcQ2TNifjnPs8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417473; c=relaxed/simple;
	bh=g35X596naWjYRJ4mQIhiO8ELMlH7T3GzYKcqBdox2Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/1G7yZ4OaITQ7jqvwufU/P0hY/icF4kLdLrSM3kVIhubDmpUq2bPuuIYKYfl8Z2MiK0k2BPVT5LQ+9FXgPdQfCRoVTE6RS6+iXfR1cLqSYgyoZ6nYpOlCQ5DVhnp+1r8N5Ql5OMgdlCaWaJ4IdYPoRVkdQIdCsB+C1draZQ+No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8Bxnr_8D8BotloIAA--.16653S3;
	Tue, 09 Sep 2025 19:31:08 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxjcH7D8BoviGKAA--.57546S3;
	Tue, 09 Sep 2025 19:31:08 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Zhang <zhangxi@kylinos.cn>,
	live-patching@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] livepatch: Add config LIVEPATCH_DEBUG to get debug information
Date: Tue,  9 Sep 2025 19:31:05 +0800
Message-ID: <20250909113106.22992-2-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20250909113106.22992-1-yangtiezhu@loongson.cn>
References: <20250909113106.22992-1-yangtiezhu@loongson.cn>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcH7D8BoviGKAA--.57546S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Ar13uw1xWw47KFy3tr4UZFc_yoW8XrWrpw
	s8GF98tw4kJFyY93ZFk3yxuFy5W397G3y3Ja93u3s5XrZ8X34YqF4ktr12v3yUXrn5K3Wa
	qr97WF1jqFyrArcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_
	JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
	UjIFyTuYvjxU466zUUUUU

Add config LIVEPATCH_DEBUG and define DEBUG if CONFIG_LIVEPATCH_DEBUG
is set, then pr_debug() can print a debug level message, it is a easy
way to get debug information without dynamic debugging.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 kernel/livepatch/Kconfig      | 8 ++++++++
 kernel/livepatch/transition.c | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 53d51ed619a3..4843665b1939 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -18,3 +18,11 @@ config LIVEPATCH
 	  module uses the interface provided by this option to register
 	  a patch, causing calls to patched functions to be redirected
 	  to new function code contained in the patch module.
+
+config LIVEPATCH_DEBUG
+	bool "Kernel Live Patching debug"
+	depends on LIVEPATCH
+	help
+	  Say Y here to print a debug level message with pr_debug() for
+	  the Kernel Live Patching code, it is a easy way to get debug
+	  information without dynamic debugging.
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 2351a19ac2a9..0ab3e5684680 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -5,6 +5,10 @@
  * Copyright (C) 2015-2016 Josh Poimboeuf <jpoimboe@redhat.com>
  */
 
+#ifdef CONFIG_LIVEPATCH_DEBUG
+#define DEBUG
+#endif
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cpu.h>
-- 
2.42.0


