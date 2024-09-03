Return-Path: <live-patching+bounces-543-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2CEA969279
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21F231C224C1
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E9C1CFECD;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qge5XARI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115831CFEBD;
	Tue,  3 Sep 2024 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336034; cv=none; b=DTvEv9p/PSDt7KpsfIUR3+lGPEMf9eX1sQTBHM1vW8no39FvynLDgIAca7yHM5sMZsxqJiV9DvBVXIjrcAb8ZhI7H/OuyUEdsxTt5c5ymP4fkoH5IsAQf7s+QrHjmbFu8QqIKi+mNEKw8h2bXo5NOnNykWctUUOlqZsPDTipfvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336034; c=relaxed/simple;
	bh=BQEb3OPU43WZ4vRis1H8WUXjg0vebOt0ENV2ilISPVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlZx8lnyisU6CpKdxa/WPbJ48KxstksfzLQrCjoVoNJx55HBrVyib3xMoemmOW+OPhIOV9bHX3fJH9ifdob5MGVS4jsRGBC+soDSSH35PGTXKmQwtHfTpNzPtP/Db8HI4PkacU9dtm0NcC1yWBSW4bVP2TNmM4XUadgqfGmhYAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qge5XARI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F3FC4CEC5;
	Tue,  3 Sep 2024 04:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336032;
	bh=BQEb3OPU43WZ4vRis1H8WUXjg0vebOt0ENV2ilISPVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qge5XARI/yOoOY6J1JgB2tTtfvKuivdFfE6B8iqOBP4UyMZ4ilV5hwnA2Gd8TC8w+
	 OS1JMJ0fEELc1T15Z4VpH1eMSEsAEmE6LQGVx4GQIiLhsA9RMzIps8/RMuSaSPLK38
	 eyuTWIoq9Gr/WtiTCwqcJTcLORwO8VFlJjxG+NwNAoOtsyo35syb+7Ml1FNj0W6Jqh
	 NeT2rGF1XC+s6595wFniyPWEosh37VUm5nAdlqEWjUe6oIvw9th8nVZYM741vd0ci2
	 VeosnEoFofdwLgPPU3sGUJVba9lq/j4+aWS3rBrtl5G1PQUi6dDxnD4kAEMSl5HwM7
	 ndPY+tr0juzLA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 07/31] kbuild: Remove "kmod" prefix from __KBUILD_MODNAME
Date: Mon,  2 Sep 2024 20:59:50 -0700
Message-ID: <d781bcac7ddd4563ed7849b5d644849760ad8109.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the arbitrary "kmod" prefix from __KBUILD_MODNAME and add it back
manually in the __initcall_id() macro.

This makes it more consistent, now __KBUILD_MODNAME is just the
non-stringified version of KBUILD_MODNAME.  It will come in handy for
the upcoming "objtool klp diff".

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/init.h | 3 ++-
 scripts/Makefile.lib | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 58cef4c2e59a..b1921f4a7b7e 100644
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
index 9f06f6aaf7fc..8411e3d53938 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -130,7 +130,7 @@ name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
 name-fix = $(call stringify,$(call name-fix-token,$1))
 basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
 modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname)) \
-		 -D__KBUILD_MODNAME=kmod_$(call name-fix-token,$(modname))
+		 -D__KBUILD_MODNAME=$(call name-fix-token,$(modname))
 modfile_flags  = -DKBUILD_MODFILE=$(call stringify,$(modfile))
 
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(target-stem).o), \
-- 
2.45.2


