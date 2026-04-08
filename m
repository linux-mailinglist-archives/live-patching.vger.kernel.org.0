Return-Path: <live-patching+bounces-2322-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNu9NUNr1mnlFAgAu9opvQ
	(envelope-from <live-patching+bounces-2322-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 16:50:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D623BDDDB
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 16:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5AF933074CF4
	for <lists+live-patching@lfdr.de>; Wed,  8 Apr 2026 14:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5D03B0ADF;
	Wed,  8 Apr 2026 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3/3Ze9c"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAD3AF65D
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775659775; cv=none; b=DWkONaKfjYzlJ6udgdY6XOFIoX7qMjc8LWoFoS2wLeLabJcOQZaSeYR7lrNIDzqXQoxhT8plRdPAK3NOu2foZrbJ5OfBsHrgGCGraYD33KyYxbxH3awfQRHAB2aM7GVr33oHks3esxXOr901gbrO1ET8o0oXpim5UAO6Y2RvCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775659775; c=relaxed/simple;
	bh=U1LOP63jkekhpoc16rbmwGtCFIDvLlhvIfRMz8hRj/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=hjCJIaq21a8//zbbC4jQZ42RzgYM7guWtAxfPf4ObXrXZTkpxuFKQvZ1Znqjqs+9rqtDSoLQiBZIHiyuBHYm3z9bx5/HMhK2HVoiZUCF6CeV5eXedFql00duPMi+JUcZwtgQfEjkhciB6RqXy3vFxhHB8gO8w/0AqxWgs2cOny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3/3Ze9c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775659773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4foOhAKp5NVEe2vHlfJAyYATQIEm+eyyUlt9Paw3fMk=;
	b=E3/3Ze9cKEm2o//Blxm2cNiO8my9tBeM6yBKiSP5ooIqm2F4O/M/J40laKDnSKYNqZG2/D
	gWMBo8ED61oPZuZuf0sxDH8Im2GhalISilvuWWQLhIGE2akumRrj7Ibblrd4PKzGFzpGYR
	gzPeovrU1cEykppRYNqHWftv23opIXg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-My_K9LyGOY-Ik7Mlxfiowg-1; Wed,
 08 Apr 2026 10:49:30 -0400
X-MC-Unique: My_K9LyGOY-Ik7Mlxfiowg-1
X-Mimecast-MFC-AGG-ID: My_K9LyGOY-Ik7Mlxfiowg_1775659768
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7802E18002D1;
	Wed,  8 Apr 2026 14:49:28 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.40])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44AE31800762;
	Wed,  8 Apr 2026 14:49:27 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 1/1] objtool/klp: Fix is_uncorrelated_static_local() for Clang naming
Date: Wed,  8 Apr 2026 10:49:19 -0400
Message-ID: <20260408144919.3825518-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2322-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 50D623BDDDB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

For naming function-local static locals, GCC uses "<var>.<id>":
  e.g. __already_done.15

while Clang uses "<func>.<var>" with optional ".<id>"
  e.g. create_worker.__already_done.111

The existing is_uncorrelated_static_local() check only matches the GCC
convention where the variable name is a prefix.  Handle both cases by
checking for a prefix match (GCC) and by checking after the first dot
separator (Clang).

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/klp-diff.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 85281b3b021f..382ca1d8d391 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -241,16 +241,17 @@ static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
 static bool is_uncorrelated_static_local(struct symbol *sym)
 {
 	static const char * const vars[] = {
-		"__already_done.",
-		"__func__.",
-		"__key.",
-		"__warned.",
-		"_entry.",
-		"_entry_ptr.",
-		"_rs.",
-		"descriptor.",
-		"CSWTCH.",
+		"__already_done",
+		"__func__",
+		"__key",
+		"__warned",
+		"_entry",
+		"_entry_ptr",
+		"_rs",
+		"descriptor",
+		"CSWTCH",
 	};
+	const char *dot;
 
 	if (!is_object_sym(sym) || !is_local_sym(sym))
 		return false;
@@ -258,8 +259,18 @@ static bool is_uncorrelated_static_local(struct symbol *sym)
 	if (!strcmp(sym->sec->name, ".data.once"))
 		return true;
 
+	dot = strchr(sym->name, '.');
 	for (int i = 0; i < ARRAY_SIZE(vars); i++) {
-		if (strstarts(sym->name, vars[i]))
+		size_t len = strlen(vars[i]);
+
+		/* GCC: "<var>.<id>" e.g. "__already_done.15" */
+		if (strstarts(sym->name, vars[i]) &&
+		    (sym->name[len] == '.' || sym->name[len] == '\0'))
+			return true;
+
+		/* Clang: "<func>.<var>[.<id>]" e.g. "create_worker.__already_done.111" */
+		if (dot && strstarts(dot + 1, vars[i]) &&
+		    (dot[1 + len] == '.' || dot[1 + len] == '\0'))
 			return true;
 	}
 
-- 
2.53.0


