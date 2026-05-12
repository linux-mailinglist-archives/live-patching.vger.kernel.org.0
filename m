Return-Path: <live-patching+bounces-2747-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECEvIpClA2qP8gEAu9opvQ
	(envelope-from <live-patching+bounces-2747-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4DB52AB9E
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A27C1304ED5B
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 22:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBEF39B96E;
	Tue, 12 May 2026 22:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8CtVhlv"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89C399354
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 22:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623877; cv=none; b=Agrs7U+AhyabzN1FowfNgrKnbLZp+hlzQOkYA8UQAX7WNee9YVZh9uezIF0BSHPcNe2SzA5hL3xbu1tKc82pXhKBRVUv9gLOm7MRnfWC8B5gKoosGXXFdAmYsL310UXIf1gGQStRVm8PcR9QUrNvV7duTibNzaIyVfEP2XQRieA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623877; c=relaxed/simple;
	bh=hT2Lb2gyz6qP9aZKuYbHMEiwNhVnCddtnbL7dOxSSZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=s4N93lmnK5fk4gVBkBc8NcU3WeugYVhmrIWdgkY64VIT2sdEhHwybX/MgPTfZYda3cxu5TuP3418YJUoOUhgpC7TsYKWPzFBpSFPXfZReAC4gaXli3opD+PUFIuyAbyvFxcn0eKkSPlOlZnrjbDWITHEKZnY5dUGXTp2+042HwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8CtVhlv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778623875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6jUpUteB+fL5/Gn+lO9XqONgcFiGo6qcPWJ1La1GAco=;
	b=T8CtVhlvYEavvg6vr4s+37OvBpClRS5rJhegcSMwpCzPoByOMOdTYaWNnbVFFfrqZsrTAQ
	NlJq/nMc/ptzbEqL+4CWwmRZPXySmiPie55su9VRyICCzY1PqqwMSor9zHM17P/FB2p0yu
	WRveTaC4o1F/RNv9GBwHfKjObZoU8T0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-HQ15H1jSPe-P96sJXpSmfA-1; Tue,
 12 May 2026 18:11:13 -0400
X-MC-Unique: HQ15H1jSPe-P96sJXpSmfA-1
X-Mimecast-MFC-AGG-ID: HQ15H1jSPe-P96sJXpSmfA_1778623872
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 581041800577;
	Tue, 12 May 2026 22:11:12 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.89.145])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 31B1918004A3;
	Tue, 12 May 2026 22:11:11 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [RFC 3/4] objtool/klp: add --arch option to display target architecture
Date: Tue, 12 May 2026 18:11:01 -0400
Message-ID: <20260512221102.2720763-4-joe.lawrence@redhat.com>
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
X-Rspamd-Queue-Id: 2B4DB52AB9E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2747-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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

objtool is built for a specific architecture determined by SRCARCH at
compile time.  However, the binary currently provides no way to report
this target architecture, making it difficult for scripts or test suites
to verify compatibility before processing object files.

Pass SRCARCH as a preprocessor define and add a --arch (-a) option to
klp diff that prints the target architecture and exits:

  $ objtool klp diff --arch
  x86

This is mutually exclusive with normal operation: when --arch is given,
all other options and arguments are ignored.

Assisted-by: Cursor:claude-4.6-opus
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/Makefile   | 3 ++-
 tools/objtool/klp-diff.c | 9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 94aabeee9736..79694444053c 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -65,7 +65,8 @@ INCLUDES := -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/lib
 
 OBJTOOL_CFLAGS  := -std=gnu11 -fomit-frame-pointer -O2 -g $(WARNINGS)	\
-		   $(INCLUDES) $(LIBELF_FLAGS) $(LIBXXHASH_CFLAGS) $(HOSTCFLAGS)
+		   $(INCLUDES) $(LIBELF_FLAGS) $(LIBXXHASH_CFLAGS) $(HOSTCFLAGS) \
+		   -DOBJTOOL_ARCH=$(SRCARCH)
 
 OBJTOOL_LDFLAGS := $(LIBSUBCMD) $(LIBELF_LIBS) $(LIBXXHASH_LIBS) $(HOSTLDFLAGS)
 
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ebe4a2a087ca..8710ae8708df 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -35,7 +35,7 @@ struct export {
 };
 
 static const char *symvers_path = "Module.symvers";
-bool debug, debug_correlate, debug_clone;
+bool show_arch, debug, debug_correlate, debug_clone;
 int indent;
 
 static const char * const klp_diff_usage[] = {
@@ -45,6 +45,7 @@ static const char * const klp_diff_usage[] = {
 
 static const struct option klp_diff_options[] = {
 	OPT_GROUP("Options:"),
+	OPT_BOOLEAN('a', "arch", &show_arch, "display target architecture"),
 	OPT_BOOLEAN('d', "debug", &debug, "enable all debug output"),
 	OPT_BOOLEAN(0, "debug-correlate", &debug_correlate, "enable correlation debug output"),
 	OPT_BOOLEAN(0, "debug-clone", &debug_clone, "enable cloning debug output"),
@@ -2366,6 +2367,12 @@ int cmd_klp_diff(int argc, const char **argv)
 	int ret;
 
 	argc = parse_options(argc, argv, klp_diff_options, klp_diff_usage, 0);
+
+	if (show_arch) {
+		printf("%s\n", __stringify(OBJTOOL_ARCH));
+		return 0;
+	}
+
 	if (argc != 3)
 		usage_with_options(klp_diff_usage, klp_diff_options);
 
-- 
2.53.0


