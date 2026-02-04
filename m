Return-Path: <live-patching+bounces-1979-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HUkLE60gmnwYgMAu9opvQ
	(envelope-from <live-patching+bounces-1979-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:51:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8BCE0FF3
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:51:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 128863020D53
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0949C2BDC05;
	Wed,  4 Feb 2026 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtkCgpUG"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92845237A4F
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 02:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173515; cv=none; b=rutGZEcgPMKt/F6lj6CAnjFeu+RXdsdY3h4oy4aHcO6LcbC314dDhVkGbcz64oiDY/9CTeTr0ATl1gucdEPYiQAvXKOMR2gfKaQX/X01CIg8h5wgJG6hiLeXADvBADuXZC2bu9rWgFB2cQ1rF+jyeyfgvPlCzQy9veM7oNyOWbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173515; c=relaxed/simple;
	bh=IHjo4aIyXhjOfr1HEL43tMfEURKF1U/OIlSnY5MCipw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=LxQ837HZesxLAVNAhhYVohETg0laotd68tiIvY1ZMn9lL7NioFAEg6N0Bfgz2PyED+4Td4vrDByoVadD+X9cEU0VYVYd0J3CjHjIEJ90mXGbKlyMSjyIdnKZjHTwbF1GcWRZxIY/fEmHoQiV6tqlH8qAiA1dUtzVr1sAmxsX/JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UtkCgpUG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770173513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ek3AXyTNWQQ2zgvOY60GChGvhvcLfX/PaZMiWREJP5A=;
	b=UtkCgpUG7KFCF3dgVvyhWAvk3oTPdkP331dK7CEFoeThTIzQGbxXRy6ZoaGgyghdUMbAtR
	FMlrXYVosvZQF1Enod01Kf11DDYyTBi9QveFl5ZCdijPb0cQ5+jyhZTzMxfIVgHVEVMeLg
	f1dXQ1WpInAiGhQHF5MNWY5HmXwfDiA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-VFztmJ02Mdui_H0UT7PIlQ-1; Tue,
 03 Feb 2026 21:51:50 -0500
X-MC-Unique: VFztmJ02Mdui_H0UT7PIlQ-1
X-Mimecast-MFC-AGG-ID: VFztmJ02Mdui_H0UT7PIlQ_1770173509
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10ABD1956050;
	Wed,  4 Feb 2026 02:51:49 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 94C851800947;
	Wed,  4 Feb 2026 02:51:47 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 2/5] livepatch/klp-build: handle patches that add/remove files
Date: Tue,  3 Feb 2026 21:51:37 -0500
Message-ID: <20260204025140.2023382-3-joe.lawrence@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-1979-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 5A8BCE0FF3
X-Rspamd-Action: no action

The klp-build script prepares a clean patch by populating two temporary
directories ('a' and 'b') with source files and diffing the result.
However, this process currently fails when a patch introduces a new
source file as the script attempts to copy files that do not yet exist
in the original source tree.  Likewise, there is a similar limitation
when a patch removes a source file and the script tries to copy files
that no longer exist.

Refactor the file-gathering logic to distinguish between original input
files and patched output files:

- Split get_patch_files() into get_patch_input_files() and
  get_patch_output_files() to identify which files exist before and
  after patch application.
- Filter out "/dev/null" from both to handle file creation/deletion
- Update refresh_patch() to only copy existing input files to the 'a'
  directory and the resulting output files to the 'b' directory.

This allows klp-build to successfully process patches that add or remove
source files.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

Lightly tested with patches that added or removed a source file, as
generated by `git diff`, `git format-patch`, and `diff -Nupr`.

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 9f1b77c2b2b7..5a99ff4c4729 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -299,15 +299,33 @@ set_kernelversion() {
 	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
 }
 
-get_patch_files() {
+get_patch_input_files() {
+	local patch="$1"
+
+	grep0 -E '^--- ' "$patch"				\
+		| gawk '{print $2}'				\
+		| grep -v '^/dev/null$'				\
+		| sed 's|^[^/]*/||'				\
+		| sort -u
+}
+
+get_patch_output_files() {
 	local patch="$1"
 
-	grep0 -E '^(--- |\+\+\+ )' "$patch"			\
+	grep0 -E '^\+\+\+ ' "$patch"				\
 		| gawk '{print $2}'				\
+		| grep -v '^/dev/null$'				\
 		| sed 's|^[^/]*/||'				\
 		| sort -u
 }
 
+get_patch_files() {
+	local patch="$1"
+
+	{ get_patch_input_files "$patch"; get_patch_output_files "$patch"; } \
+		| sort -u
+}
+
 # Make sure git re-stats the changed files
 git_refresh() {
 	local patch="$1"
@@ -315,7 +333,7 @@ git_refresh() {
 
 	[[ ! -e "$SRC/.git" ]] && return
 
-	get_patch_files "$patch" | mapfile -t files
+	get_patch_input_files "$patch" | mapfile -t files
 
 	(
 		cd "$SRC"
@@ -429,21 +447,23 @@ do_init() {
 refresh_patch() {
 	local patch="$1"
 	local tmpdir="$PATCH_TMP_DIR"
-	local files=()
+	local input_files=()
+	local output_files=()
 
 	rm -rf "$tmpdir"
 	mkdir -p "$tmpdir/a"
 	mkdir -p "$tmpdir/b"
 
 	# Get all source files affected by the patch
-	get_patch_files "$patch" | mapfile -t files
+	get_patch_input_files "$patch" | mapfile -t input_files
+	get_patch_output_files "$patch" | mapfile -t output_files
 
 	# Copy orig source files to 'a'
-	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
+	( cd "$SRC" && echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
 
 	# Copy patched source files to 'b'
 	apply_patch "$patch" --recount
-	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
+	( cd "$SRC" && echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
 	revert_patch "$patch" --recount
 
 	# Diff 'a' and 'b' to make a clean patch
-- 
2.52.0


