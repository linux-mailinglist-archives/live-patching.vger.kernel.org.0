Return-Path: <live-patching+bounces-2175-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCDcMjeBsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2175-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BA369257F11
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2C284300B5A0
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86E33CA491;
	Tue, 10 Mar 2026 20:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UsZMD5IE"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A2A3CCA12
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175094; cv=none; b=gWQZcNb9aOsEIKyejevPWjaqCYJ8ZYfKiucjVru4uWjFYoBs0KdKepekDCMvhMLKSM+lWvuZhbpN5UoeybSf1X/iJRWkJ3R31cpL/nyAWVEXJaF6rjNqkYoia3YhdTfQr8qt6s63Z6AVtt8GXeJ0i0b23CXJGRLkSqh/7f9CZOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175094; c=relaxed/simple;
	bh=MZsmWdlK/5MgYqT+USsjDLelgKzqIz0EO9GY+Lsaxbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=iJKepoeP3B+kjXSw7ts33VGjDO3dAoABoJbpV1JEHzs0nXdSRGuljBBgGRfaj76Uyg5usYpkqvrPixqdr5+Fg0R9THFK1tlZ+w9Ov85WVaBjFzzSk+uFwlSs5n6zQJ31RxipOXwDHOiaN3cTcJQHvkL59qBgqFpB4C3IfaEZPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UsZMD5IE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CRws0KCqthDr3irGgVEJbOfF7R3slpN6eQz6JIikJxE=;
	b=UsZMD5IEhHN6tlCZ1gQVduSOAg6Ja789fRn8WkyfY+9iCikk/LMLJqvNgQufad5FG8f1gz
	iX/2gDF5BTh1VFx9wsCzp+CVuW7D+uCvEuBBT4Pcn88GPLT7XTQqERi4qMDQ1hzYI3bMJs
	SgvknOFdFxnfhioU5EJnktcHKI4A2hg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-QMGRSCLEPCaGABf_Tsl8yA-1; Tue,
 10 Mar 2026 16:38:09 -0400
X-MC-Unique: QMGRSCLEPCaGABf_Tsl8yA-1
X-Mimecast-MFC-AGG-ID: QMGRSCLEPCaGABf_Tsl8yA_1773175087
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF0AB1956089;
	Tue, 10 Mar 2026 20:38:07 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 299D019560A6;
	Tue, 10 Mar 2026 20:38:06 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 07/12] livepatch/klp-build: fix shellcheck complaints
Date: Tue, 10 Mar 2026 16:37:46 -0400
Message-ID: <20260310203751.1479229-8-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: BA369257F11
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
	TAGGED_FROM(0.00)[bounces-2175-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Fix or suppress the following shellcheck warnings:

  In klp-build line 57:
  	command grep "$@" || true
                               ^--^ SC2317 (info): Command appears to be unreachable. Check usage (or ignore if invoked indirectly).

Fix the following warning:

  In klp-build line 565:
  		local file_dir="$(dirname "$file")"
                        ^------^ SC2034 (warning): file_dir appears unused. Verify use (or export if used externally).

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index cf6c2bf694aa..374e1261fd7a 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -53,6 +53,7 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
 KLP_DIFF_LOG="$DIFF_DIR/diff.log"
 
 grep0() {
+	# shellcheck disable=SC2317
 	command grep "$@" || true
 }
 
@@ -550,7 +551,6 @@ copy_orig_objects() {
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
 		local file="$OBJ/$rel_file"
-		local file_dir="$(dirname "$file")"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local orig_dir="$(dirname "$orig_file")"
 
-- 
2.53.0


