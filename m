Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84284EA3E
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2019 16:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfFUOJR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 Jun 2019 10:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUOJR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 Jun 2019 10:09:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E2717EBBD;
        Fri, 21 Jun 2019 14:09:16 +0000 (UTC)
Received: from redhat.com (ovpn-121-168.rdu2.redhat.com [10.10.121.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E30560572;
        Fri, 21 Jun 2019 14:09:14 +0000 (UTC)
Date:   Fri, 21 Jun 2019 10:09:11 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] livepatch: Allow to distinguish different version of
 system state changes
Message-ID: <20190621140911.GC20356@redhat.com>
References: <20190611135627.15556-1-pmladek@suse.com>
 <20190611135627.15556-4-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611135627.15556-4-pmladek@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 21 Jun 2019 14:09:16 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 03:56:25PM +0200, Petr Mladek wrote:
> The atomic replace runs pre/post (un)install callbacks only from the new
> livepatch. There are several reasons for this:
> 
>   + Simplicity: clear ordering of operations, no interactions between
> 	old and new callbacks.
> 
>   + Reliability: only new livepatch knows what changes can already be made
> 	by older livepatches and how to take over the state.
> 
>   + Testing: the atomic replace can be properly tested only when a newer
> 	livepatch is available. It might be too late to fix unwanted effect
> 	of callbacks from older	livepatches.
> 
> It might happen that an older change is not enough and the same system
> state has to be modified another way. Different changes need to get
> distinguished by a version number added to struct klp_state.
> 
> The version can also be used to prevent loading incompatible livepatches.
> The check is done when the livepatch is enabled. The rules are:
> 
>   + Any completely new system state modification is allowed.
> 
>   + System state modifications with the same or higher version are allowed
>     for already modified system states.
> 

More word play: would it be any clearer to drop the use of
"modification" when talking about klp_states?  Sometimes I read
modification to mean a change to a klp_state itself rather than the
system at large.

In my mind, "modification" is implied, but I already know where this
patchset is going, so perhaps I'm just trying to be lazy and not type
the whole thing out :)  I wish I could come up with a nice, succinct
alternative, but "state" or "klp_state" would work for me.  /two cents

>   + Cumulative livepatches must handle all system state modifications from
>     already installed livepatches.
> 
>   + Non-cumulative livepatches are allowed to touch already modified
>     system states.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/livepatch.h |  2 ++
>  kernel/livepatch/core.c   |  8 ++++++++
>  kernel/livepatch/state.c  | 40 +++++++++++++++++++++++++++++++++++++++-
>  kernel/livepatch/state.h  |  9 +++++++++
>  4 files changed, 58 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/livepatch/state.h
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 591abdee30d7..8bc4c6cc3f3f 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -135,10 +135,12 @@ struct klp_object {
>  /**
>   * struct klp_state - state of the system modified by the livepatch
>   * @id:		system state identifier (non zero)
> + * @version:	version of the change (non-zero)
>   * @data:	custom data
>   */
>  struct klp_state {
>  	int id;
> +	int version;
>  	void *data;
>  };
>  
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 24c4a13bd26c..614642719825 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -21,6 +21,7 @@
>  #include <asm/cacheflush.h>
>  #include "core.h"
>  #include "patch.h"
> +#include "state.h"
>  #include "transition.h"
>  
>  /*
> @@ -1003,6 +1004,13 @@ int klp_enable_patch(struct klp_patch *patch)
>  
>  	mutex_lock(&klp_mutex);
>  
> +	if(!klp_is_patch_compatible(patch)) {
> +		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
> +			patch->mod->name);
> +		mutex_unlock(&klp_mutex);
> +		return -EINVAL;
> +	}
> +
>  	ret = klp_init_patch_early(patch);
>  	if (ret) {
>  		mutex_unlock(&klp_mutex);
> diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> index f8822b71f96e..b54a69b9e4b4 100644
> --- a/kernel/livepatch/state.c
> +++ b/kernel/livepatch/state.c
> @@ -12,7 +12,9 @@
>  #include "transition.h"
>  
>  #define klp_for_each_state(patch, state)		\
> -	for (state = patch->states; state && state->id; state++)
> +	for (state = patch->states;			\
> +	     state && state->id && state->version;	\
> +	     state++)

Minor git bookkeeping here, but this could be moved to the patch that
introduced the macro.

>  
>  /**
>   * klp_get_state() - get information about system state modified by
> @@ -81,3 +83,39 @@ struct klp_state *klp_get_prev_state(int id)
>  	return last_state;
>  }
>  EXPORT_SYMBOL_GPL(klp_get_prev_state);
> +
> +/* Check if the patch is able to deal with the given system state. */
> +static bool klp_is_state_compatible(struct klp_patch *patch,
> +				    struct klp_state *state)
> +{
> +	struct klp_state *new_state;
> +
> +	new_state = klp_get_state(patch, state->id);
> +
> +	if (new_state)
> +		return new_state->version < state->version ? false : true;
> +
> +	/* Cumulative livepatch must handle all already modified states. */
> +	return patch->replace ? false : true;
> +}
> +
> +/*
> + * Check if the new livepatch will not break the existing system states.

suggestion: "Check that the new livepatch will not break" or
            "Check if the new livepatch will break"

-- Joe
