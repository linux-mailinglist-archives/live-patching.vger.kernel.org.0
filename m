Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298FD11424
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 09:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEBHaq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 03:30:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:47774 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfEBHaq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 03:30:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36A83ADDA;
        Thu,  2 May 2019 07:30:45 +0000 (UTC)
Date:   Thu, 2 May 2019 09:30:44 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] livepatch: Do not manually track kobject
 initialization
Message-ID: <20190502073044.bfzugymrncnaajxe@pathway.suse.cz>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-6-tobin@kernel.org>
 <20190502071232.GB16247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502071232.GB16247@kroah.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-05-02 09:12:32, Greg Kroah-Hartman wrote:
> On Thu, May 02, 2019 at 12:31:42PM +1000, Tobin C. Harding wrote:
> > Currently we use custom logic to track kobject initialization.  Recently
> > a predicate function was added to the kobject API so we now no longer
> > need to do this.
> > 
> > Use kobject API to check for initialized state of kobjects instead of
> > using custom logic to track state.
> > 
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  include/linux/livepatch.h |  6 ------
> >  kernel/livepatch/core.c   | 18 +++++-------------
> >  2 files changed, 5 insertions(+), 19 deletions(-)
> > 
> > @@ -626,7 +626,7 @@ static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
> >  		list_del(&obj->node);
> >  
> >  		/* Might be called from klp_init_patch() error path. */
> > -		if (obj->kobj_added) {
> > +		if (kobject_is_initialized(&obj->kobj)) {
> >  			kobject_put(&obj->kobj);
> >  		} else if (obj->dynamic) {
> >  			klp_free_object_dynamic(obj);
> 
> Same here, let's not be lazy.
> 
> The code should "know" if the kobject has been initialized or not
> because it is the entity that asked for it to be initialized.  Don't add
> extra logic to the kobject core (like the patch before this did) just
> because this one subsystem wanted to only write 1 "cleanup" function.

We use kobject for a mix of statically and dynamically defined
structures[*]. And we misunderstood the behavior of kobject_init().

Anyway, the right solution is to call kobject_init()
already in klp_init_patch_early() for the statically
defined structures and in klp_alloc*() for the dynamically
allocated ones. Then we could simply call kobject_put()
every time.

Tobin, this goes deeper into the livepatching code that
you probably expected. Do you want to do the above
suggested change or should I prepare the patch?

Anyway, thanks for working on this.


[*] Yes, we know that kobject was not designed for
    static structures. We even tried to use them but
    there was a lot of extra code with not a big benefit.

Best Regards,
Petr
