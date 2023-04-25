Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736376EE8E1
	for <lists+live-patching@lfdr.de>; Tue, 25 Apr 2023 22:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbjDYULM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Apr 2023 16:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbjDYULL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Apr 2023 16:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8874CCC19;
        Tue, 25 Apr 2023 13:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E52C63173;
        Tue, 25 Apr 2023 20:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B29FEC4339B;
        Tue, 25 Apr 2023 20:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682453451;
        bh=t7i5oLH3yrnFXi6q7mDqLvrBKRvuWzNtqXzEmuPgY2o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=N7plkgRSCHJGVIBtliTXdIAiucJlHHjrKUm77lJgss8ANiQev5Cg2StrEUSiDZO/M
         ReeT7IKt6B+dHXvJMGWzlzzygIhg2HeONkhtpFeAOPNy8ZY9sDUP46Q8lcbB/IfRI/
         phUIxh5fp6UTxJFSARd3bIC4siSgxIixjB76o+xbxJXy0f5uI1ty/tUN4Un2udss8/
         vcP8lSxZSnCQsYCSGzNdoHI0RF4FaSoiPaotY3H3D5xydO5CRWllSa7ww22zd7zfS7
         AjnJBIPQEh2+ZFif474fMflyLmsk1bvO56lvjZ+V6Tub+OLHpH/6Zt+9GBxEY2+ok7
         7V/MeHAIDlFuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AC8CC395D8;
        Tue, 25 Apr 2023 20:10:51 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZEavnK8VfIXr-jsP@alley>
References: <ZEavnK8VfIXr-jsP@alley>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZEavnK8VfIXr-jsP@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.4
X-PR-Tracked-Commit-Id: c9c8133080c75ce2440001d765dbe8c24f932ea2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 11704531dde45bc667a411e1c76de81d9f4481b8
Message-Id: <168245345163.30863.9183901678333067129.pr-tracker-bot@kernel.org>
Date:   Tue, 25 Apr 2023 20:10:51 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Mon, 24 Apr 2023 18:34:36 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/11704531dde45bc667a411e1c76de81d9f4481b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
