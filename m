Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38446F975
	for <lists+live-patching@lfdr.de>; Fri, 10 Dec 2021 04:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhLJDL4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Dec 2021 22:11:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234022AbhLJDL4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Dec 2021 22:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639105701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXWUh5En4X6dZFkxf6+B8+f+LS16fp3Q6dwt0j3g/Gk=;
        b=jJDvQeL08BIeKHs7Lk1CZOCOnGZYzFKCs0B2CflwWqOh86jtHj1hhD+VR6btoC/7ECnV4D
        Y4lIHbMxRSnOxxbL9AGbzwoc+q98bPRMGxjJWHMw5T9Ffpxgk4Q1GUlqwMocpYQe/KBqpI
        7x9rE4Jb3FDdowBTmv5v2/UDTqfEKcU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-oL8wZQ9wPKmWtCxx_Fb2Jg-1; Thu, 09 Dec 2021 22:08:20 -0500
X-MC-Unique: oL8wZQ9wPKmWtCxx_Fb2Jg-1
Received: by mail-qt1-f200.google.com with SMTP id h20-20020ac85e14000000b002b2e9555bb1so12455512qtx.3
        for <live-patching@vger.kernel.org>; Thu, 09 Dec 2021 19:08:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXWUh5En4X6dZFkxf6+B8+f+LS16fp3Q6dwt0j3g/Gk=;
        b=Ytgl20e4UXU5vUlvqUxUpe8i9IXBJLs5bBg39hC8Ukf2sXMrJ2bjFqlEYHihWmhlTX
         CzP7C1w+8NaIaLBDB+k5+FrXWJwmKioDDd181pYmOMCevqNSxPZ+CIU+pbaBonGTFcU3
         dr5wSPsP32WLv+uUOyrSHdKy2cq0BvyB2pQQ6UmWHEhPVivASKtzHifEO/oUUmvj+E86
         89IYMyTEUehc4M4bMS63gl7FrmqFGYe/scBj2MFBCEtg8rkzPTnP7SSdC7GYYuzYy8gf
         n6BF55LA79Sz3TNEkEP3oVjaWCY9JgVe0Tlsn6Cbvh+7AOm7U03imuuBCmteMHsxS4Dm
         c2HQ==
X-Gm-Message-State: AOAM531gpYtzzvNjYv29/ZRQ0AkovdttEEMjLzTlWmA5vy6BajC4rmkL
        N0I95326E1blmamct6RxDFCcEwsmZG1ikfWNAM6guJSjrko8KLW7mZmB08gBg30tCeY9047PPlY
        f+nqHgLcPoZgzC9F7FTo/xs6USqGBV3ndwsXLPJ+Ogk0iD8uxT5vPntYBsCbYe2eXeAl8t+QWV2
        ZeW8o2v4Q=
X-Received: by 2002:ac8:5fc2:: with SMTP id k2mr23663635qta.310.1639105699310;
        Thu, 09 Dec 2021 19:08:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykFyHDqmr5EaqtBOtK1YMnFz8OsH4Ii95ABA5uZFruxDtBgRptKweMHr5q+khjc7T1O9Y+Ag==
X-Received: by 2002:ac8:5fc2:: with SMTP id k2mr23663595qta.310.1639105698934;
        Thu, 09 Dec 2021 19:08:18 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id n6sm1073550qtx.88.2021.12.09.19.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 19:08:18 -0800 (PST)
Subject: Re: [PATCH] powerpc/module_64: Fix livepatching for RO modules
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Russell Currey <ruscur@russell.cc>,
        linuxppc-dev@lists.ozlabs.org
Cc:     jniethe5@gmail.com, naveen.n.rao@linux.vnet.ibm.com,
        christophe.leroy@csgroup.eu, live-patching@vger.kernel.org
References: <20211123081520.18843-1-ruscur@russell.cc>
 <d9d9ef2d-4aaa-7d8b-d15e-0452a355c5cf@redhat.com>
 <25d35b916e87ed7a71ebc6528259e2f0ed390cb2.camel@russell.cc>
 <87y24umfe9.fsf@mpe.ellerman.id.au>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <e6378545-4218-1bb6-468e-3d957ce15904@redhat.com>
Date:   Thu, 9 Dec 2021 22:08:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87y24umfe9.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/9/21 2:00 AM, Michael Ellerman wrote:
> Russell Currey <ruscur@russell.cc> writes:
>> On Tue, 2021-12-07 at 09:44 -0500, Joe Lawrence wrote:
>>> On 11/23/21 3:15 AM, Russell Currey wrote:
>>>
>>> [[ cc += livepatching list ]]
>>>
>>> Hi Russell,
>>>
>>> Thanks for writing a minimal fix for stable / backporting.  As I
>>> mentioned on the github issue [1], this avoided the crashes I
>>> reported
>>> here and over on kpatch github [2].  I wasn't sure if this is the
>>> final
>>> version for stable, but feel free to add my:
>>>
>>> Tested-by: Joe Lawrence <joe.lawrence@redhat.com>
>>
>> Thanks Joe, as per the discussions on GitHub I think we're fine to use
>> this patch for a fix for stable (unless there's new issues found or
>> additional community feedback etc).
> 
> Hmm, I read the GitHub discussion as being that you were going to do
> another version, which is why I haven't picked this up. But I guess you
> and Christophe were talking about the non-minimal fix.
> 
> I know we want this to be minimal, but I think it should be checking
> that patch_instruction() isn't failing.
> 
> Incremental diff to do that is below. It boots OK, are you able to throw
> a livepatch test at it?
> 

No problem.  The incremental patch update tests successful.

Thanks,

-- 
Joe

