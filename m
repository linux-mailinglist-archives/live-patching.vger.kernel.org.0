Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66B21140B
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 09:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfEBHUn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 03:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfEBHUm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 03:20:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C42B42085A;
        Thu,  2 May 2019 07:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556781642;
        bh=te5YZ9pgHy4DysziYxkjR/+fn1pI3veiDyNTL/2vZi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdTC2KkClxrM+vE6JNfDpr8tPJ6inUwaz0EyJLGzdshYmqxgFXS3beEfJJWzYf7l/
         xQC+n/6ly0AlBEiibJ3R0Ta4doPwfc6sELgfAnOlZ09nuUNWzGt92mcbhcow5LuYqm
         rRTnRIGSDhqzY5YNvm5ChcAOkfNbmNDKyyezMcpU=
Date:   Thu, 2 May 2019 09:20:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] kobject: Remove docstring reference to kset
Message-ID: <20190502072039.GF16247@kroah.com>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-3-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502023142.20139-3-tobin@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 02, 2019 at 12:31:39PM +1000, Tobin C. Harding wrote:
> Currently the docstring for kobject_get_path() mentions 'kset'.  The
> kset is not used in the function callchain starting from this function.
> 
> Remove docstring reference to kset from the function kobject_get_path().
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  lib/kobject.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index aa89edcd2b63..3eacd5b4643f 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -153,12 +153,11 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
>  }
>  
>  /**
> - * kobject_get_path - generate and return the path associated with a given kobj and kset pair.
> - *
> + * kobject_get_path() - Allocate memory and fill in the path for @kobj.

Wow, that's an old change that caused this to be not true anymore, nice catch.

greg k-h
