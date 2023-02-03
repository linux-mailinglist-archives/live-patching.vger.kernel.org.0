Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC0F68987D
	for <lists+live-patching@lfdr.de>; Fri,  3 Feb 2023 13:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjBCMWx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Feb 2023 07:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjBCMWv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Feb 2023 07:22:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED369DCB4;
        Fri,  3 Feb 2023 04:22:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 68925200D8;
        Fri,  3 Feb 2023 12:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675426963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUgcN+ube+bg4pZf/faXEMExTxepzrGeoVNQzvssGAU=;
        b=BG4kWf/z5yUNK9bMNLhmRPQGJooquU4Yhx7k7qWzgSXXifnh/IrjU6C3qNlA6MDVVEvWmn
        2MUq5NM4pgpBnkw0VPEdFFinRwd08BFa2t2kv2QhIMGpmVam2Mq8O+Uhb9tCJm1oQPkj/B
        sz4AhajxlT+nWxIX3ywzQL1sh8GaT/8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DC161358A;
        Fri,  3 Feb 2023 12:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AKGOEZD83GNWZQAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Fri, 03 Feb 2023 12:22:40 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     mcgrof@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, pmladek@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 2/2] Documentation: livepatch: module-elf-format: Remove local klp_modinfo definition
Date:   Fri,  3 Feb 2023 09:22:22 -0300
Message-Id: <20230203122222.1907-3-mpdesouza@suse.com>
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

Refer to klp_modinfo declaration using kdoc.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 Documentation/livepatch/module-elf-format.rst | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index 72a072514581..2f2ee33539f7 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -334,12 +334,5 @@ A livepatch module's symbol table is accessible through module->symtab.
 Since apply_relocate_add() requires access to a module's section headers,
 symbol table, and relocation section indices, Elf information is preserved for
 livepatch modules and is made accessible by the module loader through
-module->klp_info, which is a klp_modinfo struct. When a livepatch module loads,
-this struct is filled in by the module loader. Its fields are documented below::
-
-	struct klp_modinfo {
-		Elf_Ehdr hdr; /* Elf header */
-		Elf_Shdr *sechdrs; /* Section header table */
-		char *secstrings; /* String table for the section headers */
-		unsigned int symndx; /* The symbol table section index */
-	};
+module->klp_info, which is a :c:type:`klp_modinfo` struct. When a livepatch module
+loads, this struct is filled in by the module loader.
-- 
2.39.1

