Return-Path: <live-patching+bounces-1392-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67002AB1E09
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFBBE98795A
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C039D2980A3;
	Fri,  9 May 2025 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqnNoE35"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977A4297B9F;
	Fri,  9 May 2025 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821888; cv=none; b=B3BRVJnLCf1QUAFg0mxMT2tFDYSaolxxLdSxRPp1fuDF6aF1csYBdHLnJ3SlFeIFTV/zXPc4iv/xd7L58+O/NzKBEjl83ku5vzqTzLbIGYmCaGpc+KkjLiFp2Js+7xoL3LQh4G1/duz1T3wvCaXTRvZRPhr6dqPTBz7Q96uqSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821888; c=relaxed/simple;
	bh=Kja++anVa4TZR4hAtZTrGisJVRyVD27NbML9IybK2mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EazStoARMU+C4O7xW5U2vSULHFASxn57h3dcNOn3UWXY8hjE9b1s0icbY+PCNYWt577mKCS8m3txMUhcmI4eco+QN08WX4uk1aKTOcYT+U+B1X0H2QJdRYU038ZFcRJejcyyAotaR42YTEVIFzYSgjr3ElmJokbY8bYURy85waw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqnNoE35; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C0C4CEF0;
	Fri,  9 May 2025 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821888;
	bh=Kja++anVa4TZR4hAtZTrGisJVRyVD27NbML9IybK2mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqnNoE3598sTsOxjNaC/uRmaDYK/WE8uBSPx6HUE1EKp4eP2xBiqFl/aXpkRlnBUo
	 sIt0Wq/iE6zaxlbIPTOKubZcvoPoyGzGJwGSj7WLci2JapAkS+KFvhzgJXx4dB4zkO
	 /qNcG9TSbPkJMADfX8OFK8reVFR+QL1rz+GyyVG2OhJeV+v8XvkdP/zwdC8Qrqyl0Q
	 VJlcaPbQJI9BqaLyPkXg9Zh4X2hwRY88vqak0R+TwZjG5kdlPTy8fPSNcbhDzlm7wE
	 fo2vQiz2859Blu3MFXXqKJDf6mR5AN05jx/YVKazaz7DsWY6wogSmdez9P2xoQU+yH
	 sVRtAuCLXN7QQ==
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
Subject: [PATCH v2 33/62] objtool: Rename --Werror to --werror
Date: Fri,  9 May 2025 13:16:57 -0700
Message-ID: <a6bcc11cf3957721ee604c3c4981d511f4f67ff8.1746821544.git.jpoimboe@kernel.org>
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

The objtool --Werror option name is stylistically inconsistent: halfway
between GCC's single-dash capitalized -Werror and objtool's double-dash
--lowercase convention, making it unnecessarily hard to remember.

Make the 'W' lower case (--werror) for consistency with objtool's other
options.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/Makefile.lib          | 2 +-
 scripts/Makefile.vmlinux_o    | 2 +-
 tools/objtool/builtin-check.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index fb94e1ed1092..bfd55a6ad8f1 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -272,7 +272,7 @@ objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
 objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
 objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
-objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --Werror
+objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --werror
 
 objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index 938c7457717e..7562cdc73dc7 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -41,7 +41,7 @@ objtool-enabled := $(or $(delay-objtool),$(CONFIG_NOINSTR_VALIDATION))
 ifeq ($(delay-objtool),y)
 vmlinux-objtool-args-y					+= $(objtool-args-y)
 else
-vmlinux-objtool-args-$(CONFIG_OBJTOOL_WERROR)		+= --Werror
+vmlinux-objtool-args-$(CONFIG_OBJTOOL_WERROR)		+= --werror
 endif
 
 vmlinux-objtool-args-$(CONFIG_NOINSTR_VALIDATION)	+= --noinstr \
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 80239843e9f0..43139143edf8 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -100,7 +100,7 @@ static const struct option check_options[] = {
 	OPT_BOOLEAN(0,   "sec-address", &opts.sec_address, "print section addresses in warnings"),
 	OPT_BOOLEAN(0,   "stats", &opts.stats, "print statistics"),
 	OPT_BOOLEAN('v', "verbose", &opts.verbose, "verbose warnings"),
-	OPT_BOOLEAN(0,   "Werror", &opts.werror, "return error on warnings"),
+	OPT_BOOLEAN(0,   "werror", &opts.werror, "return error on warnings"),
 
 	OPT_END(),
 };
-- 
2.49.0


