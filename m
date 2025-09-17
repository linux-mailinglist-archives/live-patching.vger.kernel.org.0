Return-Path: <live-patching+bounces-1657-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 304F1B80D28
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B88E02A722A
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4790C2F83B7;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ij1OCcfg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2038C2F7AD5;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125059; cv=none; b=pqZj7O/fycRg32W1qc5wHAtD0zu6cTjLRAEC6S7417A0SnRJ8dRXD15PH6mEpxFCzGEQjjPXyq6zKZJCrpK2r0mVxhxOEE3F11beZ6ARcP4SLjLcaqHnqd7b+ToGyCuN9KmQ2lIwBX4H2OxiRNX1ZM9sG6GuoN/AqDR+3wY27tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125059; c=relaxed/simple;
	bh=kB2bITyAnXNik8zj9vwWQanEEkbV3eGASbyxSl9fHig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEyF2XOYoTTD2+HuCaWeHnvS7nZe1xiw8n10dngUGRcoou+lHklWA8WDjDlVURQogKoIUxYET3660oFQOiMLHOJa54qHpnxUI2VJVh43nExIEgMuboJUfh1fYbj/kEfX5FdM5iKkk4G5Xki9GQpK3qS1Qb3u85tS7mR0klr8xtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ij1OCcfg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9C8C4CEFB;
	Wed, 17 Sep 2025 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125059;
	bh=kB2bITyAnXNik8zj9vwWQanEEkbV3eGASbyxSl9fHig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij1OCcfgnNCcdyk0D57N9VRM+nEbhEzNTyRKxSB8fyyyJOmN35bJesIhTk4OxrCvU
	 T9omJ6HoDCg3tn3pgo0M44O+NFgjL9Z9MAejw5eOYqrSW2PkA+8/7NKvFB1CyT31VN
	 vn5DXEJvgLICD/9fWFzlAgVqjXD6r3E8uQ5r10FDVll1mcw5xtjmmdDEPy5I1fEYYG
	 Wso7hHYul2nQFaCpWF7/A7rrYAYPzzF61XfCTGJevXOcB7Y4xhmhVBd49vFANjgl60
	 YPP+br89hc5jS75ysUC4AfHs5BEB0oOAtI118Os2mc3l/W7RTYqoOr3VkMhMT+Va2V
	 I1/tfP3E57wCw==
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
Subject: [PATCH v4 04/63] x86/kprobes: Remove STACK_FRAME_NON_STANDARD annotation
Date: Wed, 17 Sep 2025 09:03:12 -0700
Message-ID: <1df0892691049cda78c595b5b19878821cf5d0cc.1758067942.git.jpoimboe@kernel.org>
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

Since commit 877b145f0f47 ("x86/kprobes: Move trampoline code into
RODATA"), the optprobe template code is no longer analyzed by objtool so
it doesn't need to be ignored.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/kprobes/opt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 0aabd4c4e2c4f..6f826a00eca29 100644
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
2.50.0


