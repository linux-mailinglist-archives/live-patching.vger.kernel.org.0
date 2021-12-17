Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9E8478CD5
	for <lists+live-patching@lfdr.de>; Fri, 17 Dec 2021 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhLQNxu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Dec 2021 08:53:50 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60444 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhLQNxu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Dec 2021 08:53:50 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5256C1F38E;
        Fri, 17 Dec 2021 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639749229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0CcG6BQv75lCkRJLlbFilpoVUlToHcP+R3qfFgZRh2A=;
        b=Y8LxUiAOWhhavFYPwneJLDxSYrR5g5fbWBaSt9lj7ZuUgZeGUxyWqBPe/Q3QdxmF774GcG
        y2pWqQxLJvPQwAiCQNH2XHxeHpuHBwajQhl+thhHM5a8B+hUkSP1Zuosf3Ol3FQFoedtxn
        g+frlAHzcN0teSzkoGvZTkgk167bLHA=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2F96FA3B8B;
        Fri, 17 Dec 2021 13:53:49 +0000 (UTC)
Date:   Fri, 17 Dec 2021 14:53:48 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miroslav Benes <mbenes@suse.cz>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbyWbNmK6rvYVzXp@alley>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
 <YbmlL0ZyfSuek9OB@alley>
 <YboLPAmOc8/6khu2@kroah.com>
 <YbtJzonSJjcUaUwh@alley>
 <YbtX088SeDWaEih1@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbtX088SeDWaEih1@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-12-16 07:14:27, David Vernet wrote:
> Petr Mladek <pmladek@suse.com> wrote on Thu [2021-Dec-16 15:14:38 +0100]:
> > > Now it does.  In the past, I think we did create some memory.  I know
> > > when we hook debugobjects up to kobjects (there's an external patch for
> > > that floating around somewhere), that is one reason to keep the
> > > kobject_put() rule, and there might have been other reasons in the past
> > > 20+ years as well.
> > > 
> > > So yes, while you are correct today, the "normal" reference counted
> > > object model patern is "after the object is initialized, it MUST only be
> > > freed by handling its reference count."  So let's stick to that rule for
> > > now.
> > 
> > Good point.
> 
> Thanks for the discussion all. I think we've landed on the fact that this
> is a refcounting bug that needs to be fixed, but isn't a leak in how the
> kobject implementation exists today.
> 
> Petr - are you OK with me sending out a v3 of the patch with the following
> changes:
>   - The patch description is updated to not claim that a leak is being
>     fixed, but rather that a kobject reference counting bug is being fixed.
>   - All of the NULL checking in klp_init_patch_early() is brought into
>     klp_enable_patch(), and klp_init_patch_early() is updated to be void,
>     per Josh's suggestion. This would address the refcounting issue and IMO
>     also simplifies and improves the code. I know you were onboard with
>     moving try_module_get() into klp_enable_patch(), but I don't think we
>     ever resolved the point about moving the rest of the NULL checking out
>     as well.

Just for record. I have answered this in the other thread where it was
discussed, see https://lore.kernel.org/r/YbyV7nsLXbQ6/44S@alley

Best Regards,
Petr
