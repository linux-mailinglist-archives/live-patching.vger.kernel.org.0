Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264E33CE2E
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfFKON0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 10:13:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:44132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728264AbfFKON0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 10:13:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 003DAAE91;
        Tue, 11 Jun 2019 14:13:24 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, kamalesh@linux.vnet.ibm.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v4 0/3] livepatch: Cleanup of reliable stacktrace warnings
Date:   Tue, 11 Jun 2019 16:13:17 +0200
Message-Id: <20190611141320.25359-1-mbenes@suse.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This is the fourth attempt to improve the situation of reliable stack
trace warnings in livepatch. Based on discussion in
20190531074147.27616-1-pmladek@suse.com (v3).

Changes against v3:
+ weak save_stack_trace_tsk_reliable() removed, because it is not needed
  anymore thanks to Thomas' recent improvements
+ klp_have_reliable_stack() check reintroduced in klp_try_switch_task()

Changes against v2:

+ Put back the patch removing WARN_ONCE in the weak
  save_stack_trace_tsk_reliable(). It is related.
+ Simplified patch removing the duplicate warning from klp_check_stack()
+ Update commit message for 3rd patch [Josh]

Miroslav Benes (2):
  stacktrace: Remove weak version of save_stack_trace_tsk_reliable()
  Revert "livepatch: Remove reliable stacktrace check in
    klp_try_switch_task()"

Petr Mladek (1):
  livepatch: Remove duplicate warning about missing reliable stacktrace
    support

 kernel/livepatch/transition.c | 8 +++++++-
 kernel/stacktrace.c           | 8 --------
 2 files changed, 7 insertions(+), 9 deletions(-)

-- 
2.21.0

