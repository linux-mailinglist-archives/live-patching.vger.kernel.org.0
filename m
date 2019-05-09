Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54BE18C1A
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfEIOjr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfEIOjL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:11 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78F363079B93;
        Thu,  9 May 2019 14:39:11 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E38925DF49;
        Thu,  9 May 2019 14:39:10 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 04/10] livepatch: Add klp-convert annotation helpers
Date:   Thu,  9 May 2019 10:38:53 -0400
Message-Id: <20190509143859.9050-5-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 09 May 2019 14:39:11 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

Define macros KLP_MODULE_RELOC and KLP_SYMPOS in
include/linux/livepatch.h to improve user-friendliness of the
livepatch annotation process.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 include/linux/livepatch.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 16b48e8b29a2..3071aec8fd72 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -236,6 +236,18 @@ void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
 void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
 void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
 
+/* Used to annotate symbol relocations in livepatches */
+#define KLP_MODULE_RELOC(obj)						\
+	struct klp_module_reloc						\
+	__attribute__((__section__(".klp.module_relocs." #obj)))	\
+	__attribute__((aligned (4)))
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
2.20.1

