Return-Path: <live-patching+bounces-2659-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDjYN/gp9GlA+wEAu9opvQ
	(envelope-from <live-patching+bounces-2659-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 761544AA3EC
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8526130A8EF8
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC2F36C9D2;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0Okok9a"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081FF2F3632;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608550; cv=none; b=BT5YIS+YVm1rOOrhNoMPvzdMlHBqaUkepO7WyywGFml2zsGC1A0ihKqqXu0G2nVzt3hVlrELhTCDTn8zUEQW271XSaYxADZkK4AfDhnYRH1cWQu/yynYJ6LruvHi4GP5Ty+CEEYMe6KVj47bfsul+tXMZ9MNWQGF2Vmo7pdqFbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608550; c=relaxed/simple;
	bh=HiI3fx7jbK+AIkSfcmy4WLjZ+5lxWSUpcGfEGZlpvDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1wFwCXvKAP+nzWHJ79+KjxaqkPdae5/A90Mxxs3+VEguqAGDhSmOgbk2d6+Pyul43NJK9bxVxQ702ulN5O5/DYiFhSIWWLV95wsA+ffTcHGGYl7ALGDOLRtGQYDdI09ACxtC1zfq/EzmQTb1AUB1NsYycA/zxagZAglahmwtsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0Okok9a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98927C2BCB7;
	Fri,  1 May 2026 04:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608549;
	bh=HiI3fx7jbK+AIkSfcmy4WLjZ+5lxWSUpcGfEGZlpvDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0Okok9a0HHVDs/hwW5AFAlcQN02n0CLq6HACkOraN30wUDGlAgTeznts1nSdylgq
	 0kUAOeExY4IgVovaLkA+I+ZZgYkEi8HUp5vpS/PrUjlmelN5nkgI9Zucw79lORxlRK
	 NNyq39QUqTHADE4DwXzOYZcr2uRuPv4jG21uNTqH5NQOLTlDGvb1sh5mXfsiNakf98
	 ul0ZKn2ZEgaUVgeRkJGdw0INrtgHHQKJuSXuLj74Prs1ufTQ8bD936KVNXX9pTy42E
	 HA0rNYBAMDYiVjdUoAPxGmjvUG/F0xqWCxPJb6BdgnoIk2LTFwCSJ6oJEz2FsP8okN
	 1OwYh/Q2o3K/Q==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 42/53] klp-build: Use "objtool klp checksum" subcommand
Date: Thu, 30 Apr 2026 21:08:30 -0700
Message-ID: <1c4f6e2a4e0a3490947111970f2d8e884afa2588.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 761544AA3EC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2659-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Use the new "objtool klp checksum" subcommand instead of injecting
--checksum into every objtool invocation via OBJTOOL_ARGS during the
kernel build.

This decouples checksum generation from the build, running it in
separate post-build passes, making the code (and the patch generation
pipeline itself) more modular.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 93 +++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 29 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 34a46bafdaec..8a4b268261a6 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -37,10 +37,12 @@ OBJTOOL="$PWD/tools/objtool/objtool"
 CONFIG="$PWD/.config"
 TMP_DIR="$PWD/klp-tmp"
 
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
@@ -136,10 +138,11 @@ Options:
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
@@ -203,10 +206,11 @@ process_args() {
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
@@ -513,11 +517,8 @@ clean_kernel() {
 build_kernel() {
 	local build="$1"
 	local log="$TMP_DIR/build.log"
-	local objtool_args=()
 	local cmd=()
 
-	objtool_args=("--checksum")
-
 	cmd=("make")
 
 	# When a patch to a kernel module references a newly created unexported
@@ -544,7 +545,6 @@ build_kernel() {
 	fi
 	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
-	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
 	cmd+=("vmlinux")
 	cmd+=("modules")
 
@@ -574,7 +574,7 @@ copy_orig_objects() {
 
 	find_objects | mapfile -t files
 
-	xtrace_save "copying orig objects"
+	xtrace_save "copying original objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
 		local file="$PWD/$rel_file"
@@ -630,6 +630,35 @@ copy_patched_objects() {
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
@@ -639,16 +668,16 @@ diff_objects() {
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
@@ -672,7 +701,7 @@ diff_objects() {
 		fi
 
 		(
-			cd "$ORIG_DIR"
+			cd "$ORIG_CSUM_DIR"
 			[[ -v VERBOSE ]] && echo "${cmd[@]}"
 			"${cmd[@]}"							\
 				1> >(tee -a "$log")					\
@@ -682,9 +711,9 @@ diff_objects() {
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
@@ -709,8 +738,7 @@ diff_checksums() {
 	done
 
 	cmd=("$OBJTOOL")
-	cmd+=("--checksum")
-	cmd+=("--link")
+	cmd+=("klp" "checksum")
 	cmd+=("--dry-run")
 
 	for file in "${!funcs[@]}"; do
@@ -719,11 +747,11 @@ diff_checksums() {
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
@@ -861,6 +889,13 @@ if (( SHORT_CIRCUIT <= 2 )); then
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
@@ -869,7 +904,7 @@ if (( SHORT_CIRCUIT <= 3 )); then
 	fi
 fi
 
-if (( SHORT_CIRCUIT <= 4 )); then
+if (( SHORT_CIRCUIT <= 5 )); then
 	status "Building patch module: $OUTFILE"
 	build_patch_module
 fi
-- 
2.53.0


