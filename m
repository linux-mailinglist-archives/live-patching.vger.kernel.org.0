Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD921BE296
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgD2PZa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727854AbgD2PZ3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fw/rARHKh3ajo0pSJAYwVDVNeUoRc15uksT01bWh3Uw=;
        b=JklEGJNsDr/LjXyDOCO8k/PxRXwoyf7ktpCAMhTcgaHwje4tpO4Z0JJ9wohYaCuctld0QC
        ADgzguY3c6AsqhU6htJeQsfC8Jp/esGKg0669mSZmSrL4J4q1EYaJpDK4T960UN11DvkXT
        4jUTpEt8RBqkTa4Pg0yzaIb2G0GQxDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-sM0PG7XPPDmRlIWYtbQzbA-1; Wed, 29 Apr 2020 11:25:23 -0400
X-MC-Unique: sM0PG7XPPDmRlIWYtbQzbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4798C18FE87E;
        Wed, 29 Apr 2020 15:25:12 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86CEB50FFB;
        Wed, 29 Apr 2020 15:25:11 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 09/11] module: Remove module_disable_ro()
Date:   Wed, 29 Apr 2020 10:24:51 -0500
Message-Id: <9684509017022ad6738560a85bb984210a4025b0.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

module_disable_ro() has no more users.  Remove it.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 include/linux/module.h |  2 --
 kernel/module.c        | 13 -------------
 2 files changed, 15 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 1ad393e62bef..e4ef7b36feda 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -860,10 +860,8 @@ extern int module_sysfs_initialized;
=20
 #ifdef CONFIG_STRICT_MODULE_RWX
 extern void module_enable_ro(const struct module *mod, bool after_init);
-extern void module_disable_ro(const struct module *mod);
 #else
 static inline void module_enable_ro(const struct module *mod, bool after=
_init) { }
-static inline void module_disable_ro(const struct module *mod) { }
 #endif
=20
 #ifdef CONFIG_GENERIC_BUG
diff --git a/kernel/module.c b/kernel/module.c
index 96b2575329f4..f0e414a01d91 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2016,19 +2016,6 @@ static void frob_writable_data(const struct module=
_layout *layout,
 		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
 }
=20
-/* livepatching wants to disable read-only so it can frob module. */
-void module_disable_ro(const struct module *mod)
-{
-	if (!rodata_enabled)
-		return;
-
-	frob_text(&mod->core_layout, set_memory_rw);
-	frob_rodata(&mod->core_layout, set_memory_rw);
-	frob_ro_after_init(&mod->core_layout, set_memory_rw);
-	frob_text(&mod->init_layout, set_memory_rw);
-	frob_rodata(&mod->init_layout, set_memory_rw);
-}
-
 void module_enable_ro(const struct module *mod, bool after_init)
 {
 	if (!rodata_enabled)
--=20
2.21.1

