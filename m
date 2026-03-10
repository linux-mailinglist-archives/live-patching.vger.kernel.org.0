Return-Path: <live-patching+bounces-2177-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Ti3MBjyBsGlNkAIAu9opvQ
	(envelope-from <live-patching+bounces-2177-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:20 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82725257F20
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A4A330EE7B3
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5E33D092A;
	Tue, 10 Mar 2026 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hEF12eIe"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5573CA491
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175097; cv=none; b=NKHErGZSJyMeBYZwqJtH2u5QcUf2JgTt6YQBxw44r/aZ1Co6Xb+hsr8+mhhb5YL3LYm2xR5cn8Bn6rtiolL+ie1qfCLFFLfjnD3bhUhNNOwp8aa6kX4JLklXOfJO5hhVg/T4ZAf2aRRTFS0bfi8mUslMEHksy+sqNG7veV/6EWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175097; c=relaxed/simple;
	bh=flJPCvN1hLj/R5qaGWn+SyqhionmWqzlBsMee658j7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=h4T2C5V4aF+VKtNEUFpdeMjxU7Csh++3+h6GLfz/wHgLvipzBSy6nrE8Q2LucSvlatX81wjNiQ2sEIB/AlPwxGkQYO15JN7ThA9oytAEENLrm1BP/NLy581QMajOeVfA5MJStflFvdfu3rntG3gW+MffCEQmMHY/2srg5k4++Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hEF12eIe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fP2witCR/uO9oX6V/z1+MkU1OAds2owMEli1JKZTD8c=;
	b=hEF12eIeLncQGakKpQJeWcmbxotpm9EZU8hOfQ0zQ3VPqe7Yk18cH0WgDmYUv4GvWjsF+2
	0/xyjlGEklKrNUjjqEfp+8eTFNdjEzKqoj43wsBaYVbUD3SfSkRLKV1fzWKdiNceefX0EX
	1MBFsXJVnGpXvdCm5RZeu7i2QJH2YgA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-NcITvrj6PMq5-lDdV9wa7w-1; Tue,
 10 Mar 2026 16:38:11 -0400
X-MC-Unique: NcITvrj6PMq5-lDdV9wa7w-1
X-Mimecast-MFC-AGG-ID: NcITvrj6PMq5-lDdV9wa7w_1773175089
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F20218005B8;
	Tue, 10 Mar 2026 20:38:09 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0532319560A6;
	Tue, 10 Mar 2026 20:38:07 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 08/12] livepatch/klp-build: improve short-circuit validation
Date: Tue, 10 Mar 2026 16:37:47 -0400
Message-ID: <20260310203751.1479229-9-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: 82725257F20
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
	TAGGED_FROM(0.00)[bounces-2177-lists,live-patching=lfdr.de];
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

Update SHORT_CIRCUIT behavior to better handle patch validation and
argument processing in later klp-build steps.

Perform patch validation for both step 1 (building original kernel) and
step 2 (building patched kernel) to ensure patches are verified before
any compilation occurs.

Additionally, allow the user to omit input patches when skipping past
step 2.

Acked-by: Song Liu <song@kernel.org>
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


