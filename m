Return-Path: <live-patching+bounces-1664-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E00B80D55
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A24A07B3890
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7175C2FB619;
	Wed, 17 Sep 2025 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJ6w+b8u"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4966E2FB60A;
	Wed, 17 Sep 2025 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125063; cv=none; b=K/5jbIWwfpH08V3cLDc7GO8Puz7EsRvnrDeqNG2zmhYIk08aB0/QRlGqkdBsLstZ4xCUqJtgzH+gZ70S66Zh7bDejdn2G5rw3J+y3rH5EKWWA23qjUIZyEPx/n/e+5c7ryyjId7ZcuiVJVYBsRjzMK9qIt0Ajy/7gyuFfskIedA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125063; c=relaxed/simple;
	bh=p6t6SsnbM2chQrHSUF5FNb/6sSY2pvC9uU7Wbvcbwik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beswf7uBbl6MsWSRah2VXO7h8ak42QaKKn4AejPxEEYvzW7NL2wCeN1BX0VkpnoPiJuW5OCClVpqdXN+3Bfs0ZvQIRwc6UOupDwgjqfOoh6/MaVrbMJ7trXwdsBaP7cGOmy32xmtx3Kk2ZQCJ8vpTSkFSxUA45b+orYU0H94UWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJ6w+b8u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E40C4CEE7;
	Wed, 17 Sep 2025 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125061;
	bh=p6t6SsnbM2chQrHSUF5FNb/6sSY2pvC9uU7Wbvcbwik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJ6w+b8uMonJXZTFS8twd57ImoiO505u6vr/tRHsxmEnpkGmorPRED77fd/O8XiBy
	 K0XLVn1dINPW+ZWoQvOu/QceR68iaMXWrDkbwatzXGY8YL04CFt5Gvr1y4huV0mj5a
	 Q/1Z4yMmP2bKAEteOypcCnp0rzwN7jgAcTstugMtvBRGcdxAue+/Z6lJjG6fXvZ8Bl
	 lXxcsqp0JKG8ci8idGlN33aQCjLGbPuwnAG8hXbQcBPCZnArddU8uIopObXXkAohQ2
	 mVGJHvgpHmzs2veRZNUXIyOz/UEm9EEjBlM0gXBPpOWBIN9RPepRrBx1wZCwaYBEho
	 3KgU2uuJ2SBMA==
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
	Peter Zijlstra <peterz@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v4 08/63] kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME
Date: Wed, 17 Sep 2025 09:03:16 -0700
Message-ID: <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
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
index 17c1bc712e234..40331923b9f4a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -200,12 +200,13 @@ extern struct module __this_module;
 
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
index 1d581ba5df66f..b955602661240 100644
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
2.50.0


