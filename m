Return-Path: <live-patching+bounces-1541-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0F7AEAB17
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 254EB4E3A48
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338D825D209;
	Thu, 26 Jun 2025 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3KsHb8o"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082EE25C83E;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982179; cv=none; b=ejlmx4pxgHLoxdlqXg/BVgG/RIzSHvkRWfUwmaLzLgC13F32uvrrTrUGisSguVx7adoHrSa+3Ttdx3wjQnK8ZRmxBgZDKPDk5ki0FeReV7y8ZFxjREWLQsU+UHSdFS6DavGHEdj+UATP1xQts34fbp4GEGLZBnwyg2zWpzasCLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982179; c=relaxed/simple;
	bh=6Idgt0dRrvx6JcsNx2dFuGmAHsQkiymEL/xdABXxvA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DziA52TMHFYJc7u303ZEh9BkqHzoGs2DOsRMbPwjnEfCkFOHwj+4wBZmk6JWt1sRhA+q1aqRcwucaMoG4jrQ8LLgQTP2CvRx1tg4AJdSc8YgYbSc9Bo2vua6ezDOaTseujz8hIV4yKGFnjq1Fbgx+fHxBv024pn+xGWXVKkpq5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3KsHb8o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E27C4CEF5;
	Thu, 26 Jun 2025 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982178;
	bh=6Idgt0dRrvx6JcsNx2dFuGmAHsQkiymEL/xdABXxvA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3KsHb8oKuK750AgCtnHQMYTmSd6Qhqgzj8H17A4uttj8ZVFolDTayB+s6zWU1kJa
	 9BtY/u+eZw1Jap1fRUaZzQ3V6Kx/oERIwmJ2VOAJzFtQHys1mANKnYN5dsR8WDer5J
	 Q9AGfNlfrUot1sNk9O/MZN2l6hzRh+NcWyXvJGfc+QeEADVreQBbW0tKJxu0bADtqB
	 yEIyhDU5Ma/GoTuJmcTDfzxuREC9GkmC1FoLBRPhAOeQ2XPGhkfeZRNrhPpl6+Q5p8
	 SmYrwFh+IlM0o53z4HXkHdj7ntF6bEW49tVP+vHp2BAZBMiHIylPPjyu7dXuyfsXu/
	 DuR6GvNvhiwNQ==
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
Subject: [PATCH v3 11/64] objtool: Make find_symbol_containing() less arbitrary
Date: Thu, 26 Jun 2025 16:54:58 -0700
Message-ID: <4afefca1066b8600d82f7b2dd9f6e3c2922884bd.1750980517.git.jpoimboe@kernel.org>
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

In the rare case of overlapping symbols, find_symbol_containing() just
returns the first one it finds.  Make it slightly less arbitrary by
returning the smallest symbol with size > 0.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index ca5d77db692a..1c1bb2cb960d 100644
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
2.49.0


