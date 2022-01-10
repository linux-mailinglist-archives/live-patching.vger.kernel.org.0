Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AA489D54
	for <lists+live-patching@lfdr.de>; Mon, 10 Jan 2022 17:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbiAJQRI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Jan 2022 11:17:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237199AbiAJQRF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Jan 2022 11:17:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641831423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YjTLY75U3Rr/IBjHhdFVsX4vnS2z8mb10E/ypAsx9o=;
        b=PbcmDbWHRMMQLyCXCr9uvOmvsHV8pR9MRroSlXczTyoKWOh4CAMd7oZUodO7FLYs/FTYiy
        LI+TCy1bBe2lvHwNgm64P45nx+gOwaXFYl0j4+L5X+UrR0WW0mBS/ScSN8QC1M4CqHyO/s
        jT40xCu2oY4Hf52eECufsxuGKj77GTE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-S8NcOPgDO2qG0R2GITO4zw-1; Mon, 10 Jan 2022 11:17:00 -0500
X-MC-Unique: S8NcOPgDO2qG0R2GITO4zw-1
Received: by mail-qv1-f69.google.com with SMTP id jn6-20020ad45de6000000b004146a2f1f97so12141335qvb.19
        for <live-patching@vger.kernel.org>; Mon, 10 Jan 2022 08:17:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YjTLY75U3Rr/IBjHhdFVsX4vnS2z8mb10E/ypAsx9o=;
        b=xiM4lwHU+Df5Ut1W8NiwbsRLZiSwP3JXDhDJtlQ9VdMqP32R/kxKYpHARg69J8Q+ZE
         LhVuCLB4S6/GAbb7VtMcgt4pGKzVpBJd0yc/UA/3tfAeSVbKuiGP9qju17ZyxmBom9kX
         EzaCFQgeU5J3gcVU0Q4c6Bd7uRpou9DiZWIczF7+dBD7tn+A2WwceqvrhNdPf3HSgPgb
         fdK/wuOyEznnntnhe13O46Ne0gULVxSWBu7UsoTxvk6Do0WnTl73Nv0R1R3gJm19xmqe
         gacT0zyGtGS7FMa65iAwo/a/3xinFlI8sqG9eRDsujssl8QtwOs4yaBcTJuyGsWFiYSe
         G50w==
X-Gm-Message-State: AOAM533NTg3GYi7QaDU3fEy/s9lW2gN1yhnDyRIJdAdKQj+LsCK37oSG
        cOjkBWETqTyWgXD44Ou744mShmqf/mVKx53o864jneheNXLnLuSHpLEQdUXWN7ooBMaBEDPWdvw
        dV0p3s3kvzmAEv3GRmtBZ6edn5w==
X-Received: by 2002:ac8:5f4e:: with SMTP id y14mr377041qta.620.1641831420240;
        Mon, 10 Jan 2022 08:17:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyAUtzH3EEX9Ff3ydZLCMZTFVjkkVjbUCwm51dfml+s1g3fpFnx//1UUzWe5M/akiYa/jS9DA==
X-Received: by 2002:ac8:5f4e:: with SMTP id y14mr377024qta.620.1641831420013;
        Mon, 10 Jan 2022 08:17:00 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id v13sm3080842qtk.93.2022.01.10.08.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 08:16:59 -0800 (PST)
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
To:     Song Liu <song@kernel.org>
Cc:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, jpoimboe@redhat.com,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz
References: <20211229215646.830451-1-void@manifault.com>
 <1f1b9b01-cfab-8a84-f35f-c21172e5d64d@redhat.com>
 <CAPhsuW4Ua2hDs5WMtF0s_CQki-ZdYMvkU2s+Nc7Rvs=-D6WL=Q@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <4df1f9a0-3b26-903b-fe63-af5e75ed98d4@redhat.com>
Date:   Mon, 10 Jan 2022 11:16:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4Ua2hDs5WMtF0s_CQki-ZdYMvkU2s+Nc7Rvs=-D6WL=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/7/22 11:46 AM, Song Liu wrote:
> On Fri, Jan 7, 2022 at 6:13 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>
>> On 12/29/21 4:56 PM, David Vernet wrote:
>>> For example, under certain workloads, enabling a KLP patch with
>>> many objects or functions may cause ksoftirqd to be starved, and thus for
>>> interrupts to be backlogged and delayed.
>>
>> Just curious, approximately how many objects/functions does it take to
>> hit this condition?  While the livepatching kselftests are more about
>> API and kernel correctness, this sounds like an interesting test case
>> for some of the other (out of tree) test suites.
> 
> Not many patched functions. We only do small fixes at the moment. In the recent
> example, we hit the issue with ~10 patched functions. Another version
> with 2 to 3
> patched function seems fine.
> 
> Yes, I think this is an important test case.
> 

Thanks, Song.  If you can share any test setup details, I'll pass those
along to our internal QE group.  And once merged, we'll be adding this
one to the list of backports for our distro.

-- 
Joe

