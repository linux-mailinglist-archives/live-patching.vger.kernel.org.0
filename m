Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276DD476E63
	for <lists+live-patching@lfdr.de>; Thu, 16 Dec 2021 10:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhLPJ5J (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Dec 2021 04:57:09 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:48664 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbhLPJ5G (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Dec 2021 04:57:06 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1F4391F3D5;
        Thu, 16 Dec 2021 09:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639648625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/qs9vdN+xRjPf2KjM847rLgFEPvaZLOMDkaNcOmQ168=;
        b=haZVP4CwUHJ6qfUYg0HrUuEPBdwSchA8MxUm6At5ZqNNeXFuxcmTm1dKf9fMOAjTK1n+xy
        yb3RVjJX0tR5iCchP78Zu0s/UmYUQtldRdK+ffJc+Ifq0v1UTsdQWX3L9rU/BjkQsZQfED
        y/t55etkmRccGf0VvRtpSkwQ5BWLxkI=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C15032C1D2;
        Thu, 16 Dec 2021 09:57:04 +0000 (UTC)
Date:   Thu, 16 Dec 2021 10:57:04 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v2] Documentation: livepatch: Add livepatch API page
Message-ID: <YbsNcAKzRCxGqXUA@alley>
References: <20211215174659.2332589-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215174659.2332589-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-12-15 09:47:00, David Vernet wrote:
> The livepatch subsystem has several exported functions and objects with
> kerneldoc comments. Though the livepatch documentation contains
> handwritten descriptions of all of these exported functions, they are
> currently not pulled into the docs build using the kernel-doc directive.
> 
> Note that all of the handwritten API descriptions were left alone with
> the exception of Documentation/livepatch/system-state.rst, which was
> updated to allow the cross-referencing to work correctly. The file now
> follows the cross-referencing formatting guidance specified in
> Documentation/doc-guide/kernel-doc.rst. Furthermore, some comments
> around klp_shadow_free_all() were updated to say <obj, id> rather than
> <*, id> to match the rest of the file, and to prevent the docs build
> from emitting an "Inline emphasis start-string without end string"
> error.
> 
> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -272,12 +272,12 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
>  EXPORT_SYMBOL_GPL(klp_shadow_free);
>  
>  /**
> - * klp_shadow_free_all() - detach and free all <*, id> shadow variables
> + * klp_shadow_free_all() - detach and free all <obj, id> shadow variables

This change is not good. The function releases all existing shadow
variables with the given @id for any @obj. And it is not longer clear.

I guess that the primary motivation was to remove  "Inline emphasis
start-string without end string" mentioned in the commit message.

A solution would be replace '*' with something else, for example, < , id>.
Another solution would be to describe it another way, for example:

 * klp_shadow_free_all() - detach and free all <obj, id> shadow variables
 *		with the given @id.

>   * @id:		data identifier
>   * @dtor:	custom callback that can be used to unregister the variable
>   *		and/or free data that the shadow variable points to (optional)
>   *
> - * This function releases the memory for all <*, id> shadow variable
> + * This function releases the memory for all <obj, id> shadow variable

Same here.

>   * instances, callers should stop referencing them accordingly.
>   */
>  void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
> @@ -288,7 +288,7 @@ void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
>  
>  	spin_lock_irqsave(&klp_shadow_lock, flags);
>  
> -	/* Delete all <*, id> from hash */
> +	/* Delete all <obj, id> from hash */

and here

>  	hash_for_each(klp_shadow_hash, i, shadow, node) {
>  		if (klp_shadow_match(shadow, shadow->obj, id))
>  			klp_shadow_free_struct(shadow, dtor);

BTW: There is likely the same problem in Documentation/livepatch/shadow-vars.rst.
     I see <*, id> there as well.


Otherwise, the patch looks fine to me.

Best Regards,
Petr
