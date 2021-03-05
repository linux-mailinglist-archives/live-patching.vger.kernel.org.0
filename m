Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B0932EC50
	for <lists+live-patching@lfdr.de>; Fri,  5 Mar 2021 14:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhCENhu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Mar 2021 08:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhCENhd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Mar 2021 08:37:33 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A02FC061574;
        Fri,  5 Mar 2021 05:37:33 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id t1so949332qvj.8;
        Fri, 05 Mar 2021 05:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=LwsrFzohnzRe7vAxMPzw3U20E6cJaV+VWlq/m8eueqc=;
        b=XtHpCkSi4lp+srcQKkn60e9DPRnVH/TMXETrmyYdk2xveEN6YNHiC7Lf81aKMlIS7l
         Xxubmyh8bqJ4fR0UH8o8yiLZ3S8lo7zEC8vHNMBqJggTsLAaDpoQm8LmlPIVYQmaC74i
         2kUPj5igizpc3VXiwW+gUCWihwsZfwrOrC9SG0vu5IEyvY1KN+Il6KBcukT+Qq89cvoZ
         ickZDrqH/UNs4ItdV2RK5BhKyd+U0z2UfiA+YpprH2rQQGwmZHTjccFZgSkGTqS1oaVm
         vLWuEIP7w/kY6YUiwF07fZRzSDgMRVfhe98/w/X6de+XuotV2ADNLHHy6ev3vtnOAIuz
         nFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LwsrFzohnzRe7vAxMPzw3U20E6cJaV+VWlq/m8eueqc=;
        b=CzVmVEAvLV10MnQsFFY1WfUjsLv0U54rFCIfOAeas/h/oWYkYjEV9vftemzfjK7ZtZ
         7XbDuyhp8ujXCh1I3ZWW5n3XegzLsmKzrc1gWONsi1tYzeTE/po6FyyP4EwJucEn7sUx
         1b6M9RoNNMwZQglcSLOc0NfuFAhMzD5q1AiUFByucwdmmsIZ7m3AuYlbqe0f7lAJH9sk
         Ija9+ZFst8TZw9UhzgYldesfh3PELNYHvrK0H8kZBVMiAtUsElnmup1HVYYhk0SPyrdQ
         nL8yj93fRbmyj4sITy2tEZJMEJ11h9iQgmPFHdXmzEfQ/06ogd/sDjTKYzp1XH/R9i0n
         KhWQ==
X-Gm-Message-State: AOAM532NzUN+JPZVuCza/pW2BULwkHY5PgotD5m+XYMoIZ4iyiV65VHM
        69c6FvxIw5a97z0NDae0mZeFTw4HG32IesZ2
X-Google-Smtp-Source: ABdhPJzNdyZyRy5a6QwQBSrKoOcg39Xy9cLTipvlQaRsNtI323ZzQpQyn7UTlsD9RVrvydgaE/1N/w==
X-Received: by 2002:a05:6214:4b3:: with SMTP id w19mr9011696qvz.26.1614951452695;
        Fri, 05 Mar 2021 05:37:32 -0800 (PST)
Received: from Gentoo ([156.146.55.96])
        by smtp.gmail.com with ESMTPSA id q186sm1747376qka.56.2021.03.05.05.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:37:31 -0800 (PST)
Date:   Fri, 5 Mar 2021 19:07:21 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH V2] docs: livepatch: Fix a typo and remove the
 unnecessary gaps in a sentence
Message-ID: <YEI0EcR5G53IoYzb@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
References: <20210305100923.3731-1-unixbhaskar@gmail.com>
 <20210305125600.GM2723601@casper.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GVj6pdslL7ULm4+q"
Content-Disposition: inline
In-Reply-To: <20210305125600.GM2723601@casper.infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--GVj6pdslL7ULm4+q
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 12:56 Fri 05 Mar 2021, Matthew Wilcox wrote:
>On Fri, Mar 05, 2021 at 03:39:23PM +0530, Bhaskar Chowdhury wrote:
>> s/varibles/variables/
>>
>> ...and remove leading spaces from a sentence.
>
>What do you mean 'leading spaces'?  Separating two sentences with
>one space or two is a matter of personal style, and we do not attempt
>to enforce a particular style in the kernel.
>
The spaces before the "In" .. nor I am imposing anything , it was peter caught
and told me that it is hanging ..move it to the next line ..so I did. ..

>>  Sometimes it may not be convenient or possible to allocate shadow
>>  variables alongside their parent objects.  Or a livepatch fix may
>> -require shadow varibles to only a subset of parent object instances.  In
>> +require shadow variables to only a subset of parent object instances.
>
>wrong preposition, s/to/for/    ..where???

--GVj6pdslL7ULm4+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBCNBEACgkQsjqdtxFL
KRUFLwf/XUiahJFH73wCx6qfXmiUUfsDymNYIWhrHadm87kHCGHScYOuvpRJN+mP
deG6Z2zHXKf4rKHb3W+Pi9UHfTbYSjrglMa38szNPsd2DY1bCSibFO5PsHZOx3Hi
LahtF6tmHFVCUOGilUTO2K8HGwqBGO5ua3F5iOebeIcQLrnuXvpd9TRC4R91Y0kO
+U+wcQm9aHr8g1ztNsrEmM8JWPbPiW8I/qfxN5eHB8B4b2tv2pVvjsMrWyQr/rn7
jdqFofhO6zTy50eygKuzF3L/sGzCpxfBZmW4YtwlT1N7Z3+Eb2P1BWDz9Isi+Bio
19C9W3ocg0o2pRFiMQ073nIO+cShWg==
=n4rW
-----END PGP SIGNATURE-----

--GVj6pdslL7ULm4+q--
