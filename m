Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14949108FAD
	for <lists+live-patching@lfdr.de>; Mon, 25 Nov 2019 15:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfKYOO2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 25 Nov 2019 09:14:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:52522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727702AbfKYOO2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 25 Nov 2019 09:14:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBFE7AEFB;
        Mon, 25 Nov 2019 14:14:26 +0000 (UTC)
Date:   Mon, 25 Nov 2019 15:14:25 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.5
Message-ID: <20191125141425.qlda25sth5zj66pn@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-5.5

to receive livepatching subsystem update.

=====================================

+ New API to track system state changes done be livepatch callbacks.
  It helps to maintain compatibility between livepatches.

+ Update Kconfig help text. ORC is another reliable unwinder.

+ Disable generic selftest timeout. Livepatch selftests have their own
  per-operation fine-grained timeouts.

======================================

There is expected one merge conflict with ftrace tree. Both add a new
independent selftest.

----------------------------------------------------------------
Joe Lawrence (1):
      x86/stacktrace: update kconfig help text for reliable unwinders

Miroslav Benes (1):
      selftests/livepatch: Disable the timeout

Petr Mladek (7):
      livepatch: Keep replaced patches until post_patch callback is called
      livepatch: Basic API to track system state changes
      livepatch: Allow to distinguish different version of system state changes
      livepatch: Documentation of the new API for tracking system state changes
      livepatch: Selftests of the API for tracking system state changes
      Merge branch 'for-5.5/selftests' into for-linus
      Merge branch 'for-5.5/system-state' into for-linus

 Documentation/livepatch/index.rst               |   1 +
 Documentation/livepatch/system-state.rst        | 167 +++++++++++++++++++++
 arch/x86/Kconfig.debug                          |   4 -
 include/linux/livepatch.h                       |  17 +++
 kernel/livepatch/Makefile                       |   2 +-
 kernel/livepatch/core.c                         |  44 ++++--
 kernel/livepatch/core.h                         |   5 +-
 kernel/livepatch/state.c                        | 119 +++++++++++++++
 kernel/livepatch/state.h                        |   9 ++
 kernel/livepatch/transition.c                   |  12 +-
 lib/livepatch/Makefile                          |   5 +-
 lib/livepatch/test_klp_state.c                  | 162 ++++++++++++++++++++
 lib/livepatch/test_klp_state2.c                 | 191 ++++++++++++++++++++++++
 lib/livepatch/test_klp_state3.c                 |   5 +
 tools/testing/selftests/livepatch/Makefile      |   3 +-
 tools/testing/selftests/livepatch/settings      |   1 +
 tools/testing/selftests/livepatch/test-state.sh | 180 ++++++++++++++++++++++
 17 files changed, 902 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/livepatch/system-state.rst
 create mode 100644 kernel/livepatch/state.c
 create mode 100644 kernel/livepatch/state.h
 create mode 100644 lib/livepatch/test_klp_state.c
 create mode 100644 lib/livepatch/test_klp_state2.c
 create mode 100644 lib/livepatch/test_klp_state3.c
 create mode 100644 tools/testing/selftests/livepatch/settings
 create mode 100755 tools/testing/selftests/livepatch/test-state.sh


Best Regards,
Petr
