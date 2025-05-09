Return-Path: <live-patching+bounces-1420-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93337AB1E48
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1AAB189FAD0
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A2329B21B;
	Fri,  9 May 2025 20:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CmJ9IcVA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B429B20F;
	Fri,  9 May 2025 20:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821908; cv=none; b=ufSfkPFGuTHhhi0AH3ThCuTRydSkQ0KM9C5gsw5RJvfKM2uhjrkQOzomvCOOhxakzYX7ckIBhh/ozBCJBqleQ35G5DnsNThNgkJNYjA2T7SUKYXpYLR+G/yQS+0/TV4uSkbgsMZvHbCOqxYdutvznZ44VW4LoYlIGATTj8C6DHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821908; c=relaxed/simple;
	bh=FNBWxK1Fm8BYB6Bj9vaGxYWsDefzu7nRRCD7N3z6kXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl8cJg4e5DrJEZmsmMFIDD0unu2DaXyEe652JIFbLZeZD8td08P32ER9gTLa710K5PPigyI1DLpQQKijg14RZ6iEYmEm+ho2b4rdWVaH5aHN1r5t+EBhJviuz+eBK5CIv3kUuVhdSLzGK28OBAU2X6pgvWTQ+mnbOJBnUgw2nk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CmJ9IcVA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F739C4CEE4;
	Fri,  9 May 2025 20:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821908;
	bh=FNBWxK1Fm8BYB6Bj9vaGxYWsDefzu7nRRCD7N3z6kXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmJ9IcVAH+vd5cgWUX90l4VCRuN5bDvMg+seyX0HJuThju0nzTtdEo0fqbi8bHhtb
	 YWStlkbVRRyxLx994PIR+NOPRUphgT9FRZDDm6xj22vFvGA+8Cc727HJAhfnSeRmC9
	 CDwxYS79duG8uBse6NBcE3AQ+WiVtCQHQjqIFXM3W93/L6+xYXZ2Enr/+jaip/qGyo
	 6QYmdpzH2aGWuOy1SY00bJaNSKShVeHBciq/oANcvXc8pZAKJx/7fjUNSQBtM8PNKT
	 7nzxjZq4ViyxNLcoY5L2nmDTXJpKhWyKiErVn1mBABmDONDJrgane9jeEofm2FuTxg
	 9Y2usqoNwAPkQ==
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
Subject: [PATCH v2 61/62] livepatch/klp-build: Add --show-first-changed option to show function divergence
Date: Fri,  9 May 2025 13:17:25 -0700
Message-ID: <b08478eb951c33e66c926d724d2d4b0520a4a6f2.1746821544.git.jpoimboe@kernel.org>
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
index 08ef903d4090..f7d88726ed4f 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -21,7 +21,7 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+errexit can catch errors.
 shopt -s lastpipe
 
-unset DEBUG_CLONE SKIP_CLEANUP XTRACE
+unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP XTRACE
 REPLACE=1
 SHORT_CIRCUIT=0
 shopt -o xtrace | grep -q 'on' && XTRACE=1
@@ -115,6 +115,7 @@ Usage: $SCRIPT [OPTIONS] PATCH_FILE(s)
 Generate a livepatch module.
 
 Options:
+   -f, --show-first-changed	Show address of first changed instruction
    -o, --output <file.ko>	Output file [default: livepatch-<patch-name>.ko]
        --no-replace		Disable livepatch atomic replace
    -v, --verbose		Pass V=1 to kernel/module builds
@@ -141,8 +142,8 @@ process_args() {
 	local long
 	local args
 
-	short="ho:vDS:T"
-	long="help,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfo:vDS:T"
+	long="help,show-first-changed,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
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
 			-o | --output)
 				[[ "$2" != *.ko ]] && die "output filename should end with .ko"
 				OUTFILE="$2"
@@ -581,6 +586,7 @@ diff_objects() {
 		local orig_file="$rel_file"
 		local patched_file="$PATCHED_DIR/$rel_file"
 		local out_file="$DIFF_DIR/$rel_file"
+		local filter=()
 		local cmd=()
 
 		mkdir -p "$(dirname "$out_file")"
@@ -593,16 +599,80 @@ diff_objects() {
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
 				> >(tee -a "$log")					\
-				2> >(tee -a "$log" >&2)					\
+				2> >(tee -a "$log" | "${filter[@]}" >&2)		\
 				|| die "objtool klp diff failed"
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
+			"${cmd[@]}" "$opt" "$file" &> "$orig_log"	\
+				|| ( cat "$orig_log" >&2; die "objtool --debug-checksum failed" )
+
+			cd "$PATCHED_DIR"
+			"${cmd[@]}" "$opt" "$file" &> "$patched_log"	\
+				|| ( cat "$patched_log" >&2; die "objtool --debug-checksum failed" )
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
@@ -697,6 +767,10 @@ fi
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


