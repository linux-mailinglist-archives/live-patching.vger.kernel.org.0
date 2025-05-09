Return-Path: <live-patching+bounces-1360-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD346AB1DC8
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 813763BDA70
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F2F25EFB7;
	Fri,  9 May 2025 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c21BYl2r"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAAB25EF96;
	Fri,  9 May 2025 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821864; cv=none; b=CV90uabmV4WYSj3qXlRo2khER8SPi0eXXeW+9kpEbcGWd30YcQXiMlbH9GHzOF0dE98jNafLvwXqCxPtoxJ/cdgghFdDiUJWMA3ZFTBQQwUXJ6mWa5RcCkgJK8czi2w0yCETvy3IfOZAydWnpgi9WpkiR/ORYZ4aOy22vt/tT08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821864; c=relaxed/simple;
	bh=EiuK1X9yLyff3oe0kJ8VsJ5+DhDW2GwGgf3p+fKQ2NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdZwpxHPhjTMiaQLXLmlPV1wMYuGT3ghpH1WaVn43TpEc4QGgnJXH8faCXiKETejM1wrxrQVXhY2q9Frm9HhQw5Ej53pm0hwqO87XNlpn+bpo6fijF2JtkMN+SDS0LpKuWVViQ7FgjnaEpM4AML+D4MKRSWWPdWv38A6+omHNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c21BYl2r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA34DC4CEEF;
	Fri,  9 May 2025 20:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821864;
	bh=EiuK1X9yLyff3oe0kJ8VsJ5+DhDW2GwGgf3p+fKQ2NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c21BYl2rdLgF+eH3o2JamZr/mX7tkuutuMO3Ug4Ak4+y1JmUHQ1nb7AW5g3TJUjJE
	 2a2KZuTl6V1WVFi9hVkrXn0ZndyycOw60emEAshUzL21lLV3XoX/nrTQFxIvqWhLSY
	 PpenhAp0tZF2LeM46MZ0qoEdQwdLD6j8+OiW54JncQRjAguwJlL2lsXW8Dfz+wML6Z
	 +qrsxdYBPXzJZb0CUtobmUff+IWWYruLrEfXO3gCTtM7m12HhX3w4sQIICTQ8WpUew
	 kTXNz53eJMRBlC+7GYs5VoSQ6/fKCySFmzZyzj0Fzg2jxwOrwkiCWATQLg8xEQYBIt
	 mVBvwYFKyTLaQ==
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
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH v2 01/62] s390/vmlinux.lds.S: Prevent thunk functions from getting placed with normal text
Date: Fri,  9 May 2025 13:16:25 -0700
Message-ID: <5547e8efe2291df0c8acf06a9bbc8f3129cbe229.1746821544.git.jpoimboe@kernel.org>
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

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/s390/include/asm/nospec-insn.h | 2 +-
 arch/s390/kernel/vmlinux.lds.S      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/nospec-insn.h b/arch/s390/include/asm/nospec-insn.h
index cb15dd25bf21..84372c3f313a 100644
--- a/arch/s390/include/asm/nospec-insn.h
+++ b/arch/s390/include/asm/nospec-insn.h
@@ -18,7 +18,7 @@
 #ifdef CONFIG_EXPOLINE_EXTERN
 	SYM_CODE_START(\name)
 #else
-	.pushsection .text.\name,"axG",@progbits,\name,comdat
+	.pushsection .text..\name,"axG",@progbits,\name,comdat
 	.globl \name
 	.hidden \name
 	.type \name,@function
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index ff1ddba96352..fbd6d1f83b67 100644
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
2.49.0


