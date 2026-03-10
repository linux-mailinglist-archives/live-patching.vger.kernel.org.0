Return-Path: <live-patching+bounces-2174-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YM7HLDeBsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2174-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1A3257F10
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 04D9B300AC8C
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD1C3CC9E6;
	Tue, 10 Mar 2026 20:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QU05itr0"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D63CA487
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175092; cv=none; b=i/MwjKOA8sdm0FnNA9N48wPFi0hXxi4TNOA9Ei6jMejXaGzrYe6Xnf9ucMd04PrmUAvGlPG3QDS4WyrK2uEJglX2H7ytq4w/sS5vm+/uFQJRgcUiSitT2how4iYz2/rYUg+Mtm1yBbeyKytdC6aEQww2asUQTaLNh3PdgBFi6Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175092; c=relaxed/simple;
	bh=S+c4SoKezlKoZDhYMS4kVyinJEeQ9YGB67R7YpERPU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Rf7S0P4dY09xcvTQpFWAyPjWeuBxoEF2i9UFBMUBEFL6iaHIKnm4i6z9BzY2Y9cxL2vQ6RfZ+edDKnCdpPRjNz/VtewwvetpDB3jSAEN0/gSom3H10cSnIhDXRGI99DInQ/8w6kVL80Bql1zjzNqEdDv7X2mnTsUsKW2/sCuorM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QU05itr0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUqCp2CN1uJSshzUDfPGA0cVEB6mXS1prfC5ObPVNNM=;
	b=QU05itr0ABPvaJsTEDF9Y5cS0GX6hv5nssFXCO6aCmPE1YdGbnFFdax2NPmwKu1TpsmaTX
	SAe5BCPdtM1MBdGbuZgolQE7hojJ88WpLZDJGYsOIWBUxBSMlkwgAzyktjLHTQAoEC6L/U
	Djz+WILWGbtJ+ienoUDVvS/44AKqQqw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-ep9jftDwPM2uoLNUZ10rOw-1; Tue,
 10 Mar 2026 16:38:07 -0400
X-MC-Unique: ep9jftDwPM2uoLNUZ10rOw-1
X-Mimecast-MFC-AGG-ID: ep9jftDwPM2uoLNUZ10rOw_1773175086
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D77E1195608D;
	Tue, 10 Mar 2026 20:38:05 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6600319560A6;
	Tue, 10 Mar 2026 20:38:04 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 06/12] livepatch/klp-build: add Makefile with check target
Date: Tue, 10 Mar 2026 16:37:45 -0400
Message-ID: <20260310203751.1479229-7-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: 8D1A3257F10
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
	TAGGED_FROM(0.00)[bounces-2174-lists,live-patching=lfdr.de];
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

Add a standalone Makefile with a 'check' target that runs static code
analysis (shellcheck) on the klp-build script(s).  This is intended
strictly as a development aid.

Acked-by: Song Liu <song@kernel.org>
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


