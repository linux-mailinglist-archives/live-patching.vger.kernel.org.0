Return-Path: <live-patching+bounces-1590-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17931AEAB81
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 736133A7501
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50052E973B;
	Thu, 26 Jun 2025 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQYT0ksD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF942E92A7;
	Thu, 26 Jun 2025 23:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982214; cv=none; b=WZOXT4N0Bp5ysiwGhc0TQxeihXpopfP99qozN5YyS6BaAxZa5IIerM/SsoPFgGB4q+EeYGffbBVPmVPoqQ9ilfzVoO6zgWzQy/cEL89q8UmXkvmJG7RFyRxpIRHBR8UGB/gnW7TGvdQWTm0+XvjB/+jDW/Vv2RalGp7KfD/kK58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982214; c=relaxed/simple;
	bh=wtyF/MopiLNSY8OQ1lCxfuihtCDTzXFaLv3rp48jCvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAr7oRXs8I1bor2JivgVmh9K7Re/wIFmG/oRqzF4iyhsmxjQJugpUjP1z1JqSgWLY2tzYnuYYAX3kTgD5D0YYsNbjIMSlfFWAitJUr8mbCUSGCyr6Vd0dfLwbcX3MgdINmQGH44u/3lhj/UXF4czrqEoiXprYjRvRhsFexv3jn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQYT0ksD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770FAC4CEF1;
	Thu, 26 Jun 2025 23:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982213;
	bh=wtyF/MopiLNSY8OQ1lCxfuihtCDTzXFaLv3rp48jCvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQYT0ksDDCDf8e0Y7SLw2qh9WshRgfh/V2x8rtZvLddoPvc8MzIn+yb3j5n3QUCKl
	 Pnvc2K7ToshwWkjw7kEETwX7ZtCOhX4CnxHjpQYjKsp1+a0PTH6+OZFUfHnyx99Bqc
	 3Kjf5dthss+3iCjrfaJKNWlFrRgASWCArY92Uh7EPQCkzUd0n/eo3nRjB5tZYxpBYI
	 i1H9NM5J3ueSQqG1+eRHOjgC4iyiKXOb2uNjmiMqfSsG9ucFrs4Q+1qs8r3BoTG6rg
	 YQWQF1zi0pOutdRqsggHa6d7+PUN7Y6deqrqaBLVSgVSMlihDVPPw5g8LjE666kZTa
	 15XRCEp8pAxjQ==
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
Subject: [PATCH v3 59/64] livepatch/klp-build: Introduce fix-patch-lines script to avoid __LINE__ diff noise
Date: Thu, 26 Jun 2025 16:55:46 -0700
Message-ID: <6ec2a82b31a90f52040846dc9a713d69a658820c.1750980517.git.jpoimboe@kernel.org>
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
index 0298d9570ca8..dd622368d74b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14006,6 +14006,7 @@ F:	include/linux/livepatch*.h
 F:	kernel/livepatch/
 F:	kernel/module/livepatch.c
 F:	samples/livepatch/
+F:	scripts/livepatch/
 F:	tools/testing/selftests/livepatch/
 
 LLC (802.2)
diff --git a/scripts/livepatch/fix-patch-lines b/scripts/livepatch/fix-patch-lines
new file mode 100755
index 000000000000..73c5e3dea46e
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
2.49.0


