Return-Path: <live-patching+bounces-1911-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6543D3BAD1
	for <lists+live-patching@lfdr.de>; Mon, 19 Jan 2026 23:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E31F33017849
	for <lists+live-patching@lfdr.de>; Mon, 19 Jan 2026 22:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E9D30149F;
	Mon, 19 Jan 2026 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VDuOZABQ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11770301465
	for <live-patching@vger.kernel.org>; Mon, 19 Jan 2026 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768861349; cv=none; b=U2uSAAJERq98Qjmi661SVv/MaHQrzL5LWiHnS6kpYTRlZedgZPfY3GiASVVolu6PSaf5vLJilro+q4MaVvMYzTeKGbysoF/Q16Lx81e71Yyx5+sdR0uCEdoIgierF5FO4TEEthQymmpU1eacDuSebkUfoyPmqdC0DwrEk9J99p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768861349; c=relaxed/simple;
	bh=hy4h1TqAX7dLrgwUKHP5nRwPD21HASB/m6/Pk6UnhGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mk3OfGfoaA8Zd6nNmKzn+MtHk+aul8d732UXUP+WGgaUgC+pIWE9BKG6rUO7CTdi9vl3K3UOGaCXpD6V1rxcJeQtsP1oTHjltwv0Ad1SwAPUdDijYoqUlCzL7Uz9ZyRz04be3qL/LEbEUSA0DZGzP2b2P/Ey62g/p0SYYUP439g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VDuOZABQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768861347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gmxHJ9Xc5nZaYbeMmrQTyTRgzvL3Ri0Z9VJjgpIdX7g=;
	b=VDuOZABQsYN50menNZb7HLTZP2AEnGgiFs+4hriUVaXx6fZ2bIrZ7B1hrQfAW+n3VIN7B2
	BBvuP18ee4OFe5MkFKDE9SyeAluHf51t7mVyHfIWWmNMnFexO66SgJNDBaP2kGf5pFNvy7
	x/1nNMVVUoN/kMGcW0oqSTYQRNQm3gM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-3W-6gsTXPliVZxgjFAp-IQ-1; Mon,
 19 Jan 2026 17:22:23 -0500
X-MC-Unique: 3W-6gsTXPliVZxgjFAp-IQ-1
X-Mimecast-MFC-AGG-ID: 3W-6gsTXPliVZxgjFAp-IQ_1768861342
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBD731956050;
	Mon, 19 Jan 2026 22:22:21 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.98])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBD901800577;
	Mon, 19 Jan 2026 22:22:18 +0000 (UTC)
Date: Mon, 19 Jan 2026 17:22:16 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] livepatch: Free klp_{object,func}_ext data after
 initialization
Message-ID: <aW6umBkI2NhVyXYz@redhat.com>
References: <20260114123056.2045816-1-petr.pavlu@suse.com>
 <20260114123056.2045816-3-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114123056.2045816-3-petr.pavlu@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Jan 14, 2026 at 01:29:54PM +0100, Petr Pavlu wrote:
> The klp_object_ext and klp_func_ext data, which are stored in the
> __klp_objects and __klp_funcs sections, respectively, are not needed
> after they are used to create the actual klp_object and klp_func
> instances. This operation is implemented by the init function in
> scripts/livepatch/init.c.
> 
> Prefix the two sections with ".init" so they are freed after the module
> is initializated.
> 
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> ---
>  kernel/livepatch/core.c             |  3 ++-
>  scripts/module.lds.S                |  4 ++--
>  tools/objtool/check.c               |  2 +-
>  tools/objtool/include/objtool/klp.h | 10 +++++-----
>  tools/objtool/klp-diff.c            |  2 +-
>  5 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 4e0ac47b3623..3621a7c1b737 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1364,7 +1364,8 @@ struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
>  	for (int i = 1; i < info->hdr.e_shnum; i++) {
>  		Elf_Shdr *shdr = &info->sechdrs[i];
>  
> -		if (strcmp(info->secstrings + shdr->sh_name, "__klp_objects"))
> +		if (strcmp(info->secstrings + shdr->sh_name,
> +			   ".init.klp_objects"))
>  			continue;
>  
>  		*nr_objs = shdr->sh_size / sizeof(struct klp_object_ext);
> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
> index 383d19beffb4..054ef99e8288 100644
> --- a/scripts/module.lds.S
> +++ b/scripts/module.lds.S
> @@ -34,8 +34,8 @@ SECTIONS {
>  
>  	__patchable_function_entries : { *(__patchable_function_entries) }
>  
> -	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
> -	__klp_objects		0: ALIGN(8) { KEEP(*(__klp_objects)) }
> +	.init.klp_funcs		0 : ALIGN(8) { KEEP(*(.init.klp_funcs)) }
> +	.init.klp_objects	0 : ALIGN(8) { KEEP(*(.init.klp_objects)) }
>  
>  #ifdef CONFIG_ARCH_USES_CFI_TRAPS
>  	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 3f7999317f4d..933868ee3beb 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -4761,7 +4761,7 @@ static int validate_ibt(struct objtool_file *file)
>  		    !strcmp(sec->name, "__bug_table")			||
>  		    !strcmp(sec->name, "__ex_table")			||
>  		    !strcmp(sec->name, "__jump_table")			||
> -		    !strcmp(sec->name, "__klp_funcs")			||
> +		    !strcmp(sec->name, ".init.klp_funcs")		||
>  		    !strcmp(sec->name, "__mcount_loc")			||
>  		    !strcmp(sec->name, ".llvm.call-graph-profile")	||
>  		    !strcmp(sec->name, ".llvm_bb_addr_map")		||
> diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
> index ad830a7ce55b..e32e5e8bc631 100644
> --- a/tools/objtool/include/objtool/klp.h
> +++ b/tools/objtool/include/objtool/klp.h
> @@ -6,12 +6,12 @@
>  #define SHN_LIVEPATCH		0xff20
>  
>  /*
> - * __klp_objects and __klp_funcs are created by klp diff and used by the patch
> - * module init code to build the klp_patch, klp_object and klp_func structs
> - * needed by the livepatch API.
> + * .init.klp_objects and .init.klp_funcs are created by klp diff and used by the
> + * patch module init code to build the klp_patch, klp_object and klp_func
> + * structs needed by the livepatch API.
>   */
> -#define KLP_OBJECTS_SEC	"__klp_objects"
> -#define KLP_FUNCS_SEC	"__klp_funcs"
> +#define KLP_OBJECTS_SEC	".init.klp_objects"
> +#define KLP_FUNCS_SEC	".init.klp_funcs"
>  
>  /*
>   * __klp_relocs is an intermediate section which are created by klp diff and
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index 4d1f9e9977eb..fd64d5e3c3b6 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -1439,7 +1439,7 @@ static int clone_special_sections(struct elfs *e)
>  }
>  
>  /*
> - * Create __klp_objects and __klp_funcs sections which are intermediate
> + * Create .init.klp_objects and .init.klp_funcs sections which are intermediate
>   * sections provided as input to the patch module's init code for building the
>   * klp_patch, klp_object and klp_func structs for the livepatch API.
>   */
> -- 
> 2.52.0
> 

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe


