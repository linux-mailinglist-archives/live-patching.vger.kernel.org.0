Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A258473138
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 17:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhLMQGO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 11:06:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:37000 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhLMQGO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 11:06:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8C8401F3B9;
        Mon, 13 Dec 2021 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639411572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FF6LuBspdsWCO4qGNpCYC3fUaZAeoqbzPnQ9aad9DtY=;
        b=NO6CGs7rJtym1/r7x7ynSwGNQ5iKyKtebbSllG6bWHjPLRlxxiZRypCWtQBflenNHDSlcb
        vZwW9S1+OicB5ARAhezARsw2m48WY2uChpa9P3uDg23wcc7M672wdV5yPRtRia5PP+qgUZ
        6h8kJIJ9G7gCTrhaGv3Nx2rdLxDl7iM=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5D4F1A3B87;
        Mon, 13 Dec 2021 16:06:12 +0000 (UTC)
Date:   Mon, 13 Dec 2021 17:06:09 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] Documentation: livepatch: Add kernel-doc link to
 klp_enable_patch
Message-ID: <YbdvcXKtxvrVqN+2@alley>
References: <20211209165303.3205464-1-void@manifault.com>
 <YbMc8YGIoyRU5nwJ@alley>
 <YbObeiWbLxO8MwrD@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbObeiWbLxO8MwrD@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-12-10 10:24:58, David Vernet wrote:
> Petr Mladek <pmladek@suse.com> wrote on Fri [2021-Dec-10 10:25:05 +0100]:
> > 
> > Honestly, I do not like this. It might be acceptable when it converts
> > klp_enable_patch() into a link pointing to another page describing the API.
> > 
> > But this patch causes the entire documentation of klp_enable_patch()
> > inserted into livepatch.html. It does not fit there and breaks
> > the text flow.
> 
> Thank you for taking a look at the patch, Petr.
> 
> I'm happy to revise the patch to instead add a new `api.rst` file that
> contains the `kernel-doc` directive, which would cause `klp_enable_patch()`
> in `livepatch.rst` to automatically link to the separate page as you
> suggested.
> 
> Just to check though -- I see that `shadow-vars.rst` and `system-state.rst`
> have their own "API" sections.

Good point. Well, even these file do not point to the documentation
generated from the sources.


> Is it preferable to add such a section directly to `livepatch.rst`,
> rather than creating a separate file?

Good question. I am not expert on writing documentation and I can't
find any good example of API documentation at
https://www.kernel.org/doc/html/latest/index.html

One reason might be that most of the documentation was written as plain text
in the past. And many people still read it in the original .rst form.

Another problem is that livepatch documentation is a mix of several
independent pieces written by different authors. It would deserve
a lot of work:

    + Connect the pieces
    + Add missing information
    + Make the style and structure consistent


Anyway, I think that the documentation generated from the sources
is useful. But it is hard to integrate it into .rst file that should
be useful even in the .rst format.

From this POV, I suggest to create Documentation/livepatch/API.rst
and add there the documentation generated from the sources. I mean
something like:

    Documentation/core-api/kernel-api.rst

that results into

https://www.kernel.org/doc/html/latest/core-api/kernel-api.html


The livepatch/API.rst might include documentation from

    include/linux/livepatch.h
    kernel/livepatch/code.c
    kernel/livepatch/shadow.c
    kernel/livepatch/state.c


But let's wait if there are other opinions from another livepatch
developers.

Best Regards,
Petr
