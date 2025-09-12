Return-Path: <live-patching+bounces-1648-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1439B551B7
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 16:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9526D58428D
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 14:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5A0322C73;
	Fri, 12 Sep 2025 14:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6DzdkgD"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F9324B1C
	for <live-patching@vger.kernel.org>; Fri, 12 Sep 2025 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687280; cv=none; b=odTD6UEcfH3I+JSg0kYqYNkjaYgIEg1y8VmaszVBZAQMv1VXLll8cQndHTQOphVfTvHtdJYv+Gnwn8IfTfECl6xwD4/qX+9fX6y1sI33zT/fmnI2z5MihbsXjiS2iCpom5Bez76gwdXPD+zbT943k6+Izdkqr8JywMDKp6WGj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687280; c=relaxed/simple;
	bh=pCQ4uSCnyA0Yf35+XnvALO7Rqa2p53aPBhZ2ia+R2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=gShLG2iH8dliyfN1YAZ6YulJTzPiDLNTdHYNhnoXbwddJ1SSonotcrvKmMSaB7puEEc/puzho2+iXeTQnvaRvH5UYJ2/nWmBYLEsfZK75N6whb3ITCG1T9Ku3gUCUEXq/wBPypYBt/7TZjqSvAABVGtTmjEFK1soRiMYbmqrhmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6DzdkgD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757687277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=stx2VrfzaBsnc/jAGNYjJWhUFVHawzyDw+ZsgOSjXaw=;
	b=U6DzdkgDxVCCxLymSA3uG3OJqolQ/xE4Q1WONdHGg1wtg1Qgr3fd+Efljnb/EoM0Oi1czl
	pk9lWjGxbmWdp2PRUO43Bgz6vAjvAqRRJnBEjeN7c+uTnv6UO84RqpHApJcymgzVNHmfHT
	XbPnD6YbmqMGifrXZOktQnnXSreZjj8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-9Ah1jaShOdWwEaz5hdcmuw-1; Fri,
 12 Sep 2025 10:27:54 -0400
X-MC-Unique: 9Ah1jaShOdWwEaz5hdcmuw-1
X-Mimecast-MFC-AGG-ID: 9Ah1jaShOdWwEaz5hdcmuw_1757687272
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B8CC18005AA;
	Fri, 12 Sep 2025 14:27:52 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1B3071800576;
	Fri, 12 Sep 2025 14:27:49 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: linuxppc-dev@lists.ozlabs.org,
	live-patching@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH v2 2/3] powerpc64/modules: correctly iterate over stubs in setup_ftrace_ool_stubs
Date: Fri, 12 Sep 2025 10:27:39 -0400
Message-ID: <20250912142740.3581368-3-joe.lawrence@redhat.com>
In-Reply-To: <20250912142740.3581368-1-joe.lawrence@redhat.com>
References: <20250912142740.3581368-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

CONFIG_PPC_FTRACE_OUT_OF_LINE introduced setup_ftrace_ool_stubs() to
extend the ppc64le module .stubs section with an array of
ftrace_ool_stub structures for each patchable function.

Fix its ppc64_stub_entry stub reservation loop to properly write across
all of the num_stubs used and not just the first entry.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 arch/powerpc/kernel/module_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 126bf3b06ab7..0e45cac4de76 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -1139,7 +1139,7 @@ static int setup_ftrace_ool_stubs(const Elf64_Shdr *sechdrs, unsigned long addr,
 
 	/* reserve stubs */
 	for (i = 0; i < num_stubs; i++)
-		if (patch_u32((void *)&stub->funcdata, PPC_RAW_NOP()))
+		if (patch_u32((void *)&stub[i].funcdata, PPC_RAW_NOP()))
 			return -1;
 #endif
 
-- 
2.51.0


