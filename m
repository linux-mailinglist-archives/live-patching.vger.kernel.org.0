Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419FF23D7F4
	for <lists+live-patching@lfdr.de>; Thu,  6 Aug 2020 10:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgHFIYj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Aug 2020 04:24:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:51150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgHFIYj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Aug 2020 04:24:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0EBA7AB9F;
        Thu,  6 Aug 2020 08:24:55 +0000 (UTC)
Date:   Thu, 6 Aug 2020 10:24:37 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.9
Message-ID: <20200806082437.GK24529@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-5.9

==================================

- Improvements and cleanups of livepatching self tests.

----------------------------------------------------------------
Joe Lawrence (5):
      selftests/livepatch: simplify test-klp-callbacks busy target tests
      selftests/livepatch: Don't clear dmesg when running tests
      selftests/livepatch: refine dmesg 'taints' in dmesg comparison
      selftests/livepatch: add test delimiter to dmesg
      selftests/livepatch: Use "comm" instead of "diff" for dmesg

Petr Mladek (1):
      selftests/livepatch: adopt to newer sysctl error format

Yannick Cote (3):
      selftests/livepatch: rework test-klp-shadow-vars
      selftests/livepatch: more verification in test-klp-shadow-vars
      selftests/livepatch: fix mem leaks in test-klp-shadow-vars

 lib/livepatch/test_klp_callbacks_busy.c            |  37 +++-
 lib/livepatch/test_klp_shadow_vars.c               | 240 +++++++++++----------
 tools/testing/selftests/livepatch/README           |  16 +-
 tools/testing/selftests/livepatch/functions.sh     |  40 +++-
 .../testing/selftests/livepatch/test-callbacks.sh  |  84 +++-----
 tools/testing/selftests/livepatch/test-ftrace.sh   |   6 +-
 .../testing/selftests/livepatch/test-livepatch.sh  |  12 +-
 .../selftests/livepatch/test-shadow-vars.sh        |  85 +++++---
 tools/testing/selftests/livepatch/test-state.sh    |  21 +-
 9 files changed, 296 insertions(+), 245 deletions(-)


Best Regards,
Petr
