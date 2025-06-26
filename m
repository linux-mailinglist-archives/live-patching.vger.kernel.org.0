Return-Path: <live-patching+bounces-1587-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE03AEAB7D
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3CA13A68E0
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8262293C6F;
	Thu, 26 Jun 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ival/QGR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE224293C58;
	Thu, 26 Jun 2025 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982211; cv=none; b=JM6ZJFlmcIrOzcIl1mPc7WlrZ18ftU0B+RP3g59lc6fsD4ywLIidnkfKtyvx4+PCenJZdpOjao8gaQJiO6r8jl+saBFP0R3M8SndO5t5LT05xMxY1In3Xk8chQSbVLzm1p92TaCaNxQBexn0ATNSabozjQ3Mr+BXP+BIyotC9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982211; c=relaxed/simple;
	bh=Ft/SDFBoP1mGfNI3AHYATzlmZliEzR8uCXsFtlQ3RME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExdkBe2yURThUqzIu3I4t22PNuGPuLkynvfXqhc/OFSQWpCOBKCpSbixZh5zKqNzl8z+h/nnDCvMFDUg5vvWJVnqL/Hob3Ks8kGANHmGf2vSszM5fmcxtphoEvbLTIyvMv/Ix4UgHNlZPiBYmp11a/1/U3p63QnGGo0ybZIE8RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ival/QGR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DCCC4CEF4;
	Thu, 26 Jun 2025 23:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982211;
	bh=Ft/SDFBoP1mGfNI3AHYATzlmZliEzR8uCXsFtlQ3RME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ival/QGR0TnT6z1zvcGFcQU4RrudIBDzchswpKsfcH0W1b4DUOWi5KR31+tRoJ8Or
	 iDEI1tEeUfUlCRZyoOl9ilEG+o7YNH8lacTW74cwlI8viTvQ7BDt3UUt9werUX/Xne
	 NLUPGWIQO2hmn+3sqLBBMVvhLpan/3H0zrT6jMKy6kx5CwG1WsIlBK8fnpUQkyMf2h
	 6frw5XS4pzYvBokuc3L5r+RgFqEw6jJYYbnOkiHGz2o34GbvG9OWC6kw/Uj9LftxLP
	 4rsi50KzasFRbo/8aP3Tf2qsXQhHRP4PgyWX06i52VWpXG2ilQBEfxItr1YpWdOk0k
	 FrfMygguTDEfA==
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
Subject: [PATCH v3 57/64] livepatch: Add CONFIG_KLP_BUILD
Date: Thu, 26 Jun 2025 16:55:44 -0700
Message-ID: <38ab721002c42abe6664aeef25b4bfa095f6b101.1750980517.git.jpoimboe@kernel.org>
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

In preparation for introducing klp-build, add a new CONFIG_KLP_BUILD
option.  The initial version will only be supported on x86-64.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/Kconfig         |  1 +
 kernel/livepatch/Kconfig | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 62faa62b5959..448c6bfb71d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -266,6 +266,7 @@ config X86
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
 	select HAVE_RETHOOK
+	select HAVE_KLP_BUILD			if X86_64
 	select HAVE_LIVEPATCH			if X86_64
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 53d51ed619a3..4c0a9c18d0b2 100644
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
2.49.0


