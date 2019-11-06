Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA4F12FA
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2019 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKFJ4E (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 04:56:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:49938 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfKFJ4E (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 04:56:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0C07B28A;
        Wed,  6 Nov 2019 09:56:02 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v3 0/4] s390/livepatch: Implement reliable stack tracing for the consistency model
Date:   Wed,  6 Nov 2019 10:55:57 +0100
Message-Id: <20191106095601.29986-1-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch consistency model requires reliable stack tracing
architecture support in order to work properly. In order to achieve
this, two main issues have to be solved. First, reliable and consistent
call chain backtracing has to be ensured. Second, the unwinder needs to
be able to detect stack corruptions and return errors.

The former should be guaranteed (see 4/4 for details), the latter is
implemented by the patch set (mainly 4/4).

It passes livepatch kselftests (with timeout disabled, see
https://lore.kernel.org/live-patching/20191025115041.23186-1-mbenes@suse.cz/)
and tests from https://github.com/lpechacek/qa_test_klp.

Based on v5.4-rc6. That is why I left 1/4 patch in the series despite
its presence in s390/features branch. The context of the rest of the
series could be preserved as such and changes in s390/fixes present in
v5.4-rc6 are taken into account.

Changes since v2:
- unwind_next_frame() is split to several functions to make it easier to
  review and prepare it for additional changes
- unwind_next_frame_reliable() merged into the existing
  unwind_next_frame()

Changes since v1 and questions follow:
- rebased on top of v5.4-rc5. It also meant rebasing on top of
  ARCH_STACKWALK, which made the outcome nicer and addressed some of
  Joe's remarks.
- sp alignment is checked in both _start and _next_frame cases
- ftrace_graph_ret_addr() calling cleanup

- I tried to use the existing infrastructure as much as possible with
  one exception. I kept unwind_next_frame_reliable() next to the
  ordinary unwind_next_frame(). I did not come up with a nice solution
  how to integrate it. The reliable unwinding is executed on a task
  stack only, which leads to a nice simplification. My integration
  attempts only obfuscated the existing unwind_next_frame() which is
  already not easy to read. Ideas are definitely welcome.

- although not nice (Josh mentioned it in his review), I kept checking
  for kretprobe_trampoline in the main loop. It could go into _start and
  _next_frame callbacks, but more changes would be required (changing a
  function return type, ordinary unwinding does not need it). So I did
  not think it was worth it. I could change it in v3, of course.

Miroslav Benes (4):
  s390/unwind: drop unnecessary code around calling
    ftrace_graph_ret_addr()
  s390/unwind: split unwind_next_frame() to several functions
  s390/unwind: prepare the unwinding interface for reliable stack traces
  s390/livepatch: Implement reliable stack tracing for the consistency
    model

 arch/s390/Kconfig                  |   1 +
 arch/s390/include/asm/stacktrace.h |   3 +-
 arch/s390/include/asm/unwind.h     |  18 +--
 arch/s390/kernel/dumpstack.c       |  16 ++-
 arch/s390/kernel/perf_event.c      |   2 +-
 arch/s390/kernel/stacktrace.c      |  48 ++++++-
 arch/s390/kernel/unwind_bc.c       | 194 ++++++++++++++++++++---------
 arch/s390/oprofile/init.c          |   2 +-
 8 files changed, 208 insertions(+), 76 deletions(-)

-- 
2.23.0

