Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B8B63E60
	for <lists+live-patching@lfdr.de>; Wed, 10 Jul 2019 01:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfGIXe1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Jul 2019 19:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfGIXe0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Jul 2019 19:34:26 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 955522082A;
        Tue,  9 Jul 2019 23:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562715266;
        bh=k9PzkviklfIkh2+9iSWzyPmpzTKPRK3OJitQ/bznqO0=;
        h=Date:From:To:cc:Subject:From;
        b=LKDf8opH9bmnMCgipiqNKxOKeiFqt7OKXoXep77wQB/b9nEWF3gfDeGDoDP/POwnJ
         iLxBtcbLyZtVe2eaDMgPI+owqMZAntyFwZR+8wRHHYTBYBA/xzPA2TJytb7S3C2VSg
         m5UnvAq7MeWV1hPffi1YW5NLQT/bpgB34Up3H/7E=
Date:   Wed, 10 Jul 2019 01:34:19 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.3
Message-ID: <nycvar.YFH.7.76.1907100127250.5899@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git for-linus

to receive livepatching updates staged for 5.3 merge window:

=====
- stacktrace handling improvements from Miroslav benes
- debug output improvements from Petr Mladek
=====

----------------------------------------------------------------
Miroslav Benes (3):
      livepatch: Remove stale kobj_added entries from kernel-doc descriptions
      stacktrace: Remove weak version of save_stack_trace_tsk_reliable()
      Revert "livepatch: Remove reliable stacktrace check in klp_try_switch_task()"

Petr Mladek (2):
      livepatch: Use static buffer for debugging messages under rq lock
      livepatch: Remove duplicate warning about missing reliable stacktrace support

 include/linux/livepatch.h     |  3 ---
 kernel/livepatch/transition.c | 11 ++++++++---
 kernel/stacktrace.c           |  8 --------
 3 files changed, 8 insertions(+), 14 deletions(-)

-- 
Jiri Kosina
SUSE Labs
