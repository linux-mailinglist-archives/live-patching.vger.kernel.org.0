Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AF61ADF2A
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbgDQOFX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:05:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730861AbgDQOE6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587132297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQvUbry9IMyI28UebIhxTY+721rvzbcFmWQGCJ8qdIY=;
        b=T9tVEiLDfcJfDBRxirU1yuZcOB/t88BE4B5TJ6vxnHTGpUPsMf8tHixsiFEuW/c2mRxe6k
        9uKEeMhJyenXHh6soMySJqWIYMHVc2POAA2IkaJYsDmd9uoMHz1OU3nrmkHujx/pA69ClY
        YZZg6BbwwF1pbZ+xyUDR7nlgtQcVEaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-TF4O6vvGNhWdNd59BSlMtg-1; Fri, 17 Apr 2020 10:04:54 -0400
X-MC-Unique: TF4O6vvGNhWdNd59BSlMtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA04B107B271;
        Fri, 17 Apr 2020 14:04:53 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C4405C1C5;
        Fri, 17 Apr 2020 14:04:52 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH v2 9/9] module: Remove module_disable_ro()
Date:   Fri, 17 Apr 2020 09:04:34 -0500
Message-Id: <fe4dbdc12324b4fe3ade97591e0b11e638aad63f.1587131959.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587131959.git.jpoimboe@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

module_disable_ro() has no more users.  Remove it.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
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
index d36ea8a8c3ec..b1d30ad67e82 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1997,19 +1997,6 @@ static void frob_writable_data(const struct module=
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

