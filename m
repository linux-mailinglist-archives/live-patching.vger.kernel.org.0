Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2ED1B8609
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2020 13:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgDYLJM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 25 Apr 2020 07:09:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgDYLI6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 25 Apr 2020 07:08:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587812937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVnDGeFkqHxYb6JYfvKvmBLlLrCl0RNnUymEdkvh3L4=;
        b=d9ylCytNdQIRy2aX9lp82BCqQEHRGp2LSPf9AoEUBvE4jjkpo/p2GGOZhyeu5cGp7TujgC
        ukHREaJpd3NejqunNBBh5kD/DCESdVvEbdkvM67dC8Gtd9nHQny8ZO/Lv0l9YeDqBRdTN3
        mv7GL2BDDr6an2BIl3btZlriaPOZ/2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-UdyXikkFMSWe8aotxXWkXQ-1; Sat, 25 Apr 2020 07:08:55 -0400
X-MC-Unique: UdyXikkFMSWe8aotxXWkXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A7D9462;
        Sat, 25 Apr 2020 11:08:54 +0000 (UTC)
Received: from treble.redhat.com (ovpn-114-29.rdu2.redhat.com [10.10.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 950ED5C1D4;
        Sat, 25 Apr 2020 11:08:51 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH v3 09/10] module: Remove module_disable_ro()
Date:   Sat, 25 Apr 2020 06:07:29 -0500
Message-Id: <33089a8ffb2e724cecfa51d72887ae9bf70354f9.1587812518.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587812518.git.jpoimboe@redhat.com>
References: <cover.1587812518.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

module_disable_ro() has no more users.  Remove it.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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

