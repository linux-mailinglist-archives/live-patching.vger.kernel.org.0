Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75C94A8D0B
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 21:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbiBCUNK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 15:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiBCUNJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 15:13:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CE9C061714;
        Thu,  3 Feb 2022 12:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=zrlsKSvDlqkhl69/Mpn0jJR0z+cbYI9W7FprFtEpGGc=; b=kL3crxm5l0SknssmbrloA8jsDt
        pStbC3k9ceYt6yFQwT3mcuBGeA/hz/UaedGJwCfGhceookBToUa8LlDm7sCbHnhEWcQcKov2dJDih
        5G+i4z0DEqsvl7sVmlY7rxoIGSneCcyyWAGI6QTUJAYi8NjE3aw9sM71wszbArOuzFUqTNgbC7m3u
        z8ouSmeNbYMmU4wKusPcOPF9P5XfZwx7nw9HldGqbMXvXMhfSC5t8CywuiipRcyDIy02iHEClKlEe
        EILcq75xKUwYtMFPrXQzo65Dgo16KTxVXKLaPYjjb+CT/H6rZVHVi2Dzr82b6gY4a/txPpBYRiUOj
        fnA84AkQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFiTX-002hGw-M5; Thu, 03 Feb 2022 20:13:03 +0000
Date:   Thu, 3 Feb 2022 12:13:03 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>, cl@linux.com,
        pmladek@suse.com, mbenes@suse.cz, akpm@linux-foundation.org,
        jeyu@kernel.org, linux-kernel@vger.kernel.org,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, allen.lkml@gmail.com,
        void@manifault.com, joe@perches.com
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <Yfw3T22UyE2oyTuY@bombadil.infradead.org>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
 <20220203194317.GC3113@kunlun.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220203194317.GC3113@kunlun.suse.cz>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Feb 03, 2022 at 08:43:17PM +0100, Michal Suchánek wrote:
> Hello,
> 
> On Wed, Feb 02, 2022 at 04:20:41PM -0800, Luis Chamberlain wrote:
> > On Sun, Jan 30, 2022 at 09:32:01PM +0000, Aaron Tomlin wrote:
> > > Hi Luis,
> > > 
> > > As per your suggestion [1], this is an attempt to refactor and split
> > > optional code out of core module support code into separate components.
> > > This version is based on branch mcgrof/modules-next since a97ac8cb24a3/or
> > > modules-5.17-rc1. Please let me know your thoughts.
> > > 
> > > Changes since v1 [2]:
> > 
> > Thanks for all this work Aaron! Can you drop the RFC prefix,
> > rebase onto linus' latest tree (as he already merged my
> > modules-next, so his tree is more up to date), and submit again?
> > 
> > I'll then apply this to my modules-next, and then ask Christophe to
> > rebase on top of that.
> > 
> > Michal, you'd be up next if you want to go through modules-next.
> 
> Sounds like a good idea. When rebasing on top of 5.17-rc1 the only
> conflict was on the module code.

I'll let you know once modules-next is ready for your code. But before
that, does anyone have any objections with this code going through
modules-next? Although its kexec related it touches on a lot of
kernel/module.c and if we don't take it on modules-next I'm afraid
there will be quite a bit of conflicts there later.

  Luis
