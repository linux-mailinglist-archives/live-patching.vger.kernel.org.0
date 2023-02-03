Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A6689882
	for <lists+live-patching@lfdr.de>; Fri,  3 Feb 2023 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjBCMWy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Feb 2023 07:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjBCMWv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Feb 2023 07:22:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCFE9DEF9;
        Fri,  3 Feb 2023 04:22:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 11D09200EE;
        Fri,  3 Feb 2023 12:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675426960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mNtvJdFEkJ+jXdKOWmXqrXhKo6WoAPSlnuOUK1ohQYQ=;
        b=XjBddZ0Ae9MZPN3G32TZ40Ieou62drXhI2JG1ku4ttif0KSGkwLmgSY6tGoAjeWIRH1Dkp
        w2E0TvuD6LkLvc8lOTK35+XcMt95m2/ZKvECe5YhxXzLi92RmRFQvTC6YNG1F3LxEfN3Po
        020FCjDPNDZm89c4nQbJukSsCHSryzA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 27B931358A;
        Fri,  3 Feb 2023 12:22:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KDjlN4z83GNWZQAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Fri, 03 Feb 2023 12:22:36 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     mcgrof@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, pmladek@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 1/2] module.h: Document klp_modinfo struct using kdoc
Date:   Fri,  3 Feb 2023 09:22:21 -0300
Message-Id: <20230203122222.1907-2-mpdesouza@suse.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203122222.1907-1-mpdesouza@suse.com>
References: <20230203122222.1907-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Previously the documentation existed only in Documentation/livepatch
directory.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 include/linux/module.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index ec61fb53979a..3382ef8f66a8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -352,6 +352,14 @@ struct mod_kallsyms {
 };
 
 #ifdef CONFIG_LIVEPATCH
+/**
+ * struct klp_modinfo - Elf information preserved from the livepatch module
+ *
+ * @hdr: Elf header
+ * @sechdrs: Section header table
+ * @secstrings: String table for the section headers
+ * @symndx: The symbol table section index
+ */
 struct klp_modinfo {
 	Elf_Ehdr hdr;
 	Elf_Shdr *sechdrs;
-- 
2.39.1

