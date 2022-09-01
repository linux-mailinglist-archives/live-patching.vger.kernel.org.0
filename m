Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B775A98BE
	for <lists+live-patching@lfdr.de>; Thu,  1 Sep 2022 15:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiIAN0K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Sep 2022 09:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiIANYd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Sep 2022 09:24:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DED2CDF0
        for <live-patching@vger.kernel.org>; Thu,  1 Sep 2022 06:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662038652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GtRrZhfcr+HBskb37rMCSyo0Md1DArbhaGxGxxH8GQE=;
        b=LqC5neSf9E4p3PG2JbJRVftcvU/yqXlJeGnun0nf1SCIDyTL9C++ok+eSq3WvnxTBxFInY
        xjB/pNd2IPI1+OvOd/H+zUIwQIp24FDdyvpo6dfxuTd+MYZqCsxXEHZ4tVXBb7/xN9oqIb
        YV9Epjpu8bcdKkEMHmzAVNsC8ets2vY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-342-GgiD-gLeO8i1EvpW0DZ-TQ-1; Thu, 01 Sep 2022 09:24:11 -0400
X-MC-Unique: GgiD-gLeO8i1EvpW0DZ-TQ-1
Received: by mail-qk1-f200.google.com with SMTP id f1-20020a05620a280100b006bc4966f463so14205812qkp.4
        for <live-patching@vger.kernel.org>; Thu, 01 Sep 2022 06:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:subject:cc:from:references:to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GtRrZhfcr+HBskb37rMCSyo0Md1DArbhaGxGxxH8GQE=;
        b=Jj5fRuYCCspSbSxU5gH3GN8yNhByVaWIx+IsOozivypO8VBkeNodOGa4zFriRZj1VB
         C4AS8vCF1j/DxNdHr3EbfK7gNG/XGu2NlEMczNGoWn0S8YBZksgEhIr72YcsXn0j/pMZ
         ZGiwS5gi0K9cA7sag5gTnB1SBc3TeqrOZb5GFdHhzNPbfyyA4jrHu06bX11UEPZXVYxU
         IHqsMJXyzLmIw2gj11PPKo5SKJ9iO+T4zqdpY8Zb+vlrqdJCmhfjWzjvfQXBkQZrSqTz
         RO4E/jdJp5tKH3zgB/xnNCE77NKOFArbx1qxGrug/x7ybOMFTAViFS9TFRKfUfbFy+uZ
         osFA==
X-Gm-Message-State: ACgBeo3YDkU2H1om6NoP9aWJX0kpk+0V2fEnNy7RR91fx3sYcIM7U0+n
        v24HZmGOoLXPCHPI16KXm3gBmNQelBxfXJ4wlVIrS55wYrg0okOU++QAgHHGqs1nSUy7IBj18hV
        EUiDYZ2d2IpSUtR5CF2EIifbwNfXfGKhvq0mo4uCZRM3UhmKr3ymhXDLKrBpxjJi5gKuCAzNvpN
        jvH+E3QnY=
X-Received: by 2002:a05:6214:5091:b0:496:dad0:6361 with SMTP id kk17-20020a056214509100b00496dad06361mr23925870qvb.81.1662038650300;
        Thu, 01 Sep 2022 06:24:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4qoveEwai/Y3kskQEd+SFMIH7fGAf1B2jYVOWFiPGDe4ghdoizdDD4y7znxlpDIOI8OXv/Dw==
X-Received: by 2002:a05:6214:5091:b0:496:dad0:6361 with SMTP id kk17-20020a056214509100b00496dad06361mr23925835qvb.81.1662038649901;
        Thu, 01 Sep 2022 06:24:09 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id m27-20020a05620a13bb00b006bbf85cad0fsm11311431qki.20.2022.09.01.06.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 06:24:09 -0700 (PDT)
To:     Zhen Lei <thunder.leizhen@huawei.com>
References: <20220901022706.813-1-thunder.leizhen@huawei.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: Move error print out of lock protection in
 klp_enable_patch()
Message-ID: <65fe1978-60da-5bd4-9559-fddec13f03bf@redhat.com>
Date:   Thu, 1 Sep 2022 09:24:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220901022706.813-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/31/22 10:27 PM, Zhen Lei wrote:
> The patch->mod is not a protected object of mutex_lock(&klp_mutex). Since
> it's in the error handling branch, it might not be helpful to reduce lock
> conflicts, but it can reduce some code size.
> 
> Before:
>    text    data     bss     dec     hex filename
>   10330     464       8   10802    2a32 kernel/livepatch/core.o
> 
> After:
>    text    data     bss     dec     hex filename
>   10307     464       8   10779    2a1b kernel/livepatch/core.o
> 

Is a size change expected, or is it just compiler fall out from
shuffling the code around a little bit?

I see some arches do a little better, some a little worse with gcc-9.3.0
cross compilers:

Before
------
   text    data     bss     dec     hex filename
   8490     600       8    9098    238a arm64/kernel/livepatch/core.o
   9424     680       8   10112    2780 s390/kernel/livepatch/core.o
   9802     228       4   10034    2732 ppc32/kernel/livepatch/core.o
  13746     456       8   14210    3782 ppc64le/kernel/livepatch/core.o
  10443     464       8   10915    2aa3 x86_64/kernel/livepatch/core.o


After
-----
   text    data     bss     dec     hex filename
   8514     600       8    9122    23a2 arm64/kernel/livepatch/core.o
   9424     680       8   10112    2780 s390/kernel/livepatch/core.o
   9818     228       4   10050    2742 ppc32/kernel/livepatch/core.o
  13762     456       8   14226    3792 ppc64le/kernel/livepatch/core.o
  10446     464       8   10918    2aa6 x86_64/kernel/livepatch/core.o

In which case, I'd just omit the size savings from the commit msg.

> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/livepatch/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 42f7e716d56bf72..cb7abc821a50584 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1041,9 +1041,9 @@ int klp_enable_patch(struct klp_patch *patch)
>  	mutex_lock(&klp_mutex);
>  
>  	if (!klp_is_patch_compatible(patch)) {
> +		mutex_unlock(&klp_mutex);
>  		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
>  			patch->mod->name);
> -		mutex_unlock(&klp_mutex);
>  		return -EINVAL;
>  	}
>  
> 

That said, I don't see anything obviously wrong about the change (we
don't need to sync our error msgs, right?) so:

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- 
Joe

