Return-Path: <live-patching+bounces-1843-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA1EC54D01
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0D3B34688A
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B5D2F0661;
	Wed, 12 Nov 2025 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2VTg/Dw"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33BF2EB5B4;
	Wed, 12 Nov 2025 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762990363; cv=none; b=Pk4xTFE7bzkhboGdreIWa2Mca2IBg+Sx2R2KF8PjF1tXWGJdVLgdC1VFDkXIlwKuAfUB1KRanv9DEa7h3JrrRDvbpbO/+ts02S0esc7QHnDrO9nblUrzMgPz/XgL0B+gQNv5bFLooRxtw77byUY97zQMXj/xgfnd0VZp0qI2Tto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762990363; c=relaxed/simple;
	bh=ka5LoL3wNysYhYY2ZtA5p9SqKvdyTB6B68s8F46H7Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na5tvBCCHX++95q63AmYlDb973Mb4rSLfINofmOcc5n26CGWPDkvj+BqISpAzKdCmmrsvJcXZ+Yyu0QBAFZHrNakytoPX4Clu5Nwt/ENs+ipR2KQ/vDlY6OeVTWoHnLglwXVIf3nj5xToaDl7XjsACpHUYOZlO7h2e8kYrUYObw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2VTg/Dw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05918C16AAE;
	Wed, 12 Nov 2025 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762990363;
	bh=ka5LoL3wNysYhYY2ZtA5p9SqKvdyTB6B68s8F46H7Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2VTg/Dw6Yhh88bmO0cRejWrK1oZGC/AQj9nNlFu1xQf/JnHnu4ij9ZSw++Pr24Ue
	 VyMjUDy1uGoOhlA3YU2QkqAZkc5WJzRHqQm3ANOoFQ2DdoH1xYA5AOZRYg5jZ1sYCJ
	 +IEEiQBbfjCgoDfcazT3PwY9E3hV5/AEcFjIoL7N1W7mTghLbGK3fQjGX5MyAWCzNR
	 T+P1UoUnr+rhJbBGQmQzVlYgr+svfy+Iz+zpWLDPzFxSQvLZGNhVZD2jsWFHfAQfKS
	 Bqx5vyaJUnp7fRkkcMb4QMA2N0t9dX+NgrOgENe02OraJL+dUvz6/V1eoji1jqK9cW
	 MBJl3KH5WjOMQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Michael Kelley <mhklinux@outlook.com>,
	live-patching@vger.kernel.org
Subject: [PATCH 2/2] objtool/klp: Only enable --checksum when needed
Date: Wed, 12 Nov 2025 15:32:34 -0800
Message-ID: <edbb1ca215e4926e02edb493b68b9d6d063e902f.1762990139.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1762990139.git.jpoimboe@kernel.org>
References: <cover.1762990139.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_KLP_BUILD enabled, checksums are only needed during a
klp-build run.  There's no need to enable them for normal kernel builds.

This also has the benefit of softening the xxhash dependency.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/boot/startup/Makefile | 2 +-
 scripts/Makefile.lib           | 1 -
 scripts/livepatch/klp-build    | 4 ++++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makefile
index e8fdf020b422..5e499cfb29b5 100644
--- a/arch/x86/boot/startup/Makefile
+++ b/arch/x86/boot/startup/Makefile
@@ -36,7 +36,7 @@ $(patsubst %.o,$(obj)/%.o,$(lib-y)): OBJECT_FILES_NON_STANDARD := y
 # relocations, even if other objtool actions are being deferred.
 #
 $(pi-objs): objtool-enabled	= 1
-$(pi-objs): objtool-args	= $(if $(delay-objtool),,$(objtool-args-y)) --noabs
+$(pi-objs): objtool-args	= $(if $(delay-objtool),--dry-run,$(objtool-args-y)) --noabs
 
 #
 # Confine the startup code by prefixing all symbols with __pi_ (for position
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index f4b33919ec37..28a1c08e3b22 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -173,7 +173,6 @@ ifdef CONFIG_OBJTOOL
 
 objtool := $(objtree)/tools/objtool/objtool
 
-objtool-args-$(CONFIG_KLP_BUILD)			+= --checksum
 objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 881e052e7fae..882272120c9e 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -489,8 +489,11 @@ clean_kernel() {
 
 build_kernel() {
 	local log="$TMP_DIR/build.log"
+	local objtool_args=()
 	local cmd=()
 
+	objtool_args=("--checksum")
+
 	cmd=("make")
 
 	# When a patch to a kernel module references a newly created unexported
@@ -513,6 +516,7 @@ build_kernel() {
 	cmd+=("$VERBOSE")
 	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
+	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
 	cmd+=("vmlinux")
 	cmd+=("modules")
 
-- 
2.51.1


