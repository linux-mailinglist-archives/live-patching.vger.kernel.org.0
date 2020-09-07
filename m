Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8212A25F4E9
	for <lists+live-patching@lfdr.de>; Mon,  7 Sep 2020 10:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgIGIUj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Sep 2020 04:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:36690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgIGIUi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Sep 2020 04:20:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D57DBAE16;
        Mon,  7 Sep 2020 08:20:37 +0000 (UTC)
Date:   Mon, 7 Sep 2020 10:20:36 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.9-rc5
Message-ID: <20200907082036.GC8084@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-5.9-rc5

======================================

- Workaround "unreachable instruction" objtool warnings that happen
  with some compiler versions.

----------------------------------------------------------------
Josh Poimboeuf (1):
      Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled"

 Makefile | 4 ----
 1 file changed, 4 deletions(-)


Best Regards,
Petr
