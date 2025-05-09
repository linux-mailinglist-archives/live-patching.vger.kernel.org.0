Return-Path: <live-patching+bounces-1366-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BDFAB1DD8
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E97851C207E9
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4922609F2;
	Fri,  9 May 2025 20:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJhDkWKq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69FA2253B2;
	Fri,  9 May 2025 20:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821869; cv=none; b=H8ITegvrLNgH+lRdyJt0jUUdCCvlJjcuemJry40Rx0zWtdGSpqKXtZFE88dyMdSkgjwNmkz030WmK2R9VP41MEFu8cQVLCrCJ1DOFUWS9CCftN/C2PzpAUXwNQrxxakwvlSbc/5zbTbhaWI1vxDONmv9tZKy72TIoZ9cqv2Az/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821869; c=relaxed/simple;
	bh=CzL97ppEFIAqWlaw5ziqGUhqojWDK7zAj1wMTi9L81o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHkGjLxOqzuIkaVRz/SUxXU0hscltKeIuud8miMfdo+CI0pWaUmHTZDK/cofoEAGekaVAyfwhZHLhV8WaupQJaih3zlWoCpxTY2cZXBFu6VU4EeIlGl5pCbkP9tAAQAwewffz8fUAEWEKJRaja7EiObJwbF550O9RtHE9OBWM3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJhDkWKq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48192C4CEE9;
	Fri,  9 May 2025 20:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821868;
	bh=CzL97ppEFIAqWlaw5ziqGUhqojWDK7zAj1wMTi9L81o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJhDkWKqUgHYWVYXXKx7Hih56KQo88qiJq9j5h6ll9U+mWnhJCF2hi0ellmWZelAl
	 vQD/hIff0kzT/3HulQybXajooBX3k53HU/5CNcfPAATls8rCuRydcXAYwfaT7Mhh2C
	 StfWE6SqYrVzKkacONPBvHKKXJZCNk39Axs4dv0rqJNsRFXudoIV8xwGuqgBCZ53D/
	 lNDn2fsZYg7IZkoI6vgP17f9oFGBKKNS9c6OdBw9WDa3Iuq1Z/3OkpXDhZYBblbd8c
	 ZKQ2fM6Z4JHyUT3O0jusG2IxdBdMYdR+IBj3Xs2tGhuvN3e9xcwKpUNRgvsfuIaIue
	 4fVDcIsL0+DfQ==
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
Subject: [PATCH v2 07/62] elfnote: Change ELFNOTE() to use __UNIQUE_ID()
Date: Fri,  9 May 2025 13:16:31 -0700
Message-ID: <3509a9a8896dfc3f9c54f8eeb36ed77326827564.1746821544.git.jpoimboe@kernel.org>
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
index 69b136e4dd2b..bb3dcded055f 100644
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
2.49.0


