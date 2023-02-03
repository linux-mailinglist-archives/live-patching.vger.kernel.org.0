Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96110689872
	for <lists+live-patching@lfdr.de>; Fri,  3 Feb 2023 13:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjBCMWo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Feb 2023 07:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBCMWm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Feb 2023 07:22:42 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038669E9C7;
        Fri,  3 Feb 2023 04:22:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B3B2C345FD;
        Fri,  3 Feb 2023 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675426956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=G+APx1/551nbZhYh9Oe6K7Hv17IGtCGwgzdzLU9/Pa8=;
        b=d8stXQ8VJQCgmpH53Ztp5ttCgXWCin0IkWy6GwyoVD1AaO32d5c7Gm5oS3VYRxeg7kKwWI
        /3oc8lmV1jG99ldJjspz1BlYB8ma4gbxCr2ZgAKdoqmzLPv/l9N7jbRArzH18XxH6HxrVC
        JxLuyFAWnDA423bl9locZrx5jN4biv0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA0D81358A;
        Fri,  3 Feb 2023 12:22:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IpBAIIn83GNWZQAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Fri, 03 Feb 2023 12:22:33 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     mcgrof@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, pmladek@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2] Document klp_modinfo using kdoc
Date:   Fri,  3 Feb 2023 09:22:20 -0300
Message-Id: <20230203122222.1907-1-mpdesouza@suse.com>
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

Originally it was only one patch, but it was divided in two. The second one
removed the local declaration to klp_modinfo and also refers to it using kdoc
format.

Changes from v1:
* Use kdoc (Luis)

Original commit message:
The struct members description can be found on
Documentation/livepatch/module-elf-format.rst, but for a developer it's
easier to search for such information looking at the struct definition.

Marcos Paulo de Souza (2):
  module.h: Document klp_modinfo struct using kdoc
  Documentation: livepatch: module-elf-format: Remove local klp_modinfo
    definition

 Documentation/livepatch/module-elf-format.rst | 11 ++---------
 include/linux/module.h                        |  8 ++++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

-- 
2.39.1

