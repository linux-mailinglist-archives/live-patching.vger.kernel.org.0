Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A584451D40
	for <lists+live-patching@lfdr.de>; Tue, 16 Nov 2021 01:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350017AbhKPA0P (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Nov 2021 19:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243278AbhKOUYW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Nov 2021 15:24:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABCCC061766;
        Mon, 15 Nov 2021 12:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u63uF+RkG65jAgm+d4IXszl9rbAfzv6AzCDviUl9T6g=; b=ugb+Z5mArdOrXSMBdLKaZnzMV5
        91Pm5WPbPaeZtbtMfWagEa2r5yEJL9LItsae0KUpP6ybCqGY5IucKF4YgHuaxLjmLpnJCHFF7FeYs
        RXeujw/2wkfA3CzVoxylfXMyMOTAF0ersST0sh+yhpyquWURVUIpp3ba45SqOWB9FKIFkKRgvmN1d
        qtSMgCebAZkl6REhntyWpjqq02qUHLp3eNLc3REmv8RNnT1OdaSCrf2JtsZnkI3bxFe6ts8cXkodk
        PZ313BAcrNrp5dPfyXog4S157kNq0Z3By5UdUUNULCNrdMklRoCmAbTWh7JgRVkkZQkMXaPbKEgYR
        panMnCkg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmiTc-00H2JS-Su; Mon, 15 Nov 2021 20:21:16 +0000
Date:   Mon, 15 Nov 2021 12:21:16 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libkmod-module: add support for a patient module
 removal option
Message-ID: <YZLBPGtm2vF2DsTk@bombadil.infradead.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-4-mcgrof@kernel.org>
 <20210923085156.scmf5wxr2phc356b@ldmartin-desk2>
 <YVJyIGXN/TR8zdU9@bombadil.infradead.org>
 <20210929184810.adrqpsvlfybnc5qt@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929184810.adrqpsvlfybnc5qt@ldmartin-desk2>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 11:48:31AM -0700, Lucas De Marchi wrote:
> > Sorry don't follow. And since I have one day before vacation, I suppose
> > I won't get to this until I get back. But I'd be happy if you massage
> > it as you see fit as you're used to the code base and I'm sure have
> > a better idea of what likely is best for the library.
> 
> 
> sure, np. I will take a look as time permits.

Just a friendly poke.

  Luis
