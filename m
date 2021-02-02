Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8532C30BC52
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 11:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhBBKqb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 05:46:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:33980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhBBKqa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 05:46:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 27FC9AE8D;
        Tue,  2 Feb 2021 10:45:48 +0000 (UTC)
Date:   Tue, 2 Feb 2021 11:45:47 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
cc:     Petr Mladek <pmladek@suse.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 05/13] kallsyms: refactor
 {,module_}kallsyms_on_each_symbol
In-Reply-To: <20210201162842.GB7276@lst.de>
Message-ID: <alpine.LSU.2.21.2102021145160.570@pobox.suse.cz>
References: <20210128181421.2279-1-hch@lst.de> <20210128181421.2279-6-hch@lst.de> <YBPYyEvesLMrRtZM@alley> <20210201114749.GB19696@lst.de> <alpine.LSU.2.21.2102011436320.21637@pobox.suse.cz> <20210201162842.GB7276@lst.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 1 Feb 2021, Christoph Hellwig wrote:

> On Mon, Feb 01, 2021 at 02:37:12PM +0100, Miroslav Benes wrote:
> > > > This change is not needed. (objname == NULL) means that we are
> > > > interested only in symbols in "vmlinux".
> > > > 
> > > > module_kallsyms_on_each_symbol(klp_find_callback, &args)
> > > > will always fail when objname == NULL.
> > > 
> > > I just tried to keep the old behavior.  I can respin it with your
> > > recommended change noting the change in behavior, though.
> > 
> > Yes, please. It would be cleaner that way.
> 
> Let me know if this works for you:
> 
> ---
> >From 18af41e88d088cfb8680d1669fcae2bc2ede5328 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 20 Jan 2021 16:23:16 +0100
> Subject: kallsyms: refactor {,module_}kallsyms_on_each_symbol
> 
> Require an explicit call to module_kallsyms_on_each_symbol to look
> for symbols in modules instead of the call from kallsyms_on_each_symbol,
> and acquire module_mutex inside of module_kallsyms_on_each_symbol instead
> of leaving that up to the caller.  Note that this slightly changes the
> behavior for the livepatch code in that the symbols from vmlinux are not
> iterated anymore if objname is set, but that actually is the desired
> behavior in this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Miroslav Benes <mbenes@suse.cz>

Thanks Christoph

M
