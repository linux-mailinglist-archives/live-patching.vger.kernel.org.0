Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46006CD74
	for <lists+live-patching@lfdr.de>; Thu, 18 Jul 2019 13:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfGRLiD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Jul 2019 07:38:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:56014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfGRLiD (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Jul 2019 07:38:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69640AC1C;
        Thu, 18 Jul 2019 11:38:01 +0000 (UTC)
Date:   Thu, 18 Jul 2019 13:38:01 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] livepatch: Allow to distinguish different version of
 system state changes
Message-ID: <20190718113801.bol75rgt26d72goy@pathway.suse.cz>
References: <20190611135627.15556-1-pmladek@suse.com>
 <20190611135627.15556-4-pmladek@suse.com>
 <87o92n2sao.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o92n2sao.fsf@suse.de>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

first, I am sorry that I answer this non-trivial mail so late.
I know that it might be hard to remember the context.


On Mon 2019-06-24 12:26:07, Nicolai Stange wrote:
> Petr Mladek <pmladek@suse.com> writes:
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 24c4a13bd26c..614642719825 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -1003,6 +1004,13 @@ int klp_enable_patch(struct klp_patch *patch)
> >  
> >  	mutex_lock(&klp_mutex);
> >  
> > +	if(!klp_is_patch_compatible(patch)) {
> > +		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
> > +			patch->mod->name);
> > +		mutex_unlock(&klp_mutex);
> > +		return -EINVAL;
> > +	}
> > +
> >  	ret = klp_init_patch_early(patch);
> >  	if (ret) {
> >  		mutex_unlock(&klp_mutex);
> 
> 
> Just as a remark: klp_reverse_transition() could still transition back
> to a !klp_is_patch_compatible() patch.

I am slightly confused. The new livepatch is enabled only when the new
states have the same or higher version. And only callbacks from
the new livepatch are used, including post_unpatch() when
the transition gets reverted.

The "compatible" livepatch should be able to handle all situations:

    + Modify the system state when it was not modified before.

    + Take over the system state when it has already been modified
      by the previous livepatch.

    + Restore the previous state when the transition is reverted.


> I don't think it's much of a problem, because for live patches
> introducing completely new states to the system, it is reasonable
> to assume that they'll start applying incompatible changes only from
> their ->post_patch(), I guess.
>
> For state "upgrades" to higher versions, it's not so clear though and
> some care will be needed. But I think these could still be handled
> safely at the cost of some complexity in the new live patch's
> ->post_patch().

Just to be sure. The post_unpatch() from the new livepatch
will get called when the transitions is reverted. It should
be able to revert any changes made by its own pre_patch().

You are right that it will need some care. Especially because
the transition revert is not easy to test.

I think that this is the main reason why Joe would like
to introduce the sticky flag. It might be used to block
the transition revert and livepatch disabling when it would
be to complicated, error-prone, or even impossible.


> Another detail is that ->post_unpatch() will be called for the new live
> patch which has been unpatched due to transition reversal and one would
> have to be careful not to free shared state from under the older, still
> active live patch. How would ->post_unpatch() distinguish between
> transition reversal and "normal" live patch disabling?  By
> klp_get_prev_state() != NULL?

Exactly. klp_get_prev_state() != NULL can be used in the
post_unpatch() to restore the original state when
the transition gets reverted.

See restore_console_loglevel() in lib/livepatch/test_klp_state2.c

> Perhaps transition reversal should be mentioned in the documentation?

Good point. I'll mention it in the documentation.

Best Regards,
Petr
