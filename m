Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD25346CF
	for <lists+live-patching@lfdr.de>; Thu, 26 May 2022 00:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiEYWvU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 May 2022 18:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiEYWvT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 May 2022 18:51:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A05E24092;
        Wed, 25 May 2022 15:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2LbSngeeObuFPL7ErF2AoPAHTv4dJXye4aEdBeQeQNc=; b=pKt+abZAcRwTjLPiIuUJ63udl/
        LnZRnektXGIrQifOO2P7wqD5PIlFZuz1FEsn7dG3uIrD0Zcm9nJmRg6jzQ00L28dKnVvU64/SnM0V
        WgngpftvIhbvNa1nF/R2cpMNn3GHQsnpskfqcbowHfbfnCnG1RrjqLx3YEKODPnz/gZccpnduZ+6k
        cHd90+71zdAoZiw3qkosD0UdzDJHfo8IRph+0ZBS+nlISrFAZFqB3LRXClk3O3Qm5udZsMgkKdDCD
        1Y1R04KKoSlNcDEDVZAsI/f126QGimL6tkIM7vsK6kH7EaZ5DS6vQWIFBmABtfvqfKaQQ/st2szcq
        5SRd4ZOA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntzqR-00CuyK-CE; Wed, 25 May 2022 22:51:11 +0000
Date:   Wed, 25 May 2022 15:51:11 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     patches@lists.linux.dev, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Song Liu <song@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [GIT PULL] Modules fixes for v5.19-rc1
Message-ID: <Yo6y37M4oyv5z4+D@bombadil.infradead.org>
References: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Sorry the subject should say "Modules changes".

I also forgot to itemize possible merge conflicts and resolutions
which linux-next reported:

powerpc:
https://lkml.kernel.org/r/20220520154055.7f964b76@canb.auug.org.au

kbuild:
https://lkml.kernel.org/r/20220523120859.570f7367@canb.auug.org.au

  Luis
