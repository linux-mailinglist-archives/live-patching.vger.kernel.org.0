Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D826A12B7
	for <lists+live-patching@lfdr.de>; Thu, 23 Feb 2023 23:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBWWUM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Feb 2023 17:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBWWUL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Feb 2023 17:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EBC5C15E;
        Thu, 23 Feb 2023 14:20:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCFB4617AE;
        Thu, 23 Feb 2023 22:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A961BC433EF;
        Thu, 23 Feb 2023 22:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677190808;
        bh=4gzbGXr4WCXoEMIhz7N8y4ikatelbYprPv/0LJrGAnI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iJ2ThTb48txCge/ly9Wt4pt3KS1UqdMpIRP6OX8sIeWgaQfTV5rmkf3JVMtIidONx
         7h9G4yDenYziWH9SelxtBlW4sph6taUxPOI4a5RmIold897i+9Z7wyjvOs/UJ0NsQO
         wJOJ0IQh1NcL2mr4qnSGr7QMtYNJVlfkR1Zo5d5KkiKbG/qIhgY4yiZqez3uGDV06z
         dAQGVbCX+z7vjkiTSE+8uZis7A0fGmcKlNBtmsFg2bIF8z6B0wJiJeFXxFix5wWOKL
         8MN6BsDnSfD5IY/RNbJXPaxQCW7X0XNz/6vcH189N8FLGW9NfhlWwPDGSSGschktgr
         ILbblkKV9Xf9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92C82C395E5;
        Thu, 23 Feb 2023 22:20:08 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y/Tmc8NApocTZbX1@alley>
References: <Y/Tmc8NApocTZbX1@alley>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y/Tmc8NApocTZbX1@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.3
X-PR-Tracked-Commit-Id: 0c05e7bd2d017a3a9a0f4e9a19ad4acf1f616f12
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7dd86cf80127aeef8a447c81228a77f0f25cc211
Message-Id: <167719080859.29288.1276303606349714089.pr-tracker-bot@kernel.org>
Date:   Thu, 23 Feb 2023 22:20:08 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Tue, 21 Feb 2023 16:42:43 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7dd86cf80127aeef8a447c81228a77f0f25cc211

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
