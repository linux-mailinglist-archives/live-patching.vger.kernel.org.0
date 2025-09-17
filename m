Return-Path: <live-patching+bounces-1668-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 055D9B80D73
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 300B67B452D
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD1E2FC865;
	Wed, 17 Sep 2025 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8wVUvEJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E3C2FC02A;
	Wed, 17 Sep 2025 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125065; cv=none; b=uJV+Sfqp41p3eV7/XSgh3hpgx/OHlDcTkFhjGRGny9vXLiXJY6s79Q3qbCJwpI93hEY64X9JlehAcL3mT7tiIba1INSx4GT+viLnSmAqPbO9dLfW5DuvKEFyVWQtLrv2CDxrjkPyxDbmKlTtLbpmHx6K+lffk9TlDa78x+smz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125065; c=relaxed/simple;
	bh=7sV+gDz90cwGROva10A+mlFzqYKEHIUn+PKA8yjd478=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CH+J2GUONW/ndYL9SOVHbwbMHc+yRog8dH08GgVF3O24CBgNF5XAI8N7qKBnZZb9b4X1N6/7bShZT4vI/8rL3uDNBLt0K2wiK3wP4iLNrG/4YH4N3rSkdAylnWen157p0V1N+wDcKfm+ZzS2oFAxmyT0BZKA7qTz7kh6R8jox8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8wVUvEJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB391C4AF0D;
	Wed, 17 Sep 2025 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125065;
	bh=7sV+gDz90cwGROva10A+mlFzqYKEHIUn+PKA8yjd478=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8wVUvEJdduYFYCfZtWcihOmX2O19xE0+0kMZhOYcqmuyqqXJSbFQGBdy4O4oegof
	 lFFxUB117SYWE+OPazk6a2VECBd5i1EWkTSXqSpX/fsid2Rk0ZvgmK8ldfK74KyQ//
	 InNdd3ugA+owDMZQ3dbSBTwTZL0YEKSSZGwNyjAatNRv7d0ksMi8O9nSmy2vFntJlZ
	 xraa7lGxuY+dRLJ20trY7GBamI2Uz+JyW2LLqNKcADRJZjk7c47SF7EPSvULm4FxQD
	 iKoyrOVxI5qiTh8n+iO1bxO8vFPd/MALdGxHHvahekW8Izv5CnQpqidhYQp0quA5FM
	 CdY7tVfwCWpAg==
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
Subject: [PATCH v4 13/63] objtool: Make find_symbol_containing() less arbitrary
Date: Wed, 17 Sep 2025 09:03:21 -0700
Message-ID: <9500b90c4182b03da59472e1a27876818610b084.1758067942.git.jpoimboe@kernel.org>
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

In the rare case of overlapping symbols, find_symbol_containing() just
returns the first one it finds.  Make it slightly less arbitrary by
returning the smallest symbol with size > 0.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index ca5d77db692a2..1c1bb2cb960da 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -193,14 +193,29 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset)
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset)
 {
 	struct rb_root_cached *tree = (struct rb_root_cached *)&sec->symbol_tree;
-	struct symbol *iter;
+	struct symbol *sym = NULL, *tmp;
 
-	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->type != STT_SECTION)
-			return iter;
+	__sym_for_each(tmp, tree, offset, offset) {
+		if (tmp->len) {
+			if (!sym) {
+				sym = tmp;
+				continue;
+			}
+
+			if (sym->offset != tmp->offset || sym->len != tmp->len) {
+				/*
+				 * In the rare case of overlapping symbols,
+				 * pick the smaller one.
+				 *
+				 * TODO: outlaw overlapping symbols
+				 */
+				if (tmp->len < sym->len)
+					sym = tmp;
+			}
+		}
 	}
 
-	return NULL;
+	return sym;
 }
 
 /*
-- 
2.50.0


