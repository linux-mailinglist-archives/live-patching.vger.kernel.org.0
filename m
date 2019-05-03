Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3112F0B
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfECN0i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 09:26:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:59760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbfECN0i (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 09:26:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ED350AE84;
        Fri,  3 May 2019 13:26:36 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/2] livepatch: Remove custom kobject state handling and duplicated code
Date:   Fri,  3 May 2019 15:26:23 +0200
Message-Id: <20190503132625.23442-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Tobin's patch[1] uncovered that the livepatching code handles kobjects
a too complicated way.

The first patch removes the unnecessary custom kobject state handling.

The second patch is an optional code deduplication. I did something
similar already when introducing the atomic replace. But it was
not considered worth it. There are more duplicated things now...

[1] https://lkml.kernel.org/r/20190430001534.26246-1-tobin@kernel.org


Petr Mladek (2):
  livepatch: Remove custom kobject state handling
  livepatch: Remove duplicated code for early initialization

 include/linux/livepatch.h |  3 --
 kernel/livepatch/core.c   | 86 ++++++++++++++++++++---------------------------
 2 files changed, 37 insertions(+), 52 deletions(-)

-- 
2.16.4

