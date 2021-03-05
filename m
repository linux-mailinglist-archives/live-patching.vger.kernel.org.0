Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4768232E564
	for <lists+live-patching@lfdr.de>; Fri,  5 Mar 2021 10:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhCEJzs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Mar 2021 04:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhCEJzV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Mar 2021 04:55:21 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B073C061574;
        Fri,  5 Mar 2021 01:55:21 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id a9so1314940qkn.13;
        Fri, 05 Mar 2021 01:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lRZq59jloSR0H3CstziAfSpbEkp52wDU2F/G5BYOIS0=;
        b=d6RUsFIexVOG1YsqT1TgIjOJjv9GvyIQqpf67Xl9NpS6xBW4w8ujuf2FWsBPliYByY
         o+ZirYLjsht7Fth7XxBUGBkExXSVS/DQdmmSmHqIK4BX6nQO3IdlzP+peO9kboVkTx0E
         qOeTnqBGCB4GsVE1vEbiCVPnus8vXtaU9H1C0Ea02BU3pKR6d5HTxGuq3kT7FvBBQT9D
         /XVoePP3t8kSQ/W2Cpu3kLjwaPVZSplx3W4Ov2y1vxYRwNQbmd3WuWLbJVYxk7smLBfb
         snYLIhoR82BFI+UBKybKzV3l8VJrUPVBlsHt+xWG6ZMoGdPRfXIf/IHRmDbvLNGvMKpu
         +SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=lRZq59jloSR0H3CstziAfSpbEkp52wDU2F/G5BYOIS0=;
        b=nMKs1OMUZY/fn0E36zhurCCIb2PIXpKd0QYpQAwrfSEPGdUaUizwJevjQN9574Oqmx
         3/lNDXB//VfL71CHZanqxXytg8TctpvnM5tHm1jmSwA5ZxTVgMY+cBJmFtAXb0rhVDVO
         WWs2W90QvOyH0bplDo5s+15ixkFMv4LSbRe9trpOvcXIQxXWDEwLHO3wpsJoXzhjRnOu
         LZ44GHCxtIGWe+BG7UwPw7/3FpWKQjXugk20qSxv8qVDPThUSklTf9GoGosElhph4zxb
         RLuoHKlXb9f83SUvYvWj5tu/ymbu6GZJhGnuiptXbePlBbH+atzgtCth1fPDNc5Rep3a
         P/qA==
X-Gm-Message-State: AOAM533ws1dhx+sYWRwRNHXdDNZdMFV7oYQ3wb43FeE70B6ml1A0P0M4
        9tRsU/V2KBjQmLc+kYZc0Po=
X-Google-Smtp-Source: ABdhPJwmaPf2wqrtZyzSz9LSRSntX3/RTjpfVnpDEuhVpmt/bXRwEAFUCz0phm672U7TWPoCBbmG9Q==
X-Received: by 2002:a37:a416:: with SMTP id n22mr8233273qke.259.1614938120544;
        Fri, 05 Mar 2021 01:55:20 -0800 (PST)
Received: from debian ([156.146.54.164])
        by smtp.gmail.com with ESMTPSA id e132sm1449102qkb.15.2021.03.05.01.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:55:20 -0800 (PST)
Date:   Fri, 5 Mar 2021 15:25:10 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] docs: livepatch: Fix a typo in the file shadow-vars.rst
Message-ID: <20210305095508.GA7689@debian>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Petr Mladek <pmladek@suse.com>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, live-patching@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
References: <20210305021720.21874-1-unixbhaskar@gmail.com>
 <YEHzevqbmZg8kZ+7@alley>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <YEHzevqbmZg8kZ+7@alley>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 10:01 Fri 05 Mar 2021, Petr Mladek wrote:
>On Fri 2021-03-05 07:47:20, Bhaskar Chowdhury wrote:
>>
>> s/ varibles/variables/
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
>It might make sense to move the "In" to the next line. It sticks out
>even more now.
>
>Eitherway:

Thanks, your wish will get fulfilled in V2 ...will send your way :)

~Bhaskar

>Reviewed-by: Petr Mladek <pmladek@suse.com>
>
>Best Regards,
>Petr

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBB//UACgkQsjqdtxFL
KRU21QgAmGy8p+LYb1CXU08y5uT/TpkD+DMETr2LpdmJ8YWV0wqRTJRODPDsnga1
ltAjt3wLvUdWlsXV0RyF6a2KdCV6hGAkMaqCqNmkbd3PGAEwc97p2aXuK6v5vrHE
NHcupELFl1hI8K8yeoNXtXBWIHwvhiQo7p8xQryAfWpX2MESXPs5HHPL3EjOHc90
exvKfGo0ZgBvEXHpka+5JAhWBhVnJ6thumUNLBi63CdFDEVAUCdOl50MW0v5ddcL
szjxI+Pz5ddBR5JNF26kE8jBpfwIuid3GlsDyoGz9nSQTKerPnKiYXZtf8x1gL42
kszv2tHjRL1vTyfg2X1sh7wsTkZmrg==
=nPla
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
