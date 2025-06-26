Return-Path: <live-patching+bounces-1594-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B87A8AEAB83
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 892191C21696
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B0D2F19B8;
	Thu, 26 Jun 2025 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1yviuqy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83C22F0E5F;
	Thu, 26 Jun 2025 23:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982217; cv=none; b=G8AcIoP7l1slpx/h8rdN2wduaR0zqU9ZyYrpqkRudwhhleftVXfCyG3TcQQHiuJ4wJJzXupgCQKMMM1NMJmD0Iu0oTurdWOaaKSdtb3qpjDTIeJ4uFna9f1bZ+ak2xPjHzh4kr5ve272K0jgqP3Fe6c3b3fTLKvtAAV2edQMB8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982217; c=relaxed/simple;
	bh=O0mdlcOLNvTMKkaQjDG/s/ezY+WH9kJUMCnIT7a05oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6y3LwxdjMOBIoywYCe9g/lx5GiqpAGoIee9p8HmKMFnZG2bJqilXatANfVhUX4Eq/QgRjfs9HxdlrA3yKEldcMGpLqXKFlZ3l+U9RurB9+Rt6JgFvT5fLlWbXliBHADNJ+7UGcBjOCgz9SPZ/FKfeyYqiNgEXdSqCkjOQQ1gN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1yviuqy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE22C4CEF3;
	Thu, 26 Jun 2025 23:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982216;
	bh=O0mdlcOLNvTMKkaQjDG/s/ezY+WH9kJUMCnIT7a05oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1yviuqyKxnSsD3mqHniG7HBh84Pc+gudChYAMWftwU2GMXSbnR+etyls7ij09ZeK
	 ObTrqkKHtpXO5F2lBRGSMmVinApfjd2Kp1DvLMtlF3mWBbtf46nEaUkSY1m6PNsdrm
	 sKea5cN1zLzC3dgpNXZKRVlKhaZydcYDNUiOrxP7dakqCpazOZXFAOPCdDDpmNi6AV
	 2W5aqsYbYzws8chP73z0MUkAeTE5XlpBxPa+bAObG+eQL380zegXNIaUSf5ZOSxeS5
	 CHB+10fRCIlZFJng+vFO5o/wYBGlgBPDjpur0CsHmv5aCMrMvLylcyedGjOIi25P5b
	 lL0NJ8M1Ne6eg==
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
Subject: [PATCH v3 63/64] livepatch/klp-build: Add --show-first-changed option to show function divergence
Date: Thu, 26 Jun 2025 16:55:50 -0700
Message-ID: <35e2ab14098362fc98aebb9ee08401c5f58d9f63.1750980517.git.jpoimboe@kernel.org>
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

Add a --show-first-changed option to identify where changed functions
begin to diverge:

  - Parse 'objtool klp diff' output to find changed functions.

  - Run objtool again on each object with --debug-checksum=<funcs>.

  - Diff the per-instruction checksum debug output to locate the first
    differing instruction.

This can be useful for quickly determining where and why a function
changed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 82 +++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 4 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index fe9af53a8476..e47056f75475 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -20,7 +20,7 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+errexit can catch errors.
 shopt -s lastpipe
 
-unset DEBUG_CLONE SKIP_CLEANUP XTRACE
+unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP XTRACE
 
 REPLACE=1
 SHORT_CIRCUIT=0
@@ -114,6 +114,7 @@ Usage: $SCRIPT [OPTIONS] PATCH_FILE(s)
 Generate a livepatch module.
 
 Options:
+   -f, --show-first-changed	Show address of first changed instruction
    -j, --jobs=<jobs>		Build jobs to run simultaneously [default: $JOBS]
    -o, --output=<file.ko>	Output file [default: livepatch-<patch-name>.ko]
        --no-replace		Disable livepatch atomic replace
@@ -141,8 +142,8 @@ process_args() {
 	local long
 	local args
 
-	short="hj:o:vdS:T"
-	long="help,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfj:o:vdS:T"
+	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -155,6 +156,10 @@ process_args() {
 				usage
 				exit 0
 				;;
+			-f | --show-first-changed)
+				DIFF_CHECKSUM=1
+				shift
+				;;
 			-j | --jobs)
 				JOBS="$2"
 				shift 2
@@ -622,6 +627,7 @@ diff_objects() {
 		local orig_file="$rel_file"
 		local patched_file="$PATCHED_DIR/$rel_file"
 		local out_file="$DIFF_DIR/$rel_file"
+		local filter=()
 		local cmd=()
 
 		mkdir -p "$(dirname "$out_file")"
@@ -634,16 +640,80 @@ diff_objects() {
 		cmd+=("$patched_file")
 		cmd+=("$out_file")
 
+		if [[ -v DIFF_CHECKSUM ]]; then
+			filter=("grep0")
+			filter+=("-Ev")
+			filter+=("DEBUG: .*checksum: ")
+		else
+			filter=("cat")
+		fi
+
 		(
 			cd "$ORIG_DIR"
 			"${cmd[@]}"							\
 				1> >(tee -a "$log")					\
-				2> >(tee -a "$log" >&2) ||				\
+				2> >(tee -a "$log" | "${filter[@]}" >&2) ||		\
 				die "objtool klp diff failed"
 		)
 	done
 }
 
+# For each changed object, run objtool with --debug-checksum to get the
+# per-instruction checksums, and then diff those to find the first changed
+# instruction for each function.
+diff_checksums() {
+	local orig_log="$ORIG_DIR/checksum.log"
+	local patched_log="$PATCHED_DIR/checksum.log"
+	local -A funcs
+	local cmd=()
+	local line
+	local file
+	local func
+
+	gawk '/\.o: changed function: / {
+		sub(/:$/, "", $1)
+		print $1, $NF
+	}' "$KLP_DIFF_LOG" | mapfile -t lines
+
+	for line in "${lines[@]}"; do
+		read -r file func <<< "$line"
+		if [[ ! -v funcs["$file"] ]]; then
+			funcs["$file"]="$func"
+		else
+			funcs["$file"]+=" $func"
+		fi
+	done
+
+	cmd=("$SRC/tools/objtool/objtool")
+	cmd+=("--checksum")
+	cmd+=("--link")
+	cmd+=("--dry-run")
+
+	for file in "${!funcs[@]}"; do
+		local opt="--debug-checksum=${funcs[$file]// /,}"
+
+		(
+			cd "$ORIG_DIR"
+			"${cmd[@]}" "$opt" "$file" &> "$orig_log" || \
+				( cat "$orig_log" >&2; die "objtool --debug-checksum failed" )
+
+			cd "$PATCHED_DIR"
+			"${cmd[@]}" "$opt" "$file" &> "$patched_log" ||	\
+				( cat "$patched_log" >&2; die "objtool --debug-checksum failed" )
+		)
+
+		for func in ${funcs[$file]}; do
+			diff <( grep0 -E "^DEBUG: .*checksum: $func " "$orig_log"    | sed "s|$ORIG_DIR/||")	\
+			     <( grep0 -E "^DEBUG: .*checksum: $func " "$patched_log" | sed "s|$PATCHED_DIR/||")	\
+				| gawk '/^< DEBUG: / {
+					gsub(/:/, "")
+					printf "%s: %s: %s\n", $3, $5, $6
+					exit
+			}' || true
+		done
+	done
+}
+
 # Build and post-process livepatch module in $KMOD_DIR
 build_patch_module() {
 	local makefile="$KMOD_DIR/Kbuild"
@@ -747,6 +817,10 @@ fi
 if (( SHORT_CIRCUIT <= 3 )); then
 	status "Diffing objects"
 	diff_objects
+	if [[ -v DIFF_CHECKSUM ]]; then
+		status "Finding first changed instructions"
+		diff_checksums
+	fi
 fi
 
 if (( SHORT_CIRCUIT <= 4 )); then
-- 
2.49.0


