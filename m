Return-Path: <live-patching+bounces-1935-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YI1rELrxfGndPQIAu9opvQ
	(envelope-from <live-patching+bounces-1935-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:26 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE51BD91E
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4A7673004632
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 18:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D43D36999A;
	Fri, 30 Jan 2026 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYY+kbjj"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9027286410
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769796024; cv=none; b=aIPN0rA84TFHw74Kys5zgfQtC9K+k1j6scnvI/lA9Y4IxhiYAfKVFO8UFgfRqGtfN0H5NyhMZEvUTMkZ2ARhr621y8TT+CyctZzTtvy+IsNg2PJX381J2vZ8aWGvfKXi6i2OVGe+MM6dlbFkgyzP6ExsZhdWDCJDZsRDqkc7AJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769796024; c=relaxed/simple;
	bh=NAzVAt62STxoeNOKK9wso0S8Uyh09YdR6R0UyULVYFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=dfVnLWYYW738Uoi6MEOMhATRwBB2BzQDo8erac8cE0itJHEXEDqyeWOcV0wAqOnW4pa0GpoSQxEgLi8VKdC8e5omF4hKgjUJmObHyoN1E9n5vEZnfGujfEnCAnf1gV+YLz1yCCuC3Vo5HLOE1f8BfIVFnFbwTbNvABar+y/lTMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RYY+kbjj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769796021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lISx/+l6MjBmDGSxw3FLJF9iykYaJ1nB0oXSfT6mefg=;
	b=RYY+kbjjOGGgv82nROpcb7Yw64Po1rvxAzC/qNB5b+U2Ji9mWCKjs0oSDK0NE2T7/2oSYr
	uTm3Xx8paeb9JfEAwtPI0HTVuwtoIZCcrdNa7DqAyOFKxXniCU8tqaZ2pcbD2iFHLIMdMQ
	ZChoBswuVMWKE7dv6ygt+z7KfAZatHQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-fovFmLstMBabyLCL4ctytQ-1; Fri,
 30 Jan 2026 13:00:09 -0500
X-MC-Unique: fovFmLstMBabyLCL4ctytQ-1
X-Mimecast-MFC-AGG-ID: fovFmLstMBabyLCL4ctytQ_1769796008
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49ACE18005BB;
	Fri, 30 Jan 2026 18:00:08 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 357801800665;
	Fri, 30 Jan 2026 18:00:07 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 5/5] objtool/klp: provide friendlier error messages
Date: Fri, 30 Jan 2026 12:59:50 -0500
Message-ID: <20260130175950.1056961-6-joe.lawrence@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1935-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DCE51BD91E
X-Rspamd-Action: no action

Provide a little bit more context behind some of the klp-build failure
modes clarify which of the user-provided patches is unsupported,
doesn't apply, and which kernel build failed.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 535ca18e32c5..64a18c2ae1ba 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -429,7 +429,7 @@ check_unsupported_patches() {
 		for file in "${files[@]}"; do
 			case "$file" in
 				lib/*|*.S)
-					die "unsupported patch to $file"
+					die "$patch unsupported patch to $file"
 					;;
 			esac
 		done
@@ -449,7 +449,7 @@ apply_patch() {
 		# The sed strips the version signature from 'git format-patch',
 		# otherwise 'git apply --recount' warns.
 		sed -n '/^-- /q;p' "$patch" |
-			git apply "${extra_args[@]}"
+			git apply "${extra_args[@]}" || die "$patch doesn't apply (retry with --fuzz?)"
 	)
 
 	APPLIED_PATCHES+=("$patch")
@@ -601,6 +601,7 @@ clean_kernel() {
 }
 
 build_kernel() {
+	local build="$1"
 	local log="$TMP_DIR/build.log"
 	local objtool_args=()
 	local cmd=()
@@ -638,7 +639,7 @@ build_kernel() {
 		"${cmd[@]}"							\
 			1> >(tee -a "$log")					\
 			2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2)
-	)
+	) || die "$build kernel build failed"
 }
 
 find_objects() {
@@ -913,7 +914,7 @@ if (( SHORT_CIRCUIT <= 1 )); then
 	validate_patches
 	status "Building original kernel"
 	clean_kernel
-	build_kernel
+	build_kernel "Original"
 	status "Copying original object files"
 	copy_orig_objects
 fi
@@ -923,7 +924,7 @@ if (( SHORT_CIRCUIT <= 2 )); then
 	fix_patches
 	apply_patches
 	status "Building patched kernel"
-	build_kernel
+	build_kernel "Patched"
 	revert_patches
 	status "Copying patched object files"
 	copy_patched_objects
-- 
2.52.0


