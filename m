Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6EE35F3E9
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 14:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350998AbhDNMge (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 08:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350988AbhDNMgc (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 08:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D899613C7;
        Wed, 14 Apr 2021 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618403770;
        bh=W8hZgGPrD8etDnaCxdxfCu2/xsJL8cgjruuafsxuso4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mEL5EqktkPiD9D+IQ3bPF25l7TsKspbjBedHpBtjTwHaH0gK/4rNJMqXOtc8rQWt1
         mxUi1M2Zhp1ocB3gL1l3AOPodPMbis89ZxE2b/HBrGg8FKLAgl1NW66kn42dYYpj5N
         HwnDMRrrAuQ8c3W8aSpbVp6XpU9Z6gi2ocZZ1zojXftgxZ6V0AV5XN7ppusjDOvRFA
         WZKvDJK+i060RwJ9E8Vu5kUryFPeXEn35OjJYqQaUUjZy24dfqO4/Vmq07XJNg4E5F
         M98PPRx5ufEg/EI8sz9nx9b+dvsjtOTtk27HIDlkuL5RubGzu9JZGDrVmfYlGM6xyO
         9LYOPnY2jkE3A==
Date:   Wed, 14 Apr 2021 13:35:48 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210414123548.GC4535@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <20210412173617.GE5379@sirena.org.uk>
 <d92ec07e-81e1-efb8-b417-d1d8a211ef7f@linux.microsoft.com>
 <20210413110255.GB5586@sirena.org.uk>
 <714e748c-bb79-aa9a-abb5-cf5e677e847b@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <714e748c-bb79-aa9a-abb5-cf5e677e847b@linux.microsoft.com>
X-Cookie: George Orwell was an optimist.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 14, 2021 at 05:23:38AM -0500, Madhavan T. Venkataraman wrote:
> On 4/13/21 6:02 AM, Mark Brown wrote:
> > On Mon, Apr 12, 2021 at 02:55:35PM -0500, Madhavan T. Venkataraman wrot=
e:

> >> 3. We are going to assume that the reliable unwinder is only for livep=
atch purposes
> >>    and will only be invoked on a task that is not currently running. T=
he task either
> >=20
> > The reliable unwinder can also be invoked on itself.

> I have not called out the self-directed case because I am assuming that t=
he reliable unwinder
> is only used for livepatch. So, AFAICT, this is applicable to the task th=
at performs the
> livepatch operation itself. In this case, there should be no unreliable f=
unctions on the
> self-directed stack trace (otherwise, livepatching would always fail).

Someone might've added a probe of some kind which upsets things so
there's a possibility things might fail.  Like you say there's no way a
system in such a state can succesfully apply a live patch but we might
still run into that situation.

> >> I suggest we do (3) first. Then, review the assembly functions to do (=
1). Then, review the
> >> remaining ones to see which ones must be blacklisted, if any.

> > I'm not clear what the concrete steps you're planning to do first are
> > there - your 3 seems like a statement of assumptions.  For flagging
> > functions I do think it'd be safer to default to assuming that all
> > SYM_CODE functions can't be unwound reliably rather than only explicitly
> > listing ones that cause problems.

> They are not assumptions. They are true statements. But I probably did no=
t do a good
> job of explaining. But Josh sent out a patch that updates the documentati=
on that
> explains what I said a lot better.

You say true statements, I say assumptions :)

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB24aQACgkQJNaLcl1U
h9BYGAf9GM7SFhyqwsiwsjyKKhLQaHG+b/LiSgJ0iKN6/7a/tRaC5WBnJVrk5dLG
WWC+hea0n3zdWT/kFu8AuBq0GHnVIZuMVav43Lu0VhBQxilRa1ySjLCgRbs+ePtj
4d31quaeFknkZVXXqsLE/42IozRJi9RFLWzPXUqUhkSELGi+Jl6zY8uYm1QonmMX
I+iE5E0T8dg9FwmfRUPVs48jYlk3pYpmWxDF0P/vWmVJC3ffF6/Lbr4VIOHCyBSk
rYBKmjZJZuNowGKoV8JHv4aLizk6Coq02br3534NMEUBIYOl9b9oFjkE0QvJOfor
8GiML6l1Qo5EHbfsZmRmIfWe0S6AZA==
=XOVC
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
