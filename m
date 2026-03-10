Return-Path: <live-patching+bounces-2180-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAmsHkGBsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2180-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:25 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF45257F44
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D232330DACD1
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151C93CC9FE;
	Tue, 10 Mar 2026 20:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEb1poMS"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3053CA487
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175103; cv=none; b=Ht2tNNypsW+BWrgbwCbDURDzWw6auDUUmEdu10yAyiHFTI5Fut/pw9o/OskKlNFMbyibSQbBvcEq1OBIrEjA0Fhk1gbSKZK2Aw5WxZnVuRaDlN8vxVmf1V+U18rKsNHbrDBJJuezo89nITpUsPcJyZCSQU0xcc0I6rtKcJRM5yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175103; c=relaxed/simple;
	bh=lAJRbLy42DK/abaecbyrierUXJ12kAYkE5nGh6xNFXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=P+fMPYB0k34u0iNYmjVPU8k07A9Rk1BTEjE7qst9nEv3igRbhzoHfPFkwGOPe1kqKHLSus01qHSLNP1j5pRUbjmCoSVuas4IJobi26tCqvhUtaCDR38KwRQvfqaxjdw5vtftozvvtl+3cCZ6UGDn5gGfm5M8pZd3Yb6sKjKykuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEb1poMS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXBq0n3V5b0v7xUwnsFDKR8B5jsaEhnByBj6ZOSv5p4=;
	b=OEb1poMSNrb4iBhLkCbuuhc0YoAdqBWYm8ruqVS/I97ZLfxJL4qUYu+hzn5Xx22dQk/ByF
	UXkF1hsEK/7/Uu+rlEOUcQCcufnz/XwpqNBSsgUOhdGjsEWYpi9fuVRx8vW3peIpN25D4W
	WL+7RosLM5Dz1QOPcDbLHAeWN94lU7k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-aNFpVBFZO5uBlpb29IsjJA-1; Tue,
 10 Mar 2026 16:38:17 -0400
X-MC-Unique: aNFpVBFZO5uBlpb29IsjJA-1
X-Mimecast-MFC-AGG-ID: aNFpVBFZO5uBlpb29IsjJA_1773175096
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B237180044D;
	Tue, 10 Mar 2026 20:38:16 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A563619560A6;
	Tue, 10 Mar 2026 20:38:14 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 12/12] livepatch/klp-build: report patch validation fuzz
Date: Tue, 10 Mar 2026 16:37:51 -0400
Message-ID: <20260310203751.1479229-13-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: 1DF45257F44
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2180-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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

Capture the output of the patch command to detect when a patch applies
with fuzz or line offsets.

If such "fuzz" is detected during the validation phase, warn the user
and display the details.  This helps identify input patches that may
need refreshing against the target source tree.

Ensure that internal patch operations (such as those in refresh_patch or
during the final build phase) can still run quietly.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 325dc4601bba..0ad7e6631314 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -359,11 +359,24 @@ check_unsupported_patches() {
 
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
+		echo "$output" >&2
+		die "$patch did not apply"
+	elif [[ "$output" =~ $drift_regex ]]; then
+		echo "$output" >&2
+		warn "${patch} applied with fuzz"
+	fi
 
+	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 	APPLIED_PATCHES+=("$patch")
 }
 
@@ -382,10 +395,11 @@ revert_patch() {
 }
 
 apply_patches() {
+	local extra_args=("$@")
 	local patch
 
 	for patch in "${PATCHES[@]}"; do
-		apply_patch "$patch"
+		apply_patch "$patch" "${extra_args[@]}"
 	done
 }
 
@@ -443,7 +457,7 @@ refresh_patch() {
 	( cd "$SRC" && echo "${input_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
 
 	# Copy patched source files to 'b'
-	apply_patch "$patch"
+	apply_patch "$patch" "--silent"
 	( cd "$SRC" && echo "${output_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
 	revert_patch "$patch"
 
@@ -816,7 +830,7 @@ fi
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


