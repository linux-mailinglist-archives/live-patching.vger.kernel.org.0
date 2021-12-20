Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306AD47A88D
	for <lists+live-patching@lfdr.de>; Mon, 20 Dec 2021 12:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhLTLYM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Dec 2021 06:24:12 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54714 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhLTLYM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Dec 2021 06:24:12 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9AAA41F395;
        Mon, 20 Dec 2021 11:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639999450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wlTVl9ZK/wksVMHatLR7d5Sc5OZUko+D/2yNlrYuunk=;
        b=WaPu+At9ZWDOgKK98/GxzQujaBbjzeQHm5ukEoTqa3FeB+5IbkkVae0HoWIO04tvUtKJcW
        Uvy/VghxmMiPgtjaNAkvlmt+n/obUgC3H9q+ij2DNHybpv8ymvmvglbrO5FJwYNTGWz7eo
        0CvZdsPt1vdlj8xl7aCYsNez02WWJuo=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6C688A3B81;
        Mon, 20 Dec 2021 11:24:10 +0000 (UTC)
Date:   Mon, 20 Dec 2021 12:24:10 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v2] Documentation: livepatch: Add livepatch API page
Message-ID: <YcBn2mk2hUp4Zt0s@alley>
References: <20211215174659.2332589-1-void@manifault.com>
 <YbsNcAKzRCxGqXUA@alley>
 <YbtUlkaWSQf4yCIb@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbtUlkaWSQf4yCIb@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-12-16 07:00:38, David Vernet wrote:
> Petr Mladek <pmladek@suse.com> wrote on Thu [2021-Dec-16 10:57:04 +0100]:
> 
> > This change is not good. The function releases all existing shadow
> > variables with the given @id for any @obj. And it is not longer clear.
> 
> > A solution would be replace '*' with something else, for example, < , id>.
> 
> I think this is better than just obj, but in my opinion this may be confusing
> for readers and look like a typo. I think I prefer your second suggestion,
> though obj really makes more sense in the case where we're actually passing an
> @obj to the function. I'll probably (deservedly?) get lambasted for suggesting
> this, but what about taking a page out of rust's book and doing something like
> this:
> 
>   * klp_shadow_free_all() - detach and free all <_, id> shadow variables
>   *		with the given @id.
> 
> to indicate that in this case we don't care about the obj. Even for a reader
> unfamiliar with rust, hopefully it would get the point across.

<_, id> looks good to me. And I not even familiar with rust ;-)

Best Regards,
Petr
