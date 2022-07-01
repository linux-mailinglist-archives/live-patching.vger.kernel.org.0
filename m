Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55CB563B9E
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 23:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiGAVE1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 17:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiGAVE0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 17:04:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D97F433BC
        for <live-patching@vger.kernel.org>; Fri,  1 Jul 2022 14:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656709463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B/9bc6Rh6ZGgA6+mhBSi9K39ZJmE1ZKcEyZ9Ez2Kdo0=;
        b=aSGDz2/Dwos2pdvSMZ0hkBSZgqj2Prwm6PAVmtWoTNIyC1tMLLP6nc6x9g6D/q6mIlZZ9F
        DdSypsvxPT7in4LLQSQgQCxOcndqYp4mlyZ5GPqc+V+F7DISXEwRrJ0sIfD/zzckX2pLfH
        v6nVMpeoluB/aTA3fwber3zPs1pS2m4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-VOadAnRUP3W8qO0rgkn2fQ-1; Fri, 01 Jul 2022 17:04:22 -0400
X-MC-Unique: VOadAnRUP3W8qO0rgkn2fQ-1
Received: by mail-qt1-f198.google.com with SMTP id a7-20020ac84347000000b00319bb5d130eso1116999qtn.14
        for <live-patching@vger.kernel.org>; Fri, 01 Jul 2022 14:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B/9bc6Rh6ZGgA6+mhBSi9K39ZJmE1ZKcEyZ9Ez2Kdo0=;
        b=c440dweTYBsgWWmcuthf9jXYeQ5/A82etdmVQW5ZnNHaPwTIXSP20+8G58Q8CI6OUb
         7FSy/R9h/8pmeCK/SR5C9YdJqAvEGw1eK9fp0SUPLbsFgfrNbxmrMB2gf5Vkg5Z5djsQ
         40tomiw/ebUfuTSwkUaywRjLXG1hGb13FDxstBUAxdLCPhgZYIaeJYKIshRwmFzCc5SU
         GAwAkBjjYaiMwx8z1UQn8XS8hxKNRSTjgah0AuVdlj/028vYWEXod5AQ2Wp4Ce/qIaT9
         GXVOdYofsLovfWAVMRQgPqvM91xSiEwJMiWJIw5zneppOIcihgbXhBcQ3FU3DL9/LaIw
         BnDQ==
X-Gm-Message-State: AJIora8zbHbSfi4wCoSl8uO/ARG/SOz8rXEQC/Y1zYHd+9vCdKOJIEEz
        3yqbDaT8jb+uOhsfUFwsJ9WMe2isDgQUFn6EzfP1DjccZOKOYoAjK5XVoIQ344+BF03u1qeosCb
        66KdSVl2sk13JdpkqKl/mhoI+Vg==
X-Received: by 2002:a05:6214:1c07:b0:472:cf58:8efe with SMTP id u7-20020a0562141c0700b00472cf588efemr3557522qvc.124.1656709461909;
        Fri, 01 Jul 2022 14:04:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vPA2du4EGR56Tzlg9krqARQEunJbHoMnMrsdDPokHrj7JaoaXmPyxLWxiyYYzvdxn+bCWX8A==
X-Received: by 2002:a05:6214:1c07:b0:472:cf58:8efe with SMTP id u7-20020a0562141c0700b00472cf588efemr3557498qvc.124.1656709461640;
        Fri, 01 Jul 2022 14:04:21 -0700 (PDT)
Received: from treble ([162.251.124.25])
        by smtp.gmail.com with ESMTPSA id h16-20020a05620a401000b006a6a7b4e7besm20604102qko.109.2022.07.01.14.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:04:21 -0700 (PDT)
Date:   Fri, 1 Jul 2022 14:04:17 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     live-patching@vger.kernel.org, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de
Subject: Re: [PATCH 3/4] livepatch/shadow: Introduce klp_shadow_type structure
Message-ID: <20220701210417.zdaa5r3heztnia5p@treble>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-4-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220701194817.24655-4-mpdesouza@suse.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 01, 2022 at 04:48:16PM -0300, Marcos Paulo de Souza wrote:
> The shadow variable type will be used in klp_shadow_alloc/get/free
> functions instead of id/ctor/dtor parameters. As a result, all callers
> use the same callbacks consistently[*][**].
> 
> The structure will be used in the next patch that will manage the
> lifetime of shadow variables and execute garbage collection automatically.
> 
> [*] From the user POV, it might have been easier to pass $id instead
>     of pointer to struct klp_shadow_type.
> 
>     The problem is that each livepatch registers its own struct
>     klp_shadow_type and defines its own @ctor/@dtor callbacks. It would
>     be unclear what callback should be used. They should be compatible.
> 
>     This problem is gone when each livepatch explicitly uses its
>     own struct klp_shadow_type pointing to its own callbacks.
> 
> [**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
>     The message must be disabled when called via klp_shadow_free_all()
>     because the ordering of freed variables is not well defined there.
>     It has to be done using another hack after switching to
>     klp_shadow_types.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Invalid SOB chain, see

  Documentation/process/submitting-patches.rst

-- 
Josh

