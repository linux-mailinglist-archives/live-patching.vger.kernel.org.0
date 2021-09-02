Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE7A3FEB60
	for <lists+live-patching@lfdr.de>; Thu,  2 Sep 2021 11:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343520AbhIBJb6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Sep 2021 05:31:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50938 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343545AbhIBJb6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Sep 2021 05:31:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7BE9C225DB;
        Thu,  2 Sep 2021 09:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630575059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jOFJNg/XLX0QLAhudTtZdYx6UwESXy0+qAOuyU0aulw=;
        b=mig2R7EhyAh5z3GS1gmxdaZIuOQL97qvqHtp3zo9dglQMLimZ57CfhLLsNI1XHRV7nabuO
        UNAwCV0hoJQNaN/iD6hbgHpXTBc1sgufrRai1xbQTzQN7SZ+G6yV/VFLaJjUazlG17SV99
        PrAVnldxTB6jn+0yCjixpnacFqcWB88=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D3549A3B87;
        Thu,  2 Sep 2021 09:30:53 +0000 (UTC)
Date:   Thu, 2 Sep 2021 11:30:59 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.15
Message-ID: <YTCZ07u6Fx4QiGoy@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.15

==================================

- Replace deprecated CPU-hotplug API calls.

----------------------------------------------------------------
Sebastian Andrzej Siewior (1):
      livepatch: Replace deprecated CPU-hotplug functions.

 kernel/livepatch/transition.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
