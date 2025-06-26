Return-Path: <live-patching+bounces-1578-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A969FAEAB63
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F2A11898C46
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DE928DB7A;
	Thu, 26 Jun 2025 23:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GysWhB0X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A928DB56;
	Thu, 26 Jun 2025 23:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982205; cv=none; b=gthExBn12XZEaPg39TyGntQCSdN/8wZdrcL1ei7sP+HZvkmPhpR9c4CEKt5LrXD0mf84lHSOQP9UY4/cGLkznAv/0L+q7aL1XNLHWWK2HG774XQoTIz+uCwoUTH7fNyYgDOc16+/vCpphpPBgopzq64FyFROrIbt0cH2ZARoTMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982205; c=relaxed/simple;
	bh=/vazAWpSQLKOVN2fQQJfvBRflRe4tIk8DyUCVqU/PSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUmFLl9BP7EkIyrL2Y0XBgsSTNdP4LK1ThcwDvx0cbQk/cDsAmVroItkQH/dYYvpF6bGF1W/Sv4VKXgKgCHIyVI7Likb1eeASl36b3YKiTO7mIz2SAz6GvSrIBj5WgP4JdUij4JRCibzvThdwn2GXi8p9vWuAzjDtZ0OWfZ1IcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GysWhB0X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EDCC4CEEF;
	Thu, 26 Jun 2025 23:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982205;
	bh=/vazAWpSQLKOVN2fQQJfvBRflRe4tIk8DyUCVqU/PSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GysWhB0XMAt3fIGdGpkJeAtHd6/4hKbc4W6cbX9L69UK4G7CQ9aQ2M2LCSeur5EY/
	 oL0KJC46H2H7ms8P/vf1eABotdvCBPc0ttB2mvxuMCFNPEXWRqh2RKq/ucdtuDmCoz
	 OPwCF6MByq8scbP87jXFVjmptv+TAheWGpkmQ7/ekIGg/eXMnTU/DUKBbQGSGHXuVW
	 SmBFkeHxNTNPc/C4dz3qO/fwRUMiLag8gXwWUQdOMwURv3tz/5ZMPIfiQSB887eOYo
	 9rELFuGBFoQHaRePL6qCi9ACnjivfj9W081flhsKfLpoZBvuwmxqIq+O3dV5yVdWmM
	 ZaMyWFKet3CYg==
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
Subject: [PATCH v3 48/64] x86/orc: Define ELF section entry size for unwind hints
Date: Thu, 26 Jun 2025 16:55:35 -0700
Message-ID: <edd9abc04a63d009d527a3dd69ebeb040236afb2.1750980517.git.jpoimboe@kernel.org>
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
size for the discard.unwind_hints section in its ELF header.  This will
allow tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/objtool.h | 11 ++++++++---
 kernel/bounds.c         |  4 ++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 366ad004d794..c7a3851ae4ae 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -2,6 +2,10 @@
 #ifndef _LINUX_OBJTOOL_H
 #define _LINUX_OBJTOOL_H
 
+#ifndef COMPILE_OFFSETS
+#include <generated/bounds.h>
+#endif
+
 #include <linux/objtool_types.h>
 
 #ifdef CONFIG_OBJTOOL
@@ -10,9 +14,10 @@
 
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
@@ -88,7 +93,7 @@
  */
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .Lhere_\@:
-	.pushsection .discard.unwind_hints
+	.pushsection .discard.unwind_hints, "M", @progbits, UNWIND_HINT_SIZE
 		/* struct unwind_hint */
 		.long .Lhere_\@ - .
 		.short \sp_offset
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 21c37e3ea629..f9bc13727721 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -15,6 +15,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/jump_label.h>
 #include <linux/static_call_types.h>
+#include <linux/objtool_types.h>
 
 int main(void)
 {
@@ -37,6 +38,9 @@ int main(void)
 #endif
 #ifdef CONFIG_HAVE_STATIC_CALL_INLINE
 	DEFINE(STATIC_CALL_TRAMP_KEY_SIZE, sizeof(struct static_call_tramp_key));
+#endif
+#ifdef CONFIG_OBJTOOL
+	DEFINE(UNWIND_HINT_SIZE, sizeof(struct unwind_hint));
 #endif
 	/* End of constants */
 
-- 
2.49.0


