Return-Path: <live-patching+bounces-1646-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E86C7B55198
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 16:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A58473AF153
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 14:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC2F322DC0;
	Fri, 12 Sep 2025 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dtq7XPeu"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A59322DCA
	for <live-patching@vger.kernel.org>; Fri, 12 Sep 2025 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687278; cv=none; b=Tgs1qarM7Cp5/GL29kOCJuAP2E9OnDjGD+ivtFx5i9j2uf3AF+hZcJ6s7RLq5Kn/wON4Qo0zq1w8F49mrvoDpOZwJ/du3HgN3OAWf1mIvcCQhD6OAzwcIqvSF1KB8utOIWWC+6kEJ1im9oead+fxIZ18/0/xQ4j9CBwg9zogk/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687278; c=relaxed/simple;
	bh=Ll8Vc4MtYa73XNI19Vym2twYPNQI64pQ+dPv6i2m/5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=LRccBVWfaKPz1EziweOgWf6mNoX86m1WNDPPpKni3yR+M+dz9os0lwcPSlgKKpg0JSOQIJomxDi7Ff90yRMQsZ1fd7HSb87YijzS8sRYP8WxTB26GLRsxW8YkZz9pPW2nwSzdZryB/nWjTiO/f1gmwQE5yrrnCE+2vMDx4+B3fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dtq7XPeu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757687274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZPvyy/AKMXkhDZNYow1h1stF46QQDZbnLwLHlg6QM8=;
	b=dtq7XPeuywi5PYHmdN+DZ0EdSocSFgdM6D0LPMGYENISR4ZxJ00nKvKgQoLxEKn67NuGbi
	o6H6WYxVKagqpNwY2qjcOMvyfUzsx/N7ioOkw9kuWDBBuFszL8FWGT8vaczq2pTHLMlIgx
	e94awMd66NU+usYosCjC2ZQ+tdoSL0M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-mg6a9mulNxG3LU0iggUvtg-1; Fri,
 12 Sep 2025 10:27:51 -0400
X-MC-Unique: mg6a9mulNxG3LU0iggUvtg-1
X-Mimecast-MFC-AGG-ID: mg6a9mulNxG3LU0iggUvtg_1757687269
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1EA4180057A;
	Fri, 12 Sep 2025 14:27:49 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C366E1800452;
	Fri, 12 Sep 2025 14:27:47 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: linuxppc-dev@lists.ozlabs.org,
	live-patching@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH v2 1/3] powerpc/ftrace: ensure ftrace record ops are always set for NOPs
Date: Fri, 12 Sep 2025 10:27:38 -0400
Message-ID: <20250912142740.3581368-2-joe.lawrence@redhat.com>
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

When an ftrace call site is converted to a NOP, its corresponding
dyn_ftrace record should have its ftrace_ops pointer set to
ftrace_nop_ops.

Correct the powerpc implementation to ensure the
ftrace_rec_set_nop_ops() helper is called on all successful NOP
initialization paths. This ensures all ftrace records are consistent
before being handled by the ftrace core.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Suggested-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 arch/powerpc/kernel/trace/ftrace.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 6dca92d5a6e8..841d077e2825 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -488,8 +488,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 		return ret;
 
 	/* Set up out-of-line stub */
-	if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE))
-		return ftrace_init_ool_stub(mod, rec);
+	if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE)) {
+		ret = ftrace_init_ool_stub(mod, rec);
+		goto out;
+	}
 
 	/* Nop-out the ftrace location */
 	new = ppc_inst(PPC_RAW_NOP());
@@ -520,6 +522,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 		return -EINVAL;
 	}
 
+out:
+	if (!ret)
+		ret = ftrace_rec_set_nop_ops(rec);
+
 	return ret;
 }
 
-- 
2.51.0


