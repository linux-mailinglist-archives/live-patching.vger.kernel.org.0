Return-Path: <live-patching+bounces-1418-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B49B0AB1E3E
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D48A25DF9
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA7529ACD5;
	Fri,  9 May 2025 20:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X91Ymlt6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B6225F99E;
	Fri,  9 May 2025 20:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821906; cv=none; b=Z00QmLad+nCDJjfC7Q5T66iD0gOoTT07VLiqPQNm1/qM6fNEAK/GA7GM4bFNOniuR2fF5NsHc2gU83KcLgwdLKXFHK4zTMY98ay3HYAGBqdT0B1fEoGvZZgZDy9KKrTNY2hmrqco6ruUkznF359MYC+rDeF17RwvHNzMydUc1io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821906; c=relaxed/simple;
	bh=K7S9V/CGtP7DC5m69+qZjgglsv1CBcatCZU2CSQ7YfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tA+ktBML2SBUqVx7r1EC3la+ch57XLYGyOs2HdhElYZHo1DXePRHxYAeeebF6S9N9uDHOFN/nazJY5wWYqkFPSTRsg3Qv1DRKIJGfTQIaxmaV/eTPrRDy5Y39BLqWTMD0XdJwF8vb9qG0Tt4IvgQBLTPP9lTK+O93V4Aw93pjqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X91Ymlt6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14032C4CEEF;
	Fri,  9 May 2025 20:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821906;
	bh=K7S9V/CGtP7DC5m69+qZjgglsv1CBcatCZU2CSQ7YfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X91Ymlt6h3Y4Q61YN5gu8mOLwGg+QGo439hp5u108TdWj6VSM1to2lOt5hSskGhwH
	 6jSyCMxutp8f68U7QBEl6nfjYFeKr8oiUkEgSA4nGaOVLZz7ZEBJB+Iego4Y0RCWAx
	 l+Hk1IadSabrpV5qSQH9Uf/o5gUnNrPJZDQIyWw6r88I5/iL1x5l8j9KyM8k3tAhhb
	 gQbEscm9FaVzRI9Jg/wjfGJkYJPg90uAuAu9rgQ6mR3COdnQESIy1D7DTHyvXK+NIa
	 KRVScXfe3uuKfkVPB7K9XFdAM5gyPFH5jVwTubcPgLLla6+5dFDYvhXMb3YqvF4kKh
	 MuO2B67hMstNg==
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
Subject: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script for generating livepatch modules
Date: Fri,  9 May 2025 13:17:23 -0700
Message-ID: <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
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

Add a klp-build script which automates the generation of a livepatch
module from a source .patch file by performing the following steps:

  - Builds an original kernel with -function-sections and
    -fdata-sections, plus objtool function checksumming.

  - Applies the .patch file and rebuilds the kernel using the same
    options.

  - Runs 'objtool klp diff' to detect changed functions and generate
    intermediate binary diff objects.

  - Builds a kernel module which links the diff objects with some
    livepatch module init code (scripts/livepatch/init.c).

  - Finalizes the livepatch module (aka work around linker wreckage)
    using 'objtool klp post-link'.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 697 ++++++++++++++++++++++++++++++++++++
 1 file changed, 697 insertions(+)
 create mode 100755 scripts/livepatch/klp-build

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
new file mode 100755
index 000000000000..ebbece6f6b8d
--- /dev/null
+++ b/scripts/livepatch/klp-build
@@ -0,0 +1,697 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Build a livepatch module
+#
+
+# shellcheck disable=SC1090
+
+if (( BASH_VERSINFO[0] < 4 \
+	|| (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4) )); then
+		echo "error: this script requires bash 4.4+" >&2
+	exit 1
+fi
+
+set -o errexit
+set -o errtrace
+set -o pipefail
+set -o nounset
+
+# Allow doing 'cmd | mapfile -t array' instead of 'mapfile -t array < <(cmd)'.
+# This helps keep execution in pipes so pipefail+errexit can catch errors.
+shopt -s lastpipe
+
+unset SKIP_CLEANUP XTRACE
+REPLACE=1
+SHORT_CIRCUIT=0
+shopt -o xtrace | grep -q 'on' && XTRACE=1
+# Avoid removing the previous $TMP_DIR until args have been fully processed.
+KEEP_TMP=1
+
+CPUS="$(getconf _NPROCESSORS_ONLN)"
+VERBOSE="-s"
+
+
+SCRIPT="$(basename "$0")"
+SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
+FIX_PATCH_LINES="$SCRIPT_DIR/fix-patch-lines"
+
+SRC="$(pwd)"
+OBJ="$(pwd)"
+
+CONFIG="$OBJ/.config"
+TMP_DIR="$OBJ/klp-tmp"
+
+ORIG_DIR="$TMP_DIR/orig"
+PATCHED_DIR="$TMP_DIR/patched"
+DIFF_DIR="$TMP_DIR/diff"
+KMOD_DIR="$TMP_DIR/kmod"
+
+STASH_DIR="$TMP_DIR/stash"
+TIMESTAMP="$TMP_DIR/timestamp"
+PATCH_TMP_DIR="$TMP_DIR/tmp"
+
+KLP_DIFF_LOG="$DIFF_DIR/diff.log"
+
+grep0() {
+	command grep "$@" || true
+}
+
+status() {
+	echo "$*"
+}
+
+warn() {
+	echo "error: $(basename "$SCRIPT"): $*" >&2
+}
+
+die() {
+	warn "$@"
+	exit 1
+}
+
+declare -a STASHED_FILES
+
+stash_file() {
+	local file="$1"
+	local rel_file="${file#"$SRC"/}"
+
+	[[ ! -e "$file" ]] && die "no file to stash: $file"
+
+	mkdir -p "$STASH_DIR/$(dirname "$rel_file")"
+	cp -f "$file" "$STASH_DIR/$rel_file"
+
+	STASHED_FILES+=("$rel_file")
+}
+
+restore_files() {
+	local file
+
+	for file in "${STASHED_FILES[@]}"; do
+		mv -f "$STASH_DIR/$file" "$SRC/$file" || warn "can't restore file: $file"
+	done
+
+	STASHED_FILES=()
+}
+
+cleanup() {
+	set +o nounset
+	revert_patches "--recount"
+	restore_files
+	[[ "$KEEP_TMP" -eq 0 ]] && rm -rf "$TMP_DIR"
+	true
+}
+
+trap_err() {
+	warn "line ${BASH_LINENO[0]}: '$BASH_COMMAND'"
+}
+
+trap cleanup  EXIT INT TERM HUP
+trap trap_err ERR
+
+__usage() {
+	cat <<EOF
+Usage: $SCRIPT [OPTIONS] PATCH_FILE(s)
+Generate a livepatch module.
+
+Options:
+   -o, --output <file.ko>	Output file [default: livepatch-<patch-name>.ko]
+       --no-replace		Disable livepatch atomic replace
+   -v, --verbose		Pass V=1 to kernel/module builds
+
+Advanced Options:
+   -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
+				   1|orig	Build original kernel (default)
+				   2|patched	Build patched kernel
+				   3|diff	Diff objects
+				   4|kmod	Build patch module
+   -T, --keep-tmp		Preserve tmp dir on exit
+
+EOF
+}
+
+usage() {
+	__usage >&2
+}
+
+process_args() {
+	local keep_tmp=0
+	local short
+	local long
+	local args
+
+	short="ho:vS:T"
+	long="help,output:,no-replace,verbose,short-circuit:,keep-tmp"
+
+	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
+		echo; usage; exit
+	}
+	eval set -- "$args"
+
+	while true; do
+		case "$1" in
+			-h | --help)
+				usage
+				exit 0
+				;;
+			-o | --output)
+				[[ "$2" != *.ko ]] && die "output filename should end with .ko"
+				OUTFILE="$2"
+				NAME="$(basename "$OUTFILE")"
+				NAME="${NAME%.ko}"
+				NAME="$(module_name_string "$NAME")"
+				shift 2
+				;;
+			--no-replace)
+				REPLACE=0
+				shift
+				;;
+			-v | --verbose)
+				VERBOSE="V=1"
+				shift
+				;;
+			-S | --short-circuit)
+				[[ ! -d "$TMP_DIR" ]] && die "--short-circuit requires preserved klp-tmp dir"
+				keep_tmp=1
+				case "$2" in
+					1 | orig)	SHORT_CIRCUIT=1; ;;
+					2 | patched)	SHORT_CIRCUIT=2; ;;
+					3 | diff)	SHORT_CIRCUIT=3; ;;
+					4 | mod)	SHORT_CIRCUIT=4; ;;
+					*)		die "invalid short-circuit step '$2'" ;;
+				esac
+				shift 2
+				;;
+			-T | --keep-tmp)
+				keep_tmp=1
+				shift
+				;;
+			--)
+				shift
+				break
+				;;
+			*)
+				usage
+				exit 1
+				;;
+		esac
+	done
+
+	if [[ $# -eq 0 ]]; then
+		usage
+		exit 1
+	fi
+
+	KEEP_TMP="$keep_tmp"
+	PATCHES=("$@")
+}
+
+# temporarily disable xtrace for especially verbose code
+xtrace_save() {
+	[[ -v XTRACE ]] && set +x
+	return 0
+}
+
+xtrace_restore() {
+	[[ -v XTRACE ]] && set -x
+	return 0
+}
+
+validate_config() {
+	xtrace_save "reading .config"
+	source "$CONFIG" || die "no .config file in $(dirname "$CONFIG")"
+	xtrace_restore
+
+	[[ -v CONFIG_LIVEPATCH ]]			\
+		|| die "CONFIG_LIVEPATCH not enabled"
+
+	[[ -v CONFIG_GCC_PLUGIN_LATENT_ENTROPY ]]	\
+		&& die "kernel option 'CONFIG_GCC_PLUGIN_LATENT_ENTROPY' not supported"
+
+	[[ -v CONFIG_GCC_PLUGIN_RANDSTRUCT ]]		\
+		&& die "kernel option 'CONFIG_GCC_PLUGIN_RANDSTRUCT' not supported"
+
+	return 0
+}
+
+# Only allow alphanumerics and '_' and '-' in the module name.  Everything else
+# is replaced with '-'.  Also truncate to 55 chars so the full name + NUL
+# terminator fits in the kernel's 56-byte module name array.
+module_name_string() {
+	echo "${1//[^a-zA-Z0-9_-]/-}" | cut -c 1-55
+}
+
+# If the module name wasn't specified on the cmdline with --output, give it a
+# name based on the patch name.
+set_module_name() {
+	[[ -v NAME ]] && return 0
+
+	if [[ "${#PATCHES[@]}" -eq 1 ]]; then
+		NAME="$(basename "${PATCHES[0]}")"
+		NAME="${NAME%.*}"
+	else
+		NAME="patch"
+	fi
+
+	NAME="livepatch-$NAME"
+	NAME="$(module_name_string "$NAME")"
+
+	OUTFILE="$NAME.ko"
+}
+
+# Hardcode the value printed by the localversion script to prevent patch
+# application from appending it with '+' due to a dirty git working tree.
+set_kernelversion() {
+	local file="$SRC/scripts/setlocalversion"
+	local localversion
+
+	stash_file "$file"
+
+	localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
+	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
+	[[ -z "$localversion" ]] && die "setlocalversion failed"
+
+	echo "echo $localversion" > "$file"
+}
+
+get_patch_files() {
+	local patch="$1"
+
+	grep0 -E '^(--- |\+\+\+ )' "$patch"			\
+		| gawk '{print $2}'				\
+		| sed 's|^[^/]*/||'				\
+		| sort -u
+}
+
+# Make sure git re-stats the changed files
+git_refresh() {
+	local patch="$1"
+	local files=()
+
+	[[ ! -d "$SRC/.git" ]] && return
+
+	get_patch_files "$patch" | mapfile -t files
+
+	(
+		cd "$SRC"
+		git update-index -q --refresh -- "${files[@]}"
+	)
+}
+
+check_unsupported_patches() {
+	local patch
+
+	for patch in "${PATCHES[@]}"; do
+		local files=()
+
+		get_patch_files "$patch" | mapfile -t files
+
+		for file in "${files[@]}"; do
+			case "$file" in
+				lib/*|*.S)
+					die "unsupported patch to $file"
+					;;
+			esac
+		done
+	done
+}
+
+apply_patch() {
+	local patch="$1"
+	shift
+	local extra_args=("$@")
+
+	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
+
+	( cd "$SRC" && git apply "${extra_args[@]}" "$patch" )
+
+	APPLIED_PATCHES+=("$patch")
+}
+
+revert_patch() {
+	local patch="$1"
+	shift
+	local extra_args=("$@")
+	local tmp=()
+
+	( cd "$SRC" && git apply --reverse "${extra_args[@]}" "$patch" )
+	git_refresh "$patch"
+
+	for p in "${APPLIED_PATCHES[@]}"; do
+		[[ "$p" == "$patch" ]] && continue
+		tmp+=("$p")
+	done
+
+	APPLIED_PATCHES=("${tmp[@]}")
+}
+
+apply_patches() {
+	local patch
+
+	for patch in "${PATCHES[@]}"; do
+		apply_patch "$patch"
+	done
+}
+
+revert_patches() {
+	local extra_args=("$@")
+	local patches=("${APPLIED_PATCHES[@]}")
+
+	for (( i=${#patches[@]}-1 ; i>=0 ; i-- )) ; do
+		revert_patch "${patches[$i]}" "${extra_args[@]}"
+	done
+
+	APPLIED_PATCHES=()
+
+	# Make sure git actually sees the patches have been reverted.
+	[[ -d "$SRC/.git" ]] && (cd "$SRC" && git update-index -q --refresh)
+}
+
+validate_patches() {
+	check_unsupported_patches
+	apply_patches
+	revert_patches
+}
+
+do_init() {
+	# We're not yet smart enough to handle anything other than in-tree
+	# builds in pwd.
+	[[ ! "$SRC" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
+	[[ ! "$OBJ" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
+
+	(( SHORT_CIRCUIT <= 1 )) && rm -rf "$TMP_DIR"
+	mkdir -p "$TMP_DIR"
+
+	APPLIED_PATCHES=()
+
+	[[ -x "$FIX_PATCH_LINES" ]] || die "can't find fix-patch-lines"
+
+	validate_config
+	set_module_name
+	set_kernelversion
+}
+
+# Refresh the patch hunk headers, specifically the line numbers and counts.
+refresh_patch() {
+	local patch="$1"
+	local tmpdir="$PATCH_TMP_DIR"
+	local files=()
+
+	rm -rf "$tmpdir"
+	mkdir -p "$tmpdir/a"
+	mkdir -p "$tmpdir/b"
+
+	# Find all source files affected by the patch
+	grep0 -E '^(--- |\+\+\+ )[^ /]+' "$patch"	|
+		sed -E 's/(--- |\+\+\+ )[^ /]+\///'	|
+		sort | uniq | mapfile -t files
+
+	# Copy orig source files to 'a'
+	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
+
+	# Copy patched source files to 'b'
+	apply_patch "$patch" --recount
+	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
+	revert_patch "$patch" --recount
+
+	# Diff 'a' and 'b' to make a clean patch
+	( cd "$tmpdir" && git diff --no-index --no-prefix a b > "$patch" ) || true
+}
+
+# Copy the patches to a temporary directory, fix their lines so as not to
+# affect the __LINE__ macro for otherwise unchanged functions further down the
+# file, and update $PATCHES to point to the fixed patches.
+fix_patches() {
+	local idx
+	local i
+
+	rm -f "$TMP_DIR"/*.patch
+
+	idx=0001
+	for i in "${!PATCHES[@]}"; do
+		local old_patch="${PATCHES[$i]}"
+		local tmp_patch="$TMP_DIR/tmp.patch"
+		local patch="${PATCHES[$i]}"
+		local new_patch
+
+		new_patch="$TMP_DIR/$idx-fixed-$(basename "$patch")"
+
+		cp -f "$old_patch" "$tmp_patch"
+		refresh_patch "$tmp_patch"
+		"$FIX_PATCH_LINES" "$tmp_patch" > "$new_patch"
+		refresh_patch "$new_patch"
+
+		PATCHES[i]="$new_patch"
+
+		rm -f "$tmp_patch"
+		idx=$(printf "%04d" $(( 10#$idx + 1 )))
+	done
+}
+
+build_kernel() {
+	local log="$TMP_DIR/build.log"
+	local objtool_args=()
+	local cmd=()
+
+	objtool_args=("--checksum")
+	[[ -v OBJTOOL_ARGS ]] && objtool_args+=("${OBJTOOL_ARGS}")
+
+	cmd=("make")
+
+	# When a patch to a kernel module references a newly created unexported
+	# symbol which lives in vmlinux or another kernel module, the patched
+	# kernel build fails with the following error:
+	#
+	#   ERROR: modpost: "klp_string" [fs/xfs/xfs.ko] undefined!
+	#
+	# The undefined symbols are working as designed in that case.  They get
+	# resolved later when the livepatch module build link pulls all the
+	# disparate objects together into the same kernel module.
+	#
+	# It would be good to have a way to tell modpost to skip checking for
+	# undefined symbols altogether.  For now, just convert the error to a
+	# warning with KBUILD_MODPOST_WARN, and grep out the warning to avoid
+	# confusing the user.
+	#
+	cmd+=("KBUILD_MODPOST_WARN=1")
+
+	cmd+=("$VERBOSE")
+	cmd+=("-j$CPUS")
+	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
+	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
+	cmd+=("vmlinux")
+	cmd+=("modules")
+
+	(
+		cd "$SRC"
+		"${cmd[@]}"							\
+			> >(tee -a "$log")					\
+			2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2)
+	)
+}
+
+find_objects() {
+	local opts=("$@")
+
+	# Find root-level vmlinux.o and non-root-level .ko files,
+	# excluding klp-tmp/ and .git/
+	find "$OBJ" \( -path "$TMP_DIR" -o -path "$OBJ/.git" -o	-regex "$OBJ/[^/][^/]*\.ko" \) -prune -o \
+		    -type f "${opts[@]}"				\
+		    \( -name "*.ko" -o -path "$OBJ/vmlinux.o" \)	\
+		    -printf '%P\n'
+}
+
+# Copy all objects (.o archives) to $ORIG_DIR
+copy_orig_objects() {
+
+	rm -rf "$ORIG_DIR"
+	mkdir -p "$ORIG_DIR"
+
+	(
+		cd "$OBJ"
+		find_objects						\
+			| sed 's/\.ko$/.o/'				\
+			| xargs cp --parents --target-directory="$ORIG_DIR"
+	)
+
+	mv -f "$TMP_DIR/build.log" "$ORIG_DIR"
+	touch "$TIMESTAMP"
+}
+
+# Copy all changed objects to $PATCHED_DIR
+copy_patched_objects() {
+	local found
+	local files=()
+	local opts=()
+
+	rm -rf "$PATCHED_DIR"
+	mkdir -p "$PATCHED_DIR"
+
+	# Note this doesn't work with some configs, thus the 'cmp' below.
+	opts=("-newer")
+	opts+=("$TIMESTAMP")
+
+	find_objects "${opts[@]}" | mapfile -t files
+
+	xtrace_save "processing all objects"
+	for _file in "${files[@]}"; do
+		local rel_file="${_file/.ko/.o}"
+		local file="$OBJ/$rel_file"
+		local orig_file="$ORIG_DIR/$rel_file"
+		local patched_file="$PATCHED_DIR/$rel_file"
+
+		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
+
+		cmp -s "$orig_file" "$file" && continue
+
+		mkdir -p "$(dirname "$patched_file")"
+		cp -f "$file" "$patched_file"
+		found=1
+	done
+	xtrace_restore
+
+	[[ -n "$found" ]] || die "no changes detected"
+
+	mv -f "$TMP_DIR/build.log" "$PATCHED_DIR"
+}
+
+# Diff changed objects, writing output object to $DIFF_DIR
+diff_objects() {
+	local log="$KLP_DIFF_LOG"
+	local files=()
+
+	rm -rf "$DIFF_DIR"
+	mkdir -p "$DIFF_DIR"
+
+	find "$PATCHED_DIR" -type f -name "*.o" | mapfile -t files
+	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
+
+	# Diff all changed objects
+	for file in "${files[@]}"; do
+		local rel_file="${file#"$PATCHED_DIR"/}"
+		local orig_file="$rel_file"
+		local patched_file="$PATCHED_DIR/$rel_file"
+		local out_file="$DIFF_DIR/$rel_file"
+		local cmd=()
+
+		mkdir -p "$(dirname "$out_file")"
+
+		cmd=("$SRC/tools/objtool/objtool")
+		cmd+=("klp")
+		cmd+=("diff")
+		cmd+=("$orig_file")
+		cmd+=("$patched_file")
+		cmd+=("$out_file")
+
+		(
+			cd "$ORIG_DIR"
+			"${cmd[@]}"							\
+				> >(tee -a "$log")					\
+				2> >(tee -a "$log" >&2)					\
+				|| die "objtool klp diff failed"
+		)
+	done
+}
+
+# Build and post-process livepatch module in $KMOD_DIR
+build_patch_module() {
+	local makefile="$KMOD_DIR/Kbuild"
+	local log="$KMOD_DIR/build.log"
+	local cflags=()
+	local files=()
+	local cmd=()
+
+	rm -rf "$KMOD_DIR"
+	mkdir -p "$KMOD_DIR"
+
+	cp -f "$SRC/scripts/livepatch/init.c" "$KMOD_DIR"
+
+	echo "obj-m := $NAME.o" > "$makefile"
+	echo -n "$NAME-y := init.o" >> "$makefile"
+
+	find "$DIFF_DIR" -type f -name "*.o" | mapfile -t files
+	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
+
+	for file in "${files[@]}"; do
+		local rel_file="${file#"$DIFF_DIR"/}"
+		local kmod_file="$KMOD_DIR/$rel_file"
+		local cmd_file
+
+		mkdir -p "$(dirname "$kmod_file")"
+		cp -f "$file" "$kmod_file"
+
+		# Tell kbuild this is a prebuilt object
+		cp -f "$file" "${kmod_file}_shipped"
+
+		echo -n " $rel_file" >> "$makefile"
+
+		cmd_file="$ORIG_DIR/$(dirname "$rel_file")/.$(basename "$rel_file").cmd"
+		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$(dirname "$kmod_file")"
+	done
+
+	echo >> "$makefile"
+
+	cflags=("-ffunction-sections")
+	cflags+=("-fdata-sections")
+	[[ $REPLACE -eq 0 ]] && cflags+=("-DKLP_NO_REPLACE")
+
+	cmd=("make")
+	cmd+=("$VERBOSE")
+	cmd+=("-j$CPUS")
+	cmd+=("--directory=.")
+	cmd+=("M=$KMOD_DIR")
+	cmd+=("KCFLAGS=${cflags[*]}")
+
+	# Build a "normal" kernel module with init.c and the diffed objects
+	(
+		cd "$SRC"
+		"${cmd[@]}"							\
+			>  >(tee -a "$log")					\
+			2> >(tee -a "$log" >&2)
+	)
+
+	# Save off the intermediate binary for debugging
+	cp -f "$KMOD_DIR/$NAME.ko" "$KMOD_DIR/$NAME.ko.orig"
+
+	# Fix (and work around) linker wreckage for klp syms / relocs
+	"$SRC/tools/objtool/objtool" klp post-link "$KMOD_DIR/$NAME.ko" || die "objtool klp post-link failed"
+
+	cp -f "$KMOD_DIR/$NAME.ko" "$OUTFILE"
+}
+
+
+################################################################################
+
+process_args "$@"
+do_init
+
+if (( SHORT_CIRCUIT <= 1 )); then
+	status "Building original kernel"
+	validate_patches
+	build_kernel
+	status "Copying original object files"
+	copy_orig_objects
+fi
+
+if (( SHORT_CIRCUIT <= 2 )); then
+	status "Fixing patches"
+	fix_patches
+	apply_patches
+	status "Building patched kernel"
+	build_kernel
+	revert_patches
+	status "Copying patched object files"
+	copy_patched_objects
+fi
+
+if (( SHORT_CIRCUIT <= 3 )); then
+	status "Diffing objects"
+	diff_objects
+fi
+
+if (( SHORT_CIRCUIT <= 4 )); then
+	status "Building patch module: $OUTFILE"
+	build_patch_module
+fi
+
+status "SUCCESS"
-- 
2.49.0


