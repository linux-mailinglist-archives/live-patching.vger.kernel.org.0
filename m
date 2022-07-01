Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44BA563A43
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 21:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiGATsp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 15:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGATso (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 15:48:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D36924958
        for <live-patching@vger.kernel.org>; Fri,  1 Jul 2022 12:48:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E574B222E0;
        Fri,  1 Jul 2022 19:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656704921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mApeaajVoFYxVpIA0SWv6Mk+esUt/5Ga0KS/5BnrRwA=;
        b=WVsqmJbPf0mJAAn4+7rDx/IxjqhpOcjS7qmQYX3FpqyMOwpnX+43FEDJ9GDJceisL3wTJg
        u+MpuHIcfZEBQ3Zoq540jrno2drnXKAMikraZQvTWCOl34Sdt5cLDDMK97mR8s562OsuTR
        A3TkXlfMeYTF7S6qnkN0uTeH9gVNNWw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4433B13A20;
        Fri,  1 Jul 2022 19:48:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CG6WAphPv2JTTgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Fri, 01 Jul 2022 19:48:40 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de
Subject: [PATCH 2/4] livepatch/shadow: Separate code removing all shadow variables for a given id
Date:   Fri,  1 Jul 2022 16:48:15 -0300
Message-Id: <20220701194817.24655-3-mpdesouza@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701194817.24655-1-mpdesouza@suse.com>
References: <20220701194817.24655-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

Allow to remove all shadow variables with already taken klp_shadow_lock.
It will be needed to synchronize this with other operation during
the garbage collection of shadow variables.

It is a code refactoring without any functional changes.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/shadow.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index 67c1313f6831..79b8646b1d4c 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -280,6 +280,20 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 }
 EXPORT_SYMBOL_GPL(klp_shadow_free);
 
+static void __klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
+{
+	struct klp_shadow *shadow;
+	int i;
+
+	lockdep_assert_held(&klp_shadow_lock);
+
+	/* Delete all <*, id> from hash */
+	hash_for_each(klp_shadow_hash, i, shadow, node) {
+		if (klp_shadow_match(shadow, shadow->obj, id))
+			klp_shadow_free_struct(shadow, dtor);
+	}
+}
+
 /**
  * klp_shadow_free_all() - detach and free all <_, id> shadow variables
  * @id:		data identifier
@@ -291,18 +305,10 @@ EXPORT_SYMBOL_GPL(klp_shadow_free);
  */
 void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 {
-	struct klp_shadow *shadow;
 	unsigned long flags;
-	int i;
 
 	spin_lock_irqsave(&klp_shadow_lock, flags);
-
-	/* Delete all <_, id> from hash */
-	hash_for_each(klp_shadow_hash, i, shadow, node) {
-		if (klp_shadow_match(shadow, shadow->obj, id))
-			klp_shadow_free_struct(shadow, dtor);
-	}
-
+	__klp_shadow_free_all(id, dtor);
 	spin_unlock_irqrestore(&klp_shadow_lock, flags);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_free_all);
-- 
2.35.3

