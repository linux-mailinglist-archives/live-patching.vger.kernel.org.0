Return-Path: <live-patching+bounces-1405-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF94AB1E26
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09C6DB267E3
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58858299955;
	Fri,  9 May 2025 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6vqXNMx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E916298C10;
	Fri,  9 May 2025 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821898; cv=none; b=ghfr2RLcPuXEFHTnG/hmm0hC5TaWahNpXGeGWr4BO/peIFb4U3v5Ls4TQ62darWwkaaIpxPAMCijUTLNvo/jz3OH4FOaLtf3MyQAVGPFnaK8V48fRmVNuWGrp5z/EqpLIGOSJtyyOxRR3trdNYtti7LWHwA9FhNKZ1YziTpLGpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821898; c=relaxed/simple;
	bh=awfvqbMu86VnqAeMjFyCXWKk5qbZjyx61gKZgFRh8pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vnoot4br5Ecn0z0gQXWfe/gcTZlppySSOLEmuJWV5RYuv70JxwCqdmCAJBdEwqBLM45UBs+lHaloeJvLSYdt3gSiHSc0jpi2u8PxOg7UaffPDJBg+sNtZC+dhPJ/tU3B9fIHlhwyXMxUQmIJPxXFODEk66vO6/WAztn4VIYReo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6vqXNMx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8677AC4CEEF;
	Fri,  9 May 2025 20:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821898;
	bh=awfvqbMu86VnqAeMjFyCXWKk5qbZjyx61gKZgFRh8pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6vqXNMxVYxvfw9p5D14I4JL7KpBC9wj+6hCC+VQCFVYT74tdxq+s/DgSrtn4nV2K
	 cPO0tw5tf8ANeMuPkvU2NtA1Qbs/5M3zNLjGguCclX6uoMSo7PbFehAwX3cNAI1FtE
	 TSoK90zMud8dlKEaoZretoQ2a00TC4NGD0mnREbeOGms9mVBeGmuHLLWlW7IiEe+QQ
	 Q4cgVYz5XPsjqJbC2YSbBGe/aCPaSGTRTG+KqIwq+1L7v4v21yFXucPQMOCZg94ayZ
	 UDnbmJKbi0uRFe92Q7gxgYq10zdxUJlT0eMLS/R/x8G3wQzw/Pn8pKtSl2IAfClgQf
	 xN3qWeKQiHwqg==
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
Subject: [PATCH v2 47/62] x86/orc: Define ELF section entry size for unwind hints
Date: Fri,  9 May 2025 13:17:11 -0700
Message-ID: <43e3ed230c982e35e43a9c66247b995336253d2d.1746821544.git.jpoimboe@kernel.org>
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
size for the discard.unwind_hints section in its ELF header.  This will
allow tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 2 ++
 include/linux/objtool.h      | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 977ee75e047c..4624d6d916a2 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -199,6 +199,8 @@ static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
 
+	BUILD_BUG_ON(UNWIND_HINT_SIZE != sizeof(struct unwind_hint));
+
 	if (ip == 0)
 		return &null_orc_entry;
 
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 366ad004d794..483dd3131826 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -8,11 +8,14 @@
 
 #include <asm/asm.h>
 
+#define UNWIND_HINT_SIZE 12
+
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(type, sp_reg, sp_offset, signal)	\
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal)		\
 	"987: \n\t"						\
-	".pushsection .discard.unwind_hints\n\t"		\
+	".pushsection .discard.unwind_hints, \"M\", @progbits, "\
+		      __stringify(UNWIND_HINT_SIZE) "\n\t"	\
 	/* struct unwind_hint */				\
 	".long 987b - .\n\t"					\
 	".short " __stringify(sp_offset) "\n\t"			\
@@ -88,7 +91,7 @@
  */
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .Lhere_\@:
-	.pushsection .discard.unwind_hints
+	.pushsection .discard.unwind_hints, "M", @progbits, UNWIND_HINT_SIZE
 		/* struct unwind_hint */
 		.long .Lhere_\@ - .
 		.short \sp_offset
-- 
2.49.0


