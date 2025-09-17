Return-Path: <live-patching+bounces-1717-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 497EDB80E8C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BEB06253D5
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6882C34662A;
	Wed, 17 Sep 2025 16:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agLqetwF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7B5346625;
	Wed, 17 Sep 2025 16:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125101; cv=none; b=ThodPkkcNxNGiEWZ8E/ZXh+8iaQ7/lt4oK4w53hnK7xvGJoJi8A+S5Wv8exNCeiPS/Xzz6Qpllizti+rrpfyuwSBTPLVIN/8eNrCMUmq8l5rSdATeLAWC3C695h9x9s9xEQBPkr4oI0NHigVgwKCFUCtl7E/mECf/UjhHDjrIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125101; c=relaxed/simple;
	bh=oBBrJ6a4WfjAzFtKH1KTUTsolN0YOgqCRZFWuB+x8Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKi9BIahUWyyeexFQNDyMGdSqa43MUUasy3OlSkeG0jpwX1v5gfsI7PetWe0BSS9hplOTURCm6YUcJnV7zqeDmtqP8LdCK42CEYGyrliWhRpSqYOFnDU4dPaD8kpgZ8MYodGh6Tj1sJ3+GIE7GFKzxXBJ2fVz9wJx7Z1j0i7QtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agLqetwF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A197C4CEE7;
	Wed, 17 Sep 2025 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125101;
	bh=oBBrJ6a4WfjAzFtKH1KTUTsolN0YOgqCRZFWuB+x8Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agLqetwFaCJ8X3M7yZ7OMSn/TaiL41bBi5nbsnKty/+nuTaIjAzi+7U+U5jqIHgdx
	 lFkBaQ2LSikzcq84HvH+xbyMrSvmsPM5CeKXPuuCfMsL2XxBveclMurfn2/3knPX+f
	 xOr7twXYKJcOJfAZlrCEnbxCGVOTy3MdFg3RkdYFuwBcLD5YUrjqcCbKOnmEB1uyb2
	 ++XIB7/hR8Gp4KPiFZ1JKwBYoErbKak99a5CzfJ6XW3QftOv0zuOGo4bwDLvNr9t2J
	 aBp9eHvg/RA+5bzjiK+yKPohQe7mHfVoFfvTj1ry1Hn6fBwzIIERiyQKVd2YzwZAUY
	 HAelx577wk+fw==
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
Subject: [PATCH v4 62/63] livepatch/klp-build: Add --show-first-changed option to show function divergence
Date: Wed, 17 Sep 2025 09:04:10 -0700
Message-ID: <d49b212454afbb9812a132340dcfb068b7dd9082.1758067943.git.jpoimboe@kernel.org>
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
index 28ee259ce5f6e..881e052e7faef 100755
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
@@ -618,6 +623,7 @@ diff_objects() {
 		local orig_file="$rel_file"
 		local patched_file="$PATCHED_DIR/$rel_file"
 		local out_file="$DIFF_DIR/$rel_file"
+		local filter=()
 		local cmd=()
 
 		mkdir -p "$(dirname "$out_file")"
@@ -630,16 +636,80 @@ diff_objects() {
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
@@ -743,6 +813,10 @@ fi
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
2.50.0


