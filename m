Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0565F380
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbjAESKR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 13:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbjAESKM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 13:10:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA101C8
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 10:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672942169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=87XEr1ZkZNddS/Li1EdlQ6ISU69eehXodKLwNjG/wIY=;
        b=W0pOd7cqUXGBJJ1fFPGJckmEWu2Hy1WldK4PisAOyOXojALE0NxQ5z5JHLsk51VToFnpqD
        dmRrwZDwN0v4ADMOvT7XpW/KGj+dmX/6OmAKJ+nablkju1JgBzJ9Bh1VpGR3rheF2API+2
        eBBd1mHAqHKw6jmVl9cQi0CfeRauUZM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-iblRWe98OemTV7pVlKsyag-1; Thu, 05 Jan 2023 13:09:28 -0500
X-MC-Unique: iblRWe98OemTV7pVlKsyag-1
Received: by mail-qt1-f199.google.com with SMTP id g12-20020ac870cc000000b003a8112df2e9so13419806qtp.9
        for <live-patching@vger.kernel.org>; Thu, 05 Jan 2023 10:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=87XEr1ZkZNddS/Li1EdlQ6ISU69eehXodKLwNjG/wIY=;
        b=Go8H9V2eLi5Jd1VBYhEno9br3JuefnhZmoOwY4a64hM8HuGLwZr8+oDIucQ9oH5Wkq
         NHZsq3OI0t9EtqRvlgJUdcW0i3rQrKYx8TgesI5bXyv2DnlqhYGh//Mk+IXMT4n5/btx
         LGkmfYHKBL+B/rCZZUXC7zQjk7oNSmhZxQCRqfU/ubLTeGRtIuivmmEq2klbuShdtLzD
         4AkiXEfOTN4wwsJPkvFMsmjpMpYSOJpEAnlcuGXoMTJbZimE3q+VrKg3PYnKRm31nyYP
         nQ1eEyckJOvcGhx05TDCFxXXkH2KpBpJCr09WVHebNqs3Ir0kH2LkWZcdlpCQGPn0UbL
         J8fw==
X-Gm-Message-State: AFqh2kptVE3HXLevLOZUBsirY6xxKKi9GTq3w7OsmybRAyth1LSnkfk1
        rAw7Link3xB/Odb0uIpO+/EBSRpS+9VD8vmuDvZwD/z9OqDaL4txEPzVGufs0gtheZop4wcucPJ
        vQbULNgOsWyA3GXrFuquC9rDbhA==
X-Received: by 2002:ac8:7ef8:0:b0:3a5:8688:89db with SMTP id r24-20020ac87ef8000000b003a5868889dbmr77063577qtc.48.1672942167685;
        Thu, 05 Jan 2023 10:09:27 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt+geZ9JEu1xNdVeR1O4//WJjIa4vv682XKhvpakNREv6dPEQINR7NLO9CJBGIi2IJ3cmUP1w==
X-Received: by 2002:ac8:7ef8:0:b0:3a5:8688:89db with SMTP id r24-20020ac87ef8000000b003a5868889dbmr77063560qtc.48.1672942167449;
        Thu, 05 Jan 2023 10:09:27 -0800 (PST)
Received: from [192.168.1.13] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id ch12-20020a05622a40cc00b00399fe4aac3esm22133229qtb.50.2023.01.05.10.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 10:09:26 -0800 (PST)
Message-ID: <641c0330-163a-336b-081c-456e0be826b6@redhat.com>
Date:   Thu, 5 Jan 2023 13:09:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20221214174035.1012183-1-song@kernel.org>
 <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
 <Y7ayTvpxnDvX9Nfi@alley>
 <CAPhsuW5E9m5tb_ZCknH4QfFMukqwZHkKxvkHxo5A-znt5tm0ow@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <CAPhsuW5E9m5tb_ZCknH4QfFMukqwZHkKxvkHxo5A-znt5tm0ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/5/23 11:53, Song Liu wrote:
> Btw: I am confused with this one:
> 
>                 case R_PPC64_REL16_HA:
>                         /* Subtract location pointer */
>                         value -= (unsigned long)location;
>                         value = ((value + 0x8000) >> 16);
>                         *((uint16_t *) location)
>                                 = (*((uint16_t *) location) & ~0xffff)
>                                 | (value & 0xffff);
>                         break;
> 
> (*((uint16_t *) location) & ~0xffff) should always be zero, no?

It looks like a lot of extra read/bit twiddling to do:

  *(uint16_t *) location = value;

or am I missing a corner case that this handles?

-- 
Joe

