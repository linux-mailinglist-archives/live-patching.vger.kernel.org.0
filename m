Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9507F6F5FA9
	for <lists+live-patching@lfdr.de>; Wed,  3 May 2023 22:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjECUGI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 May 2023 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjECUGH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 May 2023 16:06:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08AD7DA8
        for <live-patching@vger.kernel.org>; Wed,  3 May 2023 13:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683144320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xqs1e/ykDn+/g6GfB/NuOmHhg1xo07zTNBMXXs2AAgo=;
        b=A2fDqhO64XtYQXRRVE0429a+M8+fN5jtfjPDfgkooaqzoZpsX2FNN1w/yMP73pu0n2ZE56
        KCkoS5KLVe667uD1jlEg7DCBrMbKxJMhXU7Bjh/W1OOQoj5QzkySSysQmhZa9zuGi9EyKO
        sJMTnCSoHbRQQjBLUsYAapxCsl7gJK0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-8mzAZg5WOIO1OCs4i5tLAA-1; Wed, 03 May 2023 16:05:18 -0400
X-MC-Unique: 8mzAZg5WOIO1OCs4i5tLAA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-74de74a90e7so708712685a.0
        for <live-patching@vger.kernel.org>; Wed, 03 May 2023 13:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683144318; x=1685736318;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xqs1e/ykDn+/g6GfB/NuOmHhg1xo07zTNBMXXs2AAgo=;
        b=FhzHrhh9CgqQW2GlZQwvYzMq8c0hU4HKOtd7dFaQccMghdZJ1Uw8fqRtiMYsA1nXzF
         ldhr1CfTPYAWCVqBzYBLiV2YNDdEGAoFWQklOOE24hE1LgRVLWuyU5O0yIOCerQgCjHV
         5O1yATW7C/i0C/75bhkZPAJNJHZkN0AhW+haQjz0rO4gzHKzIqEJJirIN//7u22+3rXI
         ZgUXnoEV6idxmDNKXvH+EoUx0crWZEjC5RPJ9WBKvHK0UoO48mZle+1IC+fU4c+pBLOH
         iwK449WarZrVWDpu5WcOnj2/LHfQ2kBB270bdfvAw9VZat8Orooj5KO58qn1haadOwkb
         qsXw==
X-Gm-Message-State: AC+VfDwb3B6nI8SJKXuBDC3ULH8IG8Twhpe9kOXKSiOtve7uKbWxq/Iw
        sTXxDEvMm9roeeUxYVoIkCTpo+/WcHM4SRicUREmdE/NLXVxuyfhFP58EUop0l1judjMVr8qzaV
        KHIbDChwTPQorrY9t0NeKCG/dBw==
X-Received: by 2002:a05:6214:62b:b0:5ef:4763:2f61 with SMTP id a11-20020a056214062b00b005ef47632f61mr13013486qvx.20.1683144318000;
        Wed, 03 May 2023 13:05:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6AjN0TkS0B9E0LkLvhDLIrrcjrf5qu0fEOAJpPbrfwLpzT11CJ46k41Yint2vd4+fjLxwYjA==
X-Received: by 2002:a05:6214:62b:b0:5ef:4763:2f61 with SMTP id a11-20020a056214062b00b005ef47632f61mr13013451qvx.20.1683144317757;
        Wed, 03 May 2023 13:05:17 -0700 (PDT)
Received: from [10.18.17.8] (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o10-20020a05620a110a00b007513b8254easm5106769qkk.68.2023.05.03.13.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 13:05:17 -0700 (PDT)
Message-ID: <0edd2374-5cfa-2731-f874-aeaa54b3dd18@redhat.com>
Date:   Wed, 3 May 2023 16:05:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        nstange@suse.de, mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
 <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <ZDkif0cu/jh/KKC+@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/14/23 05:53, Mark Rutland wrote:
> 
> * How is this going to work with rust?
> 
>   It's not clear to me whether/how things like ftrace, RELIABLE_STACKTRACE, and
>   live-patching are going to work with rust. We probably need to start looking
>   soon.
> 

[ cc += Steve ]

For me, any explanation of kernel livepatching to another kernel dev
usually starts with ftrace, handlers, function granularity, etc.
Thinking about livepatching + rust, I can only imagine there will be a
lot of known and unknown gotchas with respect to data scoping, stacks,
relocations, etc... but I would still work my way up from learning more
about how / if Rust code will be trace-able and what that roadmap may be.

Any thoughts on that Steve?  I see that the "Kernel Testing &
Dependability" microconf has Rust on their proposal, are there any other
planned talks re: ftrace / rust?

Regards,
-- 
Joe

