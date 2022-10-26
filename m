Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A1C60E925
	for <lists+live-patching@lfdr.de>; Wed, 26 Oct 2022 21:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiJZTls (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Oct 2022 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiJZTlp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Oct 2022 15:41:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9096CB4899;
        Wed, 26 Oct 2022 12:41:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 51F781FD70;
        Wed, 26 Oct 2022 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666813300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XaNif8Cw4uustU+ovZVF6G4VJf04B2ti3O7xS7XvquQ=;
        b=SvwwGe9CaAHchGBB+YPr9VxpoHxmlfnVr7TipKs3dk5HkX9Grue8h8HlRthHi/TW7TYiKP
        UMHcYfYadKHctOjGG4CHuqH/C7yx+5SDF233K7Z9gpkK0vC/n4wJJSg1LMCu70Xb0iKG5e
        nzMxl+aZfgxraGQKjndTht2m+Rh78Ek=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0004013A77;
        Wed, 26 Oct 2022 19:41:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CLAALnGNWWNlFwAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Wed, 26 Oct 2022 19:41:37 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 2/4] livepatch/shadow: Separate code removing all shadow variables for a given id
Date:   Wed, 26 Oct 2022 16:41:20 -0300
Message-Id: <20221026194122.11761-3-mpdesouza@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026194122.11761-1-mpdesouza@suse.com>
References: <20221026194122.11761-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 Changes from v1:
 * Added my SoB (Josh)

 kernel/livepatch/shadow.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index 81ad7cbbd124..aba44dcc0a88 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -283,6 +283,20 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
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
@@ -294,18 +308,10 @@ EXPORT_SYMBOL_GPL(klp_shadow_free);
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
2.37.3

