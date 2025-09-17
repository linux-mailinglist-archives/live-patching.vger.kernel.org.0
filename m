Return-Path: <live-patching+bounces-1716-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98DD9B80E84
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8D06623BA7
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E572F9C29;
	Wed, 17 Sep 2025 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7Sfor2T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D036344E5A;
	Wed, 17 Sep 2025 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125100; cv=none; b=HJPk+xltBWlAv8Fkz9IcFMKnHyB8x+Dw6iPfoRTBOmUQqvJqqv72kWT3dCQ9AoS+lG/hL2AoXxv0Fq1IDI28bi0+U1bHe51UEzcMb7MlUyn/umhNXlMi+7oZf4xvs4UaWxtekb7Wo9laB3UkE3bY3xQFocmgvmHqWVh7Jn6uIhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125100; c=relaxed/simple;
	bh=Jebp3ZaYF+EcR3CjIOe/Vf7dxHymQKiMf6ewSq0YnNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pA6KbI72eLw3QiQpnvBqc3WGRtdSNSyc5nVODPv8DtSJgDkeGrhnu6nMRV8GVd0hW+B/O+YfF8vNFwr5ec3ik/ZD/3QZRpbbM/mIC3bcRfVEIqAVeI5Dtarm+5z8VjECpFzh01NhS5hQx9xl+8mLFKKBbtmuXfSbVEHHwwjv9Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7Sfor2T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC76C4CEFD;
	Wed, 17 Sep 2025 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125100;
	bh=Jebp3ZaYF+EcR3CjIOe/Vf7dxHymQKiMf6ewSq0YnNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7Sfor2TGph9LWGJctcKnfd8c4FFo3C8C4Z9EAqAmHDjeia5y9LQnZNz2zMuxfGLC
	 XPUzttHD//07i2YDdsYQht2ALiJbSX7E57wLCA6p45KCEsWewVeK0193c1Xk5A4TlT
	 sZ2qXmzwd5hvK2Uct9G/Mgs05FeLVHrNIxbkVj68vXtkerjr4NyAkREMjF074nphl8
	 qBPb4YrBui6gqTJQoVZbI8qhYQoAWD2dZReM3c9pOGVL/cW/saB7yOZOUe2lUzKHBj
	 /FHx9M7XBog9RUPOPlk3m6aWHk3IueBddpIeT9D9ngF3iM/WtAkiNHQizGXM106xHQ
	 UOet2Vz0dgRAA==
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
Subject: [PATCH v4 61/63] livepatch/klp-build: Add --debug option to show cloning decisions
Date: Wed, 17 Sep 2025 09:04:09 -0700
Message-ID: <84e14354875d4a6d1e79a434e0af1be27720a91a.1758067943.git.jpoimboe@kernel.org>
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

Add a --debug option which gets passed to "objtool klp diff" to enable
debug output related to cloning decisions.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 01ed0b66bfaff..28ee259ce5f6e 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -20,7 +20,7 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+errexit can catch errors.
 shopt -s lastpipe
 
-unset SKIP_CLEANUP XTRACE
+unset DEBUG_CLONE SKIP_CLEANUP XTRACE
 
 REPLACE=1
 SHORT_CIRCUIT=0
@@ -120,6 +120,7 @@ Options:
    -v, --verbose		Pass V=1 to kernel/module builds
 
 Advanced Options:
+   -d, --debug			Show symbol/reloc cloning decisions
    -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
 				   1|orig	Build original kernel (default)
 				   2|patched	Build patched kernel
@@ -140,8 +141,8 @@ process_args() {
 	local long
 	local args
 
-	short="hj:o:vS:T"
-	long="help,jobs:,output:,no-replace,verbose,short-circuit:,keep-tmp"
+	short="hj:o:vdS:T"
+	long="help,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -174,6 +175,11 @@ process_args() {
 				VERBOSE="V=1"
 				shift
 				;;
+			-d | --debug)
+				DEBUG_CLONE=1
+				keep_tmp=1
+				shift
+				;;
 			-S | --short-circuit)
 				[[ ! -d "$TMP_DIR" ]] && die "--short-circuit requires preserved klp-tmp dir"
 				keep_tmp=1
@@ -596,6 +602,7 @@ copy_patched_objects() {
 diff_objects() {
 	local log="$KLP_DIFF_LOG"
 	local files=()
+	local opts=()
 
 	rm -rf "$DIFF_DIR"
 	mkdir -p "$DIFF_DIR"
@@ -603,6 +610,8 @@ diff_objects() {
 	find "$PATCHED_DIR" -type f -name "*.o" | mapfile -t files
 	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
 
+	[[ -v DEBUG_CLONE ]] && opts=("--debug")
+
 	# Diff all changed objects
 	for file in "${files[@]}"; do
 		local rel_file="${file#"$PATCHED_DIR"/}"
@@ -616,6 +625,7 @@ diff_objects() {
 		cmd=("$SRC/tools/objtool/objtool")
 		cmd+=("klp")
 		cmd+=("diff")
+		(( ${#opts[@]} > 0 )) && cmd+=("${opts[@]}")
 		cmd+=("$orig_file")
 		cmd+=("$patched_file")
 		cmd+=("$out_file")
-- 
2.50.0


