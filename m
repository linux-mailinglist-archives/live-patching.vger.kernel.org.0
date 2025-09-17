Return-Path: <live-patching+bounces-1662-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7250B80D52
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873CC1C20F4C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE0B2F90CC;
	Wed, 17 Sep 2025 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0XD/nQE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AA52FA0DD;
	Wed, 17 Sep 2025 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125061; cv=none; b=noUPvsBGeq6/n/xyHltf+/APz/NCyLaNsSMBqWYJbK0W3KTf4FdreYCfdzNva/DT3XFn+AaSNlo5UC5PNZQT1UwgnN/v7T6QnBDwxmBexYLnkCCr8GAAmacNxiWls9SSAVkx9yiPW3npabI+jOGVaHvvWgk7OLQB5HneQGbr0Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125061; c=relaxed/simple;
	bh=edjS2E9XX9ax1DMF/nNFhXZZs9mX8DK0OwXbIxiMZtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx3j8XneyU/A2yz0rZHA2wCET2jzio392NXTsa7tmIxB5XPfgCZtFMLbFIhRhwu0Rhm031TqeImuBcckf3Fuo3nWDhRl2RdRcG+3RJ0TkcNZg9vnannMVutv8HPsJngno8X2cQLzE2m9NxdD7a8+grKmJ7EBpu84bicSkRdfHqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0XD/nQE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3FFC4CEF7;
	Wed, 17 Sep 2025 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125061;
	bh=edjS2E9XX9ax1DMF/nNFhXZZs9mX8DK0OwXbIxiMZtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0XD/nQExYCxBrAyGYtcLh56K19PHDyqTqVo4qdv2p3myqoYuJJbbM4R3Z/ciWTMj
	 2nacItHg+SlXfO4aSALwC7GrY/ycuelGXm+GjO/DfgmTwHVGgqBN10lxnTqkxA+W8n
	 vhhKxeZ0amRow+SxhAOzk/r/f06mXsEDd2HBh1xpyU7xxQfXVt7GYAusM5l3N94RQE
	 uzHr210mfA3XI4ldxJmbyqOQGaBo+MfGJvrQrGmgMfYarkl4+a2urq9lQ0S93WVQq2
	 w38BgY5amRe8V+uXyjupAlNuZc/4wXFD1R2hIco6BOvuIBOIpHfpwJsubdM1xJVwMx
	 H8U+I1q3oRDhA==
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
Subject: [PATCH v4 07/63] elfnote: Change ELFNOTE() to use __UNIQUE_ID()
Date: Wed, 17 Sep 2025 09:03:15 -0700
Message-ID: <2cb558a895702dd74240516523324123b9933914.1758067942.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, replace the custom
unique symbol name generation in ELFNOTE() with __UNIQUE_ID().

This standardizes the naming format for all "unique" symbols, which will
allow objtool to properly correlate them.  Note this also removes the
"one ELF note per line" limitation.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/elfnote.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
index 69b136e4dd2b6..bb3dcded055fc 100644
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -60,23 +60,21 @@
 
 #else	/* !__ASSEMBLER__ */
 #include <uapi/linux/elf.h>
+#include <linux/compiler.h>
 /*
  * Use an anonymous structure which matches the shape of
  * Elf{32,64}_Nhdr, but includes the name and desc data.  The size and
  * type of name and desc depend on the macro arguments.  "name" must
- * be a literal string, and "desc" must be passed by value.  You may
- * only define one note per line, since __LINE__ is used to generate
- * unique symbols.
+ * be a literal string, and "desc" must be passed by value.
  */
-#define _ELFNOTE_PASTE(a,b)	a##b
-#define _ELFNOTE(size, name, unique, type, desc)			\
+#define ELFNOTE(size, name, type, desc)					\
 	static const struct {						\
 		struct elf##size##_note _nhdr;				\
 		unsigned char _name[sizeof(name)]			\
 		__attribute__((aligned(sizeof(Elf##size##_Word))));	\
 		typeof(desc) _desc					\
 			     __attribute__((aligned(sizeof(Elf##size##_Word)))); \
-	} _ELFNOTE_PASTE(_note_, unique)				\
+	} __UNIQUE_ID(note)						\
 		__used							\
 		__attribute__((section(".note." name),			\
 			       aligned(sizeof(Elf##size##_Word)),	\
@@ -89,11 +87,10 @@
 		name,							\
 		desc							\
 	}
-#define ELFNOTE(size, name, type, desc)		\
-	_ELFNOTE(size, name, __LINE__, type, desc)
 
 #define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
 #define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
+
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _LINUX_ELFNOTE_H */
-- 
2.50.0


