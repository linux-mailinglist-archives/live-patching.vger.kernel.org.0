Return-Path: <live-patching+bounces-2021-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHLJNzCSlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2021-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F3714DE0A
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B1AC0300692D
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C7736D4FA;
	Tue, 17 Feb 2026 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZhxupgRD"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857C21D88AC
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344428; cv=none; b=G2QIGN4tu2ia1iCT0VwdVUNHO+FRUNZO9kFrdI0EDnmgmJJBJ/aoobDGnMK3nXkCM3YLdIg/qRHHFrlwmHDud50DIUClABathiP2qo+lup2FzBiWMQlppJ0gfI/yb1HykULNgZEs7JJaMvGHJrq6r3BGDPSazZy81blfoAjGYtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344428; c=relaxed/simple;
	bh=DR6hZTj1z8Cijtc6zPrzDvyQZn4uj8Vh5RhA+oJr4kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=X3oTL1jhWCdhg19YD28zFYPiQ+5OF/YIQ2bVNzPnOxKKTXiaEFBk1brXR9662rFsDe6/hBH5aw3FniSFKkxD2VxY5yxaJQ5uDI7Mzgtn83mLwvJ4cNOgte+avXnH0IY43wMi7G+QLk5pCcVIFHodQg5bFSHMsu87YQOrkJeQhSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZhxupgRD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iTMo5GwRKDXuVqQvEWMue4QwzIgxKzH8LT8cqH7myio=;
	b=ZhxupgRDjMmbQcDLboky8+HYzCCJ0YXut8SCyxcYmC6+M9VvaxmtbCurDlKya6Eeyt7wKM
	U+YDpgF2wKIT1I1KOtsKPStPE4bfYsqjuUWCBtBPVFLfsxPgUKAlOuL9Z9pFTGHsAP198d
	wEyKUoY2m0g7NirSSVcjVWC76LernlU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-N9e67vi2PqCTi_rewbrqnw-1; Tue,
 17 Feb 2026 11:07:01 -0500
X-MC-Unique: N9e67vi2PqCTi_rewbrqnw-1
X-Mimecast-MFC-AGG-ID: N9e67vi2PqCTi_rewbrqnw_1771344419
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1C4D18001E1;
	Tue, 17 Feb 2026 16:06:59 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.197])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F2B530001A5;
	Tue, 17 Feb 2026 16:06:58 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 06/13] livepatch/klp-build: add Makefile with check target
Date: Tue, 17 Feb 2026 11:06:37 -0500
Message-ID: <20260217160645.3434685-7-joe.lawrence@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-2021-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 45F3714DE0A
X-Rspamd-Action: no action

Add a standalone Makefile with a 'check' target that runs static code
analysis (shellcheck) on the klp-build script(s).  This is intended
strictly as a development aid.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/Makefile | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 scripts/livepatch/Makefile

diff --git a/scripts/livepatch/Makefile b/scripts/livepatch/Makefile
new file mode 100644
index 000000000000..17b590213740
--- /dev/null
+++ b/scripts/livepatch/Makefile
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0
+# Standalone Makefile for developer tooling (not part of kbuild).
+
+SHELLCHECK := $(shell which shellcheck 2> /dev/null)
+
+SRCS := \
+  klp-build
+
+.DEFAULT_GOAL := help
+.PHONY: help
+help:
+	@echo "  check      - Run shellcheck on $(SRCS)"
+	@echo "  help       - Show this help message"
+
+.PHONY: check
+check:
+ifndef SHELLCHECK
+	$(error shellcheck is not installed. Please install it to run checks)
+endif
+	@$(SHELLCHECK) $(SHELLCHECK_OPTIONS) $(SRCS)
-- 
2.53.0


