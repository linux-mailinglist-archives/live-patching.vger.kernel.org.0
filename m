Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7D508DD
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2019 12:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfFXK0K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Jun 2019 06:26:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:42386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727101AbfFXK0K (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Jun 2019 06:26:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE358AC98;
        Mon, 24 Jun 2019 10:26:08 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] livepatch: Allow to distinguish different version of system state changes
References: <20190611135627.15556-1-pmladek@suse.com>
        <20190611135627.15556-4-pmladek@suse.com>
Date:   Mon, 24 Jun 2019 12:26:07 +0200
In-Reply-To: <20190611135627.15556-4-pmladek@suse.com> (Petr Mladek's message
        of "Tue, 11 Jun 2019 15:56:25 +0200")
Message-ID: <87o92n2sao.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> writes:

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


Just as a remark: klp_reverse_transition() could still transition back
to a !klp_is_patch_compatible() patch.

I don't think it's much of a problem, because for live patches
introducing completely new states to the system, it is reasonable
to assume that they'll start applying incompatible changes only from
their ->post_patch(), I guess.

For state "upgrades" to higher versions, it's not so clear though and
some care will be needed. But I think these could still be handled
safely at the cost of some complexity in the new live patch's
->post_patch().

Another detail is that ->post_unpatch() will be called for the new live
patch which has been unpatched due to transition reversal and one would
have to be careful not to free shared state from under the older, still
active live patch. How would ->post_unpatch() distinguish between
transition reversal and "normal" live patch disabling?  By
klp_get_prev_state() != NULL?

Perhaps transition reversal should be mentioned in the documentation?

Thanks,

Nicolai


-- 
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB
21284 (AG Nürnberg)
