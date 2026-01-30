Return-Path: <live-patching+bounces-1934-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iy1jK7bxfGkUPgIAu9opvQ
	(envelope-from <live-patching+bounces-1934-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B04BD915
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C291300D164
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 18:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A5A2EBBB9;
	Fri, 30 Jan 2026 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gF2n2qMj"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8E236B042
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769796019; cv=none; b=jorSWKA6ZFBlLNUDBIyviVZ8mhE0dJGT/RbEAAqjZZnUztbnL6by2tfkbrssZw+6n1YO506w1SdI7kzPkmD7QCqpQ8zYDCzPO8I2eTwjVFSLe4uBNpGGOtK33/qQqdKzVj2bv2El2hXIVWaV0YWgwQZhpYlQx2EemsF1yy2ve9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769796019; c=relaxed/simple;
	bh=YZpGhsoSHzuUSS3PV5gDNgpOiRUdDbOPtJqY1iE11Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=TuEDJD644V4F+JanXxPlt5LJIB9wrK0HYOUQQ9yL9T+D34RE5l0fijr6VV1KBXx68KZ0VqRzYOzRA3XxezjfhftOKEEHrLgf4q3XjT4E/bozUx2fVRNKyDajcrTmS8je442Mv2XsLbtX7/g2PzpmQVc6RsFcNYmP052y6OWu5lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gF2n2qMj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769796016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FoXJMiEscS3zhpjn4IhScA0v7NRlLoCHYtcwt/Ovk4=;
	b=gF2n2qMjlQr+x8XyJbvdOlnwUHqRn2DRznVHmg64IuT7YWET4X6tTnIM16krgObM533xby
	050CVb7DkHpHnVYbist/WP5zrg3HGSTsfh1cmjOlT5+XXN8eYvABAcr8qh0jiDHAEKe+jg
	InNT/+q8Kl8AMm+m5AN6KNKzJdmqpzs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-jJNYiYlTNXi1JbUm_nLreg-1; Fri,
 30 Jan 2026 13:00:08 -0500
X-MC-Unique: jJNYiYlTNXi1JbUm_nLreg-1
X-Mimecast-MFC-AGG-ID: jJNYiYlTNXi1JbUm_nLreg_1769796007
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F33021954B21;
	Fri, 30 Jan 2026 18:00:06 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFCBD1800995;
	Fri, 30 Jan 2026 18:00:05 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Date: Fri, 30 Jan 2026 12:59:49 -0500
Message-ID: <20260130175950.1056961-5-joe.lawrence@redhat.com>
In-Reply-To: <20260130175950.1056961-1-joe.lawrence@redhat.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1934-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 22B04BD915
X-Rspamd-Action: no action

The klp-build script is currently very strict with input patches,
requiring them to apply cleanly via `git apply --recount`.  This
prevents the use of patches with minor contextual fuzz relative to the
target kernel sources.

Add an optional -z/--fuzz option to allow klp-build to "rebase" input
patches within its klp-tmp/ scratch space.  When enabled, the script
utilizes GNU patch's fuzzy matching to apply changes to a temporary
directory and then creates a normalized version of the patch using `git
diff --no-index`.

This rebased patch contains the exact line counts and context required
for the subsequent klp-build fixup and build steps, allowing users to
reuse a patch across similar kernel streams.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 105 +++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

Using the same 1-line-offset input combined.patch from the previous
patch in this set and adding --fuzz, we can successfully now build it:

  $ ./scripts/livepatch/klp-build -T --fuzz combined.patch
  Rebasing 1 patch(es)
  -> combined.patch
  patching file fs/proc/cmdline.c
  Hunk #1 succeeded at 7 (offset 1 line).
  patching file fs/proc/version.c
  patching file fs/proc/cmdline.c
  Hunk #1 succeeded at 7 (offset 1 line).
  patching file fs/proc/version.c
  Validating patch(es)
  Building original kernel
  Copying original object files
  Fixing patch(es)
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: cmdline_proc_show
  vmlinux.o: changed function: version_proc_show
  Building patch module: livepatch-combined.ko
  SUCCESS 

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 2313bc909f58..535ca18e32c5 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -26,6 +26,7 @@ REPLACE=1
 SHORT_CIRCUIT=0
 JOBS="$(getconf _NPROCESSORS_ONLN)"
 VERBOSE="-s"
+FUZZ_FACTOR=""
 shopt -o xtrace | grep -q 'on' && XTRACE=1
 
 # Avoid removing the previous $TMP_DIR until args have been fully processed.
@@ -49,6 +50,7 @@ KMOD_DIR="$TMP_DIR/kmod"
 STASH_DIR="$TMP_DIR/stash"
 TIMESTAMP="$TMP_DIR/timestamp"
 PATCH_TMP_DIR="$TMP_DIR/tmp"
+REBASE_DIR="$TMP_DIR/rebase"
 
 KLP_DIFF_LOG="$DIFF_DIR/diff.log"
 
@@ -131,6 +133,7 @@ Advanced Options:
 				   3|diff	Diff objects
 				   4|kmod	Build patch module
    -T, --keep-tmp		Preserve tmp dir on exit
+   -z, --fuzz[=NUM]		Rebase patches using fuzzy matching [default: 2]
 
 EOF
 }
@@ -145,8 +148,8 @@ process_args() {
 	local long
 	local args
 
-	short="hfj:o:vdS:T"
-	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfj:o:vdS:Tz::"
+	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp,fuzz::"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -204,6 +207,14 @@ process_args() {
 				keep_tmp=1
 				shift
 				;;
+			-z | --fuzz)
+				if [[ -n "$2" ]]; then
+					FUZZ_FACTOR="$2"
+				else
+					FUZZ_FACTOR=2
+				fi
+				shift 2
+				;;
 			--)
 				shift
 				break
@@ -304,6 +315,94 @@ get_patch_files() {
 		| sort -u
 }
 
+# Rebase a patch using GNU patch with fuzz
+# Outputs path to rebased patch on success, non-zero on failure
+rebase_patch() {
+	local idx="$1"
+	local input_patch="$2"
+	local patch_name="$(basename "$input_patch" .patch)"
+	local work_dir="$REBASE_DIR/$idx-$patch_name"
+	local output_patch="$work_dir/rebased.patch"
+	local files=()
+	local file
+
+	rm -rf "$work_dir"
+	mkdir -p "$work_dir/orig" "$work_dir/patched"
+
+	get_patch_files "$input_patch" | mapfile -t files
+
+	# Copy original files (before patch)
+	for file in "${files[@]}"; do
+		[[ "$file" == "dev/null" ]] && continue
+		if [[ -f "$SRC/$file" ]]; then
+			mkdir -p "$work_dir/orig/$(dirname "$file")"
+			cp -f "$SRC/$file" "$work_dir/orig/$file"
+		fi
+	done
+
+	# Apply with fuzz
+	(
+		cd "$SRC"
+		sed -n '/^-- /q;p' "$input_patch" | \
+			patch -p1 \
+				-F"$FUZZ_FACTOR" \
+				--no-backup-if-mismatch \
+				-r /dev/null \
+				--forward >&2
+	) || return 1
+
+	# Copy patched files (after patch)
+	for file in "${files[@]}"; do
+		[[ "$file" == "dev/null" ]] && continue
+		if [[ -f "$SRC/$file" ]]; then
+			mkdir -p "$work_dir/patched/$(dirname "$file")"
+			cp -f "$SRC/$file" "$work_dir/patched/$file"
+		fi
+	done
+
+	# Revert with fuzz
+	(
+		cd "$SRC"
+		sed -n '/^-- /q;p' "$input_patch" | \
+			patch -p1 -R \
+				-F"$FUZZ_FACTOR" \
+				--no-backup-if-mismatch \
+				-r /dev/null >&2
+	) || {
+		warn "fuzzy revert failed; source tree may be corrupted"
+		return 1
+	}
+
+	# Generate clean patch from captured state
+	( cd "$work_dir" && git diff --no-index --no-prefix orig patched ) > "$output_patch" || true
+
+	echo "$output_patch"
+}
+
+# If the user specified --fuzz, iterate through PATCHES and rebase them
+# Updates PATCHES array in-place with rebased patch paths
+maybe_rebase_patches() {
+	local i
+	local idx
+	local patch
+	local rebased
+
+	[[ -z "$FUZZ_FACTOR" ]] && return 0
+
+	status "Rebasing ${#PATCHES[@]} patch(es)"
+
+	mkdir -p "$REBASE_DIR"
+
+	idx=0001
+	for i in "${!PATCHES[@]}"; do
+		patch="${PATCHES[$i]}"
+		echo "-> $(basename "$patch")"
+		rebased=$(rebase_patch "$idx" "$patch") || die "rebase failed: $patch"
+		PATCHES[i]="$rebased"
+		idx=$(printf "%04d" $(( 10#$idx + 1 )))
+	done
+}
+
 # Make sure git re-stats the changed files
 git_refresh() {
 	local patch="$1"
@@ -807,6 +906,8 @@ build_patch_module() {
 process_args "$@"
 do_init
 
+maybe_rebase_patches
+
 if (( SHORT_CIRCUIT <= 1 )); then
 	status "Validating patch(es)"
 	validate_patches
-- 
2.52.0


