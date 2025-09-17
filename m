Return-Path: <live-patching+bounces-1670-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C47DB80D80
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABFE81C220B7
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315D62FD1A5;
	Wed, 17 Sep 2025 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ush6UBoG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7F22FCC17;
	Wed, 17 Sep 2025 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125067; cv=none; b=PXDolvOqcy61AnZEc6CL8mDGJXYCWThj+2QGYRrJKejabAvUSxKgVsRRxLQOWmjTw14HW4IDa8HYRLfRTXNjc0WgIZp0HNpKzGw/ab/hyuIOpO7ryqDrGRENo68yNAl1/bELzUfPBKFuCq/FIUQpiiFzPulq4yfrpvtIy40jXAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125067; c=relaxed/simple;
	bh=FEuGGqp7EQ+m4KSpW2oWnEg7GiC0+WGYaWwZBkAbIPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gotF6JB75wFx5O+uoYirW1rDOpJBxYaG0OWdUvsJ4kEgc1YLvc3nwYmWmR8oi/Pq3pAIvrqIu7I/kzRhJ8vT7xmUGhAJFO/YYXgAZCR5k5h3PFCHYwghOsxvUkfVrXZxt/Jh3auvsJRmwWU82Or0XRAw1Mq7rX1sKl8bEurS0N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ush6UBoG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD87C4CEF7;
	Wed, 17 Sep 2025 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125066;
	bh=FEuGGqp7EQ+m4KSpW2oWnEg7GiC0+WGYaWwZBkAbIPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ush6UBoGzqYsE2nkRhe5CZsEZL/xz1nT68MTTu+fsmIkPQsJqnvq4n9KOPs9J40El
	 JTE1NSJJ1eY8UyUzAiQoRbNgyyTryELMmlqrngtOQJo1cAh/NqctQO7MDk3T7FDO+p
	 jwwfjDZpeMY9ibG+s+xUyn4ImGLlOOGVJq3JABcs0dwtdtPSiJ1iGaGA6PDkAmaaIO
	 26HXRlPNCAJQR9EQqG1peCtLf7j0/vkWeRQaC+ga81Und4rt+mBsDIk08MOagoYOyp
	 UsFppbAlwB9VmUr+oGT3a2TPZiiIfTEsMHbSKzRNJUSLwajSGZKz/MTXEEdAccTdAy
	 eBbI8fmxLIfsQ==
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
Subject: [PATCH v4 15/63] objtool: Propagate elf_truncate_section() error in elf_write()
Date: Wed, 17 Sep 2025 09:03:23 -0700
Message-ID: <306f67f2f6762f80c9ff72afd363f97535b1a4b5.1758067942.git.jpoimboe@kernel.org>
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

Properly check and propagate the return value of elf_truncate_section()
to avoid silent failures.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index b009d9feed760..19e249f4783cf 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1307,7 +1307,6 @@ static int elf_truncate_section(struct elf *elf, struct section *sec)
 	for (;;) {
 		/* get next data descriptor for the relevant section */
 		data = elf_getdata(s, data);
-
 		if (!data) {
 			if (size) {
 				ERROR("end of section data but non-zero size left\n");
@@ -1343,8 +1342,8 @@ int elf_write(struct elf *elf)
 
 	/* Update changed relocation sections and section headers: */
 	list_for_each_entry(sec, &elf->sections, list) {
-		if (sec->truncate)
-			elf_truncate_section(elf, sec);
+		if (sec->truncate && elf_truncate_section(elf, sec))
+			return -1;
 
 		if (sec_changed(sec)) {
 			s = elf_getscn(elf->elf, sec->idx);
-- 
2.50.0


