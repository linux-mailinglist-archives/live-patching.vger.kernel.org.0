Return-Path: <live-patching+bounces-1980-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EG/VGVW0gmnwYgMAu9opvQ
	(envelope-from <live-patching+bounces-1980-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:52:05 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B316E1008
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0557F307B094
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB862D838C;
	Wed,  4 Feb 2026 02:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTddIx5T"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DE12BEC5F
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173518; cv=none; b=m1ShLW3psGJu4aBD7eJ5+nMphikiSW4sqPuV7lq+HeWqrTCUUGEvvG7Q7ZC0RA+IoR/SpjKNc1qlEQ3HU8PniexPnJKTUqeCgj3XUhl70cYVvT9zwA2OvzIHu9h9ctYyjQgD9rT+W9DMW7r8SudU4Ob6Fs7XVFEBmS+miCUTxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173518; c=relaxed/simple;
	bh=KHzomO9cMD96HnJ2/cvRZkEJ5mcoMYAzd7G/TrrPdYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=d1rDMItcP0+NrEHQbw+opD0Hodtf0LXEPSPlKjwD7lF3nooahKBaGGbKEuhEaccoNflcWbcNhT/vNty9z9OITDS65IIGDMtYp1oXiz6RyBDAh2mj2E6bTW+mG63qEr+JIAdL1XMdYb81TmvsB7M7AGvsqENC+Zz6ve+JI8SNt34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTddIx5T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770173515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1IRnZtUJJ7h1v9PhqwOHbG/QDqbDSXNIB/8AwBOCyls=;
	b=DTddIx5Tz4Z+IjllMKVer1WDYnGmc1yqiayMd88GODKHdilJQl4UYu7UaV25g6n0SaZMDy
	e+u+lhgCtNz94nhRF4mn7+xSy7WFU8QALF+ojr9nzjdaFOuaw6tJOxwpiHG1uzlwcOw2Yn
	+ue9a3oVSL5Ts3aKkeIc98UG9MaB/18=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-oMUb0qy0PsS3ZAZ6cponVw-1; Tue,
 03 Feb 2026 21:51:52 -0500
X-MC-Unique: oMUb0qy0PsS3ZAZ6cponVw-1
X-Mimecast-MFC-AGG-ID: oMUb0qy0PsS3ZAZ6cponVw_1770173510
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4BF91800473;
	Wed,  4 Feb 2026 02:51:50 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5D339180094B;
	Wed,  4 Feb 2026 02:51:49 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 3/5] livepatch/klp-build: switch to GNU patch and recountdiff
Date: Tue,  3 Feb 2026 21:51:38 -0500
Message-ID: <20260204025140.2023382-4-joe.lawrence@redhat.com>
In-Reply-To: <20260204025140.2023382-1-joe.lawrence@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1980-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0B316E1008
X-Rspamd-Action: no action

The klp-build script is currently very strict with input patches,
requiring them to apply cleanly via `git apply --recount`.  This
prevents the use of patches with minor contextual fuzz relative to the
target kernel sources.

To allow users to reuse a patch across similar kernel streams, switch to
using GNU patch and patchutils for intermediate patch manipulation.
Update the logic for applying, reverting, and regenerating patches:

- Use 'patch -p1' for better handling of context fuzz.
- Use 'recountdiff' to update line counts after FIX_PATCH_LINES.
- Drop git_refresh() and related git-specific logic.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 50 +++++++++++--------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

I think this does simplify things, but:

  - introduces a dependency on patchutil's recountdiff
  - requires goofy epoch timestamp filtering as `diff -N` doesn't use
    the `git diff` /dev/null, but a localized beginining of time epoch
    that may be 1969 or 1970 depending on the local timezone
  - can be *really* chatty, for example:

  Validating patch(es)
  patching file fs/proc/cmdline.c
  Hunk #1 succeeded at 7 (offset 1 line).
  Fixing patch(es)
  patching file fs/proc/cmdline.c
  Hunk #1 succeeded at 7 (offset 1 line).
  patching file fs/proc/cmdline.c
  patching file fs/proc/cmdline.c
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: override_release
  vmlinux.o: changed function: cmdline_proc_show
  Building patch module: livepatch-cmdline-string.ko
  SUCCESS

  My initial thought was that I'd only be interested in knowing about
  patch offset/fuzz during the validation phase.  And in the interest of
  clarifying some of the output messages, it would be nice to know the
  patch it was referring to, so how about a follow up patch
  pretty-formatting with some indentation like:

  Validating patch(es)
    cmdline-string.patch
      patching file fs/proc/cmdline.c
      Hunk #1 succeeded at 7 (offset 1 line).
  Fixing patch(es)
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: override_release
  vmlinux.o: changed function: cmdline_proc_show
  Building patch module: livepatch-cmdline-string.ko
  SUCCESS

  That said, Song suggested using --silent across the board, so maybe
  tie that into the existing --verbose option?

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 5a99ff4c4729..ee43a9caa107 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -96,7 +96,7 @@ restore_files() {
 
 cleanup() {
 	set +o nounset
-	revert_patches "--recount"
+	revert_patches
 	restore_files
 	[[ "$KEEP_TMP" -eq 0 ]] && rm -rf "$TMP_DIR"
 	return 0
@@ -285,7 +285,7 @@ set_module_name() {
 }
 
 # Hardcode the value printed by the localversion script to prevent patch
-# application from appending it with '+' due to a dirty git working tree.
+# application from appending it with '+' due to a dirty working tree.
 set_kernelversion() {
 	local file="$SRC/scripts/setlocalversion"
 	local localversion
@@ -303,8 +303,8 @@ get_patch_input_files() {
 	local patch="$1"
 
 	grep0 -E '^--- ' "$patch"				\
+		| grep -v -e '/dev/null' -e '1969-12-31' -e '1970-01-01' \
 		| gawk '{print $2}'				\
-		| grep -v '^/dev/null$'				\
 		| sed 's|^[^/]*/||'				\
 		| sort -u
 }
@@ -313,8 +313,8 @@ get_patch_output_files() {
 	local patch="$1"
 
 	grep0 -E '^\+\+\+ ' "$patch"				\
+		| grep -v -e '/dev/null' -e '1969-12-31' -e '1970-01-01' \
 		| gawk '{print $2}'				\
-		| grep -v '^/dev/null$'				\
 		| sed 's|^[^/]*/||'				\
 		| sort -u
 }
@@ -326,21 +326,6 @@ get_patch_files() {
 		| sort -u
 }
 
-# Make sure git re-stats the changed files
-git_refresh() {
-	local patch="$1"
-	local files=()
-
-	[[ ! -e "$SRC/.git" ]] && return
-
-	get_patch_input_files "$patch" | mapfile -t files
-
-	(
-		cd "$SRC"
-		git update-index -q --refresh -- "${files[@]}"
-	)
-}
-
 check_unsupported_patches() {
 	local patch
 
@@ -361,18 +346,14 @@ check_unsupported_patches() {
 
 apply_patch() {
 	local patch="$1"
-	shift
-	local extra_args=("$@")
 
 	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
 
 	(
 		cd "$SRC"
-
-		# The sed strips the version signature from 'git format-patch',
-		# otherwise 'git apply --recount' warns.
-		sed -n '/^-- /q;p' "$patch" |
-			git apply "${extra_args[@]}"
+		# The sed strips the version signature from 'git format-patch'.
+		sed -n '/^-- /q;p' "$patch" | \
+			patch -p1 --no-backup-if-mismatch -r /dev/null
 	)
 
 	APPLIED_PATCHES+=("$patch")
@@ -380,17 +361,13 @@ apply_patch() {
 
 revert_patch() {
 	local patch="$1"
-	shift
-	local extra_args=("$@")
 	local tmp=()
 
 	(
 		cd "$SRC"
-
-		sed -n '/^-- /q;p' "$patch" |
-			git apply --reverse "${extra_args[@]}"
+		sed -n '/^-- /q;p' "$patch" | \
+			patch -p1 -R --silent --no-backup-if-mismatch -r /dev/null
 	)
-	git_refresh "$patch"
 
 	for p in "${APPLIED_PATCHES[@]}"; do
 		[[ "$p" == "$patch" ]] && continue
@@ -437,6 +414,7 @@ do_init() {
 	APPLIED_PATCHES=()
 
 	[[ -x "$FIX_PATCH_LINES" ]] || die "can't find fix-patch-lines"
+	command -v recountdiff &>/dev/null || die "recountdiff not found (install patchutils)"
 
 	validate_config
 	set_module_name
@@ -462,12 +440,12 @@ refresh_patch() {
 	( cd "$SRC" && echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
 
 	# Copy patched source files to 'b'
-	apply_patch "$patch" --recount
+	apply_patch "$patch"
 	( cd "$SRC" && echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
-	revert_patch "$patch" --recount
+	revert_patch "$patch"
 
 	# Diff 'a' and 'b' to make a clean patch
-	( cd "$tmpdir" && git diff --no-index --no-prefix a b > "$patch" ) || true
+	( cd "$tmpdir" && diff -Nupr a b > "$patch" ) || true
 }
 
 # Copy the patches to a temporary directory, fix their lines so as not to
@@ -490,7 +468,7 @@ fix_patches() {
 
 		cp -f "$old_patch" "$tmp_patch"
 		refresh_patch "$tmp_patch"
-		"$FIX_PATCH_LINES" "$tmp_patch" > "$new_patch"
+		"$FIX_PATCH_LINES" "$tmp_patch" | recountdiff > "$new_patch"
 		refresh_patch "$new_patch"
 
 		PATCHES[i]="$new_patch"
-- 
2.52.0


