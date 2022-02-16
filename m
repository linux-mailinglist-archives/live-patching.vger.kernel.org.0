Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2534B8E9E
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiBPQ4d (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:56:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbiBPQ4c (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:56:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19314294105
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645030579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YTqgL2GGRiZHrJiJS8+mQlW1sq4ttz1z3qBJQG2OejY=;
        b=VqnuOw04QR7xMl6xO70IOL3EuleKxnB++x3mAJMn8/1f5T1hbiLgJALrr+1B0PO48qY3Yv
        RSezL5x1wGknYIxygZeEjTYwlUMHzA5MNCN6C2UmiEBj5lcotEQgWI2nNVks0kCXaU2TNX
        RgS/oQr+1UG8H1z51NjvnQk4O1uzwP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-nDkGpOFbMa6vpwcU0hx26Q-1; Wed, 16 Feb 2022 11:56:16 -0500
X-MC-Unique: nDkGpOFbMa6vpwcU0hx26Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA23C2F25;
        Wed, 16 Feb 2022 16:56:14 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59F8278AA7;
        Wed, 16 Feb 2022 16:56:14 +0000 (UTC)
Date:   Wed, 16 Feb 2022 11:56:12 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 03/12] livepatch: Add klp-convert tool
Message-ID: <Yg0srL3wfFb3MuzQ@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-4-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-4-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 16, 2022 at 11:39:31AM -0500, Joe Lawrence wrote:
> diff --git a/include/uapi/linux/livepatch.h b/include/uapi/linux/livepatch.h
> index e19430918a07..2ee98e985c2a 100644
> --- a/include/uapi/linux/livepatch.h
> +++ b/include/uapi/linux/livepatch.h
> @@ -9,7 +9,17 @@
>  #ifndef _UAPI_LIVEPATCH_H
>  #define _UAPI_LIVEPATCH_H
>  
> +#include <linux/types.h>
> +
>  #define KLP_RELA_PREFIX		".klp.rela."
>  #define KLP_SYM_PREFIX		".klp.sym."
>  
> +struct klp_module_reloc {
> +	union {
> +		void *sym;
> +		__u64 sym64;	/* Force 64-bit width */
> +	};
> +	__u32 sympos;
> +} __packed;
> +
> 
> [ ... snip ... ]
> 
> diff --git a/scripts/livepatch/klp-convert.h b/scripts/livepatch/klp-convert.h
> new file mode 100644
> index 000000000000..35b9dc4e32c4
> --- /dev/null
> +++ b/scripts/livepatch/klp-convert.h
>
> [ ... snip ... ]
>
> +struct klp_module_reloc {
> +	union {
> +		void *sym;
> +		uint64_t sym64;	/* Force 64-bit width */
> +	};
> +	uint32_t sympos;
> +} __packed;

This was a hack I added to force a consistent width for the symbol
pointer in case the user was building for 32-bit.  The actual void
*sym64 value itself is not so interesting as it's only needed for the
compiler to create a relocation (later resolved by klp-convert).  That
said, sympos is used by klp-convert, and I bet it's not endian-safe
here.

Better suggestions welcome :)

-- Joe

