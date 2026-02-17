Return-Path: <live-patching+bounces-2018-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBm4JCySlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2018-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:08 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F3214DDEE
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 198053016925
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935E136AB58;
	Tue, 17 Feb 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcR+buwr"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554FA1D88AC
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344421; cv=none; b=enT8tEitpF7m51TkEgmAMLvUvCh6+lRkYfWCrsWUtvC+ZG6x8sN1ji2FjU0lN15+pdzatJwb1oxYk/WPIAoe5yxomvkKt4hcmDyB3aTtYDlbFPfKaBHBcyIZekei+jBcVioLcTwHTrmEAGr13Nbq5iIsPVXn3IHdqObvi6si/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344421; c=relaxed/simple;
	bh=pxKGRsk7dfU3vCFEyAwBO04Kc0Wgjr1gST0HwIq8bi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=d5U0rBNmDIAmkegGynyCHSiQ0I9s8mFAwoCiS6QVRAFAtOuNiJDaFl1Nv+81rEopMpw4pwvzZFeAC24wN/gvs+TZp9Dx4pBVFS3p8ow/QTOXxCvEFQXC7FRjAnn1SpNuGgwTHgu92QiZ+RkDHSoAs9+/VIF+PAK/61DFHI7xx8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VcR+buwr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c9dLVQJi30AT2pz7CdraGJvTLefI7/9ALVpdVV6YuCU=;
	b=VcR+buwrNCqHr4/3z4pQ9GPlnQEH6AFJUh4Upsz/ZQ7MfGpGnN9IY8qdKoQd68NPP0kGgK
	a0Li8c9Ock9E3Zq4zSv+kOvoNA0x1pU5U9I9zLFspamnqIExdgSCjBtIm5QYSIb4YMRdAv
	g5bpcox9sGi8xmUdkdRxlptkMuTh1aw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-5Us-gumYNcWo5mTAf5Wi0g-1; Tue,
 17 Feb 2026 11:06:56 -0500
X-MC-Unique: 5Us-gumYNcWo5mTAf5Wi0g-1
X-Mimecast-MFC-AGG-ID: 5Us-gumYNcWo5mTAf5Wi0g_1771344415
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD21818002DE;
	Tue, 17 Feb 2026 16:06:54 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 76B2D30001A5;
	Tue, 17 Feb 2026 16:06:53 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 03/13] livepatch/klp-build: support patches that add/remove files
Date: Tue, 17 Feb 2026 11:06:34 -0500
Message-ID: <20260217160645.3434685-4-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-1-joe.lawrence@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
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
	TAGGED_FROM(0.00)[bounces-2018-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 34F3214DDEE
X-Rspamd-Action: no action

The klp-build script prepares a clean patch by populating two temporary
directories ('a' and 'b') with source files and diffing the result.
However, this process fails when a patch introduces a new source file,
as the script attempts to copy files that do not yet exist in the
original source tree.  Likewise, it fails when a patch removes a source
file and the script attempts to copy a file that no longer exists.

Refactor the file-gathering logic to distinguish between original input
files and patched output files:

- Split get_patch_files() into get_patch_input_files() and
  get_patch_output_files() to identify which files exist before and
  after patch application.
- Filter out "/dev/null" from both to handle file creation/deletion.
- Update refresh_patch() to only copy existing input files to the 'a'
  directory and the resulting output files to the 'b' directory.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 809e198a561d..94ed3b4a91d8 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -296,15 +296,33 @@ set_kernelversion() {
 	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
 }
 
-get_patch_files() {
+get_patch_input_files() {
+	local patch="$1"
+
+	grep0 -E '^--- ' "$patch"				\
+		| gawk '{print $2}'				\
+		| grep0 -v '^/dev/null$'			\
+		| sed 's|^[^/]*/||'				\
+		| sort -u
+}
+
+get_patch_output_files() {
 	local patch="$1"
 
-	grep0 -E '^(--- |\+\+\+ )' "$patch"			\
+	grep0 -E '^\+\+\+ ' "$patch"				\
 		| gawk '{print $2}'				\
+		| grep0 -v '^/dev/null$'			\
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
@@ -312,7 +330,7 @@ git_refresh() {
 
 	[[ ! -e "$SRC/.git" ]] && return
 
-	get_patch_files "$patch" | mapfile -t files
+	get_patch_input_files "$patch" | mapfile -t files
 
 	(
 		cd "$SRC"
@@ -426,21 +444,23 @@ do_init() {
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
2.53.0


