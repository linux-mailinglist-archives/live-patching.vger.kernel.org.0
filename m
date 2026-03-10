Return-Path: <live-patching+bounces-2170-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WAK/Di6BsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2170-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:06 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D78D0257EF4
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE3CC3011C58
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1729D3C870A;
	Tue, 10 Mar 2026 20:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AcRojysF"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEFA368953
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175084; cv=none; b=KsCcmfPp4uvPOBKtfkt8espQEoTsPH+IkoEdb6okpezIz4pw+tYXh5PCD5QqGo0Bbss6euXO5yhpZP3oAOO04TtQ/ZMtI3q3j2Ezi3kmKfKmbhyFLvfIKb7UTqhNsrmY4AxJ8v4ZymEymnFxbRfX2WmRdOuLqDTjIMHWWP42ZaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175084; c=relaxed/simple;
	bh=WfRcyC70XN+IWnYdQkRF5RNI8YaXJxUASER3JADfiVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Lf9qVnZAEDLjKipCduVw7XdZCsPGUww+y2/DEna/Fv4+ZqBZoSgs3bb+2n9yj1jBpuGMs/jKodcR/2ULtzDHoAuDnEdsLlA8MmtUKUNt1zQWmtdzSUtS+278FQL+mzeQG9764Oww4Wy+L7LLjvlLpelADPZamnFWx+mXlzEB+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AcRojysF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7B04edA1FUuzJP0cPtRNrHrsB+SjFVnhJurP0fQibo=;
	b=AcRojysFwdCZmlitIOmsDZOA/GQXQGaBYaq7b3DX4Zsp0UbgKq6nqMboescUOimD6WTKR6
	U4yqfnXcxpYurZCvWuVFuh6tqVmgFTJsYsEvUVvblCZnI2IXHxNvHcyUTa+BCsnVMUNkub
	xWGWcVRs3EahUTNZ0X26zbrWaXYzKAk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-_wxccCJ_Ow29JNh2n2Me6g-1; Tue,
 10 Mar 2026 16:38:00 -0400
X-MC-Unique: _wxccCJ_Ow29JNh2n2Me6g-1
X-Mimecast-MFC-AGG-ID: _wxccCJ_Ow29JNh2n2Me6g_1773175079
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33E22195609F;
	Tue, 10 Mar 2026 20:37:59 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 876E319560B7;
	Tue, 10 Mar 2026 20:37:57 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 02/12] objtool/klp: fix mkstemp() failure with long paths
Date: Tue, 10 Mar 2026 16:37:41 -0400
Message-ID: <20260310203751.1479229-3-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: D78D0257EF4
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2170-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

The elf_create_file() function fails with EINVAL when the build directory
path is long enough to truncate the "XXXXXX" suffix in the 256-byte
tmp_name buffer.

Simplify the code to remove the unnecessary dirname()/basename() split
and concatenation.  Instead, allocate the exact number of bytes needed for
the path.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/elf.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 3da90686350d..2ffe3ebfbe37 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -16,7 +16,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <errno.h>
-#include <libgen.h>
 #include <ctype.h>
 #include <linux/align.h>
 #include <linux/kernel.h>
@@ -1189,7 +1188,7 @@ struct elf *elf_open_read(const char *name, int flags)
 struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 {
 	struct section *null, *symtab, *strtab, *shstrtab;
-	char *dir, *base, *tmp_name;
+	char *tmp_name;
 	struct symbol *sym;
 	struct elf *elf;
 
@@ -1203,29 +1202,13 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 
 	INIT_LIST_HEAD(&elf->sections);
 
-	dir = strdup(name);
-	if (!dir) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
-	dir = dirname(dir);
-
-	base = strdup(name);
-	if (!base) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
-	base = basename(base);
-
-	tmp_name = malloc(256);
+	tmp_name = malloc(strlen(name) + 8);
 	if (!tmp_name) {
 		ERROR_GLIBC("malloc");
 		return NULL;
 	}
 
-	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
+	sprintf(tmp_name, "%s.XXXXXX", name);
 
 	elf->fd = mkstemp(tmp_name);
 	if (elf->fd == -1) {
-- 
2.53.0


