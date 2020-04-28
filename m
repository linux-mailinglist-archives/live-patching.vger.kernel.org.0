Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477801BB9AF
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2020 11:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgD1JUP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Apr 2020 05:20:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:60752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbgD1JUP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Apr 2020 05:20:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D8703ACCC;
        Tue, 28 Apr 2020 09:20:12 +0000 (UTC)
Date:   Tue, 28 Apr 2020 11:20:13 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v3 02/10] livepatch: Apply vmlinux-specific KLP relocations
 early
In-Reply-To: <8c9f86b3a44bdcc9b350e41301df7f61c7587cf6.1587812518.git.jpoimboe@redhat.com>
Message-ID: <alpine.LSU.2.21.2004281118160.27039@pobox.suse.cz>
References: <cover.1587812518.git.jpoimboe@redhat.com> <8c9f86b3a44bdcc9b350e41301df7f61c7587cf6.1587812518.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> @@ -738,18 +765,23 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>  	int ret;
>  
>  	mutex_lock(&text_mutex);
> -
>  	module_disable_ro(patch->mod);
> -	ret = klp_write_object_relocations(patch->mod, obj);
> -	if (ret) {
> -		module_enable_ro(patch->mod, true);
> -		mutex_unlock(&text_mutex);
> -		return ret;
> +
> +	if (klp_is_module(obj)) {
> +		/*
> +		 * Only write module-specific relocations here
> +		 * (.klp.rela.{module}.*).  vmlinux-specific relocations were
> +		 * written earlier during the initialization of the klp module
> +		 * itself.
> +		 */
> +		ret = klp_apply_object_relocs(patch, obj);
> +		if (ret)

+                       module_enable_ro(patch->mod, true);
+                       mutex_unlock(&text_mutex);

is missing here, I think. Probably lost during rebase. It is fine after 
the next patch.

> +			return ret;
>  	}
>  
>  	arch_klp_init_object_loaded(patch, obj);
> -	module_enable_ro(patch->mod, true);
>  
> +	module_enable_ro(patch->mod, true);
>  	mutex_unlock(&text_mutex);

Miroslav
