Return-Path: <live-patching+bounces-1530-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8157DAEAB02
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6739F7A1C62
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF3B226D1D;
	Thu, 26 Jun 2025 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xlzow91a"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4470225A3B;
	Thu, 26 Jun 2025 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982171; cv=none; b=D3v/SMCK0kWfXCFOqK0GZLkDnPsLTbOdEi8bF47WvBdHwHtBxxm3WFxk+7yDkme29V/nxsGbUEMLvbHw638xpSpvsCy3bkAF0QGSBGjWnbZUTpHfYxn+mRuB+JB+G4HQJWTzVMeMsFk4zfX6cILTbokgHjODtsKL7WaKgIKHm+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982171; c=relaxed/simple;
	bh=EiuK1X9yLyff3oe0kJ8VsJ5+DhDW2GwGgf3p+fKQ2NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyu9iNpQYvXDZ1AneHKFkr2iiqFqgqyRYT0cNxeEcQurebQe+cYUpm+lKFpI4VrxiLDehaKxLmcn1koQYaoM7DDA98/7DPvTDECydrFhrrIC5xMXU8YKNQqsjFka+IE/GzJXRLpfNQlIi2Atl5iewAaQGGbyaEyWNdvuQFj6bSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xlzow91a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8493C4CEF2;
	Thu, 26 Jun 2025 23:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982171;
	bh=EiuK1X9yLyff3oe0kJ8VsJ5+DhDW2GwGgf3p+fKQ2NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xlzow91aUz8yuDeqSHPGXdFrdtjtLVxV8+6X2J76WSuUkFWKwCR5IG/CYtGIlzTfl
	 sIrQvgu2vSzh79bvrJYby6irSO37UoA6YbdtFKI4IU5S80dDchZ9BDiACeuScA5fa2
	 ccovNUZ0Rix+lwIrexSvL77/eUNkIL4fykR/WZ8hgS+R9/51+N5e/RC0H0nLA70obh
	 dJ20J0zcWT1KflnRSynWo0fLYmagO2hp5u842Di6u5Tdf/WEUA3lcsnNl0Fk1zWD4m
	 ngqyQRv04cyjyRjSDnqSWCv/yfgc3oO0C110Q7qYGb0JgvGXrh+BSlTgQudi2U+IXC
	 7ZP/NPHdy01cQ==
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
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH v3 01/64] s390/vmlinux.lds.S: Prevent thunk functions from getting placed with normal text
Date: Thu, 26 Jun 2025 16:54:48 -0700
Message-ID: <aa748165bf9888b0a7bd36dc505dfe8b237f9c62.1750980517.git.jpoimboe@kernel.org>
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


