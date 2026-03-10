Return-Path: <live-patching+bounces-2179-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCVuBz+BsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2179-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:23 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B6EF7257F3B
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1657930F0E5C
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881B53D16F8;
	Tue, 10 Mar 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QuXLTXvD"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280E3CA491
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175099; cv=none; b=mFFvUfDhVfg8mZOGfgkiIPN6udzg0HeRkTQeJPYqGVhZ/bsF3hYmuZ9MBWmHl7fAThOilraJkAEiZM2HW+O0cFoT0SM0cG5P/WnZjZD4D3vR6tFNQG5HdfB4HW2n6WMcIksb+WDt1O/Ji+tWQQgz/x8hUbHeASvnX/ofXlSdR6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175099; c=relaxed/simple;
	bh=grn83Wm3SHf/29FkmK6mZWTVFRSlS+5onsDXkxaBGcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=K3RnI2Joy1aQfclyy+2099llUFCAxiCd2dgh+8jHuwjPNTzVk1XOieQLfi0wE2mVbQso0xM/aOrbxSJGIhx3t9CmZIq5jPp4hUxBEc4phanlbVz1ofZOfiqtG3T48PV2AJDoN4HGO8FqRboW67rtyiNNlNVpaB1loJydxh8R6WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QuXLTXvD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=isF7FvosYyyJzMmwxoXV6nuWtVDPGpgXwlitpONxKHg=;
	b=QuXLTXvDpRYZcWGsS1E8tyrrzbHlmMPC2MifPAAqXh8q7PtmiY6Jh59nfMaL5dNn4iu9Ar
	2+fd9OJ1hmus8JdXsjCx9f46+RO+qkfop19kyLstTVJSEQy9Gud/qXy/OISgeudRpJLZTo
	oQGv9MDS4zYYra8UKajmDTwOYzhRwwM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-ib0U8J4vNISFPe302iHHSQ-1; Tue,
 10 Mar 2026 16:38:14 -0400
X-MC-Unique: ib0U8J4vNISFPe302iHHSQ-1
X-Mimecast-MFC-AGG-ID: ib0U8J4vNISFPe302iHHSQ_1773175092
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3AF219560B7;
	Tue, 10 Mar 2026 20:38:12 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8EE7B19560B7;
	Tue, 10 Mar 2026 20:38:11 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 10/12] livepatch/klp-build: provide friendlier error messages
Date: Tue, 10 Mar 2026 16:37:49 -0400
Message-ID: <20260310203751.1479229-11-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: B6EF7257F3B
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
	TAGGED_FROM(0.00)[bounces-2179-lists,live-patching=lfdr.de];
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

Provide more context for common klp-build failure modes.  Clarify which
user-provided patch is unsupported or failed to apply, and explicitly
identify which kernel build (original or patched) failed.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 7f4041a0eefb..cf36555330b3 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -341,7 +341,7 @@ check_unsupported_patches() {
 		for file in "${files[@]}"; do
 			case "$file" in
 				lib/*|*.S)
-					die "unsupported patch to $file"
+					die "${patch}: unsupported patch to $file"
 					;;
 			esac
 		done
@@ -486,6 +486,7 @@ clean_kernel() {
 }
 
 build_kernel() {
+	local build="$1"
 	local log="$TMP_DIR/build.log"
 	local objtool_args=()
 	local cmd=()
@@ -523,7 +524,7 @@ build_kernel() {
 		"${cmd[@]}"							\
 			1> >(tee -a "$log")					\
 			2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2)
-	)
+	) || die "$build kernel build failed"
 }
 
 find_objects() {
@@ -798,7 +799,7 @@ fi
 if (( SHORT_CIRCUIT <= 1 )); then
 	status "Building original kernel"
 	clean_kernel
-	build_kernel
+	build_kernel "original"
 	status "Copying original object files"
 	copy_orig_objects
 fi
@@ -808,7 +809,7 @@ if (( SHORT_CIRCUIT <= 2 )); then
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


