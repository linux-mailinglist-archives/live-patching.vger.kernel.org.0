Return-Path: <live-patching+bounces-1563-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F09EAEAB4E
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39B1B3BD6C7
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F64F274654;
	Thu, 26 Jun 2025 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z45iqBsM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D78273805;
	Thu, 26 Jun 2025 23:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982195; cv=none; b=tSJXXpSkHbMZqCKctc0e0fyzkhl6FFX+F9lY732obMjaiqO9DLojNyVkD242kDxtBt7xfItxLwK8TNvyBOlYYEzhat5C/C3RASV9UMkVGuSLJfE+UZyHrH3Ud5PxQFq1w12MHzdtZl1o80IgKwC28FGht0BDcBrImUOg/MBCLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982195; c=relaxed/simple;
	bh=wVKJOa8t84i1UrAh4i3YFSXeCiZsVGXBaE7D7hL+Zn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4G32hgvuep51pVS5yoNZ3NZROF2fq2fc6K22b+h2oa4NhymJCjJGWos8A+O+hAP8ZXpa98I/K7fgFmYkYc3o4rQlTHgbXbOcxMJQZdNwKKNeex6cy4CVeSw2iE79k599E0FxFD1ZDLLcTgIyIqLZ9iyO4J56tlxPEJj7lqC3t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z45iqBsM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B60FC4CEF1;
	Thu, 26 Jun 2025 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982193;
	bh=wVKJOa8t84i1UrAh4i3YFSXeCiZsVGXBaE7D7hL+Zn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z45iqBsMN/DuaqKI0hU1kdV7Rvp6uIuFR3+Lo1EGn/zM9lFIt9/oTnnwc/CD+Tpjv
	 J3yfwCDNERTg798PNS65xxhK9B3HHJfB9hycdHeooP8mZora2k1n9aWs1uUHlutcml
	 PonCkv766j+xopRSMXchoppuIdqGQyuhIfL7Uk1xl/mqU/MSD67W7nIQSUEBuxA74M
	 WZA/JYxUeeo5kXsYy+Vavy0W2DkQ/SZFzxw7XZFP634ZPRpQPqQ3fAKkWpE9ZY7nU2
	 XkNF9NpvEYF9pzY7toioH/Cb2zc0PiMK8T8mxiP0Cj5XGO1dcPkCtPvmarjZczNpq9
	 E4Qb8BljDsf2w==
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
Subject: [PATCH v3 32/64] objtool: Rename --Werror to --werror
Date: Thu, 26 Jun 2025 16:55:19 -0700
Message-ID: <66c5e0958f494953647e7b060c224441aa5f859f.1750980517.git.jpoimboe@kernel.org>
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
index b95560266124..15fee73e9289 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -191,7 +191,7 @@ objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
 objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
 objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
-objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --Werror
+objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --werror
 
 objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index b024ffb3e201..fed5200195df 100644
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


