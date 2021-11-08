Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE45449B0B
	for <lists+live-patching@lfdr.de>; Mon,  8 Nov 2021 18:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhKHRt2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Nov 2021 12:49:28 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:38210 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbhKHRtR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Nov 2021 12:49:17 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 92FC721B08;
        Mon,  8 Nov 2021 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636393591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u3cuC5W6r7T0d4b7+cnExC9SjUJDZn0OsHXsjZK83V8=;
        b=GccMNX5idlvXmBBSP0JUUUIntu5WsL+D1Ab38f0oh9IGixM9XsA9AuqaZnMNKmJ8ekKSuS
        mMN8JD/gugReA5nZgEPxhmVzI0UMvp2ppNVo8tPzV+9tYpuke2sVwtaBRv/cHB0CFUP0kZ
        tYp2JylCB8gSE7hlpdsDEybVGk3TwuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636393591;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u3cuC5W6r7T0d4b7+cnExC9SjUJDZn0OsHXsjZK83V8=;
        b=WBiZLBDLJzNrT/xJlthj+i69Z5dalFFaUgpV5F+degdFhYTjRLw9MUVjTeVI93bk8BMhng
        G3EUW+wJQpWdnnCw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 78111A3B85;
        Mon,  8 Nov 2021 17:46:31 +0000 (UTC)
Date:   Mon, 8 Nov 2021 18:46:31 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Ming Lei <ming.lei@redhat.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH V4 1/3] livepatch: remove 'struct completion finish' from
 klp_patch
In-Reply-To: <20211102145932.3623108-2-ming.lei@redhat.com>
Message-ID: <alpine.LSU.2.21.2111081845150.1710@pobox.suse.cz>
References: <20211102145932.3623108-1-ming.lei@redhat.com> <20211102145932.3623108-2-ming.lei@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2 Nov 2021, Ming Lei wrote:

> The completion finish is just for waiting release of the klp_patch
> object, then releases module refcnt. We can simply drop the module
> refcnt in the kobject release handler of klp_patch.
> 
> This way also helps to support allocating klp_patch from heap.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/livepatch.h |  1 -
>  kernel/livepatch/core.c   | 12 +++---------
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 2614247a9781..9712818997c5 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -170,7 +170,6 @@ struct klp_patch {
>  	bool enabled;
>  	bool forced;
>  	struct work_struct free_work;
> -	struct completion finish;
>  };
>  
>  #define klp_for_each_object_static(patch, obj) \

Petr pointed out the main problem. I'll just add that if it comes to it, 
you could also remove the inclusion of completion.h header file and a 
description of finish struct member.

Miroslav
