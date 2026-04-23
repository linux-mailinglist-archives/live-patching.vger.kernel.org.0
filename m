Return-Path: <live-patching+bounces-2463-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKL5IMOe6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2463-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D83F244CE9F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C18930E70D9
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15573DC4A5;
	Thu, 23 Apr 2026 04:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDRsGj10"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAB13DBD6F;
	Thu, 23 Apr 2026 04:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917082; cv=none; b=bmqh+KIADlxg2eQ3MPNtULohiN77JfW3AoZCruLi0hOlUhenhWwwpGAJgp7tHOAvxMdJljYV6VfAjOGJhBQExRt4Vrw0WxzKagi3ShzNkUqKDTJ3AESD1rQJvhvbzK0rmhKchp9irx5yfvyU/OtugiM9/XKsOBQajfGqoisUl2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917082; c=relaxed/simple;
	bh=ljj6t8WcunUTkYwZXIS1IPUO1uAXy2ns4cJ5oZW9oe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCrfARWHzk6PUZeyUWsO+vM74G6oR0pzR1VygwBm7wxW8jsoiqMeuVxXpM90bq30TNk8sPHBrQyfPf3T4hf1u3BWQJi9EjSSfxgzYBNSDB2V7kRAVcxEtI8tbtehcv8XS7KcJhwCloPtG21BhdEx+WMplMxkCb1l9r2UwtZHOtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDRsGj10; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8E4C2BCB4;
	Thu, 23 Apr 2026 04:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917082;
	bh=ljj6t8WcunUTkYwZXIS1IPUO1uAXy2ns4cJ5oZW9oe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDRsGj10Ic4KlG3tOpGPuT6x1EZkVPHLXS7rq23SvZBFz6h9TQho1mzFoCPhL4yVL
	 ehZc2CJOROcfFaBCfU+lJT9zqrTnFa3D7I+zXX+a38SItxXRAGz5+EuiY96UJ0lWke
	 HwRZdP2Ldx9K/GeLgHsMZQXRc2Hon4HuBpArnKOIg1BmrSsY/GPp/qsYPBMX0TrJlM
	 R4oHNp3MhYe8w+RQJh5fSSTZmGU2oj2EmfmAEbIRnrxeo6svOF17HLRTVFyL4eMrhG
	 FAkv317puxbp1schIU7VadcDIkX+qWbPutNP+dRWVGwj+esGSzqfZVIITbd8g1EnES
	 wTTah4Gu6ymGg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 36/48] klp-build: Use "objtool klp checksum" subcommand
Date: Wed, 22 Apr 2026 21:04:04 -0700
Message-ID: <99e40357ee24962b3514d9ce4f6e773eff3a15f3.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2463-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D83F244CE9F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Use the new "objtool klp checksum" subcommand instead of injecting
--checksum into every objtool invocation via OBJTOOL_ARGS during the
kernel build.

This decouples checksum generation from the build, running it in
separate post-build passes, making the code (and the patch generation
pipeline itself) more modular.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 93 +++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 29 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 84053e8aadd3..d29ef3022556 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -39,10 +39,12 @@ OBJ="$(pwd)"
 CONFIG="$OBJ/.config"
 TMP_DIR="$OBJ/klp-tmp"
 
-ORIG_DIR="$TMP_DIR/orig"
-PATCHED_DIR="$TMP_DIR/patched"
-DIFF_DIR="$TMP_DIR/diff"
-KMOD_DIR="$TMP_DIR/kmod"
+ORIG_DIR="$TMP_DIR/1-orig"
+PATCHED_DIR="$TMP_DIR/2-patched"
+ORIG_CSUM_DIR="$TMP_DIR/3-checksum-orig"
+PATCHED_CSUM_DIR="$TMP_DIR/3-checksum-patched"
+DIFF_DIR="$TMP_DIR/4-diff"
+KMOD_DIR="$TMP_DIR/5-kmod"
 
 STASH_DIR="$TMP_DIR/stash"
 TIMESTAMP="$TMP_DIR/timestamp"
@@ -138,10 +140,11 @@ Options:
 Advanced Options:
    -d, --debug			Show symbol/reloc cloning decisions
    -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
-				   1|orig	Build original kernel (default)
-				   2|patched	Build patched kernel
-				   3|diff	Diff objects
-				   4|kmod	Build patch module
+				   1|orig		Build original kernel (default)
+				   2|patched		Build patched kernel
+				   3|checksum		Generate checksums
+				   4|diff		Diff objects
+				   5|kmod		Build patch module
    -T, --keep-tmp		Preserve tmp dir on exit
 
 EOF
@@ -205,10 +208,11 @@ process_args() {
 				[[ ! -d "$TMP_DIR" ]] && die "--short-circuit requires preserved klp-tmp dir"
 				keep_tmp=1
 				case "$2" in
-					1 | orig)	SHORT_CIRCUIT=1; ;;
-					2 | patched)	SHORT_CIRCUIT=2; ;;
-					3 | diff)	SHORT_CIRCUIT=3; ;;
-					4 | mod)	SHORT_CIRCUIT=4; ;;
+					1 | orig)		SHORT_CIRCUIT=1; ;;
+					2 | patched)		SHORT_CIRCUIT=2; ;;
+					3 | checksum)		SHORT_CIRCUIT=3; ;;
+					4 | diff)		SHORT_CIRCUIT=4; ;;
+					5 | kmod)		SHORT_CIRCUIT=5; ;;
 					*)		die "invalid short-circuit step '$2'" ;;
 				esac
 				shift 2
@@ -519,11 +523,8 @@ clean_kernel() {
 build_kernel() {
 	local build="$1"
 	local log="$TMP_DIR/build.log"
-	local objtool_args=()
 	local cmd=()
 
-	objtool_args=("--checksum")
-
 	cmd=("make")
 
 	# When a patch to a kernel module references a newly created unexported
@@ -550,7 +551,6 @@ build_kernel() {
 	fi
 	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
-	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
 	cmd+=("vmlinux")
 	cmd+=("modules")
 
@@ -582,7 +582,7 @@ copy_orig_objects() {
 
 	find_objects | mapfile -t files
 
-	xtrace_save "copying orig objects"
+	xtrace_save "copying original objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
 		local file="$OBJ/$rel_file"
@@ -638,6 +638,35 @@ copy_patched_objects() {
 	mv -f "$TMP_DIR/build.log" "$PATCHED_DIR"
 }
 
+# Copy .o files to a separate directory and run "objtool klp checksum" on each
+# copy.  The checksums are written to a .discard.sym_checksum section.
+#
+# If match_dir is given, only process files which also exist there.
+generate_checksums() {
+	local src_dir="$1"
+	local dest_dir="$2"
+	local match_dir="${3:-}"
+	local files=()
+	local file
+
+	rm -rf "$dest_dir"
+	mkdir -p "$dest_dir"
+
+	find "$src_dir" -type f -name "*.o" | mapfile -t files
+	for file in "${files[@]}"; do
+		local rel="${file#"$src_dir"/}"
+		local dest="$dest_dir/$rel"
+
+		[[ -n "$match_dir" && ! -f "$match_dir/$rel" ]] && continue
+
+		mkdir -p "$(dirname "$dest")"
+		cp -f "$file" "$dest"
+		"$SRC/tools/objtool/objtool" klp checksum "$dest"
+	done
+
+	touch "$dest_dir/.complete"
+}
+
 # Diff changed objects, writing output object to $DIFF_DIR
 diff_objects() {
 	local log="$KLP_DIFF_LOG"
@@ -647,16 +676,16 @@ diff_objects() {
 	rm -rf "$DIFF_DIR"
 	mkdir -p "$DIFF_DIR"
 
-	find "$PATCHED_DIR" -type f -name "*.o" | mapfile -t files
+	find "$PATCHED_CSUM_DIR" -type f -name "*.o" | mapfile -t files
 	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
 
 	[[ -v DEBUG_CLONE ]] && opts=("--debug")
 
 	# Diff all changed objects
 	for file in "${files[@]}"; do
-		local rel_file="${file#"$PATCHED_DIR"/}"
+		local rel_file="${file#"$PATCHED_CSUM_DIR"/}"
 		local orig_file="$rel_file"
-		local patched_file="$PATCHED_DIR/$rel_file"
+		local patched_file="$PATCHED_CSUM_DIR/$rel_file"
 		local out_file="$DIFF_DIR/$rel_file"
 		local filter=()
 		local cmd=()
@@ -680,7 +709,7 @@ diff_objects() {
 		fi
 
 		(
-			cd "$ORIG_DIR"
+			cd "$ORIG_CSUM_DIR"
 			[[ -v VERBOSE ]] && echo "${cmd[@]}"
 			"${cmd[@]}"							\
 				1> >(tee -a "$log")					\
@@ -690,9 +719,9 @@ diff_objects() {
 	done
 }
 
-# For each changed object, run objtool with --debug-checksum to get the
-# per-instruction checksums, and then diff those to find the first changed
-# instruction for each function.
+# For each changed object, run "objtool klp checksum" with --debug-checksum to
+# get the per-instruction checksums, and then diff those to find the first
+# changed instruction for each function.
 diff_checksums() {
 	local orig_log="$ORIG_DIR/checksum.log"
 	local patched_log="$PATCHED_DIR/checksum.log"
@@ -717,8 +746,7 @@ diff_checksums() {
 	done
 
 	cmd=("$SRC/tools/objtool/objtool")
-	cmd+=("--checksum")
-	cmd+=("--link")
+	cmd+=("klp" "checksum")
 	cmd+=("--dry-run")
 
 	for file in "${!funcs[@]}"; do
@@ -727,11 +755,11 @@ diff_checksums() {
 		(
 			cd "$ORIG_DIR"
 			"${cmd[@]}" "$opt" "$file" &> "$orig_log" || \
-				( cat "$orig_log" >&2; die "objtool --debug-checksum failed" )
+				( cat "$orig_log" >&2; die "objtool klp checksum failed" )
 
 			cd "$PATCHED_DIR"
 			"${cmd[@]}" "$opt" "$file" &> "$patched_log" ||	\
-				( cat "$patched_log" >&2; die "objtool --debug-checksum failed" )
+				( cat "$patched_log" >&2; die "objtool klp checksum failed" )
 		)
 
 		for func in ${funcs[$file]}; do
@@ -872,6 +900,13 @@ if (( SHORT_CIRCUIT <= 2 )); then
 fi
 
 if (( SHORT_CIRCUIT <= 3 )); then
+	status "Generating original checksums"
+	generate_checksums "$ORIG_DIR" "$ORIG_CSUM_DIR" "$PATCHED_DIR"
+	status "Generating patched checksums"
+	generate_checksums "$PATCHED_DIR" "$PATCHED_CSUM_DIR"
+fi
+
+if (( SHORT_CIRCUIT <= 4 )); then
 	status "Diffing objects"
 	diff_objects
 	if [[ -v DIFF_CHECKSUM ]]; then
@@ -880,7 +915,7 @@ if (( SHORT_CIRCUIT <= 3 )); then
 	fi
 fi
 
-if (( SHORT_CIRCUIT <= 4 )); then
+if (( SHORT_CIRCUIT <= 5 )); then
 	status "Building patch module: $OUTFILE"
 	build_patch_module
 fi
-- 
2.53.0


