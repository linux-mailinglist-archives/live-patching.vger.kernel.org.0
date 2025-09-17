Return-Path: <live-patching+bounces-1712-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DDBB80E57
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED8F06226A8
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD733408DF;
	Wed, 17 Sep 2025 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+nUoEKI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174734347B;
	Wed, 17 Sep 2025 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125097; cv=none; b=t+iVqYzRNiEAtI6aQE3/PDQPbhGVXsi0q0zp3eHFYXpOFalRCXM9TuXcBOpV3NKGx1wCLulmwv8UzUwM3tOupONBVth1+UZ6mlbiEVQ9o6cxfWmlUtp/7JNzdEz17fSa3sLTqjkwe/IAzLSPR624MneDovy09uF6BTYljHCLX8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125097; c=relaxed/simple;
	bh=A3H5+d5LYxnmBKlvKCIJb0WGEy7vihtqh4K31QNEIDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzXYeyralGGiUdk+lbo0QO1T3E++QTUtMRuBMQD4GnFWpxgoEYf+2I/fBK2j6U3PUjycG5BxScOwoOzoLma6uhfIFuo+Q9loL8B8p6n/6GtliOhhKFZQPrgcbhrMsURVfazmtLq9iJkfc2e81YBRj0v+QPDe2iX13W1M/I4aYRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+nUoEKI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAF5C4CEF9;
	Wed, 17 Sep 2025 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125096;
	bh=A3H5+d5LYxnmBKlvKCIJb0WGEy7vihtqh4K31QNEIDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+nUoEKIzy5ZpH9IouxC7dyvMSexlyYBFtcb4V0Ve372+zFqq2geGln0xd2XtBZ9j
	 F06D+bfePZjjlKCwA4g91v8qza6yWhpgzu1iPq5aWPgw6xRPGG1yYi+SLWSoiNtdTP
	 h/9Hq+PHHYLBWQ+/hyw8JuCONtMriSWqd0VGGkNlNh4b1vQ6Y1Y2OQmWleegdCGX3b
	 /Dbzozk99qzA6uwEXmP3CytQABPRpv8tbB+6QHrK6+ST9GmvncqzWAaoRTkBf5hxzn
	 c2N1ZOgUjLTjBQqbbPfyxMUDa8gqrxaMsEmkOB84SFlMK2A848R2sJKdvlqgmFExm5
	 R9vfxiDECp90w==
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
Subject: [PATCH v4 57/63] kbuild,objtool: Defer objtool validation step for CONFIG_KLP_BUILD
Date: Wed, 17 Sep 2025 09:04:05 -0700
Message-ID: <9c777456807dca9e543abf935612da5a219ba4cc.1758067943.git.jpoimboe@kernel.org>
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

In preparation for klp-build, defer objtool validation for
CONFIG_KLP_BUILD kernels until the final pre-link archive (e.g.,
vmlinux.o, module-foo.o) is built.  This will simplify the process of
generating livepatch modules.

Delayed objtool is generally preferred anyway, and is already standard
for IBT and LTO.  Eventually the per-translation-unit mode will be
phased out.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/Makefile.lib    | 2 +-
 scripts/link-vmlinux.sh | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 15fee73e92895..28a1c08e3b221 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -197,7 +197,7 @@ objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
 
-delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT))
+delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_KLP_BUILD))
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 51367c2bfc21e..59f8752362926 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -60,7 +60,8 @@ vmlinux_link()
 	# skip output file argument
 	shift
 
-	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT; then
+	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
+	   is_enabled CONFIG_KLP_BUILD; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=
-- 
2.50.0


