Return-Path: <live-patching+bounces-2745-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAE9CZilA2qP8gEAu9opvQ
	(envelope-from <live-patching+bounces-2745-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CF95B52ABC2
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 00:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1FD513091A44
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 22:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C465399350;
	Tue, 12 May 2026 22:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VlT5Gtd5"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7C539BFF5
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623873; cv=none; b=H6I1KtGGKW3OXo3ismifInc4R8k7VfsTJgAmSYEnEjFzNtEckaFnewWElGpLDMmNrJSZqz3eQ3V+Fc2RwBr92C1XUl4yaQ8y0KGAioWxQ0LWunIkNP89J6Rr6nyeEozZd3BoH7dvsROmqWZsU1yDST2torJWIBeOYfZHNCnLkM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623873; c=relaxed/simple;
	bh=ByIivCKj5RFdTIzl0dZ0C7UdwyuY2DvQgnANDqKle9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=U2JeHweXg3CqrZMGlSt5lIUnFe9ouJD3NRU8+t02eW2gnOkwnLET5nIxVMRV2hv++xLUMbim9y2Jiz02XX3OihkkBNsb1XXt3GA1Qpitw0ThZVmxT7XsbBMKJ4G8lBotsTsgDfXNFOoQdMoyRK82Ar6AMeXXG4bfG9HmZcN3WsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VlT5Gtd5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778623871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jMl1LQNh1VTb0T7JDXf2aD50ZWT7xETbSuE8HY6IfBY=;
	b=VlT5Gtd5bL7Udjn24t8IxbmKbRpf3mwbYROTP4z1ESdu9s7FlPzKMmLQmJZDQpZxYjixc0
	MYilUw29qdOyu5hqY7i2A6aq5DD2q/6+XswMIR8rTjUIACCNv1Kw2x8RUqfbGbqYlZGSCv
	Qr2o+rtU+MQ8/RBLzXDXtMpHoVZWKR8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-Td1OYS2ZP6Ssd63EYRYTCA-1; Tue,
 12 May 2026 18:11:09 -0400
X-MC-Unique: Td1OYS2ZP6Ssd63EYRYTCA-1
X-Mimecast-MFC-AGG-ID: Td1OYS2ZP6Ssd63EYRYTCA_1778623868
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C2F719560B2;
	Tue, 12 May 2026 22:11:08 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.89.145])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1806918004A3;
	Tue, 12 May 2026 22:11:06 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [RFC 0/4] klp-build: simple OOT module support
Date: Tue, 12 May 2026 18:10:58 -0400
Message-ID: <20260512221102.2720763-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: CF95B52ABC2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2745-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

This patchset introduces support for patching basic out-of-tree (OOT)
modules.  The primary motivation is to streamline testing for objtool klp
diff by providing a flexible and stable environment.

While much of the objtool klp diff logic can be validated using standard
in-tree modules (avoiding the overhead of full kernel rebuilds), OOT
support provides significant value for reproducing and fixing specific
kernel code patterns.  Standard in-tree drivers are subject to frequent
refactoring and API updates, making them unreliable for producing the
consistent binary patterns required for stable testing.  While dedicated
test modules could be introduced into the kernel tree to ensure
stability, starting with OOT modules allows for faster iteration before
committing to a permanent in-tree landing spot.

For an example, I have inlined a module below used to verify Josh's
latest commit ("objtool/klp: Rewrite symbol correlation algorithm")
[1].  This specific test case confirms that his patch resolves the
thinLTO ambiguity issue originally reported by Song Liu in February [2].

  [1] https://lore.kernel.org/live-patching/cq5uytz6edj75w53f2eubypvqm66hgh4eag7ec2vgqjefzzqts@lcnvt7fcrtmd/T/#mbfaf71b314b6600424f9c5504c415a2e3a87ade3
  [2] https://lore.kernel.org/live-patching/20260226005436.379303-9-song@kernel.org

To make full use of the example OOT module, I have additional test-
harness code that automates fetching pre-built object files, integrating
with kselftests, etc.  I chose to spin out this basic OOT support
first since it mostly stands alone and may have other helpful contexts.

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

==> Kbuild <==
obj-m := klp_test_ambig.o
klp_test_ambig-y := klp_test_ambig_a.o klp_test_ambig_b.o klp_test_ambig_c.o

==> klp_test_ambig_a.c <==
#include <linux/module.h>
#include <linux/kernel.h>
#include "klp_test_ambig.h"

static noinline int __helper(int x, int len)
{
	int i, sum = x;

	for (i = 0; i < len; i++)
		sum += i + 5;
	if (sum > 1000)
		sum = 0;
	return sum;
}

static int value_a;

int klp_test_ambig_func_a(int x)
{
	value_a = __helper(value_a, x);
	return value_a;
}
EXPORT_SYMBOL_GPL(klp_test_ambig_func_a);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("ThinLTO demangled ambiguity test module");

==> klp_test_ambig_b.c <==
#include <linux/module.h>
#include <linux/kernel.h>
#include "klp_test_ambig.h"

static noinline int __helper(int x, int len)
{
	int i, sum = x;

	for (i = 0; i < len; i++)
		sum += i + 10;
	if (sum > 1000)
		sum = 0;
	return sum;
}

static int value_b;

int klp_test_ambig_func_b(int x)
{
	value_b = __helper(value_b, x);
	return value_b;
}
EXPORT_SYMBOL_GPL(klp_test_ambig_func_b);

==> klp_test_ambig_c.c <==
#include <linux/module.h>
#include <linux/kernel.h>
#include "klp_test_ambig.h"

static int value_c;

int klp_test_ambig_func_c(int x)
{
	value_c = klp_test_ambig_func_a(x) + klp_test_ambig_func_b(x);
	return value_c;
}
EXPORT_SYMBOL_GPL(klp_test_ambig_func_c);

==> klp_test_ambig.h <==
#ifndef _KLP_TEST_AMBIG_H
#define _KLP_TEST_AMBIG_H

int klp_test_ambig_func_a(int x);
int klp_test_ambig_func_b(int x);
int klp_test_ambig_func_c(int x);

#endif


==> 0001-thin-lto-demangled-ambiguity.patch <==
From 2d208e686739b1ccccfe385e837b5a4a04a9526f Mon Sep 17 00:00:00 2001
From: klp-build-test <test@example.com>
Date: Sat, 28 Mar 2026 13:55:56 +0000
Subject: [PATCH] thin-lto-demangled-ambiguity

ThinLTO two __helper.llvm.* symbols with disjoint hashes; objtool correlates

---
 klp_test_ambig_a.c | 2 +-
 klp_test_ambig_b.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/klp_test_ambig_a.c b/klp_test_ambig_a.c
index cc4db70..4ee26a5 100644
--- a/klp_test_ambig_a.c
+++ b/klp_test_ambig_a.c
@@ -7,7 +7,7 @@ static noinline int __helper(int x, int len)
 	int i, sum = x;
 
 	for (i = 0; i < len; i++)
-		sum += i + 5;
+		sum += i * 2 + 5;
 	if (sum > 1000)
 		sum = 0;
 	return sum;
diff --git a/klp_test_ambig_b.c b/klp_test_ambig_b.c
index ca114b0..1b7ce1a 100644
--- a/klp_test_ambig_b.c
+++ b/klp_test_ambig_b.c
@@ -7,7 +7,7 @@ static noinline int __helper(int x, int len)
 	int i, sum = x;
 
 	for (i = 0; i < len; i++)
-		sum += i + 10;
+		sum += i * 2 + 10;
 	if (sum > 1000)
 		sum = 0;
 	return sum;
-- 
2.53.0

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

Applies on top of:
tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git
branch: klp-build-arm64
commit: fffce0ac08e0 ("klp-build: Add arm64 syscall patching macro")

Joe Lawrence (4):
  objtool/klp: add --symvers option to klp diff
  objtool/klp: allow special section entry size overrides
  objtool/klp: add --arch option to display target architecture
  livepatch/klp-build: add basic out-of-tree module patching support

 scripts/livepatch/klp-build | 90 ++++++++++++++++++++++++++++---------
 tools/objtool/Makefile      |  3 +-
 tools/objtool/klp-diff.c    | 49 +++++++++++++++++---
 3 files changed, 115 insertions(+), 27 deletions(-)

-- 
2.53.0


