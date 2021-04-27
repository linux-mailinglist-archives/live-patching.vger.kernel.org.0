Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8544F36C7BD
	for <lists+live-patching@lfdr.de>; Tue, 27 Apr 2021 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhD0O2v (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 27 Apr 2021 10:28:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:54364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236618AbhD0O2u (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 27 Apr 2021 10:28:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619533686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=HS50CQ8WGAAOkXLFNSVq4JgmaPlPVFcHYCJM8uyloWo=;
        b=dYN3pu/4P50MQzF4/JJSReFM0qLZWwJPbAjOe15Jv2O6AhQ0d2+J/GRrrYnZ6NOaBFKMFz
        K6FVIV1hhhupS8Co9+CVdLs52Cp5Q1D6QO/G7rZ2vZ3y56ExFUhn6ZHnxUkIqNQ+FSYBSw
        0Gy4ikwc5RZzMF3JV6TrJMj4kdPrh0I=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE8E9B1BB;
        Tue, 27 Apr 2021 14:28:06 +0000 (UTC)
Date:   Tue, 27 Apr 2021 16:28:06 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.13
Message-ID: <YIgfdoZ88RrdQ1e8@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.13

==================================

- Use TIF_NOTIFY_SIGNAL infrastructure instead of the fake signal.

----------------------------------------------------------------
Miroslav Benes (1):
      livepatch: Replace the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure

 kernel/livepatch/transition.c | 5 ++---
 kernel/signal.c               | 4 +---
 2 files changed, 3 insertions(+), 6 deletions(-)
