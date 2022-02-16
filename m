Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090534B8EDC
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 18:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiBPRMc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 12:12:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiBPRMb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 12:12:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50D0BE7AD0
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 09:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645031537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=trNnuhj3H8o+H+1AZglqTOecwQUhO1rBcjpEVqGZc1Q=;
        b=ZigsbOORPoXW6CxIIU2slLv5nXWrKckkTZen80qp0Enckcy+sWnYaLxS704zFG/k4mjnAg
        7xmgZ7Avg3/+k4mYj3VADfxELp4x7prZIzpJj23vFrwhNrQ6DoO2m6SISVsVJb/cE9wWDU
        tXZqIlwP7AKt3YfP+MuuOQ8PbXX6uPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-YwLc1HjRME2tzsKEzIe1tg-1; Wed, 16 Feb 2022 12:12:16 -0500
X-MC-Unique: YwLc1HjRME2tzsKEzIe1tg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C873B80D680;
        Wed, 16 Feb 2022 17:12:14 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40FBB62D58;
        Wed, 16 Feb 2022 17:12:14 +0000 (UTC)
Date:   Wed, 16 Feb 2022 12:12:12 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 11/12] livepatch/selftests: add data relocations
 test
Message-ID: <Yg0wbJNYeFIwaisP@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-12-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-12-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 16, 2022 at 11:39:39AM -0500, Joe Lawrence wrote:
> 
> [ ... snip ... ]
> 
> diff --git a/lib/livepatch/test_klp_convert_data.c b/lib/livepatch/test_klp_convert_data.c
> new file mode 100644
> index 000000000000..142422664159
> --- /dev/null
> +++ b/lib/livepatch/test_klp_convert_data.c
> @@ -0,0 +1,190 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2021 Joe Lawrence <joe.lawrence@redhat.com>
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/cache.h>
> +#include <linux/livepatch.h>
> +#include "test_klp_convert.h"
> +
> +/* Small global */
> +int *p_global_small = &global_small;
> +
> +/* Small global (const) */
> +// .rela.data.rel.ro, .rela.rodata supported ???:
> +int * const p_const_global_small = &const_global_small;
> +
> +/* Small file-static */
> +static int *p_static_small = &static_small;
> +
> +/* Small file-static (constant) */
> +static int * const p_static_const_small = &static_const_small;
> +
> +/* Large global */
> +int *p_global_large[4] = {
> +	&global_large[0], &global_large[1],
> +	&global_large[2], &global_large[3],
> +};
> +
> +/* Large global (const) */
> +// .rela.data.rel.ro, .rela.rodata supported ???:
> +int * const p_const_global_large[4] = {
> +	&const_global_large[0], &const_global_large[1],
> +	&const_global_large[2], &const_global_large[3],
> +};
> +
> +/* Large file-static global */
> +static int *p_static_large[4] = {
> +	&static_large[0], &static_large[1],
> +	&static_large[2], &static_large[3],
> +};
> +
> +/* Large file-static (const) */
> +static int * const p_static_const_large[4] = {
> +	&static_const_large[0], &static_const_large[1],
> +	&static_const_large[2], &static_const_large[3],
> +};
> +
> +// .rela.data.rel.ro, .rela.rodata supported ???:
> +static int * __ro_after_init p_static_ro_after_init = &static_ro_after_init;
> +static int * __read_mostly p_static_read_mostly = &static_read_mostly;

This started getting a bit repetitive, and maybe belongs to its own set
of klp-convert unit tests (as the selftests seem closer to integration
type tests).

Anyway, I left in the .rela.<read-only> type relocations as mentioned in
the [RFC PATCH v6 03/12] livepatch: Add klp-convert tool [1].  We can
talk about whether such sections should be supported over there.

As for this test, it currently crashes ppc64le as it generates a late
klp-relocation type R_PPC64_ADDR64 in a section that was marked RO.
(IIRC such ppc64le data relocations to other .rela.<text> sections are
safe as they aren't marked RO.)

[1] https://lore.kernel.org/lkml/Yg0qgtSFNQx5Mo1i@redhat.com/

-- Joe

