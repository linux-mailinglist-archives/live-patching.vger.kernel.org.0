Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47613CDB4
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfFKN4n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 09:56:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:39862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728111AbfFKN4n (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 09:56:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65C7BAE9A;
        Tue, 11 Jun 2019 13:56:42 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [RFC 0/5] livepatch: new API to track system state changes
Date:   Tue, 11 Jun 2019 15:56:22 +0200
Message-Id: <20190611135627.15556-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

this is another piece in the puzzle that helps to maintain more
livepatches.

Especially pre/post (un)patch callbacks might change a system state.
Any newly installed livepatch has to somehow deal with system state
modifications done be already installed livepatches.

This patchset provides, hopefully, a simple and generic API that
helps to keep and pass information between the livepatches.
It is also usable to prevent loading incompatible livepatches.

There was also a related idea to add a sticky flag. It should be
easy to add it later. It would perfectly fit into the new struct
klp_state.

Petr Mladek (5):
  livepatch: Keep replaced patches until post_patch callback is called
  livepatch: Basic API to track system state changes
  livepatch: Allow to distinguish different version of system state
    changes
  livepatch: Documentation of the new API for tracking system state
    changes
  livepatch: Selftests of the API for tracking system state changes

 Documentation/livepatch/index.rst               |   1 +
 Documentation/livepatch/system-state.rst        |  80 ++++++++++
 include/linux/livepatch.h                       |  17 +++
 kernel/livepatch/Makefile                       |   2 +-
 kernel/livepatch/core.c                         |  44 ++++--
 kernel/livepatch/core.h                         |   5 +-
 kernel/livepatch/state.c                        | 121 +++++++++++++++
 kernel/livepatch/state.h                        |   9 ++
 kernel/livepatch/transition.c                   |  12 +-
 lib/livepatch/Makefile                          |   5 +-
 lib/livepatch/test_klp_state.c                  | 161 ++++++++++++++++++++
 lib/livepatch/test_klp_state2.c                 | 190 ++++++++++++++++++++++++
 lib/livepatch/test_klp_state3.c                 |   5 +
 tools/testing/selftests/livepatch/Makefile      |   3 +-
 tools/testing/selftests/livepatch/test-state.sh | 180 ++++++++++++++++++++++
 15 files changed, 814 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/livepatch/system-state.rst
 create mode 100644 kernel/livepatch/state.c
 create mode 100644 kernel/livepatch/state.h
 create mode 100644 lib/livepatch/test_klp_state.c
 create mode 100644 lib/livepatch/test_klp_state2.c
 create mode 100644 lib/livepatch/test_klp_state3.c
 create mode 100755 tools/testing/selftests/livepatch/test-state.sh

-- 
2.16.4

