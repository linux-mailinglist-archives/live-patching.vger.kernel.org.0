Return-Path: <live-patching+bounces-1561-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1E0AEAB42
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C3A57B4E67
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5184273D92;
	Thu, 26 Jun 2025 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2W/S0iq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4B3273D86;
	Thu, 26 Jun 2025 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982193; cv=none; b=YlAbK6+T8k/ooVz/WcLz9EP1Anwqn4x8u+dLJdt/HFZAJsds3KG5ueUfYh48T5aJj6ziCbKRUQGxgj11ZAIuCvX+2e9xmpZpU/qomGrXNkJzmW9OIj8zuLhdoa9JI2a6uadLkqGu2xJlfBy3fvflgHcdtep9b+fvTB3gABYzC4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982193; c=relaxed/simple;
	bh=4SZwZ/7aFNERBoTGQkqoQOjlFFRUHY91U+y9sTDfXU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8C5ncsVLOV/1mG0U6TCk8s9BG84hxl5i465RGeffNCT+RSacM+qydMGqD4B3+4Kc7y+c7d0LmKqTlteAHd7yWdDiRXYqilJIErTukUEXmwFsmKoq2R3HKgx7rMfiKKu/cgNxAfc6lf6FXwBMFX3yJb0EliKsowqKpEEEWkOplI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2W/S0iq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DFEC4CEEF;
	Thu, 26 Jun 2025 23:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982193;
	bh=4SZwZ/7aFNERBoTGQkqoQOjlFFRUHY91U+y9sTDfXU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2W/S0iqH9Vnz/1prL41p8/gNHbaaGplYVR85T035+2RJE6Mce94w9C2bdXcP1uhm
	 M4azDbQ58Na8anJuHQo49yErVeiCHLyFtgK82TD2X9I6zq9KvQ87opdAXWXEbykI9K
	 tS0XrCU1DjsB4PECIVi1WIIzp4C0pMxnoXDewfolcYnL7XMDogZ7+CIsbhbRTB9Spw
	 3RI+72fhzSihS20OZi5ISLhPmD8mM2B6cwqzcLo5d4n0cx5qTNd3fxAmlQWWuEB6eF
	 VrasXFpDzGV16qzLKk+hRu/kg1eML71h8EAbPb/pCOIWX0kjxIcN622CKdNtcuG6EV
	 uUWU6ApSA6OCA==
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
Subject: [PATCH v3 31/64] objtool: Avoid emptying lists for duplicate sections
Date: Thu, 26 Jun 2025 16:55:18 -0700
Message-ID: <ee0570241895ca7fba2b31f094a66b1af45adafa.1750980517.git.jpoimboe@kernel.org>
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

When a to-be-created section already exists, there's no point in
emptying the various lists if their respective sections already exist.
In fact it's better to leave them intact as they might get used later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9ffde9389c53..87d2ba7739d5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -634,7 +634,6 @@ static int create_static_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".static_call_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->static_call_list);
 		WARN("file already has .static_call_sites section, skipping");
 		return 0;
 	}
@@ -850,7 +849,6 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".cfi_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .cfi_sites section, skipping");
 		return 0;
 	}
@@ -899,7 +897,6 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, "__mcount_loc");
 	if (sec) {
-		INIT_LIST_HEAD(&file->mcount_loc_list);
 		WARN("file already has __mcount_loc section, skipping");
 		return 0;
 	}
@@ -944,7 +941,6 @@ static int create_direct_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".call_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .call_sites section, skipping");
 		return 0;
 	}
-- 
2.49.0


