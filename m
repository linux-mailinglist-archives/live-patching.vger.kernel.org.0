Return-Path: <live-patching+bounces-1981-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNQQBWu0gmnwYgMAu9opvQ
	(envelope-from <live-patching+bounces-1981-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:52:27 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66650E1025
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 933B430BE12B
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF512DB79D;
	Wed,  4 Feb 2026 02:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FnQPvCm+"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CCD2C3255
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 02:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173519; cv=none; b=CBwMX9LB5tUedMFuP/VsYwisYylJWVTYDR04fW3A97/wgqT/KN/yTDxJiVgvqOVHzl5Mngfllj/lKAKrnd2XX269ZdxCiMIzIAapkcSp0kJZsIHGOQqWdD3MDMm8L5ScXHWa81m+FEsTxpzdb6iKAzLSxv4kyBOSyOKnlNtvqNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173519; c=relaxed/simple;
	bh=chuUpiIUZL0OQPxt2u4ASn5XpwYVr7ujBzmhfaEkmRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=qJ5Q8KKUrlRNv1sb+y2qDCvgZpW1V//P63ay/j2YQbCntdBprJEuxvs65DIoPZFOz5798p2UqUuj1zQACyTYBwbCh+NFdBb1j6wPQeJyfaZPbliYOL1BFzk9fUkSV2U0TbVuxJfCDwlI9Q2L2hKOa+nhKWv8vp3kGd6C3YeX6CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FnQPvCm+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770173517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6BzFJLKikJYR1g9xE0dpppI3Jqad/lKUQDq+4gse7k=;
	b=FnQPvCm+Rl8qei7knPaFPQemxeDmCZe++l27yipJG1zI9KwwDutLGsHtlg0WtKSZW/oI+d
	DVPoW8OOpB57o8Zm99mp/vSc06jX5y4EcPWGp7kLS5pi8VIom7xVObG1h6RAnoEU2q4xAb
	miC/whp2SeojgaKOQ4IcVhuZjP6k6qM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-k5iG6doiNeCbmeWJFwg01Q-1; Tue,
 03 Feb 2026 21:51:53 -0500
X-MC-Unique: k5iG6doiNeCbmeWJFwg01Q-1
X-Mimecast-MFC-AGG-ID: k5iG6doiNeCbmeWJFwg01Q_1770173512
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8719319560A7;
	Wed,  4 Feb 2026 02:51:52 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A995180094B;
	Wed,  4 Feb 2026 02:51:50 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 4/5] livepatch/klp-build: minor short-circuiting tweaks
Date: Tue,  3 Feb 2026 21:51:39 -0500
Message-ID: <20260204025140.2023382-5-joe.lawrence@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1981-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 66650E1025
X-Rspamd-Action: no action

Update SHORT_CIRCUIT behavior to better handle patch validation and
argument processing in later klp-build steps.

Perform patch validation for both step 1 (building original kernel)
and step 2 (building patched kernel) to ensure patches are verified
before any compilation occurs.

Additionally, allow the user to omit input patches when skipping past
step 2, while noting that any specified patches will be ignored in that
case if they were provided.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index ee43a9caa107..df3a0fa031a6 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -214,12 +214,18 @@ process_args() {
 	done
 
 	if [[ $# -eq 0 ]]; then
-		usage
-		exit 1
+		if (( SHORT_CIRCUIT <= 2 )); then
+			usage
+			exit 1
+		fi
+	else
+		if (( SHORT_CIRCUIT >= 3 )); then
+			status "note: patch arguments ignored at step $SHORT_CIRCUIT"
+		fi
 	fi
+	PATCHES=("$@")
 
 	KEEP_TMP="$keep_tmp"
-	PATCHES=("$@")
 }
 
 # temporarily disable xtrace for especially verbose code
@@ -801,9 +807,12 @@ build_patch_module() {
 process_args "$@"
 do_init
 
-if (( SHORT_CIRCUIT <= 1 )); then
+if (( SHORT_CIRCUIT <= 2 )); then
 	status "Validating patch(es)"
 	validate_patches
+fi
+
+if (( SHORT_CIRCUIT <= 1 )); then
 	status "Building original kernel"
 	clean_kernel
 	build_kernel
-- 
2.52.0


