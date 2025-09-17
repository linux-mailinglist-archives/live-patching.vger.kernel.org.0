Return-Path: <live-patching+bounces-1711-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4811B80E6C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FD777BBAAA
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D39343477;
	Wed, 17 Sep 2025 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8/YHrUn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47D634346E;
	Wed, 17 Sep 2025 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125096; cv=none; b=rPXlVWapwzPGgXyO8KiKGExA56NlyIEzJ6x7o61rYnDtoTtz5pbP0C/jFqmXzze0rHZ9jtMCfX1NLikaqMMWiGbozZ3Fvkb2ti6NS3tLphWNt98UdxMi1wYz8PxlKdtSWGPK21F0fzxiDng+LtAQT+E+j6y2CpCoqM2MAh7gOMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125096; c=relaxed/simple;
	bh=Pzen81aKxEDLsRdrYrpWtsjdpxscgWBdZGH8jyumvcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQPvvuMCcLloUnkkkcLFH43OaqsO1C8PahqgdNJJxFO3vA52VjaGdHR/RtvHrS2woDNWgEDZ7bPJcxhDqHwhPIWZBRNHTtHFtK9MgU/houlU3oVxTXYkSzc7zEpiyucxxvSJWG7Q4mZcwqLJFEqOK0zYtL/5moF6Rc2hSxte1Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8/YHrUn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92806C4CEFB;
	Wed, 17 Sep 2025 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125096;
	bh=Pzen81aKxEDLsRdrYrpWtsjdpxscgWBdZGH8jyumvcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8/YHrUn4RToAMXVN7ms8BSS2jSg7Sz4whadJupEdgg5JfbsiaH13vj7UrEv7lJa7
	 cXrpPWhGJhPAGKez7IDxm/r6Z4GYEByYuGl54mDzE98vOdB+WKqfR+aEunZv7VLExc
	 bwwcO86wuhbWHKvCwqxKpaT+pkXuZSv+GLc9J327+iUE9W+OJM9h8alN7LZ/NPxS9S
	 1gnCr8roQKwt1KzNv7bj9nUS3006MtLExWvBnrXMXz3YqF+JIKLioT5IoXY6iwzUFu
	 y2CPddnX+bzyo33HZDMs293gU6vWyKuUiHMUao9p/CB8OWAy7e0ZokCCw+be0nxbLT
	 IB5HUKPU0rWMw==
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
Subject: [PATCH v4 56/63] livepatch: Add CONFIG_KLP_BUILD
Date: Wed, 17 Sep 2025 09:04:04 -0700
Message-ID: <9240e1a1d47df784cdc2b2f7f0c4126455749843.1758067943.git.jpoimboe@kernel.org>
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

In preparation for introducing klp-build, add a new CONFIG_KLP_BUILD
option.  The initial version will only be supported on x86-64.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/Kconfig         |  1 +
 kernel/livepatch/Kconfig | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 19b1dbc8d5d26..986d31587e999 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -260,6 +260,7 @@ config X86
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
 	select HAVE_RETHOOK
+	select HAVE_KLP_BUILD			if X86_64
 	select HAVE_LIVEPATCH			if X86_64
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 53d51ed619a3d..4c0a9c18d0b25 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -18,3 +18,15 @@ config LIVEPATCH
 	  module uses the interface provided by this option to register
 	  a patch, causing calls to patched functions to be redirected
 	  to new function code contained in the patch module.
+
+config HAVE_KLP_BUILD
+	bool
+	help
+	  Arch supports klp-build
+
+config KLP_BUILD
+	def_bool y
+	depends on LIVEPATCH && HAVE_KLP_BUILD
+	select OBJTOOL
+	help
+	  Enable klp-build support
-- 
2.50.0


