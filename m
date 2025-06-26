Return-Path: <live-patching+bounces-1534-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18074AEAB09
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6B5A1892D3C
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF8D230BC3;
	Thu, 26 Jun 2025 23:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSWHjW60"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2F622FF35;
	Thu, 26 Jun 2025 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982173; cv=none; b=o1jbvsgdsnOpuMhPd2ZBUEWCO5E7IOX0ETb5ZCNE0PPo64xxkaoWCEnOcgknqQ/IkWHgo6NPeNrtHnmFbnYqJSygOiorXWWY0WQrCFRLgw0+YBwpNCGbrB/vBxWkU5Byjd8+CXtao4PriV3wl9crpawCMY4WYIFGZlKOetoBPW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982173; c=relaxed/simple;
	bh=SsRyTzAom/Wft869KnQ9Qt38Extxe2ej+kbogzcDl+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUemSvx4eqPXgQNlv4ZBi4UemsEdJYpOfU9TjZSNYO+LZrX730r+IT9NtIer3Zha1z93v5BzfFDRCo0mnqfGotpDBaEIWLXQUQq3qFY0p7hGBAOMvPaMOKmco2IO/3Oa1V2z0anqfCrfVOmDvgKo9SvpG67XSTeZGBxUYtz+KiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSWHjW60; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283F2C4CEF0;
	Thu, 26 Jun 2025 23:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982173;
	bh=SsRyTzAom/Wft869KnQ9Qt38Extxe2ej+kbogzcDl+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSWHjW60G8GS61l8W1ybCUT6+mPL0SvzERSpSGE52j81O3ajU0dld4FH1WZDxcOkj
	 gmgpBjpYB1Osz6b2Hg/FYdsOggNZzJimbOQ8xgPnwPWpeNYfpC0vpEeSDUf2cGkGpW
	 3gSKvVZoz7p6MCb4LAlO4Jd+KRIOGqP/sqW60uwmn8GwcJqyuUD5rSUgNpOPph3viU
	 KP70TE+kiAVsAyGvIKQFTgG2tGobGMCdtizAfLBEhWkmSk1dFAOsrmGmRmUXC31Cds
	 i7ex3YQvE93ZSYvUOKZSaGxsbU9H6D9AAgwilHIGKojs40P3400INvnAjGywyeA+FD
	 EgHpvcVjykSjg==
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
Subject: [PATCH v3 04/64] x86/kprobes: Remove STACK_FRAME_NON_STANDARD annotation
Date: Thu, 26 Jun 2025 16:54:51 -0700
Message-ID: <84b4dbbb573519658e378de029f2802698228a45.1750980517.git.jpoimboe@kernel.org>
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


