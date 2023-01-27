Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB167E701
	for <lists+live-patching@lfdr.de>; Fri, 27 Jan 2023 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjA0Nqm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Jan 2023 08:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjA0Nqm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Jan 2023 08:46:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FCD45228
        for <live-patching@vger.kernel.org>; Fri, 27 Jan 2023 05:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674827154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZL6syL4gm2H3QLJOVyJqOMOKMhyc7AUkpoBTr0bkmxU=;
        b=jPjru0AuDgcvefTlzoTEv1oykrOnFqTPTu4u2G/Z0JOgmCn4j4Lk2mQIG30q9CquvXwq2B
        kNh9AdJVDl0VxRuK2YH0Eji0zpqfbQvz0zVmJchoefIf2QkvCUcCovRXXh1nslT/S/aiec
        oyP9RWNoIK7UGyf2xS3wc+T2C7ob510=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-I19kgIIjOTS9LbaUZ_z72g-1; Fri, 27 Jan 2023 08:45:50 -0500
X-MC-Unique: I19kgIIjOTS9LbaUZ_z72g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F4C31818E52;
        Fri, 27 Jan 2023 13:45:49 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FEB72166B29;
        Fri, 27 Jan 2023 13:45:49 +0000 (UTC)
Date:   Fri, 27 Jan 2023 08:45:47 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v11 1/2] x86/module: remove unused code in
 __apply_relocate_add
Message-ID: <Y9PVi7WoaBu8KdR2@redhat.com>
References: <20230125185401.279042-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125185401.279042-1-song@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 10:54:00AM -0800, Song Liu wrote:
> This "#if 0" block has been untouched for many years. Remove it to clean
> up the code.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Song Liu <song@kernel.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> ---
>  arch/x86/kernel/module.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index 705fb2a41d7d..1dee3ad82da2 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -188,10 +188,6 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>  				goto invalid_relocation;
>  			val -= (u64)loc;
>  			write(loc, &val, 4);
> -#if 0
> -			if ((s64)val != *(s32 *)loc)
> -				goto overflow;
> -#endif
>  			break;
>  		case R_X86_64_PC64:
>  			if (*(u64 *)loc != 0)
> -- 
> 2.30.2
> 

Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe

