Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96F46D3BF
	for <lists+live-patching@lfdr.de>; Wed,  8 Dec 2021 13:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhLHM5E (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 8 Dec 2021 07:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhLHM5D (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 8 Dec 2021 07:57:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066F2C061746;
        Wed,  8 Dec 2021 04:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XoLdah4Vhal5BMwdRxmj89JX830AjtudjkfO7UjNrhQ=; b=mb7VDEXoLh0hh3nq3LaUmRU/uJ
        u+2Mx5oXT+8M6uZbP/70Zdtoxz58tkS8+Er8ZDFqnsmyYVv8M17wJXMUtrx4k9U+435bMBfTcjk9S
        PWKLuuG3WlXXPcfNHRNtXJ7DWSB9bAtvbFDjlGLG4/7SCuYg/sKq0VTcQBl8BS8zZybrt0lnkz9cu
        X+SPRH92tW3/Gp+hHdFU31w1SZPRGjXstBPYFMEttR9ybSQS/4XqO3KSmS/COf76KXom4Z2jtrSah
        P/51STuBRXPFHBzLuoB000bO0Wv8u+jYzfSUHlSoMG0stvEQve68Sce7wLMTn6pDsJDW3K4ysoFlm
        Tpcz2srQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muwRv-00Cbun-AQ; Wed, 08 Dec 2021 12:53:31 +0000
Date:   Wed, 8 Dec 2021 04:53:31 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libkmod-module: add support for a patient module
 removal option
Message-ID: <YbCqy320/twxxCRb@bombadil.infradead.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-4-mcgrof@kernel.org>
 <20210923085156.scmf5wxr2phc356b@ldmartin-desk2>
 <YVJyIGXN/TR8zdU9@bombadil.infradead.org>
 <20210929184810.adrqpsvlfybnc5qt@ldmartin-desk2>
 <YZLBPGtm2vF2DsTk@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZLBPGtm2vF2DsTk@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 15, 2021 at 12:21:16PM -0800, Luis Chamberlain wrote:
> On Wed, Sep 29, 2021 at 11:48:31AM -0700, Lucas De Marchi wrote:
> > > Sorry don't follow. And since I have one day before vacation, I suppose
> > > I won't get to this until I get back. But I'd be happy if you massage
> > > it as you see fit as you're used to the code base and I'm sure have
> > > a better idea of what likely is best for the library.
> > 
> > 
> > sure, np. I will take a look as time permits.
> 
> Just a friendly poke.

Just another friendy poke.

  Luis
