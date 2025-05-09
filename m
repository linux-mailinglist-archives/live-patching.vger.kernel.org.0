Return-Path: <live-patching+bounces-1407-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58EB4AB1E2E
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 147001881F29
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D574299A97;
	Fri,  9 May 2025 20:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/msG73K"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10307299A86;
	Fri,  9 May 2025 20:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821899; cv=none; b=tW1T48YyYPPK40cH4OtyUICmkGLcSZxOLI/wqjx1y787jGLnCN63HjuaxS8GP4VWit0WGI6FXQpqsT4IBUOshnAZYo0h5AxkJdBTDS52HFxBylaVQA1qH4Khrvr44JP/D1wHBWg4di/WWAuMoQ+jtqL1EwyxeS1LqvKiOYISpzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821899; c=relaxed/simple;
	bh=It0WZrkllBLdfdgI1Pv+SSr5y5XJN+lhAvDI4mLBpMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGgPoLzGUzlkMGsCcLzoHw0bvEm3WuRk1x4DaF0YcPJNLdNm0Q4e29YpYFFPdxMoYitfS9oZJIlLmUTgHQwjek0SR1aAG9+yajypyhmJx4mG5cll1sajHpOQyNNXmA3FkD8KkMsNd4fZefuh2fXKA3NH0FJEBBKkwzPLkplRarE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/msG73K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C7C4CEE4;
	Fri,  9 May 2025 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821897;
	bh=It0WZrkllBLdfdgI1Pv+SSr5y5XJN+lhAvDI4mLBpMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/msG73Kppblr3tk08Z1EUrPI+x6jrjanNXisxm/7tYhHxcFmYlWWT3GUycnB0oTx
	 vDvR8HtKrQ6VGtIwPDy4ax8DvF27NikN/HX2oQtNuvLVKVIWR3UNZH8/tfbTHX/ch0
	 aJ954SRncwNuziObBX3KgbxbZZVIE3b5lotYwM8Q69M+aJXm3cWX8sVuQvx+8DXCPr
	 z/EbYFHs8L3Q+fMwxLAEcR7m13ERzWQkUoArYXbsGFWr11K5fRLAVIu4bD31ooD+7W
	 WobUXRMuPoYDBTYBYUhv9EcYHy63UsjK1hrXcL2VpJNVz+j50jMaVJW6A2JtyCId6O
	 Tka28q5iby6Jg==
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
Subject: [PATCH v2 46/62] x86/bug: Define ELF section entry size for the bug table
Date: Fri,  9 May 2025 13:17:10 -0700
Message-ID: <6b808664d8ff4c5eaa9cd416563341f3446b243b.1746821544.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, define the entry
size for the __bug_table section in its ELF header.  This will allow
tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/bug.h | 44 ++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index fb3534ddbea2..277938f4a40b 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -41,33 +41,35 @@
 
 #define _BUG_FLAGS(ins, flags, extra)					\
 do {									\
-	asm_inline volatile("1:\t" ins "\n"				\
-		     ".pushsection __bug_table,\"a\"\n"			\
-		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
-		     "\t"  __BUG_REL(%c0) "\t# bug_entry::file\n"	\
-		     "\t.word %c1"        "\t# bug_entry::line\n"	\
-		     "\t.word %c2"        "\t# bug_entry::flags\n"	\
-		     "\t.org 2b+%c3\n"					\
-		     ".popsection\n"					\
-		     extra						\
-		     : : "i" (__FILE__), "i" (__LINE__),		\
-			 "i" (flags),					\
-			 "i" (sizeof(struct bug_entry)));		\
+	asm_inline volatile(						\
+		"1:\t" ins "\n"						\
+		".pushsection __bug_table, \"aM\", @progbits, %c3\n"	\
+		"2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
+		"\t"  __BUG_REL(%c0) "\t# bug_entry::file\n"		\
+		"\t.word %c1"        "\t# bug_entry::line\n"		\
+		"\t.word %c2"        "\t# bug_entry::flags\n"		\
+		"\t.org 2b+%c3\n"					\
+		".popsection\n"						\
+		extra							\
+		: : "i" (__FILE__), "i" (__LINE__),			\
+		    "i" (flags),					\
+		    "i" (sizeof(struct bug_entry)));			\
 } while (0)
 
 #else /* !CONFIG_DEBUG_BUGVERBOSE */
 
 #define _BUG_FLAGS(ins, flags, extra)					\
 do {									\
-	asm_inline volatile("1:\t" ins "\n"				\
-		     ".pushsection __bug_table,\"a\"\n"			\
-		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
-		     "\t.word %c0"        "\t# bug_entry::flags\n"	\
-		     "\t.org 2b+%c1\n"					\
-		     ".popsection\n"					\
-		     extra						\
-		     : : "i" (flags),					\
-			 "i" (sizeof(struct bug_entry)));		\
+	asm_inline volatile(						\
+		"1:\t" ins "\n"						\
+		".pushsection __bug_table, \"aM\", @progbits, %c1\n"	\
+		"2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
+		"\t.word %c0"        "\t# bug_entry::flags\n"		\
+		"\t.org 2b+%c1\n"					\
+		".popsection\n"						\
+		extra							\
+		: : "i" (flags),					\
+		    "i" (sizeof(struct bug_entry)));			\
 } while (0)
 
 #endif /* CONFIG_DEBUG_BUGVERBOSE */
-- 
2.49.0


