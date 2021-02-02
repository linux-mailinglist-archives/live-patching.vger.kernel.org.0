Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BFD30C8B7
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 18:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhBBR6E (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 12:58:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:43122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233952AbhBBOIf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 09:08:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 50039B0C6;
        Tue,  2 Feb 2021 14:07:52 +0000 (UTC)
Date:   Tue, 2 Feb 2021 15:07:51 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 10/13] module: pass struct find_symbol_args to
 find_symbol
In-Reply-To: <20210202121334.1361503-11-hch@lst.de>
Message-ID: <alpine.LSU.2.21.2102021504550.570@pobox.suse.cz>
References: <20210202121334.1361503-1-hch@lst.de> <20210202121334.1361503-11-hch@lst.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

>  void *__symbol_get(const char *symbol)
>  {
> -	struct module *owner;
> -	const struct kernel_symbol *sym;
> +	struct find_symbol_arg fsa = {
> +		.name	= symbol,
> +		.gplok	= true,
> +		.warn	= true,
> +	};
>  
>  	preempt_disable();
> -	sym = find_symbol(symbol, &owner, NULL, NULL, true, true);
> -	if (sym && strong_try_module_get(owner))
> -		sym = NULL;
> +	if (!find_symbol(&fsa) || !strong_try_module_get(fsa.owner)) {

I think this should be in fact

  if (!find_symbol(&fsa) || strong_try_module_get(fsa.owner)) {

to get the logic right (note the missing !). We want to return NULL if 
strong_try_module_get() does not succeed for a found symbol.

> +		preempt_enable();
> +		return NULL;
> +	}
>  	preempt_enable();
> -
> -	return sym ? (void *)kernel_symbol_value(sym) : NULL;
> +	return (void *)kernel_symbol_value(fsa.sym);
>  }
>  EXPORT_SYMBOL_GPL(__symbol_get);

Miroslav
