Return-Path: <live-patching+bounces-1577-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D94AEAB5F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71DA317054E
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B193928C851;
	Thu, 26 Jun 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmQs3x7z"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8924E28C5D7;
	Thu, 26 Jun 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982204; cv=none; b=EISCvYhu/jPdzo0iY614JO5WVmVpB7cRB8tTEOziZlcz3X6pkE6K92+Ur0cPnHq7s8pA21KO0T8V9o7I38hd5TeX/rmU+A3o0xoo6LFPN7wqpbT/WtmkiAMgBbxBaE/9TNE5NT/lE/FE30qfd5qSfkiOqDx/qV4ip7ZH2jSDnAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982204; c=relaxed/simple;
	bh=zJHQbwVSxvJMsp/vDOml8Q/LO+Frd6VrJctV0yXjZco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKQox1dA/THwfM6w08Vpowq7b+v4RS2vfCE3QBtjYeg9qalxUrriz9OoRHayrKqqR0T0sHVp7B+r/vxhZcl48X7myNspvRqLYsJ2TBoW+ua5++b4qjRVCCxpwRcK4/KO1X6spA0lml3jS5a2/8D2GOUxm35/YghmoNQOCr03+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmQs3x7z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE64C4CEEB;
	Thu, 26 Jun 2025 23:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982204;
	bh=zJHQbwVSxvJMsp/vDOml8Q/LO+Frd6VrJctV0yXjZco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmQs3x7zAfKtfZ0wh+YKnZVV4ckZ4DVRFB5PjYFRbOOhgAi98il9VAyri6UX4Kaho
	 BVprSwtmpFiwldzxb3/vlAMng1gZ4b2e2inHhZeiHK/7Azw5F7rJPtm9TY1qeyRIas
	 u2/cZwlKLLfsxTXdCndp3+sJWXogDrRoXnvP1fPKxUheH1hLVyjJdXr2Jyi8aySEsl
	 tW+eOSm9P+4A9/BPgfojbhkk/oJ5aAtmvMiA9CRHyDD5EYRdfFkpj9IBs/HOaxxzvb
	 Jlh0pS28h/N4s6qxMcWntVrm0az9qEoo06tKjdb6ebYSgOoDdXWgLgEXrEGLvvp+My
	 PN/TDm2p+rRlg==
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
Subject: [PATCH v3 47/64] x86/bug: Define ELF section entry size for bug table
Date: Thu, 26 Jun 2025 16:55:34 -0700
Message-ID: <43b5d27827075a3418edd0fad621c78070e4f444.1750980517.git.jpoimboe@kernel.org>
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
size for the __bug_table section in its ELF header.  This will allow
tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/bug.h | 45 ++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 59e155ee3c76..3aa28c687696 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -41,33 +41,36 @@
 
 #define _BUG_FLAGS(cond_str, ins, flags, extra)				\
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
-		     : : "i" (WARN_CONDITION_STR(cond_str) __FILE__), "i" (__LINE__),		\
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
+		: : "i" (WARN_CONDITION_STR(cond_str) __FILE__),	\
+		    "i" (__LINE__),					\
+		    "i" (flags),					\
+		    "i" (sizeof(struct bug_entry)));			\
 } while (0)
 
 #else /* !CONFIG_DEBUG_BUGVERBOSE */
 
 #define _BUG_FLAGS(cond_str, ins, flags, extra)				\
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


