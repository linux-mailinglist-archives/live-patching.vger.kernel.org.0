Return-Path: <live-patching+bounces-1370-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 104EDAB1DDF
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67484501498
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B79A263C77;
	Fri,  9 May 2025 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rf1iBl+H"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ED2262FED;
	Fri,  9 May 2025 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821872; cv=none; b=oAvWILNSCniCCMd801Ia8NY845KDEIvFKGrZ5GrA+VgphnNoJtW/psdAyxB5YAIrwZxmkVmGzjGIRpLZfJNvE5imfdVyZU5MB918/aVnvftsqb4L5Qmgm++ZYYhERqTHyGjxZItGIkO7NYMooVPmaWXfeEEvq48L6bSFBR6lwv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821872; c=relaxed/simple;
	bh=LDUKcJdT8kH8BjUeYhtSNqXt7nIhVlc4MqtNBfwYqyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnECaXH+Zc98hnrfLpmEsVI3iGd6CnS6H72zv3nwuYWR07WuQdJk4SDrEjZ+VyzXY99ui+T9PR/8n9ZiQgKFBKbS0WRtCelz3VXdSlEdLZb8OVm7/sbpAxoQTIDtaacw5sKteDdna7EcPyVVcZqMZ3zhneGAwpqOZiinCb43emk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rf1iBl+H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B52C4CEF1;
	Fri,  9 May 2025 20:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821871;
	bh=LDUKcJdT8kH8BjUeYhtSNqXt7nIhVlc4MqtNBfwYqyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf1iBl+HpDRgdOTBIBu3Fml6XJxx7FFMFnr4l4LXlYiU9tVDUdFJBOT9qH05Z/hsY
	 qYB7hkOKR5LmSKHSwrndV6t+SAdQdrzv+fNd+FEQ83kMGamgVxXvhU4yG0RGe4oAEd
	 OYHrwCWZYsFzWDTYiFHwG10JKBDA/qsRtZ/rQJPByCMlg+xOGVyQgTFlz0u+hbfAOy
	 VMEPF2AFedtH/jE+mTzK2NW776gu9KSeAqWCPe+Bdw4yWLh76l7JceorJiZNuOHZpW
	 icLom8m+NQWZWlKio+otwzdVBEcfc6yfh1cxNHN3UY/AWX3z1c0ps2HaY8O4R3xX+e
	 T841Xo1E54B9w==
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
Subject: [PATCH v2 11/62] objtool: Make find_symbol_containing() less arbitrary
Date: Fri,  9 May 2025 13:16:35 -0700
Message-ID: <bb8f2cae0bc531529e2107eb1eccae6a35cc362e.1746821544.git.jpoimboe@kernel.org>
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

In the rare case of overlapping symbols, find_symbol_containing() just
returns the first one it finds.  Make it slightly less arbitrary by
returning the smallest symbol with size > 0.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 8dffe68d705c..bc24d59360df 100644
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


