Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3822D4E9555
	for <lists+live-patching@lfdr.de>; Mon, 28 Mar 2022 13:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbiC1LlZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Mar 2022 07:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244558AbiC1LiI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Mar 2022 07:38:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B6A56C03;
        Mon, 28 Mar 2022 04:30:22 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B04641F37E;
        Mon, 28 Mar 2022 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648467020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=ptF4uKlBf+j63JThpEd5Nppo+/zyX1odlEnDP+ueGQU=;
        b=dh3s6w9BdD7mfQGua5wPVLP4/pjK4l626sx0VGdNDgAIRAtzds1sPoCEw/uVsrcKFad4tf
        /RnKYv8/UAUFJDATP0rcGWIrhfBxiNNSxm8h+PDGzvl8jqNEa/55fIu2ZQ4+cSRAglRL3n
        v2PU1XLiE54EEtZodbANKsD5cC+AcOA=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8C704A3B92;
        Mon, 28 Mar 2022 11:30:20 +0000 (UTC)
Date:   Mon, 28 Mar 2022 13:30:17 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 5.18
Message-ID: <YkGcSUol2xzW62tQ@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170912 (1.9.0)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.18

========================================

- Forced transitions block only to-be-removed livepatches. [Chengming]

- Detect when ftrace handler could not be disabled in self-tests. [David]

- Calm down warning from a static analyzer. [Tom]

----------------------------------------------------------------
Chengming Zhou (1):
      livepatch: Don't block removal of patches that are safe to unload

David Vernet (1):
      livepatch: Skip livepatch tests if ftrace cannot be configured

Petr Mladek (1):
      Merge branch 'for-5.18/selftests-fixes' into for-linus

Tom Rix (1):
      livepatch: Reorder to use before freeing a pointer

 kernel/livepatch/transition.c                    | 11 +++++++++--
 samples/livepatch/livepatch-shadow-fix1.c        |  2 +-
 samples/livepatch/livepatch-shadow-fix2.c        |  2 +-
 tools/testing/selftests/livepatch/functions.sh   | 22 +++++++++++++++++++---
 tools/testing/selftests/livepatch/test-ftrace.sh |  3 ++-
 5 files changed, 32 insertions(+), 8 deletions(-)
