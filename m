Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928D94B8E6C
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiBPQrT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:47:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbiBPQrS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D30F1A82C
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645030025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36+amQYpsAR2WASYmM8zsPn0dtpM2TBA20M2ylDK/kc=;
        b=XNdpmwo2WfcCOsfPqz+TbcwLpvI5J4QDOcDPllXza7B4dZfrBdGQlvcNmIYh0gr7V4YUQ5
        7souzZl14Y/jdZud5Dg5AlsA+D4DPEhT3kLQAZYaLc+Qe1bF78sdEKdXks7fOcs/IDo3A4
        1uQnjvH0zIoLH/n2YXyNLWyw/iekEzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-3ZVEvefnPn6mbvDvK6KLGA-1; Wed, 16 Feb 2022 11:47:01 -0500
X-MC-Unique: 3ZVEvefnPn6mbvDvK6KLGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD62A2F44;
        Wed, 16 Feb 2022 16:47:00 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B6DA753DA;
        Wed, 16 Feb 2022 16:47:00 +0000 (UTC)
Date:   Wed, 16 Feb 2022 11:46:58 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 03/12] livepatch: Add klp-convert tool
Message-ID: <Yg0qgtSFNQx5Mo1i@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-4-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-4-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
> 
>  [ ... snip ... ]
> 
> +/*
> + * Checks if rela conversion is supported in given section
> + */
> +static bool supported_section(struct section *sec, char *object_name)
> +{
> +#if 0
> +	/*
> +	 * klp-relocations forbidden in sections that otherwise would
> +	 * match in allowed_prefixes[]
> +	 */
> +	static const char * const not_allowed[] = {
> +		".rela.data.rel.ro",
> +		".rela.data.rel.ro.local",
> +		".rela.data..ro_after_init",
> +		NULL
> +	};
> +#endif
> +
> +	/* klp-relocations allowed in sections only for vmlinux */
> +	static const char * const allowed_vmlinux[] = {
> +		".rela__jump_table",
> +		NULL
> +	};
> +
> +	/* klp-relocations allowed in sections with prefixes */
> +	static const char * const allowed_prefixes[] = {
> +		".rela.data",
> +		".rela.rodata",	// supported ???
> +		".rela.sdata",
> +		".rela.text",
> +		".rela.toc",
> +		NULL
> +	};
> +
> +	const char * const *name;
> +
> +#if 0
> +	for (name = not_allowed; *name; name++)
> +		if (strcmp(sec->name, *name) == 0)
> +			return false;
> +#endif

I wasn't sure if relocations in .rela.<read-only> sections should be
supported or not, particularly in the late relocation use case.  For
most, I think they can be easily avoided by the livepatch author
changing the storage class for the C pointer that is relocated.  On the
other hand, this may be disruptive to automated tools like
kpatch-build... or maybe there is no issue at all for late relocating
.rela.<read-only>?

-- Joe

