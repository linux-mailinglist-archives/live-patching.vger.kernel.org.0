Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6CA348C61
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 10:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYJMY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Mar 2021 05:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhCYJLs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Mar 2021 05:11:48 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DE4C06175F;
        Thu, 25 Mar 2021 02:11:46 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id j7so1132380qtx.5;
        Thu, 25 Mar 2021 02:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=t3z/hxgoWLAQqM1wXkd9iVUgfneeCuSfJf4VH9I2W2k=;
        b=KGC+VctVIhSIXX+cwcptqh63o3Ku4hn/hHJT1I89wfbFi3SPOIiRdlhq70+LrwPbdc
         9oZAyq1iVLRwynhsMq2PVkhkyE0BnYIkNdhdhlYKGPFd5sgMO1ahG0KQjzlduR/ET26K
         T2gczJ6cK7AgwgewNi5m3WpUkvz5M4ZkrNxW9+1THX3Zr/yjUJjWx5+NK9s11diWmpwI
         TAvEdd8BY29jOrECSx7C+LkRgT/bNGrQGHLJtFWIFgQGcXjSDKYnVFTswelXKJpooEwX
         84LhLVfwWNuIP1wXNFfnFcufRgu58hqS41ezvVbsEKDVAKgKFBjZYNyMMrnwuppGmhDb
         QzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=t3z/hxgoWLAQqM1wXkd9iVUgfneeCuSfJf4VH9I2W2k=;
        b=A8Ig1vURBkZRdmQmsDaK6ebVIT9uRobOtPX9AmglGzt5lTi6JdhJ8iycVBcolGp1my
         n9GGECZn6lS1+WuyjjdaXnc8jr7KvSnkakVDfbfylSNy/Sdox+NyB2H+bOZiaCHvAA01
         JcCmK9YQ3alUyaDSWrFRNHsvaDeFOVroLPrIRHJx8QJDFLNcBbqOtI7L9/h4DEw4rEcf
         S1Dgl6+m8y5oD3NdmuOoi9aka6mOdZzkmxWGXk4cccCT8U9RF8hVSR72FVuYlWZPYx+n
         LUc++K0ETDLHFZLhE7F+6z3aCo7sYCU3EFEEE5kFhJ1Yaju0gP0g8q42BZH6d5U3SGbh
         NQug==
X-Gm-Message-State: AOAM530rocbiqZZr87hBoBepRHC01Ulx0vUuM5Ke2B5x+W3gScAd8ev7
        w0alBoYn8gvcn62a4JvHh9g=
X-Google-Smtp-Source: ABdhPJz4ZP6APn8BMvsoWvYlVGGrI4yMkHmZhkNcd39wrotMVGuaxdgyd1CdXFC0Ljo3+rrSGmXOXg==
X-Received: by 2002:ac8:4412:: with SMTP id j18mr6791793qtn.387.1616663505844;
        Thu, 25 Mar 2021 02:11:45 -0700 (PDT)
Received: from OpenSuse ([156.146.58.54])
        by smtp.gmail.com with ESMTPSA id z14sm3118079qti.87.2021.03.25.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:11:45 -0700 (PDT)
Date:   Thu, 25 Mar 2021 14:41:35 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] docs: livepatch: Fix a typo
Message-ID: <YFxTxxOkQDr2rb/J@OpenSuse>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        corbet@lwn.net, live-patching@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
References: <20210325065646.7467-1-unixbhaskar@gmail.com>
 <alpine.LSU.2.21.2103250956530.30447@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vJbGBnt7stF50BDq"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2103250956530.30447@pobox.suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--vJbGBnt7stF50BDq
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 10:05 Thu 25 Mar 2021, Miroslav Benes wrote:
>Hi,
>
>On Thu, 25 Mar 2021, Bhaskar Chowdhury wrote:
>
>>
>> s/varibles/variables/
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  Documentation/livepatch/shadow-vars.rst | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/livepatch/shadow-vars.rst b/Documentation/livepatch/shadow-vars.rst
>> index c05715aeafa4..8464866d18ba 100644
>> --- a/Documentation/livepatch/shadow-vars.rst
>> +++ b/Documentation/livepatch/shadow-vars.rst
>> @@ -165,7 +165,7 @@ In-flight parent objects
>>
>>  Sometimes it may not be convenient or possible to allocate shadow
>>  variables alongside their parent objects.  Or a livepatch fix may
>> -require shadow varibles to only a subset of parent object instances.  In
>> +require shadow variables to only a subset of parent object instances.  In
>>  these cases, the klp_shadow_get_or_alloc() call can be used to attach
>>  shadow variables to parents already in-flight.
>
>you sent the same fix a couple of weeks ago and Jon applied it.
>
Ah..difficult to remember....thanks for reminding ..it seems I need to keep
track ...which I don't do at this moment ...so the patch get duplicated ..

So.do you have any better policy to keep track???

>Miroslav

--vJbGBnt7stF50BDq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBcU7sACgkQsjqdtxFL
KRXpIQf/U2X4X8z8kzJAjGibPP2zSgFDF/PyvVHSP4mjmSzDqpUaCv+fgBDKnOg+
LQ3Gv/ZPUrgz8FctnCFF2Z5rCJQ2pqmNK2EkJUInxifeyp/y8pBJn/q8oz0ZarxH
IFWe52q3jdMgG8TUYJ2zky9ofX02ukuYWVtGFEgbinWEGocqr/5WU45nlWM3jTBt
AjiMHprZiuiUmE2VsqaE+z6lfpEvp1iLw+xmTBTcnOe45bowj3MopNZ89FASD7UL
d+9FSPhIMrlzAgqOwjSVkY6og33lYuhN0tFjHZd0rLl6feaLbRqDTCUXkR32+Dvr
KP0bsTKRAsy36KgPVLR/A3i6sJdgdA==
=ODuY
-----END PGP SIGNATURE-----

--vJbGBnt7stF50BDq--
