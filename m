Return-Path: <live-patching+bounces-1363-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C26AB1DD0
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D6F4C6D9A
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7799325F97A;
	Fri,  9 May 2025 20:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZpE/gM0u"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0FB25F971;
	Fri,  9 May 2025 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821867; cv=none; b=aKfYwnvMqRa1iud0KjsiQVcWjuw/r3moxkWzXwEimAeOKIqFvQP1QC5wCR2EyPINHwCRUdgrZL9Wh2RKU32MjbHynbuaIWLxlDF209Lv6kOatss4tllX19+XF/EOWFibrp23X2uX0KewzqmAm+R9GcVjbxzFtHFiV56fN3EF2iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821867; c=relaxed/simple;
	bh=SsRyTzAom/Wft869KnQ9Qt38Extxe2ej+kbogzcDl+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdLyH2QzMub+zYBIRoQWMYqs/irLaPrAnDd7aYBQcExW/1ipRpvniNt7pimVFAlxYftV19TpYr1+n4bB4rh1s1j3wZmJ7/ja4u7Qk593fzj5uKa+j9e3Kt6+zosfhQYFLToFqrvXTt9k6P/bZa8F3Jzt+xyjqBpLTuhWnKPZ8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZpE/gM0u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7D6C4CEF2;
	Fri,  9 May 2025 20:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821866;
	bh=SsRyTzAom/Wft869KnQ9Qt38Extxe2ej+kbogzcDl+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpE/gM0uGypZ5l7V2yRKKHZDrK7FrXSNT9r/tDEZIlya7qMkH/UNCreoisXNpW1+z
	 i04wAoMGLNQwl76gM1xMoWmRaGLKY54M1k0ZHZ/O4lSPw1H/M1Hq+dtx9B1ZucnIdt
	 r/Fv7OIliSH78V+uDDYPp3hdJCzX+3TtqgChNi5nBnECD2h/g2iXavn1BxgPZ3mRNQ
	 McKJjCXE33d72v/Rr7aB9MmX2BAX+qbn3RX+AB9dVz9fQAVm6MG7BVagNx2ZD3PtjS
	 AnMYlAQXFeqmiszRZHPK4fFLNd1v/cCs2P46EZRoIvOcbTDS1RCpfoiLvFG1iEB/Oo
	 FnyM/YjLtmENA==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 04/62] x86/kprobes: Remove STACK_FRAME_NON_STANDARD annotation
Date: Fri,  9 May 2025 13:16:28 -0700
Message-ID: <2b2dffdf237d36e6184f0cd948b3ee36e8b1dadc.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 877b145f0f47 ("x86/kprobes: Move trampoline code into
RODATA"), the optprobe template code is no longer analyzed by objtool so
it doesn't need to be ignored.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/kprobes/opt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 0aabd4c4e2c4..6f826a00eca2 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -103,7 +103,6 @@ static void synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
 
 asm (
 			".pushsection .rodata\n"
-			"optprobe_template_func:\n"
 			".global optprobe_template_entry\n"
 			"optprobe_template_entry:\n"
 #ifdef CONFIG_X86_64
@@ -160,9 +159,6 @@ asm (
 			"optprobe_template_end:\n"
 			".popsection\n");
 
-void optprobe_template_func(void);
-STACK_FRAME_NON_STANDARD(optprobe_template_func);
-
 #define TMPL_CLAC_IDX \
 	((long)optprobe_template_clac - (long)optprobe_template_entry)
 #define TMPL_MOVE_IDX \
-- 
2.49.0


