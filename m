Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0319B30990
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 09:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfEaHmF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 03:42:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:41268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbfEaHmF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 03:42:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6591FAE0E;
        Fri, 31 May 2019 07:42:04 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/3] livepatch: Clean up of reliable stacktrace warnings
Date:   Fri, 31 May 2019 09:41:44 +0200
Message-Id: <20190531074147.27616-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I believe that all the changes make sense. I would like to get them
merged if nobody see a fundamental problem.

Changes against v2:

+ Put back the patch removing WARN_ONCE in the weak
  save_stack_trace_tsk_reliable(). It is related.
+ Simplified patch removing the duplicate warning from klp_check_stack()
+ Update commit message for 3rd patch [Josh]

Petr Mladek (3):
  stacktrace: Remove superfluous WARN_ONCE() from
    save_stack_trace_tsk_reliable()
  livepatch: Remove duplicate warning about missing reliable stacktrace
    support
  livepatch: Use static buffer for debugging messages under rq lock

 kernel/livepatch/transition.c | 4 +---
 kernel/stacktrace.c           | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

-- 
2.16.4

