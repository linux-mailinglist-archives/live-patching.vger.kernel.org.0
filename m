Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3868130A6CF
	for <lists+live-patching@lfdr.de>; Mon,  1 Feb 2021 12:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhBALrg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Feb 2021 06:47:36 -0500
Received: from verein.lst.de ([213.95.11.211]:40808 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhBALre (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Feb 2021 06:47:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 56C7C6736F; Mon,  1 Feb 2021 12:46:49 +0100 (CET)
Date:   Mon, 1 Feb 2021 12:46:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 04/13] module: use RCU to synchronize find_module
Message-ID: <20210201114649.GA19696@lst.de>
References: <20210128181421.2279-1-hch@lst.de> <20210128181421.2279-5-hch@lst.de> <alpine.LSU.2.21.2101291626080.22237@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2101291626080.22237@pobox.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 29, 2021 at 04:29:02PM +0100, Miroslav Benes wrote:
> >  
> > -	mutex_lock(&module_mutex);
> > +	rcu_read_lock_sched();
> >  	/*
> >  	 * We do not want to block removal of patched modules and therefore
> >  	 * we do not take a reference here. The patches are removed by
> > @@ -74,7 +75,7 @@ static void klp_find_object_module(struct klp_object *obj)
> >  	if (mod && mod->klp_alive)
> 
> RCU always baffles me a bit, so I'll ask. Don't we need 
> rcu_dereference_sched() here? "mod" comes from a RCU-protected list, so I 
> wonder.

rcu_dereference* is only used for dereferencing points where that
reference itself is RCU protected, that is the lookup of mod itself down
in find_module_all in this case.
