Return-Path: <live-patching+bounces-1771-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB950BF2D07
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 19:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80FE6401686
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 17:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C0F330B38;
	Mon, 20 Oct 2025 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9GSvqsr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D012D94B4;
	Mon, 20 Oct 2025 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760982850; cv=none; b=mXUDMoBSMsf0xBTsu6AQAZVCoQwCZGBrm2/gIGUCwYm/FreDX7gt6MCkR8obOdhcbtTIcdJSRzOFzo6SlnoPu4PNKAlYXNHt+hGGFj9BYWvsMgtzH1ZMaknTPzBk6xlm/zu+tIYYJVywG8TRHe/AXBCkzkuxrsmYcBHnasZhOeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760982850; c=relaxed/simple;
	bh=W9Q/9dwn0h86HXDHG358xCGj+ZGwS3vc5Ixmi2iD/rk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gRigte3XqfEZh/gGoYAbzW3piL6uymkutOCrDoqMx7iGXKiTwxAn9mMiYbJv3EORnIvZYhCKShWHCtMm99nEpY9sKRYdorWOYh9KVbUsYt+rgqcFX+MKXgl3GG3B6iWLX3uMrb7dWBWlQwAdqxhQnXaQ7ss3Ncbivog9WGMNIes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9GSvqsr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E212C4CEFE;
	Mon, 20 Oct 2025 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760982850;
	bh=W9Q/9dwn0h86HXDHG358xCGj+ZGwS3vc5Ixmi2iD/rk=;
	h=From:To:Cc:Subject:Date:From;
	b=o9GSvqsrrkBYtGFIQS7hjCb4B3q8prvkuUHnqv0Ei1X8WgjTgcxI5PrUIby/HhzyH
	 7VyXj1z8YJbjJe5LW0bejXCibBAZoZQgR7kBWOmBXjkCpLi4k0INLU3rbyg+8C9lNJ
	 Ig8WPyQH9k0OHcyGuOzAOAbyTRUuHidqJpddzTr90ET02+6Gwpefa6WkOykTo76Ta7
	 tFuCAjqOy0cM5Tvsy9wXMqGTWYtqQybIf3rFqGiihFhV1JgLXsY9z1AVrmkL6l2y38
	 OZTB4oOm/JQsySlpugWgDZDJ/I+h+lYrcyn5tN9L2dfiEPml5nIapok7mLsaN6qfsR
	 ofa568azqcp3A==
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
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Cosmin Tanislav <demonsingur@gmail.com>
Subject: [PATCH] module: Fix device table module aliases
Date: Mon, 20 Oct 2025 10:53:40 -0700
Message-ID: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
__KBUILD_MODNAME") inadvertently broke module alias generation for
modules which rely on MODULE_DEVICE_TABLE().

It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
MODULE_DEVICE_TABLE() to generate a symbol name which no longer matched
the format expected by handle_moddevtable() in scripts/mod/file2alias.c.

As a result, modpost failed to find the device tables, leading to
missing module aliases.

Fix this by explicitly adding the "kmod_" string within the
MODULE_DEVICE_TABLE() macro itself, restoring the symbol name to the
format expected by file2alias.c.

Fixes: 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME")
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Cosmin Tanislav <demonsingur@gmail.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/module.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e135cc79aceea..d80c3ea574726 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -251,10 +251,11 @@ struct module_kobject *lookup_or_create_module_kobject(const char *name);
  */
 #define __mod_device_table(type, name)	\
 	__PASTE(__mod_device_table__,	\
+	__PASTE(kmod_,			\
 	__PASTE(__KBUILD_MODNAME,	\
 	__PASTE(__,			\
 	__PASTE(type,			\
-	__PASTE(__, name)))))
+	__PASTE(__, name))))))
 
 /* Creates an alias so file2alias.c can find device table. */
 #define MODULE_DEVICE_TABLE(type, name)					\
-- 
2.51.0


