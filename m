Return-Path: <live-patching+bounces-474-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F24F94C63A
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 23:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6117281239
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 21:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9F01552E0;
	Thu,  8 Aug 2024 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZK6a11Q"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51411D554
	for <live-patching@vger.kernel.org>; Thu,  8 Aug 2024 21:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723151908; cv=none; b=JgJIT8nmp1FBViWIhtFiLf/JbYw2+QZDNit9+dNjFmsKjKQkd91i9m4baQtRQ5o0IpdzjbpviWiDF6/wJMpoKfw5IjqLGuVikDkg3vuw3FkOftxGLz4oYuAFRhPHAKsRGSKbn36JrHf92lck84vVrRIc8IMPXwJTfoXPinO08Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723151908; c=relaxed/simple;
	bh=SJo5u277DGY0uGvWNOL+99PfVvPiqXu9mw3+L5CxCb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3pSoRb+x7Fgl6SN+EdXCnSr7siLgtj6Vpk2nwjZPvh6oKhmIm97IjekP47VIs7cguonmmJqUXxuuAB8gYkt2B0O+oAUCkMLi2/n1dwJ0jS1YFzsFa0nyhFBTssnLBGNIxU50X7nYKvJkYDujlzcMlWDrQ5lQXy2rS397+jFPf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZK6a11Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723151905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnjXGHCPUNPy6I5lbWUg1nMwDED9LsoqLpd8V9RhJ4g=;
	b=UZK6a11QhHYgs7QZqiyFsSTPO6VZlsA+iXjaoBb1FrBvJdJ6POnMRZTN8gftP/NPxtfTgb
	I2wj5D1KwhoZ6xzlWnZEGd/FigW9/tTDW7IHdAVMXVpGtsMv3LMP9U1DTekHERLjSwwAYa
	kGZzwFi/tAx/NyGAr1mZcYcPS4o1TWE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452--r30CwRLNoCB0RTJZ1w5hA-1; Thu,
 08 Aug 2024 17:18:18 -0400
X-MC-Unique: -r30CwRLNoCB0RTJZ1w5hA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F04FD1955F4A;
	Thu,  8 Aug 2024 21:18:15 +0000 (UTC)
Received: from sullivan-work.redhat.com (unknown [10.2.17.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6D44C300018D;
	Thu,  8 Aug 2024 21:18:11 +0000 (UTC)
From: Ryan Sullivan <rysulliv@redhat.com>
To: live-patching@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Cc: rysulliv@redhat.com,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jikos@kernel.org,
	jpoimboe@kernel.org,
	naveen.n.rao@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	mpe@ellerman.id.au,
	npiggin@gmail.com
Subject: RE: [PATCH v2] powerpc/ftrace: restore caller's toc on ppc64 livepatch sibling call
Date: Thu,  8 Aug 2024 17:17:40 -0400
Message-ID: <20240808211751.50746-1-rysulliv@redhat.com>
In-Reply-To: <79fffe34-ce0b-4937-a85a-0ce566684887@csgroup.eu>
References: <79fffe34-ce0b-4937-a85a-0ce566684887@csgroup.eu>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Restores caller's toc pointer to r2, on a sibling call this will
uncorrupt the caller's toc pointer and otherwise will be redundant

Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>
---
 arch/powerpc/kernel/trace/ftrace_entry.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/trace/ftrace_entry.S b/arch/powerpc/kernel/trace/ftrace_entry.S
index 76dbe9fd2c0f..4dfbe6076ad1 100644
--- a/arch/powerpc/kernel/trace/ftrace_entry.S
+++ b/arch/powerpc/kernel/trace/ftrace_entry.S
@@ -244,6 +244,9 @@ livepatch_handler:
 	mtlr	r12
 	ld	r2,  -24(r11)
 
+	/* Restore toc to caller's stack in case of sibling call */
+	std	r2, 24(r1)
+
 	/* Pop livepatch stack frame */
 	ld	r12, PACA_THREAD_INFO(r13)
 	subi	r11, r11, 24
-- 
2.44.0


