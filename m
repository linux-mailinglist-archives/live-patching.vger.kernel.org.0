Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2867437C1
	for <lists+live-patching@lfdr.de>; Fri, 30 Jun 2023 10:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjF3IwB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Jun 2023 04:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjF3Iv7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Jun 2023 04:51:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51202100;
        Fri, 30 Jun 2023 01:51:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7750521853;
        Fri, 30 Jun 2023 08:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688115116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=2aqH3sf+U4eErOsjHoFwxu3dwSX26xiiKO8iBBj+if4=;
        b=K1tFbnPRYinq1F7qs0nSzxRxNQ7uiJyyh3eSoch/XwIiPcCxYRb+7fXH4UO4HW6bTIbtcd
        jWsvVV+05nd4nf0Xi8hHlW4v1hBVDF/ee8yxlUadH4SWYNfJpe7dPeCRWQiF4VxPQ6dZVC
        JNzarzTBCTHAOolof79RsCb2KpvGKII=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 474852C141;
        Fri, 30 Jun 2023 08:51:56 +0000 (UTC)
Date:   Fri, 30 Jun 2023 10:51:52 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.5
Message-ID: <ZJ6XqN90v2tU483G@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.5

===================================

- Make a variable static to fix a sparse warning.

----------------------------------------------------------------
Josh Poimboeuf (1):
      livepatch: Make 'klp_stack_entries' static

 kernel/livepatch/transition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
