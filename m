Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E816546712
	for <lists+live-patching@lfdr.de>; Fri, 10 Jun 2022 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbiFJNG2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Jun 2022 09:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343724AbiFJNG0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Jun 2022 09:06:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 561516333
        for <live-patching@vger.kernel.org>; Fri, 10 Jun 2022 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654866382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/qZ9hPkyfAzHF2C3skFs/nWfk6/WdMDFmw7jidLtN8=;
        b=UayAoJn1y0lPB4UMdEB2C7cU9yu0F0ILyT6igxdtFHThm0VTwuwCXnYlx4LrCVpjVd63Xp
        MXuxERqWTNVa1laXxW+WbHOaEGbUmtiFSvmxskDydZvp+B+lCZYF0XYVHCfhnD9H1BUwKw
        PbLdaeM/4ml06uSkr51ZA8MHVjb6Rzg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-dwy1MMrmOfiW3McmsEfldw-1; Fri, 10 Jun 2022 09:06:21 -0400
X-MC-Unique: dwy1MMrmOfiW3McmsEfldw-1
Received: by mail-qv1-f70.google.com with SMTP id ib14-20020a0562141c8e00b0046e08b0ae27so1089150qvb.18
        for <live-patching@vger.kernel.org>; Fri, 10 Jun 2022 06:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i/qZ9hPkyfAzHF2C3skFs/nWfk6/WdMDFmw7jidLtN8=;
        b=DHuI4z/bRQGvatXRC+6d6fmlqAP9ptzTQ+QwBs0immRf/LKOfC0of2SA5my+QpdAJt
         Gdxv+Ttc/Hk4s+DfeL43NX1kWTpc4u4I7wfJOQk3ok9NTj29H0xZF9dJ4sU+9IvDAUCQ
         MbBOd13gN6dIKNXBonlnzYSzB4842MgQ+dfgKPZiYw2FeWiOw0L01qEJc6hUHlzlfTOA
         dOClTQrimUDeRI5QS+J5C5Zn27yYw/Z/NoHEpS1/0T8nCdVvDbmRBmjIqxMP8MwwOZJ0
         N2idIm4yb/NB+4K3yKlbz9mj+91s+h4GYG0XhbTev5prqTaYL3JPcmd9/cfujIqLTTGC
         +Kyw==
X-Gm-Message-State: AOAM531muPrce61LyYwPf1eKu2YNFggz28VHHh/xf9+UPFfgq1JyeOAG
        fBo3mJ6e8Yt1xqYLqNB04xCEddExcJohscRkK5qb1PqMtgPQjM4jkbXg3EUXcGtlnjigiJ2Pudc
        wZOTEbUYy0C4drJmsAOUHqABbIQ==
X-Received: by 2002:a05:622a:11c5:b0:304:d8cd:2058 with SMTP id n5-20020a05622a11c500b00304d8cd2058mr33787610qtk.324.1654866379097;
        Fri, 10 Jun 2022 06:06:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhc8Ym2vVTmu35wZVMf8SMDVYuy8RlOZdv2PzzhEZKAhcDLqWbwqQ2AtPXYeBY2TIahvJk7Q==
X-Received: by 2002:a05:622a:11c5:b0:304:d8cd:2058 with SMTP id n5-20020a05622a11c500b00304d8cd2058mr33787535qtk.324.1654866378406;
        Fri, 10 Jun 2022 06:06:18 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a424f00b006a69d7f390csm18477915qko.103.2022.06.10.06.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 06:06:17 -0700 (PDT)
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     shuah@kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        pmladek@suse.com
References: <20220603143242.870-1-mpdesouza@suse.com>
 <c5dc436e-2e3f-db2c-5cd5-215a9af19152@linuxfoundation.org>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 0/2] livepatch: Move tests from lib/livepatch to
 selftests/livepatch
Message-ID: <5966397b-5577-8075-ffdd-f32e5e4ca75a@redhat.com>
Date:   Fri, 10 Jun 2022 09:06:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c5dc436e-2e3f-db2c-5cd5-215a9af19152@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 6/9/22 4:16 PM, Shuah Khan wrote:
> On 6/3/22 8:32 AM, Marcos Paulo de Souza wrote:
>> Hi there,
>>
>> The first patch moves the current livepatch tests to selftests,
>> allowing it
>> be better suited to contain more complex tests, like using userspace C
>> code
>> to use the livepatched kernel code. As a bonus it allows to use
>> "gen_tar" to export the livepatch selftests, rebuild the modules by
>> running make in selftests/livepatch directory and simplifies the process
>> of creating and debugging new selftests.
>>
> 
> In general selftests don't include modules. We keep test modules under lib.
> One of the reasons is that modules have dependencies on the kernel and
> should
> be built when kernel is built.
> 
> I don't fully buy the argument that moving modules under selftest would
> simplify
> the process.
> 

Hi Shuah,

I see that there is tools/testing/selftests/bpf/bpf_testmod/ which
claims to be a "conceptually out-of-tree module".  Would similarly
moving livepatch test modules under tools/ give us flexibility to write
them build for multiple kernel versions?  Then one could theoretically
build and run the latest, greatest selftests against older kernels
(assuming the associate script/module/kernel supports the idea)?

Regards,
-- 
Joe

