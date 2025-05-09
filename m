Return-Path: <live-patching+bounces-1390-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F42CAB1E0D
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69D891C016E4
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08AF2920A9;
	Fri,  9 May 2025 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bd3Ltiqm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F8229188E;
	Fri,  9 May 2025 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821886; cv=none; b=rCAk7iNqf4u4uEbow85/P3xAusuNt71J8LrWVnbKYLewUf5EHcCJKGmXykxW9ycgx8P1iZarlOAvp835I2z3OrPm99bMuYQDvIumFuiDa4r7n6XQz90bFVPDgOsR12H90jNVv/FGkMitTbjDCiztnoi5rdiBtVvKa9PQ08RtpN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821886; c=relaxed/simple;
	bh=4dEdBQqKg96SIuMQ4R/7bsyOczgXLNxTXCnaDOxtU+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPx32AODDMj/MJtPklHxdfPeOYKppBjuw1HV2k7mSix01tROZEDoLNIMkWv6S5tr34UyugcIdvUgWbMyHZAgtP/32/L9CBwglXUTWI85quj1FfUboRPc6PzP/HUb2y/KUmxJ+S6BHX2BpBQZ3uZzPUXDKq6Wmh0lLxvEWAVdHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bd3Ltiqm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2913AC4CEF0;
	Fri,  9 May 2025 20:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821886;
	bh=4dEdBQqKg96SIuMQ4R/7bsyOczgXLNxTXCnaDOxtU+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd3LtiqmHR4yfQXPnlG2a6IGZEk75/F9WQ/qb+UDdnHs7UZc6ijKJ57otVRy5PVW5
	 QIvKQSQ5adnIczmNUSGUVWqM7J3ZwcIyh+24lee3CB/U54FUEkoSkVtFQptKu5F658
	 uINeS5l7P/5fTDw1hikrUA7iR311QrjBEhhjXEeaHF6YNq0hrN75RDhxCe/wsCbx1i
	 +MmssoHYEharGhRx10q4Du6w6gQ7/f9H7le8ov+w+1qOdRe2tKPSuqkWG0I/VEQV6d
	 KQ1goQk8tdhnxGJNPnKJtq9+AGKdtlDLA+u59szdMT/GbpI6IPqD0dVXVPKI4fk0Ro
	 ITM3ntU45fjGA==
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
Subject: [PATCH v2 31/62] objtool: Avoid emptying lists for duplicate sections
Date: Fri,  9 May 2025 13:16:55 -0700
Message-ID: <506d79489b610bde50f877fa0f67cf527b05cf06.1746821544.git.jpoimboe@kernel.org>
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

When a to-be-created section already exists, there's no point in
emptying the various lists if their respective sections already exist.
In fact it's better to leave them intact as they might get used later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c9f041168bce..3b9443b98fd5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -637,7 +637,6 @@ static int create_static_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".static_call_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->static_call_list);
 		WARN("file already has .static_call_sites section, skipping");
 		return 0;
 	}
@@ -853,7 +852,6 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".cfi_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .cfi_sites section, skipping");
 		return 0;
 	}
@@ -902,7 +900,6 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, "__mcount_loc");
 	if (sec) {
-		INIT_LIST_HEAD(&file->mcount_loc_list);
 		WARN("file already has __mcount_loc section, skipping");
 		return 0;
 	}
@@ -947,7 +944,6 @@ static int create_direct_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".call_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .call_sites section, skipping");
 		return 0;
 	}
-- 
2.49.0


