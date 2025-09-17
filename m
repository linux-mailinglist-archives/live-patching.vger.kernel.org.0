Return-Path: <live-patching+bounces-1688-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE439B80DD3
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C4B03A05A5
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A13336284;
	Wed, 17 Sep 2025 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXRFR6po"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5D6335954;
	Wed, 17 Sep 2025 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125080; cv=none; b=r6BIJZAROdf3XGZWVsc5DItJanNQnljmEB+/W3pct75RFCj6fPPpvvZ7DiPWm+Am1gWwHMfEnGTfFoWfBoyU/pEwWf5G/39VVc0lQXi1/MferEwKoCTuYyx6qOLHdXw9u7scRRMZ+t7XuFO+oBQGkkNK1GLg1LPbzMBH70zuGF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125080; c=relaxed/simple;
	bh=+c3m4SnwkS9U/GosXwbEYwHZVKnVCubU14Y1GjKYlv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nmcf1qcS3JiNGGgCvR2cosvWuGJKjCEsEAAdzWHWzI1luGMaIwex6D5N3lcr6tD2RJbT4zRqtI3DKe26FwpHlje2Xni82gtuvv3Rh8vwPeqo9+PWo2ZUI3DosqqtocAT7UIbJo2b5u0++SX3FVKMCwVrPdA/UHZtal2PDdqlrHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXRFR6po; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3160AC4CEF7;
	Wed, 17 Sep 2025 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125079;
	bh=+c3m4SnwkS9U/GosXwbEYwHZVKnVCubU14Y1GjKYlv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXRFR6pomdUPoYJpPKUiADHGRuGV+HEayICeyESNWXFL7QYLWbVTKLrYBqskCILzu
	 ODCVlohhbW2TlKQArQpdWLu4LU8m9fwjm63adoWeIGXDTFX2yyrALOQVuqUWezVwbu
	 fCWBP+yMv7ATXBpcQFjgmxqLijmRjfkbD47vyqFOcqa0K89j+Uqt+W8e2rtKBld1Ac
	 QyKF7B6mv3Lvufx9XSf+hwqk6aik6e8XhTT2pPk2V2s6SZggPTssgEKEVzAWk3XFAu
	 wrdyt+pP9bK48fJ1ukNKSK/ow8Uv6iWm2ntVMTojEbX6tvY5fcraGYMntpiMsTGf8R
	 hDG7mMipHVq+A==
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
Subject: [PATCH v4 33/63] objtool: Avoid emptying lists for duplicate sections
Date: Wed, 17 Sep 2025 09:03:41 -0700
Message-ID: <b2aef7bd757ba1fe9d0d4d2756855135133b5a99.1758067943.git.jpoimboe@kernel.org>
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

When a to-be-created section already exists, there's no point in
emptying the various lists if their respective sections already exist.
In fact it's better to leave them intact as they might get used later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ea53468120d7a..f75de86c60f5f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -635,7 +635,6 @@ static int create_static_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".static_call_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->static_call_list);
 		WARN("file already has .static_call_sites section, skipping");
 		return 0;
 	}
@@ -851,7 +850,6 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".cfi_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .cfi_sites section, skipping");
 		return 0;
 	}
@@ -900,7 +898,6 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, "__mcount_loc");
 	if (sec) {
-		INIT_LIST_HEAD(&file->mcount_loc_list);
 		WARN("file already has __mcount_loc section, skipping");
 		return 0;
 	}
@@ -945,7 +942,6 @@ static int create_direct_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".call_sites");
 	if (sec) {
-		INIT_LIST_HEAD(&file->call_list);
 		WARN("file already has .call_sites section, skipping");
 		return 0;
 	}
-- 
2.50.0


