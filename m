Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9654E562B
	for <lists+live-patching@lfdr.de>; Wed, 23 Mar 2022 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbiCWQTN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Mar 2022 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237987AbiCWQTM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Mar 2022 12:19:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C21CC6E8E2
        for <live-patching@vger.kernel.org>; Wed, 23 Mar 2022 09:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648052261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LMilvWqrMPZjKPNSjn2quNpLYv1XEy4/3uEFo9XhgfY=;
        b=iImOCK1DsV8u4JB+hZOQFX0P+avcIJwUKWIspr0KYdJuql5oKn4+wnKvmSVtVy9cRKGTGs
        UerOeZRjcQlE7p3dPcM42b+rQLqTKW0IZzR+AjYOyA+zjVrAMZ+TxZvzHTpY0eaDv5U2Rk
        KzuSZDkiEC3sY/nZKTBYAmdwy5xl+NI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-RNFonJ4QNrq9gAzvYO7UwQ-1; Wed, 23 Mar 2022 12:17:40 -0400
X-MC-Unique: RNFonJ4QNrq9gAzvYO7UwQ-1
Received: by mail-qk1-f200.google.com with SMTP id m6-20020a37a306000000b0067b189190c3so1274373qke.20
        for <live-patching@vger.kernel.org>; Wed, 23 Mar 2022 09:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=LMilvWqrMPZjKPNSjn2quNpLYv1XEy4/3uEFo9XhgfY=;
        b=bUP5Ubs7lkMWC6qkZEzxaE1kaj7KR0e5gFbXO6RWL4o57zsL26qIwdWdzODp2RibAC
         SZgppXnMk1Llv0i5Mp4+BcAtr9ycbYF40QTLnPWMCNf/L5nXtUSorY75VwmJoUDLAxCk
         ZbyjJtCFZDcF4H8wymAle44rKH0L34sFMQl/YIWXQq0BMnfyO+uqromm66wYhW045Wop
         3H1sCQbbRoK1VTeI6Xy1PZ/q8oEP2utX7+zZHywOGBdnbH0jJRzt5ZgZaNtFIuIkj+D7
         vmMinG0mPRsLyKm0O3k+P7RZOxAjCRcf7iwE8xtAjFLFEZbN+lME++Nmmvi+AamEnHja
         Pycw==
X-Gm-Message-State: AOAM530qiNKVn8Jl/P9chTf21f7EEcl5dZU5yfMFw50ywZsw1DwHUutF
        tlBnM5ycYWoxMPtmtM03B7U1vKefROO+vc0eioXVuFukGRTy4QYKtH+7K2giG01GkS3yeTJ3zzg
        ksMVMGOG2L1NwnSwCcGP7T1beMA==
X-Received: by 2002:ac8:7d0f:0:b0:2e1:cd79:6c3f with SMTP id g15-20020ac87d0f000000b002e1cd796c3fmr456898qtb.551.1648052259713;
        Wed, 23 Mar 2022 09:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI+ts2Y1HOmiplnzOuO6XQHoN928vcCV0rvB/x+YY/nDDPpeIZrag/6oSq8+QdpPyfB2jmMQ==
X-Received: by 2002:ac8:7d0f:0:b0:2e1:cd79:6c3f with SMTP id g15-20020ac87d0f000000b002e1cd796c3fmr456865qtb.551.1648052259384;
        Wed, 23 Mar 2022 09:17:39 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id u20-20020a05620a455400b0067ec0628661sm261739qkp.110.2022.03.23.09.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 09:17:38 -0700 (PDT)
Subject: Re: [PATCH v2] livepatch: Reorder to use before freeing a pointer
To:     Petr Mladek <pmladek@suse.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220320015143.2208591-1-trix@redhat.com>
 <YjtCY1QaA6GI3b+7@alley>
From:   Tom Rix <trix@redhat.com>
Message-ID: <be3ac729-8d1d-0c2e-6d63-aeb23ca04bbd@redhat.com>
Date:   Wed, 23 Mar 2022 09:17:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YjtCY1QaA6GI3b+7@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


On 3/23/22 8:53 AM, Petr Mladek wrote:
> On Sat 2022-03-19 18:51:43, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> Clang static analysis reports this issue
>> livepatch-shadow-fix1.c:113:2: warning: Use of
>>    memory after it is freed
>>    pr_info("%s: dummy @ %p, prevented leak @ %p\n",
>>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> The pointer is freed in the previous statement.
>> Reorder the pr_info to report before the free.
>>
>> Similar issue in livepatch-shadow-fix2.c
> I have added the following paragraph:
>
> <snip>
> Note that it is a false positive. pr_info() just prints the address.
> The freed memory is not accessed. Well, the static analyzer could not
> know this easily.
> </snip>
>
>> Signed-off-by: Tom Rix <trix@redhat.com>
> and pushed the patch into livepatching/livepatching.git,
> branch for-5.18/selftests-fixes.
>
> IMHO, the patch is so trivial and can be added even in this merge
> window. There is no need to create more dances around it ;-)
>
> Let me know if you disagree. I am going to send the pull request
> on Friday or Monday.

Do whatever is easier for you.  The addition to the commit log is fine.

Thanks

Tom

>
> Best Regards,
> Petr
>

