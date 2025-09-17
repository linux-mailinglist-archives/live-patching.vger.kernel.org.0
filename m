Return-Path: <live-patching+bounces-1689-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB2DB80DDC
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AE8E74E35B6
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B9B33629B;
	Wed, 17 Sep 2025 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKfZt7v0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA417336296;
	Wed, 17 Sep 2025 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125080; cv=none; b=Vp8/k88NGoDBLSb2P+yVz1RwC+weFrR3eykcaJjKAiYgW/5DWzVFXBwJOioxoSt+lwkJVnsQWCX6KbBSQjl+ghG9WWCDPt57VIZSG4jldMboA67ozMtY8iHrSnDAm9s37YffmhmWmKPVMwPGEyTO+9ygISbrj1+4VOpmeAmKPRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125080; c=relaxed/simple;
	bh=zzPXI2VpKo1Wco0KB6aiLbeXTtAcPdncQD6jWvFhB+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfhm4UjeOQFyEirY/bAPoYR9JcHGfsaG2r1xbZixY2fXe2PiONtDzVLc6W0Mc92zZ9ldJLepvkrcOEbUmQO2YkaC/goRyw08so2y5O0+wlQuz0gkVplBIbg1MwxIufO+MEsIhLEGWEy9KZ8tbZD83YZvTS+T5/GhkVdgEgLCyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKfZt7v0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBD2C4CEFB;
	Wed, 17 Sep 2025 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125080;
	bh=zzPXI2VpKo1Wco0KB6aiLbeXTtAcPdncQD6jWvFhB+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKfZt7v0z9SLsycCuc+yMzHd+ZPooY+FaRdTIYPV9MTQ4yuh68TISpjISizx0cfUp
	 xF+0mRda5fgDxubBQqnRjHiL5Qtn7QfkAz0FOYGcltzNQGAaYLpxd3H1t3Y2gHN3RG
	 VrKJuraWvRP5mRaKqDP1ZHc1/H6GvFQW0OLGCliT5dHQ+VEeg2qy4H79J33G3o6p+j
	 quFjg8ebg5oyIHksRucL2ZnXplg1ygpTjmKOyLol3rE6prsNoORMJBHA9bOaLmHpJP
	 A+jGZTmqkx5myEPqJZkTkzHJ3kIiQDozfJqzSC4NDsyDqzX2Eh5BSPotTHmVhgtgx/
	 cZaCPmNKj3o8g==
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
Subject: [PATCH v4 34/63] objtool: Rename --Werror to --werror
Date: Wed, 17 Sep 2025 09:03:42 -0700
Message-ID: <466225d69e1d91b7ffd333f999ea7f3cbc070e50.1758067943.git.jpoimboe@kernel.org>
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
index b955602661240..15fee73e92895 100644
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
index b024ffb3e2018..fed5200195df2 100644
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
index 0f6b197cfcb03..8e2047026cc51 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -101,7 +101,7 @@ static const struct option check_options[] = {
 	OPT_BOOLEAN(0,   "sec-address", &opts.sec_address, "print section addresses in warnings"),
 	OPT_BOOLEAN(0,   "stats", &opts.stats, "print statistics"),
 	OPT_BOOLEAN('v', "verbose", &opts.verbose, "verbose warnings"),
-	OPT_BOOLEAN(0,   "Werror", &opts.werror, "return error on warnings"),
+	OPT_BOOLEAN(0,   "werror", &opts.werror, "return error on warnings"),
 
 	OPT_END(),
 };
-- 
2.50.0


