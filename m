Return-Path: <live-patching+bounces-1538-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1A8AEAB12
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5B0E7B56CF
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093B525A2A7;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdEGmray"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D358E258CC4;
	Thu, 26 Jun 2025 23:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982177; cv=none; b=E/ciPwJ6LxWUzCByFXGwUqlnGHsw8hJnqB6KCxhli+RfTRImtGUXg64Ho8TG004eusBvM6NOnMNhzBQ7Tqp2eFVXcRP0IndxLVeydAVNL8x8XWxJ78+Wm6RgeHi9a76vR4LpE14kNCwVshrmfPTge89/RdP1OZn+B1AdDt5ZW74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982177; c=relaxed/simple;
	bh=J8WhknoQAqa4+U6iX36FxAI9Wkoq8PCgC13kVt4mfbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVvSYaAcudhEC7fBPHpFWYcAMTsoMx03pUW4tcbG3zswfIqUTPgGrEruCykvAMMcMfzFsQcUUTtciciPidK87MBBL7tgnmbMyFPVaszfACGQUtDOJnZQt6L2XYc1j8BVfjLFjQ9C+sXA9lPU08457Vdi4YJdOml7lm7vc60+0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdEGmray; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4304C4CEF0;
	Thu, 26 Jun 2025 23:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982176;
	bh=J8WhknoQAqa4+U6iX36FxAI9Wkoq8PCgC13kVt4mfbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdEGmrayOuOpSSbtxAGMvJC3209IyisOItGbLWk4qT7F1o390Wz7D92yiVSYsTZPG
	 JH+HwRAZe2gGG7KsA+QDgB2IQxQDK+XJJPniqWCAlK04TggwC4QkiFJ7bukfodmrCb
	 UqJatXjxj7EMJIKfYahwd7TTDo22U797EOWmTJ++NINPBisqJm/xdJLWD/o/ZlVUQb
	 40tGPeuPUs8asXNCtnQG+TX7/FmDctCSEr0I3MuMlw/1VHHq24PEunoZRWBVK1yHpE
	 5hIZl/vh5c1gxa3kptCwxb3ZYdnOWPyDuON5IY+15efemWJQhnQ/lT8V1VGWWgoaIP
	 sWmQsHDC2tahQ==
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
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v3 08/64] kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME
Date: Thu, 26 Jun 2025 16:54:55 -0700
Message-ID: <8c457bf0087beccb4d82b4672f2a2c163f1c22b7.1750980517.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, remove the arbitrary
'kmod_' prefix from __KBUILD_MODNAME and instead add it explicitly in
the __initcall_id() macro.

This change supports the standardization of "unique" symbol naming by
ensuring the non-unique portion of the name comes before the unique
part.  That will enable objtool to properly correlate symbols across
builds.

Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/init.h | 3 ++-
 scripts/Makefile.lib | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index ee1309473bc6..553a62f4cff5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -206,12 +206,13 @@ extern struct module __this_module;
 
 /* Format: <modname>__<counter>_<line>_<fn> */
 #define __initcall_id(fn)					\
+	__PASTE(kmod_,						\
 	__PASTE(__KBUILD_MODNAME,				\
 	__PASTE(__,						\
 	__PASTE(__COUNTER__,					\
 	__PASTE(_,						\
 	__PASTE(__LINE__,					\
-	__PASTE(_, fn))))))
+	__PASTE(_, fn)))))))
 
 /* Format: __<prefix>__<iid><id> */
 #define __initcall_name(prefix, __iid, id)			\
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 1d581ba5df66..b95560266124 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -20,7 +20,7 @@ name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
 name-fix = $(call stringify,$(call name-fix-token,$1))
 basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
 modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname)) \
-		 -D__KBUILD_MODNAME=kmod_$(call name-fix-token,$(modname))
+		 -D__KBUILD_MODNAME=$(call name-fix-token,$(modname))
 modfile_flags  = -DKBUILD_MODFILE=$(call stringify,$(modfile))
 
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(target-stem).o), \
-- 
2.49.0


