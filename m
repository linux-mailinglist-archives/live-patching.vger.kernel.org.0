Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418FD69E3C7
	for <lists+live-patching@lfdr.de>; Tue, 21 Feb 2023 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjBUPnI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Feb 2023 10:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbjBUPmv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Feb 2023 10:42:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA881723;
        Tue, 21 Feb 2023 07:42:49 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E4F165C917;
        Tue, 21 Feb 2023 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676994167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=tpikDxyA7KEg0lK3+BdYnkYOBl5X+Fm+lKsZuEAcpuw=;
        b=daJd4awxCCLh3hxu0NDzeOJSFZjuhdxrZFziR1IsrcnLiuQ6nTdEDqxx8LXYzh7ofEUy6R
        xrr9N3vKgXAOm/Bat1Ne2OnX4Vg7nvTTx6sVYEoZLFj4q0lXgYMl+1+16y08qGpUVZys1o
        FTEOHYTQiZrL/rNGEFYuKrqnQ+7WDHo=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BF01D2C141;
        Tue, 21 Feb 2023 15:42:47 +0000 (UTC)
Date:   Tue, 21 Feb 2023 16:42:43 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.3
Message-ID: <Y/Tmc8NApocTZbX1@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.3

========================================

- Allow to reload livepatched module by clearing livepatch-specific
  relocations in the livepatch module. Otherwise, the repeated load
  would fail on consistency checks.

----------------------------------------------------------------
Song Liu (2):
      x86/module: remove unused code in __apply_relocate_add
      livepatch,x86: Clear relocation targets on a module removal

 arch/x86/kernel/module.c     | 97 +++++++++++++++++++++++++++-----------------
 include/linux/moduleloader.h | 17 ++++++++
 kernel/livepatch/core.c      | 62 ++++++++++++++++++++++------
 3 files changed, 126 insertions(+), 50 deletions(-)
