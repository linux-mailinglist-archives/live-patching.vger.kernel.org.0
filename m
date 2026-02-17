Return-Path: <live-patching+bounces-2028-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FC+Aj2SlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2028-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:25 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E85514DE35
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A1773011C5A
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C3B36D4FF;
	Tue, 17 Feb 2026 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxR/ytTy"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F62236C0CF
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344439; cv=none; b=cs0TNoyFAkjWkwiah2Qq3TXgoj1Gw/TBp9HbrLldlUa3RKo1ijXNKE+H7bYLVZ1WYVIplG3UubysnZZjeQ19tCX4xfNnsK5joyCdsLYRTYEnF9e8/EmMScul5SFFePPCOJZ35Few6cqjJdkY43yh1r9mkISw8BYWt9Big0J5mY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344439; c=relaxed/simple;
	bh=9iyGjKH/ZCQz73oXk5Oxhr2M6EandGNwSusOMEoz7PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Kv9prRj3YPdtMU++8v/TU//Gy1K4GeP61BLUaD7y064bhRgFmJgRJdpvV3sQhqwAqaF9ERAJqRKgMntj1AqKv2VTOU0+Fmf4h+Oxw7mhG1zxX5cEkeY0bKiy3vMKoqz5k8WtFz5U7cszq/4XjvLKS7EYbUoiaeS8YZ2faJNmdWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XxR/ytTy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35OmfNA781oFbGRjpB6OTJ6e0X0SwSykHvIChQ8N1Ps=;
	b=XxR/ytTy8EK3338ZKwhmVcGBXBfVTncz32lfvL3a3UTw2FyyMHVKLncjmE8lbWuoOMITZU
	eWvEa29eB9PXD1vbfe0lBEN/I7v7V4PajOa9nyDrACknpSspuBHJfaVU/33nik/qREWwYB
	lwqFzNc7DFkjZQ7Mi3ckzVZZ4kfiT+k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-5Y8fN1HGNlW5ljUMiglTmA-1; Tue,
 17 Feb 2026 11:07:10 -0500
X-MC-Unique: 5Y8fN1HGNlW5ljUMiglTmA-1
X-Mimecast-MFC-AGG-ID: 5Y8fN1HGNlW5ljUMiglTmA_1771344429
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F3511800639;
	Tue, 17 Feb 2026 16:07:09 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BB0DD30001A5;
	Tue, 17 Feb 2026 16:07:07 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 12/13] livepatch/klp-build: report patch validation drift
Date: Tue, 17 Feb 2026 11:06:43 -0500
Message-ID: <20260217160645.3434685-13-joe.lawrence@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-2028-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 9E85514DE35
X-Rspamd-Action: no action

Capture the output of the patch command to detect when a patch applies
with fuzz or line offsets.

If such "drift" is detected during the validation phase, warn the user
and display the details.  This helps identify input patches that may need
refreshing against the target source tree.

Ensure that internal patch operations (such as those in refresh_patch or
during the final build phase) can still run quietly.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index fd104ace29e6..5367d573b94b 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -369,11 +369,24 @@ check_unsupported_patches() {
 
 apply_patch() {
 	local patch="$1"
+	shift
+	local extra_args=("$@")
+	local drift_regex="with fuzz|offset [0-9]+ line"
+	local output
+	local status
 
 	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
-	patch -d "$SRC" -p1 --dry-run --silent --no-backup-if-mismatch -r /dev/null < "$patch"
-	patch -d "$SRC" -p1 --silent --no-backup-if-mismatch -r /dev/null < "$patch"
+	status=0
+	output=$(patch -d "$SRC" -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
+	if [[ "$status" -ne 0 ]]; then
+		echo "$output"
+		die "$patch did not apply"
+	elif [[ "$output" =~ $drift_regex ]]; then
+		warn "$patch applied with drift"
+		echo "$output"
+	fi
 
+	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 	APPLIED_PATCHES+=("$patch")
 }
 
@@ -392,10 +405,11 @@ revert_patch() {
 }
 
 apply_patches() {
+	local extra_args=("$@")
 	local patch
 
 	for patch in "${PATCHES[@]}"; do
-		apply_patch "$patch"
+		apply_patch "$patch" "${extra_args[@]}"
 	done
 }
 
@@ -453,7 +467,7 @@ refresh_patch() {
 	( cd "$SRC" && echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
 
 	# Copy patched source files to 'b'
-	apply_patch "$patch"
+	apply_patch "$patch" "--silent"
 	( cd "$SRC" && echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
 	revert_patch "$patch"
 
@@ -826,7 +840,7 @@ fi
 if (( SHORT_CIRCUIT <= 2 )); then
 	status "Fixing patch(es)"
 	fix_patches
-	apply_patches
+	apply_patches "--silent"
 	status "Building patched kernel"
 	build_kernel "patched"
 	revert_patches
-- 
2.53.0


