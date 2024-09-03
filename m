Return-Path: <live-patching+bounces-540-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 506E7969275
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F4B6282F0A
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD1C1CEACC;
	Tue,  3 Sep 2024 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAIymmtP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303D1CEAC1;
	Tue,  3 Sep 2024 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336032; cv=none; b=ZcGLT5bMDgA9kumkJ7sQ12WwR2OQF/cYR4xUvTmHLp/t2ggnSIbuDP/PmFn4tJ9rDvfIWNIAjZh33Z/+5DsHL0OEGHLAyMEMJBvMtp55njzrlckSOr1cCmEgaNiOVRLR9N0pFrvZw+fsiOro36f2a0yzJNsqztJy6KnuSUSeeUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336032; c=relaxed/simple;
	bh=D66bvgjTzEHS1IUZEykzKYLBEGl7MWwVq4oNeoxG36E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JygVzhwRxloPDMXUMfJL/kJd42Rek30oWd0Xcbz81SXH/Qo65srWE0XckoQnbpkgBBkRei8Fg5qNEZ7G4MBIlynIAeXkrSYkBUKxebZxRTN3r5LLpESRbrjUjc9kZI8PIFnmWva3P98QByRwto9kKQetyUrpMjyChesJli0Hj6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAIymmtP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC36FC4CECB;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336032;
	bh=D66bvgjTzEHS1IUZEykzKYLBEGl7MWwVq4oNeoxG36E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAIymmtPm0nMdV9Rz7kru4HMAeAVnXLd3+fmOd0mjcUlx4JuSb1FQyuLG6e0t+jCU
	 sgmczaS/2dSI5bYVAQyncK2vXpzNfaVU4T83iY2zf5JGKW6++Vzy6y/bsVi/DOAElG
	 Ygn6kPzndpOVbUFc9x3eCqeFgpFPBVxI11WX5YoxZJTCs1IP/3Q7uJVyjdYZozrMqK
	 RNHFqDPHdtLMLuuj7GqArRfAMeg7yoJNRjcUBBgIXprXZH4pC5IcMOPeK5uOvA1nwT
	 tNFtOVHvOd8EoMAsdU/3e00c7dMg+r7VhK49Ts8pmWKM9+2dhjuWmim2rC1zrNGR58
	 vkq0XTvV5sH0g==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 06/31] elfnote: Use __UNIQUE_ID() for note symbols
Date: Mon,  2 Sep 2024 20:59:49 -0700
Message-ID: <4a9e9d529a2be6265999a669f921a39991bfdd63.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The name of an ELF note symbol isn't important.  It just needs to be
unique.  Simplify by using the existing __UNIQUE_ID() macro.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/elfnote.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
index 69b136e4dd2b..6398af0bb601 100644
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -64,19 +64,16 @@
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
+#define ELFNOTE(size, name, type, desc)			\
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
@@ -89,11 +86,10 @@
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
2.45.2


