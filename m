Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD01B4B158E
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 19:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbiBJSvI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 13:51:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiBJSvI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 13:51:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E122E7F;
        Thu, 10 Feb 2022 10:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mEKCxhU+JNeT1eMVQTnlAK3ulpLxB/CwopnVgEI95lA=; b=0cvSbH4Y/kCukzwjlS9gIBRS9q
        dlBTzfjS8ziXZfcR+CMHsEhjsW2GEW1VYCrlMfcE+mYjv62nsLJtP83VGg1D7qh9Q4eJYe3lNhCsJ
        RHk/cxEZvK1ZiJeGTg8iSaPYN7SpO7ECLYNa0Wbg9vm4YDgAjyXrhU8h2fAZGGW16QRXUatVgk/71
        2rgmFNeCSDTu5WQ4CtEnayeDCr/nQbR/oL3zD+10caFRB1eVMHFmUh4OajwwJO/DQaxDFNBVoqiqB
        e+RMqxk4oLD2lqlu64XvAviH70qmscakTpquZlrjpT8OR/XLMFVsRK4shrjSwHq00P3BoR00beij8
        E8VHEIEA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIEWw-004g2X-9h; Thu, 10 Feb 2022 18:50:58 +0000
Date:   Thu, 10 Feb 2022 10:50:58 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v5 01/13] module: Move all into module/
Message-ID: <YgVekoAxiV5nw22q@bombadil.infradead.org>
References: <20220209170358.3266629-1-atomlin@redhat.com>
 <20220209170358.3266629-2-atomlin@redhat.com>
 <a22eb1b0-3fb5-a70e-cf6f-022571538efb@csgroup.eu>
 <CANfR36jh3yg9nqXkpCUWPeHV+sSD6yne9j1=uA5vyUpYOC8t9g@mail.gmail.com>
 <926e5c35d50ec5f6d7e789831be96744ca8d6423.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <926e5c35d50ec5f6d7e789831be96744ca8d6423.camel@perches.com>
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

On Thu, Feb 10, 2022 at 09:02:09AM -0800, Joe Perches wrote:
> On Thu, 2022-02-10 at 14:45 +0000, Aaron Tomlin wrote:
> > On Thu 2022-02-10 11:11 +0000, Christophe Leroy wrote:
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > > > @@ -13001,7 +13001,7 @@ L:    linux-kernel@vger.kernel.org
> > > >   S:    Maintained
> > > >   T:    git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git modules-next
> > > >   F:    include/linux/module.h
> > > > -F:    kernel/module.c
> > > > +F:    kernel/module/main.c
> > > 
> > > Shouldn't it be the entire directory ?
> > 
> > Indeed it should. Moving forward: kernel/module/*
> 
> Better would be:
> 
> F:	kernel/module/
> 
> in case it ever gets subdirectories too.

Yes, that also later allows us to add entries for things like say
livepatching. Or we peg the livepatching file to the livepatching
tag. Either way, one of the side goals of the split is to eventually
help scale maintenance.

  Luis
