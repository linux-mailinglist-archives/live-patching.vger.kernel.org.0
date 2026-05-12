Return-Path: <live-patching+bounces-2748-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHOSGJalA2qP8gEAu9opvQ
	(envelope-from <live-patching+bounces-2748-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4E052ABAC
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2DBBB302A1A5
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 22:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B64399351;
	Tue, 12 May 2026 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DO13w20q"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6339B964
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 22:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623878; cv=none; b=YXYnI5Pg/cl4uF/GucPExuaXFxALDvAp/5IjKN0CkgfQGqYuQ9hROm/KxW+tA+qR2BuAqYRrAgJQP/9P1118w3GaTM9/8+/sGMHkHS+INNzBzO9SHGsPtPD5vbhJT/hAWnE+knNvgnLWf2vZgBorhOmAXD01LwQUaiNYR1ajiMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623878; c=relaxed/simple;
	bh=36Tw+gz85KTY3fBDCPnS7KKF24RCjtB1UcjdLUyYiPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=LMOArPJROdls/igm16RDi+oZMGi0YRhAJK6HEHvfaellFfpaHPwljnbGTNwgKQjWZSywC8Zp2dec2SND3I4767KbCcTSEuKSIHfeNuG/TZ8auKXu66MuQnGjPmF82snneeb51aqZHOu9eH+aaoLex3L8rzzeOPzFNTzGp1GI3XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DO13w20q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778623876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jl30t3jXKDaBR32ke15XxtGmE5d14QvFnALDQQLw2mE=;
	b=DO13w20qSc1L1Ri4a9ES0qhsihqnKOov5j9I44HXxGPUPBbfO5ITLjOvSoMVJeUXAssBtm
	U361q+RplbB2QOeeCs+fw0Nh4GfXqrcZ7lUmoEEwve75r2JATtuzjUAanucKSCfKKJcG+t
	gLC++ASV3rhZEeg+huXNVOqdl6KSJ3M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-MPHo4m1ZNQ6ugcJ4F_Cm0w-1; Tue,
 12 May 2026 18:11:12 -0400
X-MC-Unique: MPHo4m1ZNQ6ugcJ4F_Cm0w-1
X-Mimecast-MFC-AGG-ID: MPHo4m1ZNQ6ugcJ4F_Cm0w_1778623871
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E19C61955F01;
	Tue, 12 May 2026 22:11:10 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.89.145])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D67941800347;
	Tue, 12 May 2026 22:11:09 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [RFC 2/4] objtool/klp: allow special section entry size overrides
Date: Tue, 12 May 2026 18:11:00 -0400
Message-ID: <20260512221102.2720763-3-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: 7B4E052ABAC
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
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2748-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Special section entry sizes (ALT_ENTRY_SIZE, JUMP_ENTRY_SIZE,
EX_ENTRY_SIZE) are built into objtool from arch-specific headers.
When processing cached unit test objects that were built from a
different kernel version, these compiled-in sizes may not match the
objects' actual entry sizes, causing create_fake_symbols() to
incorrectly parse special sections.

Allow the user to override the compiled-in defaults via environment
variables of the same name.  When unset, behavior is unchanged.  This
will enable a klp-diff unit test runner to pass the correct entry sizes
from test metadata.

Assisted-by: Cursor:claude-4.6-opus
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/klp-diff.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index bd8d64f2f3f6..ebe4a2a087ca 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1749,6 +1749,22 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 
 }
 
+static unsigned int entry_size_from_env(const char *name, unsigned int def)
+{
+	const char *str = getenv(name);
+	char *end;
+	unsigned long val;
+
+	if (!str)
+		return def;
+
+	val = strtoul(str, &end, 10);
+	if (*end || !val)
+		return def;
+
+	return val;
+}
+
 static int create_fake_symbol(struct elf *elf, struct section *sec,
 			      unsigned long offset, size_t size)
 {
@@ -1871,6 +1887,21 @@ static int create_fake_symbols(struct elf *elf)
 		}
 
 		entry_size = sec->sh.sh_entsize;
+
+		/*
+		 * Some special sections have multiple relocs per entry,
+		 * so the reloc-based heuristic below doesn't work.  Use
+		 * the arch-defined entry sizes for known special sections.
+		 */
+		if (!entry_size) {
+			if (!strcmp(sec->name, ".altinstructions"))
+				entry_size = entry_size_from_env("ALT_ENTRY_SIZE", ALT_ENTRY_SIZE);
+			else if (!strcmp(sec->name, "__jump_table"))
+				entry_size = entry_size_from_env("JUMP_ENTRY_SIZE", JUMP_ENTRY_SIZE);
+			else if (!strcmp(sec->name, "__ex_table"))
+				entry_size = entry_size_from_env("EX_ENTRY_SIZE", EX_ENTRY_SIZE);
+		}
+
 		if (!entry_size) {
 			entry_size = arch_reloc_size(sec->rsec->relocs);
 			if (sec_size(sec) != entry_size * sec_num_entries(sec->rsec)) {
-- 
2.53.0


