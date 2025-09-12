Return-Path: <live-patching+bounces-1647-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D39B551BE
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 16:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1414B1CC5E24
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 14:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F28324B15;
	Fri, 12 Sep 2025 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LLswFSfP"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EBB324B05
	for <live-patching@vger.kernel.org>; Fri, 12 Sep 2025 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687278; cv=none; b=PEsejsIBSKo7mvWtymR0WkV2nbD06HBYt+4ACbyhTJJcxXy8mG6gPuybvqpL9MtJeAWk68gMK+R77zPKO36Q8XblWxzDOpeAUmWpzayX6PKdnBFWKdmGD9IXxeKQpB6Hkt4v+ADoOJTDoBFH2XWmr2uJprcIstOUdN8RX3Zx/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687278; c=relaxed/simple;
	bh=ccGl4SA8gBz98VY+IZKJlK+Jc/PYOmegrjF7AYqESdM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=RV4xNpdtqMnzkDXTxHk48U2zKkNX44bceAeKbCjVF+LGi6bIw7dTqVaYhRU/SJ59zYb+pGXSyA7sUQHCEJJEcLDgxvSsr/FevHrhjAo4tgMRTeNGUW3HuKvOR21tWeNXoeTKdCUYC1Bh7Nb/ooxlGAiFnLj9jxrqryhJwS2yPh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LLswFSfP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757687275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wdMeJNpmaMWU91io11Cf7LsjSfeZyGuNLcRl222Xmsw=;
	b=LLswFSfPHsChfDE5dp+M32N5+1BnrLhyaKcLmuaNXrc+a3oA/czDtr7DY3eyVhtyg6MQKQ
	PGhkOza8HffhVAFqkS9Rxb7LZq6XvzvEs14ng7c8Nss6unHgkpNAIHnqQy8PeCwHOSSTCP
	cbVviD6lMznA1MPPBMw6aisVAcSTPWo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-NH7vFBPcPI208v_eBsPDsA-1; Fri,
 12 Sep 2025 10:27:49 -0400
X-MC-Unique: NH7vFBPcPI208v_eBsPDsA-1
X-Mimecast-MFC-AGG-ID: NH7vFBPcPI208v_eBsPDsA_1757687268
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29E4B1956050;
	Fri, 12 Sep 2025 14:27:47 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D902180035E;
	Fri, 12 Sep 2025 14:27:44 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: linuxppc-dev@lists.ozlabs.org,
	live-patching@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH v2 0/3] powerpc/ftrace: Fix livepatch module OOL ftrace corruption
Date: Fri, 12 Sep 2025 10:27:37 -0400
Message-ID: <20250912142740.3581368-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This patch series fixes a couple of bugs in the powerpc64 out-of-line
(OOL) ftrace support for modules, and follows up with a patch to
simplify the module .stubs allocation code. An analysis of the module
stub area corruption that prompted this work can be found in the v1
thread [1].

The first two patches fix bugs introduced by commit eec37961a56a
("powerpc64/ftrace: Move ftrace sequence out of line"). The first,
suggested by Naveen, ensures that a NOP'd ftrace call site has its
ftrace_ops record updated correctly. The second patch corrects a loop in
setup_ftrace_ool_stubs() to ensure all required stubs are reserved, not
just the first. Together, these bugs lead to potential corruption of the
OOL ftrace stubs area for livepatch modules.

The final patch replaces the sentinel-based allocation in the module
.stubs section with an explicit counter. This improves clarity and helps
prevent similar problems in the future.

Changes since v1: https://lore.kernel.org/live-patching/df7taxdxpbo4qfn7lniggj5o4ili6kweg4nytyb2fwwwgmnyo4@halp5gf244nn/T/

- Split into parts: bug fix x2, code cleanup
- Call ftrace_rec_set_nop_ops() from ftrace_init_nop() [Naveen]
- Update commit msg on cleanup patch [Naveen]

Joe Lawrence (3):
  powerpc/ftrace: ensure ftrace record ops are always set for NOPs
  powerpc64/modules: correctly iterate over stubs in
    setup_ftrace_ool_stubs
  powerpc64/modules: replace stub allocation sentinel with an explicit
    counter

 arch/powerpc/include/asm/module.h  |  1 +
 arch/powerpc/kernel/module_64.c    | 26 ++++++++------------------
 arch/powerpc/kernel/trace/ftrace.c | 10 ++++++++--
 3 files changed, 17 insertions(+), 20 deletions(-)

-- 
2.51.0


