Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF41619A69
	for <lists+live-patching@lfdr.de>; Fri,  4 Nov 2022 15:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiKDOpK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Nov 2022 10:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiKDOpI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Nov 2022 10:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AE8D7F
        for <live-patching@vger.kernel.org>; Fri,  4 Nov 2022 07:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667573048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cWbQ4srh1ZbMWJ3y2/Y3jfOfBLZVj52Dtk9Wv7SX37I=;
        b=Ti3OM+Z1WEWaXlXY6vM+/O0dW8XL/feBdXnCIHTD9vR7zGTKSc8JglB73bx/z/2HIAu/Oi
        UUkVcwS501qJXZ85ZbHiqxlE7U5fGoWpez1mZZcVqzNT59IkHw8u26V556obxZM4EDdTLX
        a0Ho9+G2AEEPJsCOceSMWL94o0Mu7fc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-_wSJUwiwPnGbcVEZGC1ZDA-1; Fri, 04 Nov 2022 10:44:06 -0400
X-MC-Unique: _wSJUwiwPnGbcVEZGC1ZDA-1
Received: by mail-qt1-f199.google.com with SMTP id ff5-20020a05622a4d8500b003a526107477so3881716qtb.9
        for <live-patching@vger.kernel.org>; Fri, 04 Nov 2022 07:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:subject:references:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cWbQ4srh1ZbMWJ3y2/Y3jfOfBLZVj52Dtk9Wv7SX37I=;
        b=zQ8JIqx1tWQUCFVVVN9kibD8IdATkIUGpNb1uxmdMm5VuKlgYAiKz20/4nzbFPqiIR
         N/AkTo2ySWfwLlxAQ0OSIDEIbLOPc1hYMNMo8bnAD0BR3RqoWuMGsD0gxbwDXG8bOerr
         cDFtpu04HLeeeXub06e3R1I8b/heRxbnVur3FWNE49JlwEU0Y3xcc+9pgvTtoUIFDN+b
         EShnJyBa+GqkP5yHMPRahxsQi8D7QQLKURfLXoPjDT7iPXGVCGM+Aor6YEiXF8IxaffF
         M6coTryQOx+GNcB5eeD6+mLYOru3IhCBjL8TyJ1FdIBLgMcWgIwBkqX2MqAholzGYpYg
         /faA==
X-Gm-Message-State: ACrzQf2ECgqrjcIqzubCVosyXqDJJWlTVpS42VJmsKJ9/dQjE0L0gmgX
        EHYU6On+L5gBdpTJedK5nTZ/TH/byPF1m5vOsrSS3My41gBCttWZRidhTVfmWRxQhaZ2NEE1sUJ
        WfgHrG9Zp5Ic1PXnNrT9UBJrSvg==
X-Received: by 2002:a05:6214:21e9:b0:4be:3ae1:f17f with SMTP id p9-20020a05621421e900b004be3ae1f17fmr8219742qvj.121.1667573046219;
        Fri, 04 Nov 2022 07:44:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7d7ArrXrn3R4ypo2bZhEzcfYOCJRRbfhFT3M+jRnvhRddiWe5+Expp8jf+KFl8nVxf+afvEw==
X-Received: by 2002:a05:6214:21e9:b0:4be:3ae1:f17f with SMTP id p9-20020a05621421e900b004be3ae1f17fmr8219715qvj.121.1667573045954;
        Fri, 04 Nov 2022 07:44:05 -0700 (PDT)
Received: from [192.168.1.77] ([209.104.230.86])
        by smtp.gmail.com with ESMTPSA id i18-20020a05620a405200b006fa8299b4d5sm2622509qko.100.2022.11.04.07.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 07:44:05 -0700 (PDT)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-5-mpdesouza@suse.com>
 <b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com> <Y1aqkxKWnzVo7pfP@alley>
 <Y2D83wFbIcBoknQL@alley> <a0a03167-1d49-1c58-12c3-4a881e924224@redhat.com>
Subject: Re: [PATCH 4/4] livepatch/shadow: Add garbage collection of shadow
 variables
Message-ID: <528e9eba-9d97-b8b8-be1d-4f7323dac89f@redhat.com>
Date:   Fri, 4 Nov 2022 10:44:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a0a03167-1d49-1c58-12c3-4a881e924224@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/2/22 8:51 AM, Joe Lawrence wrote:
> On 11/1/22 7:02 AM, Petr Mladek wrote:
>> Note that adding the used klp_shadow_types into struct klp_object
>> is not strictly required.
>>
>> Alternative solution is to register/unregister the used types using
>> klp_callbacks or module init()/exit() callbacks. This approach
>> is used in lib/livepatch/test_klp_shadow_vars.c.
>>
>> I believe that this would be usable for kpatch-build.
>> You needed to remove not-longer used shadow variables
>> using these callbacks even before this patchset. I would
>> consider it a bug if you did not remove them. The new API
>> just allows to do this a safe way.
>>
> 
> Ah, let me dig into that example for alternative usage.  At first
> glance, it looks like you're right -- kpatch already supports callbacks,
> so just (un)register the shadow variables here.  I'll be back with more
> info hopefully later this week.
> 

(Un)registering the shadow types from the callbacks worked out fine.  It
adds some verbosity to our shadow variable usage, but I think most of
that is unavoidable as the API is changing anyway.

Adding the shadow type into kpatch klp_objects (or the klp_patch) would
require a bit more work on our part, but doesn't need to hold up
upstream review up this patchset.

Thanks,

-- 
Joe

