Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD11064A3D4
	for <lists+live-patching@lfdr.de>; Mon, 12 Dec 2022 15:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiLLO6a (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Dec 2022 09:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiLLO62 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Dec 2022 09:58:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB222656C;
        Mon, 12 Dec 2022 06:58:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 67D881F8B3;
        Mon, 12 Dec 2022 14:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670857106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=R/8X7O5xD4y0+p+ZS3irGgqXxUCtysr8GPX03Pzflvk=;
        b=GvRp7/NKqUPWJyyhvLovYeDXQkt4oLI+qwyCimrzL2s3WtLUJ0Y8GVk1r7bpVYzRUS5c6X
        JNFfyaeHk2cqlrubHLSM8WItVK886KBHVo9bX/sZOcq4310m1YCZfzJCZe61xbyoN399pq
        ByXfGPQggzuEjf0rmpvoLXSwIebMpBk=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 44C742C141;
        Mon, 12 Dec 2022 14:58:26 +0000 (UTC)
Date:   Mon, 12 Dec 2022 15:58:23 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.2
Message-ID: <Y5dBjz3g1V0exuIp@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.2

======================================

- code cleanup

----------------------------------------------------------------
Zhen Lei (1):
      livepatch: Move the result-invariant calculation out of the loop

 kernel/livepatch/transition.c | 54 +++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)
