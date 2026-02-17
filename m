Return-Path: <live-patching+bounces-2016-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BAJBCiSlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2016-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 308D714DDE7
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CB9183004CAC
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92623612C5;
	Tue, 17 Feb 2026 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTuPOCxb"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A07718C2C
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344418; cv=none; b=MqZLYGIS7gdzDQQu/MQXTnBtJRxbrt6LBx+2aNR6vG9rzmkHkMuEPP/Xi6+jG+zgKbZYaDIPnCIy/wkUmkgIMxUtn+JhFKtuFbWlUrr+03q5mx6KxwQd87tv2PRyOXko4eDjdnBxQqyAj+d5uOw7Egl3059EUrmCDXKjm5XfimY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344418; c=relaxed/simple;
	bh=EY9o6lt0iQXT4hgHhec26ZL8UVMU7K4YFDigNn8rqT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=OmlgBq+0D2xa2SrOIIOLqa1/fCcLhzCuRQeFi5AzmffFCpRPq/1AB/pU3vCrGFbiQNSxQG5U1UeMjC9qlQYLjwoPYu02rVBFoIwDpgtxo+eK+mt9GOP/jiNzKMnComUbpJc1tJIB0ovEycB0jHhP3m+EaK4UNc5C7C5/yfwdriY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTuPOCxb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZtO+45SDEP7KkTMtHOgSGlgpMWfIXd6huECcOuOlFw=;
	b=OTuPOCxbTKkq+b4VffSXN8oNeOsLewnd79RuqpqTv5ksOHKBeoOBlwyWpiM0D8B763dS0a
	A9xFHJiQLhFwiJDXHdxyZTl1iNZ2of2YF/Q7/Jf98vk3CecDGHUeBwzMszkXZAtzHuogTL
	hTLs0A9HZ10Fj7TFd8rflM+em9yW9B4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-43YzZT1YOcGvg87PEyGAJg-1; Tue,
 17 Feb 2026 11:06:54 -0500
X-MC-Unique: 43YzZT1YOcGvg87PEyGAJg-1
X-Mimecast-MFC-AGG-ID: 43YzZT1YOcGvg87PEyGAJg_1771344413
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3333D1800367;
	Tue, 17 Feb 2026 16:06:53 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CCE530001A5;
	Tue, 17 Feb 2026 16:06:51 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 02/13] objtool/klp: fix mkstemp() failure with long paths
Date: Tue, 17 Feb 2026 11:06:33 -0500
Message-ID: <20260217160645.3434685-3-joe.lawrence@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2016-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 308D714DDE7
X-Rspamd-Action: no action

The elf_create_file() function fails with EINVAL when the build directory
path is long enough to truncate the "XXXXXX" suffix in the 256-byte
tmp_name buffer.

Simplify the code to remove the unnecessary dirname()/basename() split
and concatenation.  Instead, allocate the exact number of bytes needed for
the path.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/elf.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index bd6502e7bdc0..6f6d1c4cb6af 100644
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


