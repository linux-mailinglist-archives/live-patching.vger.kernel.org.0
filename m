Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3B22FF791
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 22:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbhAUVr0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 16:47:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727336AbhAUVrP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 16:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611265546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+rDl9+7fXwTudocqpSNQ/uswuuzlXykto241XVMPhJI=;
        b=LY/Wg0807FU2U+wJ/ReQSo/Gfb8SR/zSXfgI11eSomBILlWaGEbA5daVCYneyAgOq7xGYj
        XAfXfHI7HQpIxhVmDoFGqWf60lcQPmFNbomz6k9e+JF2cdLvIqXT5aMdumKG2bT4pWS+Tp
        14gYkvivhXUjVQHIDdECkx1hHgjvoqo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-OKLBo_BNP5yCUTW080-5Wg-1; Thu, 21 Jan 2021 16:45:42 -0500
X-MC-Unique: OKLBo_BNP5yCUTW080-5Wg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E5AC802B40;
        Thu, 21 Jan 2021 21:45:39 +0000 (UTC)
Received: from treble (ovpn-116-102.rdu2.redhat.com [10.10.116.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EF795F9B5;
        Thu, 21 Jan 2021 21:45:31 +0000 (UTC)
Date:   Thu, 21 Jan 2021 15:45:29 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 04/13] livepatch: move klp_find_object_module to module.c
Message-ID: <20210121214529.il2ac3vk6oqogjpr@treble>
References: <20210121074959.313333-1-hch@lst.de>
 <20210121074959.313333-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210121074959.313333-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 21, 2021 at 08:49:50AM +0100, Christoph Hellwig wrote:
> @@ -820,14 +796,25 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>  	const char *name;
>  
>  	obj->patched = false;
> -	obj->mod = NULL;

Why was this line removed?

>  	if (klp_is_module(obj)) {
>  		if (strlen(obj->name) >= MODULE_NAME_LEN)
>  			return -EINVAL;
>  		name = obj->name;
>  
> -		klp_find_object_module(obj);
> +		/*
> +		 * We do not want to block removal of patched modules and
> +		 * therefore we do not take a reference here. The patches are
> +		 * removed by klp_module_going() instead.
> +		 * 
> +		 * Do not mess work of klp_module_coming() and
> +		 * klp_module_going().  Note that the patch might still be
> +		 * needed before klp_module_going() is called.  Module functions
> +		 * can be called even in the GOING state until mod->exit()
> +		 * finishes.  This is especially important for patches that
> +		 * modify semantic of the functions.
> +		 */
> +		obj->mod = find_klp_module(obj->name);

These comments don't make sense in this context, they should be kept
with the code in find_klp_module().

-- 
Josh

