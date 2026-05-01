Return-Path: <live-patching+bounces-2648-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMS5Hs4o9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2648-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 226594AA29C
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9CAA73093D94
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52A5359A90;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULdb7KDn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E373537CC;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608545; cv=none; b=Dzb7xgeUSddxtNrA/xQng4X73KFyXWmfn9494uIg0GXHxQ1QvEsbqPDrVnxQR/HI7Ve3yhUJcX3omOQWuh0QyEo/l17n5/pmZVGQIlcSSsTS3Osh60IoXh0vsqWruJyk2WgwVXu67GWwHqyF4R76y/gqmRr/Z4rKNKt27PG/a94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608545; c=relaxed/simple;
	bh=5WQETiS7rEgNgSdSGbmwnnu09ScP+70xY/bHo0tLzNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/qfFdciol8BmxdgJvBsEvc8Wazzulg4iBhDAm4rG1mRA3ouS1a6S8GYPE2MHjCkXfm0yAHklNBneomuSSMXNjgjoebvDFZ3hqMuh5lHcd3/g8dvIcuoGrG0xj8bCXOBpLlqkuQ4/ZhExw7djCPLIMjAznwLsjTNTw0CXj1n1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULdb7KDn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052E1C2BCC7;
	Fri,  1 May 2026 04:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608545;
	bh=5WQETiS7rEgNgSdSGbmwnnu09ScP+70xY/bHo0tLzNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULdb7KDnq0Kiv/T9146uuzTiDB05dqBKKpD9QaSKPJHNgsMGF2uX5qCdVRCkexjlm
	 GzeCJLD8UR973Qt9+7xc+0rtypCUGuCzCtkQ2BBQKwO60j9uTv6ycfg4aS8xHgkTAE
	 A3l+2KghGJr78sdGKj9jlA0oyynomCHS0xWOnin00Zd/wgJ/EnvB7lMuHpr0IOsGkB
	 9oJoMfmbATM2fpmq3T6GiJY8s+i6oyrngyfPVXXGmwq0u/rx4dFjj9eYCIlDo5qfuR
	 vMTMOXLzIzm2zQp5kBLCXYLu73q6nrjiuzywsziZ5r7exjFEucyM1KH6GylnITMquw
	 anubQKXJbkpZQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 32/53] klp-build: Remove redundant SRC and OBJ variables
Date: Thu, 30 Apr 2026 21:08:20 -0700
Message-ID: <63b0d7848597ad6011e1f56c8fdd53593d09a992.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 226594AA29C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2648-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

SRC and OBJ are both set to $(pwd) and are always identical.  The script
already enforces that klp-build runs from the kernel root directory, and
builds are done in-place, making these variables unnecessary.

Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 67 ++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 39 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 355345aa94d2..34a46bafdaec 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -33,11 +33,9 @@ SCRIPT="$(basename "$0")"
 SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 FIX_PATCH_LINES="$SCRIPT_DIR/fix-patch-lines"
 
-SRC="$(pwd)"
-OBJ="$(pwd)"
-
-CONFIG="$OBJ/.config"
-TMP_DIR="$OBJ/klp-tmp"
+OBJTOOL="$PWD/tools/objtool/objtool"
+CONFIG="$PWD/.config"
+TMP_DIR="$PWD/klp-tmp"
 
 ORIG_DIR="$TMP_DIR/orig"
 PATCHED_DIR="$TMP_DIR/patched"
@@ -88,7 +86,7 @@ declare -a STASHED_FILES
 
 stash_file() {
 	local file="$1"
-	local rel_file="${file#"$SRC"/}"
+	local rel_file="${file#"$PWD"/}"
 
 	[[ ! -e "$file" ]] && die "no file to stash: $file"
 
@@ -102,7 +100,7 @@ restore_files() {
 	local file
 
 	for file in "${STASHED_FILES[@]}"; do
-		mv -f "$STASH_DIR/$file" "$SRC/$file" || warn "can't restore file: $file"
+		mv -f "$STASH_DIR/$file" "$PWD/$file" || warn "can't restore file: $file"
 	done
 
 	STASHED_FILES=()
@@ -304,7 +302,7 @@ set_module_name() {
 # Hardcode the value printed by the localversion script to prevent patch
 # application from appending it with '+' due to a dirty working tree.
 set_kernelversion() {
-	local file="$SRC/scripts/setlocalversion"
+	local file="$PWD/scripts/setlocalversion"
 	local kernelrelease
 
 	stash_file "$file"
@@ -375,7 +373,7 @@ apply_patch() {
 
 	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
 	status=0
-	output=$(patch -d "$SRC" -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
+	output=$(patch -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
 	if [[ "$status" -ne 0 ]]; then
 		echo "$output" >&2
 		die "$patch did not apply"
@@ -385,14 +383,14 @@ apply_patch() {
 	fi
 
 	APPLIED_PATCHES+=("$patch")
-	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
+	patch -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 }
 
 revert_patch() {
 	local patch="$1"
 	local tmp=()
 
-	patch -d "$SRC" -p1 -R --force --no-backup-if-mismatch -r /dev/null &> /dev/null < "$patch" || true
+	patch -p1 -R --force --no-backup-if-mismatch -r /dev/null &> /dev/null < "$patch" || true
 
 	for p in "${APPLIED_PATCHES[@]}"; do
 		[[ "$p" == "$patch" ]] && continue
@@ -430,8 +428,7 @@ validate_patches() {
 do_init() {
 	# We're not yet smart enough to handle anything other than in-tree
 	# builds in pwd.
-	[[ ! "$SRC" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
-	[[ ! "$OBJ" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
+	[[ ! "$PWD" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
 
 	(( SHORT_CIRCUIT <= 1 )) && rm -rf "$TMP_DIR"
 	mkdir -p "$TMP_DIR"
@@ -462,11 +459,11 @@ refresh_patch() {
 	get_patch_output_files "$patch" | mapfile -t output_files
 
 	# Copy orig source files to 'a'
-	( cd "$SRC" && echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
+	echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a"
 
 	# Copy patched source files to 'b'
 	apply_patch "$patch" "--silent"
-	( cd "$SRC" && echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
+	echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b"
 	revert_patch "$patch"
 
 	# Diff 'a' and 'b' to make a clean patch
@@ -510,10 +507,7 @@ clean_kernel() {
 	cmd+=("-j$JOBS")
 	cmd+=("clean")
 
-	(
-		cd "$SRC"
-		"${cmd[@]}"
-	)
+	"${cmd[@]}"
 }
 
 build_kernel() {
@@ -554,12 +548,10 @@ build_kernel() {
 	cmd+=("vmlinux")
 	cmd+=("modules")
 
-	(
-		cd "$SRC"
-		"${cmd[@]}"							\
-			1> >(tee -a "$log")					\
-			2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2)
-	) || die "$build kernel build failed"
+	"${cmd[@]}"							\
+		1> >(tee -a "$log")					\
+		2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2) \
+		|| die "$build kernel build failed"
 }
 
 find_objects() {
@@ -567,9 +559,9 @@ find_objects() {
 
 	# Find root-level vmlinux.o and non-root-level .ko files,
 	# excluding klp-tmp/ and .git/
-	find "$OBJ" \( -path "$TMP_DIR" -o -path "$OBJ/.git" -o	-regex "$OBJ/[^/][^/]*\.ko" \) -prune -o \
+	find "$PWD" \( -path "$TMP_DIR" -o -path "$PWD/.git" -o -regex "$PWD/[^/][^/]*\.ko" \) -prune -o \
 		    -type f "${opts[@]}"				\
-		    \( -name "*.ko" -o -path "$OBJ/vmlinux.o" \)	\
+		    \( -name "*.ko" -o -path "$PWD/vmlinux.o" \)	\
 		    -printf '%P\n'
 }
 
@@ -585,7 +577,7 @@ copy_orig_objects() {
 	xtrace_save "copying orig objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
-		local file="$OBJ/$rel_file"
+		local file="$PWD/$rel_file"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local orig_dir="$(dirname "$orig_file")"
 
@@ -618,7 +610,7 @@ copy_patched_objects() {
 	xtrace_save "copying changed objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
-		local file="$OBJ/$rel_file"
+		local file="$PWD/$rel_file"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local patched_file="$PATCHED_DIR/$rel_file"
 		local patched_dir="$(dirname "$patched_file")"
@@ -663,7 +655,7 @@ diff_objects() {
 
 		mkdir -p "$(dirname "$out_file")"
 
-		cmd=("$SRC/tools/objtool/objtool")
+		cmd=("$OBJTOOL")
 		cmd+=("klp")
 		cmd+=("diff")
 		(( ${#opts[@]} > 0 )) && cmd+=("${opts[@]}")
@@ -716,7 +708,7 @@ diff_checksums() {
 		fi
 	done
 
-	cmd=("$SRC/tools/objtool/objtool")
+	cmd=("$OBJTOOL")
 	cmd+=("--checksum")
 	cmd+=("--link")
 	cmd+=("--dry-run")
@@ -774,7 +766,7 @@ build_patch_module() {
 	rm -rf "$KMOD_DIR"
 	mkdir -p "$KMOD_DIR"
 
-	cp -f "$SRC/scripts/livepatch/init.c" "$KMOD_DIR"
+	cp -f "$SCRIPT_DIR/init.c" "$KMOD_DIR"
 
 	echo "obj-m := $NAME.o" > "$makefile"
 	echo -n "$NAME-y := init.o" >> "$makefile"
@@ -820,12 +812,9 @@ build_patch_module() {
 	cmd+=("KCFLAGS=${cflags[*]}")
 
 	# Build a "normal" kernel module with init.c and the diffed objects
-	(
-		cd "$SRC"
-		"${cmd[@]}"							\
-			1> >(tee -a "$log")					\
-			2> >(tee -a "$log" >&2)
-	)
+	"${cmd[@]}"							\
+		1> >(tee -a "$log")					\
+		2> >(tee -a "$log" >&2)
 
 	kmod_file="$KMOD_DIR/$NAME.ko"
 
@@ -836,7 +825,7 @@ build_patch_module() {
 	objcopy --remove-section=.BTF "$kmod_file"
 
 	# Fix (and work around) linker wreckage for klp syms / relocs
-	"$SRC/tools/objtool/objtool" klp post-link "$kmod_file" || die "objtool klp post-link failed"
+	"$OBJTOOL" klp post-link "$kmod_file" || die "objtool klp post-link failed"
 
 	cp -f "$kmod_file" "$OUTFILE"
 }
-- 
2.53.0


