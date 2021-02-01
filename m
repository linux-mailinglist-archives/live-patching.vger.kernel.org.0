Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9146D30A875
	for <lists+live-patching@lfdr.de>; Mon,  1 Feb 2021 14:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhBANRH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Feb 2021 08:17:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:39952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhBANQy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Feb 2021 08:16:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5380CAE9A;
        Mon,  1 Feb 2021 13:16:13 +0000 (UTC)
Date:   Mon, 1 Feb 2021 14:16:12 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jessica Yu <jeyu@kernel.org>
cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 04/13] module: use RCU to synchronize find_module
In-Reply-To: <YBfvvdna9pSeu+1g@gunter>
Message-ID: <alpine.LSU.2.21.2102011415290.21637@pobox.suse.cz>
References: <20210128181421.2279-1-hch@lst.de> <20210128181421.2279-5-hch@lst.de> <alpine.LSU.2.21.2101291626080.22237@pobox.suse.cz> <YBfvvdna9pSeu+1g@gunter>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 1 Feb 2021, Jessica Yu wrote:

> +++ Miroslav Benes [29/01/21 16:29 +0100]:
> >On Thu, 28 Jan 2021, Christoph Hellwig wrote:
> >
> >> Allow for a RCU-sched critical section around find_module, following
> >> the lower level find_module_all helper, and switch the two callers
> >> outside of module.c to use such a RCU-sched critical section instead
> >> of module_mutex.
> >
> >That's a nice idea.
> >
> >> @@ -57,7 +58,7 @@ static void klp_find_object_module(struct klp_object
> >> *obj)
> >>   if (!klp_is_module(obj))
> >>    return;
> >>
> >> -	mutex_lock(&module_mutex);
> >> +	rcu_read_lock_sched();
> >>   /*
> >>    * We do not want to block removal of patched modules and therefore
> >>    * we do not take a reference here. The patches are removed by
> >> @@ -74,7 +75,7 @@ static void klp_find_object_module(struct klp_object
> >> *obj)
> >>   if (mod && mod->klp_alive)
> >
> >RCU always baffles me a bit, so I'll ask. Don't we need
> >rcu_dereference_sched() here? "mod" comes from a RCU-protected list, so I
> >wonder.
> 
> Same here :-) I had to double check the RCU documentation. For our
> modules list case I believe the rcu list API should take care of that
> for us. Worth noting is this snippet from Documentation/RCU/whatisRCU.txt:
> 
>    rcu_dereference() is typically used indirectly, via the _rcu
>    list-manipulation primitives, such as list_for_each_entry_rcu()

Ok, thanks to both for checking and explanation.

Ack to the patch then.

Miroslav
