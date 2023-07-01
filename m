Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1F77446AF
	for <lists+live-patching@lfdr.de>; Sat,  1 Jul 2023 07:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjGAFFY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 1 Jul 2023 01:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjGAFFI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 1 Jul 2023 01:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E050D4232;
        Fri, 30 Jun 2023 22:05:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74E5C60F05;
        Sat,  1 Jul 2023 05:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8C8CC433C7;
        Sat,  1 Jul 2023 05:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688187902;
        bh=Chp/dF5vEstDKA5BwQZEJf50ojKTOh8MxGE24r2ZtmU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=d882mKYX5Rn27rM2O/Y8TnefFy2EArz/mihlnP6+ohLtSNy/IuwHhXPFSrvEDdZOY
         JNGjAKqx3DW1ecvR9jJ+91nH57SFfCrXD5lp5T/kKgO9XrclSRMD/bKTGdopI9hjHY
         ucRGMeryKPLy/eEJtQxCYTIBcrkIRRt8rdbBl+1vJDB1SdvriMnIE6BXtTXmaL7pIF
         NcyaU4itnZCIQaILklISQrDEQ2xOw/IFK0abZsWzw5DwWeuw80Ycq/cDNOBZiQC9JW
         IKvmSCWh7LZz4Kco2JfE6PNHwXzTUEeRnAzessxrBblJXFk3Loo9khs/N/YJ8nGHEq
         L6Lbf560APu5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8E94E5381B;
        Sat,  1 Jul 2023 05:05:02 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZJ6XqN90v2tU483G@alley>
References: <ZJ6XqN90v2tU483G@alley>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZJ6XqN90v2tU483G@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.5
X-PR-Tracked-Commit-Id: 42cffe980ce383893660d78e33340763ca1dadae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f4ce392b03722b62804909aadbce6ff4f9c50b91
Message-Id: <168818790281.30776.1514772909331959682.pr-tracker-bot@kernel.org>
Date:   Sat, 01 Jul 2023 05:05:02 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Fri, 30 Jun 2023 10:51:52 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f4ce392b03722b62804909aadbce6ff4f9c50b91

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
