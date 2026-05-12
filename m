Return-Path: <live-patching+bounces-2746-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BuRCpClA2qP8gEAu9opvQ
	(envelope-from <live-patching+bounces-2746-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C412952AB9D
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7337B304E9F8
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 22:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECEC39B942;
	Tue, 12 May 2026 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="erDTa7j5"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D08D39A04B
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 22:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623876; cv=none; b=O6qhdxVvD+KhpxHucRrv7BlbarTlo2i2eyavybr+842WboybbLuFectsm8DoovDPf4lrmS+++N0/edHgm59F6k3CxmNVLT0aTOIMCNYCXki0uXDadBCxUIXCLiVTRfk6GUaE1jKmYiKqgyNTAId13YbaTznodkGNhwihHz2Ks5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623876; c=relaxed/simple;
	bh=gECdz6zcWZXHiX7/8w4kq3L75tckDtrUFc0FOY0Ex8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=mEsQ7E2K4Nz4CnAZxpVmkhUr3vhLSyPIFQwDS6/n4JuEJ2EkGoMstCNnBcNCcvfFmYe2S4Kqs+v1f65R2qLaiINohDsXfKrh3nx+VPvUHj9//wA7sokxHWFKoUgvix0psJwszhLFmqAqSpZ6ubx3DdFg2qSvfNQpNe/omA72nqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=erDTa7j5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778623874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oDpL3nXOLEaRoHDYwhPLUSNJyZ2U9nKp5cmtYyZyePU=;
	b=erDTa7j5gBs+dPOlZHpAfsFxHp4B5xnIpIGEnsj766wJrJQafpDiqt6/VLDXPd5FVTXB7j
	4kwI0xFr2WzGEzMZLWiMyeDeLzZfekCixDrlI6lggMEZyM5526Y/rmoOSaHdEyuLNNfRVT
	78tTuD8BWJth2dUTvy2tG+0qgTUEPdY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-OnlDOUrWMhGI-ecb1-8hBA-1; Tue,
 12 May 2026 18:11:10 -0400
X-MC-Unique: OnlDOUrWMhGI-ecb1-8hBA-1
X-Mimecast-MFC-AGG-ID: OnlDOUrWMhGI-ecb1-8hBA_1778623869
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89E4A180060D;
	Tue, 12 May 2026 22:11:09 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.89.145])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 562B81800349;
	Tue, 12 May 2026 22:11:08 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [RFC 1/4] objtool/klp: add --symvers option to klp diff
Date: Tue, 12 May 2026 18:10:59 -0400
Message-ID: <20260512221102.2720763-2-joe.lawrence@redhat.com>
In-Reply-To: <20260512221102.2720763-1-joe.lawrence@redhat.com>
References: <20260512221102.2720763-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: C412952AB9D
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
	TAGGED_FROM(0.00)[bounces-2746-lists,live-patching=lfdr.de];
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
X-Rspamd-Action: no action

Add a --symvers (-s) option that accepts a path to Module.symvers.  When
provided, it replaces the default "Module.symvers" filename used by the
auto-detection logic.

This decoupling helps to enable scenarios like out-of-tree module
patching and unit testing of klp-diff, where object files /
Module.symvers live outside the kernel tree.

The existing auto-detection behavior (try cwd, then top_level_dir()
fallback) is preserved regardless of whether --symvers is specified.

Assisted-by: Cursor:claude-4.6-opus
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/klp-diff.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index b9624bd9439b..bd8d64f2f3f6 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -34,6 +34,7 @@ struct export {
 	char *mod, *sym;
 };
 
+static const char *symvers_path = "Module.symvers";
 bool debug, debug_correlate, debug_clone;
 int indent;
 
@@ -47,6 +48,7 @@ static const struct option klp_diff_options[] = {
 	OPT_BOOLEAN('d', "debug", &debug, "enable all debug output"),
 	OPT_BOOLEAN(0, "debug-correlate", &debug_correlate, "enable correlation debug output"),
 	OPT_BOOLEAN(0, "debug-clone", &debug_clone, "enable cloning debug output"),
+	OPT_STRING('s', "symvers", &symvers_path, "path", "path to Module.symvers (default: Module.symvers)"),
 	OPT_END(),
 };
 
@@ -86,16 +88,15 @@ static char *escape_str(const char *orig)
 
 static int read_exports(void)
 {
-	const char *symvers = "Module.symvers";
 	char line[1024], *path = NULL;
 	unsigned int line_num = 1;
 	FILE *file;
 
-	file = fopen(symvers, "r");
+	file = fopen(symvers_path, "r");
 	if (!file) {
-		path = top_level_dir(symvers);
+		path = top_level_dir(symvers_path);
 		if (!path) {
-			ERROR("can't open '%s', \"objtool diff\" should be run from the kernel tree", symvers);
+			ERROR("can't open '%s', \"objtool diff\" should be run from the kernel tree", symvers_path);
 			return -1;
 		}
 
-- 
2.53.0


