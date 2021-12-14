Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE586473ECE
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 09:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhLNIyp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 03:54:45 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53546 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhLNIyo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 03:54:44 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2CCAE1F3C5;
        Tue, 14 Dec 2021 08:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639472083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tOuVKsw6WN/ES5cvRcB8gKDwFK03CCX8tV7l0uWiVbQ=;
        b=fvz1g2sf4pf0M3XlJrzLhMkHwi8+RlV/C6fu/PNqvOruIpQ5z4tUuvYWITV84cXv8B8Bkh
        AfG6EroqXGuQDEbqLRY2/1j6kFZlMjFOyN3hubMdD81XL9QnR1zn4bo+B85Kfo5NCjcAUN
        nvNR+vTTHeY/FuiqyPR0pbF8omTIJyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639472083;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tOuVKsw6WN/ES5cvRcB8gKDwFK03CCX8tV7l0uWiVbQ=;
        b=Bn8GOU18ThWycw651O3AaGXTMZxTu6+X09MVBaYzzy227QASbp4hw+//dtmsWaN0+6iAwK
        EOhZzJH0JtsKQMCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0EE16A3B84;
        Tue, 14 Dec 2021 08:54:43 +0000 (UTC)
Date:   Tue, 14 Dec 2021 09:54:42 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     David Vernet <void@manifault.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] Documentation: livepatch: Add kernel-doc link to
 klp_enable_patch
In-Reply-To: <YbdvcXKtxvrVqN+2@alley>
Message-ID: <alpine.LSU.2.21.2112140952100.20187@pobox.suse.cz>
References: <20211209165303.3205464-1-void@manifault.com> <YbMc8YGIoyRU5nwJ@alley> <YbObeiWbLxO8MwrD@dev0025.ash9.facebook.com> <YbdvcXKtxvrVqN+2@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> From this POV, I suggest to create Documentation/livepatch/API.rst
> and add there the documentation generated from the sources. I mean
> something like:
> 
>     Documentation/core-api/kernel-api.rst
> 
> that results into
> 
> https://www.kernel.org/doc/html/latest/core-api/kernel-api.html
> 
> 
> The livepatch/API.rst might include documentation from
> 
>     include/linux/livepatch.h
>     kernel/livepatch/code.c
>     kernel/livepatch/shadow.c
>     kernel/livepatch/state.c
> 
> 
> But let's wait if there are other opinions from another livepatch
> developers.

Yes, please. Do not include anything generated from the source into our 
"hand-written" documentation. Or at least not like the proposed patch. It 
breaks it as Petr pointed out. A separate API file sounds better to me.

Regards
Miroslav
