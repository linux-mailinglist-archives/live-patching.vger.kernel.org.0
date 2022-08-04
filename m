Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425F1589C78
	for <lists+live-patching@lfdr.de>; Thu,  4 Aug 2022 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiHDNTV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Aug 2022 09:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiHDNTU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Aug 2022 09:19:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADD51DA73;
        Thu,  4 Aug 2022 06:19:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 31BE02100D;
        Thu,  4 Aug 2022 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659619158; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=XZQzMO92Je2z3nTtjnI4WFLSj0n80v2BsrU2KK6eZFA=;
        b=oJJaPWxt2HrMiVo7ZAheyI/lhUBriP3Qn/atP3ws0v7yIDxZ9ZcqaXfKc8AV2Ucy8/PFIE
        ctq583KLnNMJTL4aAxiskTb+tDgcBG4N2eXGsjDmuOAh3LTtPsXMEzMJbYRok9+yefwa3G
        nhdJsMjkstModC1l1Bg2M6PPJ6V3IUg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0FE792C141;
        Thu,  4 Aug 2022 13:19:18 +0000 (UTC)
Date:   Thu, 4 Aug 2022 15:19:17 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.20
Message-ID: <YuvHVUrcraF20aIP@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.20

======================================

- Make a selftest more reliable.

----------------------------------------------------------------
Joe Lawrence (1):
      selftests/livepatch: better synchronize test_klp_callbacks_busy

 lib/livepatch/test_klp_callbacks_busy.c | 8 ++++++++
 1 file changed, 8 insertions(+)
