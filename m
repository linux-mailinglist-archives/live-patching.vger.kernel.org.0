Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B8B4E4B5F
	for <lists+live-patching@lfdr.de>; Wed, 23 Mar 2022 04:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiCWDXC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Mar 2022 23:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiCWDW7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Mar 2022 23:22:59 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2B5BD07;
        Tue, 22 Mar 2022 20:21:30 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id bp39so230968qtb.6;
        Tue, 22 Mar 2022 20:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TjGXNoNPeHTVLppn4GBStrAFhNsfJnPfAeYAzRe+rIQ=;
        b=vSc5oBegHRWgKtCFx7IsmYRnF9EoKKTYwcBGJHbEAMpADlBAgxYEKrY8d8aD4luQUb
         iPWFLtkCTtrxy6n13/Bj0yGPy4kgL8a3hfGpbSmvhIQiWv0CMsTCyTmA+YwfDLIguu4I
         reiS8L2jnQRhXzVhsI04VU4F0lx2DSZghy1mckTF/z+pv/JVyDPzklWTNXUDS14Al5fc
         fAIhViw8oJwEb8y+zIaxZJEOBT+nTIB8QNw9LCngyVLNjHsEog3VCOMCZuNZZrxp8I1j
         6vWygVAb6Vp9fgnuEOVu/ZS02lipOb71F5Q3Z/yWUuVIV6uxS23JO51XrK/+3eOmpzlA
         uGCg==
X-Gm-Message-State: AOAM5314vIfQWzzEGVj28OQerIwNIHRSgr0RqyzO0nEzWVMoRRqtx3CJ
        zyIYYgbrUUl3tuUyDYHYu58=
X-Google-Smtp-Source: ABdhPJwREaT8EIhjKSo80EaUzacQXlNrDBxDy3kVCH1nAdH1G2E1btewQjiiC+IPt9n0ZPA8epCYSQ==
X-Received: by 2002:a05:622a:13d0:b0:2e1:cb3e:bb8a with SMTP id p16-20020a05622a13d000b002e1cb3ebb8amr23033116qtk.16.1648005689792;
        Tue, 22 Mar 2022 20:21:29 -0700 (PDT)
Received: from user-VirtualBox (c-73-132-53-127.hsd1.va.comcast.net. [73.132.53.127])
        by smtp.gmail.com with ESMTPSA id a23-20020a05620a16d700b0067e98304705sm3725607qkn.89.2022.03.22.20.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 20:21:29 -0700 (PDT)
Date:   Tue, 22 Mar 2022 23:21:27 -0400
From:   David Vernet <void@manifault.com>
To:     Tom Rix <trix@redhat.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        nathan@kernel.org, ndesaulniers@google.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH v2] livepatch: Reorder to use before freeing a pointer
Message-ID: <20220323032127.3frjsh4iiclv4cys@user-VirtualBox>
References: <20220320015143.2208591-1-trix@redhat.com>
 <3ee9826e-b770-d015-0251-e9770172d973@redhat.com>
 <b4b347ea-5b12-223a-86f5-c13aee714f08@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4b347ea-5b12-223a-86f5-c13aee714f08@redhat.com>
User-Agent: NeoMutt/20191207
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > On 3/19/22 9:51 PM, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > Clang static analysis reports this issue
> > > livepatch-shadow-fix1.c:113:2: warning: Use of
> > >    memory after it is freed
> > >    pr_info("%s: dummy @ %p, prevented leak @ %p\n",
> > >    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 
> > > The pointer is freed in the previous statement.
> > > Reorder the pr_info to report before the free.
> > > 
> > > Similar issue in livepatch-shadow-fix2.c
> > > 
> > > Signed-off-by: Tom Rix <trix@redhat.com>
> > > ---
> > > v2: Fix similar issue in livepatch-shadow-fix2.c
> > > 
> > >   samples/livepatch/livepatch-shadow-fix1.c | 2 +-
> > >   samples/livepatch/livepatch-shadow-fix2.c | 2 +-
> > >   2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
> > > index 918ce17b43fda..6701641bf12d4 100644
> > > --- a/samples/livepatch/livepatch-shadow-fix1.c
> > > +++ b/samples/livepatch/livepatch-shadow-fix1.c
> > > @@ -109,9 +109,9 @@ static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
> > >   	void *d = obj;
> > >   	int **shadow_leak = shadow_data;
> > > -	kfree(*shadow_leak);
> > >   	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
> > >   			 __func__, d, *shadow_leak);
> > > +	kfree(*shadow_leak);
> > >   }
> > >   static void livepatch_fix1_dummy_free(struct dummy *d)
> > > diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
> > > index 29fe5cd420472..361046a4f10cf 100644
> > > --- a/samples/livepatch/livepatch-shadow-fix2.c
> > > +++ b/samples/livepatch/livepatch-shadow-fix2.c
> > > @@ -61,9 +61,9 @@ static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
> > >   	void *d = obj;
> > >   	int **shadow_leak = shadow_data;
> > > -	kfree(*shadow_leak);
> > >   	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
> > >   			 __func__, d, *shadow_leak);
> > > +	kfree(*shadow_leak);
> > >   }
> > >   static void livepatch_fix2_dummy_free(struct dummy *d)

Acked-by: David Vernet <void@manifault.com>
