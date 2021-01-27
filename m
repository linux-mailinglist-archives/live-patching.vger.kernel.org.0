Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C20F305C59
	for <lists+live-patching@lfdr.de>; Wed, 27 Jan 2021 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343711AbhA0NAa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Jan 2021 08:00:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:47894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237727AbhA0M7I (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Jan 2021 07:59:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611752302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rf92LTTFX4pVSu04S1qGCWjVx84cWC2RbUfV8aaylL0=;
        b=ovHxwd9vUh3DFC3tdSqrSvVBXGoeewXO7zvX/Z1ZxTpcJvFTsNg4CqY0jVrzLafIRI/IOr
        /SxIvVgLdXOEc8uCzSQppYSdFRTUf4Kin0frH1vG5ICidM8tHdpIzcCGyW77Eixiohw1qi
        X9IUpaB07dPxSu9FKXJguFEcDmxKr20=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ECBDEACBA;
        Wed, 27 Jan 2021 12:58:21 +0000 (UTC)
Date:   Wed, 27 Jan 2021 13:58:21 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 03/13] livepatch: refactor klp_init_object
Message-ID: <YBFjbbuQ7sn4T7yT@alley>
References: <20210121074959.313333-1-hch@lst.de>
 <20210121074959.313333-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121074959.313333-4-hch@lst.de>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-01-21 08:49:49, Christoph Hellwig wrote:
> Merge three calls to klp_is_module (including one hidden inside
> klp_find_object_module) into a single one to simplify the code a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  kernel/livepatch/core.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index f76fdb9255323d..a7f625dc24add3 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -54,9 +54,6 @@ static void klp_find_object_module(struct klp_object *obj)
>  {
>  	struct module *mod;
>  
> -	if (!klp_is_module(obj))
> -		return;
> -

We need to either update the function description or keep this check.

I prefer to keep the check. The function does the right thing also
for the object "vmlinux". Also the livepatch code includes many
similar paranoid checks that makes the code less error prone
against any further changes.

Of course, it is a matter of taste.

>  	mutex_lock(&module_mutex);
>  	/*
>  	 * We do not want to block removal of patched modules and therefore

Otherwise, the patch looks fine.

Best Regards,
Petr
