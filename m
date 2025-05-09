Return-Path: <live-patching+bounces-1367-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDDFAB1DDA
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA74217A7EE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546D32620CD;
	Fri,  9 May 2025 20:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHjrvu9C"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A82620C1;
	Fri,  9 May 2025 20:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821870; cv=none; b=G+0WDIMvPOVTgD5Osd/Frvwkzy9NeEf2KjdKYh4Aadh1wyJqJj3coFif2ZRZpBMxBFF7kfyvoM6NCjH6Zba2WQM4WjtyfQOCqPbVQA0yBOpnSxrKRAuggDahFf17RkxZiybvi1HclblhnHfh6wo4syx2m3/bGM5qsF8NSRmwFEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821870; c=relaxed/simple;
	bh=h1ZVvgJ7SeyvdOYpc1dBLJ7EzMoOiIdQTGbYi9xfN0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiiGDCWp7x93aqGYeeFETZQoGJzluyv3zizjrhEc6dJtIfxZ/oybuPab9UmO95eZePyQXl3P5AnMwXhlV+SwHA6OJ6xcTUWUbb8mZ7cz1gUD8HiIyo8WuvVkg7xFTt4VTNqXq/VeWul6sSKfcJMKxbxA5+Xv0egEplwn+ToxPR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHjrvu9C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F388BC4CEFD;
	Fri,  9 May 2025 20:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821869;
	bh=h1ZVvgJ7SeyvdOYpc1dBLJ7EzMoOiIdQTGbYi9xfN0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHjrvu9CqCb2+/G/dK5E3Izb3dcBcxO+bDQp9bXFwuDELFSiu8Rmm7VD1lcFbHCLO
	 1R+onqiLS3uEXTB5Zmm/QK2ddbbFPZrYfZHVD8UqkLpOjTsOcPoIr4qV+7O9T2V0iF
	 rhJMwONl28JJCF9NnKaF9T1s4kzWvhKfS4v8JjGtNxv/gbc4RZcUT/xL8QzzhggfK0
	 kut83eMXzzZnozuCqlHEUQQuHSQBD/eMzkUL2ygzdT4Mh20mfHlkIRNXPoiTTRiLHU
	 N4UsVb/yClbh7x8zQULictv3pUOLpphtwdKpwdloTJsr0DsGcr63XAotkB+3n3wb1v
	 CcXTUw9OHCWpg==
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
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v2 08/62] kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME
Date: Fri,  9 May 2025 13:16:32 -0700
Message-ID: <071a1b53fbed73dfd8ab321658af1f0c4d68b4ba.1746821544.git.jpoimboe@kernel.org>
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
index 2fe73cda0bdd..fb94e1ed1092 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -104,7 +104,7 @@ name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
 name-fix = $(call stringify,$(call name-fix-token,$1))
 basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
 modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname)) \
-		 -D__KBUILD_MODNAME=kmod_$(call name-fix-token,$(modname))
+		 -D__KBUILD_MODNAME=$(call name-fix-token,$(modname))
 modfile_flags  = -DKBUILD_MODFILE=$(call stringify,$(modfile))
 
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(target-stem).o), \
-- 
2.49.0


