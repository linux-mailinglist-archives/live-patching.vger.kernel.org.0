Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308236886C8
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 19:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBBSkM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 13:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjBBSkL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 13:40:11 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC326778F;
        Thu,  2 Feb 2023 10:39:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9DD4533E29;
        Thu,  2 Feb 2023 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675362611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=G9113WeU1VCYSJZi9oEtZ3+Oiam89PAL+MkdMDPwLfg=;
        b=UY5r4vu1NVauUoWSTnh1YYk6qQr4oISsGqpR92zda4mPqgQTkrnArnD9+XWFVaf5q6LsSd
        6RSDlIoX3pdLbNNlx8AsgvYntH5wq+ZsQfyGlMOCz6gvbkHXKwHLF76BHz3cyMxVv6gUsj
        V1oCZL+YAcbQ2SnYjBaGDQMqMuqMfgg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D72D138E8;
        Thu,  2 Feb 2023 18:30:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oCgYMTEB3GOQPwAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Thu, 02 Feb 2023 18:30:09 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     mcgrof@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH] module.h: Document klp_modinfo struct members
Date:   Thu,  2 Feb 2023 15:29:50 -0300
Message-Id: <20230202182950.10471-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.39.1
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

The struct members description can be found on
Documentation/livepatch/module-elf-format.rst, but for a developer it's
easier to search for such information looking at the struct definition.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 include/linux/module.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index ec61fb53979a..4fbe06b29b39 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -353,10 +353,10 @@ struct mod_kallsyms {
 
 #ifdef CONFIG_LIVEPATCH
 struct klp_modinfo {
-	Elf_Ehdr hdr;
-	Elf_Shdr *sechdrs;
-	char *secstrings;
-	unsigned int symndx;
+	Elf_Ehdr hdr;		/* Elf header */
+	Elf_Shdr *sechdrs;	/* Section header table */
+	char *secstrings;	/* String table for the section headers */
+	unsigned int symndx;	/* The symbol table section index */
 };
 #endif
 
-- 
2.39.1

