Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFDC48ED7F
	for <lists+live-patching@lfdr.de>; Fri, 14 Jan 2022 16:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbiANP5a (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jan 2022 10:57:30 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:55650 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiANP52 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jan 2022 10:57:28 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 85F81218FB;
        Fri, 14 Jan 2022 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642175847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=iTHPqAaPHBaWNDnBdcn/c29Xaw95onlPSiC6tvTEjVg=;
        b=d/1b0hwr76ngfgGgR9+TL/BavD6Urq78TKKSIMXkqfs7yJze+oLgCI+5QXGndhk14D9kCA
        Z2cU/yYW7dnFfqepHJ43qYPszFcMiUee2MDiDWDUIdm7XQIFYtfxl3Tupx3HI/sV8jdkrB
        v9xcKEtuh97MrdzvvdcztIx3R24y/rQ=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7283BA3B85;
        Fri, 14 Jan 2022 15:57:27 +0000 (UTC)
Date:   Fri, 14 Jan 2022 16:57:27 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.17
Message-ID: <20220114155727.GA17419@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.17

====================================

+ Correctly handle kobjects when a livepatch init fails.

+ Avoid CPU hogging when searching for many livepatched symbols.

+ Add livepatch API page into documentation.

----------------------------------------------------------------
David Vernet (3):
      Documentation: livepatch: Add livepatch API page
      livepatch: Fix kobject refcount bug on klp_init_patch_early failure path
      livepatch: Avoid CPU hogging with cond_resched

Petr Mladek (1):
      Merge branch 'for-5.17/kallsyms' into for-linus

Yang Yingliang (1):
      livepatch: Fix missing unlock on error in klp_enable_patch()

 Documentation/livepatch/api.rst          | 30 ++++++++++++++++++++++++++++++
 Documentation/livepatch/index.rst        |  1 +
 Documentation/livepatch/shadow-vars.rst  |  4 ++--
 Documentation/livepatch/system-state.rst |  4 ++--
 kernel/kallsyms.c                        |  1 +
 kernel/livepatch/core.c                  | 29 +++++++++++++----------------
 kernel/livepatch/shadow.c                |  6 +++---
 kernel/module.c                          |  2 ++
 8 files changed, 54 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/livepatch/api.rst
