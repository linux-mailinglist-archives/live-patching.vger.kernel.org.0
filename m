Return-Path: <live-patching+bounces-2022-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFVbEDWSlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2022-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:17 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CE314DE18
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 549AA30131CF
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C2936D4FF;
	Tue, 17 Feb 2026 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mr41aZa/"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C751836C5B7
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344428; cv=none; b=clBpwMO8DiGLqwYei0+QMTyzHuKbFloEgNoayzbgwGFPhB64wtYqnFa2MyqIBj2GMZLVWwEjZ8SHQ0J/+O4k0JLHW1r3AYkBLXOPYJs9qkuQw1nrv6r0HrMMwiJXHGrMUTrwUf4Daryaurvcc18X6iaRSh3E8hnsVVmovRAXpdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344428; c=relaxed/simple;
	bh=YxSmhX5pf7dj5kn57zFZtpcUZhfiuA9k9tzWPnQKrIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Wzc06KPkWLJi9hokhlUuxCFOEEshHiAKpr4ZIZkSgd9zUifKLt0BOnjJSC5aJ+IyjH0QWZEfTV90EpVDxLtdlI+hgFdEqwiPc7drAqn4cS97ZCJZ7U9uyb2YmKEemrAm3UlqdLJOaRYaD/62RPmfWyqeO6YxMvQdjDsMELVgNC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mr41aZa/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LRcwl5Ikyb93htTbvcfbUVutghj4m9o21fInp8eZNbc=;
	b=Mr41aZa/K50HHDyYBa+ZkcXXdiqX3UHK5Fk4xDkgz46OmFYb3RbvppzO5YD5aaSN0hPsLp
	1sv2tGpWDfapgUPkSQHPLv10lcCD+MNqAUgRFS8Nyo3D1ENrzCU1e5kuQTe1t3uqg2qFwj
	tzi7T52gHfmX8bwPmxs12nIuRuC9khY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-vaJgkCLhOImpZtbqwN0zZA-1; Tue,
 17 Feb 2026 11:07:02 -0500
X-MC-Unique: vaJgkCLhOImpZtbqwN0zZA-1
X-Mimecast-MFC-AGG-ID: vaJgkCLhOImpZtbqwN0zZA_1771344421
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 531521800464;
	Tue, 17 Feb 2026 16:07:01 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 12AF830001B9;
	Tue, 17 Feb 2026 16:06:59 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 07/13] livepatch/klp-build: fix shellcheck complaints
Date: Tue, 17 Feb 2026 11:06:38 -0500
Message-ID: <20260217160645.3434685-8-joe.lawrence@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2022-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D7CE314DE18
X-Rspamd-Action: no action

Fix or suppress the following shellcheck warnings:

  In klp-build line 57:
  	command grep "$@" || true
                               ^--^ SC2317 (info): Command appears to be unreachable. Check usage (or ignore if invoked indirectly).

Fix the following warning:

  In klp-build line 565:
  		local file_dir="$(dirname "$file")"
                        ^------^ SC2034 (warning): file_dir appears unused. Verify use (or export if used externally).

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


