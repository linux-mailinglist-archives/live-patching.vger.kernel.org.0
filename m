Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B971B67E709
	for <lists+live-patching@lfdr.de>; Fri, 27 Jan 2023 14:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjA0NtE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Jan 2023 08:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbjA0NtD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Jan 2023 08:49:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAB41420D
        for <live-patching@vger.kernel.org>; Fri, 27 Jan 2023 05:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674827292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kw/UexsSySmCBQfo+jBXXjDxKL8QdcF+X/4S+iGj/Pc=;
        b=W2WmomO6w8/n8QCQEb5ppjaGqDrwwWDfFQnzWUF7pqbMfPtC4oZ+p2cI+asFAXV8WHHfJ2
        c5F3kfBCwfv4AHM+Xou7okC5kKvbUknnZHi2Apb8tXsEytJl+ZXfC4SuSUP6m33Gt5PbEV
        eyNYBhMyG/KaBqOeewrsbeD8Zy/h7mQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-4jfb2mIeMtO6M4x2NXRfrg-1; Fri, 27 Jan 2023 08:48:09 -0500
X-MC-Unique: 4jfb2mIeMtO6M4x2NXRfrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B97D585A588;
        Fri, 27 Jan 2023 13:48:08 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BFD640C141B;
        Fri, 27 Jan 2023 13:48:07 +0000 (UTC)
Date:   Fri, 27 Jan 2023 08:48:06 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 0/2] powerpc: Fix livepatch module re-patching issue
Message-ID: <Y9PWFp29nAdtdPqp@redhat.com>
References: <cover.1674617130.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1674617130.git.jpoimboe@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 24, 2023 at 07:38:03PM -0800, Josh Poimboeuf wrote:
> Fix a livepatch bug seen when reloading a patched module.
> 
> This is the powerpc counterpart to Song Liu's fix for a similar issue on
> x86:
> 
>   https://lkml.kernel.org/lkml/20230121004945.697003-2-song@kernel.org
> 
> Josh Poimboeuf (2):
>   powerpc/module_64: Improve restore_r2() return semantics
>   powerpc/module_64: Fix "expected nop" error on module re-patching
> 
>  arch/powerpc/kernel/module_64.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> -- 
> 2.39.0
> 

For the series,

Reviewed-and-tested-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe

