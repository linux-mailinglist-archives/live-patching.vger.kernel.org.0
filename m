Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A58321A64
	for <lists+live-patching@lfdr.de>; Mon, 22 Feb 2021 15:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhBVObv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 09:31:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:46448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhBVO2r (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 09:28:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614004073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=AhAhubZiu6D9nNWp9+u1PI+pzPnK7s/wONbPGe8OOPY=;
        b=l7ruMnkZ3hr/UOnM02wrNU2dDH8zftyaZx/Tjm3IEJtk7C/0p+ZFPeRvgvFc3I00ujPznE
        GtLpHyE07lBigH47SeI/iOfIjVPbIzR7DLurmaasuL0SHn6820JB4r/UVhoiY8DMN+gdR0
        WUsX46yM9hC/GsN6VpjHbrokXvvcZss=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3E29CAC69;
        Mon, 22 Feb 2021 14:27:53 +0000 (UTC)
Date:   Mon, 22 Feb 2021 15:27:52 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.12
Message-ID: <YDO/aM82PiGprdPQ@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.12

==================================

- Practical information how to implement reliable stacktraces needed by
  the livepatching consistency model by Mark Rutland and Mark Brown.

- Automatically generated documentation contents by Mark Brown.

----------------------------------------------------------------
Mark Brown (1):
      Documentation: livepatch: Convert to automatically generated contents

Mark Rutland (1):
      Documentation: livepatch: document reliable stacktrace

 Documentation/livepatch/index.rst               |   1 +
 Documentation/livepatch/livepatch.rst           |  15 +-
 Documentation/livepatch/module-elf-format.rst   |  10 +-
 Documentation/livepatch/reliable-stacktrace.rst | 309 ++++++++++++++++++++++++
 4 files changed, 313 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/livepatch/reliable-stacktrace.rst
