Return-Path: <live-patching+bounces-1408-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E7FAB1E2A
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F66BA02AC5
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC723299AAB;
	Fri,  9 May 2025 20:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owzxQTNB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CA1299A9A;
	Fri,  9 May 2025 20:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821899; cv=none; b=eqVpt3jOSvX3/UeUuD+RMz7HJVnCAivuN1qTna4t97FegK/2M/tkh1RCtMzjdGAzm28ZVE/5uJMGtU5QEhINp3y3/3DCaTscejUCY4hiPgSLmJ3ffglR4FbjhJ0xbZIbbe0X3RXv3+0CQsq/q9KL/JsKJlO2Et5WZZIBb8Sc5h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821899; c=relaxed/simple;
	bh=jdYcNiJ4B6/6kSPtg1OujZwbu87DFz7lbE7C4Irv4hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdxaZGADW9i1YVemhglwJmCx/R9NWerOGOt/8rRzNcfJ6DX2K3Tf7u6bTzVFdEA2jHDGam42jZvu5vMuo+T7qg/oWSZ2YHgjhVfIzluom5z5kQDKoH9Tp2I7zGpq0gkaYoSSJerPflVWbUbPI2/ZV4Ek/QNEsaqYNRuVqaQjaJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owzxQTNB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8610C4CEE9;
	Fri,  9 May 2025 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821899;
	bh=jdYcNiJ4B6/6kSPtg1OujZwbu87DFz7lbE7C4Irv4hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owzxQTNBcpm2lAhl0R162KDQ0SaTeLZndd4cjh5aRnhSHELuxE3IfITNc6PQ/OtK2
	 gUFAns6rf4KxpdntGc8B8+/NcmSsaCOl52VxVGbYWOcPk3B6tkV+kl/a0OTB5aCrzj
	 XxanOd2sRZEX/0hg3M5365u+iKqdZcrvPJIS36W5xOOdcoG+sAiuH+2MxjUtnjycEJ
	 d6fT5HYHHNNmInE94bcj3WGeE35LgrzXwpWv8L2Bs6BYTIXLncT3BWgET0kWLWKi4F
	 Rw+WoUp5m68ErvmJEtQ6IkWMX6gWjk4DvtofFiLM8cGr0lHPRTiQ1+24ImvHx3VNqi
	 ULsSknEiRv7AA==
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
Subject: [PATCH v2 49/62] kbuild,objtool: Defer objtool validation step for CONFIG_LIVEPATCH
Date: Fri,  9 May 2025 13:17:13 -0700
Message-ID: <0a12cca631dd6f4c55015e224acefb641b3824ce.1746821544.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, defer objtool
validation for CONFIG_LIVEPATCH until the final pre-link archive (e.g.,
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
index bfd55a6ad8f1..a68390ff5cd9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -278,7 +278,7 @@ objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
 
-delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT))
+delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_LIVEPATCH))
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 51367c2bfc21..acffa3c935f2 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -60,7 +60,8 @@ vmlinux_link()
 	# skip output file argument
 	shift
 
-	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT; then
+	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
+	   is_enabled CONFIG_LIVEPATCH; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=
-- 
2.49.0


