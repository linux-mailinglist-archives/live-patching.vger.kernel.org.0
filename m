Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD36F27F
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 11:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfD3JKy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 05:10:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:36454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbfD3JKx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 05:10:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C397AC57;
        Tue, 30 Apr 2019 09:10:52 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 0/2] livepatch: Clean up of reliable stacktrace warnings
Date:   Tue, 30 Apr 2019 11:10:47 +0200
Message-Id: <20190430091049.30413-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This is the remaining piece from the original patchset[1]. It is
a simplification and split of the 3rd patch.

[1] https://lkml.kernel.org/r/20190424085550.29612-1-pmladek@suse.com


Petr Mladek (2):
  livepatch: Remove duplicate warning about missing reliable stacktrace
    support
  livepatch: Use static buffer for debugging messages under rq lock

 kernel/livepatch/transition.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
2.16.4

