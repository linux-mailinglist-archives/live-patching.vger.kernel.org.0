Return-Path: <live-patching+bounces-1588-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D13AEAB7A
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05B23189F943
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C2329B8FB;
	Thu, 26 Jun 2025 23:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/t7eQ+2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74E292B5D;
	Thu, 26 Jun 2025 23:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982212; cv=none; b=KJIZse+WyLJcL6J5JFxSmosE1VEiQy/wx5MiTgNze8I9bhh/9m28DtYhr9661H9loeXt6oY9nJCBMnlh3kQq3yO8+9qMihLBo+73oti4sxXwTLkwkPn4nfnq91ZkcHoty5w4gKEoeqiEnL0EwkGxT3F3cHLmZGHNfqxsvCG4H7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982212; c=relaxed/simple;
	bh=C3hl/octZq4mZ1MaR7e5EA/59I5YP/4wR5GptOcc2VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1zCdIKxtfvhOZumZQt5ZE0SrpAXmRpV3M8dRFIEQk5+8J2mJ+3mfG7S01/jtEJHNmDpsBRLbfIGWmYq2MERYI72cCVy4yzfLetLWq86JsVrgOS4Has8Zaw7pXcnIqcH2qgtTBFM8hPUQ68ZQfyUPDoNjwakf2GmHrdWlMhhTjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/t7eQ+2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A62C4CEF2;
	Thu, 26 Jun 2025 23:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982212;
	bh=C3hl/octZq4mZ1MaR7e5EA/59I5YP/4wR5GptOcc2VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/t7eQ+2Z8qeo7bVcAzOCHHXYZK1yKXsiLvUHHLOGDeqwFu90QclsRX6a8yucVSlt
	 VNpLhWSRgsRIQLbW0G0dc+OPvsg5xeWH/3yspo5smZUTHNRSJ/WNPRrePburBKYspN
	 kfAtOWA7DcOl42X+rmDp8vU6yaKhk/dKpCkUFF8Mz46FEt8SfTuleY44C0yyOwgrrK
	 4oYinsGT4WL6OGgQQy58w12xs/h+zVLFkoR05IRRj02JpzRxxJ2bV+jNY0hrjOoJ4e
	 x6bx3P3EMOjnm7x9seyB1/CPbpTFfaIhhQkj2VOcIbfAo+Hwtgzu9mZ3qx9rjOOPDI
	 PF9v9TJm80O9A==
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
Subject: [PATCH v3 58/64] kbuild,objtool: Defer objtool validation step for CONFIG_KLP_BUILD
Date: Thu, 26 Jun 2025 16:55:45 -0700
Message-ID: <d83af9f86f2f7a24096d4ea0ddd78574fef9a5d3.1750980517.git.jpoimboe@kernel.org>
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
index 15fee73e9289..28a1c08e3b22 100644
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
index 51367c2bfc21..59f875236292 100755
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
2.49.0


