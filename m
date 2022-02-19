Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269394BC4BA
	for <lists+live-patching@lfdr.de>; Sat, 19 Feb 2022 03:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbiBSCMx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Feb 2022 21:12:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239267AbiBSCMw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Feb 2022 21:12:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663F866C93;
        Fri, 18 Feb 2022 18:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OAqxNDaUe2ylila3+Bj58t/n7xQbOHdFFEY5OriYkBQ=; b=uenpRq5fymbCoVILp7O8eddzwJ
        ISaFYQIqbP4kTH/zXHNZLocS8AJ3oG7C61QIiTCb/j8EedDpCQINOLMTEcHAfJttbC/D460PyzLHD
        f2acc4eqEzqt6x+iJQ5K8cxZRc0PsSgicffOwv1wTVp5X77vIIZj+2HLbceXO4qYywMw65Al2aPD3
        HHkCu9xLuu3U1OZoYa8l23ikV3f3bo54e+N6VYKOSP0GwsCV/TxWEUhlpZBdjchRyHqPrHWHtj9f5
        DFBED2KXPTXl5u34JLNBrGyDp6qfjmvQa6QQDFwWwWrGR0l1yM4i6dRmKxO88J9cXik8IZSntXftZ
        7WqRuZ/g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nLFEV-00G9mG-5d; Sat, 19 Feb 2022 02:12:23 +0000
Date:   Fri, 18 Feb 2022 18:12:23 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, joe@perches.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: Re: [PATCH v6 00/13] module: core code clean up
Message-ID: <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
References: <20220218212511.887059-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218212511.887059-1-atomlin@redhat.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Feb 18, 2022 at 09:24:58PM +0000, Aaron Tomlin wrote:
> Hi Luis,
> 
> As per your suggestion [1], this is an attempt to refactor and split
> optional code out of core module support code into separate components.
> This version is based on Linus' commit 7993e65fdd0f ("Merge tag
> 'mtd/fixes-for-5.17-rc5' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux").
> Please let me know your thoughts.

Fantastic, thanks for doing all this work, I've pushed this out to
modules-next so that the testing can start as this will be in linux-next
soon. I'll obviously wait for more reviews, we have a long time before this
gets merged to Linus, so just want to start getting testing done now rather
than later. And other folks are depending on your changes to start
getting their own code up too.

Thanks!

  Luis
