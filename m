Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F044B8EF2
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 18:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiBPRRc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 12:17:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiBPRRb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 12:17:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAC0CBDE55
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 09:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645031838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l01JrVUK+HQMzPZaZaQKrewFXcNhBlKnH3eIP6lTZ6M=;
        b=HzkbdFNq9xEGL8s6Ahn7fmsVxKlCyNk4H1CpzFK7KTLUlvb4wL95o03t2POc0GDg6x9JXn
        EBMlW9tNtk8oOq0IfbhY+XYxLSlHbclGiToGeJssdMmmRSj6bXHKPY1/OO/R8vC4Sq4qUn
        Yg6Go0V+Euutz+mNdD4NmFDvdoMLr/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-V3mfLI-2OVabCLHLrxjONg-1; Wed, 16 Feb 2022 12:17:17 -0500
X-MC-Unique: V3mfLI-2OVabCLHLrxjONg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D3DC8143E5;
        Wed, 16 Feb 2022 17:17:16 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B15E8753ED;
        Wed, 16 Feb 2022 17:17:15 +0000 (UTC)
Date:   Wed, 16 Feb 2022 12:17:13 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 00/12] livepatch: klp-convert tool
Message-ID: <Yg0xmWaBDNVmCB3b@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
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

On Wed, Feb 16, 2022 at 11:39:28AM -0500, Joe Lawrence wrote:
> 
> [ ... snip ... ]
> 
>  lib/livepatch/Makefile                        |  12 +
>  lib/livepatch/test_klp_convert.h              |  45 +
>  lib/livepatch/test_klp_convert1.c             | 121 +++
>  lib/livepatch/test_klp_convert2.c             | 110 +++
>  lib/livepatch/test_klp_convert_data.c         | 190 ++++
>  lib/livepatch/test_klp_convert_keys.c         |  91 ++
>  lib/livepatch/test_klp_convert_keys_mod.c     |  52 +
>  lib/livepatch/test_klp_convert_mod_a.c        |  31 +
>  lib/livepatch/test_klp_convert_mod_b.c        |  19 +
>  lib/livepatch/test_klp_convert_mod_c.c        |  36 +
>  lib/livepatch/test_klp_convert_sections.c     | 120 +++

A general (selftests) question: is there any build mechanism in the
kernel tree that is used to *expect* build failure?

Under certain circumstances, we would need klp-convert to fail and it
would be helpful to test for that.  At the moment I am considered out of
tree tests that could exercise the code this way, but definitely prefer
anything that is already in-tree.

Thanks,

-- Joe

