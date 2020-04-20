Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1E1B13B4
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2020 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgDTR6G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Apr 2020 13:58:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48301 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726748AbgDTR6F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Apr 2020 13:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587405484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=37Z6hANsBQ4dsxMNn94eIgKjUPnUG7LLhH5O/teSf/E=;
        b=jCD4Q3cZdKXpRGlEQr6R9iiSjuY0g7HC8uvGJRovevwDPupy+ezIgi0gNgiRoIUaRzU6Up
        IpMQjRgqEAJ8922lYK9EfkNhn68oSc/M/CsKMpaeNTivignAdZUBNouB4D6oQxVNT4piJU
        4rdk+lkDD58ksm5MjtlSWpW5Lp7txmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-Kfi4jOZsMey4R9IIxSsqFw-1; Mon, 20 Apr 2020 13:58:02 -0400
X-MC-Unique: Kfi4jOZsMey4R9IIxSsqFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F66F1085982;
        Mon, 20 Apr 2020 17:57:54 +0000 (UTC)
Received: from redhat.com (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C0D976E71;
        Mon, 20 Apr 2020 17:57:53 +0000 (UTC)
Date:   Mon, 20 Apr 2020 13:57:51 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v2 2/9] livepatch: Apply vmlinux-specific KLP relocations
 early
Message-ID: <20200420175751.GA13807@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83eb0be61671eab05e2d7bcd0aa848f6e20087b0.1587131959.git.jpoimboe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 17, 2020 at 09:04:27AM -0500, Josh Poimboeuf wrote:
> 
> [ ... snip ... ]
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 40cfac8156fd..5fda3afc0285 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> 
> [ ... snip ... ]
> 
> +int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> +			  const char *shstrtab, const char *strtab,
> +			  unsigned int symndx, struct module *pmod,
> +			  const char *objname)
>  {
>  	int i, cnt, ret = 0;
> -	const char *objname, *secname;
>  	char sec_objname[MODULE_NAME_LEN];
>  	Elf_Shdr *sec;
>  
> -	if (WARN_ON(!klp_is_object_loaded(obj)))
> -		return -EINVAL;
> -
> -	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> -
>  	/* For each klp relocation section */
> -	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> -		sec = pmod->klp_info->sechdrs + i;
> -		secname = pmod->klp_info->secstrings + sec->sh_name;
> +	for (i = 1; i < ehdr->e_shnum; i++) {
> +		sec = sechdrs + i;

Hi Josh, minor bug:

Note the for loop through the section headers in
klp_write_relocations(), but its calling function ...

> [ ... snip ... ]
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 646f1e2330d2..d36ea8a8c3ec 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2334,11 +2334,12 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
> -		/* Livepatch relocation sections are applied by livepatch */
>  		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> -			continue;
> -
> -		if (info->sechdrs[i].sh_type == SHT_REL)
> +			err = klp_write_relocations(info->hdr, info->sechdrs,
> +						    info->secstrings,
> +						    info->strtab,
> +						    info->index.sym, mod, NULL);
> +		else if (info->sechdrs[i].sh_type == SHT_REL)
>  			err = apply_relocate(info->sechdrs, info->strtab,
>  					     info->index.sym, i, mod);
>  		else if (info->sechdrs[i].sh_type == SHT_RELA)

... apply_relocations() is also iterating over the section headers (the
diff context doesn't show it here, but i is an incrementing index over
sechdrs[]).

So if there is more than one KLP relocation section, we'll process them
multiple times.  At least the x86 relocation code will detect this and
fail the module load with an invalid relocation (existing value not
zero).

-- Joe

