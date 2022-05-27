Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049C853571A
	for <lists+live-patching@lfdr.de>; Fri, 27 May 2022 02:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiE0Acx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 May 2022 20:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiE0Acv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 May 2022 20:32:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D7913F7D;
        Thu, 26 May 2022 17:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 875FC61D2D;
        Fri, 27 May 2022 00:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 970CAC385A9;
        Fri, 27 May 2022 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653611569;
        bh=EJ+M0UolvZcc5eCQAgbviCxSXBshGpflKucWZ7mnGQo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tHo3LrnI51gUIj/ZnfKNKaFaNtt0PdZ5Fe3c16jpOyAlouTJfPNwrhsg+ap52uevN
         d2xTlqYYM/sxFABChVLYEyRRy2bNElZ7GMVeedGsBo4uwp+WCV48mGHDmuGsIapUD4
         UJkjTdmDWsGsJyZck+IBl6tjr3Q7iByptjIjUf1/YL5To7FiSBmJoLnGfSjLzhplK2
         IlP1mklaWfR4i4boxw+YOvyamklaE8u6HnRnUEBNfC/CDLxAUEoZFysCzI9iqCUwzw
         ddip7kmvhE3bZP0CHgBk39ji6KDePoNGULCSh3/rnITh+ZZn7nNezEUAnXelgER76p
         QGXYQg7VV0ybg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81278F0394B;
        Fri, 27 May 2022 00:32:49 +0000 (UTC)
Subject: Re: [GIT PULL] Modules fixes for v5.19-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
References: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
X-PR-Tracked-List-Id: Linux on PowerPC Developers Mail List <linuxppc-dev.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-5.19-rc1
X-PR-Tracked-Commit-Id: 7390b94a3c2d93272d6da4945b81a9cf78055b7b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef98f9cfe20d8ca063365d46d4ab2b85eeeb324f
Message-Id: <165361156952.27205.7644773907998918342.pr-tracker-bot@kernel.org>
Date:   Fri, 27 May 2022 00:32:49 +0000
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Song Liu <song@kernel.org>, mcgrof@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Keith Busch <kbusch@kernel.org>, live-patching@vger.kernel.org,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-modules@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Wed, 25 May 2022 14:49:34 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-5.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef98f9cfe20d8ca063365d46d4ab2b85eeeb324f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
