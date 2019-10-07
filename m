Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5092FCDCFD
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2019 10:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfJGIRS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Oct 2019 04:17:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:56240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727448AbfJGIRS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Oct 2019 04:17:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC998AE46;
        Mon,  7 Oct 2019 08:17:16 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Date:   Mon,  7 Oct 2019 10:17:11 +0200
Message-Id: <20191007081714.20259-1-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch uses ftrace for redirection to new patched functions. It is
thus directly affected by ftrace sysctl knobs such as ftrace_enabled.
Setting ftrace_enabled to 0 also disables all live patched functions. It
is not a problem per se, because only administrator can set sysctl
values, but it still may be surprising.

Introduce PERMANENT ftrace_ops flag to amend this. If the
FTRACE_OPS_FL_PERMANENT is set, the tracing of the function is not
disabled. Such ftrace_ops can still be unregistered in a standard way.

The patch set passes ftrace and livepatch kselftests.

Miroslav Benes (3):
  ftrace: Make test_rec_ops_needs_regs() generic
  ftrace: Introduce PERMANENT ftrace_ops flag
  livepatch: Use FTRACE_OPS_FL_PERMANENT

 Documentation/trace/ftrace-uses.rst |  6 ++++
 Documentation/trace/ftrace.rst      |  2 ++
 include/linux/ftrace.h              |  8 +++--
 kernel/livepatch/patch.c            |  3 +-
 kernel/trace/ftrace.c               | 47 ++++++++++++++++++++++++-----
 5 files changed, 55 insertions(+), 11 deletions(-)

-- 
2.23.0

