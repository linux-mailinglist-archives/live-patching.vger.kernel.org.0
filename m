Return-Path: <live-patching+bounces-2026-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kEroIzmSlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2026-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:21 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D7B14DE27
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2FC083004C95
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA5E36D4FF;
	Tue, 17 Feb 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aGZRYI/W"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653636D4EB
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344436; cv=none; b=llZ7QVtQcFwvwcflPF75V7wRAEF3nRBRzQqfhO/s1bUjoIcc4PxAtiEnI7OpcVRLjaHlwS5cZW3SrBAA0WILtqAMf5Kk0jIdf3DlLqsl94P8k11yVBLhx0YAMMXgKGR7507mtBApblnFYDjiSWoWZGByLAWFtz/dynkLRy3y9kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344436; c=relaxed/simple;
	bh=+965LPkOSmeWQ4rkItjA5vdg2PL/BASEZ537w6WFZy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=gtUXeOyUDa/MfiP7V7yaf6YHzW/olv3V8hettJENxc9CzRh+dUAC55C6d3CSOuLsZKOh1WG64ZpbWK/h5KX7wceQeQJtgxsOMqpRTqYInALWYVsSzXtnlH4rOt9D9e2bZ8qhnKQDquWwyX21iaARazZJI7AKP2o/1uLTx7kIqEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aGZRYI/W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZtaTWCef1n4DUcgsSV0b0KDBZX+YioJ8uzaC1gqWE8=;
	b=aGZRYI/W6ZgX94I2HlCcdEeRmjJckwy3jHkFzXc8mXLg6hHX3qF8ZpBU2vsZgak6NkJkim
	JiChnE4vowqETXQzV+LWe2bB4LXUgOlsGBaQzvzu4eTo4WS3eYIpnUyuMX74IPFFfoM+OZ
	5Wdmb6dfu3HUnhEvpgF9fLoiKYh1LNo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-ZHWbcqZPM1m1Ci5rHYtqIA-1; Tue,
 17 Feb 2026 11:07:07 -0500
X-MC-Unique: ZHWbcqZPM1m1Ci5rHYtqIA-1
X-Mimecast-MFC-AGG-ID: ZHWbcqZPM1m1Ci5rHYtqIA_1771344426
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA38618005B0;
	Tue, 17 Feb 2026 16:07:05 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F1C630001A5;
	Tue, 17 Feb 2026 16:07:04 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 10/13] livepatch/klp-build: provide friendlier error messages
Date: Tue, 17 Feb 2026 11:06:41 -0500
Message-ID: <20260217160645.3434685-11-joe.lawrence@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2026-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B7D7B14DE27
X-Rspamd-Action: no action

Provide more context for common klp-build failure modes.  Clarify which
user-provided patch is unsupported or failed to apply, and explicitly
identify which kernel build (original or patched) failed.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 6d3adadfc394..80703ec4d775 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -351,7 +351,7 @@ check_unsupported_patches() {
 		for file in "${files[@]}"; do
 			case "$file" in
 				lib/*|*.S)
-					die "unsupported patch to $file"
+					die "$patch unsupported patch to $file"
 					;;
 			esac
 		done
@@ -496,6 +496,7 @@ clean_kernel() {
 }
 
 build_kernel() {
+	local build="$1"
 	local log="$TMP_DIR/build.log"
 	local objtool_args=()
 	local cmd=()
@@ -533,7 +534,7 @@ build_kernel() {
 		"${cmd[@]}"							\
 			1> >(tee -a "$log")					\
 			2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2)
-	)
+	) || die "$build kernel build failed"
 }
 
 find_objects() {
@@ -808,7 +809,7 @@ fi
 if (( SHORT_CIRCUIT <= 1 )); then
 	status "Building original kernel"
 	clean_kernel
-	build_kernel
+	build_kernel "original"
 	status "Copying original object files"
 	copy_orig_objects
 fi
@@ -818,7 +819,7 @@ if (( SHORT_CIRCUIT <= 2 )); then
 	fix_patches
 	apply_patches
 	status "Building patched kernel"
-	build_kernel
+	build_kernel "patched"
 	revert_patches
 	status "Copying patched object files"
 	copy_patched_objects
-- 
2.53.0


