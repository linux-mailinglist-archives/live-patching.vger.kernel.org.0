Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6A563B7D
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 23:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiGAVBy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 17:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiGAVBx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 17:01:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 714F06B264
        for <live-patching@vger.kernel.org>; Fri,  1 Jul 2022 14:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656709311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWS3iKCOODVJzZhTrsjiDauwqc/b5M/Jyx7jN5NzBsA=;
        b=bMAU9uV2hKL7hpNmWJL5zgd6nYjVsf8+DK2Nv8mEoEZ82B4r3ysWFXOwpVBKeWSj86dvEs
        fc7zAusvcavorDC21mngn/eJ84YAnpbTgs09OUyxIlIX5r//kWiQfO7an2c3MSqocQks7e
        oZKYupLif+ny3lTvtiipAQSVU/APWm0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-mH4aE-NiOOCmi6Pnq535Mw-1; Fri, 01 Jul 2022 17:01:50 -0400
X-MC-Unique: mH4aE-NiOOCmi6Pnq535Mw-1
Received: by mail-qt1-f198.google.com with SMTP id n18-20020ac81e12000000b00318b16f53e0so1100075qtl.5
        for <live-patching@vger.kernel.org>; Fri, 01 Jul 2022 14:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oWS3iKCOODVJzZhTrsjiDauwqc/b5M/Jyx7jN5NzBsA=;
        b=0/21R2roV+FeHuSd2UeJnMmx4xKty1D/H5V7ZGm2ihNrAZjWbVsLDc6VtMQV3SgwKN
         pO32TCHJFtwlveUN7aWUbwGuDb9o17CKIufKojliM1cL5byPzAWVoqheLQm0VdP4mDkJ
         i6C4mP4V1FACRUwfEZIJH9cfHODgFKOowST2L/vGWswjiYl5MmSQphoKNIFLCGnZxhhm
         Gy3weduhh45m6rNwebRD7ahsJItUeZ4sfKqL/61e6CPaGfg0Gepj9Rk853nsZoQsAeUG
         /gCLvTj5x3hborIUeDkZfHkcf/pdWmWbDJqHlcK2Vu6U1n9P/Q9WDMx1tfeTEp42A4ba
         dEtQ==
X-Gm-Message-State: AJIora+M3YxAt1nfVNJmeQKMdKVcZ71zLCgmd9kMoSSLgf6Xn8hmH0rv
        awecJuhek0IK/lnnLSOfkcQRqJUs9kptrD+K+Al0+wSYLJGVnniENrJBnXeznlDznDk/TmYdWW2
        8ErQCUDcblhUGunVKEMFf6pD7JA==
X-Received: by 2002:a05:622a:11c4:b0:31a:e88d:9a22 with SMTP id n4-20020a05622a11c400b0031ae88d9a22mr14787727qtk.306.1656709309944;
        Fri, 01 Jul 2022 14:01:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQS4hYX93lB+KXqbcEdZvtlNF41WuOs5OXuunyyl65rEVlNuRm1AHwL64onsSO4JIeEJbI1A==
X-Received: by 2002:a05:622a:11c4:b0:31a:e88d:9a22 with SMTP id n4-20020a05622a11c400b0031ae88d9a22mr14787698qtk.306.1656709309680;
        Fri, 01 Jul 2022 14:01:49 -0700 (PDT)
Received: from treble ([162.251.124.25])
        by smtp.gmail.com with ESMTPSA id h16-20020a05620a401000b006a6a7b4e7besm20599283qko.109.2022.07.01.14.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:01:49 -0700 (PDT)
Date:   Fri, 1 Jul 2022 14:01:44 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     live-patching@vger.kernel.org, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de
Subject: Re: [PATCH 1/4] livepatch/shadow: Separate code to get or use
 pre-allocated shadow variable
Message-ID: <20220701210144.2wbrrmjswey2tilb@treble>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-2-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220701194817.24655-2-mpdesouza@suse.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 01, 2022 at 04:48:14PM -0300, Marcos Paulo de Souza wrote:
> From: Petr Mladek <pmladek@suse.com>
> 
> Separate code that is used in klp_shadow_get_or_alloc() under klp_mutex.
> It splits a long spaghetti function into two. Also it unifies the error
> handling. The old used a mix of duplicated code, direct returns,
> and goto. The new code has only one unlock, free, and return calls.
> 
> Background: The change was needed by an earlier variant of the code adding
> 	garbage collection of shadow variables. It is not needed in
> 	the end. But the change still looks like an useful clean up.
> 
> It is code refactoring without any functional changes.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Hi Marcos,

Invalid Signed-off-by chain, it will need your SOB added as well.

Also, when posting patches please add lkml to Cc so they're archived and
visible to the wider community.

-- 
Josh

