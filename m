Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40C630A8E4
	for <lists+live-patching@lfdr.de>; Mon,  1 Feb 2021 14:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhBANhz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Feb 2021 08:37:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:33488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhBANhy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Feb 2021 08:37:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA6FBABD5;
        Mon,  1 Feb 2021 13:37:12 +0000 (UTC)
Date:   Mon, 1 Feb 2021 14:37:12 +0100 (CET)
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
In-Reply-To: <20210201114749.GB19696@lst.de>
Message-ID: <alpine.LSU.2.21.2102011436320.21637@pobox.suse.cz>
References: <20210128181421.2279-1-hch@lst.de> <20210128181421.2279-6-hch@lst.de> <YBPYyEvesLMrRtZM@alley> <20210201114749.GB19696@lst.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 1 Feb 2021, Christoph Hellwig wrote:

> On Fri, Jan 29, 2021 at 10:43:36AM +0100, Petr Mladek wrote:
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -164,12 +164,8 @@ static int klp_find_object_symbol(const char *objname, const char *name,
> > >  		.pos = sympos,
> > >  	};
> > >  
> > > -	mutex_lock(&module_mutex);
> > > -	if (objname)
> > > +	if (objname || !kallsyms_on_each_symbol(klp_find_callback, &args))
> > >  		module_kallsyms_on_each_symbol(klp_find_callback, &args);
> > > -	else
> > > -		kallsyms_on_each_symbol(klp_find_callback, &args);
> > > -	mutex_unlock(&module_mutex);
> > 
> > This change is not needed. (objname == NULL) means that we are
> > interested only in symbols in "vmlinux".
> > 
> > module_kallsyms_on_each_symbol(klp_find_callback, &args)
> > will always fail when objname == NULL.
> 
> I just tried to keep the old behavior.  I can respin it with your
> recommended change noting the change in behavior, though.

Yes, please. It would be cleaner that way.

Miroslav
