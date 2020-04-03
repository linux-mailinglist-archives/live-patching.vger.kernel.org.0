Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4119DD38
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2020 19:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403945AbgDCRyh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Apr 2020 13:54:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28581 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727167AbgDCRyh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Apr 2020 13:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585936476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m/sN5U1KWfQeBEyLLOyOkjJBPzSeLq7M2YpI/ghADG0=;
        b=bKOxEux0FxZSXV+nz/8NsTZHs9Uxu2fT13vJ3j+sqlqBXLnhl4zDp78BtygKc5PKbptIJH
        BBrR8x0XwzKsXzHb9eoEEc9d4Pwg1xTreBHEUdjfC1tiAe9C9N9HAzEca7p56eunzOB2Y2
        AT68IodKYREFW6HWUhXy7DyyQjtXvIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-dYKjhh3uNNiiE1b8mvym5A-1; Fri, 03 Apr 2020 13:54:32 -0400
X-MC-Unique: dYKjhh3uNNiiE1b8mvym5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C834D1005F6D;
        Fri,  3 Apr 2020 17:54:30 +0000 (UTC)
Received: from redhat.com (ovpn-114-27.phx2.redhat.com [10.3.114.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E15D360BF3;
        Fri,  3 Apr 2020 17:54:29 +0000 (UTC)
Date:   Fri, 3 Apr 2020 13:54:28 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 04/23] livepatch: Prevent loading livepatch sub-module
 unintentionally.
Message-ID: <20200403175428.GA30284@redhat.com>
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-5-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117150323.21801-5-pmladek@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 17, 2020 at 04:03:04PM +0100, Petr Mladek wrote:
> Livepatch is split into several modules. The main module is for livepatching
> vmlinux. The rest is for livepatching other modules.
> 
> Only the livepatch module for vmlinux can be loaded by users. Others are
> loaded automatically when the related module is or gets loaded.
> 
> Users might try to load any livepatch module. It must be allowed
> only when the related livepatch module for vmlinux and the livepatched
> module are loaded.
> 
> Also it is important to check that obj->name is listed in patch->obj_names.
> Otherwise this module would not be loaded automatically. And it would
> lead into inconsistent behavier. Anyway, the missing name means a mistake
> somewhere and must be reported.
> 
> klp_add_object() is taking over the job done by klp_module_coming().
> The error message is taken from there so that selftests do not need
> to get updated.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  kernel/livepatch/core.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index ec7ffc7db3a7..e2c7dc6c2d5f 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> 
> [ ... snip ... ]
> 
>  int klp_add_object(struct klp_object *obj)
>  {
> +	struct klp_patch *patch;
>  	int ret;
>  
>  	ret = klp_check_object(obj, true);
>  	if (ret)
>  		return ret;
>  
> +	mutex_lock(&klp_mutex);
> +
> +	patch = klp_find_patch(obj->patch_name);
> +	if (!patch) {
> +		pr_err("Can't load livepatch (%s) for module when the livepatch (%s) for vmcore is not loaded\n",
> +		       obj->mod->name, obj->patch_name);

nit: s/vmcore/vmlinux in the error message?

> +		ret = -EINVAL;
> +		goto err;

Minor code snafu: !patch for this exit path means ...

> +	}
> +
> +	if (!klp_is_object_compatible(patch, obj)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	mutex_unlock(&klp_mutex);
>  	return 0;
> +
> +err:
> +	/*
> +	 * If a patch is unsuccessfully applied, return
> +	 * error to the module loader.
> +	 */
> +	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
> +		patch->obj->patch_name, obj->name, obj->name);

... we can't access patch->obj->patch_name here.

-- Joe

