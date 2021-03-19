Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795C43421A7
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 17:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhCSQUp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 12:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhCSQUf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 12:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA1961963;
        Fri, 19 Mar 2021 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616170835;
        bh=/3yDPMaEcKpd8W4gwbQX3/MKYIK23/2GGJOXBc9ca6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UiAZbSqK+Bxr1V4JKWCRcMDpC9EXiJiVzDohtarl1yOzBYMluvTafxvoUuzxfozGz
         qiSxnaXHOeH7j+NOjPl2D5fk2aw4hcFaIxZufppY3u6i75Z1Jg3TnkSoyHzxbzPG7N
         J9OP+72SwCeidnjrK1TGvugoyI9JrXS2G6UY3vdP5uzjBOsJkg9TvpBShV8CXRcjgR
         8ZAkfDx9tRH3Rx+Q5JwXfUSND4eEVYX2cbGcZc7rAVctxxypdVTF+rSZxUZG8ImShH
         ZkoAcImlAdKrYrFhEUL4lbUKb8XGRgf3bJS0UX8/rDCnaxKAFnmBoTqWwlqgzE/j7I
         cgh1ABxfqvD3w==
Date:   Fri, 19 Mar 2021 16:20:31 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
Message-ID: <20210319162031.GG5619@sirena.org.uk>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-3-madvenka@linux.microsoft.com>
 <20210318174029.GM5469@sirena.org.uk>
 <6474b609-b624-f439-7bf7-61ce78ff7b83@linux.microsoft.com>
 <20210319132208.GD5619@sirena.org.uk>
 <e8d596c3-b1ec-77a6-f387-92ecd2ebfceb@linux.microsoft.com>
 <eb0def39-efcf-52ac-ce46-5982e8555dc1@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Content-Disposition: inline
In-Reply-To: <eb0def39-efcf-52ac-ce46-5982e8555dc1@linux.microsoft.com>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 19, 2021 at 10:02:52AM -0500, Madhavan T. Venkataraman wrote:
> On 3/19/21 9:40 AM, Madhavan T. Venkataraman wrote:

> > Actually now I look again it's just not adding anything on EL2 entries
> > at all, they use a separate set of macros which aren't updated - this
> > will only update things for EL0 and EL1 entries so my comment above
> > about this tracking EL2 as EL1 isn't accurate.

> So, do I need to do anything here?

Probably worth some note somewhere about other stack types existing and
how they end up being handled, in the changelog at least.

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBUz04ACgkQJNaLcl1U
h9Cpqgf8C+sEeXm1+QeQfV8ysaT8ehmWZISo2Rqniu/jWkA+2jAGl9fSxfG/mRkE
U8XPZHXjs5ZiTTmgqxeRomnDc1/qBu1jGFzLLByRYWBvPhIig8HAiU0JhKGJeOX0
mno39118bCEqxj9RU6Y9NbhsrrrZ2SLsMnDVenxGKMNTHI5Y84UKQNAqbLxGBlwB
0FKzqQFi4eXEYDPSJn/gD9dUAr3MyO10FN6oE4Ke4b/tvWorHmKREMki2gCzcvSZ
g+dUhHKPkHXb89VUapoHhaJIMnsjVeSNdHoVUVp1tZzsD53etKggdClvYtE01PSS
ZxKBbGQzMXd95U19spomNiYzX7aNUg==
=0+Tp
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
