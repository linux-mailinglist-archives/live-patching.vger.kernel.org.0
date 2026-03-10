Return-Path: <live-patching+bounces-2171-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLWPCTGBsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2171-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:09 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C58C9257EFB
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48B6B30E4917
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F0D3BF69D;
	Tue, 10 Mar 2026 20:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8+PvDCr"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A903368272
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175086; cv=none; b=eGlyydxB8IwCMOOQ7Y/o4rn4MTZB9RF2NZp1mkCIkptI8+OdPypLDAUvH95+Ezp+4PqKjUrE10F76kBWyIDw1srsD30Kyw4MBe2Mc8434/dJMHcbOelpDqihS55Vgz+xlf1YZlOVt6Sl1iyjuTdQTXkxyo7pjQefLcvLm1QknNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175086; c=relaxed/simple;
	bh=pvt+uPHlj+oB1Ic+mK4RzRIq0l5x+g6ALkpPWxsV0gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=hXg6kTopEXsNoPLBqWlGhNRF35mW4aRqit7Q5UPJ9vakr+sHckHshDa8kWq+/DcTqa79CVag408CzOhZLYKV8hiR+RgpCVOko5UlhH8bx9L7+dTqKZ3GJXbu2Oyo2F8NWBsPyb9WLehnVtIGyJqHa8ukz/aKYezQ5tTatz2P2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8+PvDCr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rORCTuUObG3uWuyBosjqSAV+SYdc9N1cLFhJrFH6Qbo=;
	b=D8+PvDCrUOhYfIZkiMdU2fdXKT5v8XMGIBntxjOXW3TAoeTOMMxxPOabAcJJ85wPSw4o8y
	IqYfPbLeVkZORHAABIFoGYej7hCd1usdcaVuE9Gm3/pGg4CTwOHVqhenFR+tCHzMDfvMzz
	ZiUltlSG/5xLVlGY1SY/ftuWO1S0igg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-w6LzN1SWPRK-QUwkK7HCIQ-1; Tue,
 10 Mar 2026 16:38:02 -0400
X-MC-Unique: w6LzN1SWPRK-QUwkK7HCIQ-1
X-Mimecast-MFC-AGG-ID: w6LzN1SWPRK-QUwkK7HCIQ_1773175081
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28ADF180044D;
	Tue, 10 Mar 2026 20:38:01 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 94A1F19560A6;
	Tue, 10 Mar 2026 20:37:59 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 03/12] livepatch/klp-build: support patches that add/remove files
Date: Tue, 10 Mar 2026 16:37:42 -0400
Message-ID: <20260310203751.1479229-4-joe.lawrence@redhat.com>
In-Reply-To: <20260310203751.1479229-1-joe.lawrence@redhat.com>
References: <20260310203751.1479229-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: C58C9257EFB
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
	TAGGED_FROM(0.00)[bounces-2171-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
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

Acked-by: Song Liu <song@kernel.org>
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


