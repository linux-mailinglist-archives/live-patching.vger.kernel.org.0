Return-Path: <live-patching+bounces-2024-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oK7zHC+SlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2024-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5482414DDFC
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BA00F3006467
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6312436D4FD;
	Tue, 17 Feb 2026 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H5IMD24h"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F13536D4FC
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344430; cv=none; b=r/dMX3vlaCa5CJRo2WTxLcKBSpyG/kn6VqFZfUxvFO8AMwRWEKKySqYCoggxWB7kMK8wE5fexGCMUYze454VJhwFKkkPa3VHLw9wrdjzSK+LHlXvW5BTnX3BZuJwTwt6qNJSKsNxAJNBcEN4QASgI6b+vnjBKjarAwYg1bqDe4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344430; c=relaxed/simple;
	bh=8UpOVRcXWgB4kHV/URAuFf1nY+GvLUs8nBecp4oEPMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=cntHwS0d1cj3DK1atKSZ4c94rl+bIk/w7d8va50DVaBH2GfMMFQYUxapmUZZx/+jBMapCs2bLySWD8hYWbKWNCxqmdXtGQss4eJiFh2Z2m7ptgkrJS/a+vJ7D8+qVMhNMttzmGgAqB7yEwlXUKEvhuq6O+DmLvmwQvoI60HAwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H5IMD24h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsI4OyxHujD5gVAIutll5zRHFPP4Zu4VClUGKKzTt2o=;
	b=H5IMD24h9fzu4MR2UbPSbmC8M87kDph+NohGXd8J7F4UIJfL342fAEOf++X6rMGccvoJmk
	NzQkfl18vPctL3H+xs71T+FvIynFq3oYVMWvCD7jjy1tlCC8xtD+CwRA2d6zKk7j2qh8bW
	xxwCy9p8T807qWrF/NDFtvwJO2wA/GE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-UdSwOXfaMUG8b1Z5J7Akxw-1; Tue,
 17 Feb 2026 11:07:04 -0500
X-MC-Unique: UdSwOXfaMUG8b1Z5J7Akxw-1
X-Mimecast-MFC-AGG-ID: UdSwOXfaMUG8b1Z5J7Akxw_1771344423
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDB581933F86;
	Tue, 17 Feb 2026 16:07:02 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BEA330001A5;
	Tue, 17 Feb 2026 16:07:01 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 08/13] livepatch/klp-build: improve short-circuit validation
Date: Tue, 17 Feb 2026 11:06:39 -0500
Message-ID: <20260217160645.3434685-9-joe.lawrence@redhat.com>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2024-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 5482414DDFC
X-Rspamd-Action: no action

Update SHORT_CIRCUIT behavior to better handle patch validation and
argument processing in later klp-build steps.

Perform patch validation for both step 1 (building original kernel) and
step 2 (building patched kernel) to ensure patches are verified before
any compilation occurs.

Additionally, allow the user to omit input patches when skipping past
step 2.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 374e1261fd7a..60c7635e65c1 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -220,7 +220,7 @@ process_args() {
 		esac
 	done
 
-	if [[ $# -eq 0 ]]; then
+	if [[ $# -eq 0 ]] && (( SHORT_CIRCUIT <= 2 )); then
 		usage
 		exit 1
 	fi
@@ -791,9 +791,12 @@ build_patch_module() {
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
2.53.0


