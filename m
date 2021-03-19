Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8403F341E0B
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 14:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCSNWg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 09:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhCSNWN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 09:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41AA864ED7;
        Fri, 19 Mar 2021 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616160132;
        bh=jfniUAsVtzfuj72roKz477ZitBRSmRDhansmEikSOJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnaMtEBDSKNHngHkxdL+DQk7GEzTqr2SekijiqFFJ8DxFf2O4HbDaVHaxRgITD/38
         uYFrn5bs+RchQil4wWmhwIIQZJ52gJjBj1B4ZUjBSNMh4UjpxyB9KCakCY/O5L8Umm
         YyVineHr3GTkFYVN8gvIDHP0aw3xNJCsHrzO/aosq/koIdypcRQBDh1vyRgJWG3VMu
         2Y0QF/8AbnLhLDaCZfj5235UTdRgu6miCBtAsZuS27DFUwxMUmEKqgEQFsIaJl2DRd
         Jkd4nzY2apanMcMSxXlcCAK3sNu4tGJuFtJSxjE8M3mgO0BCsQKV30f+FhwTz6Tj+b
         6gtfZN6S/816g==
Date:   Fri, 19 Mar 2021 13:22:08 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
Message-ID: <20210319132208.GD5619@sirena.org.uk>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-3-madvenka@linux.microsoft.com>
 <20210318174029.GM5469@sirena.org.uk>
 <6474b609-b624-f439-7bf7-61ce78ff7b83@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <6474b609-b624-f439-7bf7-61ce78ff7b83@linux.microsoft.com>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2021 at 05:22:49PM -0500, Madhavan T. Venkataraman wrote:
> On 3/18/21 12:40 PM, Mark Brown wrote:

> > Unless I'm misreading what's going on here this is more trying to set a
> > type for the stack as a whole than for a specific stack frame.  I'm also
> > finding this a bit confusing as the unwinder already tracks things it
> > calls frame types and it handles types that aren't covered here like
> > SDEI.  At the very least there's a naming issue here.

> Both these frames are on the task stack. So, it is not a stack type.

OTOH it's also not something that applies to every frame but only to the
base frame from each stack which I think was more where I was coming
=66rom there.  In any case, the issue is also that there's already another
thing that the unwinder calls a frame type so there's at least that
collision which needs to be resolved if nothing else.

> > Taking a step back though do we want to be tracking this via pt_regs?
> > It's reliant on us robustly finding the correct pt_regs and on having
> > the things that make the stack unreliable explicitly go in and set the
> > appropriate type.  That seems like it will be error prone, I'd been
> > expecting to do something more like using sections to filter code for
> > unreliable features based on the addresses of the functions we find on
> > the stack or similar.  This could still go wrong of course but there's
> > fewer moving pieces, and especially fewer moving pieces specific to
> > reliable stack trace.

> In that case, I suggest doing both. That is, check the type as well
> as specific functions. For instance, in the EL1 pt_regs, in addition
> to the above checks, check the PC against el1_sync(), el1_irq() and
> el1_error(). I have suggested this in the cover letter.

> If this is OK with you, we could do that. We want to make really sure that
> nothing goes wrong with detecting the exception frame.

=2E..

> If you dislike the frame type, I could remove it and just do the
> following checks:

> 	FP =3D=3D pt_regs->regs[29]
> 	PC =3D=3D pt_regs->pc
> 	and the address check against el1_*() functions

> and similar changes for EL0 as well.

> I still think that the frame type check makes it more robust.

Yeah, we know the entry points so they can serve the same role as
checking an explicitly written value.  It does mean one less operation
on exception entry, though I'm not sure that's that a big enough
overhead to actually worry about.  I don't have *super* strong opinons
against adding the explicitly written value other than it being one more
thing we don't otherwise use which we have to get right for reliable
stack trace, there's a greater risk of bitrot if it's not something that
we ever look at outside of the reliable stack trace code.

> >> EL1_FRAME
> >> 	EL1 exception frame.

> > We do trap into EL2 as well, the patch will track EL2 frames as EL1
> > frames.  Even if we can treat them the same the naming ought to be
> > clear.

> Are you referring to ARMv8.1 VHE extension where the kernel can run
> at EL2? Could you elaborate? I thought that EL2 was basically for
> Hypervisors.

KVM is the main case, yes - IIRC otherwise it's mainly error handlers
but I might be missing something.  We do recommend that the kernel is
started at EL2 where possible.

Actually now I look again it's just not adding anything on EL2 entries
at all, they use a separate set of macros which aren't updated - this
will only update things for EL0 and EL1 entries so my comment above
about this tracking EL2 as EL1 isn't accurate.

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBUpYAACgkQJNaLcl1U
h9BivQf/a5jp1i89RLN0okDV6V6vMs3m5jJpCysGDC4WB1f9kNO71EswgcPV3Sby
EoNcoGTyW0IezbxiAu6CiKS1i1nqZK4yfISSHrWES9AMYWTiIdm9Gg7EX3JmQy/0
rnVXSNuQrodPd+EfXekZszaKUZ+CrGTAXQ1R+FB2iHMBM+hJzc2+gJJlyr2ZxIya
BqNoZJxyo+0QwoRUD9IvCmBS7x05UCJM6BHJPgfVzB7XSRIhLix5/srwYnBaxSvY
A1HMlc33zNBNNzQ+0oH1oIY5f8Eyv+iSCtNxFkNmWjcACmR9eMqM3mYcD4A/Ruek
LeNu5rMwsjgJ5lOxVJT2TVjV6HSbxA==
=T8BD
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
