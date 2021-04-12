Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434BF35CF8C
	for <lists+live-patching@lfdr.de>; Mon, 12 Apr 2021 19:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbhDLRg4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Apr 2021 13:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238649AbhDLRgz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Apr 2021 13:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C7A61261;
        Mon, 12 Apr 2021 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618248997;
        bh=FOcBq5IiHKnDW5iAmHjvkIgTdRN/vg5ZmjJEZHBQ+sU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kJAkGDGqU2OmXTWeqLdQ3ZfMRrr4N/bxHFBU6oI7MOVFmqWF7DRm4JC2PP01Y6GIH
         kIBp0Jb2NZIhcL9SeNZHP5kGOZbXgxWdLpDjkATaQMJA1vhyR+Y3+MM+i0iPJTFFgM
         f7/vzgdmzqaCzRwXmguV1R5ofDZXUXhK7KWMlbN1pn37MdWNlO8Ow4U4DnEMdNzwxx
         Y8MZbvvFfMGlYK9hQU2AJKO1S2qHkR1yMPsqt+e5NYGjAGTotj1Cyr9YTnYEO8Hvu+
         sK4Sn+PMhRRky1mmm30/gGx2EhmSFFOpFCtHUpofGqQlK+dRiCrSadVnj4719IT5O/
         WZJV2SKKfN/tQ==
Date:   Mon, 12 Apr 2021 18:36:17 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, madvenka@linux.microsoft.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210412173617.GE5379@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
Content-Disposition: inline
In-Reply-To: <20210409213741.kqmwyajoppuqrkge@treble>
X-Cookie: Air is water with holes in it.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 09, 2021 at 04:37:41PM -0500, Josh Poimboeuf wrote:
> On Fri, Apr 09, 2021 at 01:09:09PM +0100, Mark Rutland wrote:

> > Further, I believe all the special cases are assembly functions, and
> > most of those are already in special sections to begin with. I reckon
> > it'd be simpler and more robust to reject unwinding based on the
> > section. If we need to unwind across specific functions in those
> > sections, we could opt-in with some metadata. So e.g. we could reject
> > all functions in ".entry.text", special casing the EL0 entry functions
> > if necessary.

> Couldn't this also end up being somewhat fragile?  Saying "certain
> sections are deemed unreliable" isn't necessarily obvious to somebody
> who doesn't already know about it, and it could be overlooked or
> forgotten over time.  And there's no way to enforce it stays that way.

Anything in this area is going to have some opportunity for fragility
and missed assumptions somewhere.  I do find the idea of using the
SYM_CODE annotations that we already have and use for other purposes to
flag code that we don't expect to be suitable for reliable unwinding
appealing from that point of view.  It's pretty clear at the points
where they're used that they're needed, even with a pretty surface level
review, and the bit actually pushing things into a section is going to
be in a single place where the macro is defined.  That seems relatively
robust as these things go, it seems no worse than our reliance on
SYM_FUNC to create BTI annotations.  Missing those causes oopses when we
try to branch to the function.

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB0hRAACgkQJNaLcl1U
h9DMHwf+KB+Zd6w5uaq7CyPt8R3d9OSaoTNTS4qTwkA67lnsewK8sU+vsvUuYqDU
BSH8HZGIW7X8I2GLwfZ16ByBDiOwp+kFszvgmZBUxqJE8UVHFXnkqpqOAclNvLYZ
c+SSwra2ySfLzZhTyeb6ZLbs5gsDkhLXHFM4K0QEMw8NGLnzXZu5u5EKWzmwwkkW
riHhGIj/5h4AInrIL4lt1A18Xl2OCwHje2FJtO5JUaooF7sZrL9p5xhwL9Po1BkL
hYg3DvD2gzF3T6dLos/HmVo+Rokc29DLFhMLjcMDrPtFB77svgVdp7vAHOCNpy15
LUx0nHMZo72C9P4fkDBM4jFqOP55VA==
=5gSu
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--
