Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B275883B0
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 23:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiHBVh0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Aug 2022 17:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiHBVhY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Aug 2022 17:37:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 096C21011
        for <live-patching@vger.kernel.org>; Tue,  2 Aug 2022 14:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659476243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L++OmXb05hgY48nbfQ+76BYj3PkGGpS0TQ0LdKlUC0o=;
        b=FX9vnN7oZtp0Lbsfrgl1ApX2j8ThHmkJ6C7eNt7+NmaWs37lgsX+JHiJPyp7hQ6gTuJtIX
        2n0YyeshIt5gFB05DGdx0YySsqS6EMXSjWMNfXg/ESAT1yHaiDmw9r5vWb2Uxr4X5aodH6
        zOJtx1ebEdWI4M46+YfCIHzwXxSCYAM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-Hy_pe2msOXCJUpFnEz5Jpw-1; Tue, 02 Aug 2022 17:37:19 -0400
X-MC-Unique: Hy_pe2msOXCJUpFnEz5Jpw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 308C33C021B1;
        Tue,  2 Aug 2022 21:37:19 +0000 (UTC)
Received: from redhat.com (unknown [10.22.18.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C13CB1121314;
        Tue,  2 Aug 2022 21:37:18 +0000 (UTC)
Date:   Tue, 2 Aug 2022 17:37:17 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 0/2] add sysfs entry "patched" for each klp_object
Message-ID: <YumZDXVy+739tnps@redhat.com>
References: <20220802010857.3574103-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802010857.3574103-1-song@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 01, 2022 at 06:08:55PM -0700, Song Liu wrote:
> I was debugging an issue that a livepatch appears to be attached, but
> actually not. It turns out that there is a mismatch in module name
> (abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.
> 
> Changes v1 => v2:
> 1. Add selftest. (Petr Mladek)
> 2. Update documentation. (Petr Mladek)
> 3. Use sysfs_emit. (Petr Mladek)
> 
> Song Liu (2):
>   livepatch: add sysfs entry "patched" for each klp_object
>   selftests/livepatch: add sysfs test
> 
>  .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
>  kernel/livepatch/core.c                       | 18 +++++++++
>  tools/testing/selftests/livepatch/Makefile    |  3 +-
>  .../testing/selftests/livepatch/test-sysfs.sh | 40 +++++++++++++++++++
>  4 files changed, 68 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/livepatch/test-sysfs.sh
> 
> --
> 2.30.2
> 

For both,

Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe

