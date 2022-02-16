Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676704B8E32
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiBPQkG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:40:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbiBPQkA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:40:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6564C25BD77
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645029587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Mq1jwqI6luhdbFCNV2XBi7hZGS9NGpXpOnoDwVor4s=;
        b=FJznjZMbIFFyCCtB/0jF7tOSPh1auNnCudmcZdNu161Ar9JBsLx30mVbw7g9IwFyGum3kC
        8KqR0kd9rHjAuCuEuuYfeliX5G7IxgJrMZ90Y1QApF3UDnxdJyk+rOCZ/DbNZBYDAHdoLl
        vM4BCu3ALSCDVX3pMofrfQ98D7luxjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-RrUqpS3pNL63aF8oKGRQ_A-1; Wed, 16 Feb 2022 11:39:46 -0500
X-MC-Unique: RrUqpS3pNL63aF8oKGRQ_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50E77100C610;
        Wed, 16 Feb 2022 16:39:45 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B18A7753D3;
        Wed, 16 Feb 2022 16:39:44 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [RFC PATCH v6 04/12] livepatch: Add klp-convert annotation helpers
Date:   Wed, 16 Feb 2022 11:39:32 -0500
Message-Id: <20220216163940.228309-5-joe.lawrence@redhat.com>
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

Define macros KLP_MODULE_RELOC and KLP_SYMPOS in
include/linux/livepatch.h to improve user-friendliness of the livepatch
annotation process.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 include/linux/livepatch.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 0fb05aae091a..3abb09bd807a 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -237,6 +237,18 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 			     unsigned int symindex, unsigned int secindex,
 			     const char *objname);
 
+/* Used to annotate symbol relocations in livepatches */
+#define KLP_MODULE_RELOC(obj)						\
+	struct klp_module_reloc						\
+	__section(".klp.module_relocs." #obj)				\
+	__aligned(4)
+
+#define KLP_SYMPOS(symbol, pos)						\
+	{								\
+		.sym = &symbol,						\
+		.sympos = pos,						\
+	}
+
 #else /* !CONFIG_LIVEPATCH */
 
 static inline int klp_module_coming(struct module *mod) { return 0; }
-- 
2.26.3

