Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC7C563A40
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiGATsm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 15:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiGATsh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 15:48:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E342655C
        for <live-patching@vger.kernel.org>; Fri,  1 Jul 2022 12:48:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 56C6B222DE;
        Fri,  1 Jul 2022 19:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656704915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=7hzsDqB7U/VQlHCST9vjrRvUNjm2rEzvmKwxyMcxGYI=;
        b=sXjDu7l4Pda4mLrWEbMrWkzOOD+aMt8qdlxGWv3wYUBrP6mdbBVyUnIX50r5mj568YV5X4
        sGy7jshoiGBaLbHY5prn2TAzrNncFHs7XWSlQ8RCrI9aFjq0bSPbk1NZFX+tqD2fUTVSZT
        NfLp9jOE0HoKmVehSjJrlWnNxYHV/Rs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 772D113A20;
        Fri,  1 Jul 2022 19:48:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GoJLD5FPv2JTTgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Fri, 01 Jul 2022 19:48:33 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de, Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH 0/4] livepatch: Add garbage collection for shadow variables
Date:   Fri,  1 Jul 2022 16:48:13 -0300
Message-Id: <20220701194817.24655-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.35.3
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

Hello reviewers,

These patches were originally created by Petr. The patches 3 and 4 were
originally one bigger patch but they are more easily reviewed split.

The patches 1 and 2 are code improvements.
Patch 3 adds a new struct called klp_shadow_type that combines the id, ctor and
dtor of a shadow variable. This patch is needed by patch 4.

Patch 4 adds the garbage collection.

Thanks for reviewing!

Marcos Paulo de Souza (2):
  livepatch/shadow: Introduce klp_shadow_type structure
  livepatch/shadow: Add garbage collection of shadow variables

Petr Mladek (2):
  livepatch/shadow: Separate code to get or use pre-allocated shadow
    variable
  livepatch/shadow: Separate code removing all shadow variables for a
    given id

 include/linux/livepatch.h                     |  50 ++-
 kernel/livepatch/core.c                       |  39 +++
 kernel/livepatch/core.h                       |   1 +
 kernel/livepatch/shadow.c                     | 296 +++++++++++++-----
 kernel/livepatch/transition.c                 |   4 +-
 lib/livepatch/test_klp_shadow_vars.c          | 119 ++++---
 samples/livepatch/livepatch-shadow-fix1.c     |  24 +-
 samples/livepatch/livepatch-shadow-fix2.c     |  34 +-
 .../selftests/livepatch/test-shadow-vars.sh   |   2 +-
 9 files changed, 415 insertions(+), 154 deletions(-)

-- 
2.35.3

