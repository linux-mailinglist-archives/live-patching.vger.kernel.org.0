Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7340B341CF1
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 13:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCSMa4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 08:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhCSMa2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 08:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C2E64E09;
        Fri, 19 Mar 2021 12:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616157027;
        bh=STuc4t7Ex+kxKPe6umFc1+qm6aDEDEQvBbxhw2YlGvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEqj7olBLe9tvO/HUo8ZkhlvM7YIVwA4mQbLGLJOYiN7bYkggTOI+iNfMK/gFmE1a
         A9itO1s+Z7s5DKzwKe9TNmdbwqmfy7oEhtohrurO/N5BPvx3toX+dGH9/8CIhIByPP
         4bz+Za+WCbyzcHVkPlO4lja5iNfkp0FpZ1l5KiGhfS2sgmvC2gz5MqOzs6yhzuVNWP
         +1nEv30LHt5BALndrYJHE4qOFPxHawirlyafcTNJZp6kjpnGllZLt01+7P1sS6iFe6
         cEGO3hL0pB82BBQPD6v3MM5jIBA9Ww6io3dQFU8jvheSp+cYTcPJvwGK9Q6gkhkCnq
         J2TaDnvcHlcnQ==
Date:   Fri, 19 Mar 2021 12:30:23 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] arm64: Implement stack trace termination
 record
Message-ID: <20210319123023.GC5619@sirena.org.uk>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-2-madvenka@linux.microsoft.com>
 <20210318150905.GL5469@sirena.org.uk>
 <8591e34a-c181-f3ff-e691-a6350225e5b4@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <8591e34a-c181-f3ff-e691-a6350225e5b4@linux.microsoft.com>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 18, 2021 at 03:26:13PM -0500, Madhavan T. Venkataraman wrote:
> On 3/18/21 10:09 AM, Mark Brown wrote:

> > If we are going to add the extra record there would probably be less
> > potential for confusion if we pointed it at some sensibly named dummy
> > function so anything or anyone that does see it on the stack doesn't get
> > confused by a NULL.

> I agree. I will think about this some more. If no other solution presents
> itself, I will add the dummy function.

After discussing this with Mark Rutland offlist he convinced me that so
long as we ensure the kernel doesn't print the NULL record we're
probably OK here, the effort setting the function pointer up correctly
in all circumstances (especially when we're not in the normal memory
map) is probably not worth it for the limited impact it's likely to have
to see the NULL pointer (probably mainly a person working with some
external debugger).  It should be noted in the changelog though, and/or
merged in with the relevant change to the unwinder.

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBUmV8ACgkQJNaLcl1U
h9ABJwgAgN92saU1Ljsz55wJhiKxyalqRT9vs3rxeTR2So6rrXGyFb8YKrZacIrG
tARHk3LFN8JU5kHE0iEHvLkqkmVxgGwxppsyKRSy9tL44fURVTS4ZA0+Flhm8wdf
yCqxgPwKgN4viY1sDH4HL1jOpa3AdK/x93O0qelxHYw4UZsruna6jmxVRle4gwj3
U2qv7muAQiTigUJluJ5KZLRzs4ca1c0bfldwvfM3ruTwmiE/sggqMC+3LWi0aPlc
PUMp0wqWkCkoqNXHS1qIiU/lp0ZhW+qdhBe0SrSsYHpAUSZw/iDb475VjlKRKdCD
DY84czq9IA2dQnZ1LQTL9TyU6bMRwg==
=ouYL
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
