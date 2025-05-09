Return-Path: <live-patching+bounces-1402-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB48AAB1E1E
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D38BFA0747B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CA6298CA6;
	Fri,  9 May 2025 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o8kDWFzX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAA82989BE;
	Fri,  9 May 2025 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821895; cv=none; b=isWyuXUnrMEFbV+MW+D/yHD2SxGYDPApdpHTNsL+yExHIlutgtprdGlkSszm/t+19rmzw8bPKekAJIcINjE8/UeqTSSarU8XXMEMSB8Rl8Pm6bCoWDjeyW3RsOKma/kap2cWi/1d19LKoqThHPXFQxV+W6vbgJ+cFzc8O24gKMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821895; c=relaxed/simple;
	bh=qq4f5X+mxLUKb++5vZav/c3qryo3uTpZCBcDBFGdgf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIduZD/mfuIophoI+dNL5Agx9+NUFI4/YPsQI71G0udAFbmOxhGhHas/WwiSIpH97nnf9x1lMFrn7tFjpDyEegm2W2ZzvVg/jLrLL5yQ8CSkzg9/YMe1753gQ2puCQbaJ9NShvxZZ5Fdxb3fR2L5mTXgTOH1W0fa9FKwtQhV8JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o8kDWFzX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CFFC4CEEE;
	Fri,  9 May 2025 20:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821895;
	bh=qq4f5X+mxLUKb++5vZav/c3qryo3uTpZCBcDBFGdgf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8kDWFzXS83Iyi+N9p8zX6i42iFDnHc8Ki0qZzyrTt54BAbpbhq/FIE00nYSsZRiH
	 MZ59/aSlw8uYvBDHnogGYxlj3XeMHtBNJRS1gw7rqbcIQbg1h17m91vtHkTFtP9Drq
	 13XMlLI2Ku+mNLXcRGxjjVeyaHo3yIyrZShiXMMqdNcPUIL/5oedAbJINgCrIpvmDA
	 CiKz2cYQBg3svOdQKgQJ1sG52997YYjig6z9GMU0/NY1uFj6BW6/zTqtR5BQ6pxXa+
	 aNm7/0Me/d2myIfpb9QICEo7gMRbSgPw0+cxWPC4t0ee46ArrHr1M2WUHE3v4fw3Zg
	 38XVPcXnozNIA==
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
Subject: [PATCH v2 43/62] x86/alternative: Define ELF section entry size for alternatives
Date: Fri,  9 May 2025 13:17:07 -0700
Message-ID: <68a8126c21f4ee054d6c4d6262d0f465b5babd89.1746821544.git.jpoimboe@kernel.org>
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
size for the .altinstructions section in its ELF header.  This will
allow tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/alternative.h | 7 +++++--
 arch/x86/kernel/alternative.c      | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index e18cdaa1573c..212761eec886 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -15,6 +15,8 @@
 #define ALT_DIRECT_CALL(feature) ((ALT_FLAG_DIRECT_CALL << ALT_FLAGS_SHIFT) | (feature))
 #define ALT_CALL_ALWAYS		ALT_DIRECT_CALL(X86_FEATURE_ALWAYS)
 
+#define ALTINSTR_SIZE		14
+
 #ifndef __ASSEMBLER__
 
 #include <linux/stddef.h>
@@ -165,7 +167,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	"773:\n"
 
 #define ALTINSTR_ENTRY(ft_flags)					      \
-	".pushsection .altinstructions,\"a\"\n"				      \
+	".pushsection .altinstructions, \"aM\", @progbits, "		      \
+		      __stringify(ALTINSTR_SIZE) "\n"			      \
 	" .long 771b - .\n"				/* label           */ \
 	" .long 774f - .\n"				/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
@@ -328,7 +331,7 @@ void nop_func(void);
 741:									\
 	.skip -(((744f-743f)-(741b-740b)) > 0) * ((744f-743f)-(741b-740b)),0x90	;\
 742:									\
-	.pushsection .altinstructions,"a" ;				\
+	.pushsection .altinstructions, "aM", @progbits, ALTINSTR_SIZE ;	\
 	altinstr_entry 740b,743f,flag,742b-740b,744f-743f ;		\
 	.popsection ;							\
 	.pushsection .altinstr_replacement,"ax"	;			\
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ec220e53cb52..d6064dd87dde 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -425,6 +425,8 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 	u8 *instr, *replacement;
 	struct alt_instr *a, *b;
 
+	BUILD_BUG_ON(ALTINSTR_SIZE != sizeof(struct alt_instr));
+
 	DPRINTK(ALT, "alt table %px, -> %px", start, end);
 
 	/*
-- 
2.49.0


