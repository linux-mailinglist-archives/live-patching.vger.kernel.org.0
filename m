Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2561345102
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 03:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbfFNBIc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Jun 2019 21:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfFNBIc (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Jun 2019 21:08:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34CD23082DDD;
        Fri, 14 Jun 2019 01:08:29 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DC8B5429D;
        Fri, 14 Jun 2019 01:08:24 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/3] module: Livepatch/ftrace fixes
Date:   Thu, 13 Jun 2019 20:07:21 -0500
Message-Id: <cover.1560474114.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 14 Jun 2019 01:08:32 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Patch 1 fixes a module loading race between livepatch and ftrace.

Patch 2 adds lockdep assertions assocated with patch 1.

Patch 3 fixes a theoretical bug in the module __ro_after_init section
handling.

Josh Poimboeuf (3):
  module: Fix livepatch/ftrace module text permissions race
  module: Add text_mutex lockdep assertions for page attribute changes
  module: Improve module __ro_after_init handling

 arch/arm64/kernel/ftrace.c |  2 +-
 include/linux/module.h     |  4 ++--
 kernel/livepatch/core.c    | 10 ++++++++--
 kernel/module.c            | 29 ++++++++++++++++++++++-------
 kernel/trace/ftrace.c      | 10 +++++++++-
 5 files changed, 42 insertions(+), 13 deletions(-)

-- 
2.20.1

