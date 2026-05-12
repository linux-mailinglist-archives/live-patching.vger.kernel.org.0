Return-Path: <live-patching+bounces-2749-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id PO59N5alA2qf8gEAu9opvQ
	(envelope-from <live-patching+bounces-2749-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D81C252ABAD
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CC3F63028554
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 22:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8693932CD;
	Tue, 12 May 2026 22:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KtEPBJDb"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EC239A048
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623879; cv=none; b=GSI44RHfe5IZBG8j7pmsfaoUW4lHRgmvcynJ1wN00WpDgmuLum2D+NAk60ljJh351XkzkL6i1IbUE99vV2+pvocCL9KzXRwfU8r7AwQQvawdwrwgLPKDsFyPKFiJKvR5MM1wyX22R4ImbmxqXXChJd+3Fc5ziX/yoIgP4V0DuKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623879; c=relaxed/simple;
	bh=ZlNDe47xnL0/zPxohYBs9qW9GAXdcCt+pG3/sDxhc0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=MhN02lEzLF+zFcD/+x5waOXJq8dLHRfRYw94OSknZVtN5Dl/3+w8HXR2iLDdUG23ZD/XwLLrQQbIxa/Oxvted3+lo/8mVPWS8NilVmdbdWX+wZZ5PgnHfdyUCscbM7qc0akFFvEsV9QedqQVvAKBcwI/upauXDuQQQV3d1UBjHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KtEPBJDb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778623877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQyzWIEoj+1BBNUogKgZJ+a06FHPUEbHv1XAlYwio8Y=;
	b=KtEPBJDbamq63pfzYFdGcWcYUbaJq78uHaxRxHM4qtpswilkqr1TuObpD1r+eTvai8/ovj
	kXmyhuVa/bljldTFHRJtYxn/Blj5KILHa+B98jPfvPT4vaVujs0u2GFfy3McE+ZQ+uh/sm
	OWAn6lDcZQuQWeHZB7U90wgA0Kv3Neg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-350-mvzBiAPqOA2c92uFb5ylWA-1; Tue,
 12 May 2026 18:11:15 -0400
X-MC-Unique: mvzBiAPqOA2c92uFb5ylWA-1
X-Mimecast-MFC-AGG-ID: mvzBiAPqOA2c92uFb5ylWA_1778623874
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA23E1955F2C;
	Tue, 12 May 2026 22:11:13 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.89.145])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4B3F180076A;
	Tue, 12 May 2026 22:11:12 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [RFC 4/4] livepatch/klp-build: add basic out-of-tree module patching support
Date: Tue, 12 May 2026 18:11:02 -0400
Message-ID: <20260512221102.2720763-5-joe.lawrence@redhat.com>
In-Reply-To: <20260512221102.2720763-1-joe.lawrence@redhat.com>
References: <20260512221102.2720763-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: D81C252ABAD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2749-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

klp-build is currently limited to patching in-tree kernel modules.
Introduce a -M/--module-dir option to enable livepatch generation for
basic out-of-tree (OOT) modules.  This requires the associated kernel
tree to be pre-configured (e.g., 'make modules_prepare').

The OOT workflow is as follows:

  cd /path/to/kernel
  ./scripts/livepatch/klp-build -M /path/to/mymodule my-fix.patch

With this option, klp-build performs two builds (original and patched)
of the OOT module via 'make M=...' instead of a full kernel rebuild.
The resulting objects are then processed and diffed to produce the
final livepatch .ko.

While this enhancement does not yet cover every OOT scenario, it
provides a functional baseline and enables OOT unit-testing for
the 'objtool klp diff' command.

Current limitations include:
 - Separate build directories (make O=) are not yet supported.
 - No passthrough for extra Kbuild variables (e.g., EXTRA_CFLAGS or
   specific CONFIG_* overrides like DKMS supports).
 - OOT module source must be contained within a single directory.
   Multi-directory layouts are not handled.

Assisted-by: Cursor:claude-4.6-opus
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 90 ++++++++++++++++++++++++++++---------
 1 file changed, 69 insertions(+), 21 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 10145b1dd089..db4da64f2b9f 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -21,6 +21,7 @@ shopt -s lastpipe
 
 unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP VERBOSE XTRACE
 
+MODULE_DIR=""
 REPLACE=1
 SHORT_CIRCUIT=0
 JOBS="$(getconf _NPROCESSORS_ONLN)"
@@ -137,6 +138,7 @@ Options:
 
 Advanced Options:
    -d, --debug			Show symbol/reloc cloning decisions
+   -M, --module-dir=<DIR>	Out-of-tree module source directory
    -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
 				   1|orig		Build original kernel (default)
 				   2|patched		Build patched kernel
@@ -159,8 +161,8 @@ process_args() {
 	local args
 	local patch
 
-	short="hfj:o:vdS:T"
-	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfj:M:o:vdS:T"
+	long="help,show-first-changed,jobs:,module-dir:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -202,6 +204,10 @@ process_args() {
 				keep_tmp=1
 				shift
 				;;
+			-M | --module-dir)
+				MODULE_DIR="$2"
+				shift 2
+				;;
 			-S | --short-circuit)
 				[[ ! -d "$TMP_DIR" ]] && die "--short-circuit requires preserved klp-tmp dir"
 				keep_tmp=1
@@ -361,11 +367,21 @@ check_unsupported_patches() {
 		get_patch_files "$patch" | mapfile -t files
 
 		for file in "${files[@]}"; do
+			# In and out-of-tree paths to reject
 			case "$file" in
-				lib/*|*/vdso/*|*/realmode/rm/*|*.S)
+				*.S)
 					die "${patch}: unsupported patch to $file"
 					;;
 			esac
+
+			# In-tree paths to reject (based on naming convention)
+			if [[ -z "$MODULE_DIR" ]]; then
+				case "$file" in
+					lib/*|*/vdso/*|*/realmode/rm/*)
+						die "${patch}: unsupported patch to $file"
+						;;
+				esac
+			fi
 		done
 	done
 }
@@ -374,13 +390,14 @@ apply_patch() {
 	local patch="$1"
 	shift
 	local extra_args=("$@")
+	local patch_target="${MODULE_DIR:-$PWD}"
 	local drift_regex="with fuzz|offset [0-9]+ line"
 	local output
 	local status
 
 	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
 	status=0
-	output=$(patch -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
+	output=$(patch -d "$patch_target" -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
 	if [[ "$status" -ne 0 ]]; then
 		echo "$output" >&2
 		die "$patch did not apply"
@@ -390,14 +407,15 @@ apply_patch() {
 	fi
 
 	APPLIED_PATCHES+=("$patch")
-	patch -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
+	patch -d "$patch_target" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 }
 
 revert_patch() {
 	local patch="$1"
+	local patch_target="${MODULE_DIR:-$PWD}"
 	local tmp=()
 
-	patch -p1 -R --force --no-backup-if-mismatch -r /dev/null &> /dev/null < "$patch" || true
+	patch -d "$patch_target" -p1 -R --force --no-backup-if-mismatch -r /dev/null &> /dev/null < "$patch" || true
 
 	for p in "${APPLIED_PATCHES[@]}"; do
 		[[ "$p" == "$patch" ]] && continue
@@ -452,8 +470,6 @@ cross_compile_init() {
 }
 
 do_init() {
-	# We're not yet smart enough to handle anything other than in-tree
-	# builds in pwd.
 	[[ ! "$PWD" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
 
 	if (( SHORT_CIRCUIT >= 2 )); then
@@ -470,6 +486,15 @@ do_init() {
 		[[ -f "$DIFF_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $DIFF_DIR"
 	fi
 
+	if [[ -n "$MODULE_DIR" ]]; then
+		[[ -d "$MODULE_DIR" ]] || die "module directory not found: $MODULE_DIR"
+		MODULE_DIR="$(realpath "$MODULE_DIR")"
+		[[ -f "$MODULE_DIR/Kbuild" || -f "$MODULE_DIR/Makefile" ]] ||
+			die "no Kbuild or Makefile in $MODULE_DIR"
+		[[ -f "$PWD/Module.symvers" ]] ||
+			die "kernel must be built first (no Module.symvers in $PWD)"
+	fi
+
 	(( SHORT_CIRCUIT <= 1 )) && rm -rf "$TMP_DIR"
 	mkdir -p "$TMP_DIR"
 
@@ -488,6 +513,7 @@ do_init() {
 refresh_patch() {
 	local patch="$1"
 	local tmpdir="$PATCH_TMP_DIR"
+	local patch_target="${MODULE_DIR:-$PWD}"
 	local input_files=()
 	local output_files=()
 
@@ -500,11 +526,11 @@ refresh_patch() {
 	get_patch_output_files "$patch" | mapfile -t output_files
 
 	# Copy orig source files to 'a'
-	echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a"
+	( cd "$patch_target" && echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
 
 	# Copy patched source files to 'b'
 	apply_patch "$patch" "--silent"
-	echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b"
+	( cd "$patch_target" && echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
 	revert_patch "$patch"
 
 	# Diff 'a' and 'b' to make a clean patch
@@ -546,6 +572,9 @@ clean_kernel() {
 	cmd=("make")
 	cmd+=("--silent")
 	cmd+=("-j$JOBS")
+	if [[ -n "$MODULE_DIR" ]]; then
+		cmd+=("M=$MODULE_DIR")
+	fi
 	cmd+=("clean")
 
 	"${cmd[@]}"
@@ -582,7 +611,11 @@ build_kernel() {
 	fi
 	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
-	cmd+=("vmlinux")
+	if [[ -n "$MODULE_DIR" ]]; then
+		cmd+=("M=$MODULE_DIR")
+	else
+		cmd+=("vmlinux")
+	fi
 	cmd+=("modules")
 
 	"${cmd[@]}"							\
@@ -594,12 +627,19 @@ build_kernel() {
 find_objects() {
 	local opts=("$@")
 
-	# Find root-level vmlinux.o and non-root-level .ko files,
-	# excluding klp-tmp/ and .git/
-	find "$PWD" \( -path "$TMP_DIR" -o -path "$PWD/.git" -o -regex "$PWD/[^/][^/]*\.ko" \) -prune -o \
-		    -type f "${opts[@]}"				\
-		    \( -name "*.ko" -o -path "$PWD/vmlinux.o" \)	\
-		    -printf '%P\n'
+	if [[ -n "$MODULE_DIR" ]]; then
+		# OOT: find .ko at any depth under the module dir
+		find "$MODULE_DIR" -path "$MODULE_DIR/.git" -prune -o \
+			-type f "${opts[@]}" \
+			-name "*.ko" -printf '%P\n'
+	else
+		# In-tree: find root-level vmlinux.o and non-root-level .ko files,
+		# excluding klp-tmp/ and .git/
+		find "$PWD" \( -path "$TMP_DIR" -o -path "$PWD/.git" -o	-regex "$PWD/[^/][^/]*\.ko" \) -prune -o \
+			    -type f "${opts[@]}"				\
+			    \( -name "*.ko" -o -path "$PWD/vmlinux.o" \)	\
+			    -printf '%P\n'
+	fi
 }
 
 # Copy all .o archives to $ORIG_DIR
@@ -611,10 +651,11 @@ copy_orig_objects() {
 
 	find_objects | mapfile -t files
 
+	local obj_root="${MODULE_DIR:-$PWD}"
 	xtrace_save "copying original objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
-		local file="$PWD/$rel_file"
+		local file="$obj_root/$rel_file"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local orig_dir="$(dirname "$orig_file")"
 
@@ -645,10 +686,11 @@ copy_patched_objects() {
 
 	find_objects "${opts[@]}" | mapfile -t files
 
+	local obj_root="${MODULE_DIR:-$PWD}"
 	xtrace_save "copying changed objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
-		local file="$PWD/$rel_file"
+		local file="$obj_root/$rel_file"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local patched_file="$PATCHED_DIR/$rel_file"
 		local patched_dir="$(dirname "$patched_file")"
@@ -727,6 +769,9 @@ diff_objects() {
 		cmd+=("klp")
 		cmd+=("diff")
 		(( ${#opts[@]} > 0 )) && cmd+=("${opts[@]}")
+
+		[[ -n "$MODULE_DIR" ]] && cmd+=("--symvers" "$PWD/Module.symvers")
+
 		cmd+=("$orig_file")
 		cmd+=("$patched_file")
 		cmd+=("$out_file")
@@ -905,13 +950,16 @@ build_patch_module() {
 process_args "$@"
 do_init
 
+BUILD_TARGET="kernel"
+[[ -n "$MODULE_DIR" ]] && BUILD_TARGET="module ${MODULE_DIR##*/}"
+
 if (( SHORT_CIRCUIT <= 2 )); then
 	status "Validating patch(es)"
 	validate_patches
 fi
 
 if (( SHORT_CIRCUIT <= 1 )); then
-	status "Building original kernel"
+	status "Building original $BUILD_TARGET"
 	clean_kernel
 	build_kernel "original"
 	status "Copying original object files"
@@ -922,7 +970,7 @@ if (( SHORT_CIRCUIT <= 2 )); then
 	status "Fixing patch(es)"
 	fix_patches
 	apply_patches "--silent"
-	status "Building patched kernel"
+	status "Building patched $BUILD_TARGET"
 	build_kernel "patched"
 	revert_patches
 	status "Copying patched object files"
-- 
2.53.0


