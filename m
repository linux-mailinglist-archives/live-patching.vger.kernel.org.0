Return-Path: <live-patching+bounces-1656-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4043BB80D25
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC8AF7AF4EE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668892D374D;
	Wed, 17 Sep 2025 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5IO7XM8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54E2877F7;
	Wed, 17 Sep 2025 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125057; cv=none; b=G00s2258BwncArsnMDBZNYQW3bSEagvJp+c+lWbBEJSE241LuD15udjNaEgHeorNs47lrrmSiwpnFpUoMm/tvgUBpm1bu0kYZIC3ucSmK3xOWcTEfI+ucWons9eQeX39XDQCVCioNAokmn85sLomNMVXBqot2TsD4Q+ZsE7w0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125057; c=relaxed/simple;
	bh=nnjz7icAVSnZx5tYZe6k3KmmtjVt/3AzI/SEQTCK794=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukFqrPL5jCF/KUnGsqIgeZ5t8fBJEmWLf6TAjzwwrmxXu9B9ITKnUWXQWzUo2cpEetGKFvVXtaNN8GCVdLWU9769cAayJxRpobe3yC7m6OkkMCRM1MiuwXkBYZPt15PLjiN2ss9gDyhrXT6rADS1ihIksKs0Fpf3I5Lml/E1/as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5IO7XM8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E22EC4CEFB;
	Wed, 17 Sep 2025 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125056;
	bh=nnjz7icAVSnZx5tYZe6k3KmmtjVt/3AzI/SEQTCK794=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5IO7XM8SXo70vajGZci2kLy+B6Y5RKPF87Qwsbx5XK26c3U/u4rdJCwYna3uIgnr
	 bYsBqotgqbV/ptHTDAO8Tmtqns1wWqGPDEpNXRANYKrfvgW05EA+3ZWqZp9uxZJHh1
	 tuLg18sj1s7UQj2iu8RgpXXcGKrJ4iU8eLyLG+gswVpNOjNW9QnNYBodE8TlN4O1te
	 JFCwhOGzT53VEYul5E2c8Vp1lO9gQnRFw/3dL031F5hIqxWg/0YtCnmPged8WB8ZLv
	 YhoCwAEAVNCbvW7xKZA9CK9FDu31fktMEoHmJ//0LYL8PZWky242pEGedE2aAp4ISy
	 AY2qVJdxZTCig==
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
	Peter Zijlstra <peterz@infradead.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v4 01/63] s390/vmlinux.lds.S: Prevent thunk functions from getting placed with normal text
Date: Wed, 17 Sep 2025 09:03:09 -0700
Message-ID: <f41932f45a581433ceeab8226e35dc052a4babbe.1758067942.git.jpoimboe@kernel.org>
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

The s390 indirect thunks are placed in the .text.__s390_indirect_jump_*
sections.

Certain config options which enable -ffunction-sections have a custom
version of the TEXT_TEXT macro:

  .text.[0-9a-zA-Z_]*

That unintentionally matches the thunk sections, causing them to get
grouped with normal text rather than being handled by their intended
rule later in the script:

  *(.text.*_indirect_*)

Fix that by adding another period to the thunk section names, following
the kernel's general convention for distinguishing code-generated text
sections from compiler-generated ones.

Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/s390/include/asm/nospec-insn.h | 2 +-
 arch/s390/kernel/vmlinux.lds.S      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/nospec-insn.h b/arch/s390/include/asm/nospec-insn.h
index 6ce6b56e282b8..46f92bb4c9e50 100644
--- a/arch/s390/include/asm/nospec-insn.h
+++ b/arch/s390/include/asm/nospec-insn.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_EXPOLINE_EXTERN
 	SYM_CODE_START(\name)
 #else
-	.pushsection .text.\name,"axG",@progbits,\name,comdat
+	.pushsection .text..\name,"axG",@progbits,\name,comdat
 	.globl \name
 	.hidden \name
 	.type \name,@function
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 1c606dfa595d8..79b514c72c5b4 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@ SECTIONS
 		IRQENTRY_TEXT
 		SOFTIRQENTRY_TEXT
 		FTRACE_HOTPATCH_TRAMPOLINES_TEXT
-		*(.text.*_indirect_*)
+		*(.text..*_indirect_*)
 		*(.gnu.warning)
 		. = ALIGN(PAGE_SIZE);
 		_etext = .;		/* End of text section */
-- 
2.50.0


