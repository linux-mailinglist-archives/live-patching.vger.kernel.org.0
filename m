Return-Path: <live-patching+bounces-1713-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C88C1B80E60
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8C5B622667
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C21E3445AA;
	Wed, 17 Sep 2025 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElvCPo+3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FD23445A1;
	Wed, 17 Sep 2025 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125098; cv=none; b=PrpSJQsTz7DI2GT1BneEtu9hn2am7zjz1vEb5qN04SEkMtVI/APN+W0Enj5aSyUbUdMs0tqTfgBXq84fHDbbS7JbhPlXmZ7OBkF87H0zpyuue82XBDeiCAauusWr0eeKdFm2EbumuKb8tDvm5z64dUwB+65AQqBVp/8MGTbWkzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125098; c=relaxed/simple;
	bh=O1tSFT4UPwPqlxbxBq2Q3rtbc7FKAx090bERGw4SM3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8kFReVNtro7Ld7X1qaH4AiRR86JA8Y/zBup8C037thXbz9Ef4dmmx7Zcacnl0ZcLCT2NvJart1L77Ex24UIqNjOxp+Ijpy81hZItv34MqISpgZqMlRi60qOVKZTyLgydxJN4qYPhoezL3f+ohUbfPcHlp7za10vhDUan+P7ehQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElvCPo+3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07103C4CEFC;
	Wed, 17 Sep 2025 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125098;
	bh=O1tSFT4UPwPqlxbxBq2Q3rtbc7FKAx090bERGw4SM3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElvCPo+3rzg8v8Hny2fWklYUA34nDIyxL7q/P9kevRYVWG67rPUysrtOjTzUgq4OF
	 F1r7n39sblJEtTI86XdBmvo8yHFJpvbqR/VNsK5RLyu34cFYfSymbyj94PjV/4G9Kc
	 1hzSiNYYvC56xn1Cr/TJiA+TKPmvAi1Oy2FXMCAfZu5D1B3+bGZAeMCDvlFx5iUzWt
	 Zf+TAq11FgSBBRkqDUxORb4fThSRRVnisyPIgkaQHyZJq1JMJ5cI1OEyGhZOWv5YVW
	 z08ev+0jrwJ90F96JClRh8TjzKG9l5K9RYekgAING2/mzCR0lSRdJkCRgEqtdt4+Tp
	 jwnZlJCflMxJQ==
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
Subject: [PATCH v4 58/63] livepatch/klp-build: Introduce fix-patch-lines script to avoid __LINE__ diff noise
Date: Wed, 17 Sep 2025 09:04:06 -0700
Message-ID: <6c804737efdd7aefc80765bd0535367c9bb44ab4.1758067943.git.jpoimboe@kernel.org>
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

The __LINE__ macro creates challenges for binary diffing.  When a .patch
file adds or removes lines, it shifts the line numbers for all code
below it.

This can cause the code generation of functions using __LINE__ to change
due to the line number constant being embedded in a MOV instruction,
despite there being no semantic difference.

Avoid such false positives by adding a fix-patch-lines script which can
be used to insert a #line directive in each patch hunk affecting the
line numbering.  This script will be used by klp-build, which will be
introduced in a subsequent patch.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 MAINTAINERS                       |  1 +
 scripts/livepatch/fix-patch-lines | 79 +++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100755 scripts/livepatch/fix-patch-lines

diff --git a/MAINTAINERS b/MAINTAINERS
index 605390cdfb75e..485042b545b3e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14225,6 +14225,7 @@ F:	include/linux/livepatch*.h
 F:	kernel/livepatch/
 F:	kernel/module/livepatch.c
 F:	samples/livepatch/
+F:	scripts/livepatch/
 F:	tools/testing/selftests/livepatch/
 
 LLC (802.2)
diff --git a/scripts/livepatch/fix-patch-lines b/scripts/livepatch/fix-patch-lines
new file mode 100755
index 0000000000000..73c5e3dea46e1
--- /dev/null
+++ b/scripts/livepatch/fix-patch-lines
@@ -0,0 +1,79 @@
+#!/usr/bin/awk -f
+# SPDX-License-Identifier: GPL-2.0
+#
+# Use #line directives to preserve original __LINE__ numbers across patches to
+# avoid unwanted compilation changes.
+
+BEGIN {
+	in_hunk = 0
+	skip    = 0
+}
+
+/^--- / {
+	skip = $2 !~ /\.(c|h)$/
+	print
+	next
+}
+
+/^@@/ {
+	if (skip) {
+		print
+		next
+	}
+
+	in_hunk = 1
+
+	# for @@ -1,3 +1,4 @@:
+	#   1: line number in old file
+	#   3: how many lines the hunk covers in old file
+	#   1: line number in new file
+	#   4: how many lines the hunk covers in new file
+
+	match($0, /^@@ -([0-9]+)(,([0-9]+))? \+([0-9]+)(,([0-9]+))? @@/, m)
+
+	# Set 'cur' to the old file's line number at the start of the hunk.  It
+	# gets incremented for every context line and every line removal, so
+	# that it always represents the old file's current line number.
+	cur = m[1]
+
+	# last = last line number of current hunk
+	last = cur + (m[3] ? m[3] : 1) - 1
+
+	need_line_directive = 0
+
+	print
+	next
+}
+
+{
+	if (skip || !in_hunk || $0 ~ /^\\ No newline at end of file/) {
+		print
+		next
+	}
+
+	# change line
+	if ($0 ~ /^[+-]/) {
+		# inject #line after this group of changes
+		need_line_directive = 1
+
+		if ($0 ~ /^-/)
+			cur++
+
+		print
+		next
+	}
+
+	# If this is the first context line after a group of changes, inject
+	# the #line directive to force the compiler to correct the line
+	# numbering to match the original file.
+	if (need_line_directive) {
+		print "+#line " cur
+		need_line_directive = 0
+	}
+
+	if (cur == last)
+		in_hunk = 0
+
+	cur++
+	print
+}
-- 
2.50.0


