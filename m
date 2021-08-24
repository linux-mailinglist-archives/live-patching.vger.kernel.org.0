Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C583F6845
	for <lists+live-patching@lfdr.de>; Tue, 24 Aug 2021 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbhHXRmD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 13:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234752AbhHXRkC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 13:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62B63610D1;
        Tue, 24 Aug 2021 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629826757;
        bh=CsaaIJ0mqvMrW1cfcnujbBXiLpITKWy956POm5RpK0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdnT40ch9qUhQ04G6TGydGZux5oi5A6H95hLtQRnt4NfKYBrSrU4UkFmHI5yEWOYJ
         1j0trFQ7m6Z/qtlu+HFFip4VWp5VWik0kBId32P5h2u9W0xna7qaVzFyxVQAng8PNC
         cORxENimPGDsp+ugmywYIEseXrgiUcGtJAy3B3mzdRfOa7vww33zh1XsCbtAGye3Kk
         QFZrdXr/bkZca0hAkHt3d3IVuUKXFcD00zIkpDE8MmTLryXLydNpLt4Hgw0FM7Lkki
         jKsQOEIGXBwKKNpJuF1nLjoXhM0/uqM+FvyKchwhH1/PDg0XIwyR76VKr0aJbhPgtb
         p699nOhPxskAA==
Date:   Tue, 24 Aug 2021 18:38:50 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 1/4] arm64: Make all stack walking functions use
 arch_stack_walk()
Message-ID: <20210824173850.GN4393@sirena.org.uk>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-2-madvenka@linux.microsoft.com>
 <20210824131344.GE96738@C02TD0UTHF1T.local>
 <da2bb980-09c3-5a39-73cd-ca4de4c38d51@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iwjEIfU64POCkTAH"
Content-Disposition: inline
In-Reply-To: <da2bb980-09c3-5a39-73cd-ca4de4c38d51@linux.microsoft.com>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--iwjEIfU64POCkTAH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 24, 2021 at 12:21:28PM -0500, Madhavan T. Venkataraman wrote:
> On 8/24/21 8:13 AM, Mark Rutland wrote:
> > On Thu, Aug 12, 2021 at 02:06:00PM -0500, madvenka@linux.microsoft.com wrote:

> > Note that arch_stack_walk() depends on CONFIG_STACKTRACE (which is not in
> > defconfig), so we'll need to reorganise things such that it's always defined,
> > or factor out the core of that function and add a wrapper such that we
> > can always use it.

> I will include CONFIG_STACKTRACE in defconfig, if that is OK with you and
> Mark Brown.

That might be separately useful but it doesn't address the issue, if
something is optional we need to handle the case where that option is
disabled.  It'll need to be one of the two options Mark Rutland
mentioned above.

--iwjEIfU64POCkTAH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmElLqkACgkQJNaLcl1U
h9D52wf9HF8gVGgKIbvDXcRnQ3/hQSq3I/kE8tfA0mjUk6GSVSXBN0W3+3b0hnVZ
In5H7LYRDhD3vusvJhJlb9bE/6GdNxwnqX0UsRF/tBoeiRjJAW5aphWaw2d/d9E3
a0fDLhKwVKhjgEEVtpAtbm1Hhy3/yhysuuFiHCbl1LCMfgD/zTea3ksk6EbNOs+O
J1UEeSO/5rhwrAUQoIvUurkYvlEuqOgcvryIb36ibmyzdaGzPHV/8MMq4Z9qWKmt
JGQBuWfh+DV3HB7XJw0780vdjDfjlscqu51/b0SxXOjuU+nTJaMZ7YLXsLduYpcY
+DXmi8wIed6NkKwo+J/BKulZu1z45Q==
=FpFy
-----END PGP SIGNATURE-----

--iwjEIfU64POCkTAH--
