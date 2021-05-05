Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D588A3746CB
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 19:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbhEER2I (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 May 2021 13:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238599AbhEERGL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 May 2021 13:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C36EB613F9;
        Wed,  5 May 2021 16:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620233245;
        bh=cQH1viTRhYXl+Jt1QORMEhZ6NgeUoG/3eUaMm1SfYc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MbYkLDraHvZ9Z15LwnUslfVHSDdfqboAaa5IKFnn6G9zp7sn1/r3gMcpBoxkMUS3j
         jfIF9dGUtff3yDR/xffYdjJN21RFD2UjqEXUYBnVFEm0CLDjPGVbNxfZysA6/nXNTf
         Shfy//0z2yLErdZqnoEREQp24XMNg/5v9sdO0wZ5HVep7Ze0384kVKada+cAFNUeGK
         7E/zM+bS3umqj7k/tSwOrUt7CUJEsBYecVvw57qIA8ra2kwLLemoI4CF0m6+BV58xl
         rfR9HcoQyemnFn8Ks8VIsUetEivSB6wxW3zeVi8n1YwthuWNWHbPJf9a83fmDuDktE
         wB6NpT1lFFqqg==
Date:   Wed, 5 May 2021 17:46:48 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
Message-ID: <20210505164648.GC4541@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <20210504160508.GC7094@sirena.org.uk>
 <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
 <0f72c4cb-25ef-ee23-49e4-986542be8673@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
In-Reply-To: <0f72c4cb-25ef-ee23-49e4-986542be8673@linux.microsoft.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 04, 2021 at 02:32:35PM -0500, Madhavan T. Venkataraman wrote:

> If you prefer, I could do something like this:
>=20
> check_pc:
> 	if (!__kernel_text_address(frame->pc))
> 		frame->reliable =3D false;
>=20
> 	range =3D lookup_range(frame->pc);
>=20
> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> 	if (tsk->ret_stack &&
> 		frame->pc =3D=3D (unsigned long)return_to_handler) {
> 		...
> 		frame->pc =3D ret_stack->ret;
> 		frame->pc =3D ptrauth_strip_insn_pac(frame->pc);
> 		goto check_pc;
> 	}
> #endif /* CONFIG_FUNCTION_GRAPH_TRACER */

> Is that acceptable?

I think that works even if it's hard to love the goto, might want some
defensiveness to ensure we can't somehow end up in an infinite loop with
a sufficiently badly formed stack.

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCSy/cACgkQJNaLcl1U
h9ABjAf/fEFuQnVM2PvVSSZ12g8EU3JD2pWnZUmAS5BwePbK0p37pAFxtY+RmvAQ
DwaiqGBi0F7QP8FToXUPDsds7X9jQy8+8yHMNbt878ScDIz5SKNuR29m2ADQ/cKr
OZD8Jv3poTDRDVUNequtEEqt4T+90tBlCN6ZKBlxH7wV2ArU3cUJ8Oa/vQyouyoc
VPzvPAZY1zupyPtDNPzK31AkkyWhhmOZJmckQuJ1p8KC5aKZCRcEvmPA5jX9QYvq
oesi89rEjZVhXphISnELRwpfcvJx/O203iRhTbuJ06nU/KxZLBXWAmj/vaXhggog
jAkfptyHcleFuFCNNsKFLCY3o/TQ6A==
=fJrE
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
