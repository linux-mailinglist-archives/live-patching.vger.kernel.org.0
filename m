Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C55F5353
	for <lists+live-patching@lfdr.de>; Wed,  5 Oct 2022 13:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJEL3Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Oct 2022 07:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJEL3P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Oct 2022 07:29:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BD172845;
        Wed,  5 Oct 2022 04:29:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B486C1F8B8;
        Wed,  5 Oct 2022 11:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664969349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=RSONogm4ktT7GH8V6bPUMQx+1QqP0KqcdqjhyKH0xow=;
        b=gyOHdWJ5A6s2WublXnb25CBIaK/1jhgf6AGHxcopyn80W4LHTLDBSXoSTml/lfHjvZzJGY
        bzAEuvI5jFxwYLRFl/2+VPuyYb3+RUFB2Fn/Lo7eTrlm3GS5hJ884Z2EMbk9WSJZgjKGwZ
        taMfr9JDJA7wy9cJYI1kN+fGRx4xxYw=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 957442C161;
        Wed,  5 Oct 2022 11:29:09 +0000 (UTC)
Date:   Wed, 5 Oct 2022 13:29:06 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.1
Message-ID: <Yz1qgrJA+wmbVILN@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.1

==================================

- Fix race between fork and livepatch transition revert.

- Add sysfs entry that shows "patched" state for each object (module)
  that can be livepatched by the given livepatch.

- Some clean up.

----------------------------------------------------------------
Joe Lawrence (1):
      selftests/livepatch: normalize sysctl error message

Petr Mladek (1):
      Merge branch 'for-6.1/sysfs-patched-object' into for-linus

Rik van Riel (1):
      livepatch: fix race between fork and KLP transition

Song Liu (2):
      livepatch: add sysfs entry "patched" for each klp_object
      selftests/livepatch: add sysfs test

Zhen Lei (1):
      livepatch: Add a missing newline character in klp_module_coming()

 Documentation/ABI/testing/sysfs-kernel-livepatch |  8 +++
 kernel/livepatch/core.c                          | 20 +++++-
 kernel/livepatch/transition.c                    | 18 ++++-
 tools/testing/selftests/livepatch/Makefile       |  3 +-
 tools/testing/selftests/livepatch/functions.sh   | 36 +++++++++-
 tools/testing/selftests/livepatch/test-sysfs.sh  | 86 ++++++++++++++++++++++++
 6 files changed, 166 insertions(+), 5 deletions(-)
 create mode 100755 tools/testing/selftests/livepatch/test-sysfs.sh
